---
title: "Quid du processeur (CPU)"
description: "Le processeur, entre autre, détermine vélocité de votre ordinateur. Il est donc important de bien choisir son processeur en fonction de ses besoins."
tags: [ "Quid", "CPU", "Processeur", "Overclocking" ]
lastmod: "2016-01-11 19:15:49"
date: "2012-03-10 19:15:49"
categories:
    - "Guides"
type: post
slug: "quid-processeur-cpu"
cover: "/media/2012/03/aaaeb16d6af6fcadb4a7a9df80de1cd3-1024x427.jpg"
---

Le CPU, pour Central Process Unit, effectue l’ensemble des calculs nécessaires à l’exécution des tâches sur votre PC. C’est lui, entre autre, qui détermine vélocité de votre ordinateur. Il est donc important de bien choisir son processeur en fonction de ses besoins. Dans cette optique, voici un petit guide pour vous aider à choisir correctement votre CPU.

<!--more-->

## La fréquence du processeur

Elle s’exprime en Gigahertz (GHz). Elle indique le nombre d’opération que le CPU peut effectuer par seconde (1GHz = 1 million d’opération par seconde). Longtemps considérer comme un indicateur de la puissance du CPU, la fréquence native d’un processeur actuel varie entre 1,5 GHz et 3,6 GHz pour les PC de bureau. Je parle de fréquence native car il est possible d’overclocker son processeur pour augmenter sa fréquence (voir l’article sur [l'overclocking](/tutoriels/overclocker-son-cpu/)).

{{% alert "info" %}}<i class="fa fa-info-circle"></i> **INFO :** Pour l’anecdote, le record d’overclocking avec un CPU grand public est détenu par l’AMD FX-8150 qui a atteint une fréquence de 8,429 GHz. Pour atteindre un tel niveau, il a fallu utiliser de l’hélium liquide pour refroidir le processeur.{{% /alert %}}

Cependant, il ne faut pas oublier que généralement plus la fréquence est élevée plus la température est élevée. Je dis « généralement » car avec la multiplication des cœurs (voir plus bas), le rapport fréquence/température s’est un peu complexifié.

## La mémoire cache

Appelée aussi mémoire tampon, c’est une mémoire intégrée au CPU qui permet un accès plus raide aux informations. Lorsque vous sollicitez le processeur, celui-ci ne peut pas effectuer toutes les opérations nécessaires en une seule fois. Les ordres et les données sont donc stockés dans cette mémoire. Vous l’aurez donc compris, sa capacité influe sur la rapidité du CPU.
Les processeurs actuels possèdent plusieurs niveaux de mémoire cache :

- Le **cache L1** : directement intégré au cœur du CPU, il est donc très rapide d’accès. Il est subdivisé en deux parties :
    - Le cache d’instructions qui contient les ordres reçus pour effectuer l’opération.
    - Le cache de données qui stocke les informations nécessaires à l’exécution de l’opération.
- Le **cache L2** : situé dans le CPU, il vient s’intercaler entre le cœur du processeur et la mémoire vive. Il est plus rapide d’accès que la RAM mais moins que le cache L1.
- Le **cache L3** : autrefois solidaire de la carte mère, les nouvelle architecture l’intègre au CPU. Il s’intercale alors entre le cache L2 et la mémoire vive.

<table style="text-align: center; width: 100%; height: 100px;" cellspacing="5" cellpadding="1">
	<tbody>
		<tr>
			<td style="background-color: #e0f2ff; border: solid 1px #404040; width: 19%;">Cœur du Processeur</td>
			<td style="background-color: #fff4e0; border: solid 1px #404040; width: 19%;">Cache L1</td>
			<td style="background-color: #e0ffe0; border: solid 1px #404040; width: 19%;">Cache L2</td>
			<td style="background-color: #ffe0e0; border: solid 1px #404040; width: 19%;">Cache L3</td>
			<td style="width: 5%; border: none;"></td>
			<td style="background-color: #cacaca; border: solid 1px #404040; width: 19%;">Mémoire Vive</td>
		</tr>
		<tr>
			<td style="height: 30%;" colspan="6">Schéma de la structure des caches d’un processeur</td>
		</tr>
	</tbody>
</table>

## Les processeurs Multi-Cœur

La loi de Moore prévoyait que le nombre de composants au sein d’un processeur et donc la puissance des CPU double tous les deux ans. Or, ces dernier ayant une taille fixe, les fabriquant se heurte depuis quelques années aux limites physique de cette loi. Leur parade a été de multiplier les cœurs des processeurs pour obtenir plus de performance. Après une longue mode des Dual Core, on voit aujourd’hui des processeurs avec deux, trois, quatre, six, huit voire même douze cœurs.

Le principal avantage de ces multi-cœurs est qu’ils ont rendu les PC réellement multitâche. En effet, un programme peut ainsi fonctionner en tache de fond (comme l’antivirus) sans gêner le programme en cours d’utilisation.

Les principaux processeurs multi-cœur AMD et Intel les plus récents sont les suivants :

- **Deux cœurs** : Intel Pentium D, Intel Dual-Core, Intel Core i3 et i5, AMD Athlon II X2, AMD Phenom II X2 et AMD A4.
- **Trois cœurs** : AMD Athlon II X3, AMD Phenom II X3 et AMD A6.
- **Quatre cœurs** : Intel Quad-Core, Intel Core i5 et i7, Intel Xeon, AMD Athlon II X4, AMD Phenom II X4, AMD A6 et A8 et AMD Opteron.
- **Six cœurs** : Intel Core i7, Intel Xeon, AMD Phenom II X6, AMD FX et AMD Opteron.
- **Huit cœurs** : AMD FX et AMD Opteron.
- **Douze cœurs** : AMD Opteron.

{{< img src="/media/2012/03/ee18b896cc5899bec1f776840dbec215.jpg" >}}
{{< img src="/media/2012/03/42c1b10b6c736953a0c1756258ad74cb.jpg" >}}

## Le socket

En fonction du socket que vous allez choisir, vous devrez acheter une carte mère compatible avec celui-ci. Actuellement, les sockets les plus fréquents sont les AM3 (AMD), LGA1155 et LGA1156 (Intel). Mais on trouve également des sockets AM2 et AMD2+ (AMD) et des sockets LGA775, LGA1366 et LGA2011 (Intel).
Pour plus d’info, voir l’article sur les [cartes mères](/guides/quid-carte-mere/).

{{< img src="/media/2012/03/639a82223fa951396ed4bf99e9c4eb20.jpg" >}}

## Un processeur pour chaque utilisation

En fonction de vos besoins, les performances requises pour le CPU changent. C’est principalement le budget qui permet de définir les catégories d’utilisation :

- **Bureautique** : un processeur entrée de gamme à moins de 100€ suffit.
- **Jeux et retouche vidéo/photo** : un faut privilégier un processeur milieu de gamme entre 100€ et 200€.
- **Jeux poussés et professionnels** : un processeur haut de gamme à plus de 200€ s’impose.

Enfin, les processeurs sont vendus en version « Boite » accompagnés d’un refroidissement (ventirad) composé d’un ventilateur et d’un radiateur. Vous rencontrez peut-être des processeurs « Bulk ». Ce sont des processeurs vendus sans refroidissement, dans un emballage dénudé et avec une garantie moins longue. Cependant, les versions Bulk sont en train de disparaitre.