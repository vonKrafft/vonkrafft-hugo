---
title: "Trucs et astuces pour les liseuses Kobo"
description: "Astuces de configuration : Convertissez vos livres pour profiter de toutes les fonctionnalités du Kobo et copiez-les facilement sur votre liseuse !"
tags: [ "Kobo", "Astuce", "Configuration", "Liseuse" ]
lastmod: "2016-12-01 10:53:11"
date: "2016-12-01 10:52:27"
categories:
    - "Guides"
type: post
slug: "trucs-astuces-liseuses-kobo"
cover: "/media/2016/12/32052f235759e191308724ac5e4d2d0f-1024x479.jpg"
---

Si vous aussi vous avez franchi le pas du numérique et que vous avez acheté une liseuse pour pouvoir enfin emporter plus de 3 livres pour vos vacances et si vous aussi vous avez choisi la Kobo (créée par qui vous savez), cet article est écrit tout juste pour vous.

{{< img src="/media/2016/12/32052f235759e191308724ac5e4d2d0f-1024x479.jpg" alt="Calibre" link="/media/2016/12/32052f235759e191308724ac5e4d2d0f.jpg" >}}

## Le bon format pour les livres

Le format EPUB (acronyme de « electronic publication », « publication électronique » en français) est un format ouvert standardisé pour les livres numériques. Par définition, il est donc compatible avec toutes les liseuses électroniques présentes sur la marché dont le Kobo : il suffit de les glisser dedans une fois connecté en USB, éjecter l’appareil et le redémarrer.

C'est bien, mais ce n'est pas le mieux. En effet, le Kobo dispose d'un format de livre électronique à lui : le KEPUB (notez l'originalité du nommage du format ...). Ce format permet d'apporter tout un lot de nouvelles fonctionnalités qui améliorent la lecture et l'expérience "Kobo".

Tout d’abord, la pagination : en bas du livre, la barre du bas indique un numéro de page sur le nombre de pages du chapitre en cours. C’est con, mais c’est déjà un bel avantage pour s’y retrouver et savoir si ça vaut le coup de continuer à lire pour espérer terminer le chapitre en cours. Par ailleurs, un truc tout bête mais qui devient vite indispensable pour ceux qui, comme moi, doivent bien ajuster leur temps de lecture dans leur emploi du temps : un petit « widget » de statistique de lecture avec le pourcentage du livre lu, le temps restant avant de terminer le chapitre, le temps que prendra la lecture du chapitre suivant, et une répartition graphique du livre par chapitre (chaque barre étant un chapitre ; plus la barre est haute, plus le chapitre contient de nombreuses pages).

Vous me direz "c'est bien joli tout ça, mais mes livres à moi sont au format EPUB !". Pas de panique, j'ai la solution : Calibre.

{{< img src="/media/2016/12/fccc8f9fde7b6108c5f1932d7e9da5b1-300x225.png" alt="Calibre" link="/media/2016/12/fccc8f9fde7b6108c5f1932d7e9da5b1.png" >}}

## Convertir ses livres pour le Kobo

Transformer un fichier EPUB en faux EPUB amélioré pour les Kobo va s’avérer finalement assez simple. Tout d’abord, il vous faudra installer le logiciel gratuit Calibre que vous pourrez trouver ici par exemple : [http://calibre-ebook.com/download](http://calibre-ebook.com/download).

Ensuite, vous allez devoir installer ce [plugin Calibre](/media/2016/12/e108d16818374e6a98f1ae534cd1aa00.zip) qui vous permettra de convertir vos livres EPUB au format KEPUB pour votre Kobo. Il vous suffira d’envoyer tous vos EPUB sur votre Kobo depuis Calibre équipé de ce plugin. Voilà, problème réglé !

## Transférer ses livres sur le Kobo

Vous ouvrez ensuite Calibre et connectez votre Kobo à l'ordinateur : Calibre reconnaîtra automatiquement la liseuse et un bouton "Appareil" devrait dans la barre de menu en haut. Dans votre bibliothèques, sélectionnez les livres que vous souhaitez copier sur la liseuse, faites un clic droit, "Envoyer vers le dispositif" et "Envoyer un format spécifique". Une petite fenêtre s'ouvre alors, vous choisissez "KEPUB", vous attendez quelques instants que Calibre convertisse et copie vos livres et c'est terminé ! Vous pouvez à présent lire vos livre en bénéficiant des fonctionnalités du format KEPUB.

## La couverture en mode veille

Lorsque votre liseuse est en veille, vous pouvez admirer un magnifique logo Fnac. Loin de moi l'idée de critiquer la marque, mais je préfère avoir la couverture de mon livre plutôt que ce petit log au centre de mon écran. Pour cela, rien de plus simple :

1. Branchez votre Kobo sur l'ordinateur, ouvrir l'explorateur de fichier et aller dans le répertoire du Kobo ;
1. Cliquer dans le dossier `.kobo`, vous trouverez un fichier `affiliate.conf` ;
1. Ouvrez-le avec un éditeur de texte : clic droit, `Ouvrir avec`, `Bloc-Note` ;
1. Dans ce fichier est inscrit : `[General] affiliate=fnac` ;
1. Remplacer `affiliate=fnac` par `affiliate=kobo` et enregistrez ;
1. Débranchez et dès que vous mettrez en veille la couverture du dernier livre ouvert s'affichera.
