---
title: "Le Courant Porteur en Ligne - CPL"
description: "La technologie CPL permet de transmettre des données par le circuit électrique de la maison. Explication du fonctionnement du courant porteur en ligne."
tags: [ "Quid", "CPL", "Réseau", "Technique" ]
lastmod: "2011-05-18 18:53:38"
date: "2011-05-18 18:53:38"
categories:
    - "Guides"
type: post
slug: "le-courant-porteur-en-ligne-cpl"
cover: "/media/2011/05/0f2fa23471511c398c13d01b50f48d01.png"
---

{{< img src="/media/2011/05/0f2fa23471511c398c13d01b50f48d01.png" link="/media/2011/05/0f2fa23471511c398c13d01b50f48d01.png" >}}

**01 | Transmission des données**  
La technologie CPL permet de transmettre des données par le circuit électrique de la maison en superposant au courant un signal utilisant des fréquences plus élevées, dans la bande (le 1,6 a 30MHz. C’est au chipset d’Atheros, composé de deux puces (INTB4DD et INT14W), que revient cette charge. La première puce est chargée de l'encodage et de la transmission des paquets et la deuxième fait ofﬁce d’aiguilleur. C’est cette dernière qui intercepte et envoie les signaux reçus par la prise mâle. On retrouve ces deux puces dans chacun des boitiers puisque tous deux envoient et reçoivent des données.

**02 | La mémoire vive en soutien**  
Comme n'importe quel processeur, la puce INT64DD d’Atheros s’appuie sur un module de mémoire vive pour soulager le traitement de ses tâches. On retrouve ici un module de type SD-Ram de 128Mo qui facilite le décodage et la conversion des données unes en signaux électriques.

**03 | Le bloc CPL Wi-fi**  
Un kit CPL classique comprend deux blocs équipés chacun d’une prise Ethernet: l’une reliée à la boxe et l'autre au PC distant à connecter au réseau. Ce modèle est particulier dans le sens où l'un des blocs fait ofﬁce de routeur sans ﬁl, permettant à plusieurs appareils distants de se connecter à la box. Le Wi-fi est géré par la puce RT3052 de Ralink, protégée par
de la céramique. Comme la plupart des appareils Wi-fi, le bloc "maître" est doté d’antennes permettant d’optimiser la portée du signal.

**04 | Protection et stabilisation du courant**  
Le CPL est une technologie particulièrement dépendante de la qualité du réseau électrique et de la stabilité du courant qui le traverse. Les blocs CPL intègrent me série de protections particulièrement robustes, intégrées habituellement au sein d'appareils électriques plus conséquents : un fusible de 2,5A pour réduire l’impact d'éventuels courts-circuits, deux condensateurs de 6,3V pour encaisser les chutes et les pics de tension et une bobine d'inductance pour éliminer les parasites.

**05 | Ports Ethernet**  
On reconnait le bloc "maître" à ses trois prises Ethernet 10 / 100 et joue ainsi le rôle d'un switch. Une solution idéale pour relier en filaire des appareils éloignés de la box : un ou plusieurs ordinateurs. une imprimante ou un disque dur réseau.