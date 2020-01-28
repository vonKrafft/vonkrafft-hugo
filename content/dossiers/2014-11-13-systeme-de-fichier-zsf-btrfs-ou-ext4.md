---
title: "Système de fichier : zfs, btrfs ou ext4 ?"
description: "Ce bref état de l’art va donc tout d’abord présenter quelques facteurs de choix pouvant aider à départager des systèmes de fichier concurrents, avant de présenter plus en détail trois de ceux-ci : zfs, btrfs et ext4."
tags: [ "Veille technologique", "Système de fichier", "Btrfs", "ZFS", "ext4" ]
lastmod: "2014-11-13 20:49:31"
date: "2014-11-13 20:49:31"
categories:
    - "Dossiers"
type: post
slug: "systeme-de-fichier-zsf-btrfs-ou-ext4"
cover: "/media/2014/11/95576abe5f73468976492f0867d8456b.jpg"
---

Les systèmes de fichiers sont utilisés pour organiser le stockage de l’information sur des supports physiques (disques dur, ssd, etc.) de manière transparent pour l’utilisateur tout en lui permettant un stockage et un accès fiables.

Il existe plusieurs systèmes de fichiers, chacun ayant des caractéristiques propres et des cas d’utilisation particulier. S’il est souvent peu utile de sélectionner manuellement son système de fichier plutôt que de choisir celui proposé par défaut, dans certaines conditions d’utilisation il est nécessaire de sélectionner le système de fichier le plus adapté ; cela peut-être le plus rapide, ou le plus fiable, ou celui impliquant le moins de cycles d’écritures, etc.

<!--more-->

Ce bref état de l’art va donc tout d’abord présenter quelques facteurs de choix pouvant aider à départager des systèmes de fichier concurrents, avant de présenter plus en détail trois de ceux-ci : zfs, btrfs et ext4.

## Types de système de fichier

Devant la multitude de systèmes de fichiers existant, il faut sélectionner quelques critères permettant de faire le choix le plus adapté à l’utilisation souhaitée. De plus, le choix est souvent conditionné en partie par le système d’exploitation choisi.

Les systèmes de fichiers sont souvent regrouppés par type, ce qui permet de mettre en avant leur caractéristique principale. Voici une présentation rapide des types les plus fréquemment rencontrés :

-  **journalisé** : une trace de l’ensemble des modifications apportées aux données est conservé dans un journal, ce qui permet une plus grande tolérance aux pannes et une réparation plus facile en cas de corruption. Ext3, Ext4 et la famille Reiser sont journalisés. 
-  **non journalisé** : ce sont des systèmes de fichiers plus historiques, qui sont de moins en moins utilisés; comme par exemple les systèmes FAT ou ext/ext2.
-  **à _snapshot_** : un *snapshot* est un instantané du système de fichier qui permet d’enreigistré les modifications apportées. Selon l’implémentation utilisée (sauvegarde totale du système de fichier auparavant ou non), cette méthode permet d’éviter toute perte en cas de panne, mais implique une utilisation double d’espace de stockage. Les deux systèmes de fichier de ce type les plus anciens sont Btrfs et ZFS.

Il existe encore d’autres types de systèmes de fichier, certains développés pour une utilisation en réseau, pour les clusters, ou encore d’autres plus spécialisés (ISO 9660 pour les CD-ROM, CFS pour le stockage chiffré, ramfs et tempFS pour les systèmes de fichiers temporaires, etc.). Dans la suite, nous n’aborderons plus ces systèmes de fichiers spécialisés pour nous concentrer sur les usages plus conventionnels.

## ext4

### Présentation et historique

Comme son nom l’indique, l’*extended filesystem 4* (ext4) est le quatrième des systèmes de fichiers *extended filesystem*, utilisés par Linux depuis ses début. Il a été développé pour apporter à ext3 des améliorations en attendant l’arrivée d’un système de fichier plus révolutionnaire (qui devrait être Btrfs). Cependant, même si ses concepteurs l’ont conçu comme une étape intermédiaire, il a été massivement adopté et est implémenté dans une grande partie des systèmes d’exploitation de type Unix. Par rapport à ses prédécesseurs, ext4 apporte une meilleure gestion des gros volumes et des gros fichiers, ainsi qu’une limitation de la fragmentation grâce à l’*extent*.

### Points forts

- Compatibilité ascendante avec ext3
- Répandu, bien documenté, stable
- Limitation des erreurs I/O grâce à l’utilisation de checksum 
- Moins de fragmentation, efficace sur les gros fichiers :
	- pré-allocation (grâce à l’extent)
	- allocation retardée (le système attend d’avoir la taille totale du fichier à écrire pour allouer l’espace)
- performance pas trop en deça des autres pour les manipulations simples

### Points faibles

- compression et chifrement pas intégrés de base
- performances en deça pour les multiples manipulations en même temps

## ZFS

### Présentation et historique

ZFS a été développé dans l'objectif d'être le système de fichier "ultime". Le projet a été lancé par Sun Microsystem entreprise maintenant rachetée par Oracle. Il a fait sa première apparition en 2005 sur Solaris et a été totalement intégré mi 2006.

Il intègre en un seul produit le système de fichiers et la gestion de volumes.

