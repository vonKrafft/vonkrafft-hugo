---
title: "Donner un nom DNS à son serveur local"
description: "Renommer son serveur personnel sur un réseau local en utilisant les IP fixes et les DNS locaux de vos différents équipements réseaux."
tags: [ "VPS", "Admin Système", "IP", "Host", "DHCP", "DNS" ]
lastmod: "2016-05-11 21:02:27"
date: "2015-12-12 10:22:06"
categories:
    - "Console"
type: post
slug: "donner-nom-dns-a-serveur-local"
cover: "/media/2015/12/5bb38ba3a8ec3b4d0c26c73c31d0cd58.jpg"
---

Sur le réseaux, les machines sont identifiés par une adresse IP et/ou un nom DNS (et pas que, mais ce n’est pas le propos de ce tutoriel). Une adresse IP (de l’anglais Internet Protocol) est comme une adresse postale mais appliquée au domaine de l’informatique.

<!--more-->

Il en existe deux versions :

- IPv4 (version 4) crée en 1981 est le format le plus utilisé. Cela permet d’écrire les adresses sur 32 bits, soit en théorie 4 294 967 296 adresses possibles. Mais nous avons dans le monde plus d’équipements relié à internet qu’il n’y a d’adresses IPv4.
- IPv6 (version 6) crée en 1998 est censé remplacer IPv4. Cela permet d’écrire les adresses sur 128 bits, soit en théorie 3,4×10^38 adresses possibles.

