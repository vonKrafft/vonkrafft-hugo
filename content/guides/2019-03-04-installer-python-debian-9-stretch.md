---
title: "Installer Python 3.7 sur Debian 9 Stretch"
description: "Comment installer Python 3.7 sur un système Debian 9 Strecth qui n'intègre par défaut que la version 3.5 de Python"
tags: [ "Python", "Python 3.7", "Debian", "Debian 9", "Stretch" ]
lastmod: "2019-03-04 19:54:26"
date: "2019-03-04 19:43:46"
categories:
    - "Guides"
type: post
slug: "installer-python-3.7-debian-9-strecth"
cover: "/media/2019/03/23eeeb4347bdd26bfc6b7ee9a3b755dd.png"
---

Nous allons installer **Python 3.7** sur un système **Debian 9 (Stretch)**. Pour ceux qui ne le savent pas, Python est un langage de programmation open source et Python 3.7 est la dernière version majeure du langage. Il comprend de nombreuses nouvelles fonctionnalités, mais du fait du rythme de _release_ des version Debian stables, Debian 9 n'intègre que la version 3.5 de Python.

<!-- more -->

{{< img-post path="/media/2019/03" file="3b3d883f353f54a8ad62760ab18ea9c6.png" >}}

{{< alert info info-circle >}}Une des fonctionnalités sympa dont j'avais besoin est l'ajout des [f-Strings](https://realpython.com/python-f-strings/#arbitrary-expressions). Apparu avec Python 3.6, elle permettent d'ajouter dans les chaînes de caractères des expressions qui seront remplacée par leur valeur. Et quitte à mettre à jour Python, autant installer la dernière version ;){{< /alert >}}

## Installer Python 3.7

La première étape est de mettre à jour le système et d'installer `libffi`.

{{< highlight terminal >}}
debian:~$ sudo apt update && sudo apt upgrade
debian:~$ sudo apt install libffi-dev
{{< /highlight >}}

Ensuite, nous téléchargeons la dernière version de Python 3.7 (liste des version sur https://www.python.org/ftp/python), nous décompressons l'archive _tgz_ dans le répertoire `/usr/src` et nous installons Python.

{{< highlight terminal >}}
debian:~$ wget https://www.python.org/ftp/python/3.7.2/Python-3.7.2.tgz
debian:~$ sudo tar -xzf Python-3.7.2.tgz -C /usr/src
debian:~$ cd /usr/src/Python-3.7.2
debian:/usr/src/Python-3.7.2$ sudo ./configure --enable-optimizations
debian:/usr/src/Python-3.7.2$ sudo make altinstall
{{< /highlight >}}

Je vous propose d'aller prendre un café, car ça va durer un petit moment. Si l'installation s'est correctement terminée (i.e. aucun message d'erreur, notamment dans les dernières lignes affichées dans la console), vous devriez être en mesure de lancer la commande suivante :

{{< highlight terminal >}}
debian:~$ python3.7 -V
Python 3.7.2
debian:~$ pip3 --version
pip 19.0.3 from /usr/local/lib/python3.7/site-packages/pip (python 3.7)
{{< /highlight >}}

Et voilà :)
