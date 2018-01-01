---
title: "Activer HTTP2 avec Nginx sous Debian"
description: "Les standards de HTTP/2.0 ont été publiée par l\'IETF en mai 2015. Pourquoi alors ne pas activer HTTP2 sur son propre serveur ?"
tags: [ "Nginx", "HTTP", "HTTP2", "Serveur", "SSL", "HTTPS" ]
lastmod: "2016-05-11 21:01:10"
date: "2016-05-10 16:46:15"
categories:
    - "Console"
type: post
slug: "activer-http2-nginx-debian"
cover: "/media/2016/05/12df53fea8b3adfa6c2ec456dd22e204.jpg"
---

Cela fait maintenant 20 ans que le protocole HTTP (HyperText Transfer Protocol) a été inventé, et depuis les versions HTTP/1.0 en [mai 1996](https://www.ietf.org/rfc/rfc1945.txt) et HTTP/1.1 en [janvier 1997](https://www.ietf.org/rfc/rfc2068.txt) il n'a plus évolué. Afin de pallier les limitations de HTTP, Google a mené ses propres travaux, dévoilant SPDY en 2012 qui visait essentiellement à réduire le temps de chargement des pages web en ajoutant la notion de priorité des contenus et le multiplexage des transferts au sein d'une seule connexion TCP. Ces travaux ont inspiré l'IETF qui a repris cette approche afin de publier les caractéristiques de HTTP/2.0 (écrit aussi HTTP2). Les RFC7540 et RFC7541 qui définissent les standards de HTTP2 ainsi que la compression HPACK des en-têtes HTTP2 ont été publiée par l'IETF en mai 2015. Pourquoi alors ne pas activer HTTP2 sur son propre serveur ?

<!--more-->

{{% alert "info" %}}<i class="fa fa-info-circle"></i> Le tutoriel suivant est conçu pour Debian, ou tout autre distribution qui s'en inspire. Pour les autres distributions Linux, les commandes nécessitent d'être adaptée, notamment le gestionnaire de paquets.{{% /alert %}}

## Activer HTTP2 avec nginx

Tout d'abord, il va faloir s'octroyer les droits administrateur. Si ce n'est pas possible ou si vous avez peur de faire une fausse manipulation, préfixez les commandes par `sudo` dans la suite du tutoriel, sinon exécutez la commande `sudo -s` et saisissez votre mot de passe lorsque demandé.

### Mise à jour du serveur

Comme je vous l'ai déjà précisé, les standards de HTTP2 ont été publié en mai 2015. Rapidement, les serveur les plus utilisés ont intégré le support du protocole dans leur version beta, comme ce dut le cas avec Nginx depuis la version 1.9.5. Or la version stable de Nginx était la 1.8.1, donc cela imposait d'ajouter la version mainline du serveur dans les dépôts Linux, ce que je pensais vous expliquer lorsque j'ai débuter la rédaction de ce tutoriel. Mais depuis le 26 avril 2016, Nginx est disponible en version stable 1.10.0 qui comporte toutes les fonctionnalités des version mainline 1.9.x, dont le support de HTTP2.

Pour commencé, nous allons donc vérifier la version de Nginx et si besoin nous allons le mettre à jour.

{{< code lang="console" icon="code" title="Console" >}}
root:~# nginx -v
nginx version: nginx/1.9.13
root:~# apt-get update
root:~# apt-get dist-upgrade
root:~# nginx -v
nginx version: nginx/1.10.0
{{< /code >}}

{{% alert "info" %}}<i class="fa fa-info-circle"></i> Vous pouver aussi simplement l'installer avec `apt-get install nginx`, sans oublier de lancer `apt-get update` avant.{{% /alert %}}

Bon aller, tant que j'y suis, je vais vous dire comment installer la version mainline.

{{% alert "warning" %}}<i class="fa fa-question-circle"></i> Mais tu viens de nous dire que la version 1.10.0 était disponible, stable, et supportait HTTP2 ... ?{{% /alert %}}

Oui mais ... J'ai préciser au début du tutoriel que la distribution utilisée est Debian, et tout le monde connait la rapidité légendaire de mise à jour des dépôts Debian. Donc à moins d'attendre que les dépôts soient mis à jour pour Nginx, ce qui peut prendre du temps, nous allons installer la version mainline. Et puis cela vous permettra de bénéficier des dernières fonctionnalités du serveur.

{{< code lang="console" icon="code" title="Console" >}}
root:~# curl http://nginx.org/keys/nginx_signing.key | apt-key add -
root:~# echo -e "deb http://nginx.org/packages/mainline/debian/ `lsb_release -cs` nginx\ndeb-src http://nginx.org/packages/mainline/debian/ `lsb_release -cs` nginx" &gt; /etc/apt/sources.list.d/nginx.list
root:~# apt-get update
root:~# apt-get dist-upgrade
{{< /code >}}

### Activer HTTPS

La nouvelle version du protocole préconise l'utilisation de TLS, dont la version minimum requise est imposée pour HTTPS/2 : TLS version 1.2 ou supérieure (RFC7540 Section 9.2). Nous allons donc configurer le serveur pour utiliser HTTPS. Si vous aviez déjà configurer la gestion de HTTPS pour votre serveur, vous pouvez passer cette section.

Tout d'abord, nous allons créer le répertoire qui contiendra les certificats SSL. J'ai choisi de le mettre avec le répertoire de configuration de Nginx (dans `/etc/nginx`), mais vous pouvez le mettre ailleurs.

{{< code lang="console" icon="code" title="Console" >}}
root:~# mkdir /etc/nginx/ssl
{{< /code >}}

Ensuite, nous allons créer un certificat auto-signé ainsi qu'une clé pour signer ce certificat. Si vous disposé déjà d'un certificat, copiez-le dans le répertoire que nous venons de créer. J'en profite aussi pour générer un fichier de configuration pour les paramètres de Diffie-Hellman.

{{< code lang="console" icon="code" title="Console" >}}
root:~# openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt
root:~# openssl dhparam -out /etc/nginx/ssl/dhparam.pem 4096
{{< /code >}}

### Configurer Nginx

Le serveur est à jour, nous avons notre certificat ... il ne nous reste plus qu'à activer HTTP2 et HTTPS. Ci-dessous, je vous met un extrait du fichier de configuration (dans mon cas, et par défaut, c'est le fichier `/etc/nginx/conf.d/default.conf`).

