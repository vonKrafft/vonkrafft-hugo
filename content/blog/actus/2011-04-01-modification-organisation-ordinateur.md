---
title: "Modification de l\'organisation de l\'ordinateur"
description: "Le chipset et le processeur sont en train de fusionner petit à petit. Explication de l\'organisation des composants sur la carte mère."
tags: [ "PC", "CPU", "Carte mère", "Chipset", "RAM" ]
lastmod: "2011-04-01 22:40:50"
date: "2011-04-01 22:40:50"
categories:
    - "Actus"
type: post
slug: "modification-organisation-ordinateur"
cover: "/media/2011/04/8f52d9d12e7cda00d35e05e32d5935d1-1024x576.jpeg"
---

Dans un PC, ce n’est pas au processeur que reviennent toutes les tâches. Il est épaulé par tous les autres composants avec qui il dialogue grâce au chipset, un ensemble de puces essentielles qui dirigent les données entre les divers éléments du PC … et qui sont en train de subir un changement radical. Explication de l'organisation des composants sur la carte mère.

<!--more-->

Lorsque vous entreprenez une action sur votre ordinateur, quelle qu’elle soit, que se passe-t-il dans les entrailles de votre machine ? C’est tout une mécanique qui se met en route afin de mettre en relation tous les composant nécessaire à l’exécution de la tâche que vous avez sollicitée. Les yeux rivés sur votre écran, une main sur la souris, l’autre sur le clavier, nous ne voyons pas forcément ce qui se trame au sein même de l’ordinateur.

## Le Chipset au centre de la carte mère

Bien qu’ils soient importants, le processeur, la mémoire vive, la carte graphique et le disque dur ne font pas tout. Il faut lier tous ces composants : c’est le rôle du chipset – jeu de composants – qui, soudé à la carte mère, est un point de transit des données entrante et sortante, allant et venant entre la mémoire, le processeur, la carte graphique, etc. …

Historiquement, le chipset était composé de deux puces principales. La première, le northbridge (pont-nord), dialogue directement avec le processeur grâce à une voie de communication haut débit, le front-side bus (FSB). C’est à lui que l’on confiait les échange les plus rapides : le contrôle de la mémoire vive, le dialogue avec la partie graphique du PC, les interfaces AGP et PCI-Express. La seconde puce, le southbridge (pont-sud), se chargeait des échanges lents, avec les interfaces externes : l’USB, les disques durs, le son, l’Ethernet, etc. … Les deux puces, northbridge et southbridge sont reliées entre elles par une voie de communication dédiée.

{{< img-link alt="Modification de l'organisation de l'ordinateur" path="/media/2011/04" file="65d0406686a4c880529679df88ffcad8.jpg" link="/media/2011/04/65d0406686a4c880529679df88ffcad8.jpg" >}}

## Bouleversement de cette organisation

Mais cette organisation est du passé, elle est en train de subir une mutation visant à réduire la taille de nos PC. Après une vingtaine d’année d’existence, cette organisation est en plein changement ; la limite de miniaturisation des composants étant presque atteinte, l’idée est de fusionner les composants entre eux afin de gagner en place et en rapidité. Premier touché par ce changement, le northbridge tend à disparaître, intégrée au processeur.

Depuis quelques années déjà, sa fonction de gestion de la mémoire vive est placée au sein du processeur. Apparu dans les années 90, cette architecture s’est répandue dans le grand public en 2002 avec l’Athlon 64 d’AMD. Plus tard, Intel l’a intégré dans tous ses processeurs de la famille Core i à partir de 2008. Conséquence : la vitesse de transfert entre la mémoire vive et le processeur profite d’un gain important. En effet, avec le contrôleur au sein même du processeur, les données ne transitent plus par le northbridge, ce qui permet d’obtenir une bande passante pouvant dépasser les 8 Go/s en DDR2. Ce gain a été accentué par l’arrivée de la DDR3, affichant des débits de transfert jusqu’à 50 Go/s !

Plus récemment, Intel et AMD on développés des processeurs capable de gérer la partie graphique du PC, intégrant parfois un composant d’affichage et gèrent eux même les liaisons avec le PCI-Express sur lequel est brancher votre carte graphique. Les fonctions du northbridge se résumant à la gestion de la mémoire et des interfaces d’affichage, l’intégration du contrôleur mémoire et graphique au sein du processeur va entrainer la disparition pure et simple du northbridge.

La disparition de cette puce est intéressante pour les portables et les mini-PC, ces derniers étant à la recherche de place. Dans ces environnement très compact, chaque millimètre cube de gagner est bon à prendre. Le southbridge, grâce à son rôle essentielle dans la communication avec toutes les autres interfaces, a encore quelques années devant lui mais il sera, à terme, lui aussi intégré dans le processeur.

<small class="align-right">**Source** : article original de C. Gauthier revu par Wandrille K.</small>
