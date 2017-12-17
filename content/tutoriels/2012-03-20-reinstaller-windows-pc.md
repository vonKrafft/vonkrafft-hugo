---
title: "Réinstaller Windows sur son PC"
description: "C’est le printemps, accompagné de sa traditionnelle époque du grand ménage. Et pourquoi ne pas en profiter pour réinstaller Windows ?"
tags: [ "Windows", "Microsoft", "Réinstallation", "Sauvegarde", "Printemps", "Logiciels" ]
lastmod: "2016-01-11 19:07:03"
date: "2012-03-20 19:07:03"
categories:
    - "Tutoriels"
type: post
slug: "reinstaller-windows-pc"
cover: "/media/2012/03/4552016b0902f973b7fdd9e443b95a9e-1024x426.jpg"
---

Ça y’est, c’est le printemps, accompagné de sa traditionnelle époque du grand ménage. Et celui-ci passe aussi par les disques durs de nos ordinateurs : pourquoi ne pas en profiter pour réinstaller Windows ? Libre à vous de faire du tri dans vos fichiers, je vais vous donner ici quelques conseils pour faire une réinstallation de Windows efficace.

{{< tw_supply level="2" time="1 à 4 heures" supplies="Un DVD d'installation de Windows ou une clé USB bootable, un disque dur externe pour sauvegarder vos données, votre PC et un accès à Internet" >}}

## Sauvegarder ses données

Même si les disques durs sont de plus en plus partitionné, une partie étant réservée au système et l’autre destinée au stockage de vos données, il peut arriver que vous n’ayez qu’un seul disque dur où se mêlent vos données personnelles et les fichiers système. Une réinstallation de votre système d’exploitation doit donc débuter par la mise en lieu sûr de vos données.

{{< img src="/media/2012/03/50a00bbbe78ef49034bf6ed7e02020c3.jpg" >}}

Vous avez besoin d’un disque dur externe (ou interne), ou bien d’une clé USB si jamais vos données sont peu volumineuses. Ensuite, il vous faut explorer tous les recoins de votre PC à la recherche de vos données.

### Vos documents

Chaque utilisateur de Windows possède un dossier qui lui est réservé au sein du disque système (disque C:/ généralement). C’est dans ce dossier que Windows enregistre tous les documents par défaut. Pour y accéder :

- Windows 7 : C:\Users\VotreNom
- Windows Vista et XP : C:\Documents and Settings\VotreNom

Vous noterez que les deux emplacements sont sensiblement identiques. Pour la suite du tuto, j’adopterais la notation « Users ». Vous y retrouverez vos document mais aussi vos musiques, vos films, vos favoris, etc. … Pour ces derniers, seuls ceux d’Internet Explorer y sont.

### Vos favoris

Ceux d’Inter Explorer sont enregistrés avec vos documents. Pour les autres explorateurs internet, ils sont stockés dans des dossiers spécifiques au navigateur. Pour les deux principaux :

- Chrome : C:\Users\VotreNom\AppData\Local\GoogleChrome\User Data\Default

Puis faire une copie du ou des fichiers « Bookmarks » que vous replacerez au même endroit après la réinstallation de Chrome et Windows. Le dossier AppData (ou Application Data) est un dossier caché. A noté que les dernières versions de chrome permettent de se connecter avec un compte Gmail et de sauvegarder ses favoris en ligne.

- Firefox : C:\Users\VotreNom\Appdata\Local\Mozilla\Firefox\Profiles\xxxxxx.default

Puis faire une copie du ou des fichiers « Bookmarks.html » que vous replacerez au même endroit après la réinstallation de Firefox et Windows. Le dossier AppData (ou Application Data) est un dossier caché.

### Vos mails et vos contacts

