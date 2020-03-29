---
title: "Monter son PC | Carte mère & branchements"
draft: false
lastmod: "2015-09-21 16:59:59"
date: "2015-09-21 16:59:59"
type: page
slug: carte-mere-branchements
---

{{< alert "default" "exclamation-triangle" >}}
Cette page est issue de l'ancien site _Tuto Wibb_ et n'a pas été mise à jour depuis 2015. Son contenu peut donc être inexact, voire erroné, et l'application des conseils ou consignes présents dans cet article doit être fait à votre propre appréciation. Je vous invite à lire [Les 7 ans de Tuto Wibb](/actus/les-7-ans-de-tuto-wibb/) pour plus d'informations.
{{< /alert >}}

1. [Introduction](/wibb/monter-son-pc/)
2. [Présentation & outillage](/wibb/monter-son-pc/presentation-outillage/)
3. [Déballage de la carte mère](/wibb/monter-son-pc/deballage-de-la-carte-mere/)
4. [Pose du processeur](/wibb/monter-son-pc/pose-du-processeur/)
5. [Fixation du ventirad](/wibb/monter-son-pc/fixation-du-ventirad/)
6. [Installation de la mémoire vive](/wibb/monter-son-pc/installation-de-la-memoire-vive/)
7. [Préparation du boîtier](/wibb/monter-son-pc/preparation-du-boitier/)
8. [Installation des disques](/wibb/monter-son-pc/installation-des-disques/)
9. [Fixation de l'alimentation](/wibb/monter-son-pc/fixation-de-lalimentation/)
10. **Carte mère & branchements**
11. [Mise en place d'une carte fille](/wibb/monter-son-pc/mise-en-place-dune-carte-fille/)
12. [Vérifications & tests](/wibb/monter-son-pc/verifications-tests/)
13. [Finitions & conclusion](/wibb/monter-son-pc/finitions-conclusion/)

Nous allons maintenant effectuer la tâche la plus délicate du montage : introduite les carte mère dans le boîtier. Tout d’abord, avant d'installer la carte mère, veuillez à vérifier quelques petites choses :

- Vérifiez la présence du **cache ATX** à l'arrière de votre boîtier (c’est la grille où va se mettre la connectique arrière) et assurez-vous qu’il est bien clipsé ;
- Assurez-vous que les **entretoises** qui supporte la carte mère sont vissées aux bons endroits ;
- **Ecartez** tous les fils électrique de l'alimentation et du boîtier ;
- **Décharger vous** encore une fois de votre électricité statique (en touchant le boîtier ou un radiateur).

{{< img-fit
    "" "c9bc44d290788dcd5bfb1c52578c09b6.png" ""
    "" "ccb918bcacd5f0cf433123d043821c3a.jpg" ""
    "" "a58bf600c4a7910b13b0ad0ee77c89f9.jpg" ""
    "/media/wibb" "nowrap" "" >}}

{{< alert "warning" "exclamation-triangle" >}}
**ATTENTION :** La carte mère est un élément **fragile**. De plus, le ventirad déjà fixé sur la carte est parfois très lourds. Faites donc attention qu'elle ne vous échappe pas des mains (c'est bête ...). Pour prendre la carte mère, éviter de la saisir par le ventirad, la connectique arrière ou le chipset. Je vous conseille de vous en saisir par les bords, même si ça complique l'insertion dans le boîtier.
{{< /alert >}}

Maintenant, passons aux choses sérieuses :

- Amenez la carte mère à plat, puis l'incliner vers l’arrière du boîtier pour faire entrer les connecteurs dans le cache ATX ;
- Posez ensuite la carte au fond sur les entretoises (si vous avez bien fait votre boulot, les entretoises seront en face des trous de fixation de la carte mère) ;
- Vissez la carte en faisant attention de ne pas déraper (une petite rayure peut rendre la carte HS), il est inutile de serrer les vis à fond, un vissage « normal » suffit.

{{< alert "info" "info-circle" >}}
**NOTE :** Les vis à utiliser sont parfois au petit format, plus souvent au gros format, il faut essayer les deux (sans forcer !). **Attention** de ne pas déraper sur la carte : ça pourrait la rendre inutilisable ...
{{< /alert >}}

### Alimenter la carte mère

La carte mère est alimentée à deux endroits :

- Le premier est un petit connecteur 4 pins (ou 8 pins pour les cartes mères plus récentes) qui a pour but d’alimenter principalement le CPU. Il se situe donc à proximité du processeur.
- Le second est un connecteur plus grand de 24 pins (ou 20 pins sur les anciennes cartes mère) qui sert à fournir du courant aux autres composants. Il est généralement placé près des emplacements de mémoire vive.

{{< alert "info" "info-circle" >}}
**NOTE :** Les connecteurs d’alimentation sont munis d’une multitude de détrompeurs conçu de façon à ce qu’il ne soit pas physiquement possible de les brancher à l’envers ou sur une autre prise.
{{< /alert >}}

{{< img-fit
    "" "e33efcc82686cf5e990e5263361df9b1-300x300.jpg" "ATX 12V 4 pins"
    "" "800d09cad0432f519f3a819c516446fe-300x300.jpg" "ATX 12V 8 pins"
    "" "25c58601fb8758a37a044e76e4118f7c-300x300.png" "ATX 12V 20+4 pins"
    "/media/wibb" "nowrap" "Connecteur 4 pins - Connecteur 8 pins  - Connecteur 20+4 pins" >}}

Certains boîtiers un peu haut de gamme sont conçus pour laisser passer des fils derrière la plaque de support de la carte mère, cette plaque du fond sur laquelle repose la carte mère est percée de plusieurs trous et un espace est disponible entre cette plaque et la paroi du boitier pour **ranger les fils** d'alimentation et la connectique (ce qui évite d'avoir un plat de spaghetti dans son boîtier).

