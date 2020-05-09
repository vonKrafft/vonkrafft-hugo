---
title: "Des prises connectées Sonoff avec Tasmota"
description: "Guide pour flasher des modules Sonoff Basic R2 afin d'utiliser Tamota et obtenir des prises connectées à moins de 10 euros."
tags: [ "Domotique", "Sonoff", "Tasmota", "ESP8266", "Google Home" ]
lastmod: "2020-05-09 14:47:11"
date: "2020-03-29 15:23:50"
categories:
    - "Tutoriels"
type: post
slug: "prises-conectees-sonoff-tasmota"
cover: "/media/2020/03/a6c629a0985665748bfb63318a02a126.png"
---

Ayant vendu mon âme ~~au diable~~ à *Big Brother* fin 2019 lors de l'acquisition d'un Google Home Mini, je me suis vite aperçu que l'usage que j'en avais n'était pas très éloigné d'une enceinte *Bluetooth* classique. Désireux d'en faire plus, je me suis mis en tête d'acheter des prises connectées pour contrôler mes lumières à la voix.

<!--more-->

Mais alors là, plusieurs soucis. Premièrement **ces prises coûtent les yeux de la tête !** Non mais 30 euros minimum pour un module `ESP8266` et un (plus ou moins) joli boîtier, c'est un peu abusé ... De plus, ces prises font souvent parti de **l'écosystème du fabriquant**, vous obligeant à acheter tous vos appareils domotiques chez le même constructeur, avec le risque dans le cas contraire de vous retrouver avec de multiples comptes sur les différentes plate-forme en ligne. Et voilà le dernier gros soucis : le *Cloud*. Relier les appareils de **mon réseau local sur Internet**, impliquant souvent d'ouvrir des ports sur la box, ça me tente pas trop ...

## Une prise connectée "fait maison"

Pour se fabriquer une prise connectée, il me faut un relais et un module `ESP8266`. Oui mais mon module et le signal de commande du relais fonctionnent en courant faible, il me faut donc également un transformateur pour passer du *230V 50Hz* au *5V continu*. Et c'est là qu'est le problème.

{{< alert "info" "info-circle" >}}Se fabriquer sa propre prise ? Une fausse bonne idée ...{{</ alert >}}

