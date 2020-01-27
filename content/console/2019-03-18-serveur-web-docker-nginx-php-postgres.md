---
title: "Serveur Web avec Docker : Nginx, PHP et PostgreSQL"
description: "Utiliser Docker pour mettre en place un serveur Web intégrant une base de données PostgreSQL, PHP-FPM et servi par Nginx."
tags: [ "Docker", "PHP", "Nginx", "PostgreSQL" ]
lastmod: 2019-04-10 20:20:49
date: "2019-03-18 20:21:54"
categories:
    - "Console"
type: post
slug: "serveur-web-docker-nginx-php-postgres"
cover: "/media/2019/03/bff132734906900fcbf309071ae72229.png"
---

Un serveur Web incluant généralement un **logiciel serveur** (_Nginx_), un **interpréteur de script CGI** (_PHP_) et d'un **système de gestion de base de données** (_PostgreSQL_), nous allons voir comment mettre en place ces trois composants en utilisant Docker.

<!-- more -->

{{< alert info github >}}Les fichiers nécessaires et le script de mise en place des containers sont disponibles sur [gist.github.com](https://gist.github.com/vonKrafft/18019dedb49eae01035489bbb9ff856c).{{< /alert >}}

{{< img-post alt="Serveur Web avec Docker : Nginx, PHP et PostgreSQL" path="/media/2019/03/" file="49abbcc5707255341cfebe39f9e2b1ce.png" >}}

## Nginx et PHP FPM

Récemment, j'expliquais comment simplement mettre en place un serveur **Nginx** qui supporte **PHP** à l'aide de Docker. L'image `php:fpm-alpine` utilisée y était minimaliste et n'embarquait que très peu d'extension PHP. De plus, aucune base de données n'était présente dans notre infra : c'est ce point là que nous allons corrigé ici.

{{< alert warning exclamation-circle >}}Il est recommandé d'avoir lu l'article [Un simple site en PHP avec Docker et Nginx](/console/simple-site-php-avec-docker-nginx) pour la suite, et d'avoir démarrer les containers Nginx et PHP.{{< /alert >}}

Pour rappel, nous avions créé l'arborescence suivante dans laquelle nous retrouvons le fichier de configuration `nginx.conf`, les journaux Nginx et le contenu du site Web dans `www` :

{{< highlight plaintext >}}
├── docker-compose.yml
└── docker-web
    ├── log
    │   ├── access.log
    │   └── error.log
    ├── nginx.conf
    └── www
        └── index.php
{{< /highlight >}}

{{< highlight yaml >}}
version: '3'

services:
    web-nginx:
        image: nginx:stable-alpine
        container_name: web-nginx
        volumes:
            - "./docker-web/www:/usr/share/nginx/html:ro"
            - "./docker-web/log:/var/log/nginx"
            - "./docker-web/nginx.conf:/etc/nginx/nginx.conf:ro"
        ports:
            - "127.0.0.1:80:80"

    web-php:
        image: php:fpm-alpine
        container_name: web-php
        volumes:
            - "./docker-web/www:/script:ro"
{{< /highlight >}}

{{< highlight nginx >}}
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
{{< /highlight >}}

Après avoir vérifié que nos deux containers `web-nginx` et `web-php` sont bien démarrés et que le serveur Nginx est accessible depuis un navigateur Web, nous allons modifier le fichier `index.php` pour qu'il se connecte à la base de données et affiche la version du <abbr title="Système de Gestion de Base de Données">SGBD</abbr>.

{{< highlight php >}}
<?php
$dbconn = pg_connect('host=web-pgsql port=5432 dbname=foobar user=foobar password=foobar')
    or die('Could not connect');
     
echo '<pre>' . var_export(pg_version($dbconn), true) . '</pre>';

pg_close($dbconn);
?>
{{< /highlight >}}

Si tous ce passe bien, vous devriez obtenir une erreur ... _wait, what?_

{{< img-post alt="Call to undefined function" path="/media/2019/03/" file="762a28c8146467077d7aefd4f33314ad.png" >}}

## Personnaliser l'image Docker de PHP

Le serveur nous indique qu'il y a une erreur : `Call to undefined function pg_connect()`. En effet, l'image Docker standard de PHP n'embarque que très peu de module. Il est précisé sur la page [DockerHub PHP](https://hub.docker.com/_/php) comment **ajouter des extensions PHP supplémentaires**. Nous allons donc créer notre propre image Docker de PHP pour y intégrer le client PostgreSQL.

Commençons par créer un fichier `Dockerfile` dans le répertoire `docker-web/.build-php` (vous pouvez le placer ailleurs). C'est dans ce fichiers que nous allons décrire comment construire l'image :

- Nous partons de l'image `php:fpm-alpine`
- Nous y ajoutons les paquets `postgresql-dev` afin de disposer des bibliothèques nécessaire aux extensions PHP PostgreSQL
- L'image `php:fpm-alpine` embarque des scripts pour faciliter l'ajout d'extension, nous les utilisons pour ajouter `pgsql` et `pdo_pgsql`.

{{< highlight dockerfile >}}
FROM php:fpm-alpine
RUN apk update && apk add --no-cache \
        postgresql-dev \
    && docker-php-ext-install -j$(nproc) pgsql \
    && docker-php-ext-install -j$(nproc) pdo_pgsql
{{< /highlight >}}

Il faut également modifier le fichier `docker-compose.yml` pour préciser que nous voulons utiliser notre image plutôt que `php:fpm-alpine`. Nous renseignons pour cela la directive `build` afin d'indiquer à Docker Compose **de construire l'image si nécessaire** (premier démarrage, modification du fichier `Dockerfile`, etc...), ou **d'utiliser la dernière image construite** si aucune modification n'a été opérée depuis le dernier build.

{{< highlight yaml >}}
web-php:
    build: ./docker-web/.build-php
    container_name: web-php
    volumes:
        - "./docker-web/www:/script:ro"
{{< /highlight >}}

{{< highlight terminal >}}
host:~# docker-compose up -d
{{< /highlight >}}

Si tous ce passe bien, vous devriez obtenir une erreur ... _wait, again?_

{{< img-post alt="Unable to connect to PostgreSQL server" path="/media/2019/03" file="25f80845da0b1c6c3de60d74036a6324.png" >}}

## Le container PostgreSQL

Évidement, il nous manque le container PostgreSQL, que nous avons déjà nommé ci-dessus dans le fichier `index.php` : **web-pgsql**.

{{< highlight terminal >}}
host:~# mkdir -p docker-web/data # Pour stocker le contenu de la base de données
{{< /highlight >}}

Pas besoin de faire compliqué ici, nous allons simplement utiliser l'image officielle et Docker Compose pour configurer et démarrer le container PostgreSQL :

- Le container est nommé `web-pgsql` ;
- Le répertoire `./docker-web/data` est monté pour y stocker le contenu de la base de données ;
- Les variables d'environnement suivantes sont définies :
    - **`POSTGRES_PASSWORD`**, cette variable définit le mot de passe de l'utilisateur `POSTGRES_USER` pour PostgreSQL ;
    - **`POSTGRES_USER`**, cette variable créera l'utilisateur `foobar`. S'il n'est pas spécifié, l'utilisateur par défaut de `postgres` sera utilisé ;
    - **`POSTGRES_DB`**, cette variable créera la base de données `foobar`. S'il n'est pas spécifié,la valeur de `POSTGRES_USER` sera utilisée.

{{< alert danger exclamation-circle >}}Pour les besoins de cet article, j'ai utilisé les identifiants `foobar:foobar` pour me connecter à la base de données. Pensez à remplacer les variable d'environnement par vos propres valeurs ;){{< /alert >}}

