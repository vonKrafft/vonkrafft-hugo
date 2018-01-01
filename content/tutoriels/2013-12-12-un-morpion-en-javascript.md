---
title: "Un morpion en Javascript"
description: "Explication rapide du code source JavaScript d\'un jeu du morpion. Ce code source est aussi téléchargeable en suivant ce lien."
tags: [ "Morpion", "JavaScript", "Jeu", "CSS", "jQuery", "Tic Tac Toe", "HTML" ]
lastmod: "2013-12-12 18:35:51"
date: "2013-12-12 17:23:50"
categories:
    - "Tutoriels"
type: post
slug: "un-morpion-en-javascript"
cover: "/media/2013/12/86d8663b4bb62cbe6de841cb80991e60-1024x614.png"
---

On est parfois ammener à s'oocuper comme on peu lorsqu'on ne trouve rien à faire. C'est ainsi que j'ai implémenté un Morpion codé en JavaScript.

<!--more-->

## Le jeu du Morpion

Le **morpion** est un jeu de réflexion se pratiquant à deux joueurs au tour par tour et dont le but est de créer le premier un alignement de trois symbole sur une grille de 3 x 3.

- Vous pouvez y jouer sur [cette page](/media/2013/12/8cfd9cdead69b491836fe8caf58234c5/)
- Vous pouvez télécharger le code source avec [ce lien](/media/2013/12/8cfd9cdead69b491836fe8caf58234c5.zip)

{{< img src="/media/2013/12/8cfd9cdead69b491836fe8caf58234c5.jpg" title="Aperçu du jeu" >}}

## La page HTML

Elle comporte une zone de jeu et une colonne latérale pour les points et les messages. Chaque balise HTML possède un id pour pouvoir être manipulée par le script JavaScript. La zone de jeu est une balise "canvas". Elle est utilisée en tant que zone de dessin.

## Le script JS

Pour ce jeu du morpion, j'ai utilisé la bibliothèque jQuery.

### La zone de jeu

Pour dessiner la grille de jeux, j'ai implémenté un fonction `drawGrid()`. Elle dessine quatre segments grâce à la méthode `lineTo()`. Cette méthode est également utilisée pour tracer la croix du joueur 1. Pour le cercle du joueur 2, j'ai utilisé la méthode `arc()`.

### Déroulement d'une action

Je récupère l’événement d'un clique de la souris grâce au code `$("#canvas").click(function(e){})`. Lorsque l'on clique sur la zone de jeu, le script calcule les coordonnées du centre de la case la plus proche. Ensuite, si la case est libre, on appelle la fonction `drawSector()`. En fonction du joueur qui est en train de jouer, cette fonction dessine une croix ou un cercle, permute le numéro du joueur en train de jouer et actualise le message d'information. Enfin, elle vérifie si une ligne est complète. Si c'est le cas, le script appelle la fonction `theEnd()`. Si un joueur a gagné, on incrémente son compteur de points. S'il y a match nul, seul le compteur de manche est incrémenté. Enfin, le message d'information est actualisé et deux boutons s'affichent : "Nouvelle manche" et "Nouvelle partie".

### Nouvelle manche ou partie

A la fin de chaque manche, deux boutons apparaissent afin de commencer une nouvelle manche ou une nouvelle partie. Pour la nouvelle manche, on exécute la fonction `newMatch()`. La grille est redessinée, le tableau contenant la liste des cases occupées et réinitialisé et le message d'information est actualisé. Pour la nouvelle partie, on exécute la fonction `newGame()`. Cette fonction appelle la fonction `newMatch()` et en plus, les compteurs de points et de manches sont remis à zéro.

{{% alert "info" %}}<i class="fa fa-info-circle"></i> Vous êtes libre d'utiliser librement ce code. Seulement, si vous le diffusez, merci de citer vos sources et de conserver les commentaires des fichiers HTML, JavaScript et CSS.{{% /alert %}}