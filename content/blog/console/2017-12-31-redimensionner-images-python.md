---
title: "Redimensionner ses images en Python"
description: "Un script en Python pour redimensionner ses images afin d'inclure des images avec une résolution adaptée dans son site Web."
tags: [ "Image", "Python", "PNG", "JPG", "Gist" ]
lastmod: "2017-12-31 10:36:12"
date: "2017-12-31 09:14:06"
categories:
    - "Console"
type: post
slug: "redimensionner-images-python"
cover: "/media/2017/12/f99dc7883dc86099da307531d273ada6.png"
---

Lorsque l'on ajoute des illustrations a un article sur un site Web, il est important de bien la dimensionner : une image trop petite sera soit floue soit illisible, tandis qu'une image trop grande sera trop longue à charger.

{{< img src="/media/2017/12/f99dc7883dc86099da307531d273ada6.png" >}}

<!--more-->

## L'importance de la résolution d'une image

Vous me direz qu'à l'heure d'Internet illimité, il suffit de mettre des images en 4K partout et puis le tour joué. Oui ... mais non ! Tout d'abord, certains forfaits 4G ne sont pas illimité, et puis la couverture Haut Débit n'est pas uniforme et on a vite fait de se retrouver sur son smartphone avec un débit tout pourri. Et puis la personne qui se rend sur votre site n'est pas forcément intéressé par toutes les images, pensez à une page d'accueil avec une image de couverture pour chaque article, alors que votre visiteur ne s'intéresse qu'à un seul article.

Bref, il ne faut pas mettre sur votre site une image (beaucoup) plus grande que sa taille affichée. Ainsi, une photo 3840x2160 pixels affichée sur votre page dans un cadre de 300x169 pixels, ce n'est pas très optimisé ...

{{< alert "warning" question-circle >}}Oui mais mes images, lorsque l'on clique dessus, elles s'affichent en plein écran et donc si ma photo dans mon cadre de 300x169 pixels se retrouve en plein écran en 1920x1080 pixel, bah ce sera tout flou ... donc comment faire ?{{< /alert >}}

Et bien il suffit de charger l'image en haute définition lorsque l'on en a besoin. Au chargement de la page, on affiche une image de 300x169 pixels, et lorsque quelqu'un clique sur l'image pour la voir en plein écran, on renvoie une requête au serveur pour afficher l'image en haute définition.

{{< alert "warning" exclamation-circle >}}Non mais attend, ça veut dire que je dois avoir 2 images pour chaque illustration de mon site, mais c'est long et casse-coui****es à faire ...{{< /alert >}}

Oui, et parfois plus que deux images. Reprenons notre photo de 3840x2160 pixels, l'idéal sera d'avoir :

- Une version 300x169 pixels pour l'illustration du résumé de l'article en page d'accueil ;
- Une version 1024x577 pixels pour son affichage sur la page de l'article ;
- Une version originale, haute définition, lorsque l'on voudra l'afficher en plein écran.

Bon, à chaque nouvelle image que l'on insère sur notre site, on ne va pas redimensionner à la main notre image : on va scripter tout ça !

## Redimensionner son image en Python

Le script est assez simple :

- Il faut lancer `python resize-img.py IMAGE` (il se peut qu'il faille installer des dépendances, PIL notamment)
- Tout d'abord, l'image est renommée avec un condensat MD5 de son nom
- Si l'image est plus large que 1024 pixels, une version de 1024x??? pixels est créée
- Si l'image est plus large que 300 pixels, une version de 300x??? pixels est créée
- Enfin, une version rognée de 150x150 pixel est créée

Il ne vous reste plus qu'à utiliser les dimensions les plus appropriées pour inclure l'image sur votre site.

{{< gist vonKrafft 5ff45332d7b63797628253fa2c704c06 >}}