{{< code lang="plaintext" icon="file-text-o" title="/etc/nginx/conf.d/default.conf" >}}
server {
    # Activer HTTP2 et SSL
    listen 443 ssl http2 default deferred;
    # Configuration SSL
    ssl on;
    ssl_certificate /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;
    # Pour améliorer les performances
    ssl_session_cache shared:SSL:50m;
    ssl_session_timeout 5m;
    # Notre fichier de peramètres de Diffie-Hellman
    ssl_dhparam /etc/nginx/ssl/dhparam.pem;
    # SSL n'est plus un protocol sûr, et je vous recommande la dernière version de TLS
    ssl_protocols TLSv1.2;
}
# redirect all http traffic to https
server {
    listen 80;
    server_name localhost;
    return 301 https://$host$request_uri;
}
{{< /code >}}

Bien sûr, ces paramètres sont à rajouter ou à modifier dans le fichier de configuration et ils ne se suffisent pas à eux-même. Pour sécuriser votre serveur Nginx, je vous invite à jeter un coup d’œil à ce projet, qui donne des [recommendations pour améliorer la sécurité de Nginx](https://gist.github.com/plentz/6737338).

{{% alert "info" %}}<i class="fa fa-info-circle"></i> Ne pas oublier de redémarrer le serveur avec la commande `service nginx restart`{{% /alert %}}

{{% gallery columns="2" %}}
{{< gallery_item src="/media/2016/05/12df53fea8b3adfa6c2ec456dd22e204-300x186.jpg" link="/media/2016/05/12df53fea8b3adfa6c2ec456dd22e204.jpg" height="150px;" >}}
{{< gallery_item src="/media/2016/05/ee434023cf89d7dfb21f63d64f0f9d74-150x150.png" link="/media/2016/05/ee434023cf89d7dfb21f63d64f0f9d74.png" height="150px;" >}}
{{% /gallery %}}

## Conclusion

Et voilà, vous avez un serveur Nginx à jour avec HTTP2 et SSL. Vous pouvez vous y rendre à l'adresse [https://localhost/](https://localhost/). Avant de se quitter, je vous propose les commandes suivante pour compiler Nginx depuis les sources, utile notamment pour l'installer sur un Raspberry Pi avec Raspbian (source [https://hanshell.com/](https://hanshell.com/2_compile_nginx_on_raspberry_pi.html)).

{{< code lang="console" icon="code" title="Console" >}}
wandrille:~$ sudo apt-get install libpcre3-dev libssl-dev debhelper libxml2-dev libxslt-dev libgd2-xpm-dev libgeoip-dev libperl-dev
wandrille:~$ apt-get source nginx
wandrille:~$ cd nginx-1.9.13/
wandrille:~$ time dpkg-buildpackage -uc -b
wandrille:~$ cd ..
wandrille:~$ sudo dpkg -i nginx_1.9.13-1~jessie_armhf.deb
wandrille:~$ sudo dpkg -i nginx-module-geoip_1.9.13-1~jessie_armhf.deb
wandrille:~$ sudo service nginx restart
wandrille:~$ nginx -v
{{< /code >}}