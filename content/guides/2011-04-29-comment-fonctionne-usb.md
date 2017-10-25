---
title: "Comment fonctionne l\'USB"
description: "Né en 1991, le port USB s’est imposer dans le monde de l’informatique. Mais comment fonctionne cette interface que nous utilisons depuis plus de 20 ans ?"
tags: [ "Quid", "USB", "Technique" ]
lastmod: "2016-05-10 19:21:47"
date: "2011-04-29 12:00:00"
categories:
    - "Guides"
type: post
slug: "comment-fonctionne-usb"
cover: "/media/2011/04/6a758e155636cd29a0e897e498151f6e.jpeg"
---

*Né en 1991, le port USB s’est imposer dans le monde de l’informatique personnel, décliné sous plusieurs formes, types & normes … Mais comment fonctionne cette interface que nous utilisons depuis plus de 20 ans ?*

## Un peu de culture générale

Le port USB est un port universel, c’est le plus utilisé dans l’informatique de tous les jours. Tout d'abord, le port USB a vu le jour en 1990 dans le but de remplacer tous les anciens ports qui commençaient à s'essouffler. Il a connu trois versions depuis sa création : la 1.1 la 2.0 et la 3.0.

{{< img src="/media/2011/04/d756e54c471730bae5a6c5af6dc5faf4.png" link="/media/2011/04/d756e54c471730bae5a6c5af6dc5faf4.png" >}}

- La version 1.1 permet deux modes de fonctionnement :
	- Low speed à 192 Ko/s pour les claviers et souris, etc.;
	- Full speed à 1,5 Mo/s pour les imprimantes, scanners, etc.
- La version 2.0 ajoute un nouveau mode :
	- High speed, à 60 Mo/s. Il est utilisé par les disques durs externes, les clés de stockage, et par les nouveaux scanners et nouvelles imprimantes.
	- Mais ce n'est pas tout : la version 2.0 ajoute une alimentation en 5 Volts et jusqu'à 500 mA, soit 2,5 Watts (0,5A x 5V = 2,5W).
	- Tout récemment, en 2008, la version 3.0 de l'USB a vu le jour et apporte un débit de transfert de 625 Mo/s soit 5000 Mbits/s. Ce mode est alors nommé Superspeed.

## Schéma électrique

### USB 1.1 et 2.0 – Low, Full & High Speed

Commençons par les deux premières normes de l’USB. La norme 1.1 et 2.0 se ressemble grandement. La première a quasiment disparu tandis que la deuxième fait partie intégrante de notre vie. Peu à peu, l’USB 2.0 sera remplacé par la nouvelle norme 3.0

- Alors, en 1 nous avons la borne +5V (2.0) ;
- En 2, D+, qui permet de transférer les données (1.1 et 2.0) ;
- En 3, D-, qui permet également de transférer les données (1.1 et 2.0) ;
- En 4, Ground, c'est-à-dire le 0V (2.0).

On distingue aussi deux type de port USB :

- Le port type A (le plus courant) : pour les clés USB, câble de mp3/ appareil photo … ;
- Le port type B (moins fréquent) : pour les imprimantes et scanners notamment.

Il existe encore les ports de type mini A et mini B. On les trouve le plus souvent pour connecter les appareils photos, certaines clés audio USB, etc.

{{% tw_gallery columns="2" title="Schéma du connecteur USB" %}}
{{< tw_gallery_item src="/media/2011/04/6b45ebaa03b0d371340fc0596a8e56fa.png" link="/media/2011/04/6b45ebaa03b0d371340fc0596a8e56fa.png" >}}
{{< tw_gallery_item src="/media/2011/04/1f588a9d86faed1fd4f1acf12956170c.png" link="/media/2011/04/1f588a9d86faed1fd4f1acf12956170c.png" >}}
{{% /tw_gallery %}}

{{% tw_alert "info" %}}<i class="fa fa-question-circle"></i> Pourquoi y a-t-il deux broches D+ et D- pour transmettre les données (data) alors que c'est un port série ?{{% /tw_alert %}}

Le port USB utilise un type d'encodage (NRZI) qui nécessite deux broches. C'est-à-dire que cet encodage utilise la borne D- pour représenter un 0 binaire, avec une tension négative, et la borne D+ pour le 1 binaire, avec une tension positive. NRZI signifie Non Return to Zero Inverted : jamais de retour à zéro, inversé. C'est un codage bien spécial :

- s'il faut envoyer un "1"", la sortie ne change pas d'état ;
- s'il faut envoyer un 0", la sortie change d'état à chaque fois.

### USB 3.0 – SuperSpeed

Maintenant, passons à la version 3.0 : il est plus complexe puisqu'il comporte neuf fils !

En apparence, il reste similaire à la version 2.0, ce qui lui permet entre autres d'assurer une compatibilité descendante et ascendante : on peut brancher des vieux périphériques sur du nouveau matériel et des périphériques neufs sur du vieux matériel.

Mais, s'il conserve les quatre broches classiques de l'USB, cinq viennent s'ajouter permettant ainsi au mode Superspeed d'atteindre un très haut débit : 600 Mo/s tout de même !

{{< img src="/media/2011/04/3107d7e498eebaf742fd42a6e29b3547.jpg" alt="Schéma du connecteur USB 3.0" link="/media/2011/04/3107d7e498eebaf742fd42a6e29b3547.jpg" title="Schéma du connecteur USB 3.0" >}}

Voici les vues de dessus et de profil du connecteur (en coupe) :

- Les broches 1, 2, 3 et 4 ont toujours les mêmes fonctions ;
- En 5 et 6, nous avons les contacts joliment nommés StdA_SSRX- et StdA_SSRX+ qui sont dédiés à la réception (pour l'ordinateur) en mode Superspeed ;
- En 8 et 9, ce sont les contacts StdA_SSTX- et StdA_SSTX+ qui servent à l'émission (pour l'ordinateur) en mode Superspeed ;
- Le contact 7 est quant à lui dédié au retour des signaux et se nomme GND_DRAIN.

Certes, les noms nous sont inutiles, mais cela nous apprend qu'il y a désormais une connectique pour la transmission et la réception dans la version 3.0 de l'USB.

Maintenant que vous en savez un peu plus sur ce port, vous pouvez [construire un ventilateur USB](http://tuto-wibb.krafft.ovh/2011/05/fabriquez-ventilateur-usb/).