---
title: "Exploiter un \".git\" accessible sur un site Web"
description: "Retour d\'expérience sur l\'exploitation d\'un répertoire \".git\" accessible à la racine d\'un site Web : code source, mots de passe SQL, etc."
tags: [ "Serveur", "Git", "Exploit", "Directory Listing", "Pentest" ]
lastmod: "2017-03-15 12:54:26"
date: "2017-03-15 12:43:46"
categories:
    - "Console"
type: post
slug: "repertoire-git-accessible"
cover: "/media/2017/03/a22eaab5c6227da7b38ffb1db7ba6ccd.png"
---

Récemment, je suis intervenu sur un serveur web qui s’était fait compromettre. J’ai donc cherché à savoir quelle avait été la porte d’entrée sur le serveur. C’était assez folklorique : *chmod 777* sur le webroot, une flopée de SQLi, des webshell à la pelle, des configs *Apache* et *MySQL* très laxistes et surtout un répertoire `.git` avec du directory listing …

<!--more-->

Depuis, les problèmes sont résolus et je voulais vous partager l’exploitation du `.git` que j’ai trouvé assez sympa. Pour des questions de confidentialité, nous appellerons ce site « champions.fr » (parce qu’à ce niveau-là, ce sont vraiment de grands champions pour avoir un site comme celui-là en production avec une tétrachiée de données clients).

## Let’s begin !

Tout d'abord, j'ai accès à la page suivante : [http://champions.fr/.git/](http://champions.fr/.git/). Comme je l’ai dit plus haut, j’ai du directory listing. L’exploitation d’un git peut se faire sans directory listing mais c’est plus facile lorsque l'on peut lister le contenu des répertoires car aucun outil ou script particulier n'est nécessaire. Sans directory listing, il nous faudra utiliser un script tel que [DVCS Pillage Toolkit](https://github.com/evilpacket/DVCS-Pillage).

{{< img src="/media/2017/03/733aa40510c54d3875c3989cd65fe2e1-1024x468.png" alt="Directory listing du .git" link="/media/2017/03/733aa40510c54d3875c3989cd65fe2e1.png" >}}

Pour « cloner » le dépôt en local, il me suffit de télécharger récursivement tous les fichiers du répertoire git :

{{< code lang="console" icon="code" title="Console" >}}
root:~# wget -r http://champions.fr/.git/
root:~# cd champions.fr
root:~/champion.fr(git:stable_prod)#
{{< /code >}}

## Restaurer avec git

Je me retrouve avec un dépôt git en local. Cependant, j'ai seulement récupéré le répertoire `.git`, et donc lorsque je fais un `git status`, cela m'informe que tous les fichiers ont été supprimés ! Qu’à cela ne tienne, Git permet de restaurer l'état du dernier commit. Pour cela, nous utiliserons la commande `git reset`.

{{< code lang="console" icon="code" title="Console" >}}
root:~/champion.fr(git:stable_prod)# git reset --hard
{{< /code >}}

{{< img src="/media/2017/03/0a95e43f86e9262e800fea6b27b3d11f.png" alt="Directory listing du .git" link="/media/2017/03/0a95e43f86e9262e800fea6b27b3d11f.png" >}}

Bon, on ne parlera pas des webshells qui ont été versionnés, des dumps de base de données ou bien encore du « .bash_history » ni de « .ssh » (oui, c’est vraiment dégueulasse comme site …)

## Rechercher un fichier particulier

Ce qui nous intéresse (en plus du code source naturellement), c’est de savoir que c’est un WordPress. Les informations que nous voulons (ie. les mots de passe de la base de données), sont dans « wp-config.php ». Damned, le fichier n’existe pas ! En réalité, le fichier a été déplacé dans le répertoire parent (incroyable, il y a tout de même des notions de sécu chez les admins sys !). Mais là encore ce n’est pas grave, car nous avons le répertoire `.git` et donc il y a une chance que ce fichier ait été versionné. Pour restaurer le fichier `wp-config.php`, il faut remonter au dernier commit qui le concerne (ie le commit qui marque sa suppression).

{{< code lang="console" icon="code" title="Console" >}}
root:~/champion.fr(git:stable_prod)# git checkout $(git rev-list -n 1 HEAD -- wp-config.php)^ -- wp-config.php
{{< /code >}}

{{< img src="/media/2017/03/905262a4583b7b31dfa7ffab7aa80a5a.png" alt="Directory listing du .git" link="/media/2017/03/905262a4583b7b31dfa7ffab7aa80a5a.png" >}}

Non seulement on a le mot de passe MySQL sur un serveur de dev (pour root), mais aussi celui de la production. Ces comptes et mots de passe peuvent aussi êtres utilisés pour d'autres services, comme par exemple d'authentification Web ou bien la connexion SSH (qui sait ?).

Bon, le plus important ici, c’est le code source de du site que nous avons obtenu. Puisque c’est un WordPress, nous pouvons savoir quelle est la version utilisée, ainsi que la liste des plugins présents. Et bien sûr, nous avons accès au code du thème. Ici, c’est un thème « maison » assez lourds avec plein de requêtes SQL construites avec des concaténations bien sales d’inputs non filtrés. Mais c’est un cas particulier, vous aurez sans doute des choses un peu moins fun lors de vos expériences personnelles de tests d'intrusion (quoique …).