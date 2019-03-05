---
title: "Un simple site en PHP avec Docker et Nginx"
description: ""
tags: [ "Docker", "PHP", "Nginx" ]
lastmod: "2019-02-25 20:27:54"
date: "2019-02-25 19:53:21"
categories:
    - "Console"
type: post
slug: "simple-site-php-avec-docker-nginx"
cover: "/media/2019/02/05b6053c41a2130afd6fc3b158bda4e6.png"
---

J'ai récemment revu l'organisation des containers Docker présents sur mon serveur et j'ai essayé d'utiliser le plus possible les images "officielles" des technos dont j'avais besoin. Ici, nous allons mettre en place un Nginx pour servir des pages statique (HTML et autres ressources) mais également en mesure de gérer du contenu PHP.

<!--more-->

## Objectif de l'infra

Le but est d'avoir un container avec Nginx pour servir du contenu statique et dynamique (PHP). Il faudra configurer Nginx pour rediriger les requêtes de ressources PHP vers un second container qui embarquera PHP-FPM (FastCGI Process Manager).

{{% alert info %}}<i class="fa fa-info-circle"></i> Je tiens à préciser que le Nginx que nous allons mettre en place sert le contenu en HTTP. Personnellement, j'utilise un reverse-proxy qui s'occupe de gérer HTTPS (_un article futur viendra peut-être pour expliquer comment faire_). Si vous comptez mettre en ligne votre site en utilisant Docker et la méthode ci-après, je vous recommande de modifier la configuration du Nginx pour **mettre en place HTTPS**.{{% /alert %}}

Nous aurons donc besoin de deux images Docker :

