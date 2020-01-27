---
title: "[EN] [CTF] TAMU - Scenario MCCU"
description: "Write-up for challenge 'Scenario MCCU' (Forensics, 700 pts) from TAMU CTF 2018."
tags: [ "CTF", "Forensics" ]
lastmod: 2018-02-27 20:12:54
date: "2018-02-27 19:34:07"
categories:
    - "Write-up"
type: post
slug: "ctf-tamu-scenario-mccu-700"
cover: "/media/2018/02/32e3da5062e6e33f0a2a930faab52bc0.png"
---

This was a series of challenges that involved a compromised WordPress website. Several proofs (screenshots, log extracts, WordPress archive, etc.) allowed us to answer questions.

<!--more-->

### 00\_intrusion (Scenario - MCCU, 25pt)

> The financial institution MCCU received a call from a Karen Brebs. Ms. Brebs told an employee that she was a cyber-security jounalist, and that the MCCU website had been compromised. Ms. Brebs emailed the attached screenshot.
> 
> To complete this challenge, answer the following question(s):
> 
> 1. Is this a real threat (yes/no)?
> 2. What's our next step (A: take the website offline and reinstall the website, B: leave the website up and investigate further, C: take the website offline and investigate further)?

The screenshot shows a webshell accessible from the URL https://midcoastfcu.com/wp-content/plugins/hello.php. This is a real threat for MCCU. Because the site is a WordPress, the safest way to eliminate the threat is to take the site offline and reinstall the site.

**Answers**

{{< highlight plaintext >}}
1. yes
2. A
{{< /highlight >}}

### 01\_logs (Scenario - MCCU, 50pt)

> We've made contact with the system administrator of the MCCU website - this is not something they developed.
> 
> We are waiting on more details from the administrator about the website's configuration. All we know is that it has two services - Web and SSH.
> 
> The only thing we've received so far are the logs for the web server and ssh server. MCCU really wants to know how they were compromised.
> 
> To complete this challenge, answer the following question(s):
> 
> 1. Which service was used to compromise the server (web/ssh)?
> 2. Which log file led you to this conclusion (access.log, error.log, auth.log)?
> 3. What was the IP of the suspected attacker?
> 4. What was the date of the suspected compromise (MM/DD-HH:MM:SS)?
> 5. If the attack was web based, what was the URI of the request (/images/pic.png)? Or If the attack was ssh based, what was the username the attacker compromised?

The server has been compromised through the website. It can be seen in the log file `access.log` which lists the HTTP requests received by the server. At first shy, the attacker (172.16.20.24) tests several potential flaws (HTTP downgrade, WordPress xmlrpc, etc.) before finding a vulnerable PHP page. In the `auth.log` file, we can see that a new user "admin" was created at 20:35:21. The server was probably compromised before that date. When we look at the received HTTP requests a bit earlier, we see a PHP file in the upload directory (`/wp-content/uploads/EYcNS.php`). The attacker thus found a way to upload this file, and by going back again the history, we identify the source of the compromise: `/wp-content/plugins/wpshop/includes/ajax.php`.

{{< highlight plaintext >}}
Nov  8 20:35:21 midcoastfcu useradd[1499]: new group: name=admin, GID=1000
Nov  8 20:35:21 midcoastfcu useradd[1499]: new user: name=admin, UID=1000, GID=1000, home=/home/admin, shell=/bin/sh
{{< /highlight >}}
{{< highlight plaintext >}}
172.16.20.24 - - [08/Nov/2017:20:32:49 -0900] "POST /wp-content/plugins/wpshop/includes/ajax.php HTTP/1.1" 200 61 "-" "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)"
172.16.20.24 - - [08/Nov/2017:20:32:54 -0900] "GET /wp-content/uploads/EYcNS.php HTTP/1.1" 499 0 "-" "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)"
{{< /highlight >}}

**Answers**

{{< highlight plaintext >}}
1. web
2. access.log
3. 172.16.20.24
4. 11/08-20:32:49
5. /wp-content/plugins/wpshop/includes/ajax.php
{{< /highlight >}}

### 02\_Analysis (Scenario - MCCU, 75pt)

