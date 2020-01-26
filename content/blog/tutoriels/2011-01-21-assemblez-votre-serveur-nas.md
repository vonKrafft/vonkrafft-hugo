---
title: "Assemblez votre serveur NAS de A à Z"
description: "Un guide de montage étape par étape pour vous aider à assembler votre propre serveur NAS de données et l\'inclure dans votre réseau domestique."
tags: [ "tuto", "NAS", "Montage PC" ]
lastmod: "2011-01-21 22:15:29"
date: "2011-01-21 22:15:29"
categories:
    - "Tutoriels"
type: post
slug: "assemblez-votre-serveur-nas"
cover: "/media/2011/01/356a8667d4d5192ba470210640d8e32e.jpg"
---

Comment monter un serveur de fichiers à la maison, pour sauvegarder ses données et les rendre accessibles facilement ? Un guide de montage étape par étape pour vous aider à assembler votre propre serveur NAS de données et l'inclure dans votre réseau domestique.

<!--more-->

## Une époque dangereuse

L’informatique est bel et bien installée chez nous et s’il y a une vingtaine d’années, avoir un ordinateur était un luxe, aujourd’hui, on en a deux ou trois chez nous. De plus, changer de PC ou de disque dur est problématique aussi : celui qui a déjà grillé un disque dur sait de quoi je parle, et celui qui a déjà essayé de transférer des gros volumes de données (> 300Go) d’un PC à un autre le sait aussi... Donc comment faire pour s’y retrouver ?