- [Nginx](https://hub.docker.com/_/nginx), j'ai choisi de prendre la version Alpine stable (1.14.2 à la date de cet article) ;
- [PHP-FPM](https://hub.docker.com/_/php), là encore avec Alpine et avec la dernière version disponible (7.3.2 à la date de cet article).

{{% gallery columns="2" %}}
{{< gallery_item src="/media/2019/02/ee434023cf89d7dfb21f63d64f0f9d74.png" >}}
{{< gallery_item src="/media/2019/02/e1bfd762321e409cee4ac0b6e841963c.png" >}}
{{% /gallery %}}

Par préférence personnelle, nous allons utiliser `docker-compose` pour configurer les containers ([Installer Docker Compose](https://docs.docker.com/compose/install/)).

## Le container Nginx

Tout d'abord, il nous faut créer l’arborescence de répertoire dont nous allons avoir besoin (je place tout ça dans `/docker`), ainsi que les fichiers de journalisation avec les privilèges adéquats :

{{< code lang="console" icon="code" title="Console" >}}
host:~# mkdir -p /docker/web-php/www                  # Webroot dans lequel sera stocké le contenu statique du site
host:~# mkdir -p /docker/web-php/log                  # Pour enregistrer les journaux de Nginx
host:~# touch /docker/web-php/log/{error,access}.log  # Journaux pour Nginx
host:~# chmod a+rw /docker/web-php/log/*              # Accessible en lecture/écriture pour tous (ce n'est pas l'idéal, si quelqu'un a une autre idée je suis preneur)
{{< /code >}}

Nous aurons également besoin du fichier de configuration de Nginx. Il remplacera celui par défaut présent dans le container Nginx et permettra de facilement modifier la configuration du serveur sans avoir en entrer dans le container.

{{< code lang="nginx" icon="file-text-o" title="/docker/web-php/nginx.conf" >}}
user                       nginx;
worker_processes           1;

error_log                  /var/log/nginx/error.log warn;
pid                        /var/run/nginx.pid;

events {
    worker_connections     1024;
}

http {
    include                /etc/nginx/mime.types;
    default_type           application/octet-stream;
    
    log_format             main  '$remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent" "$http_x_forwarded_for"';
    access_log             /var/log/nginx/access.log main;
    
    sendfile               on;
    keepalive_timeout      65;
    server_tokens          off;

    server {
        listen             80;
        server_name        localhost;
        
        location / {
            root           /usr/share/nginx/html;
            index          index.html index.htm;
        }
        
        error_page         500 502 503 504 /50x.html;
        location = /50x.html {
            root           /usr/share/nginx/html;
        }
    }
}
{{< /code >}}

On peut à présent configurer et démarrer le container Nginx :

- Le port TCP/80 (HTTP) est mappé sur l'hôte ;
- Le container est nommé `web-nginx` ;
- Le répertoire `/docker/web-php/www` est monté en lecture seule pour y stocker le contenu statique du site Web ;
- Le répertoire `/docker/web-php/log` est monté pour y stocker les journaux Nginx ;
- Le fichier `/docker/web-php/nginx.conf` est mappé en lecture seule sur le fichier de configuration Nginx du container.

{{< code lang="yaml" icon="file-text-o" title="docker-compose.yml" >}}
version: '3'

services:
    web-nginx:
        image: nginx:stable-alpine
        container_name: web-nginx
        volumes:
            - "/docker/web-php/www:/usr/share/nginx/html:ro"
            - "/docker/web-php/log:/var/log/nginx"
            - "/docker/web-php/nginx.conf:/etc/nginx/nginx.conf:ro"
        ports:
            - "80:80"
{{< /code >}}

{{< code lang="console" icon="code" title="Console" >}}
host:~# docker-compose up -d
{{< /code >}}

Le site est maintenant accessible sur le port TCP/80 de l'hôte. Cependant, si vous vous rendez à l'adresse http://localhost/ (éventuellement remplacer _localhost_ par l'adresse IP de votre serveur), vous obtiendrez une erreur **403 Forbidden** car notre répertoire `www` est vide. Pour simplement vérifier que tout fonctionne, il suffit de créer un fichier `index.html` :

{{< code lang="console" icon="code" title="Console" >}}
host:~# echo 'hello world!' > /docker/web-php/www/index.html
{{< /code >}}

{{< img src="/media/2019/02/fc35fdc70d5fc69d269883a822c7a53e.png" alt="index.php" link="/media/2019/02/fc35fdc70d5fc69d269883a822c7a53e.png" >}}

## Le container PHP

Ne perdons pas de vu l'objectif : disposer d'un environnement Web capable d’interpréter PHP pour servir du contenu dynamique. Pour cela, nous allons mettre en place un second container qui embarquera PHP.

Tout d'abord, il faut modifier le fichier de configuration de Nginx pour lui préciser de rediriger les requêtes de ressources PHP vers le container que nous venons de mettre en place. Nous ajoutons `index.php` dans la directive `index` du serveur, et les instructions `fastcgi` pour les fichiers PHP (i.e. les fichiers dont l'extension est **.php** : `location ~ \.php$`).

{{< code lang="nginx" icon="file-text-o" title="/docker/web-php/nginx.conf" >}}
user                       nginx;
worker_processes           1;

error_log                  /var/log/nginx/error.log warn;
pid                        /var/run/nginx.pid;

events {
    worker_connections     1024;
}

http {
    include                /etc/nginx/mime.types;
    default_type           application/octet-stream;
    
    log_format             main  '$remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent" "$http_x_forwarded_for"';
    access_log             /var/log/nginx/access.log main;
    
    sendfile               on;
    keepalive_timeout      65;
    server_tokens          off;

    server {
        listen             80;
        server_name        localhost;
        
        location / {
            root           /usr/share/nginx/html;
            index          index.php index.html index.htm;
        }
        
        error_page         500 502 503 504 /50x.html;
        location = /50x.html {
            root           /usr/share/nginx/html;
        }

        location ~ \.php$ {
            root           /usr/share/nginx/html;
            include        fastcgi_params;
            fastcgi_pass   web-php:9000;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME  /script$fastcgi_script_name;
        }
    }
}
{{< /code >}}

Nous aurons besoin également d'un fichier `index.php` afin de pouvoir tester que tout fonctionne une fois que le container sera en place.

{{< code lang="console" icon="code" title="Console" >}}
host:~# echo '<?php phpinfo();' > /docker/web-php/www/index.php
{{< /code >}}

On peut à présent configurer et démarrer le container PHP :

- Le container est nommé `web-php` ;
- Le répertoire `/docker/web-php/www` est monté en lecture seule pour y stocker les fichiers PHP.

{{< code lang="yaml" icon="file-text-o" title="docker-compose.yml" >}}
version: '3'

services:
    web-nginx:
        image: nginx:stable-alpine
        container_name: web-nginx
        volumes:
            - "/docker/web-php/www:/usr/share/nginx/html:ro"
            - "/docker/web-php/log:/var/log/nginx"
            - "/docker/web-php/nginx.conf:/etc/nginx/nginx.conf:ro"
        ports:
            - "80:80"

    web-php:
        image: php:fpm-alpine
        container_name: web-php
        volumes:
            - "/docker/web-php/www:/script:ro"
{{< /code >}}

{{< code lang="console" icon="code" title="Console" >}}
host:~# docker-compose up -d
{{< /code >}}

{{< img src="/media/2019/02/3be2a3b771431f2096ff984899869fa6.png" alt="index.php" link="/media/2019/02/3be2a3b771431f2096ff984899869fa6.png" >}}

---

#### Références

1. [PHP (Docker Official Images) - Docker Hub](https://hub.docker.com/_/php)
2. [Nginx (Docker Official Images) - Docker Hub](https://hub.docker.com/_/nginx)