Achetés séparément et en petite quantité (je n'ai pas besoin de centaines de prises connectées), tous ces composants coûtent finalement cher et on se rapproche des tarifs d'une prise commercialisée pour le grand public. De plus, ces composants prennent de la place, et j'aimerais ne pas avoir une boîte à chaussure au pied de chacune de mes lampes ...

## Sonoff + Tasmota, la solution

Lorsqu'on cherche comment faire de la domotique *DIY*, on tombe rapidement sur la pléthore de Tutos expliquant comment flasher un module **Sonoff**. Ces modules, basés sur un `ESP8285` (variante du `ESP8266` avec 1Mo de mémoire), ne diffèrent pas beaucoup des prises connectées classiques et disposent elles aussi d'un écosystème *Cloud*. Mais ils ont l'avantage d'être bon marché, facilement démontables et peu encombrants.

Je me suis donc tourné vers l'achat de deux **[Sonoff Basic R2](https://www.amazon.fr/gp/product/B082W4ZWLW/)** pour tester cette solution. Le module est constitué d'un relais, une puce `ESP8285` (Wi-Fi 802.11 b/g/n, 1Mo Built-in Flash), un transformateur *90-250V > 5V* et fonctionne par conséquent sur le *230V 50Hz* européen. Pour s'affranchir de l'écosystème *eWeLink* mis à disposition par *Sonoff*, il est également possible de facilement flasher le firmware du microcontrôleur pour en utiliser un autre. Et c'est ce que j'ai fait en m'orientant vers **[Tasmota](https://github.com/arendst/Tasmota)**.

{{< supply cost="10" level="3" time="30 minutes" supplies="Un module Sonoff ou tout autre appareil compatible avec Tasmota, un adaptateur FT232RL, de quoi souder des broches sur un PCB" >}}

## Une prise connectée pour moins de 10 euros

Donc pour une quinzaine d'euros, nous avons deux modules qui nous permettront de faire deux prises connectées. Il nous faut également un [adaptateur FT232RL](https://www.amazon.fr/gp/product/B01N9RZK6I/) pour envoyer le nouveau firmware sur notre module *Sonoff* via USB.

### Préparation du matériel

Pour commencer, il faut démonter le module *Sonoff*, y repérer les connecteurs RX (Réception), TX (Émission), VCC et GND (alimentation 5V) et y souder des connecteurs. C'est la seule étape délicate, mais nécessaire pour flasher le microcontrôleur. L'idéal est d'y souder 4 broches, mais, n'ayant pas ça sous le coude, j'ai utilisé des petites sections de câbles et des connecteurs *Dupont*.

{{< img-fit
    "/media/2020/03/7b4c3c0367ae188987808a782619aecd.jpg" "7b4c3c0367ae188987808a782619aecd-300x300.jpg" ""
    "/media/2020/03/5346b0eaca0e0672536a9479111b9fdb.jpg" "5346b0eaca0e0672536a9479111b9fdb-300x300.jpg" ""
    "/media/2020/03/6f50d92c2bf8b65e1ec816a84746853b.jpg" "6f50d92c2bf8b65e1ec816a84746853b-300x300.jpg" ""
    "/media/2020/03/" "nowrap" "Préparation du module Sonoff pour y brancher l'adapteur FT232RL" >}}

### Installer Tamota

Maintenant que le module est prêt à être flashé, il nous faut télécharger :

- La dernière version de **[Tasmota](https://github.com/arendst/Tasmota/releases)** dans la langue de votre choix ;
- Le logiciel **[Tasmotizer](https://github.com/tasmota/tasmotizer/releases)** ou un autre des [outils recommandés](https://tasmota.github.io/docs/#/installation/Flashing)

Il faut ensuite connecter notre module en USB, mais également lui faire comprendre qu'il va recevoir un nouveau firmware. Pour cela, maintenir le bouton du *Sonoff* enfoncé et connecter l'USB. Une fois le module alimenté, nous pouvons relâcher le bouton. La procédure est très simple : après avoir lancé *Tasmotizer*, sélectionner le binaire que nous venons tout juste de télécharger, et cliquer sur **Tasmotize** !

{{< img-fit
    "" "bf81e1c68a61074fc5c6fe7658576667.png" ""
    "" "6ab642c85acabfbf87f59eaacf608b28.png" ""
    "/media/2020/03/" "nowrap" "" >}}

{{< highlight plaintext >}}
esptool.py v2.8
Serial port /dev/ttyUSB0
Connecting....
Chip is ESP8285
Features: WiFi, Embedded Flash
Crystal is 26MHz
MAC: 24:62:ab:55:42:24
Uploading stub...
Running stub...
Stub running...
Configuring flash size...
Auto-detected Flash size: 1MB
Erasing flash (this may take a while)...
Chip erase completed successfully in 3.0s
Compressed 592768 bytes to 411116...
Wrote 592768 bytes (411116 compressed) at 0x00000000 in 36.5 seconds (effective 130.1 kbit/s)...
Hash of data verified.

Leaving...
Hard resetting via RTS pin...
{{</ highlight >}}

Et voilà, le module est prêt à être utilisé ! Relions-y deux prises mâle et femelle et puis nous pouvons l'alimenter. La LED devrait clignoter en vert : cela signifie que le module est prêt à être configuré.

### Configurer Tasmota

Lors de sa première mise sous tension, *Tamota* met en place un point d'accès Wi-Fi nommé `tamota-[0-9]+`. Connectez-vous à ce réseau avec l'appareil de votre choix, tel qu'un smartphone, puis rendez-vous à l'adresse [http://192.168.4.1/](http://192.168.4.1/). Sur cette page, il faudra entrer les informations suivantes:

- **AP1 SSId** : Le nom de votre réseau Wi-Fi
- **Mot de passe AP1** : Le mot de passe pour votre point d'accès Wi-Fi
- **Nom d'hôte** (optionnel) : Le nom de la prise, par défaut `tamota-[0-9]+`

{{< alert "info" "info-circle" >}}Il est possible d'envoyer directement la configuration à l'appareil flashé via *Tasmotizer* (configuration Wi-Fi, MQTT, module et/ou template).{{</ alert >}}

Après avoir cliqué sur "Sauvegarder", le module redémarre et se connecte automatique au réseau Wi-Fi que nous venons de configurer. Il faut à présent trouver l'adresse IP que la box a octroyé au module. Pour cela, un rapide scan réseau permet de trouver :

{{< highlight terminal >}}
$ nmap -sn 192.168.1.0/24   
Starting Nmap 7.70 ( https://nmap.org ) at 2020-03-27 20:59 CET
Nmap scan report for tasmota-7718 (192.168.1.5)
Host is up (0.0097s latency).
{{</ highlight >}}

{{< alert "success" "lightbulb-o" >}}Je vous recommande d'attribuer une adresse IP fixe à votre prise.{{</ alert >}}

Nous pouvons maintenant nous connecter en HTTP à notre prise connectée depuis l'adresse `http://192.168.1.5/`.

{{< img-post alt="" path="/media/2020/03/" file="73e863a39bd0dae83bc7a8cd5d98d189-1024x299.png" >}}

Et voilà, une **prise connectée** peu onéreuse qui nous permet de commander une lampe ou tout type d'appareil 230V (10A max.) ! Personnellement, je ne me suis pas arrêté là et je me suis installé une centrale domotique sur un *Raspberry Pi* que j'ai relié à ma *Google Home Mini* pour un contrôle à la voix, mais c'est' l'objet d'un [autre article](/tutoriels/installer-domoticz-homebridge-raspberry-pi/) :)