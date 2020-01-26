---
title: "Les mots de passe : les bonnes pratiques"
description: "Entre les politiques de mots de passe non adaptées et un stockage aussi chaotique qu’hétéroclite, les accès à nos mots de passe (et par conséquent à nos comptes) sont de plus en plus vulnérables."
tags: [ "Mots de passe", "hachage", "chiffrement", "RGPD", "CNIL", "vie privée", "protection" ]
lastmod: "2018-01-28 16:28:21"
date: "2018-01-28 16:28:21"
categories:
    - "Dossiers"
type: post
slug: "mots-de-passe-bonnes-pratiques"
cover: "/media/2018/01/7f81aacab375fb9fb14cc7885fdad12f.png"
---

Depuis les débuts de l’informatique, le mot de passe est le moyen le répandu de protéger un espace personnel (système d’exploitation, site Web, etc.) ou des données sensibles (chiffrement). Mais entre les politiques de mots de passe non adaptées et un stockage aussi chaotique qu’hétéroclite, les accès à nos mots de passe (et par conséquent à nos comptes) sont de plus en plus vulnérables.

<!--more-->

{{< img src="/media/2018/01/7f81aacab375fb9fb14cc7885fdad12f.png" >}}

Aujourd’hui, avec l’expansion d’Internet et la numérisation des services et des divertissements, nous faisons face à une multitude de sites Web sur lesquels nous avons un espace personnel qu’il nous faut protéger avec un mot de passe. Or, entre l’utilisateur qui, par flemmardise, choisi un mot de passe faible et les sites Web qui chacun de leur côté implémentent une gestion des mots de passe pas toujours au top, nos espaces personnels sur Internet se retrouvent de plus en plus vulnérables.

Je parlerai ici uniquement du mot de passe comme moyen de s’authentifier, notamment sur une application Web. Il existe d’autres moyens de s’authentifier, tels que les certificats, la délégation d’authentification (SSO par exemple), l'empreinte biométrique, etc. Une première partie concerne principalement l’utilisateur, puis une seconde partie s’adresse plus aux développeurs.

## Bien choisir un mot de passe

Un mot de passe doit être individuel, secret, difficile à déterminer via une attaque de type « Brute-Force » et changé si l’on pense qu’il a été compromis. Pour répondre à ces exigences, on a déjà tous rencontré des règles imposées au moment de choisir et/ou d’utiliser un mot de passe :

