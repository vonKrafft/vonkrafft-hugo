---
title: "PGP : Générer des clés et configurer une Yubikey"
description: "La Yubikey, configurée pour fonctionner comme une carte à puce, permet de stocker de façon sécurisée ses clés PGP pour signer, chiffrer et s'authentifier. Détail des différentes étapes pour générer une clé PGP, l'importer sur la Yubikey et utiliser l'agent GPG pour s'authentifier avec SSH."
tags: [ "PGP", "Yubikey", "OpenPGP", "GnuPG", "GPG", "SSH" ]
lastmod: "2018-06-22 18:07:17"
date: "2018-06-22 18:07:17"
categories:
    - "Securite"
type: post
aliases:
    - "/console/pgp-generer-des-cles-et-configurer-une-yubikey/"
slug: "pgp-generer-des-cles-et-configurer-une-yubikey"
cover: "/media/2018/06/3d693b8cc27de08455d746df6295da08.jpg"
---

Ayant récemment acquis une [Yubikey NEO](https://www.yubico.com/product/yubikey-neo/), j'ai souhaité me créer de (nouvelles) clés GPG, les stocker sur ma Yubikey et configurer l'authentification SSH pour utiliser la clé présente sur la Yubikey. Après avoir lu pas mal d'articles et croisé les différentes sources qui étaient parfois incomplètes ou dédiées à d'autres environnement UNIX, je suis enfin parvenu à configurer ma clé. Je regroupe ici les différentes étapes qui m'ont permis d'y arriver (on ne sait jamais, ça pourra servir à d'autres, ou me resservir si je dois configurer un nouveau PC ou reformater ma Yubikey).

{{< img src="/media/2018/06/3d693b8cc27de08455d746df6295da08.jpg" >}}

<!--more-->

## Petits rappels sur PGP

Ça ne peut pas faire de mal de résumer les bases de [OpenPGP](http://www.openpgp.org/), et plus particulièrement la structure d'une clé PGP.

{{< alert "info" info-circle >}}PGP fait initialement référence à [Pretty Good Privacy](https://fr.wikipedia.org/wiki/Pretty_Good_Privacy), mais aussi au standard OpenPGP. Par la suite, j'utiliserais le terme PGP pour désigner OpenPGP.{{< /alert >}}

{{< alert "info" info-circle >}}[GnuPG](https://fr.wikipedia.org/wiki/GNU_Privacy_Guard) (ou GPG, de l'anglais GNU Privacy Guard) est l'implémentation GNU du standard OpenPGP défini dans la [RFC 4880](http://tools.ietf.org/html/rfc4880). Par la suite, nous générerons des clés OpenPGP à l'aide de GnuPG.{{< /alert >}}

### Structure d'une clé PGP

Une clé PGP n'est pas simplement une bi-clé publique/privée comme le sont les clés SSH, elles contiennent également des métadonnées et éventuellement d'autres clés. De manière générale, une clé PGP est constituée de quatre éléments :

- Une **clé primaire** (ou clé maître) : il s'agit d'une bi-clé utilisée pour signer les informations contenues dans la clé PGP. L'ID de cette clé primaire (une empreinte de 20 octets, soit 40 caractères, défini dans la [RFC 4880-12.2](http://tools.ietf.org/html/rfc4880#section-12.2)) est utilisée pour référencer la clé PGP.
- Une **identité primaire** : c'est elle qui définit le nom et l'adresse email du détenteur de la clé PGP.
- Une ou plusieurs **identités secondaires** optionnelles : Si généralement le nom est le même pour toutes les identités (je ne vous prive pas de vous inventer des surnoms), il est commun d'associer plusieurs adresses email à la clé PGP.
- Éventuellement des **sous-clés** : il s'agit là aussi de bi-clé utilisées pour signer, chiffrer ou s'authentifier. Ces clés sont certifiées par la clé primaire.

{{< img src="/media/2018/06/e91ebb5eb00250a74a0ebfe7450bfa2f.png" >}}

On peut se rendre compte qu'une clé PGP est en réalité une véritable structure pouvant contenir une ou plusieurs bi-clés ainsi que des métadonnées concernant le propriétaire de la clé. Initialement, lorsque Zimmermann décrit PGP dans la [RCF 1991](https://tools.ietf.org/html/rfc1991), une clé PGP ne comporte qu'une seule bi-clé. Lorsque la notion de sous-clés a été ajouté, le terme de "clé PGP" au singulier est resté.

### Les sous-clés

On distingue quatre actions pour les clés PGP : la certification, la signature, le chiffrement et l'authentification. Seule la clé primaire possède le pouvoir de certification. Les sous-clés sont des bi-clés signée par la clé primaire. La clé publique permet de vérifier une signature et chiffrer un document, tandis que la clé privée permet de signer ou déchiffrer un document, mais aussi à s'authentifier.

- La sous-clé de **chiffrement** : Elle est automatiquement créée par défaut et signée par la clé primaire. Elle permet de chiffrer les documents, les mails, etc.
- La sous-clé de **signature** : Elle permet de signer les documents, les mails, etc. Par défaut, cette fonction est remplie par la clé primaire.
- La sous-clé d'**authentification** :  Elle est utilisée pour s'authentifier auprès de services externes tels que SSH. Par défaut, cette fonction est remplie par la clé primaire.

Chaque sous-clé a sa propre date d'expiration (optionnelle) et peut être révoquées indépendamment des autres. Il peut être alors judicieux de n'attribuer qu'un seul rôle à chaque clé, une clé primaire utilisée pour signer les sous-clés et les identités, et trois sous-clés utilisées respectivement pour signer, chiffrer et s'authentifier.

### Les cartes à puces

Pour terminer cette (longue) introduction, parlons rapidement des cartes à puces (ou smart-card), telle que la Yubikey. Ce sont simplement des supports physiques pour stocker des clés privées et réalisée des opérations cryptographiques directement sur la carte.

Les cartes à puce sont conçues de telle sorte qu'une fois les clés privées ont été importées sur le périphérique, elles ne peuvent plus être extraites. Ainsi, même en cas de compromission de la machine, un attaquant ne pourra pas obtenir les clés privées.

## Configurer la Yubikey

Maintenant que les bases sont posées, il est temps de générer une clé PGP et de configurer notre Yubikey pour pouvoir signer et chiffrer des documents, mais aussi utiliser SSH avec une sous-clé stockée sur la Yubikey. Nos objectifs sont les suivants :

- Générer une clé PGP avec :
- Une clé primaire RSA 4096 bits pouvant uniquement certifier les identifiés et les sous-clés
- Une identité primaire avec notre nom et notre email
- Trois sous-clés RSA 2048 bits qui seront respectivement utilisées pour signer, chiffrer et s'authentifier
- Exporter la clé primaire privée sur une clé USB dédiée que nous stockerons précieusement
- Configurer la Yubikey pour y stocker les sous-clés privées
- Configurer Debian pour s'authentifier en SSH avec la sous-clé d'authentification de la Yubikey

### Créer une nouvelle clé PGP

Nous allons donc générer une clé primaire qui ne sera utilisée que pour signer les autres informations de notre clé PGP. Nous utilisons les options `--expert` et `--full-generate-key` pour obtenir toutes les options disponibles lors de la génération, notamment pour pouvoir définir précisément le rôle de la clé primaire. 

{{< highlight bash >}}
debian:~$ gpg2 --expert --full-generate-key
{{< /highlight >}}

Choisir l'option **(8) RSA (set your own capabilities)**, désactiver tous les rôles sauf **Certify** et générer une clé de 4096 bits. On peut ensuite vérifier que la clé a bien été créée :

{{< highlight bash >}}
debian:~$ gpg2 --list-keys
pub   rsa4096/0x788FC46C8BB350B8 2018-06-15 [C] [expires: 2019-06-15]
Key fingerprint = 1523 4153 E3D0 76C2 72E0  1D31 788F C46C 8BB3 50B8
uid                   [ultimate] Wandrille &lt;contact at vonkrafft dot fr&gt;
debian:~$ gpg2 --list-secret-keys
sec   rsa4096/0x788FC46C8BB350B8 2018-06-15 [C] [expires: 2019-06-15]
Key fingerprint = 1523 4153 E3D0 76C2 72E0  1D31 788F C46C 8BB3 50B8
uid                   [ultimate] Wandrille &lt;contact at vonkrafft dot fr&gt;
{{< /highlight >}}

On a donc une clé **pub**lique et une clé **sec**rète (privée) dont le rôle est de certifier **[C]** les autres informations de la clé PGP. On a également une identité **uid**.

{{< alert "info" info-circle >}}J'ai mis une date d'expiration de ma clé primaire à un an car je suis masochiste et j'adore générer des clés PGP tous les ans ... Blague à part, j'ai généré cette nouvelle clé PGP pour ma Yubikey à des fins de test, et je vais très probablement générer une nouvelle clé dans l'année.{{< /alert >}}

L'étape suivante est de générer nos trois sous-clés :

{{< highlight bash >}}
debian:~$ gpg2 --expert --edit-key 788FC46C8BB350B8
gpg> addkey
{{< /highlight >}}

GnuPG dispose d'une interface de commande pour l'édition des clés. Pour ajouter une clé, saisir `addkey`, puis choisir l'option **(8) RSA (set your own capabilities)**, désactiver tous les rôles sauf **Sign** et générer une clé de 2048 bits.

{{< alert "warning" question-circle >}}**Mais pourquoi utiliser RSA 2048 bits ?**<br>La Yubikey NEO, à l'heure où j'écris ces lignes, ne supporte que RSA 2048 and ECC p256. J'ai utilisé ici des clés RSA, mais libre à vous de générer des clés ECC en sélectionnant l'option **(11) ECC (set your own capabilities)**.{{< /alert >}}

Répéter l'opération pour générer les deux autres clés avec les rôles **Encrypt** et **Authenticate**, puis enregistrer les modifications :

{{< highlight bash >}}
gpg> quit
Save changes? (y/N) y
{{< /highlight >}}

Vous devriez ensuite obtenir ceci :

{{< highlight bash >}}
debian:~$ gpg2 --list-keys
pub   rsa4096/0x788FC46C8BB350B8 2018-06-15 [C] [expires: 2019-06-15]
Key fingerprint = 1523 4153 E3D0 76C2 72E0  1D31 788F C46C 8BB3 50B8
uid                   [ultimate] Wandrille &lt;contact at vonkrafft dot fr&gt;
sub   rsa2048/0x9DAAB9EBD88FFC37 2018-06-15 [S]
sub   rsa2048/0x9C892908F2535889 2018-06-15 [E]
sub   rsa2048/0xE69F0992A12AD72E 2018-06-15 [A]
debian:~$ gpg2 --list-secret-keys
sec   rsa4096/0x788FC46C8BB350B8 2018-06-15 [C] [expires: 2019-06-15]
Key fingerprint = 1523 4153 E3D0 76C2 72E0  1D31 788F C46C 8BB3 50B8
uid                   [ultimate] Wandrille &lt;contact at vonkrafft dot fr&gt;
ssb   rsa2048/0x9DAAB9EBD88FFC37 2018-06-15 [S]
ssb   rsa2048/0x9C892908F2535889 2018-06-15 [E]
ssb   rsa2048/0xE69F0992A12AD72E 2018-06-15 [A]
{{< /highlight >}}

On retrouve donc nos sous-clés privées (**ssb**) et publiques (**sub**) pour signer **[S]**, chiffrer **[E]** et s'authentifier **[A]**.

### Exporter les clés

Nous n'avons plus besoin à présent de la clé privée primaire qui a été utilisée pour signer l'identité et les sous-clés. Mais on va tout de même éviter de la supprimer : on ne sait jamais, elle pourrait nous servir ... On va donc exporter toutes nos clés sur une clé USB vierge dédiée au stockage de notre clé PGP. 

{{< highlight bash >}}
debian:~$ gpg2 --armor --output /mnt/usb/secret-keys.txt --export-secret-key 788FC46C8BB350B8
{{< /highlight >}}

{{< alert "danger" exclamation-circle >}}**Attention** Ne pas laisser trainer et ne pas perdre le support USB. Ça peut paraitre inutile de le préciser, mais il s'agit de vos clés privées ! Selon l'usage que vous ferez de votre clé PGP, la perte ou le vol de ces clés peut conduire à l'**usurpation de votre identité** !{{< /alert >}}

Maintenant que l'on dispose d'un backup sur un support USB bien planqué chez nous (ou dans un coffre à la banque, mais ce n'est pas forcément à la portée de tout le monde), on peut supprimer la clé privée primaire de notre clé PGP. Il nous faut pour cela :

1. Exporter les sous-clés ;
2. Supprimer complètement la clé PGP que nous venons tout juste de générer ;
3. Importer les sous-clés et supprimer le fichier d'export.

Après l'importation, nous aurons récupéré les sous-clés mais pas la clé primaire.

{{< highlight bash >}}
debian:~$ gpg2 --armor --output ./secret-subkeys.txt --export-secret-subkeys 788FC46C8BB350B8
debian:~$ gpg2 --delete-secret-key 788FC46C8BB350B8
debian:~$ gpg2 --import ./secret-subkeys.txt
debian:~$ rm ./secret-subkeys.txt
debian:~$ gpg2 --list-secret-keys
sec#  rsa4096/0x788FC46C8BB350B8 2018-06-15 [C] [expires: 2019-06-15]
Key fingerprint = 1523 4153 E3D0 76C2 72E0  1D31 788F C46C 8BB3 50B8
uid                   [ultimate] Wandrille &lt;contact at vonkrafft dot fr&gt;
ssb   rsa2048/0x9DAAB9EBD88FFC37 2018-06-15 [S]
ssb   rsa2048/0x9C892908F2535889 2018-06-15 [E]
ssb   rsa2048/0xE69F0992A12AD72E 2018-06-15 [A]
{{< /highlight >}}

On observe que la clé **sec**rète est à présent suivie d'un **#**. Cela indique que la clé privée n'est pas stockée sur le poste. Nous sommes prêts pour importer les sous-clés sur la Yubikey.

### Configurer la Yubikey

Après avoir branché la Yubikey, vérifions que nous pouvons communiquer avec elle (*E.T. téléphone maison*) :

{{< highlight bash >}}
debian:~$ gpg-connect-agent --hex "scd apdu 00 f1 00 00" /bye
D[0000]  04 03 04 90 00                                     .....
OK
{{< /highlight >}}

Ensuite, on va dire à la Yubikey de se comporter comme une carte à puce pour pouvoir y copier nos clés. Pour cela, nous avons besoin de [ykpersonalize](https://github.com/Yubico/yubikey-personalization).

{{< highlight bash >}}
debian:~$ ykpersonalize -m82
Firmware version 4.3.4 Touch level 773 Program sequence 1
The USB mode will be set to: 0x82
Commit? (y/n) [n]: y
{{< /highlight >}}

La dernière étape consiste à personnaliser la clé. Vous pouvez y renseigner votre nom, langue, pseudo, sexe et l'URL à laquelle votre clé publique est disponible (nous verrons sans doute dans un autre article comment mettre notre clé publique en ligne).

{{< highlight bash >}}
debian:~$ gpg2 --card-edit
{{< /highlight >}}

Le plus important ici est de **modifier les codes PIN par défaut**. Et oui, ça ne sert pas à grand-chose de protéger ses clés privées sur une Yubikey si tout le monde peut les utiliser (à condition de détenir physiquement votre Yubikey).

Dans l'interface d'édition de la Yubikey, tapez `admin` afin d'activer les commandes d'administration. Ensuite, tapez `passwd` pour changer le code PIN et le code PIN admin. Par défaut, le PIN est `123456` et le PIN admin est `12345678` Sauvegardez vos modifications et quitter l'interface d'édition de la Yubikey.

### Importer nos clés sur la Yubikey

Dernière étape : importer les trois sous-clés sur la Yubikey. Pour cela, il nous faut la console d'édition de notre clé PGP.

{{< highlight bash >}}
debian:~$ gpg2 --edit-key 788FC46C8BB350B8
pub  rsa4096/0x788FC46C8BB350B8
created: 2018-06-15  expires: 2019-06-15  usage: C   
trust: ultimate      validity: ultimate
ssb  rsa2048/0x9DAAB9EBD88FFC37
created: 2018-06-15  expires: never       usage: S   
ssb  rsa2048/0x9C892908F2535889
created: 2018-06-15  expires: never       usage: E   
ssb  rsa2048/0xE69F0992A12AD72E
created: 2018-06-15  expires: never       usage: A   
[ultimate] (1). Wandrille &lt;contact at vonkrafft dot fr&gt;
{{< /highlight >}}

Ensuite, nous sélectionnons les clés une à une pour les importer sur la Yubikey.

{{< highlight bash >}}
gpg> key 1      # Sélection de la première sous-clé à transférer
gpg> keytocard  # Déplacement de la clé sur la carte à puce
Please select where to store the key: 1 (Signing)

gpg> key 1      # Désélection de la première sous-clé
gpg> key 2      # Sélection de la seconde sous-clé à transférer
gpg> keytocard  # Déplacement de la clé sur la carte à puce
Please select where to store the key: 2 (Encryption)
    
gpg> key 2      # Désélection de la seconde sous-clé
gpg> key 3      # Sélection de la troisième sous-clé à transférer
gpg> keytocard  # Déplacement de la clé sur la carte à puce
Please select where to store the key: 3 (Authentication)
    
gpg> quit
Save changes? (y/N) y
{{< /highlight >}}

Maintenant que les sous-clés ont été déplacées sur la Yubikey, si nous listons les clés, nous verrons qu'elles ne sont plus stockées localement mais pointent vers la carte à puce (Le suffixe **>** signifie "pointeur vers une clé") :

{{< highlight bash >}}
debian:~$ gpg2 --list-secret-keys
sec#  rsa4096/0x788FC46C8BB350B8 2018-06-15 [C] [expires: 2019-06-15]
Key fingerprint = 1523 4153 E3D0 76C2 72E0  1D31 788F C46C 8BB3 50B8
uid                   [ultimate] Wandrille &lt;contact at vonkrafft dot fr&gt;
ssb>  rsa2048/0x9DAAB9EBD88FFC37 2018-06-15 [S]
ssb>  rsa2048/0x9C892908F2535889 2018-06-15 [E]
ssb>  rsa2048/0xE69F0992A12AD72E 2018-06-15 [A]
{{< /highlight >}}

## Utiliser la Yubikey avec GPG/SSH Agent

Maintenant que vous avez votre clé PGP fraichement générée et sécurisée sur votre Yubikey, vous pouvez utiliser vos sous-clés pour notamment signer et/ou le chiffrer vos mails et documents. La sous-clé d'authentification peut également être utilisé pour se connecter en SSH. C'est ce cas-là qui va nous intéresser ici et nous allons configurer `gpg-agent`. Vous utilisez déjà sans doute `ssh-agent`, et bien `gpg-agent` intègre les fonctionnalités de `ssh-agent` et permet d'utiliser vos
clés PGP en plus de vos clés SSH classiques.

{{< highlight bash >}}
debian:~$ echo "use-agent" >> ~/.gnupg/gpg.conf                                  # GnuPG essayera de se connecter à l'agent avant de demander une passphrase
debian:~$ echo "enable-ssh-support" >> ~/.gnupg/gpg-agent.conf                   # Activer le support de SHH
debian:~$ echo "write-env-file $HOME/.gpg-agent-info" >> ~/.gnupg/gpg-agent.conf # Fichier dans lequel se trouvent les variables d'environnement, notamment le nom du socket
debian:~$ echo "source ~/.gpg-yubikey" >> ~/.zshrc                               # Ou ~/.bashrc, ou autre ...
{{< /highlight >}}

La dernière ligne, ajoutée au fichier `~/.zshrc` (ou `~/.bashrc` selon votre shell), permet de démarrer automatiquement l'agent GPG lors de l'ouverture d'un émulateur de terminal. Pour cela, j'ai préféré ajouter les commandes dans un fichier séparé `~/.gpg-yubikey` pour définir les variables d'environnement et de démarrer l'agent GPG :

{{< highlight shell >}}
if [ ! -f "${HOME}/.gpg-agent-info" ] && [ -S "${HOME}/.gnupg/S.gpg-agent" ] && [ -S "${HOME}/.gnupg/S.gpg-agent.ssh" ]; then
    echo "GPG_AGENT_INFO=${HOME}/.gnupg/S.gpg-agent" >> "${HOME}/.gpg-agent-info";
    echo "SSH_AUTH_SOCK=${HOME}/.gnupg/S.gpg-agent.ssh" >> "${HOME}/.gpg-agent-info";
fi

if [ -f "${HOME}/.gpg-agent-info" ]; then
    . "${HOME}/.gpg-agent-info"
    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
    export GPG_TTY=$(tty)
    gpg-connect-agent updatestartuptty /bye >& /dev/null
fi
{{< /highlight >}}

Maintenant, à chaque ouverture d'un émulateur de terminal, l'agent GPG sera lancé (s'il ne l'est pas déjà) avec support du SSH. Nous pouvons toujours utiliser la commande `ssh-add` comme avant pour ajouter des clés SSH à l'agent et lorsque la Yubikey est branchée, les clés sont automatiquement ajoutées à l'agent GPG.

{{< highlight bash >}}
debian:~$ ssh-add -L
ssh-rsa AAAA[...]UhB9OUWmkFt5DFMrJpYAhSuz cardno:000..........
ecdsa-sha2-nistp521 AAAA[...]EHrYHEkXOQ== ~/.ssh/id_ecdsa
ssh-rsa AAA[...]ZC0ktDvMBKLKHdp9iIJnbswm3 ~/.ssh/id_rsa
{{< /highlight >}}

Il ne nous reste plus qu'à exporter la clé publique et la copier sur le serveur dans le fichier `~/.ssh/authorized_keys`.

{{< highlight bash >}}
debian:~$ gpg2 --export-ssh-key 788FC46C8BB350B8 > ~/.ssh/yubikey.pub
{{< /highlight >}}

Vous pouvez également modifier votre fichier de configuration `~/.ssh/config` pour utiliser la clé publique et l'agent GPG se chargera du reste ...

{{< highlight plaintext >}}
Host serveur
    Hostname 192.168.0.1
    User root
    IdentityFile ~/.ssh/yubikey.pub
{{< /highlight >}}

---

**Edit 2019-03-07**

Si vos clés PGP ne sont pas ajoutées à l'agent GPG (i.e. non visibles dans le résultat de la commande `ssh-add -L`) et que vous obtenez l'erreur `gpg --card-status` pour la commande `gpg: error getting version from 'scdaemon': No SmartCard daemon`, pensez à installer les paquets `pcscd`, `scdaemon` et `pcsc-tools` :

{{< highlight bash >}}
debian:~$ gpg --card-status
gpg: error getting version from 'scdaemon': No SmartCard daemon
gpg: la carte OpenPGP n'est pas disponible : No SmartCard daemon
debian:~$ sudo apt install pcscd scdaemon pcsc-tools
debian:~$ gpg --card-status
Reader ...........: Yubico Yubikey NEO OTP CCID 00 00
# ... [cropped result]
{{< /highlight >}}

---

#### Sources

1. [Using Your YubiKey with OpenPGP](https://support.yubico.com/support/solutions/articles/15000006420-using-your-yubikey-with-openpgp) (EN)
2. [Anatomy of a GPG Key](https://davesteele.github.io/gpg/2014/09/20/anatomy-of-a-gpg-key/) (EN)
3. [Setting up GnuPG + Yubikey on NixOS for SSH authentication](https://rzetterberg.github.io/yubikey-gpg-nixos.html) (EN)
4. [Install YubiKey NEO's GPG Ubuntu 14.04](https://gist.github.com/pietroalbini/b218ee9bf4316454ad9f) (EN)
5. [Configuring Yubikeys, GPG, and Keybase](https://ttmm.io/tech/yubikey/) (EN)
6. Le script `gpg-yubikey` n'est pas de moi, mais impossible de retrouver la source ...

