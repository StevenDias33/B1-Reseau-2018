# Lexique

* [Protocoles](#protocoles)
* [Autres sigles et acronymes](#siglesacronymes)
* [Notions](#notions)
* [Commandes](#commandes)

## Protocoles
### Couche 2 modèle OSI
#### *Ethernet*
* un *message Ethernet* est une **trame Ethernet**
* utilisé pour la *commutation de paquets*
* Ethernet définit le format des trames Ethernet qui circulent sur le réseau (entre autres)
  * [MAC](#mac--media-access-control) source d'un message
  * [MAC](#mac--media-access-control) destination d'un message

* **un câble RJ45**, c'est juste un câble qui est fait pour faire passer des trames Ethernet :)
  * d'ailleurs on les appelle parfois "câbles Ethernet" !
  * **donc pas besoin de plus que d'un câble pour créer un réseau**

---

### Couche 2/3 du modèle OSI

#### *ARP* : Adresse Resolution Protocol
* c'est dans le nom : il permet de résoudre des adresses
* plus précisément, il **permet de demander sur le réseau la MAC de quelqu'un, quand on connaît son IP**
* pour plus de détails sur le fonctionnement d'ARP, vous pouvez vous référer [au cours sur le sujet](./5.md#arp)

---

### Couche 3 du modèle OSI

#### *IP* : Internet Protocol v4

> on parle ici d'IPv4 (on verra peut-être un peu d'IPv6 ensemble)

* un *message IP* est un **paquet IP**
* protocole utilisé pour discuter à travers des réseaux
* une *adresse IP* peut être "portée" par une *carte réseau*
* une *adresse IP* est composée de 32 bits
  * par exemple : `192.168.1.1`
* pour comprendre l'IP on a besoin du [masque de sous-réseau](#masque-de-sous-r%C3%A9seau) qui lui est associé
* la décomposition d'une *adresse IP* est vue dans le [cours 1](./1.md)
* il existe des plages réservées d'adresses IP
  * entre autres, [les adresses privées et publiques](./3.md#ip-privéespubliques)

---

### Couche 4 du modèle OSI

#### *TCP* : Transmission Control Protocol

* un *message TCP* est un **datagramme TCP**
* permet d'établir un tunnel entre deux personnes, généralement un client et un serveur
* une fois le tunnel établi, le client et le serveur peuvent échanger des données
* voyez TCP comme un échange de messages (comme des textos) **avec accusé de réception**
* **on utilise TCP lorsqu'on veut une connexion stable, même si elle est un peu plus lente**
* une connexion HTTP utilise un tunnel TCP par exemple

#### *UDP* : User Datagram Protocol

* un *message UDP* est un **datagramme UDP**
* permet d'échanger des données, générélament entre un client et un serveur
* aucun tunnel n'est établi, les données sont envoyées **sans accusé de réception**
* **on utilise UDP lorsqu'on s'en fiche de perdre certains messages sur la route, afin d'optimiser la vitesse de transport**
* UDP est par exemple très utilisé dans les jeux en ligne (typiquement pour des FPS en ligne)

---

### Au dessus de 4 (couches "applicatives" qui transportent de la donnée)

#### *DHCP* : Dynamic Host Configuration Protocol
* permet d'éviter aux gens de définir leur adresse IP à la main eux-mêmes
* permet donc d'attribuer automatiquement des adresses IPs au sein d'un [LAN](#lan--local-area-network)
* il existe sur les réseaux pourvus de DHCP, un *serveur DHCP*
  * chez vous, c'est votre box
  * il parle le protocole DHCP, et vos PCs aussi
* **on oppose "l'adresse par DHCP" (ou "adressage dynamique") à "l'adressage statique"**
  * une "IP statique" ça veut dire "une IP **PAS** récupérée *via* DHCP
* le [cours 6](./6.md#dhcp) est plus détaillé à ce sujet


#### *DNS* : Domain Name System
* protocole utilisé pour associé des *un nom d'hôte et un nom de domaine* à une adresse IP
* les *serveurs DNS* sont des serveurs à qui on peut poser des questions
  * "donne moi le nom de domaine associé à telle IP"
  * "donne moi l'IP associée à tel nom de domaine"
* des outils comme [`nslookup` ou `dig`](#nslookup-ou-dig) peuvent être utilisés pour interroger des serveurs DNS à la main

#### *HTTP* : HyperText Transfer Protocol
* protocole utilisé pour discuter avec des serveurs web
* comme beaucoup de protocole de communicationo, HTTP fonctionne avec un principe de question/réponse
  * le client effectue une requête HTTP à un serveur web
    * = il demande une page spécifique
  * le serveur répond à la requête du clent dans une réponse HTTP
    * = il donne une page HTML + son CSS et son JS au client

#### *SSH* : Secure SHell
* protocole/outil utilisés pour se connecter à distance sur un équipement
* on peut alors contrôler l'équipement en passant par le réseau
  * l'équipement distant doit faire tourner une application : un **serveur SSH** 
    * souvent le serveur SSH écoute sur le port TCP numéro 22
  * votre PC doit posséder un **client SSH** :
    * la commande `ssh` (simple, puissant, léger)
    * ou [Putty](https://www.putty.org/) (sur Windows, quand la commande `ssh` n'est pas dispo)

## Sigles/Acronymes

### *CIDR* : Classless Inter-Domain Routing
* de façon simple, c'est le `/24` dans `192.168.1.1/24` par exemple
* un `/24` veut dire "24 bits à 1" et correspond donc au masque `11111111.11111111.11111111.00000000` soit `255.255.255.0`

### *FQDN* : Fully Qualified Domain Name
* c'est le nom complet d'un hôte (= d'une machine) sur le réseau
* il est la concaténation du nom d'hôte et du domaine
* [cf. le cours 4](./4.md#noms-de-domaine)

### *LAN* : Local Area Network
* réseau local
* les équipements qui s'y trouvent portent des [adresses privées](./3.md#ip-privéespubliques)

### *MAC* : Media Access Control
* on parle l'ici de *l'adresse MAC* ou *adresse physique*
* elle est *obligatoirement* portée par une *carte réseau*
* sur une carte physique, elle est gravée sur la carte (on ne peut pas la changer)
* l'*adresse MAC* est composée de 12 caractères hexadécimaux (par exemple `D4-6D-7D-00-15-3F`)
* les adresses MAC servent à envoyer des messages directs aux machines sur le même réseau que nous, elles sont utilisées par [le protocole Ethernet](#ethernet)

### *RFC* : Request For Comments
* document texte qui définit une notion, un concept, un protocole (principalement utilisés en informatique)
* les RFCs peuvent écrit par n'importe qui et sont des documents publics
* comme sont l'indique, une RFC a pour but d'être lue et commentée
* si les gens la lisent, la commentent, la complètent, une RFC finit par contenir des choses intéressantes
* **voyez-les comme des manuels pour construire des choses, ce sont juste des plans**
  * un plan pour construire une messagerie sécurisée, par exemple !
* les protocoles que vous connaissez ont tous été définis dans des RFCs, entre autres :
  * [IP](#ip--internet-protocol) : [RFC 791](https://tools.ietf.org/html/rfc791)
  * Allocation d'adresses privées : [RFC 1918](https://tools.ietf.org/html/rfc1918)
  * [HTTP](#http--hypertext-transfer-protocol) : [RFC 2616](https://tools.ietf.org/html/rfc2616)
  * [TCP](#tcp--transmission-control-protocol) : [RFC 793](https://tools.ietf.org/html/rfc793)
  * [Ethernet](#ethernet) : [RFC 826](https://tools.ietf.org/html/rfc826), [RFC 894](https://tools.ietf.org/html/rfc894)
    * un extrait de l'intro, c'est cadeau : 
> "The world is a jungle in general, and the networking game contributes many animals."

### *WAN* : Wide Area Network
* réseau étendu
* celui que vous utilisez le plus est Internet
  * les équipements qui s'y trouvent portent des [adresses publiques](./3.md#ip-privéespubliques)

## Notions

### Adresse de réseau
* adresse qui définit un réseau
* elle ne peut pas être utilisée comme adresse d'un hôte
* elle correspond à la première adresse disponible d'un réseau
* exemple :
  * pour l'adresse IP `192.168.1.37/24`, l'adresse de réseau est `192.168.1.0/24`

### Adresse de diffusion (ou *broadcast address*)

#### Pour le [protocole Ethernet](#ethernet)

* dernière MAC "possible" : `ff:ff:ff:ff:ff:ff`
* elle n'est portée par aucun équipement
* envoyer une trame Ethernet à cette [adresse MAC](#mac--media-access-control) permet d'envoyer un message à tous les autres équipements sur le réseau où l'on se trouve

#### Pour le [protocole IP](#ip--internet-protocol-v4)

* dernière adresse d'un réseau
* est utilisée pour envoyer un message à tous les hôtes d'un réseau
* elle ne peut pas être utilisée comme adresse d'un hôte
* **l'adresse de broadcast n'est portée par aucune machine**, c'est une adresse réservée dans tous les LANs du monde :)
* exemple :
  * pour l'adresse IP `192.168.1.37/24`, l'adresse de broadcast est `192.168.1.255/24`

### Binaire
* c'est la base 2 des mathématiques
* nous sommes habitués à compter en base 10
* n'importe quelle base est possible, certaines sont beaucoup utilisées en informatique
  * binaire (base 2)
  * décimal (base 10)
  * octal (base 8)
  * héxadécimal (base 16)
  * base 64 (oui oui, base 64)
  * pour les curieux : en fait l'ASCII normal (pas la table étendue), c'est juste une base 128 hein :)
* le cours 1 contient [un passage avec des calculs binaires](./1.md#3-exemple-de-manipulation-dip-vue-en-cours)
 
### Carte réseau (ou interface réseau)
* carte physique dans une machine (ou virtuelle)
* porte forcément une [adresse MAC](#mac--media-access-control)
  * pour une interface physique, la MAC est gravée physiquement sur le périphérique : on ne peut pas la changer
* peut porter une [adresse IP](#ip--internet-protocol) et ainsi "être dans un réseau"
* dans nos PCs du quotidien, on en a au moins une : la carte WiFi

### Loopback
* quand on parle de Loopback on parle d'une interface réseau
* il existe au moins une Loopback sur tous les équipements
  * sur vos PCs elle porte l'IP `127.0.0.1`
  * parfois elle est gérée différemment par rapport aux autres interfaces (vous ne la voyez pas sur Windows avec un `ipconfig`)
* **une interface de loopback permet uniquement de se joindre soi-même**
  * en fait c'est juste qu'elle porte une IP dans un `/32`, un masque un peu particulier, utilisé à cet effet :)
* go test un `ping 127.0.0.1` vous aurez jamais vu un `ping` si rapide. Normal : vous pingez votre propre machine, sans passer par le réseau

### Masque de sous-réseau
* permet d'extraire l'[adresse de réseau](#adresse-de-réseau) d'une adresse IP
* se présente sous sa forme classique `255.255.255.0` ou en notation [CIDR](#cidr--classless-inter-domain-routing) `/24`
* **les trois affirmations suivantes sont parfaitement équivalentes :**
  * "j'ai un réseau en `255.255.255.0`"
  * "j'ai un `/24`"
  * "j'ai un réseau avec 256 adresses possibles"
* la décomposition d'une IP est vue dans le [cours 1](./1.md)

### Pare-feu ou *firewall*
* présent sur la plupart des équipements (PCs, serveurs, etc)
* peut exister sous la forme d'une équipement physique
* c'est une application qui permet de filtrer le trafic réseau d'une machine
  * filtrage du trafic qui entre sur la machine
    * par exemple le firewall Windows bloque le `ping` entrant par défaut
  * filtrage du trafic qui sort de la machine
    * surtout utilisé sur des PCs d'entreprise ou sur des serveurs
* [la notion a été abordée dans le cours 2](./2.md#firewall)

### Passerelle ou *Gateway*
* la *passerelle* est un noeud agissant comme pivot, et elle permet de sortir du réseau (de chez vous vers Internet par exemple)
* il existe des réseaux sans passerelle
* la passerelle possède souvent l'IP juste avant la *broadcast*, mais pas toujours (ce n'est pas le cas à Ingésup par exemple)
* **la passerelle est une machine. L'adresse IP de gateway est donc l'adresse IP d'une machine présente sur le même réseau que nous,  contrairement à l'adresse de broadcast** : c'est une adresse IP réelle, et elle est portée par un équipement.
* **un réseau qui ne souhaite pas être connecté à d'autres réseaux ne possède pas de passerelle**

### Ports
* [le cours est plus complet à ce sujet](./2.md#notion-de-ports)
* un serveur est une machine qui "écoute" sur un port
  * un client est une machine qui se connecte à un port où un serveur écoute
* un port est un point d'entrée unique **sur une interface réseau**
  * donc si on a deux interfaces réseau, on a deux ports 443 (entre autres) : un sur chaque interface
* on peut demander à des applications "d'écouter" sur un ou plusieurs ports
* *par exemple, pour un site web, on demande souvent au serveur Web d'écouter sur le port 443 pour HTTPS*

### Routage ou *routing*
* c'est le fait de mettre en place et de configurer un [routeur](#routeur)

### Routeur
* **Très important**
* un routeur est un équipement sur le réseau 
  * c'est un PC quoi, mais optimisé :)
* il est au milieu de plusieurs réseaux, au moins deux (sinon c'est pas un routeur !)
  * **pour rappel** : "être dans un réseau" = "être branché (câble ou wifi) **+** posséder une carte réseau **+** avoir une IP dans le réseau donné"
  * donc il a au moins deux interfaces réseaux
  * et donc au moins deux adresses IPs ! :)
  
```
 ____________                      ____________
|  Réseau 1  |                    |  Réseau 2  |
|            |------ Routeur -----|            |
|____________|                    |____________|
```

* **il permet aux gens du réseau 1 d'aller vers le réseau 2, et vice-versa**

* la [passerelle](#passerelle-ou-gateway) d'un réseau, c'est souvent un routeur !

* son rôle est de connaître des "routes" et d'en faire profiter les réseaux auxquels il est connecté
  * une "route" est un chemin pour aller vers un réseau
  * par exemple, une route c'est : 
    * "pour aller dans `192.168.1.0/24`,
    * tu passes par l'[interface réseau](#carte-réseau-ou-interface-réseau) numéro 4,
    * en passant par la [passerelle](#passerelle-ou-gateway) `192.168.0.254/24`"

* il existe une route spéciale : la **route par défaut** 
  * c'est la route à prendre quand on connaît pas de routes spécifiques pour une adresse donnée
  * c'est le panneau "Toutes directions" quoi !
  
* **le routeur est un mec sympa : il connaît les routes, mais surtout, il vous permet d'y accéder**
  * chez vous, le routeur c'est votre Box
  * elle connaît une route pour aller dans votre [LAN](#lan--local-area-network) et une route pour aller sur Internet (le [WAN](#wan--wide-area-network))
  * et votre box est sympa : elle vous a dit que si vous aviez besoin d'aller sur internet, vous pouviez passer par elle

* **EDIT** : un routeur est un équipement qui fait de l'*IP Forwarding* :
  * ça veut dire qu'il peut traiter des [paquets IP](5.md#vocabulaire) qui ne lui sont pas destinés
  * afin de les faire transiter de réseau en réseau
  * par exemple, vos paquets, quand vous parlez à google, ils sont pas destinés au routeur, m'kay ?
  * **il suffit d'activer ça sur votre PC pour qu'il devienne un routeur** 

### *Stack réseau* ou *stack TCP/IP* ou Pile réseau
* désigne toutes les applications d'une machine qui s'occupent du réseau
* si quand vous tapez `ipconfig` il se passe quelque chose, bah y'a bien une application qui s'en occupe
* désigne des choses bien différentes suivant les OS
* on utilise le terme *stack réseau* pour désigner tout ce qui touche de près ou de loin au réseau sur une machine
  * gestion d'IP
  * gestion d'interfaces
  * firewall
  * et plein plein d'autres choses

### Subnetting
* c'est le fait de découper un réseau en plusieurs sous-réseaux
* par exemple, un `/24` contient deux `/25`
  * `192.168.1.0/24` est la réunion de `192.168.1.0/25` et `192.168.1.128/25`
* il existe des tonnes d'outils permettant d'assister le subnetting en évitant de devenir fou avec le binaire, comme [celui-ci](http://www.davidc.net/sites/default/subnets/subnets.html)

## Commandes

### `dhclient` (Linux only)
* permet de demander une IP en DHCP
* pour lâcher votre bail DHCP (`DHCPRELEASE`)
  * `sudo dhclient -v -r` (`r` comme `renew`)
* pour redemander une IP ([DORA](../../cours/6.md#dhcp))
  * `sudo dhclient -v`

### `ipconfig` ou `ifconfig` ou `ip a`
* affiche des informations sur les carte réseau
```
# Windows
ipconfig 
ipconfig /all

# GNU/Linux ou MacOS
ifconfig
ip a
```

### `ping`
* message très simple qui fait un aller-retour sur le réseau
* on l'utilise souvent pour tester la présence de quelqu'un sur le réseau
* la valeur en millisecondes est le temps de l'aller-retour
* utilisation : `ping IP` où `IP` est l'adresse IP d'un hôte sur le réseau
* test d'accès internet
  * souvent, pour tester l'accès d'une machine à internet on fait `ping 8.8.8.8`
  * `8.8.8.8` est une adresse simple  mémoriser et correspond en réalité à un serveur de Google
  * `1.1.1.1` peut aussi être utilisé de la même façon, c'est un serveur de CloudFlare
  
### `nmap`
* outil de scan réseau
* permet de récupérer des informations sur un réseau et les machines qui y sont connectées
* beaucoup de scans sont possibles
  * le plus simple, le scan de ping envoie simplement un `ping` à toutes les IPs d'un réseau
  * exemple de scan de ping : `nmap -sP 192.168.1.0/24`

### `nc` ou `netcat`
* outil permettant de simples connexions [TCP](#tcp--transmission-control-protocol) ou [UDP](#udp--user-datagram-protocol)
* on a effectué des simples connexions entre vos PCs en cours
* mais on peut aussi s'en servir pour se connecter à un serveur web, aucun problème
  * faut savoir parler l'[HTTP](#http--hypertext-transfer-protocol) par contre ehe
  
* pour agir comme un serveur (Linux) :
```
# Lance netcat pour qu'il "écoute" sur le port 9999 de l'IP 10.1.0.10
# -l comme "listen"
nc -l 10.1.0.10 9999
```
* pour agir comme un client, et se connecter à un serveur (Linux) : 
```
# Pour se connecter au serveur 10.1.0.10 sur le port 9999 
nc 10.1.0.10 9999
```

### `netstat` ou `ss`
* outils permettant de lister les connexions actives d'une machine
  * entre autres, une par site web que l'on visite par exemple
  * **on l'utilise beaucoup pour lister les [ports](#ports) ouverts par une machine**
* options communes de `ss`
  * `-l` pour les ports en écoute (`-l` comme *listen*)
  * `-t` pour les ports TCP
  * `-u` pour les ports UDP
  * `-4` pour les connexions IPv4
  * `-n` pour ne pas transformer le numéro de ports en nom de service
  * `-p` pour voir l'application (le processus) qui est attaché à un port
* exemple :
  * `ss -l -t -4`

### `nslookup` ou `dig`
* outils permettant d'effectuer des opérations liées au protocole DNS
* un *lookup DNS* consiste à demander quelle est l'IP d'un nom donné
  * "à quelle IP se trouve le serveur `www.google.com` ?" par exemple
* un *reverse lookup DNS* c'est l'inverse : on cherche à connaître à quel nom est associée une IP
  * "y'a-t-il des [noms de domaines](./4.md#noms-de-domaine) associés à `76.32.43.32` ?" par exemple

### `curl` et `wget`
* permettent de faire des requêtes [HTTP](#http--hypertext-transfer-protocol)
* tout ce que fait `wget`, `curl` sait le faire. La réciproque n'est pas vraie.
* `wget` c'est l'outil simple mais peu puissant et très peu flexible
* `curl`, c'est l'inverse
* souvent, pour imiter un simple `wget`, vous pouvez faire `curl -SLO`
* exemple : 
  * `curl -L www.google.com` permet de récupérer le contenu du serveur web de  `www.google.com`
  
### `traceroute`
* permet d'afficher les machines intermédiaires pour aller à une destination
* `traceroute` a plusieurs méthodes de fonctionnement
  * la plus classique est d'envoyer plusieurs `ping`
* exemple : 
  * `traceroute <IP>`