{{< highlight yaml >}}
version: '3'

services:
    web-nginx:
        image: nginx:stable-alpine
        container_name: web-nginx
        volumes:
            - "./docker-web/www:/usr/share/nginx/html:ro"
            - "./docker-web/log:/var/log/nginx"
            - "./docker-web/nginx.conf:/etc/nginx/nginx.conf:ro"
        ports:
            - "127.0.0.1:80:80"

    web-php:
        image: php:fpm-alpine
        container_name: web-php
        volumes:
            - "./docker-web/www:/script:ro"

    web-pgsql:
        image: postgres:alpine
        container_name: web-pgsql
        volumes:
            - "./docker-web/data:/var/lib/postgresql/data"
        environment:
            POSTGRES_USER: foobar
            POSTGRES_PASSWORD: foobar
            POSTGRES_DB: foobar
{{< /highlight >}}

{{< highlight terminal >}}
host:~# docker-compose up -d
{{< /highlight >}}

Si tous ce passe bien, vous devriez obtenir une erreur ... Ah non, pas cette fois-ci, maintenant que tout est en place la fonction [`pg_version()`](https://secure.php.net/manual/fr/function.pg-version.php) renvoie les infos des versions client/serveur de PostgreSQL.

{{< img-post alt="Tout fonctionne" path="/media/2019/03" file="5f46c66379b93cbc1ec1c6460be50af5.png" >}}

---

#### Références

1. [PHP (Docker Official Images) - Docker Hub](https://hub.docker.com/_/php)
2. [Nginx (Docker Official Images) - Docker Hub](https://hub.docker.com/_/nginx)
3. [PostgreSQL (Docker Official Images) - Docker Hub](https://hub.docker.com/_/postgres)

