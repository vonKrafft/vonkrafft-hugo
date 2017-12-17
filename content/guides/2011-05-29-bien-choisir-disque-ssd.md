---
title: "Bien choisir son disque SSD"
description: "Annoncé comme l’avenir du stockage des informations en remplacement des disques durs, voici quelques pistes pour vous aider dans le choix d\'un SSD."
tags: [ "Guide d'achat", "SSD", "Stockage" ]
lastmod: "2011-05-29 19:44:18"
date: "2011-05-29 19:44:18"
categories:
    - "Guides"
type: post
slug: "bien-choisir-disque-ssd"
cover: "/media/2011/05/1126bffa694048b4de49d7cb4f900686-cover-1024x576.jpg"
---

Annoncé comme l’avenir du stockage des informations, le SSD est un élément qui doit vous inciter à la plus grande prudence et à une grande réflexion avant l'achat. Voici quelques pistes pour vous aider dans ce choix.

## Les puces SLC, MLC... et le contrôleur

Le **SSD** (pour solid-state drive) est constitué de puces de **mémoire flash**, comme les clés USB. En réalité, on pourrait dire que ce sont des **grosse clés USB** mais un élément du SSD absent dans le stockage USB fait toute la différence. Cette élément est le **contrôleur**, il rend possible le dialogue entre les puces de mémoires du disque et le reste du système. Le choix de ce dernier est donc extrêmement important.

{{< img src="/media/2011/05/baeefc8a43c6401fecd6abade9c5cc85-150x150.png" link="/media/2011/05/baeefc8a43c6401fecd6abade9c5cc85.png" class="pull-right">}}

### Le choix des puces

Les **puces** sont de deux types : **SLC** ou **MLC**, pour Single ou Multiple Level Cell. Les premières ne peuvent stocker qu'un seul bit de données à la fois quand les secondes en stockent 2, voire 3 bits. Cette technologie permet une économie de production certaine, mais engendre une **usure** plus rapide des cellules et dégrade les performances, particulièrement en écriture.

### Le choix du contrôleur

Le choix du type de puce s'avère déterminant, celui du **contrôleur** l'est tout autant. Ce dernier a en effet un rôle très important dans les **performances des SSD**. Actuellement, je vous conseillerai de limiter votre choix de SSD à quatre contrôleurs :

- Les contrôleurs **d’Intel** comme les X25-E, X25-V, X25-M … ;
- Le **Marvell** 9174 ;
- Ceux de **Toshiba** comme le Daikoku 2 ;
- Les **Sand** **Force** comme le SF-1200.

Pour trancher ensuite, je vous laisse vous référer aux différents **tests** qui existent que le ou les SSD que vous aurez retenu.

### Le TRIM

Le TRIM est une technologie gérée actuellement par la plupart des carte mère (mais encore non reconnue en RAID) qui permet d’**augmenter la durée de vie** d’un SSD. Ce dernier point étant (quasiment) le seul défaut des SSD – puisque les performances diminues fortement avec le temps – les constructeur l’on compensé avec cette technologie qui **gère l’écriture des données** sur les puces. Le TRIM est **primordial** pour conserver des performances à long terme.

Vous cherchez :

- Pour votre système
- Pour encore plus de performances !
- Pour un serveur


## Un SSD pour votre système

Si les SSD sont encore chers et de faible capacité, ils représentent un bon investissement pour l’hébergement d’un **système d’exploitation**. Un SSD – pour les performances système – **couplé avec un disque dur** – pour le stockage de données – est donc un choix judicieux.

### L’espace de stockage

**Evaluez** bien vos besoins en terme d'espace-disque et n'oubliez pas qu'un l’investissement d’un SSD doit s'inscrire à long terme. Pour Windows ou Mac OS, la capacité du disque doit être au **minimum de 40 Go**, afin de pouvoir loger le système d’exploitation, les logiciels et les jeux. Prévoyez vos besoins et passez à 60 Go si vous avez peur de voir les 40 Go trop vite rempli. Si vous choisissez un machine sous Linux, un **30 Go** devrait suffire mais le marché actuel du SSD permet de s’en procurer un de 40 Go pour moins de **100€**.

### Les puces et le contrôleur

Privilégiez les modèles les plus **récents**, qui bénéficient des **dernières innovations** (dont la gestion du TRIM) et donc de performances accrues. Pour la technologie des puces, les SSD constitués de puces de **type MLC** sont ici à privilégiés : ils ont un coût moindre et leurs performances sont largement suffisantes pour la plupart des besoins.

## Pour encore plus de performances !

Vous êtes avides de **performance** ? Les SSD sont rapide, plus que les disques durs classique, mais l’homme moderne en veut toujours plus. Heureusement, la technologie est là pour répondre à ses attentes.

### Le choix du port

Les derniers modèles de SSD sont équipés de contrôleurs gérant le **SATA III**, qui offrent des performances bien meilleures que celles du SATA II (6 Gb/s au lieu des 3 Gb/s) à condition d'avoir une carte mère adaptée. Il offre des débits de **525 Mo/s** en écriture. Il existe aussi des SSD au format **PCI-Express** (4x ou 8x) qui proposent des taux de transfert encore plus élevés (**730 Mo/s** en lecture pour du PCI-e 4x). Ces disques communiquent directement avec la carte mère (pas de câbles S-ATA) mais ils sont aussi plus chers.

{{% tw_gallery columns="2" title="Les SSD en PCI-Express et les contrôleur de disque sont de bons atouts pour plus de performances" %}}
{{< tw_gallery_item src="/media/2011/05/094e8b4d2050a87bb6657b9b6c450b63.png" link="/media/2011/05/094e8b4d2050a87bb6657b9b6c450b63.png" >}}
{{< tw_gallery_item src="/media/2011/05/291f31126a31ce7ce88e71caa312a31c.jpg" link="/media/2011/05/291f31126a31ce7ce88e71caa312a31c.jpg" >}}
{{% /tw_gallery %}}

Enfin, une dernière connectique est présente sur les SSD : le **HSDL**. Plus rapide que le S-ATA, il offre des taux de transfert de l’ordre des **710 Mo/s** en lecture. Donc proche des cartes PCI-Express, il reste cependant bien moins cher.

### Le RAID, une fausse bonne idée

A l’instar des disques durs, il est aussi possible de monter des SSD en **RAID**. Le RAID0 permet d’accroitre les performances en reliant deux disques entre eux. Cependant, **je ne vous conseille pas** le RAID de SSD. En effet, le **TRIM** n’est pas utilisable en RAID et donc la mémoire du disque **s’altère** plus rapidement. De plus, un montage RAID signifie achat d’un 2<sup>nd</sup> disque et donc **surcoût**, un surcoût trop important face au maigre gain de vitesse. Il est donc préférable d’investir dans un SSD **haut de gamme** offrant des débits plus élevé.