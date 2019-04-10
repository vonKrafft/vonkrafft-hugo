---
title: "Gérer ses mots de passe avec PGP"
description: "Si de nouvelles méthodes d'authentification font peu à peu leur apparission, les mots de passe sont encore largement utilisés. Mais face à la croissance de plus en plus importante de services nécessitant un mot de passe, comment gérer efficacement nos identifiants sans nous rendre vulnérable."
tags: [ "PGP", "OpenPGP", "GnuPG", "GPG", "Pass", "Git" ]
lastmod: "2018-07-18 23:40:17"
date: "2018-07-18 23:40:17"
categories:
    - "Securite"
type: post
aliases:
    - "/console/gerer-ses-mots-de-passe-avec-pgp/"
slug: "gerer-ses-mots-de-passe-avec-pgp"
cover: "/media/2018/07/12df53fea8b3adfa6c2ec456dd22e204.jpg"
---

Si de nouvelles méthodes d'authentification font peu à peu leur apparition, les mots de passe sont encore largement utilisés. J'évoquais déjà dans mon article sur [les bonnes pratiques en matière de mot de passe](/dossiers/mots-de-passe-bonnes-pratiques/) comment stocker convenablement les mots de passe sur un serveur de base de données. Mais nos identifiants ont beau bénéficier de la meilleure protection possible en termes de stockage sur ces serveurs, cela n'empêchera pas l'utilisateur de choisir un mot de passe faible ou de le stocker en clair sur son ordinateur ...

<!--more-->

{{< img src="/media/2018/07/12df53fea8b3adfa6c2ec456dd22e204.jpg" link="/media/2018/07/12df53fea8b3adfa6c2ec456dd22e204.jpg" >}}

## Une avalanche de mots de passe

Face à une croissance de plus en plus importante du nombre de mots de passe nécessaires dans la vie de tous les jours, l'Homo Sapiens s'est adapté et a élaboré plusieurs méthodes pour ne pas oublier ces précieux sésames. Vous pouvez par exemple :

- Mettre le même mot de passe partout. Après tout, pourquoi se casser la tête à inventer de nouveaux mots de passe lorsqu'il suffit de réutiliser celui que l'on connait déjà par cœur ? Les adeptes de cette méthode utilisent souvent le prénom de leur animal de compagnie comme mot de passe universel ...
- Noter vos mots de passe sur des post-it, que vous planquerez discrètement sous le clavier. L'homme moderne souhaitant s'affranchir du support papier, vous pouvez également de voir un fichier texte enregistrer sur le Bureau, habilement nommé "motsdepasse.txt", ou un mail dans "Brouillon" avec l'ensembles des identifiants.
- Incrémenter son mot de passe et/ou utiliser une base commune suivie ou préfixée par le nom du service auquel le mot de passe donne accès. Cela peut donner des mots de passe assez long et donc si cela vous permet de retenir vos identifiants, c'est une bonne méthode.
- Utiliser des mots de passe de 20 caractères avec une entropie importante que vous retenez facilement car votre cerveau s'apparente à un supercalculateur avec une mémoire immuable et illimitée.