Pour palier au manque d’adresses IPv4, nous utilisons ce que nous appelons les plages d’IP privées. Ainsi, vous possédez une IP publique attribuée par votre FAI (Fournisseur d'Accès Internet) et de plusieurs IP privées. Ces IP privées sont la plupart du temps de la forme 192.168.X.X, qui est une des plages d’IPv4 privées (utilisée par toutes des box Internet des FAI français par défaut), soit en théorie 35 536 adresses possibles. Ces adresses privées sont locales, c’est à dire que vous ne pourrez pas accéder à votre PC depuis l’extérieur en utilisant son IP privée. Mais nous ne cherchons pas à accéder à notre PC depuis l’extérieur …

| Préfixe        | Plage IP privée               | Nombre d'adresses  |
| -------------- | ----------------------------- | ------------------ |
| 10.0.0.0/8     | 10.0.0.0 – 10.255.255.255     | 232-8 = 16 777 216 |
| 172.16.0.0/12  | 172.16.0.0 – 172.31.255.255   | 232-12 = 1 048 576 |
| 192.168.0.0/16 | 192.168.0.0 – 192.168.255.255 | 232-16 = 65 536    |

Donc, après cette rapide présentation des adresses IP, il est temps de s’attaquer au tutoriel.

## Mais pourquoi renommer son serveur ?

Si vous avez un serveur local (pour diverses raisons), vous pouvez y accéder avec une machine client grâce à son adresse IP, comme par exemple http://192.168.1.20 (c'est aussi le cas pour tous les ordinateurs connecter à votre réseau local et hébergeant un serveur HTTP).

{{< alert "danger" exclamation-circle >}}Non mais attend, tu viens de nous dire que nous ne pouvions pas accéder à notre PC en utilisant son IP privée ?!?{{< /alert >}}

Oui, mais cela est vrai uniquement depuis l’extérieur, c’est-à-dire depuis une machine client qui se trouve au delà de notre box Internet. Mais nous supposons que notre serveur et notre client sont sur le même réseaux privé.

{{< img src="/media/2015/12/91e02cd2b8621d0c05197f645668c5c4.png" title="Par défaut, un client extérieur ne peut pas accéder aux équipements de votre réseau local" link="/media/2015/12/91e02cd2b8621d0c05197f645668c5c4.png" >}}

Donc, vous pouvez accéder à votre serveur (en HTTP, FTP, SSH … en fonction des services installés sur votre serveur) avec on adresse IP. Mais les adresses IP sont allouées dynamiquement, c’est-à-dire que l’adresse de votre serveur peut changer. Nous allons donc faire deux choses :

- Configurer le serveur pour lui donner une adresse IP fixe
- Indiquer à notre (nos) client(s) que notre serveur a un nom

## Une IP fixe

Nous allons configurer notre interface réseau. Pour moi, il s’agit de eth0 (connexion physique n°0), mais cela peut être différent pour vous : eth1 (si vous avez plusieurs cartes réseau), wlan0 (si vous êtes connecté en wifi), ou autre …

{{< alert "info" info-circle >}}Le serveur `vps-001` est un serveur Debian. Pour les autres distributions Linux, opu pour un serveur Windows, il sera necessaire d'adapter certaines commandes et/ou chemins de fichiers.{{< /alert >}}

Le fichier de configuration est le suivant : /etc/networks/interfaces. Par défaut, notre serveur (comme n’importe quel équipement réseau) demande une adresse IP à notre box Internet :

{{< code lang="plaintext" icon="file-text-o" title="/etc/networks/interfaces" >}}
iface eth0 inet dhcp
{{< /code >}}

Nous allons donc modifier cette ligne pour lui dire quelle adresse IP utiliser :

{{< code lang="plaintext" icon="file-text-o" title="/etc/networks/interfaces" >}}
iface eth0 inet static
    address 192.168.1.100
    netmask 255.255.255.0
    gateway 192.168.1.254
{{< /code >}}

Pour connaître l’adresse IP de votre gateway, utilisez la commande trace :

{{< code lang="console" icon="code" title="Console" >}}
vonkrafft@vps-001:~$ sudo route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         192.168.1.254   0.0.0.0         UG    0      0      0   eth0
169.254.0.0     0.0.0.0         255.255.0.0     U     1000   0      0   eth0
192.168.1.0     0.0.0.0         255.255.255.0   U     0      0      0   eth0
{{< /code >}}

L’adresse de votre gateway est celle repérée par le flag UG. Pour moi il s’agit de 192.168.1.254. Pour appliquer les changements, nous redémarrons le réseau :

{{< code lang="console" icon="code" title="Console" >}}
vonkrafft@vps-001:~$ sudo service networking restart
{{< /code >}}

{{< alert "info" info-circle >}}Il est aussi possible d'attribuer une adresse IP fixe en utilisant votre box Internet. Mais toutes les box des FAI français ne proposent pas cette options.{{< /alert >}}

## Un nom DNS pour votre serveur

Lorsque vous naviguez sur le web, vous ne vous amusez surement pas à saisir l’adresse IP du serveur hébergant votre site web. Non ? Vous saisissez son URL (par exemple `google.com`). Derrière ce nom, il y a un service appelé DNS (de l’anglais Domain Name Service) qui s’occupe de traduire le nom du site en adresse IP. Tout comme les pages blanches font la correspondance entre un nom et un numéro de téléphone, un DNS fait la correspondance entre un nom de domaine et une adresse IP.

Il existe de nombreux serveurs DNS dans le monde, mais ils ne nous intéressent pas ici car nous allons utiliser notre DNS local.

{{< alert "warning" question-circle >}}Un DNS local ? Où ça ?{{< /alert >}}

Tous les PC possède un DNS local qui est consulté avant de demander aux autres DNS de traduire un nom. Nous allons donc renseigner notre nom dans le DNS de notre machine client, qui n’est autre qu’un fichier : `/etc/hosts`. Il faut ajouter notre traduction comme suit : `<adresse_ip> <nom>`

{{< code lang="plaintext" icon="file-text-o" title="/etc/hosts" >}}
192.168.1.100    vps-001.server
{{< /code >}}

{{< alert "warning" question-circle >}}Mais quel nom choisir ?{{< /alert >}}

Qu’importe. Quoi qu’il arrive ce DNS est local, vous êtes le seul à le consulter. Vous pourriez très bien nommer votre serveur `facebook.com`. Il sera accessible avec ce nom depuis votre client mais vous n’aurez plus accès à Facebook.

{{< alert "success" lightbulb-o >}}Le plus simple est de choisir le nom de la machine suivi d’un domaine local que vous utiliserez pour tous vos équipements réseau. Pour mon réseau local, j’utilise le nom de la machine suivi de “.server”{{< /alert >}}

Et voilà, c’est tout. Cependant, votre serveur n’a été renommé que pour un client, et il vous faudra répéter la manipulation pour chaques clients en modifiant leur fichier `/etc/hosts`. Une autre solution consiste à utiliser un serveur DNS local.

{{< alert "info" info-circle >}}Il est aussi possible d'attribuer une adresse nom de domaine en utilisant votre box Internet. Mais toutes les box des FAI français ne proposent pas cette options.{{< /alert >}}

A présent, vous pouvez accéder à votre serveur ainsi :

- http(s)://vps-001.server
- ssh vonkrafft@vps-001.server
- etc.