- La taille, souvent 8 caractères minimum ;
- L’entropie, imposant généralement d’utiliser 3 types de signes parmi les 4 possibles (minuscule, majuscule, chiffre et caractères spéciaux) ;
- Le verrouillage en cas d’un certain nombre d’échec (pensez aux smartphone qui se bloquent plus ou moins longtemps après 5 échecs d’authentification) ;
- Le renouvellement fréquent (l’ANSSI préconise un [renouvellement trimestriel des mots de passe](https://www.ssi.gouv.fr/guide/mot-de-passe/)), et l’impossibilité de réutiliser les N derniers mots de passe utilisés ;
- Changement obligatoire lorsque l’utilisateur n’a pas choisi son mot de passe (par exemple, lors de la génération d’un mot de passe temporaire lors de la procédure de réinitialisation de mot passe).

### Anecdotes ...

J’en profite pour pousser un coup de gueule envers les sites Web qui limitent le nombre et/ou le type de caractères que l’on peut utiliser. J’ai déjà rencontré les cas suivants :

<div class="pull-right hidden-xs hidden-sm">{{< tweet 940170499354750981 >}}</div>

- **« [Mot de passe sans accents, tirets ou espaces](https://twitter.com/von_Krafft/status/940170499354750981) »** : Non mais sérieux ?!? Qu’est-ce qui poussent les développeurs à interdire ce genre de caractères ? L’encodage de la base de données dans lequel le mot de passe est stocké ? Parce qu’à moins de stocker mon mot de passe en clair, les caractères spéciaux dans un mot de passe ne posent aucun problème technique !
- **« [Le mot de passe ne doit pas excéder 14 caractères](https://twitter.com/von_Krafft/status/953742996910075904) »**, sinon quoi ? Si je choisis un mot de passe de 15 caractères j’explose ta base de données dans lequel tu as prévu un VARCHAR(14) pour stocker mon mot de passe en clair ?
- **« Vous avez oublié votre mot de passe, il vous a été renvoyé par mail »** pardon ? Ah oui, mon mot de passe en clair dans un mail ... Faîtes attention, l’entrée en vigueur du [RGPD](https://en.wikipedia.org/wiki/General_Data_Protection_Regulation) c’est en mai 2018 ...
- **« Vous avez oublié votre mot de passe, un nouveau mot de passe temporaire vous a été envoyé par mail »** Très bien. Je me connecte donc avec ce mot de passe temporaire et je serais forcé de le changer ... et non ! Du coup je ne vois pas trop ce qu’il a de « temporaire » ce mot de passe ...

Bref, laissez-nous choisir les mots de passe que l’on veut, pour peu qu’ils respectent les règles de sécurité citées plus haut. Et par pitié, supprimez vos règles contre-productives sur la sécurité d’un mot de passe !

#### Quid des règles actuelles de politique de mot de passe ?

Parce que oui, les règles citées ci-dessus sont présentes depuis un certain temps et sont peu à peu entrées dans l’inconscient collectif. Mais ces règles sont-elles efficaces ? Le débat est encore ouvert à l’heure actuelle, mais certaines personnes, comme moi, doutent de leur efficacité en termes de robustesse et sécurité.

Prenons par exemple le mot de passe `P@ssword01` : c’est un mot de passe de 10 caractères avec des minuscules, une majuscule, des chiffres et un caractère spécial. Bref, d’après les règles actuelles, c’est un mot de passe « robuste ». Oui ... mais non, vous vous doutez bien qu’un tel mot de passe se devine facilement. Des dictionnaires de mots de passe fréquemment utilisés existent et permettre de deviner (très) rapidement ce genre de mot de passe.

Vous me direz qu’il suffit de complexifier le mot de passe, par exemple `k4dUj@gD_8` (pardon, j’ai éternué sur mon clavier). Hum ... d’accord, et comment retenir ce mot de passe ? Parce que si nous n’avions seulement qu’un seul mot de passe à retenir ça serait réalisable, mais nous utilisons des dizaines de comptes !

{{< alert warning warning >}}Si vous utilisez un seul mot de passe pour tous vos comptes, j’espère au moins que vous culpabilisez ... Quoi qu'il en soit, je vous invite à rapidement changer tous vos mots de passe et à définir un mot de passe unique pour chacun de vos comptes !{{< /alert >}}

Bref, un mot de passe ne peut pas à la fois se retenir facilement, respecter la règle de 8 caractères dont 3 types de signes parmi les 4 possibles, et être absent des dictionnaires de mots de passe. Les politiques de mots de passe établies depuis ces dernières années forcent les utilisateurs à choisir des mots de passe difficiles à mémoriser et faciles à casser ...

{{< img src="/media/2018/01/68de6ae4ad54fc3bfc1a8677117dc605.png" alt="xkcd" link="/media/2018/01/68de6ae4ad54fc3bfc1a8677117dc605.png" >}}

Un autre point à prendre en compte est l’entropie. L’entropie correspond à la quantité d’information contenue dans le mot de passe. On peut la comparer à l’incertitude que l’on a sur ce dernier. Il existe plusieurs méthodes pour calculer l’entropie d’un mot de passe, certains calculs prenant en comptes des répétitions de caractères successifs ou encore intégrant des dictionnaires de mots de passe fréquents.

Dans notre cas, nous prendrons <code>H = log<sub>2</sub>(N<sup>L</sup>) = L &times; ( log(N) / log(2) )</code>.

| Mot de passe              | Taille (N) | Alphabet (L) | Entropie (H) |
| ------------------------- | ---------- | ------------ | ------------ |
| P@ssword01                | 9          | 10           | 32           |
| k4dUj@gD_8                | 10         | 10           | 33           |
| MonSuperMotDePasse        | 13         | 18           | 67           |
| Tr0ub4dor&3               | 10         | 11           | 37           |
| correcthorsebatterystaple | 13         | 25           | 93           |

On voit bien qu’un mot de passe simple à retenir de 18 caractères mêlant uniquement minuscule et majuscule possède une entropie nettement plus élevée que notre mot de passe `k4dUj@gD_8`.

{{< alert success lightbulb-o >}}La longueur d’un mot de passe est à privilégier par rapport à la diversité de ses caractères.{{< /alert >}}

Attention, je ne dis pas qu’il ne faut pas utiliser des caractères variés pour un mot de passe : un mot de passe constitué d'un seul caractère répété N fois a une entropie de 1 ! L'idéal est de choisir plusieurs mots que l'on colle les uns après les autres. Le mot de passe est donc amené à devenir une phrase de passe (passphrase en anglais), plus facile à retenir pour un utilisateur et plus long à casser pour un ordinateur.

Dernier point : le renouvellement fréquent des mots de passe. C’est une fausse bonne idée. En effet, un utilisateur qui doit changer tous les trimestres son mot de passe sera plus enclin à choisir un mot de passe faible, voire même incrémenter un compteur placé à la fin d’un mot de passe invariant.

Si le mot de passe est robuste et qu’il n’y a pas de raison de penser qu’il a été compromis, pourquoi le changer ? Toute la difficulté réside dans les moyens mis en place pour forcer l’utilisateur à choisir un mot de passe robuste.

### Guider le choix mots de passe

Simplement imposer des règles ne suffit pas pour le choix d’un mot de passe. L’utilisateur va voir ces règles comme une nuisance et va mettre en place une stratégie d’évitement, préférant choisir le mot de passe le plus simple satisfaisant les règles imposées (tel que `P@ssword01`).

Pour éviter ce genre de mot de passe, on peut envisager l’utilisation de dictionnaire lors du choix du mot de passe (j’ai déjà vu certains sites faire ça en JavaScript). Mais cela impose d’avoir recours à des ressources volumineuses (les dictionnaires comptant souvent quelques Gigas de données) et n’est pas forcément adapté à une application Web.

Une solution qui a fait ses preuves est le nudge ([source](https://www.ece.cmu.edu/~lbauer/papers/2012/usenix2012-meters.pdf)). Terme anglais qui n’a pas d’équivalent en français, un nudge est une modification infime de notre environnement qui modifie de façon concrète notre comportement. Sans le savoir, vous en avez déjà croisé :

{{% gallery columns="3" title="Exemples de nudge (en gare, pour encourager l'utilisation des escalier, pour adapter sa vitesse)" %}}
{{< gallery_item src="/media/2018/01/4f660580d0116a21be0d100add83ee49.png" alt="Guide gare" link="/media/2018/01/4f660580d0116a21be0d100add83ee49.png" >}}
{{< gallery_item src="/media/2018/01/d1d7e52f82413b010434fa7ec3baf4fb.png" alt="Escaliers piano" link="/media/2018/01/d1d7e52f82413b010434fa7ec3baf4fb.png" >}}
{{< gallery_item src="/media/2018/01/4edf1d11f265ddfa22bf2ac2f6ec4b43.png" alt="Radar éducatif" link="/media/2018/01/4edf1d11f265ddfa22bf2ac2f6ec4b43.png" >}}
{{% /gallery %}}

Nous avons vu plus haut la notion d’entropie. On peut facilement mettre en place une échelle qui évolue selon l’entropie du mot de passe saisi par l’utilisateur. Google, KeePass, WordPress et d’autres ont déjà mis en place ce type d’indicateur pour inciter l’utilisateur à choisir un mot de passe fort.

{{% gallery columns="2" %}}
{{< gallery_item src="/media/2018/01/897181580aa3737af3def1f474307b6f-300x175.png" alt="Nudge Gmail" link="/media/2018/01/897181580aa3737af3def1f474307b6f.png" >}}
{{< gallery_item src="/media/2018/01/7a57fa91e73a2dc47397fa055e803a10-300x175.png" alt="Nudge KeePass" link="/media/2018/01/7a57fa91e73a2dc47397fa055e803a10.png" >}}
{{% /gallery %}}

### Les gestionnaire de mot de passe

Une dernière problématique est la diversité de ses mots de passe. En effet, face aux multiples sites Web pour lesquels nous avons besoin d’un mot de passe, il est facile de se dire « je vais mettre le même mot de passe partout ». Surtout, ne faîtes pas ça !

Une première solution consiste à enregistrer le mot de passe dans le navigateur (Firefox, Chrome, Safari, Edge, etc.). Mais attention, en fonction du navigateur et de la configuration de ce dernier, vos mots de passes ne sont pas forcément protégés en cas de compromission de votre PC.

L’autre solution est d’utiliser un gestionnaire de mot de passe dédié, tel que KeePass, LastPass, Dashlane, 1Password, etc. Ces gestionnaires vous permettront de générer, gérer et stocker vos mots de passe, ces derniers pouvant alors être longs, complexes et uniques. Vous n’avez plus qu’à retenir un seul mot de passe, celui permettant de déverrouiller votre gestionnaire. Bien évidemment, ce dernier devra être robuste, comme une passphrase par exemple. Pour ce qui est du gestionnaire, je vous laisse choisir parmi ceux qui existent.

{{% gallery columns="4" title="KeePass, LastPass, Dashlane et 1Password" %}}
{{< gallery_item src="/media/2018/01/a1bcf0f19351f0fa1f9f8e89a49ac1e0-150x150.png" alt="KeePass" link="/media/2018/01/a1bcf0f19351f0fa1f9f8e89a49ac1e0.png" >}}
{{< gallery_item src="/media/2018/01/72265d7ad91adbfc58fbe93ea8687a55-150x150.png" alt="LastPass" link="/media/2018/01/72265d7ad91adbfc58fbe93ea8687a55.png" >}}
{{< gallery_item src="/media/2018/01/f11f23a4304b75f7428d21c4f46e189c-150x150.png" alt="Dashlane" link="/media/2018/01/f11f23a4304b75f7428d21c4f46e189c.png" >}}
{{< gallery_item src="/media/2018/01/91c4c74435e0a2548471d1f6533c102c-150x150.png" alt="1Password" link="/media/2018/01/91c4c74435e0a2548471d1f6533c102c.png" >}}
{{% /gallery %}}

## La gestion des mots de passes coté serveur

Un mot de passe est une information sensible strictement personnelle, considéré comme tel par la [CNIL](https://fr.wikipedia.org/wiki/Commission_nationale_de_l%27informatique_et_des_libert%C3%A9s_(France)) et dans le [RGPD](https://en.wikipedia.org/wiki/General_Data_Protection_Regulation). Par conséquent, les sites Web qui vous demandent de protéger votre compte avec un mot de passe doivent suivre certaines règles.

### Comment (ne pas) stocker un mot de passe ?

Lorsque vous souhaitez vous connecter à votre espace personnel sur une application Web, ce dernier doit pouvoir vérifier que vous êtes capable de lui donner le bon mot de passe. Par conséquent, l’application Web doit stocker des informations concernant votre mot passe.

Le plus simple est d’enregistrer votre mot de passe dans une base de données, tout comme le reste de vos informations personnelles (nom, prénom, mail, etc.). C’est facile, et puis en plus, si l’utilisateur a oublié son mot de passe, l’application Web est en mesure de lui renvoyer par mail. MAUVAISE IDE&Eacute; !!!

{{< alert danger exclamation-circle >}}Un mot de passe ne doit jamais, je dis bien **JAMAIS**, être stocké en clair !{{< /alert >}}

Imaginez qu’une faille du site permette d’accéder à l’ensemble de la base de données (injections SQL ([OWASP](https://www.owasp.org/index.php/SQL_Injection)), administrateur réseau malveillant, etc.) et votre mot de passe est alors compromis. 

Si un site vous envoie votre mot de passe en clair lorsque vous cliquez sur « mot de passe oublié », cela signifie probablement que ce dernier est stocké en clair dans une base de données.

Je dis « probablement », car votre mot de passe peut également être stocké chiffré. Une clé de chiffrement permet de chiffrer votre mot de passe, et sans clé de déchiffrement, votre mot de passe chiffré est inutilisable s’il venait à être volé. Cependant, les clés de chiffrement sont souvent stockées sur le serveur hébergeant la base de données, et donc une faille pourrait mener, comme avec un stockage en clair, à une divulgation de votre mot de passe.

{{< alert danger exclamation-circle >}}Chiffrer les mots de passe est une fausse bonne idée ...{{< /alert >}}

Mais alors comment l’application peut-elle stocker votre mot de passe sans que celui-ci ne puisse être lu par une tierce personne ? Et bien il suffit que l’application stocke le condensat du mot de passe, et non le mot de passe lui-même.

### Hacher les mots de passes

Un condensat (en anglais hash), est une chaîne de caractère de taille fixe obtenue à partir d’une entrée quelconque (chaîne de caractères, binaire, image, vidéo, etc.) à l’aide d’une fonction de hachage. Une telle fonction doit respecter les propriétés suivantes :

- Pour une entrée donnée, le condensat obtenu sera toujours le même, quelques soient la machine et le système d’exploitation sur lesquels la fonction est exécutée ;
- La sortie doit être de taille fixe ;
- Une légère modification de l’entrée doit produire un condensat sensiblement différent ;
- Il ne doit pas être possible, dans la pratique, de retrouver l’entrée à partir du condensat, et deux entrées différentes ne peuvent pas produire le même condensat (je dis « dans la pratique », et non « théoriquement », car il est trivial d’un point de vue mathématiques de montrer que cette propriété est irréalisable étant donné la caractéristique de taille fixe de la sortie).

Parmi les fonctions les plus connues, je citerais MD5, SHA-1 et SHA-2. Certains de ces algorithmes ne satisfont plus l’ensemble des propriétés, notamment les collisions (deux entrées qui produisent le même condensat) qui ont été prouvées comme réalisables pour MD5 et SHA-1.

Vous avez remarqué qu’un condensat est une chaîne de caractères de taille fixe. J’y ajouterai que ces caractères sont alphanumériques. Donc si une application Web limite la taille des mots de passe, ou interdit certains caractères spéciaux, cela signifie probablement que ce dernier est stocké en clair dans une base de données.

{{< alert success lightbulb-o >}}Il est donc recommander de stocker les condensats des mots de passe et d’utiliser la fonction de hachage SHA-2, ou ses dérivés (SHA-256, SHA-224, SHA-512 ou SHA-384).{{< /alert >}}

### Assaisonnons les condensats

Les mots de passe sont à présents stockés hachés dans la base de données de l’application, mais des problèmes de sécurité subsistent :

- Deux utilisateurs qui ont le même mot de passe ont donc le même condensat. En triant la liste des utilisateurs selon les valeurs des condensats, il sera facile de savoir quels mots de passe attaquer en priorité.
- Des dictionnaires existent pour les algorithmes de hachage, permettant de se passer des étapes de calcul du condensat et permettant de retrouver les mots de passes les plus fréquemment utilisés.

Que faire ? Et bien il suffit de « saler » le mot de passe, voire même le « poivrer ».

{{< alert info >}}<i class="fa fa-question-circle"></i> Non mais attends, on n’est pas dans un cours de cuisine ici ...{{< /alert >}}

Afin de pallier au premier problème et éviter que deux utilisateurs avec le même mot de passe aient le même condensat, il suffit de concaténer le mot de passe avec une chaîne aléatoire propre à chaque utilisateur, que l’on appelle « sel » (en anglais salt).

{{< highlight python >}}
hash_pwd = SHA512(clear_pwd + salt)
{{< /highlight >}}

Il est également possible de concaténer une seconde chaîne de caractère commune à tous les utilisateurs : le « poivre » (en anglais pepper). Le poivre ne doit JAMAIS être stocké dans la base de données. Ainsi, si la base de données venait à être compromise (et uniquement la base de données), alors les condensats salés et poivrés seraient inexploitables.

{{< highlight python >}}
hash_pwd = SHA512(clear_pwd + salt + pepper)
{{< /highlight >}}

Enfin, une dernière mesure de protection qu’il est possible de mettre en place est l’itération. Hacher une fois le mot de passe salé et poivré, c’est bien, et le hacher 1000 fois, c’est mieux. Cela rallongera le temps nécessaire pour casser le condensat du mot de passe.

### Des fonctions de hachages « sécurisées »

Maintenant que l’on a listé les bonnes et mauvaises pratiques qu’un site Web peut mettre en œuvre pour protéger votre mot de passe, je vous propose trois petites fonctions pour résumer tout ça :

{{< highlight python >}}
pepper = conf['PEPPER']

def hash_password(password, salt, iterations=1000):
	hashed_password = password + salt + pepper
	for i in range(iterations):
		hashed_password = hashlib.sha512(hashed_password)
	return hashed_password

def create_password(password, iterations=1000):
	salt = uuid.uuid4().hex
	return hash_password(password, salt, iterations) + ':' + salt

def check_password(hashed_password, user_password, iterations=1000):
	password, salt = hash_password.split(':')
	return password == hash_password(user_password, salt, iterations)
{{< /highlight >}}

Selon les langages de programmation, des fonctions de hachage existent déjà et ce n'est pas obligatoire de réinventer la roue. Parmi les fonctions les plus connues, je peux citer [Bcrypt](https://fr.wikipedia.org/wiki/Bcrypt), [Argon2](https://fr.wikipedia.org/wiki/Argon2), [Scrypt](https://fr.wikipedia.org/wiki/Scrypt) ou encore [PBKDF2](https://fr.wikipedia.org/wiki/PBKDF2). Il faudra néanmoins fournir le sel en paramètre, fournir le poivre dans le mot de passe, et certaines fonction limite la taille de l'entrée (comme [Bcrypt](https://fr.wikipedia.org/wiki/Bcrypt) par exemple).

### Le transport du mot de passe

Lorsque vous saisissez votre mot de passe dans le formulaire d’authentification d’un site Web puis que vous validez, il est alors envoyé vers le serveur hébergeant ce site. Votre mot de passe est alors vulnérable, et tout comme lors de son stockage, il doit être protégé lors de son transport entre vous et le serveur.

La première chose à faire est de mettre en place HTTPS sur le serveur de l’application. Cela permettra de chiffrer les communications entre votre navigateur et le site Web vers lequel vous envoyez votre mot de passe. L’article ne portant pas sur HTTPS, je ne vais pas m’attarder sur ce point. Sachez simplement qu’en 2018, c’est tellement simple d’obtenir un certificat (avec des entités telles que [Let’s Encrypt](https://letsencrypt.org/)) que tout, je dis bien TOUT les site Web impliquant le transfert de données sensible doivent imposer l’utilisation du protocole HTTPS avec une configuration durcie.

Enfin, une mesure de protection supplémentaire consiste à hacher le mot de passe coté client en utilisant du JavaScript. Ainsi, même si la requête HTTP est interceptée, le condensat qu’elle comporte ne sera pas (ou difficilement) exploitable. Pour cela, il nécessaire d’envoyer le sel au client pour le calcul du condensat salé. Il est aussi possible de ne pas salé le mot de passe coté client et simplement le hacher.

- Coté client : `client_pwd = SHA512(pwd)`
- Coté serveur : `server_pwd = SHA512(client_pwd + salt + pepper)`

Si vous avez bien suivi, le poivre est secret et ne doit pas quitter le serveur sur lequel il a été généré. Il ne faut surtout pas envoyer le poivre au client !

# Conclusion

Le mot de passe est souvent maltraité, accusé d'être le maillon faible de la protection des espaces personnels. Mais il suffirait de revoir les politiques de mots de passe et s'assurer du bon stockage de ce dernier :

- Stocker des condensats de mots de passe salés et poivrés, en utilisant un algorithme de hachage robuste (bannir MD5 et SHA-1) ;
- Définir de nouvelles règles pour la création d'une « phrase de passe » :
	- Imposer une taille de 15 ou 20 caractères, forçant l'utilisateur à choisir une phrase plutôt qu'un mot ;
	- Ne plus imposer la compléxité mais la « nudger », en modifiant l'interface de choix du mot de passe à l'aide de nudges pour guider l'utilisateur via des indicateurs ;
	- Le renouveller seulement lorsque l'on suspecte que le mot de passe a été compromis ;

Vous savez quoi faire ;)  
Si vous avez d'autres idées, des conseils ou des remarques concernant cet article, n'hésitez pas à me le faire savoir !