Simple : la solution c’est le NAS ! Un stockage en réseau NAS, ou un NAS (de l'anglais Network Attached Storage), est un serveur de fichiers autonome, relié à un réseau qui vous permet d’accéder à vos fichiers partout chez vous, voire même partout dans le monde si l’on sait un peu se débrouiller.

Aujourd’hui, la situation se résume à ça : un utilisateur lambda d’un PC possède environ 500 à 750 Giga de données, voire beaucoup plus ! Vous avez sûrement sur votre ordinateur vos photos de vacances, vos archives personnelles, vos documents de travail, votre collection de mp3 achetés bien légalement sur iTunes, etc... Et là, deux options :

- Soit vous n’avez qu’un seul PC et donc toutes vos données sont au même endroit.  
**Avantage** : vos fichiers ne sont pas éparpillés entre plusieurs ordinateurs même si c’est un peu le bazar dans votre disque dur.  
**Inconvénient** : un disque dur, passé 4 à 5 ans, cela peut claquer à chaque instant (précisément à chaque démarrage/arrêt). Et là vous me dites « facile, je grave des DVD »... Double erreur. D’une part, vous faites confiance à un support ayant une durée de vie de 15 à 20 ans. D’autre part, QUI a encore la patience de copier ses fichiers sur des galettes de 7 Go avec un disque dur de 750 Go ? En tous cas, pas moi.
- Soit vous avez plusieurs PC, et là encore, c’est compliqué.  
**Avantage** : vos fichiers sont sûrement en double et donc si un PC lâche, il vous en reste au moins un autre.  
**Inconvénient** : vos fichiers sont éparpillés entre plusieurs ordinateurs, et donc vous ne vous y retrouvez plus. Là encore vous me dites : « je copie tout sur mon disque externe USB ». Mais ce n’est pas très pro, ça prend du temps, et en plus, si vous avez plusieurs PCs, c’est compliqué pour se passer le disque. Surtout cela reste un disque dur donc, si le disque externe vous lâche, vous perdez vos données.

Maintenant, observons votre lieu de travail : il y a de fortes chances pour qu’au boulot, vous ayez accès à un « disque réseau partagé ». Un espace de stockage sur serveur, accessible via le réseau, et sur lequel vous stockez vos PowerPoint, vos PDF, vos documents, vos images débiles, vos films de vacances, et même quelques fichiers pour le travail...

{{< alert "warning" question-circle >}}Pourquoi ne pas monter son serveur à la maison ?{{< /alert >}}

## Intégrer un NAS dans son réseau

Après une introduction un peu longue, nous allons pouvoir commencer. Je supposerai par la suite que vous avez lu le guide [Monter son PC](/monter-son-pc/) et donc je passerais très vite sur le montage.

NOTE : Il existe des serveurs NAS « clef en main » à acheter dans le commerce. En dehors du fait qu’ils prennent rarement en charge le RAID, ils sont souvent plus chers que la solution proposée ici. Et souvent, ils ne sont pas évolutifs. Pas moyen d’y ajouter plus de deux disques (pour les premiers prix).

{{< img src="/media/2011/01/0f4036499be2e755d0fae2c749664b65.png" link="/media/2011/01/0f4036499be2e755d0fae2c749664b65.png" title="Exemple de réseau domestique" >}}

Pour commencer, il va falloir « monter » un serveur NAS. Pour ce faire, vous avez besoin d’une carte mère, un peu de RAM, un processeur, une carte graphique (elle peut être intégrée à la carte mère), d’un boîtier, d’une alimentation, de deux disques durs de grosse capacité (tant qu’à faire), d’un Operating System dédié et d’une clef USB... C’est tout !

Si vous avez un vieux PC dans un coin, c’est le moment de le recycler. N’importe quelle vieille machine avec un Pentium II démodé et 64Mo de RAM ou plus fera parfaitement l’affaire, du moment que vous pouvez y brancher deux disques durs (si possible SATA).

## Montez un NAS classique

{{< supply cost="350" level="3" time="1 à 3 heures" supplies="Processeur AMD Sempron 145 (35€ env.), carte mère Gigabyte GA-M68MT-S2 (50€ env.), mémoire vive 1Go DDR3-1333 (20€ env.), disque dur 2x1To RAID1 (140€ env.), alimentation silencieuse (80€ env.), boîtier entrée de gamme (35€ env.)" >}}

### Les composants

Niveau composant, un NAS ne requière pas du haut de gamme. les prix plancher feront l'affaire. Je vous conseil d'opter pour un boîtier Micro-ATX, ainsi que pour la carte mère qui va avec (attention, veillez à prendre de la DDR3). Libre à vous de voir plus grand, en choisissant un boîtier ATX, mais il est évident qu'un petit NAS se casera plus facilement qu'un grand. Pour le processeur, un Intel Celeron ou un AMD Sempron suffira, à vous de choisir en fonction de vos préférences entre les deux constructeur. Enfin, ajoutez environ 1 Go de mémoire vive DDR3 (2 Go maximum, après c'est inutile), Et pensez à acheter une clé USB, ou retrouvez-en une au fond d'un de vos tiroirs. Si vous en achetez une, je vous conseillerais 128 Mo, mais ça ne se fabrique plus (si vous avez une clé de 128 Mo chez vous, c'est parfait) ... donc prenez 1 Go pour être tranquille.

### Le stockage et le système d'exploitation

C'est le plus important ! La rapidité des disques n’est pas un critère, car vous serez limité par la vitesse de votre équipement réseau (et de votre carte wifi). Achetez de bonnes marques, le disque, c’est le cœur de votre serveur.

Et le système d'exploitation ? Vous avez le chois entre la distribution Windows avec Home Server (env. 110€) et la distribution Linux avec Freenas (gratuit). Le premier a l'avantage d'être simple d'utilisation et donc très facilement aprivoisable par quiconque, mais il est payant (je dirais même cher). Donc j'opterais pour le dernier : Freenas est un bon serveur de fichiers, stable, sympa d’utilisation ... mais il demande un peu plus de capacité d'adaptation. Il est téléchargeable gratuitement sur [www.Freenas.com](http://www.freenas.org/). Freenas démarre très bien sur une clef USB, et la plupart des BIOS sont capables de booter sur un périphérique USB depuis quelques temps.

## Montez un NAS miniature

{{< supply cost="460" level="3" time="1 à 3 heures" supplies="Processeur AMD Atom D525 intégré, carte mère Asus AT5IONT-I Mini-ITX (155€ env.), mémoire vive 1Go So-Dimm DDR3-800 (25€ env.), disque dur 2x1To RAID1 (190€ env.), alimentation intégrée, boîtier Antec ISK 100 (80€ env.)" >}}

### Les composants

L'objectif est de réduire la taille du NAS basique afin d'obtenir un mini serveur domestique (un peu comme un [mini PC](/tutoriels/monter-un-mini-pc/)). Niveau composant, il faudra opter pour un boîtier Mini-ITX ainsi que pour la carte mère qui va avec (attention, veillez à prendre de la DDR3). Pour le processeur, un Intel Atom intégré suffira, et ajoutez à ça environ 1 Go de mémoire vive DDR3 (2 Go maximum, après c'est inutile). Enfin, pensez à acheter une clé USB, ou retrouvez-en une au fond d'un de vos tiroirs. 128 Mo suffise, mais je vous conseil 1 Go pour être tranquille.

### Le stockage et le système d'exploitation

Là encore, il faut réduire, donc opter pour des disque 2.5" qui sont plus chers mais permettent une économie de place non négligeable. C'est le plus important ! La rapidité des disques n’est pas un critère, car vous serez limité par la vitesse de votre équipement réseau (et de votre carte wifi). Achetez de bonnes marques, le disque, c’est le cœur de votre serveur.

Et le système d'exploitation ? Vous avez le chois entre la distribution Windows avec Home Server (env. 110€) et la distribution Linux avec Freenas (gratuit). Le premier a l'avantage d'être simple d'utilisation et donc très facilement aprivoisable par quiconque, mais il est payant (je dirais même cher). Donc j'opterais pour le dernier : Freenas est un bon serveur de fichiers, stable, sympa d’utilisation ... mais il demande un peu plus de capacité d'adaptation. Il est téléchargeable gratuitement sur [www.Freenas.com](http://www.freenas.org/). Freenas démarre très bien sur une clef USB, et la plupart des BIOS sont capables de booter sur un périphérique USB depuis quelques temps.

## Recyclez votre vieux PC en NAS

{{< supply cost="150" level="3" time="1 à 3 heures" supplies="Votre vieux PC, disque dur 2x1To RAID1 (140€ env.), une clé USB (10€ env.)" >}}

### Le vieux PC

Si un vieux PC triane chez vous, il est temps d'en faire quelque chose : un NAS par exemple ! Pré-requis : il faut minimum deux ports S-ATA et des composants pas trop bruyants. Coté processeur, un pentium 4 première génération suffira, ou un vieil AMD. Vous pouvez si vous le souhaitez changer l'alimentation pour un modèle plus silencieux : optez pour une alimentation d'environ 200 W, ça suffit. Pour le processeur, pourquoi pas investir dans un ventirad passif, limitant le bruit et la consommation électrique de votre NAS. Mais inutile de changer trop de composants, car dans ce cas là, un NAS monté de A à Z sera plus rentable.

### Le stockage et le système d'exploitation

C'est le plus important ! La rapidité des disques n’est pas un critère, car vous serez limité par la vitesse de votre équipement réseau (et de votre carte wifi). Achetez de bonnes marques, le disque, c’est le cœur de votre serveur.

Et le système d'exploitation ? Vous avez le chois entre la distribution Windows avec Home Server (env. 110€) et la distribution Linux avec Freenas (gratuit). Le premier a l'avantage d'être simple d'utilisation et donc très facilement aprivoisable par quiconque, mais il est payant (je dirais même cher). Donc j'opterais pour le dernier : Freenas est un bon serveur de fichiers, stable, sympa d’utilisation ... mais il demande un peu plus de capacité d'adaptation. Il est téléchargeable gratuitement sur [www.Freenas.com](http://www.freenas.org/). Freenas démarre très bien sur une clef USB, et la plupart des BIOS sont capables de booter sur un périphérique USB depuis quelques temps.

## Montage du NAS

Donc, c’est très simple : montez votre NAS. Si vous recyclez votre vieux PC, passez à l'étape n°8 directement. Pour plus dinfo sur le montage, rendez-vous [ici](/monter-son-pc/).

1. Trouvez un tournevis cruciforme, un tournevis plat, une table solide et bien protégée contre les rayures ;
1. Montez le boîtier, branchez son alimentation ;
1. Installez la carte mère, paramétrez les jumpers conformément au manuel, ce qui implique que d’abord vous avez lu le manuel !
1. Branchez votre CPU et son ventilo (si vous avez choisi l’option ITX, c’est déjà fait);
1. Branchez votre carte graphique (si elle n’est pas intégrée à la carte mère) ;
1. N’oubliez pas les barrettes de RAM (dans le bon sens, merci) ;
1. N’oubliez pas les LED de façade, ça sert toujours !
1. Branchez vos deux gros disques dans la tour,
1. Ayez un câble RJ45 à portée de la main, pour brancher votre serveur sur le modem ADSL ou votre routeur wifi,
1. Votre serveur est prêt sur le plan « hardware ».


## Finalisation et réglages systèmes

Copiez, depuis votre PC fixe, Freenas sur votre clef USB en suivant les instructions du [site](http://www.freenas.org/).

1. Débranchez écran et claviez, et branchez-les sur le « serveur »,
1. Configurez le BIOS du serveur pour démarrer sur la clef USB,
1. Suivez les instructions de la [documentation](http://philoxserver.homelinux.org:8080/philoxsvr/file/freenas.pdf),
1. Une fois configuré, vous pouvez débrancher l’écran et le clavier du serveur, et le placer dans un endroit discret et proche du routeur wifi (pour branchement par câble RJ45).
1. Petit conseil : imprimez une [doc de Freenas](http://philoxserver.homelinux.org:8080/philoxsvr/file/freenas.pdf), et stockez-la à côté du serveur. On ne sait jamais !
1. Reste à configurer le routeur pour attribuer une adresse IP à votre serveur. Par exemple `192.1.68.1.5`. Vous pouvez aussi laisser le NAS et votre box ADSL faire joujou tous seuls ...

Ensuite, vous pourrez vous connecter au serveur depuis votre PC fixe via un explorateur web style Firefox pour configurer la matrice RAID et le système de fichier (LISEZ [la documentation de Freenas](http://freenas.org/documentation:setup_and_user_guide)). Une fois ceci fait, vous pourrez créer un drive partagé sur le réseau, que tous les PC de la maison pourront voir. Il sera bien au chaud derrière le Firewall de votre routeur. En outre, Freenas étant un OS très simple et sans autres applications sur le serveur, les risques de piratage et/ou infection sont quasi nuls (enfin n’oubliez pas d’inclure le nouveau lecteur dans vos recherches de virus périodiques).

{{< alert "info" question-circle >}}**NOTE :** Il y a une fonction « recycle bin » / poubelle dans Freenas, pour créer une « poubelle » comme dans Windows (un espace où sont conservés les fichiers « effacés » par vos soins et éventuellement par mégarde).{{< /alert >}}

## Conclusion

Et voilà : vous avez maintenant un serveur de fichiers, d’une capacité de 1000 Go, qui démarre sur clef USB. Il contient toutes vos données en double, vous pouvez y accéder de partout dans la maison, de n’importe quel ordi. N’importe qui venant chez vous avec un ordinateur portable peut s’y connecter via votre modem/routeur. En le laissant tourner pendant que vous n’êtes pas chez vous, et moyennant quelques bricolages, vous pourrez même y accéder depuis internet ... (je ne développerais pas ce point dans ce tuto).

Si vous grillez un des disques, voici ce que je conseille : comme 3-4 ans se seront écoulés, achetez deux autres disques d’une capacité double ou triple (c’est le principe de la course aux armements), branchez-les dedans, construisez une nouvelle matrice RAID, et copiez les données du vieux disque...

***Voilà, c’est donc fini. Vous avez à présent vos données rangées au même endroit et sécurisées.***