### Alimenter lecteur, disque dur et SSD

Premièrement, voici comment brancher un **composant IDE**.

{{< img-fit
    "" "581d6381f3f35e4f9d77201acf87b364.png" ""
    "" "ce4b6032119e0b8046a806b71a615b41.png" ""
    "/media/wibb" "nowrap" "" >}}

On peut y voir une nappe IDE qui sert à communiquer les informations du disque à la carte mère. Cette nappe est munie d’un détrompeur (attention, **ne forcez pas** !). Le deuxième connecteur est une prise Molex d’alimentation.

{{< alert "info" "info-circle" >}}
**NOTE :** pour les lecteurs de disquette, c'est la même chose mais il faut une nappe IDE par lecteur de disquette. Ces nappes sont plus petites et elles ont une extrémité inversée.
{{< /alert >}}

Maintenant, voici pour **un périphérique S-ATA**.

{{< img-fit
    "" "b295577a85dbfc997889c9a6f26566e5.png" ""
    "" "5b43ed42abd453eee53c530e83ae20d5.jpg" ""
    "/media/wibb" "nowrap" "" >}}

Si l’IDE se présentait sous forme de larges nappes pouvant relier deux lecteurs à la carte mère, le S-ATA est plus simple, il y a **une nappe S-ATA par disque** dur, SSD ou lecteur optique dispose de sa propre connectique. Les prises sont sur le coin en bas à gauche des lecteurs ou des disques. La première se relie à l'alimentation, la seconde à la carte mère.

### Les prises ventilateur, USB et audio

Que ce soit les ventilateurs du boîtier, la connectique de façade ou tout autre périphérique, tous doivent être connectés à la carte mère. Où brancher ces fils ? Généralement, les prises sont en bas de la carte mère mais leur emplacement diffère d’un modèle à un autre. La solution se trouve donc dans le **manuel de votre carte mère**, où le rôle de chaque connecteur est indiqué. Certain lecteur CD possède des prises audio : branchez donc le câble approprié à l'arrière du lecteur. Votre ventirad est normalement déjà branché sur la prise **CPU FAN** (sinon faites-le). Pour les ventilateurs éventuels du boitier, branchez le connecteur sur la prise **SYS FAN**, pour ceux des disques durs, branchez sur **HDD FAN**.

{{< img-fit
    "" "7aca5ec618f7317328dcd7014cf9bdcf.jpg" ""
    "" "add0180387a0985c32471180b375b8d9.jpg" ""
    "/media/wibb" "nowrap" "Branchement USB - Branchement FAN" >}}

{{< alert "warning" "exclamation-triangle" >}}
**ATTENTION :** Veillez à ne surtout pas intervertir les connectiques USB et Firewire, cela risque d'endommager la carte mère.
{{< /alert >}}

{{< alert "info" "info-circle" >}}
**INFO :** branchez les ventilateurs sur les **bonnes prises**. En effet, les cartes mère récentes prennent en charge la régulation de la vitesse de rotation des ventilateurs (ainsi, c'est moins bruyant) et donc le nom des prise doit être respecté (CPU Fan, SYS Fan, HDD Fan ...).
{{< /alert >}}

### Les boutons de démarrage, reset et DEL

{{< img-post alt="Front Panel" path="/media/wibb" file="1cda01bdfb8b94f9e65c1743d21e6ed7.jpg" >}}

Le bouton On/Off, Reset et les DEL de façade se connectent aussi à la carte mère. Cherchez donc la série de câbles se terminant par un tout petit **pavé noir** (normalement, ce sont les seuls non branchés car on a déjà connecté les autre fils). Sur ces minuscules pavés noirs, il y a des inscriptions. Voici leurs significations :

- **Power Switch** : (PW SW) c’est le bouton de démarrage du PC ;
- **H.D.D. LED** : (HDD LED) commande la DEL qui indique si les disques durs travaillent ;
- **Power LED** : (PW LED) correspond à la DEL  de marche du PC ;
- **Reset Switch** : (Reset SW) c’est le bouton de Redémarrage du PC ;
- **Speaker** : (SPK) c’est le petit haut-parleur interne du PC qui fera BIIIIIP quand votre PC plantera et redémarrera (il n’est pas nécessaire de le brancher).

Les voyants (LED) doivent être branchés dans un **sens bien spécifique** contrairement aux interrupteurs (switchs, SW). D'abord, regardez votre **notice de carte mère** pour savoir ou brancher le connecteur LED, puis vérifiez où se trouve la broche + et où se trouve la broche -. Enfin, branchez le connecteur dans le bons sens : le fil blanc (ou noir) est le -, l'autre fil est le + (De toute façon, si les LED ne s'allument pas lors du premier démarrage vous changerez le sens de branchement du connecteur).

{{< nav
    "Fixation de l'alimentation" "/wibb/monter-son-pc/fixation-de-lalimentation/"
    "Mise en place d'une carte fille" "/wibb/monter-son-pc/mise-en-place-dune-carte-fille/" >}}