Vous l'aurez compris, ce n'est pas facile de jongler avec cette multitude de mots de passe. Si ce n'était pas assez clair, je ne recommande aucune des méthodes citées ci-dessus et si vous souhaitez de bonnes règles pour vos mots de passe, je vous conseille de jeter un œil aux [recommandations de l'ANSSI](https://www.ssi.gouv.fr/guide/mot-de-passe/). Pour allier sécurité et convivialité, il existe les gestionnaires de mots de passe. Vous ne retenez plus qu'un seul mot de passe qui sera utilisé pour chiffrer/déchiffrer tous les autres sur votre PC. Ainsi, vous pouvez avoir des mots de passe complexes différents pour chacun des services que vous utilisé sans avoir à tous les connaître.

Bien sûr, en plus de choisir un mot de passe maître robuste (une passphrase de plus de 20 caractères faisant l'affaire), il convient de bien choisir son gestionnaire de mot de passe afin de sélectionner un éditeur de confiance utilisant des algorithmes de chiffrement éprouvés. Parmi les gestionnaires les plus utilisés, je pourrais citer [KeePass](https://keepass.info/), [1Password](https://1password.com/), [LastPass](https://www.lastpass.com/fr) ou encore [Dashlane](https://www.dashlane.com/).

{{% gallery columns="4" %}}
{{< gallery_item src="/media/2018/07/55df45851ba0b5217648e7f6781cfe51-150x150.png" >}}
{{< gallery_item src="/media/2018/07/ef9c4dbcfa0b6025c36f40ab2dfc02bf-150x150.png" >}}
{{< gallery_item src="/media/2018/07/d08f7c91fcf5bd23107a3e9bef4b3bea-150x150.png" >}}
{{< gallery_item src="/media/2018/07/8177e32666901164e845c4829dd6a72d-150x150.png" >}}
{{% /gallery %}}

## Chiffrer nos mots de passe

Dans un précédent article, j'ai expliqué comment [générer des clés PGP et configurer une Yubikey](/console/pgp-generer-des-cles-et-configurer-une-yubikey/). Avec notre clé PGP et GnuPG, il est possible de chiffrer des documents. Ainsi, nous pouvons créer un fichier avec tous nos mots de passe et le chiffrer avec PGP.

{{< code lang="console" icon="code" title="Console" >}}
debian:~$ vim motsdepasse.txt                                                          # Modifier notre fichier avec les mots de passe
debian:~$ gpg2 --recipient $GPGKEY --output motsdepasse.gpg --encrypt motsdepasse.txt  # Chiffrer le fichier
debian:~$ rm motsdepasse.txt                                                           # Supprimer le fichier texte non chiffré
debian:~$ gpg2 --output motsdepasse.txt --decrypt motsdepasse.gpg                      # Lorsqu'on en a bseoin, déchiffrer le fichier
{{< /code >}}

{{% alert info %}}<i class="fa fa-info-circle"></i> Pour GnuPG 1.0 et 2.0, l'algorithme de chiffrement par défaut est **Cast5**, pour GnuPG 2.1 c'est **AES-128**. Il est possible de choisir un autre algorithme lors du chiffrement avec l'option `--cipher-algo` ou modifier l'algorithme par défaut dans le fichier de configuration `~/.gnupg/gpg.conf` avec les directives `personal-cipher-preferences` et `s2k-cipher-algo`.{{% /alert %}}

Bon, on est bien content avec notre fichier, mais si l'on doit déchiffrer à chaque fois notre fichier, rechercher le mot de passe que l'on souhaite, copier/coller et  puis chiffrer à nouveau le fichier ... on va vite s'en lasser et revenir à nos règles toutes pourries citées plus haut. Heureusement, quelqu'un a déjà planché sur un gestionnaire de mot de passe basé sur PGP.

## Pass, le gestionnaire de mot de passe UNIX standard

Avec [`pass`](https://www.passwordstore.org/), chaque mot de passe réside dans un fichier GPG chiffré nommé selon le titre du site ou de la ressource nécessitant le mot de passe. Ces fichiers chiffrés sont organisés dans des répertoires dont l'arborescence est laissé libre à l'utilisateur, le tout stocké dans le dossier `~/.password-store`. Il est possible de synchroniser les mots de passe d'un ordinateur à l'autre en utilisant Git. Enfin, `pass` embarque des commandes simples afin de manipuler les mots de passe pour ajouter, modifier et copier les fichiers avec du chiffrement/déchiffrement à la volé.

### Initialiser un répertoire de stockage pour les mots de passe

Nous allons créer un répertoire de stockage de mot de passe pour y enregistrer nos mots de passe personnel, mais aussi les mots de passe d'autres personnes et des mots de passe commun. Imaginons une équipe constituée d'Alice, Bob et John qui souhaiterais mettre en place une gestion centralisée de leurs mots de passe. Alice, la chef de projet, décide d'utiliser `pass` puisqu'ils ont chacun une clé PGP.

{{< code lang="console" icon="code" title="Console" >}}
alice:~$ sudo apt install git gpg2 pass      # Installation
alice:~$ pass init alice@awesome-project.fr  # Création d'un répertoire de stockage de mot de passe
alice:~$ pass init $GPGKEY
mkdir: created directory '/home/alice/.password-store/'
Password store initialized for alice@awesome-project.fr
alice:~$ ls -lah /home/alice/.password-store/
total 12K
drwx------  2 alice alice 4.0K Jun 26 20:51 .
drwxr-xr-x 39 alice alice 4.0K Jun 26 20:56 ..
-rw-------  1 alice alice   41 Jun 26 20:51 .gpg-id
{{< /code >}}

Le dossier `.password-store` a été créé dans le répertoire d'Alice et le fichier `.gpg-id` contient l'identité d'Alice (ici son adresse mail). Tous les mots de passe qui seront ajoutés avec `pass` seront chiffrés avec la clé d'Alice.

{{< code lang="console" icon="code" title="Console" >}}
alice:~$ pass init -p alice alice@awesome-project.fr   # Initialisation d'un répertoire pour Alice
alice:~$ pass init -p bob bob@awesome-project.fr       # Initialisation d'un répertoire pour Bob
alice:~$ pass init -p john john@awesome-project.fr     # Initialisation d'un répertoire pour John
alice:~$ pass init -p shared alice@awesome-project.fr  # Initialisation d'un répertoire partagé
alice:~$ echo "bob@awesome-project.fr" >> ~/.password-store/shared/.gpg-id
alice:~$ echo "john@awesome-project.fr" >> ~/.password-store/shared/.gpg-id
{{< /code >}}

A présent, on dispose de quatre répertoires dans `~/.password-store`, chacun comportant un fichier `.gpg-id`. Nous avons un répertoire pour Alice, un pour Bob, un pour John et un partagé. Les fichiers `.gpg-id` des répertoires d'Alice, Bob et John ne contiennent que l'identité de la clé de leurs propriétaires respectifs. Ainsi, les mots de passe ajoutés dans le répertoire de Bob (par exemple) seront chiffrés avec la clé publique de Bob et donc seul ce dernier pourra les déchiffrer.

Le fichier `.gpg-id` du réperoire `~/.password-store/shared` contient les identités des trois clés PGP d'Alice, Bob et John. Ainsi, les mots de passe ajoutés dans ce répertoire seront chiffrés avec ces trois clés et donc toute l'équipe pourra les déchiffrer.

{{% alert info %}}<i class="fa fa-info-circle"></i> Au moment de chiffrer, `pass` va rechercher le premier fichier `.gpg-id` qu'il trouvera en remontant l'arborescence jusqu'à la racine du répertoire `~/.password-store`. Si aucun fichier `.gpg-id` n'est trouvé ou si ce dernier est vide, une erreur indiquera d'utiliser `pass init`.{{% /alert %}}

{{% alert warning %}}<i class="fa fa-exclamation-circle"></i> Attention, si vous avez bien suivi, seul l'identité d'Alice est présent dans `~/.password-store/.gpg-id`. Tous mots de passe créé ailleurs que dans `alice`, `bob`, `john` ou `shared` sera chiffré avec la clé d'Alice et donc lisible par cette dernière. Par conséquent, si Bob ou John ajoutent des mots de passe ailleurs que dans leurs répertoires, ils seront lisibles par Alice. L'idéal est de supprimer le fichier `~/.password-store/.gpg-id`.{{% /alert %}}

### Partage des mots de passe chiffrés avec Git

A présent que l'arborescence du répertoire `~/.password-store` est créé, Alice voudrais le partager avec Bob et John. Pour cela, `pass` intègre les commandes de `git` pour versionner les modifications des mots de passe et synchroniser le contenu avec un serveur Git.

{{< code lang="console" icon="code" title="Console" >}}
alice:~$ pass git init                                                      # Initialisation d'un dépôt Git
alice:~$ pass git remote add origin awesome-project.fr:/git/pass-store.git  # URL du serveur Git sur lequel centraliser les mots de passe
{{< /code >}}

### Ajout ou suppression d'une identité

L'équipe vient d'embaucher Jane et donc Alice voudrais lui partager les mots de passe de `shared`. Pour cela, elle ajoute l'identité de Jane dans `shared/.gpg-id`. Les nouveaux mots de passe créé dans `shared` sont à présent bien chiffés avec les quatre clés, seulement voilà, les anciens mots de passe ne sont pas lisibles par Jane. Pour cela, il faut réinitialiser le répertoire pour chiffrer les mots de passe avec toutes les clés PGP autorisées.

{{< code lang="console" icon="code" title="Console" >}}
alice:~$ pass init -p jane jane@awesome-project.fr                           # Création d'un répertoire privée pour Jane
alice:~$ echo "jane@awesome-project.fr" >> ~/.password-store/shared/.gpg-id  # Ajout de l'identité de Jane pour le répertoire shared
alice:~$ pass init -p shared $(cat ~/.password-store/shared/.gpg-id)         # Réinitialisation du répertoire partagé
{{< /code >}}

C'est la même manipulation lorsque l'on souhaite retirer une clé PGP : après avoir retiré l'identité dans le fichier `shared/.gpg-id`, il suffit de lancer la commande `pass init -p shared $(cat ~/.password-store/shared/.gpg-id)`. Bien sûr, je vous recommande également de changer les mots de passe concernés après avoir mis à jour le fichier `.gpg-id`.

{{% alert info %}}<i class="fa fa-info-circle"></i> Dans l'exemple ci-dessus, je crée un seul répertoire partagé pour tout le monde. Vous pouvez bien sûr créer autant de répertoires partagés que vous souhaitez, avec autant de combinaisons d'identités désirées.{{% /alert %}}

Personnellement, j'adore `pass` pour sa simplicité de conception et d'utilisation. Quand on y pense, ce n'est rien de plus que `gpg`, `git` et quelques commandes de base pour copier, modifier et supprimer des fichiers. Vous pouvez même utiliser votre éditeur de texte préféré pour modifier les mots de passe, `pass` utilise la variable d'environnement `$EDITOR` (`vi` par défaut).

Je n'ai pas détaillé toutes les fonctionnalités de `pass`, et je vous invite à regarder le site officiel de [Standard UNIX Password Manager](https://www.passwordstore.org/). Il est aussi possible d'utiliser des [plugins pour `pass`](https://www.passwordstore.org/#extensions), pour par exemple importer ses mots de passe depuis un autre gestionnaire de mot de passe, utiliser `pass` avec `dmenu` (i3), ajouter des extensions Chrome/Firefox pour bénéficier de ses mots de passe directement dans
son navigateur ...

## QtPass, un GUI pour gérer ses mots de passe

Nos mots de passe sont à présent protégés chiffrés avec nos clés PGP, bien organisés dans `~/.password-store`, et nous disposons de plusieurs commandes pour gérer leur organisation. Mais gérer ses mots de passe au travers d'un émulateur de terminal n'est pas forcément au goût de chacun et il serait agréable de bénéficier d'une interface graphique pour `pass`. C'est ce que propose [QtPass](), en se basant sur `git`/`gpg` ou bien sur `pass`.

{{% img src="/media/2018/07/ace5cefdb350559e106bedfd03b3ee4d.png" link="/media/2018/07/ace5cefdb350559e106bedfd03b3ee4d.png" %}}

## Nos mots de passe nomades avec Android

Un gestionnaire de mot de passe sur son PC, c'est pratique. Mais lorsqu'il s'agit de s'authentifier sur notre téléphone/tablette, cela devient vite fastidieux de recopier nos sésames de 20 caractères aléatoires (si ce n'est plus). Il serait donc intéressant de bénéficier d'une application pour gérer ses mots de passe sur nos appareils nomades.

L'implémentation de `pass` sur Android est [Password Store](https://play.google.com/store/apps/details?id=com.zeapo.pwdstore). Pour les curieux, le code source de l'application est disponible sur [GitHub zeapo/Android-Password-Store](https://github.com/zeapo/Android-Password-Store).

{{% gallery columns="3" title="Application Password Store pour Android" %}}
{{< gallery_item src="/media/2018/07/cfeb30ebaab19c8e177d372eea3ccfa3-300x533.png" link="/media/2018/07/cfeb30ebaab19c8e177d372eea3ccfa3.png" >}}
{{< gallery_item src="/media/2018/07/45e3706caddbbcf13c47fec36a40d4d1-300x533.png" link="/media/2018/07/45e3706caddbbcf13c47fec36a40d4d1.png" >}}
{{< gallery_item src="/media/2018/07/e0ab24074a3b1be066c969707ad99170-300x535.png" link="/media/2018/07/e0ab24074a3b1be066c969707ad99170.png" >}}
{{% /gallery %}}

Cela permet de synchroniser ses mots de passe avec Git et de gérer leur stockage sur le téléphone. Bien sûr, il vous faudra une clé PGP sur votre téléphone et vous aurez besoin pour cela de l'application [OpenKeychain](https://play.google.com/store/apps/details?id=org.sufficientlysecure.keychain) afin de générer et utiliser une clé PGP. Cette application est également compatible avec les [Yubikey](/console/pgp-generer-des-cles-et-configurer-une-yubikey/) et il vous suffira d'utiliser NFC
et votre Yubikey à chaque fois que vous aurez besoin de déchiffrer un mot de passe.

## Les autres plateformes

Je n'ai pas pu tester `pass` sur les autres plateformes, n'ayant pas de PC, téléphone ou tablette avec ces systèmes d'exploitation. Mais il existe des clients compatibles pour (presque) toutes les plateformes, parmi lesquelles :

- Microsoft Windows avec [Pass4Win](https://github.com/mbos/Pass4Win)
- Mac OS avec [pass.applescript](https://git.zx2c4.com/password-store/tree/contrib/pass.applescript)
- iOS avec l'application [passforios](https://mssun.github.io/passforios/)
- [Liste complète des clients compatibles](https://www.passwordstore.org/#other)

---

#### Sources

1. [Pass: The Standard Unix Password Manager](https://www.passwordstore.org/) (EN)
2. [Using pass in a team](https://medium.com/@davidpiegza/using-pass-in-a-team-1aa7adf36592) (EN)