> The administrator informed us that the server is an Ubuntu server running nginx 1.1.19 with a Wordpress 4.1.0 install.
> 
> The administrator also sent a tar of the Wordpress installation (attached).
> 
> To complete this challenge, answer the following question(s):
> 
> 1. List the plugins and their versions in lexicographic order separated by commas (alpha.1.3.4,bravo.5.4,charlie.0.3,...).
> 2. List the plugins connected to the intrusion and their versions the same way as in questions 1 (alpha.1.3.4,charlie.0.3,...).
> 3. List any CWEs for said plugins and their versions in lexicographic (CWE-NUMBER).

We now have the complete archive of the compromised Wordpress. So we just use `grep` to list the versions of the different plugins. The versions in the PHP files are not necessarily correct, so you have to look in the `readme.txt` files for the stable tag.

{{< highlight terminal >}}
host:~$ grep -nr "Stable tag" ./*
./akismet/readme.txt:6:Stable tag: 3.0.4
./contact-form-7/readme.txt:7:Stable tag: 3.1.1
./duplicate-post/readme.txt:6:Stable tag: 0.5
./jetpack/readme.txt:6:Stable tag: 2.0.7
./jetpack/modules/contact-form/readme.txt:4:Stable tag: 2.3
./jetpack/modules/sharedaddy/readme.txt:6:Stable tag: trunk
./jetpack/modules/shortcodes/videopress.php:19:Stable tag: 1.5.4
./ninja-forms/readme.txt:7:Stable tag: 1.3.5
./w3-total-cache/readme.txt:6:Stable tag: 0.7
./wpshop/readme.txt:7:Stable tag: 1.3.9.5
./wp-super-cache/readme.txt:5:Stable tag: 0.3
{{< /highlight >}}

We saw during the previous challenge that the entry point was the wpshop plugin. A small search allows to obtain the following link: https://wpvulndb.com/vulnerabilities/7830

**Answers**

{{< highlight plaintext >}}
1. akismet.3.0.4,contact-form-7.3.1.1,duplicate-post.0.5,jetpack.2.0.7,ninja-forms.1.3.5,w3-total-cache.0.7,wp-super-cache.0.3,wpshop.1.3.9.5
2. wpshop.1.3.9.5
3. CWE-434
{{< /highlight >}}

### 03\_Forensics (Scenario - MCCU, 100pt)

> Now that we have some idea of how the intrusion took place, let's take a look at what's changed since the attack.
> 
> To complete this challenge, answer the following question(s):
> 
> 1. List file paths from wordpress/ (e.g. readme.txt,wp-admin/index.php) that were created after the attack time found in challenge 01 lexicographic and separated by commas (dir/file1,dir/file2,...).
> 2. List any files that have any evidence that points to them be exfiltrated by the attacker as in question 2 (dir/file1,dir/file2,...).
> 3. List all unique sha1 hashes of these files in lexicographic order separated by commas (hash1,hash2).
> 4. What shell was used to get command execution? (e.g. /bin/bash, /bin/sh, /bin/ksh, etc...)?
> 
> This challenge uses the file found in challenge 02.

A simple search by filtering on the last edit date of the files allows to obtain the list of files created by the attacker. In the `access.log` file, we can see that only the `.mysql.db` file has been exfiltrated from the server. Finally, when we look at the content of PHP files created, we find that the shell used was `/bin/dsh`.

{{< highlight plaintext >}}
172.16.20.24 - - [08/Nov/2017:20:38:41 -0900] "GET /.mysql.db HTTP/1.1" 200 186411 "-" "Wget/1.18 (linux-gnu)"
{{< /highlight >}}
{{< highlight plaintext >}}
$shell='uname -a;w;id;pwd;/bin/dsh';
{{< /highlight >}}

{{< highlight terminal >}}
host:~$ find . -type f -newermt '2017-11-08 20:32:49' -ls
   410155    184 -rw-r--r--   1 root     www-data   186411 Nov  9 06:38 ./.mysql.db
   414710      4 -rw-rw-rw-   1 www-data www-data      538 Nov  8 23:08 ./wp-content/w3tc-cache/index.php
   414709      4 -rw-rw-rw-   1 www-data www-data      199 Nov  8 23:08 ./wp-content/w3tc-cache/.htaccess
   414711      4 -rw-rw-rw-   1 www-data www-data      342 Nov  8 23:08 ./wp-content/advanced-cache.php
   410700      8 -rw-rw-rw-   1 www-data www-data     4572 Nov  8 23:08 ./wp-content/w3-total-cache-config.php
   413876      4 -rw-r--r--   1 www-data www-data     1851 Nov  9 06:39 ./wp-content/plugins/hello.php
   414713      4 -rw-rw-rw-   1 www-data www-data      295 Nov  8 23:08 ./wp-content/db.php
   410152      4 -rw-r--r--   1 www-data www-data     1851 Nov  9 06:39 ./.wp-config.php
   410154      4 -rw-r--r--   1 www-data www-data     1851 Nov  9 06:39 ./wp-register.php
   410150      4 -rw-r--r--   1 www-data www-data     1851 Nov  9 06:39 ./wp-logout.php
{{< /highlight >}}

**Answers**

{{< highlight plaintext >}}
1. .mysql.db,.wp-config.php,wp-content/plugins/hello.php,wp-logout.php,wp-register.php
2. .mysql.db
3. 05ed0336f549d3dc47e6430e9ae85e9d25402e21
4. /bin/dsh
{{< /highlight >}}

### 04\_Privilege\_Escalation (Scenario - MCCU, 125pt)

> Now that we have a better understanding of how the attacker got in to the system, and that they had shell access, let's figure out what level of access they were able to obtain.
> 
> Attached are all history files that were found on the hard drive and the shell file you identified in challenge 03.
> 
> To complete this challenge, answer the following question(s):
> 
> 1. What was the highest level of access the attacker able to obtain (username)?
> 2. List the sha1 hash of any files that may have been used to gain the higher level of access (hash0,hash1,hash2,...).
> 3. What CVE was used to escalate privileges (CVE-YYYY-NUMBER OR MSYY-NUMBER)?
> 
> This challenge also uses the same image from challenge 02.

The attacker was able to obtain a root access on the server. He uploaded a webshell using the `ajax.php` file from the wpshop plugin, then he uploaded and executed the` / tmp / dc64` file. Then he elevated his privileges using DirtyCow root escalation privilege.

{{< highlight terminal >}}
host:~$ sha1sum 02\_analysis/evidence\_2/wordpress/wp-content/plugins/wpshop/includes/ajax.php
4efaa331787b5cc077892ded823509967287efb0  02\_analysis/evidence\_2/wordpress/wp-content/plugins/wpshop/includes/ajax.php
host:~$ sha1sum 04\_Privilege\_Escalation/evidence/dsh
4cbf8cb09a9627a1ee596df0988a99e48376b9df  04\_Privilege\_Escalation/evidence/dsh
host:~$ xxd 04\_Privilege\_Escalation/evidence/dsh | grep -C 2 Dirty
000a42b0: 7267 6574 2074 6f20 7265 7374 6f72 6520  rget to restore 
000a42c0: 2f74 6d70 2f62 616b 0000 0000 0000 0000  /tmp/bak........
000a42d0: 4469 7274 7943 6f77 2072 6f6f 7420 7072  DirtyCow root pr
000a42e0: 6976 696c 6567 6520 6573 6361 6c61 7469  ivilege escalati
000a42f0: 6f6e 0000 0000 0000 5261 6369 6e67 2c74  on......Racing,t
{{< /highlight >}}

**Answers**

{{< highlight plaintext >}}
1. root
2. 4cbf8cb09a9627a1ee596df0988a99e48376b9df,4efaa331787b5cc077892ded823509967287efb0
3. CVE-2016-5195
{{< /highlight >}}

### 05\_backdoor (Scenario - MCCU, 150pt)

> The administrator sent over the following netstat output, does anything look bad?
> 
> To complete this challenge, answer the following question(s):
> 
> 1. What IP address is the malicious program using?
> 2. What port is the malicious program using?
> 3. What is the filename of the malicious program?
> 4. What is the PID of the malicious program?

We have the result of the `netstat` command. We know the IP address of the attacker (172.16.20.24) and therefore we can see the network connections established between him and the server.

{{< highlight plaintext >}}
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 172.16.20.132:49815     172.16.20.24:4444       ESTABLISHED 889/php-fpm: pool w
tcp        0      0 172.16.20.132:49811     172.16.20.24:4444       ESTABLISHED 1448/php-fpm: pool 
tcp        0      0 172.16.20.132:80        172.16.20.24:54912      ESTABLISHED 868/nginx: worker p
{{< /highlight >}}

**Answers**

{{< highlight plaintext >}}
1. 172.16.20.24
2. 4444
3. php-fpm
4. 889
{{< /highlight >}}

### 06\_persistence (Scenario - MCCU, 175pt)

> The administrator has went ahead and updated all the Wordpress plugins, quarantined the files made by the user, and changed system credentials.
> 
> The administrator has also informed us that the admin user doesn't look familiar to them, so they sent over /etc/passwd and /etc/group.
> 
> To complete this challenge, answer the following question(s):
> 
> 1. When was the admin user created (MM/DD-HH:MM:SS)?
> 2. Was this user created after the intrusion (yes/no)?
> 3. List the groups this user is a part of in lexicographic order separated by commas (group1,group2,...).
> 4. Is it probable this user was created by the attacker (yes/no)?
> 
> This challenge uses evidence found in previous challenges.

To answer these questions, we need to go back to the log files. In the `auth.log` file, we can see that an "admin" user is created, then delete, and then create again at 20:35:29. The `root.bash\_history` file confirms this creation, first with the` useradd` command and then with `adduser`. The user "admin" is then added to the group "sudo". Then the attacker tries an SSH connection and the `sudo su` command to make sure of its persistence.

{{< highlight plaintext >}}
Nov  8 20:35:21 midcoastfcu useradd[1499]: new group: name=admin, GID=1000
Nov  8 20:35:21 midcoastfcu useradd[1499]: new user: name=admin, UID=1000, GID=1000, home=/home/admin, shell=/bin/sh
Nov  8 20:35:26 midcoastfcu userdel[1507]: delete user 'admin'
Nov  8 20:35:26 midcoastfcu userdel[1507]: removed group 'admin' owned by 'admin'
Nov  8 20:35:29 midcoastfcu groupadd[1513]: group added to /etc/group: name=admin, GID=1000
Nov  8 20:35:29 midcoastfcu groupadd[1513]: group added to /etc/gshadow: name=admin
Nov  8 20:35:29 midcoastfcu groupadd[1513]: new group: name=admin, GID=1000
Nov  8 20:35:29 midcoastfcu useradd[1517]: new user: name=admin, UID=1000, GID=1000, home=/home/admin, shell=/bin/bash
Nov  8 20:35:42 midcoastfcu passwd[1524]: pam\_unix(passwd:chauthtok): password changed for admin
Nov  8 20:35:44 midcoastfcu chfn[1525]: changed user 'admin' information
Nov  8 20:36:04 midcoastfcu usermod[1529]: add 'admin' to group 'sudo'
Nov  8 20:36:04 midcoastfcu usermod[1529]: add 'admin' to shadow group 'sudo'
Nov  8 20:36:45 midcoastfcu sshd[1537]: Accepted password for admin from 172.16.20.24 port 43646 ssh2
Nov  8 20:36:45 midcoastfcu sshd[1537]: pam\_unix(sshd:session): session opened for user admin by (uid=0)
Nov  8 20:36:51 midcoastfcu sudo:    admin : TTY=pts/0 ; PWD=/home/admin ; USER=root ; COMMAND=/bin/su
Nov  8 20:36:51 midcoastfcu sudo: pam\_unix(sudo:session): session opened for user root by admin(uid=1000)
Nov  8 20:36:51 midcoastfcu su[1765]: Successful su for root by root
Nov  8 20:36:51 midcoastfcu su[1765]: + /dev/pts/0 root:root
Nov  8 20:36:51 midcoastfcu su[1765]: pam\_unix(su:session): session opened for user root by admin(uid=0)
{{< /highlight >}}

**Answers**

{{< highlight plaintext >}}
1. 11/08-20:35:29
2. yes
3. admin,sudo
4. yes
{{< /highlight >}}