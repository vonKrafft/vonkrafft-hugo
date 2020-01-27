---
title: "Une interface Web pour IRC avec Docker"
description: ""
tags: [ "Docker", "WeeChat", "Glowing Bear", "IRC", "Nginx" ]
lastmod: "2018-10-04 18:43:12"
date: "2018-10-04 18:43:12"
categories:
    - "Console"
type: post
slug: "interface-web-pour-irc-avec-docker"
cover: "/media/2018/10/43118e2d20e0480d62d73d6deba5ef8f.png"
---

IRC est un protocole de communication qui a récemment soufflé ses bougies pour son 30ème anniversaire. Apparu en août 1988 avec la [RFC 1459](https://tools.ietf.org/html/rfc1459), il est de moins en moins utilisé au profit d'outils plus polyvalents tels que Slack ou Discord. Mais les plus fervent utilisateurs d'IRC s'adaptent pour continuer d'utiliser le protocole historique ...

{{< img-link alt="IRC xkcd" path="/media/2018/10" file="65cbb229fe3468f903a2cb8eec16c8c7-1024x437.png" link="/media/2018/10/65cbb229fe3468f903a2cb8eec16c8c7.png" >}}

L'objectif que nous allons essayer d'atteindre est de faire tourner avec Docker l'application [Glowing Bear](https://github.com/glowing-bear/glowing-bear), une interface Web pour le client IRC WeeChat. Pour cela, nous utiliserons le **dépôt officiel de Nginx** et nous créerons une image pour WeeChat.

La première chose à faire est bien sûr d'installer [Docker](https://www.docker.com/). Je vais également utiliser dans cet article **Docker Compose**. Cela facilite la gestion des applications Docker lorsqu'on utilise de multiples conteneurs.

{{< alert success >}}Pour notre exemple, le site Web sera accessible à l'adresse [http://irc.docker.local/](http://irc.docker.local/).{{< /alert >}}

## Le conteneur WeeChat

Ce conteneur sera dédié au client IRC. Basé sur [Alpine](https://hub.docker.com/_/alpine/), il embarquera WeeChat avec un utilisateur dédié.

### Une image Docker pour WeeChat

Il n'existe pas de dépôt officiel pour WeeChat. Afin de ne pas dépendre d'une tierce personne sur Internet, nous allons créer une image Docker dans laquelle nous allons installer et configurer le client IRC. Pour créer une image Docker, il faut utiliser un fichier `Dockerfile` dans lequel nous précisons les opérations à réaliser pour construire l'image. Pour plus de détails, je vous laisse aller jeter un œil à la [documentation Dockerfile](https://docs.docker.com/engine/reference/builder/).

{{< gist vonKrafft bc74bd9c90c6bbe19f07729c42ffc0f4 "Dockerfile" >}}

1. Nous partons de l'image officielle d'[Alpine](https://hub.docker.com/_/alpine/) ;
2. Installation des paquets **weechat**, **python** et **bash**, puis suppression du cache ;
3. Changement de la valeur de la variable globale *LANG* pour `C.UTF8` (Préférences globales) ;
4. Changement de la valeur de la variable globale *HOME* pour `/weechat` ;
5. Création de l'utilisateur `weechat` avec l'uid *1000* et du groupe `weechat` avec le gid *1000* ;
6. Création d'un point de montage pour le répertoire `/weechat/.weechat` ;
7. Le répertoire de travail sera `/weechat` ;
8. Le compte utilisé pour exécuter le conteneur sera `weechat` ;
9. Le conteneur écoutera sur le port *9001* ;
10. Au lancement du conteneur, la commande `weechat` sera exécutée.

{{< alert "warning" exclamation-circle >}}J'ai défini l'uid et le gid du compte `weechat` à *1000*. La valeur de ces uid/gid importent peu pour notre images, à condition d'être supérieurs ou égaux à *1000*. Par la suite, nous allons créer un utilisateur sur l'hôte avec les mêmes uid/gid, donc assurez vous que ces valeurs sont disponibles sur l'hôte et changez-les si besoin.{{< /alert >}}

Ensuite, il nous suffit de construire notre image avec la commande `docker build` (attention de ne pas oublier le point à la fin de la commande) :

{{< highlight terminal >}}
debian:~$ docker build -t vonkrafft/weechat:latest .
Successfully built 226da8c3ad94
Successfully tagged vonkrafft/weechat:latest
debian:~$ docker image ls
REPOSITORY             TAG           IMAGE ID            SIZE
vonkrafft/weechat      latest        226da8c3ad94        54.3MB
{{< /highlight >}}

### Préparer l'hôte pour accueillir le conteneur

À ce stade, nous disposons d'une image Docker pour notre client IRC. Il nous faut à présent créer le conteneur WeeChat qui utilisera cette image. Pour cela, nous utiliserons Docker Compose. Tout d'abord, il nous faut un utilisateur non privilégié sur l'hôte pour faire tourner le conteneur.

{{< highlight terminal >}}
debian:~$ groupadd -g 1000 weechat 
debian:~$ useradd -u 1000 -M -p '*' -s /bin/false -g 1000 weechat
{{< /highlight >}}

Nous allons également avoir besoin d'un **répertoire de travail**. Pour ma part, j'aime bien avoir toutes les données relatives à Docker dans une répertoire `/docker`, mais libre à vous de stocker vos données où cela vous arrange. Dans notre répertoire de travail, nous allons stocker les fichiers de configuration et de journalisation de WeeChat.

{{< highlight terminal >}}
debian:~$ mkdir -p /docker/web-irc/weechat
debian:~$ chown 1000:1000 /docker/web-irc/weechat
{{< /highlight >}}

### Configurer et exécuter WeeChat

{{< highlight terminal >}}
debian:~$ ls -lh /docker/web-irc/
drwxr-xr-x 2 weechat weechat 4.0K Sep 29 11:29 weechat
debian:~$ docker run --rm -it -v "/docker/web-irc/weechat:/weechat/.weechat" vonkrafft/weechat:latest weechat
{{< /highlight >}}

Si tout fonctionne (notamment vis-à-vis des permissions sur les répertoires partagés), vous devriez avoir accès à l'IHM de WeeChat en ligne de commande. C'est la seule fois où vous aurez besoin d'accéder à WeeChat via le terminal.

{{< img-link alt="WeeChat en ligne de commande" path="/media/2018/10" file="fc416cc1729e3bfefc3b19a193c40c98-1024x401.png" link="/media/2018/10/fc416cc1729e3bfefc3b19a193c40c98.png" >}}

Cet accès temporaire à WeeChat en ligne de commande va nous permettre de configurer le relais de WeeChat via le port 9001. Si vous souhaitez plus de détail, je vous invite à regarder la documentation sur le protocole [WeeChat Relay](https://weechat.org/files/doc/devel/weechat_relay_protocol.en.html).

{{< highlight terminal >}}
/relay add weechat 9001
/set relay.network.password mon_super_mot_de_passe
/exit
{{< /highlight >}}

Lorsque nous quittons WeeChat, le terminal va se fermer automatiquement et le conteneur WeeChat va être détruit car nous avions lancé ce conteneur avec l'option `--rm` (Clean-up). Pas d’inquiétude, la configuration sera persistante dans le dossier `/docker/web-irc/weechat` (un `ls` peut vous aider à vous en convaincre).

## Le docker Nginx

Nous allons utiliser l'image officielle de [Nginx](https://hub.docker.com/_/nginx/), dans sa **version stable sur Alpine**. Le choix de la version est personnel, vous pouvez utiliser la version mainline ou bien vous baser sur Debian selon vos préférences.

### Les répertoires partagés

Dans notre répertoire de travail, nous allons stocker le contenu du site Web, les fichiers de journalisation du serveur Nginx, ainsi que notre fichier de configuration Nginx `default.conf`.

{{< highlight terminal >}}
debian:~$ cd /docker
debian:~$ mkdir -p web-irc/log
debian:~$ touch web-irc/log/access.log web-irc/log/error.log
debian:~$ chmod a+rw web-irc/log/*
{{< /highlight >}}

Les fichiers de journalisation doivent être accessibles en lecture et en écriture par le conteneur Nginx. Alors certes, un `a+rw` n'est pas très propre, mais c'est la meilleure solution que j'ai actuellement (n'hésitez pas à m'en suggérer d'autres).

{{< alert "info" info-circle >}}Il n'est pas nécessaire de monter un répertoire pour les fichiers de journalisation. Néanmoins, je trouve pratique de les avoir à disposition sur l'hôte et cela permet de ne pas les perdre si le conteneur est détruit.{{< /alert >}}

### Le fichier de configuration

Ensuite, il nous faut un fichier de configuration. Nous indiquons le port en écoute, le nom de domaine, le chemin des fichiers de journalisation et du code source. Il nous faut aussi préciser la redirection vers le relais WeeChat.

{{< gist vonKrafft bc74bd9c90c6bbe19f07729c42ffc0f4 "default.conf" >}}

{{< alert "info" info-circle >}}Dans la directive `proxy_pass`, j'ai renseigné l'URL du relais WeeChat. Dans mon cas, mon conteneur s'appelle **weechat** et Docker s'occupera de la résolution DNS pour cette URL. Si vous avez nommé votre conteneur différemment, il vous faudra reporter ce nom dans le fichier de configuration Nginx.{{< /alert >}}

### Le code source

Il nous faut à présent télécharger le code source de [Glowing Bear](https://github.com/glowing-bear/glowing-bear). Vous pouvez télécharger l'archive ZIP et la décompresser dans `/docker/web-irc/www`, ou alors utiliser Git pour cloner le dépôt (dans ce cas là, pensez à supprimer ou à restreindre l'accès au répertoire `.git`).

{{< highlight terminal >}}
debian:~$ git clone https://github.com/glowing-bear/glowing-bear.git /docker/web-irc/www
debian:~$ rm -r /docker/web-irc/www/.git
{{< /highlight >}}

## Finaliser les conteneurs

Maintenant que notre image WeeChat est prête, que nos répertoires partagés sont créés et configurés et que notre fichier de configuration Nginx est terminé, nous pouvons lancer les deux conteneurs qui nous permettront d'avoir une IHM Web pour notre client IRC. Nous pouvons donc rédiger le fichier `docker-compose.yml` qui nous permettra de gérer nos conteneurs. À noter que nous utiliserons l'option **tty** pour le conteneur WeeChat car le client IRC a besoin d'un terminal pour s’exécuter.

{{< gist vonKrafft bc74bd9c90c6bbe19f07729c42ffc0f4 "docker-compose.yml" >}}

Pour terminer, la commande `docker-compose up -d` va créer et lancer les conteneurs. Si tous se passe bien, vous devriez donc avoir deux conteneur en cours d'exécution et le conteneur Nginx devrait exposer le port TCP/80 vous permettant d'accéder à l'URL [http://irc.docker.local/](http://irc.docker.local/).

{{< alert "danger" exclamation-triangle >}}Attention !!! En l'état, le conteneur Nginx héberge votre serveur HTTP sur le port TCP/80, donc non chiffré. Je vous conseille fortement de mettre en place le HTTPS (surtout si votre site est exposé sur Internet). Par exemple, vous pouvez utiliser un proxy : [LetsEncrypt container to use with nginx as proxy](https://hub.docker.com/r/jrcs/letsencrypt-nginx-proxy-companion/).{{< /alert >}}

{{< img-link alt="Glowing Bear authentication form" path="/media/2018/10" file="db25bfb420b2f3d4d9df2ee1d7c91135-1024x339.png" link="/media/2018/10/db25bfb420b2f3d4d9df2ee1d7c91135.png" >}}

Et voilà, votre interface Web pour IRC est en place. Pour vous authentifier, utilisez l'adresse `irc.docker.local` (le hostname du serveur sur lequel le conteneur Nginx est lancé) avec le port `80` (ou 443 si vous avez mis en place le HTTPS) et le mot de passe défini plus haut (dans mon cas `mon_super_mot_de_passe`).

{{< img-link alt="Glowing Bear interface" path="/media/2018/10" file="34c898d3d2cc51387f3e9957abb6c529-1024x494.png" link="/media/2018/10/34c898d3d2cc51387f3e9957abb6c529.png" >}}

---

#### Sources

1. [Official build of Nginx](https://hub.docker.com/_/nginx/) (EN)
2. [Docker Documentation](https://docs.docker.com/) (EN)
3. [WeeChat Documentation](https://weechat.org/doc/) (EN, FR et autres)
4. [Monter une passerelle de communication IRC/WeeChat/Glowing Bear/Bitlbee](https://dan.lousqui.fr/monter-une-passerelle-de-communication-irc-weechat-glowing-bear-bitlbee-fr.html) (FR)