Si vous utilisez un logiciel comme Outlook ou Windows Live Mail pour recevoir votre courrier, il est nécessaire de sauvegarder vos emails reçus.
Dans Outlook Express allez dans le menu Outils, choisissez Options puis l’onglet Maintenance et  cliquez sur Dossier de stockage.  Puis rendez-vous dans ce dossier et copier les mails. Pour les contacts, allez dans le menu Fichier, pointez sur Exporter, puis cliquez sur Carnet d'adresses.
Dans Windows Live Mail 2011, déroulez le menu Backstage (une enveloppe suivie d'une flèche en haut à gauche), sélectionnez Exporter des messages puis Messages électroniques. Pour les contacts, affichez la fenêtre Contacts de Windows Live Mail et cliquez sur le bouton Exporter dans le ruban Accueil.
Dans Windows Live Mail 2009, déroulez le menu Fichier, sélectionnez Exporter puis Messages. Pour les contacts, affichez la fenêtre Contacts de Windows Live Mail et sélectionnez la commande Exporter dans le menu Fichier
Dans Thunderbird sauvegardez le repertoire C :UsersVotreNomAppDataLocalThunderbirdProfilesxxxxxxx.defaultmail. Pour les contacts, c'est le fichier « abook.mab » dans C :UsersVotreNomAppDataLocalThunderbirdProfilesxxxxxxx.default

## Les drivers

Réinstaller Windows va effacer l’intégralité de votre disque. A la fin de celle-ci, il se peut que votre matériel, comme une imprimante, un lecteur CD ou le son, ne soit pas reconnu par Windows. Il est donc préférable de télécharger l’intégralité des pilotes nécessaires à votre configuration. Pour cela, je vous conseille [www.touslesdrivers.com](http://www.touslesdrivers.com/index.php?v_page=29) qui se chargera de détecter vos périphériques et de vous proposer les pilotes adéquats.
Pensez aussi à télécharger un antivirus que vous installerez dès la fin de l’installation de Windows pour plus de sécurité.

## Réinstaller Windows

Pour ce faire, vous devez avoir avec vous le DVD d’installation de Windows. Si vous ne l’avez pas, il faut demander au constructeur de votre PC comment faire pour en obtenir un ou bien l’acheter. Ensuite, vous insérer le DVD, vous installer Windows et vous passez à la suite, je ne vais pas m’étendre là-dessus.
Cependant, il peut arriver que vous ne disposiez pas de lecteur DVD sur votre ordinateur. C’est le cas, par exemple, des Netbooks. Pas de panique, il suffit de créer une clé USB d’installation.
Tout d’abord, vous devez créer une image ISO du DVD, ou alors en télécharger une sur le site de Microsoft. Pour créer une image à partir du disque, je vous conseille [ISO Recorder](http://www.clubic.com/telecharger-fiche36463-iso-recorder.html), [BurnAtOnce ](http://www.clubic.com/telecharger-fiche14725-burnatonce.html)ou encore [DeepBurner](http://www.clubic.com/telecharger-fiche12674-deepburner-free.html).
Ensuite, il faut créer votre clé USB d’installation à partir de votre fichier ISO. Microsoft propose son propre logiciel pour Windows 7 : [Windows 7 USB/DVD Download Tool](http://www.clubic.com/telecharger-fiche302934-windows-7-usb-dvd-download-tool.html) . Mais je vous conseille [WinToFlash](http://www.clubic.com/telecharger-fiche297880-wintoflash.html), un utilitaire très léger qui ne nécessite pas d’installation.

Ça y est ? vous avez un Windows tout beau tout neuf ? Parfait, passons à la suite : la réinstallation des logiciels.

## Réinstallation des logiciels

Premier conseil, n’installer que le strict minimum. Ne commencer pas à polluer votre nouveau système avec des logiciels que vous n’utiliserez que très rarement.
Ensuite, commencer par installer votre antivirus, que vous aviez téléchargé avant de réinstaller Windows. Puis paramétrez votre connexion internet et installer au besoin les pilotes des périphérique non reconnus par Windows. Pour savoir lequel dysfonctionnent, faites un clic droit sur le Poste de Travail (ou Ordinateur pour Vista et 7), sélectionnez « Propriété » et cliquez sur « Gestionnaire des périphériques ». Le matériel défectueux est signalé par un triangle jaune d’avertissement.


Vient maintenant le temps d’installer tous les logiciels dont vous avez besoin. Vous me direz que c’est long et fastidieux de rechercher tous les logiciels sur le net et de les installer un par un, sans compter les redémarrages du PC. Et bien je vous donne une astuce : [http://ninite.com/](http://ninite.com/). Vous sélectionnez les logiciels souhaitez (les grands classiques y sont tous) et le site génère un assistant d’installation que vous téléchargez. Celui-ci se charge ensuite de télécharger et d’installer tous les logiciels sélectionnés. Pour les programmes absents du site, il vous faudra tout de même passer par une installation manuelle.

## Conclusion

Voilà, vous avez réussi à réinstaller Windows et vous avez un nouvel OS tout propre. Il ne reste plus qu’à y ajouter vos données que vous aviez sauvegardé et de paramétrer vos logiciels.
Pour clore de tutoriel, voici de quoi conserver votre système au sommet de sa forme :

- [Ccleaner](http://www.clubic.com/telecharger-fiche14492-ccleaner.html) (gratuit) : simple d’utilisation, il est destiné à l’utilisateur Lambda qui ne veut pas se casser la tête avec des optimisations compliquées. Un clic toutes les semaines et votre système aura une durée de vie accrue.
- [Glary Utilities](http://www.clubic.com/telecharger-fiche73266-glary-utilities.html) (gratuit) : tout comme Ccleaner, il propose une solution de « Maintenance en un clic » accompagné d’un mode de fonctions avancées.
- [TuneUp Utilities](http://www.clubic.com/telecharger-fiche14995-tuneup-utilities-2012.html) (40 euros env.) : complet, il propose tout un panel de programme pour optimiser et personnaliser son système. Je vous le recommande.

{{% tw_gallery columns="3" %}}
{{< tw_gallery_item src="/media/2012/03/62e6e5d80448b91eda532682e8e250af.jpg" >}}
{{< tw_gallery_item src="/media/2012/03/e2c637950d07ec5c417060eef93b182a.jpg" >}}
{{< tw_gallery_item src="/media/2012/03/3fabd73770bf5b901740141d92bb29a5.jpg" >}}
{{% /tw_gallery %}}
