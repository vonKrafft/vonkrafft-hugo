---
title: "Se connecter en SSH à son VPS"
description: "Dans le tutoriel suivant, nous allons voir comment nous connecter en SSH à un serveur VPS"
tags: [ "VPS", "Admin Système", "SSH", "RSA", "Authentification", "Clé", "Sécurité", "Serveur" ]
lastmod: "2016-05-11 21:01:43"
date: "2016-01-19 12:19:17"
categories:
    - "Console"
type: post
slug: "connecter-ssh-vps"
cover: "/media/2016/01/597378aff3d794da6abd242d9a708295.jpg"
---

Dans le tutoriel suivant, nous allons voir comment nous connecter en SSH à un serveur VPS, une manière simple et sécurisée pour administrer le serveur à distance.

<!--more-->

{{< alert "warning" question-circle >}}Un serveur VPS, une connexion SSH, mais qu’est-ce que c‘est ?{{< /alert >}}

Un serveur VPS (de l’anglais Virtual Private Server) est une façon de partitionner un serveur en plusieurs serveurs virtuels indépendants qui ont chacun les caractéristiques logicielles d'un serveur dédié, en utilisant des techniques de virtualisation. Chaque serveur peut fonctionner avec un système d'exploitation différent et redémarrer indépendamment.

