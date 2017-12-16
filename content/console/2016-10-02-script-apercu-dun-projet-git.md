---
title: "Un script d\'aperçu d\'un projet Git"
description: "Présentation d\'un script bash qui permet d\'obtenir rapidement des infos sur un projet Git, comme le nombre de commits, de branches, de contributeurs ..."
tags: [ "Git", "Script", "Gitlab", "Github", "Gogs" ]
lastmod: "2016-10-02 08:49:03"
date: "2016-10-02 08:45:28"
categories:
    - "Console"
type: post
slug: "script-apercu-dun-projet-git"
cover: "/media/2016/10/8047d08e7a9c14108656e68be19a1e58-150x150.jpg"
---

Vous connaissez sans doute la célèbre plateforme [github.com](https://github.com/), qui permet d'explorer et gérer un projet Git. D'autres alternatives existent, comme [GitLab ](https://about.gitlab.com/) ou [Gogs](https://try.gogs.io/), qui permettent de disposer d'une interface web pour ses projets Git.

## Fonctionnalités

Ce sont ces outils qui m'ont inspiré pour le script que je vous présente aujourd'hui. L'idée était d'avoir un aperçu de l'état d'un projet Git. Le script, hébergé sur "[GitHub Gist](https://gist.github.com/vonKrafft/45d673da94be9620d578fa76d1a22277)", permet d'obtenir :

- Le nom du dépôt et de la branche actuelle ;
- Le nombre de commits, de branches, de tags et de contributeurs ;
- Le dernier commit, son auteur, son commentaire, son identifiant et sa date ;
- La liste des fichiers et répertoires avec leur dernier commit.

Je dois vous l'avouer, le script n'est pas parfait et j'ai déjà plusieurs idées pour l'améliorer. Cependant, il fait ce qu'on lui demande et c'est pourquoi je vous le partage, si jamais vous souhaitez disposer d'un petit script pour obtenir des infos sur vos projets en une seule commande.

## Le code source git-overview.sh

{{< gist vonKrafft 45d673da94be9620d578fa76d1a22277 "git-overview.sh" >}}

N'hésitez pas à laisser un commentaire si vous avez des remarques et/ou des idées d'amélioration.

## Ajouter un alias

Pour facilement obtenir ces infos lorsque vous vous trouvez dans un répertoire d'un projet Git, je vous propose de créer un alias dans votre fichier `.bashrc` ou `.zshrc` :

{{< tw_code lang="bash" icon="file-text-o" title="~/.zshrc" >}}
alias 'git-overview'='/path/to/the/script/git-overview.sh'
{{< /tw_code >}}