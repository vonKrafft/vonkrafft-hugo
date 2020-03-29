---
title: "Monter son PC | Pose du processeur"
draft: false
lastmod: "2015-09-21 16:39:04"
date: "2015-09-21 15:55:18"
type: page
slug: "pose-du-processeur"
---

{{< alert "default" "exclamation-triangle" >}}
Cette page est issue de l'ancien site _Tuto Wibb_ et n'a pas été mise à jour depuis 2015. Son contenu peut donc être inexact, voire erroné, et l'application des conseils ou consignes présents dans cet article doit être fait à votre propre appréciation. Je vous invite à lire [Les 7 ans de Tuto Wibb](/actus/les-7-ans-de-tuto-wibb/) pour plus d'informations.
{{< /alert >}}

1. [Introduction](/wibb/monter-son-pc/)
2. [Présentation & outillage](/wibb/monter-son-pc/presentation-outillage/)
3. [Déballage de la carte mère](/wibb/monter-son-pc/deballage-de-la-carte-mere/)
4. **Pose du processeur**
5. [Fixation du ventirad](/wibb/monter-son-pc/fixation-du-ventirad/)
6. [Installation de la mémoire vive](/wibb/monter-son-pc/installation-de-la-memoire-vive/)
7. [Préparation du boîtier](/wibb/monter-son-pc/preparation-du-boitier/)
8. [Installation des disques](/wibb/monter-son-pc/installation-des-disques/)
9. [Fixation de l'alimentation](/wibb/monter-son-pc/fixation-de-lalimentation/)
10. [Carte mère & branchements](/wibb/monter-son-pc/carte-mere-branchements/)
11. [Mise en place d'une carte fille](/wibb/monter-son-pc/mise-en-place-dune-carte-fille/)
12. [Vérifications & tests](/wibb/monter-son-pc/verifications-tests/)
13. [Finitions & conclusion](/wibb/monter-son-pc/finitions-conclusion/)

Nous allons maintenant fixer le processeur (CPU). Vous allez me dire : « pourquoi laisser la carte mère hors du boîtier ? » C’est vrai que l’on pourrait d’abord mettre la carte mère dans le boîtier et y ajouter ensuite le processeur et la RAM.

{{< img-fit
    "" "d46e8ec240cc8d9cfe560cda03c3190c.png" ""
    "" "61f2529360aec54f5dc9804b842cf3fa.png" ""
    "/media/wibb" "nowrap" "" >}}

Mais je préfère préparer la carte mère **avant de la fixer au boîtier** pour plusieurs raisons :

- Vous aurez peut-être choisi un ventirad qui nécessite une plaque de maintien à l'arrière ;
- Il est plus facile (à mon goût), de fixer le ventirad sur une carte mère posée à plat sur son emballage carton sur une table ;
- Certains boîtiers sont étroits et il est parfois difficile (voire impossible) de monter le ventirad directement dans le boîtier.
- Un tournevis qui dérape en voulant fixer maladroitement  le ventirad peut faire beaucoup de dégâts.

On va donc le monter le processeur et son ventirad hors du boîtier. Il existe à l’heure actuelle deux types de fixation pour les CPU, le premier, utiliser uniquement pas Intel, place les broches sur la carte mère, le processeur étant lisse. Le second, pour les puces AMD et les anciens CPU d’ Intel, place les broches sur le processeur, celle-ci s’insérant dans le socket de la carte mère.

### Processeur Intel 775/1155/1156/1366

Si vous avez choisi un **CPU Intel récent**, il se monte sur socket 775, 1155, 1156 ou 1366. Le sens de montage d'un processeur sur ce type socket est facilité grâce à la présence de détrompeur sur la puce et la carte mère. Pour l'installer :

- **Ouvrez le levier** qui libère le capot, et retirez le cache en plastique si votre carte mère est neuve ;
- **Posez le processeur** de façon à ce que les deux encoches soient alignées avec celles situées sur le socket ;
- **Rabattez le capot** sur le CPU ;
- **Refermez le levier** pour bien maintenir le capot.

{{< img-fit
    "" "be16bfed22a379602b46d9667cb4e64e.png" ""
    "" "973c3b52fa51042bccb27e20b4152432.png" ""
    "" "1552395ce4898c1bcaba509fa047e926.png" ""
    "" "07ad3189430651a4d0ec3283deca92aa.png" ""
    "" "cc7845f6010a306c393f661d9da00415.png" ""
    "" "851281b5793a94ba2544b53c01f91658.png" ""
    "/media/wibb" "nowrap" "" >}}

{{< alert "danger" "exclamation-triangle" >}}
**ATTENTION :** Insérez-le dans le bon sens : il y a des encoches, parfois un petit triangle doré pour vous indiquer la bonne orientation ; la surface lisse doit être orientée vers le haut et donc visible.  Ne forcez pas en l'enfonçant car ça pourrait l'endommager.
{{< /alert >}}

### Processeur AMD et Intel 478/P

Dans le cas d'un **CPU AMD** ou d'un **Intel plus ancien**, il se monte sur socket AM2, AM2+, AM3, 754, 939 et 462(A), ou 478 et P. Ces sockets sont suffisamment ressemblants pour que les instructions s'appliquent à tous. Pour installer le processeur :

- **Tirez le levier au maximum** pour débloquer le socket ;
- **Place le processeur** de façon à ce que le repère triangulaire placé sur le socket soit aligné avec celui placé sur le processeur. Tous les pins doivent passer entièrement dans le socket et le processeur doit être parfaitement à plat.
- **Replacez ensuite le levier** dans sa position d'origine pour bloquer le processeur.

{{< img-fit
    "" "3aca7dad0a473fb50c71086947b10cf8.png" ""
    "" "4a14e6d98f51d07e2a1d244b40b4b67b.png" ""
    "" "8c24e19d5bf11f3778604329d592091b.png" ""
    "" "e35d03cd86e371e32ef3153c75c2d937.jpg" ""
    "/media/wibb" "nowrap" "" >}}

{{< alert "danger" "exclamation-triangle" >}}
**ATTENTION :** Insérez-le dans le bon sens : il y a des coins sans broches, parfois un petit triangle doré pour vous indiquer la bonne orientation ; la surface lisse doit être orientée vers le haut et donc visible. Ne forcez pas en l'enfonçant car ça pourrait l'endommager.
{{< /alert >}}

Maintenant que le CPU est en place, on va pouvoir fixer le ventirad.

{{< nav
    "Déballage de la carte mère" "/wibb/monter-son-pc/deballage-de-la-carte-mere/"
    "Fixation du ventirad" "/wibb/monter-son-pc/fixation-du-ventirad/" >}}