L’administration d’un VPS se fait à distance, et dans notre cas nous utiliserons SSH. Le protocole SSH (de l'anglais Secure Shell) impose une authentification lors de la création de la connexion. Une fois cette connexion établie, les échanges se font de façon sécurisée entre le client (nous) et le serveur (notre VPS).

Dans la suite des manipulations, j’aurais la configuration suivante :

- Notre machine client depuis laquelle nous nous connecterons à notre serveur : elle porte le nom de “stargazer” ;
- Notre serveur VPS qui tourne via le logiciel VirtualBox sur notre machine client : il porte le nom de “farragut” avec l’adresse `farragut.server`.

Un client et un serveur SSH sont respectivement installés sur “stargazer” et “farragut”. L’utilisateur client est “vonkrafft” et un autre utilisateur “vonkrafft” existe sur le VPS.

{{< alert "success" check-circle >}}**ASTUCE** : Comme vous pouvez le voir, j’ai une adresse personnalisée pour mon VPS alors que je travail en local (càd sur mon réseau privé derrière ma box Internet). Pour en savoir plus, je vous invite à lire [comment renommer votre serveur sur votre réseau local](/console/donner-nom-dns-a-serveur-local/).{{< /alert >}}

## Connexion au serveur

Pour nous connecter au serveur, rien de plus simple. Je me connecte grâce par SSH en tant que “vonkrafft” sur le VPS. Après avoir exécuté la commande, le serveur me demande mon mot de passe, je le saisi et c’est terminé : me voilà connecté au serveur.

{{< code lang="console" icon="code" title="Console" >}}
vonkrafft@stargazer:~$ ssh vonkrafft@farragut.server
vonkrafft@farragut.server's password:

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
You have mail.
Last login: Thu Dec 18 18:08:28 2015 from stargazer
vonkrafft@farragut:~$
{{< /code >}}

Comme vous pouvez le constater, j’ai du rentrer mon mot de passe, et cela va être le cas à chaque fois que je vais me connecter. Pour me faciliter les choses, nous allons mettre en place une authentification par clé.

## Générer une paire de clés RSA

Avant toute chose, il nous faut une paire de clés RSA privée/publiques.

{{< alert "warning" question-circle >}}Une clé RSA, c’est quoi, et pour quoi faire ?{{< /alert >}}

Le chiffrement RSA (nommé par les initiales de ses trois inventeurs Ronald Rivest, Adi Shamir et Leonard Adleman) est un algorithme de cryptographie asymétrique. Il repose sur l'utilisation d'une clé publique (qui est diffusée) et d'une clé privée (gardée secrète), l'une permettant de chiffrer le message et l'autre de le déchiffrer. Ainsi, l'expéditeur peut utiliser la clé publique du destinataire pour chiffrer un message que seul le destinataire (en possession de la clé privée) peut déchiffrer, garantissant la confidentialité du contenu.

Il existe 2 types de clés : RSA et DSA. Chacune pouvant être de longueur différente : 1024, 2048, 4096 bits (les clés inférieures à 1024 bits sont à proscrire... surtout les RSA). Pour créer une clé DSA de 2048 bits : `ssh-keygen -t dsa -b 2048`. Sans paramètres, les options par défaut sont type RSA en 2048 bits.

Pour générer notre paire de clés, il suffit d’utiliser l'outil mis à disposition par le paquet SSH. Nous allons donc créer deux clés RSA de 4096 bits que je stocke sur ma machine client dans le répertoire `/home/vonkrafft/.ssh` :

{{< code lang="console" icon="code" title="Console" >}}
vonkrafft@stargazer:~$ ssh-keygen -t rsa -b 4096
Generating public/private rsa key pair.
Enter file in which to save the key (/home/vonkrafft/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/vonkrafft/.ssh/id_rsa.
Your public key has been saved in /home/vonkrafft/.ssh/id_rsa.pub.
The key fingerprint is:
09:69:5a:98:af:43:0f:72:1b:e7:fd:58:1b:41:d0:26 vonkrafft@stargazer
{{< /code >}}

{{< alert "info" info-circle >}}**NOTE :** J’ai choisi une taille de clé RSA de 4096 bits, vous pouvez bien évidement choisir DSA et/ou une autre taille de clé.{{< /alert >}}

Lors de la génération des clés, je suis invité à renseigner une passphrase.

{{< alert "warning" question-circle >}}Une passphrase, mais qu’est-ce que c’est encore que ça ?{{< /alert >}}

Vous connaissez déjà les password (ou mot de passe dans la langue de Molière). Les passphrase sont des mots de passe très long qui ont été nommé ainsi pour les différencier des des mots de passe plus courts. Aisni, nous avaons les phrases (longues) de passe, et les mots (courts) de passe. Cela permet à l’utilisateur de saisir une phrase de quelques mots facile à retenir mais difficile à casser. Pourquoi donc ? Parce que le niveau de complexité augmente de façon plus qu’exponentielle avec le nombre des caractères, en particulier quand on commence à découper en mots.

La passphrase est optionnelle. Mais je vous conseille d'entrer une passphrase: elle sert à chiffrer symétriquement la clé privée, ajoutant ainsi une couche de sécurité supplémentaire.

## Activer l’authentification par clé

Voilà, on a une paire de clés, c’est bien beau tout ça mais j’en fais quoi ? Je vais commencé par copier ma clé publique sur le serveur VPS. Deux façon de faire ça. La première est de copier la clé manuellement :

{{< code lang="console" icon="code" title="Console" >}}
vonkrafft@stargazer:~$ scp ~/.ssh/id_rsa.pub vonkrafft@farragut.server:/home/vonkrafft/.ssh/authorized_keys
{{< /code >}}

Ou alors, mieux, nous utilisons la commande `ssh-copy-id` :

{{< code lang="console" icon="code" title="Console" >}}
vonkrafft@stargazer:~$ ssh-copy-id -i ~/.ssh/id_rsa.pub vonkrafft@farragut.server
{{< /code >}}

Du coté de notre VPS maintenant. Nous avons récupéré la clé publique du client, il faut maintenant paramétrer le daemon SSH pour qu’il accepte les connexions avec une clé. Pour cela, il suffit de modifier le fichier `/etc/ssh/sshd_config`. Il faut ensuite rechercher les options suivantes pour leur attribuer les bonnes valeurs :

{{< code lang="plaintext" icon="file-text-o" title="/etc/ssh/sshd_config" >}}
PubkeyAuthentication            yes
AuthorizedKeysFile              %h/.ssh/authorized_keys
ChallengeResponseAuthentication yes
{{< /code >}}

Au passage, nous pouvons en profiter pour désactiver la connexion SSH en tant que root afin de réduiore la surface d'attaque de notre serveur. Si vous avez besoin de vous connecter à votre VPS en tant que root, ne désactivez pas cette option, mais à vos risques et périls.

{{< code lang="plaintext" icon="file-text-o" title="/etc/ssh/sshd_config" >}}
PermitRootLogin no
{{< /code >}}

{{< alert "info" info-circle >}}**NOTE** : Il est possible de désactiver l’authentification par mot de passe sur le VPS afin que seuls les clients avec une clé soient autorisés à se connecter. Pour cela il faut modifier la valeur de `PasswordAuthentication` à `no`.{{< /alert >}}

J’indique au daemon SSH qu’il trouvera la clé publique dans le fichier `~/.ssh/authorized_keys` de l’utilisateur concerné. Il faut ensuite redémarrer le daemon SSH pour appliquer les modifications :

{{< code lang="console" icon="code" title="Console" >}}
vonkrafft@farragut:~$ sudo service ssh reload
{{< /code >}}

Voilà tout est prêt ! Je test la connexion et … on me demande ma passphrase. Nous avons donc troqué un mot de passe contre une passphrase encore plus longue à saisir …

## ssh-agent

Le serveur SSH est maintenant plus sécurisé, mais taper des passphrases à longueur de journée peut se révéler être très pénible surtout si on a choisi une « vraie » et longue passphrase.

L'agent SSH permet de taper la passphrase une seule fois et de la conserver en mémoire pendant tout son fonctionnement. Les déchiffrement de la clé privée se fera donc de façon transparente en local.

Pour lancer l’agent SSH, il suffit d’exécuter la commande `ssh-agent`. Ensuite, nous ajoutons notre clé privée à l’agent avec `ssh-add` :

{{< code lang="console" icon="code" title="Console" >}}
vonkrafft@stargazer:~$ ssh-agent
vonkrafft@stargazer:~$ ssh-add
Enter passphrase for /home/vonkrafft/.ssh/id_rsa:
Identity added: /home/vonkrafft/.ssh/id_rsa (/home/vonkrafft/.ssh/id_rsa)
{{< /code >}}

Et lorsque nous nous reconnectons à notre VPS, nous n’avonsi plus besoin de saisir ni mot de passe ni passphrase.

{{< code lang="console" icon="code" title="Console" >}}
vonkrafft@stargazer:~$ ssh vonkrafft@farragut.server
Last login: Fri Dec 18 18:40:15 2015 from stargazer
vonkrafft@farragut:~$
{{< /code >}}

Voilà, la connexion à notre VPS se fait de manière sécurisée grâce à nos clés RSA (4096 bits ça fait une bonne sécurité, bonne chance pour décrypter les communications …) et nous n’aurons plus besoin de saisir la passphrase tant que l’agent SSH tournera.

## Conclusion : se connecter en SSH

Nous avons donc vu comment sécuriser une connexion SSH grâce à une authentification par clé, et nous avons mis en place un agent SSH pour nous connecter sans avoir à saisir notre passphrase plusieurs fois. Petit rappel de la procédure :

- Générer une paire de clés RSA, sécurisé par une passphrase, et les stocker dans `~/.ssh` sur le poste du client
- Copier la clé publique dans le répertoire `~/.ssh` du VPS avec le nom `~/.ssh/authorized_keys`
- Activer l’authentification par clé sur le VPS et indiquer au deamon ssh où trouver la clé publique du client
- Utiliser un agent ssh sur le client pour mémoriser la passphrase et éviter de la saisir plusieurs fois.

## Aller plus loin

### Préciser le port utilisé

Par défaut, le protocole SSH utilise le port 22. Mais il est tout à fait possible de configurer son serveur pour que le deamon ssh écoute sur un port différent. Ensuite, pour se connecter au serveur, nous devons utiliser l’option `-p` suivie du numéro de port :

{{< code lang="console" icon="code" title="Console" >}}
vonkrafft@stargazer:~$ ssh -p 4242 vonkrafft@voyager.server
{{< /code >}}

### Plusieurs clés pour plusieurs serveurs SSH

Il est possible de spécifier quelle clé il faut utiliser lors de la connexion SSH. Pour cela, il faut utiliser l’option `-i` suivie du chemin de la clé :

{{< code lang="console" icon="code" title="Console" >}}
vonkrafft@stargazer:~$ ssh -i ~/.ssh/id_rsa_farragut vonkrafft@farragut.server
{{< /code >}}

### Simplifier les connexions avec un fichier de config

Vous me direz que c’est fastidieux de devoir saisir les options, l’utilisateur et l'hôte à chaque fois, et vous aurez bien raison. Mais rassurez-vous, il existe une façon de mémoriser ce choix. Pour cela, nous allons créer le fichier `~/.ssh/config` sur le poste client et y inscrire les lignes suivantes :

{{< code lang="plaintext" icon="file-text-o" title="~/.ssh/config" >}}
Host farragut
    HostName farragut.server
    User vonkrafft
    IdentityFile ~/.ssh/id_rsa
Host voyager
    HostName voyager.server
    User vonkrafft
    Port 4242
    IdentityFile ~/.ssh/id_rsa_home
{{< /code >}}

Nous pouvons à présent nous connecter rapidement à deux hôtes (farragut et voyager) avec deux clés différentes et sans préciser d’option lors de la connexion.

{{< code lang="console" icon="code" title="Console" >}}
vonkrafft@stargazer:~$ ssh farragut
{{< /code >}}