### Points forts

- vérification de disque à chaud
- vérification des métadata et des data lors d'une vérification de disque
- systeme de snapshot très performant par différence
- possibilité de transférer des snapshot par le réseau, via ssh
- possibilité de définir un device pour faire du cache sur un pool de disque
- raidz (aucune, simple, double, ou triple partité)

### Points faibles

- pas intégrable dirctement dans le noyau linux à cause de sa license

## Btrfs

### Présentation et historique

Le projet de *B-tree File System* (Btrfs, à prononcer Butter-FS) voit le jour fin 2007 et a pour but de créer un système de fichier combinant toutes les couches habituellement utilisées (mdadm/lvm/fs...) en un produit unique. Ainsi, puisqu'il en a connaissances, Btrfs est capable de faire plus de choses et de les faire plus rapidement qu'un système de fichier utilisant des couches indépendantes (et universelles).

Son rôle sur le long terme est de remplacer ext4. Cependant, tant que son développement n'est pas terminé, il souffre de beaucoup de points faibles et la plupart de ses fonctionnalité se retrouvent déjà dans les produits actuels.

### Points forts

- Garantir la fiabilité des données
- Réaliser des instantanés au niveau fichier
- Mode « 3 copies » : RAID1 sur 3 blocs au lieu de 2
- Le « scrubbing » automatique en tâche de fond pour régulièrement traquer les corruptions et ventiler uniformément les données entre les disques
- De nouveaux algorithmes de compression, plus rapide (Snappy, de chez Google, ou LZ4, en plus de zlib et LZO)

### Points faibles

- Plus de 50% du disque sera utilisé pour assurer cette sécurité
- Pas de chiffrement des données
- En cas de panne d'un disque, il est nécéssaire de démonter le FS !
- Une fragmentation importante.
- Une fiabilité encore très éloignées des FS habituels.

|                                          | ZFS                         | Btrfs                     | Ext4                                       |
| ---------------------------------------- | --------------------------- | ------------------------- | ------------------------------------------ |
| Signification                            | Z File System               | B-tree File System        | Extended File System                       |
| date de création                         | 01/10/2005                  | 06/12/2007                | 10/10/2006                                 |
| capacité maximale du disque              | 16 Eio                      | 16 Eio                    | 1 Eio (limité à 16Tio par e2fsprogs)       |
| taille maxi d'un fichier                 | 16 Eio                      | 16 Eio                    | 16 Tio                                     |
| nombre max de fichier dans un répertoire | 2^56                        | Illimité                  | Illimité                                   |
| nombre maxi de fichiers                  | 2^48                        | 2^64                      | 4 milliards                                |
| nombre d'instantannés max                | 2^48                        | N/A                       | N/A                                        |
| architecture physique, comment les fichiers sont stockés sur le disque | Extensible hash table     | extend               | extend              |
| taille des noms de fichiers              | 255 octets                  | 255 octets                | 255 octets                                 |
| licence                                  | CDDL open source            | GPL                       | BSD                                        |
| éditeur/developpeur                      | sun/oracle                  | oracle                    | sun                                        |
| objectif, besoin auquel il répond        | fiabilité, protection contre les corruptions de données | Remplacer l'ext4 en s'inspirant de zfs     | Améliorer ext3 en attendant un successeur « révolutionnaire » (btrfs) |
| dates associées au fichier               | N/A                         | modification (mtime), modification des attributs(ctime), accès (atime) | Précision à la nanoseconde |
| où il est utilisé                        | solaris 10, netbsd, zfsguru | linux                     | linux                                      |
| système de permissions                   | posix                       | posix, ACL                | N/A                                        |
| compression                              | intégrée                    | intégrée (gzip, LZO1, Snappy2 et LZ43) | non                           |
| chiffrement                              | intégrée                    | intégrée                  | bob                                        |

## Sources et références

- `(en)` [http://kernelnewbies.org/Ext4](http://kernelnewbies.org/Ext4)
- `(en)` [https://ext4.wiki.kernel.org/index.php/Main_Page](https://ext4.wiki.kernel.org/index.php/Main_Page)
- `(fr)` [http://fr.wikipedia.org/wiki/Extended_file_system](http://fr.wikipedia.org/wiki/Extended_file_system)
- `(fr)` [http://docs.oracle.com/cd/E19253-01/820-2315/zfsover-1/index.html](http://docs.oracle.com/cd/E19253-01/820-2315/zfsover-1/index.html)
- `(fr)` [http://noonworld.fr/larchitecture-de-zfs/](http://noonworld.fr/larchitecture-de-zfs/)
- `(fr)` [http://fr.wikipedia.org/wiki/ZFS](http://fr.wikipedia.org/wiki/ZFS)
- `(en)` [https://btrfs.wiki.kernel.org](https://btrfs.wiki.kernel.org)
- `(en)` [https://www.youtube.com/watch?v=hxWuaozpe2I [vidéo]](https://www.youtube.com/watch?v=hxWuaozpe2I)
- `(fr)` [http://fr.wikipedia.org/wiki/Btrfs](http://fr.wikipedia.org/wiki/Btrfs)

---

Recherches & rédaction : Jake, Wandrille et Thom
