---
title: "Overclocker son CPU"
description: "Pour plus de fluidité ou pour faire renaître un vieux processeur, voici comment overclocker (i.e. augmenter la fréquence) son CPU."
tags: [ "CPU", "Overclocking", "tuto" ]
lastmod: "2011-09-17 20:48:51"
date: "2011-09-17 20:48:51"
categories:
    - "Tutoriels"
type: post
slug: "overclocker-son-cpu"
cover: "/media/2011/09/1c624a315b25dee4702269e5b6753953-1024x683.jpg"
---

Il y a quelques années, l'overclocking demandait beaucoup de moyens et était réservé aux informaticiens expérimentés. Mais depuis, les choses ont bien changées et overclocker son CPU est devenu plus facile. Pour plus de fluidité ou pour faire renaître un vieux processeur, voici comment augmenter la fréquence de son CPU.

<!--more-->

{{< supply level="3" time="2 heures" supplies="Un PC sous Windows et les logiciels CPU-Z, setFSB, OCCT & Speecy" >}}

## Qu’est-ce que l’overclocking

### Pourquoi overclocker votre processeur ?

Le but d'un overclocking est d’améliorer la puissance de calcul du processeur. Cela permet :

- D’obtenir un PC **plus réactif** pour un meilleur confort d’utilisation.
- De redonner un peu de puissance à une **vielle configuration** afin de pouvoir encore l’utiliser quelques années.

### Comment se fait-il qu’on puisse faire de l’overclocking ?

Afin d’éviter la casse, les constructeurs baissent volontairement la fréquence du processeur. Ainsi, votre CPU résistera aux contraintes extérieures (canicule, poussière …). Sachez qu’une gamme de processeur n’est basée que sur une architecture.

{{< alert "info" cogs >}}**EXEMPLE :** Les AMD Athlon II X2 2xx dont la fréquence varie entre 3.0 et 3.4 GHz.{{< /alert >}}

On peut donc effectuer un overclocking sur un CPU milieu de gamme et obtenir la fréquence d’un CPU haut de gamme (voire plus).

{{< alert "info" info-circle >}}**NOTE :** Cela ne signifie pas qu’un processeur milieu de gamme overclocké est aussi puissant qu’un haut de gamme. En effet, les performances d’un CPU ne dépendent pas uniquement de sa fréquence.{{< /alert >}}

### Le principe de l’overclocking

Tout d’abord, il faut savoir que le processeur communique avec la RAM (mémoire vive), la carte graphique et le chipset (puces de la carte mère). Ce dernier communique avec le reste des composants. L’ensemble des connexions qui relient le chipset au processeur s’appelle le **Front Side Bus** (FSB).
Pour des raisons historiques, la fréquence du processeur est égale à la <strong>*fréquence du FSB* x *un multiplicateur*</strong>, que nous allons appeler ici "coeff. CPU".

{{< alert "info" cogs >}}**EXEMPLE :** Pentium 4 Dual Core E5200 : 200MHz (FSB) x 12,5 (Coeff. CPU) = 2500 MHz{{< /alert >}}

Pour overclocker un processeur, il existe deux solutions :

- **Augmenter le coefficient du CPU**, mais celui-ci est plafonné par les constructeurs.
- **Augmenter le FSB**, c’est que nous allons faire.


## Se renseigner sur son matériel

Durant la suite de ce tutoriel,  je prendrais comme exemple un** Intel Pentium 4 Dual Core E5200**. C’est un processeur qui possède un coefficient multiplicateur de 12,5 et qui est cadencé initialement à **2,5 GHz**. Je vais procéder un à overclocking de 20% en augmentant le FSB de 200 MHz à 240 MHz pour obtenir une fréquence de **3,0 GHz**.

Tout d’abord, vous devez réunir des informations concernant votre matériel.

