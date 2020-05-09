---
title: "Installer Domoticz et Homebridge sur un Raspberry Pi"
description: "Utiliser un Raspberry Pi comme une centrale domotique en y installant Domoticz et Homebridge pour contrôler tous vos appareils connectés à la voix."
tags: [ "Domotique", "Domoticz", "Homebridge", "Raspberry Pi", "Google Home" ]
lastmod: "2020-05-09 15:31:44"
date: "2020-05-09 09:27:31"
categories:
    - "Tutoriels"
type: post
slug: "installer-domoticz-homebridge-raspberry-pi"
cover: "/media/2020/05/227ffdc014d82c6aa403dc0122156244.png"
---

Domoticz est, parmi tant d'autres solutions, un système permettant de centraliser la gestion des prises connectées, mais aussi des autres équipements domotiques. Cet article fait suite à un premier tutoriel expliquant comment [installer *Tasmota* sur des prises *Sonoff*](/tutoriels/prises-conectees-sonoff-tasmota/).

{{< supply cost="50" level="2" time="30 minutes" supplies="Un Raspberry Pi 3B+ (ou équivalent)" >}}

## Installation de Domoticz sur un Raspberry Pi

Commençons par télécharger [Raspbian](https://www.raspberrypi.org/downloads/raspbian/). Le but n'étant pas de vous expliquer comment installer une distribution Linux sur votre *Raspberry Pi*, je vous laisse le soins de suivre la méthode adaptée à votre matériel et vos préférences (J'ai choisi *Raspbian*, mais vous pouvez tout à fait utiliser une autre distribution Linux basée sur *Debian*, tel que *Ubuntu*). Pour ma part, une simple copie de l'image sur une carte SD et une installation classique feront l'affaire :

```shell
# dd bs=4M if=2020-02-13-raspbian-buster-lite.img of=/dev/sda status=progress conv=fsync
```

{{< alert "warning" "exclamation-circle" >}}**Attention :** Vérifiez bien vos arguments avant d’exécuter la commande `dd`, notamment le périphérique `of=` sur lequel vous effectuez la copie. Après avoir bien vérifié la valeur des arguments, revérifier encore une dernière fois, car vous perdrez des données si vous fournissez la mauvaise sortie !{{</ alert >}}

{{< alert "info" "info-circle" >}}Pour la suite de l'article, le *Raspberry Pi* aura l'adresse IP `192.168.0.10`.{{</ alert >}}

Une fois votre système installé et configuré, il faut à présent installer *Domoticz*. Deux solutions s'offre à vous :

- Le compiler vous-même depuis les sources, tel qu'expliquer sur le site de [Domoticz](https://www.domoticz.com/wiki/Build_Domoticz_from_source) ;
- Utiliser le script d'installation mis à disposition par *Domoticz*.

```shell
user@raspberry:~$ curl -L https://install.domoticz.com | bash
```

J'ai personnellement opté pour la seconde solution. Une fois l'installation terminée, *Domoticz* est accessible en HTTP à l'adresse IP de votre *Raspberry Pi*, par exemple [http://192.168.0.10:8080](http://192.168.0.10:8080).

## Configurer l'accès aux prises connectées

Tout d'abord, il faut créer un matériel virtuel qui correspondra à nos prises *Tamota* ([/#/Hardware](http://192.168.0.10:8080/#/Hardware)). *Domoticz* supporte de nombreux types d'équipement, mais dans notre cas nous utiliserons le type générique **"Dummy"**. Le nom du matériel virtuel importe peu, il est simplement là pour vous aider à identifier vos différents matériels virtuels.

{{< img-post alt="" path="/media/2020/05/" file="beba419c14eeb4f360106832e5484715-1024x202.png" >}}

Une fois créé, le nouveau matériel virtuel apparaît dans la liste :

{{< img-post alt="" path="/media/2020/05/" file="205ea9abb136549445172195d14cdc97-1024x140.png" >}}

Il est maintenant possible de créer un capteur virtuel (dans notre cas un interrupteur) depuis la liste des matériels. Nommer votre équipement et sélectionnez **interrupteur** parmi les type de capteurs. Le nouvel équipement sera visible sur la page "Interrupteurs" ([/#/LightSwitches](http://192.168.0.10:8080/#/LightSwitches)). Cependant, si vous essayer d'allumer ou d'éteindre la lampe depuis *Domoticz*, il ne se passera rien. En effet, le nouvel interrupteur virtuel est encore un équipement "idiot" (Dummy) tant qu'on ne lui a pas dit que qu'il doit faire.

{{< img-fit
    "" "258a739061fde9bf260996ea5ddefefe.png" ""
    "" "88c84f7ac00e8d890ff174e258da5d1e.png" ""
    "/media/2020/05/" "nowrap" "" >}}

Pour préciser à *Domoticz* ce que notre interrupteur doit faire, il faut se rendre sur la page de configuration de l'équipement ([/#/Devices/1/LightEdit](http://192.168.0.10:8080/#/Devices/1/LightEdit)) et renseigner les champs **Action On** et **Action Off** :

- Pour allumer la lampe (**Action On**), il faut envoyer la requête HTTP avec la commande `Power On` à l'interrupteur : [http://192.168.0.11/cm?cmnd=Power%20On](http://192.168.0.11/cm?cmnd=Power%20On)
- De même, pour l'éteindre (**Action Off**), il faudra envoyer la même requête HTTP avec la commande `Power Off`.

{{< img-post alt="" path="/media/2020/05/" file="0c12a2c60ff3079d9752f4fd4c359e44-1024x386.png" >}}

Et voilà, à présent si vous cliquez sur l'ampoule dans le tableau de bord *Domoticz*, votre interrupteur changera d'état. *Domoticz* n'est bien sûr pas limité au contrôle d'interrupteurs, et il permet de surveiller et de configurer divers appareils, y compris divers capteurs/métriques comme la température, les précipitations, le vent, le rayonnement ultraviolet (UV), la consommation / production d'électricité, la consommation de gaz, la consommation d'eau et beaucoup plus.

## Contrôler Domoticz à la voix

Toutes nos prises et équipements domotiques sont maintenant gérés depuis une seule interface. Cependant, si je dois utiliser le navigateur de mon smartphone à chaque fois que je veux allumer une lumière, ça va rapidement devenir fastidieux. C'est pourquoi nous allons ajouter le contrôle à la voix à *Domoticz*.

{{< alert "info" "info-circle" >}}Je me limite ici à l'interconnexion avec *Google Assistant*, mais il est également possible de relier *Domoticz* à *Siri* ou *Alexa*.{{</ alert >}}

Pour cela, nous allons utiliser [Homebridge](https://github.com/oznu/homebridge), et plus particulièrement sa version Web UI. La documentation de *Homebridge* est assez complète et explique comment [installer *Homebridge Config UI X*](https://github.com/oznu/homebridge-config-ui-x/wiki/Homebridge-&-Systemd-(Raspbian,-Ubuntu,-Debian)) :

- Installer `Node.js`
- Installer *Homebridge* et *Homebridge Config UI X* avec `npm`
- S'authentifier sur *Homebridge* : [http://192.168.0.10:8581/](http://192.168.0.10:8581/)

```shell
$ curl -sL https://deb.nodesource.com/setup_12.x | sudo bash -
$ sudo apt-get install -y nodejs gcc g++ make python
$ sudo npm install -g --unsafe-perm homebridge homebridge-config-ui-x
$ sudo hb-service install --user homebridge
```

Une fois rendu sur l'interface Web, nous aurons besoins d'installer deux *plugins* ([http://192.168.1.200:8581/plugins](http://192.168.1.200:8581/plugins)). Pas besoin de les installer en ligne de commande, tout se fait à présent via l'interface Web :

- **Homebridge Edomoticz** ([https://github.com/PatchworkBoy/homebridge-edomoticz](https://github.com/PatchworkBoy/homebridge-edomoticz))
- **Homebridge Google Smart Home** ([https://github.com/oznu/homebridge-gsh](https://github.com/oznu/homebridge-gsh))

Une fois les *plugins* téléchargés et installés, nous pouvons les configurer. **Edomoticz** n'a besoin que de l'adresse IP et le port sur lequel est installé *Domoticz* (ici `127.0.0.1:8080`). **Google Home Assistant** requiert quant à lui lier son compte *Google*, suivez simplement les instructions.


{{< img-fit
    "/media/2020/05/3c47a919b655e24ac40c351d88378602.png" "3c47a919b655e24ac40c351d88378602-150x150.png" ""
    "/media/2020/05/ee6a6c5619ac1d7281c38c7ed38c6c9e.png" "ee6a6c5619ac1d7281c38c7ed38c6c9e-150x150.png" ""
    "/media/2020/05/8ff87e6c5de3793bcc3b2a51aec014ad.png" "8ff87e6c5de3793bcc3b2a51aec014ad-150x150.png" ""
    "/media/2020/05/8b510bcf75740a29b2f13f7f3c334c3e.png" "8b510bcf75740a29b2f13f7f3c334c3e-150x150.png" ""
    "/media/2020/05/" "nowrap" "Configuration des plugins Edomoticz et GHA (Cliquer pour agrandir)" >}}

Ensuite, dans l'application **Home** de *Google*, ajoutez un nouvel équipement déjà configuré, sélectionnez **Homebridge** dans la liste et le tour est joué. L'application va scanner votre réseau local et automatiquement identifier l'instance de *HomeBridge* qui tourne sur votre *Raspberry Pi*. Normalement, tous les équipements de *Domoticz* devraient apparaître dans votre application *Home*.

Et maintenant : `OK Google, allume la lampe du salon ...`