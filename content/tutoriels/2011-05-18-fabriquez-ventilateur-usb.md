---
title: "Fabriquez votre ventilateur USB"
description: "Je vous propose de faire un ventilateur USB. Ce n’est pas grandement utile mais vous pourrez fièrement vous vanter en disant : \"c’est moi qui l’ai fait !\"."
tags: [ "USB", "ventilateur", "électronique", "fabriquer" ]
lastmod: "2011-05-18 23:20:22"
date: "2011-05-18 13:02:44"
categories:
    - "Tutoriels"
type: post
slug: "fabriquez-ventilateur-usb"
cover: "/media/2011/05/12371e0b53ec20a2910edc2afe24a872-1024x769.jpg"
---

Je ne sais pas si vous suivez l'actualité informatique, mais on peut remarquer tout un tas de trucs inutiles en USB : un barbecue USB, un aquarium USB, un ventilateur USB, un réfrigérateur USB, une chauffe tasse USB, etc. …

Je vous propose de faire un ventilateur USB. Ce n’est pas grandement utile mais vous pourrez fièrement vous vanter en disant : « c’est moi qui l’ai fait ! ». Avant de commencer, je vous conseille de jeter un œil au [fonctionnement de l'USB](/guides/comment-fonctionne-usb/).

{{< tw_supply level="4" time="45 minutes" supplies="Un ventilateur de PC et un vieux câble USB, un fer à souder avec du fil d'étain, une paire de ciseaux et un ordinateur avec de l'USB (pour tester)." >}}

## La préparation

{{< img src="/media/2011/05/4e719fcb6194ea9281a1872a55e37d48-300x168.jpg" link="/media/2011/05/4e719fcb6194ea9281a1872a55e37d48.jpg" class="pull-right" width="250px">}}

Tout d'abord, il faut :

- Un ventilateur de PC et un vieux câble USB ;
- Un fer à souder avec du fil d'étain ;
- Une paire de ciseaux ;
- Un ordinateur avec de l'USB (pour tester).

{{% tw_alert "info" %}}<i class="fa fa-info-circle"></i> Un ventilateur de PC fonctionne en 12 V - 500 mA, or l'USB ne peut délivrer que 5 V - 500 mA. Donc l’USB ne pourra alimenter pleinement le ventilateur : ce n’est pas très important, notez juste que votre ventilateur ne tournera pas à sa vitesse maximale.{{% /tw_alert %}}

## Le montage

- Commencez par couper votre vieux câble USB ;
- Écartez bien les quatre fils qui le traversent ;
- Découpez le blindage ainsi que tout le plastique (en principe, le fil de la masse et du 5 V sont respectivement noir et rouge et plus épais) ;
- Une fois que vous avez trouvé vos deux fils, mettez du scotch ou un isolant autour des deux autres ;
- Dénuder vos deux fils +5V et 0V avec vos ciseaux ou un dénude-fil d’électricien ;
- De l’autre côté, notez la position de chaque fil : le rouge correspond au +12V, le noir à la masse et le(s) fil(s) qui reste(nt) correspond(ent) au transit d’information pour les ventilateurs thermo-régulable.
- Procédez au dessoudage des fils à l’aide de votre fer à souder.
- Maintenant, prenez vos deux fils de l’USB préalablement dénudés est souder les à la place des fils +12V et 0V de votre ventilateur (si vous avez noté la position des fils comme je vous l’ai dit, il ne devrait pas y avoir de problème)

{{% tw_gallery columns="4" %}}
{{< tw_gallery_item src="/media/2011/05/e776e2478a89d87f3d3cb0c619851d9f-150x150.jpg" link="/media/2011/05/e776e2478a89d87f3d3cb0c619851d9f.jpg" >}}
{{< tw_gallery_item src="/media/2011/05/a4d59281d401a278dbe8a46c47c1eeb0-150x150.jpg" link="/media/2011/05/a4d59281d401a278dbe8a46c47c1eeb0.jpg" >}}
{{< tw_gallery_item src="/media/2011/05/12371e0b53ec20a2910edc2afe24a872-150x150.jpg" link="/media/2011/05/12371e0b53ec20a2910edc2afe24a872.jpg" >}}
{{< tw_gallery_item src="/media/2011/05/327d7d6fccbf0cfc4288ce8963e461c2-150x150.jpg" link="/media/2011/05/327d7d6fccbf0cfc4288ce8963e461c2.jpg" >}}
{{% /tw_gallery %}}

Désormais, vous pouvez brancher, et constater que ça tourne !

{{< img src="/media/2011/05/a099fddac11afcf194cadb0b90a72601-1024x196.jpg" link="/media/2011/05/a099fddac11afcf194cadb0b90a72601.jpg">}}

Le ventilateur ne tourne pas, c'est raté. Vérifiez que vous avez correctement soudé les fils au bon endroit. Il se peut aussi que Windows vous affiche un message d'erreur comme quoi le périphérique à dépasser l'ampérage maximum, et là, il faut changer de ventilateur et réactiver le port USB que Windows a désactivé.

## Votre ventilateur USB

Vous venez de créer votre périphérique USB.

Mais vous pouvez très bien faire une guirlande électrique, ou tout ce que vous voulez, du moment que vous ne dépassez pas 500 mA. Si vous ne dépassez que de quelques milliampères, Windows XP vous préviendra qu'un périphérique USB a dépassé l'ampérage maximum, et désactivera temporairement le port USB.