Pour cela, téléchargez [**CPU-Z**](http://www.clubic.com/telecharger-fiche11090-cpu-z.html), installez-le puis lancez-le. Dans l’onglet « **CPU** », vous pouvez voir la fréquence de votre processeur, celle de votre FSB et le coefficient multiplicateur du CPU.

Avant de continuer, téléchargez et installez :

- [**SetFSB**](http://www.clubic.com/telecharger-fiche307458-setfsb.html), qui vous permettra de modifier la fréquence du FSB depuis Windows ;
- [**OCCT**](http://www.clubic.com/telecharger-fiche133762-occt.html), afin de tester la stabilité de l’overclocking ;
- [**Speccy**](http://www.clubic.com/telecharger-fiche309808-speccy.html), qui vous donnera toutes les informations relatives à votre matériel ainsi que la température du processeur (très importante, il faut la surveiller de près).

## Overclocker son processeur

Ça y est, il est temps de passer aux choses sérieuses : nous allons **overclocker** le processeur !

{{< alert "danger" warning >}}**ATTENTION :** le fait d’overclocker votre processeur supprime sa garantie. Il est fortement recommandé d’effectuer une sauvegarde de ses données avant de débuter un overclocking de votre processeur. Tuto Wibb ne peut être tenu pour responsable des éventuels dommages survenus suite à l'utilisation de ce tutoriel.{{< /alert >}}

### Modifier le BIOS

{{< img src="/media/2011/09/5f8d177789055b98bd23693375337c2b.png" alt="Overclocker son CPU - Bios" link="/media/2011/09/5f8d177789055b98bd23693375337c2b.png" >}}

Premièrement, redémarrer votre PC et appuyez sur la touche « **suppr** » de votre clavier lorsque le PC démarre afin d’accéder au BIOS.

Ensuite, dans le BIOS, activez le contrôle manuel du FSB. Pour cela, activez le « **Clock Control** » (Gigabyte) ou bien augmentez de **1 MHz** le FSB (Asus).

Enregistrez les modifications et redémarrez votre PC.

### Modifier la fréquence du FSB

Maintenant que vous êtes de retour sous Windows, nous allons augmenter le FSB :

- Ouvrer SetFSB
- Sélectionnez le PLL de votre carte mère dans la liste « Clock Generator ». Pour cela, cherchez dans [cette liste](http://soj.mesdiscussions.net/soj/Overclocking/pll-liste-pll-sujet_2572_1.htm) le modèle de votre carte mère (ou un modèle qui s’en approche)
- Cliquez sur « Get FSB »

Vous obtenez alors ceci :

{{< img src="/media/2011/09/2f8924ac181b3a1bfd99be88a8debd59.png" alt="Overclocker son CPU - SetFSB" link="/media/2011/09/2f8924ac181b3a1bfd99be88a8debd59.png" >}}

Pour modifier la fréquence du FSB, déplacer le curseur du haut sur la fréquence souhaitée et cliquer sur « Set FSB ».

{{< alert "info" info-circle >}}**NOTE :** Il est inutile de se précipiter, avancez par palier de 5 MHz.{{< /alert >}}

### Pourquoi ça ne fonctionne pas ?

L’overclocking n’est pas une science exacte. Il arrive donc que des erreurs surviennent :

- Si votre PC ne répond plus, c’est que le PPL que vous avez sélectionné dans la liste n’est pas compatible avec votre carte mère.
- Si votre PC plante et redémarre, c’est que vous avez rentré une fréquence trop élevée.

### Overclocking de 10%

Nous allons débuter doucement par une légère augmentation du FSB.

- Régler SetFSB sur une fréquence **10%** plus haute que celle d’origine (Ici, 220 MHz)
- Cliquez sur « **Set FSB** »
- Si votre PC n’a pas planté, ouvrez OCCT
- Sélectionnez « Perso » dans la case « Test Type »
- Réglez le test sur 30 minutes
- Cliquez sur « **ON** »
- Si au bout d’une demi-heure OCCT ne détecte pas d’erreurs, vous pouvez passer à 20%

{{% gallery columns="2" title="CPU-Z à 10% - OCCT à 10%" %}}
{{< gallery_item src="/media/2011/09/618d2a1113c26c423473dcb0e40cdddd.png" link="/media/2011/09/618d2a1113c26c423473dcb0e40cdddd.png" >}}
{{< gallery_item src="/media/2011/09/b00f20b3296cb93beb01c0ea82f092b8.png" link="/media/2011/09/b00f20b3296cb93beb01c0ea82f092b8.png" >}}
{{% /gallery %}}

### Overclocking de 20%

Votre processeur tourne actuellement à 110% de ses capacités initiales et il est stable. Nous allons donc mettre la barre un peu plus haute et passe à 20 % d’overclocking :

- Régler SetFSB sur une fréquence **20%** plus haute que celle d’origine (Ici, 240 MHz)
- Cliquez sur « **Set FSB** »
- Si votre PC n’a pas planté, ouvrez OCCT
- Sélectionnez « **Auto (1h)** » dans la case « Test Type »
- Cliquez sur « **ON** »
- Si au bout d’une heure OCCT ne détecte pas d’erreurs, vous avez **réussi** votre overclocking

{{% gallery columns="5" title="OCCT à 20% - CPU-Z à 20% - Test de OCCT - Température au repos - Température en charge" %}}
{{< gallery_item src="/media/2011/09/a29e1ddf3eeee1ac457d751fd265e724-150x150.png" link="/media/2011/09/a29e1ddf3eeee1ac457d751fd265e724.png" >}}
{{< gallery_item src="/media/2011/09/4c8666d46865ab5008993cf2f373239c-150x150.png" link="/media/2011/09/4c8666d46865ab5008993cf2f373239c.png" >}}
{{< gallery_item src="/media/2011/09/c9449ce52c76a2897d84810c959a2b15-150x150.png" link="/media/2011/09/c9449ce52c76a2897d84810c959a2b15.png" >}}
{{< gallery_item src="/media/2011/09/ab67281fa7514190951edaa614b941be-150x150.png" link="/media/2011/09/ab67281fa7514190951edaa614b941be.png" >}}
{{< gallery_item src="/media/2011/09/b6ed449c4defbde9f578c47ce22d6b36-150x150.png" link="/media/2011/09/b6ed449c4defbde9f578c47ce22d6b36.png" >}}
{{% /gallery %}}

### Finitions

Voilà, vous exploitez votre CPU à **120%**.

Pour finir votre overclocking, redémarrez votre PC et allez dans le BIOS. Puis modifiez la valeur de la fréquence du FSB en y inscrivant celle souhaitée (Ici, 200 MHz + 20 % = 240 MHz).

Enregistrez et redémarrer le PC.

## Conclusion

Vous venez donc d’effectuer un overclocking de 20 %, augmentant ainsi la fréquence de votre processeur et – j’espère – la fluidité de votre PC.

Cependant, cette méthode d’overclocking reste relativement simple et elle ne permet pas de dépasser les 20 % d’overclocking. Pour aller plus loin et pousser son CPU dans ses derniers retranchements, il existe des manipulations plus complexes et plus risquées mais qui permettent une augmentation de 50 % voire plus. Tutoriel à suivre …