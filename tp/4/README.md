# B1 Réseau 2018 - TP4

# Notions vues avant le TP

* Manipulations IP et masque (avec le [binaire](../../cours/lexique.md#binaire))
* Notions :
  * [Firewall](../../cours/lexique.md#pare-feu-ou-firewall)
  * [Routage (statique)](../../cours/lexique.md#routeur)
  * IP, Ports, MAC
* Utilisation de CentOS
  * installation simple
  * utilisation CLI simple (cf [les commandes du Lexique](../../cours/lexique.md#commandes))
    * `man`, `cd`, `ls`, `nano`, `cat`
    * `ip a`, `ping`, `nc`, `traceroute`, `ss`
  * configuration réseau (voir la fiche de [procédures](../../cours/procedures.md))
    * configuration d'[interfaces](../../cours/lexique.md#carte-réseau-ou-interface-réseau)
    * gestion simplifié de nom de domaine
      * hostname, FQDN, fichier `/etc/hosts`
    * configuration [firewall](../../cours/lexique.md#pare-feu-ou-firewall)
    * configuration routage statique ([TP 3](../3/README.md))

# TP 4 - Spéléologie réseau : descente dans les couches
Gné ? "Spéléologie" ? Oui, on va descendre dans les couches du *modèle OSI* (on y reviendraaaaaa), explorer le principe d'encapsulation, et regarder un peu comment ça fonctionne **vraiment** tout ça.  

**En vrai c'est le TP qui fait un peu mal aux dents, alors gardez le sourire, soyez motivées les filles et tout ira bien.** :)  

Ha et **c'est un TP solo** ! Vous pouvez vous aider entre vous (oui, aidez-vous, vous êtes beaux et forts), **mais un rendu/personne exigé !**

# Déroulement et rendu du TP 
* vous utiliserez un l'hyperviseur de votre choix parmi : 
  * [Virtualbox](https://www.virtualbox.org/wiki/Downloads)
  * VMWare Workstation
  * j'utiliserai VirtualBox pour ma part, c'est avec lui que les exemples seront donnés

* les machines virtuelles : 
  * l'OS **devra être** [CentOS 7 (en version minimale)](http://isoredirect.centos.org/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1810.iso)
  * pas d'interface graphique (que de la ligne de commande)
  
* il y a beaucoup de ligne de commande dans ce TP, préférez les copier/coller aux screens

* le rendu doit toujours se faire [au même format](../README.md)

# Hints généraux
* **pour vos recherches Google** (ou autres) : 
  * **en anglais**
  * **précisez l'OS et la version** dans vos recherches ("centos 7" ici)
* dans le TP, **lisez en entier une partie avant de commencer à la réaliser.** Ca donne du sens et aide à la compréhension
* **allez à votre rythme.** Le but n'est pas de finir le TP, mais plutôt de bien saisir et correctement appréhender les différentes notions
* **n'hésitez pas à me demander de l'aide régulièrement** mais essayez toujours de chercher un peu par vous-mêmes avant :)
* pour moult raisons, il sera préférable pendant les cours de réseau de **désactiver votre firewall**. Vous comprendrez ces raisons au fur et à mesure du déroulement du cours très justement. N'oubliez pas de le réactiver après coup.
* **utilisez SSH dès que possible**

# Sommaire
* [Préparation d'une VM "patron"](#préparation-dune-vm-patron)
* I. [Mise en place du lab](#i-mise-en-place-du-lab)
* II. [Spéléologie Réseau](#ii-spéléologie-réseau)
  * 1. [ARP](#1-arp)
  * 2. [Interception de trafic avec Wireshark](#2-wireshark)
    * [ARP et `ping`](#a-interception-darp-et-ping)
    * [netcat](#b-interception-dune-communication-netcat)
    * [Trafic Web (HTTP)](#c-interception-dun-trafic-http)
* [Annexe 1 : Installation d'une interface graphique sur CentOS 7](#annexe-1--installation-dun-client-graphique)

--- 
# Préparation d'une VM "patron"
Bon c'est rigolo d'installer CentOS, mais c'est vite chiant. Nos hyperviseurs permettent de cloner des machines déjà existantes. Sauf que vos machines précédentes, vous les avez bien pourries !  

Vous allez réaliser **une nouvelle installation de CentOS**, configurer le minimum, et l'éteindre. **Vous ne rallumerez plus jamais cette VM**, elle ne servira qu'à être clonée. Cela accélerera grandement la mise en place de nos TPs ! (ce ne sont que des choses qu'on a déjà fait au [TP précédent](../3/README.md#i-création-et-utilisation-simples-dune-vm-centos))

**Installation et configuration de la VM "patron"** :
* créer une VM
  * 512 Mo RAM
  * 1 CPU
  * Réseau
    * une carte NAT
  * Stockage
    * disque de 8Go 
    * `.iso` de CentOS 7 (sur le "contrôleur IDE")
* installation
  * se référer au [TP précédent](../3/README.md#i-création-et-utilisation-simples-dune-vm-centos) (n'hésitez pas à m'appeler en cas de doute)
* wait for installation process to finish
* redémarrer la VM
  * vous pouvez enlever le `.iso` du lecteur CD si ce n'est pas fait automatiquement :)
* configuration VM
  * se logger avec votre utilisateur
  * exécutez :
```bash
# Désactivation de SELinux
sudo setenforce 0 # temporaire
sudo sed -i 's/enforcing/permissive/g' /etc/selinux/config # permanent

# Mise à jour des dépôts
sudo yum update -y

# Installation de dépôts additionels
sudo yum install -y epel-release

# Installation de plusieurs paquets réseau dont on se sert souvent
sudo yum install -y traceroute bind-utils tcpdump nc nano

# Désactivation de la carte NAT au reboot
sudo nano /etc/sysconfig/network-scripts/ifcfg-enp0s3
# mettre ONBOOT à NO

# Eteindre la machine
sudo shutdown now
```

# I. Mise en place du lab

Le "lab", c'est juste l'environnement nécessaire à notre TP. Vous allez créer des VMs quoi !

## 1. Création des réseaux

On va créer de nouveaux réseaux host-only. Pour rappel, la création d'un réseau host-only **ajoute une [carte réseau](../../cours/lexique.md#carte-réseau-ou-interface-réseau) sur votre PC**. Vous pouvez la voir avec un `ipconfig` bien sûr ! 

Créez les réseaux **host-only** suivants :
* le "réseau 1" ou `net1` : `10.1.0.0/24`
  * la carte réseau de l'hôte doit porter l'IP `10.1.0.1`
  * **PAS** de DHCP
* le "réseau 2" ou `net2` : `10.2.0.0/24`
  * la carte réseau de l'hôte doit porter l'IP `10.2.0.1`
  * **PAS** de DHCP

## 2. Création des VMs

**NB : Quand vous clonez, Virtualbox va vous poser des questions :**
* **clone intégral**
* **réinitialisation des adresses MAC : OUI**

**NB2 : PAS DE NAT DANS LES CLONES (ou alors vous la désactivez)**. Une interface de type NAT dans VirtualBox sert à accéder à internet. On en a **PAS** besoin (vous avez déjà fait les `yum install` dans le patron).

Créez les VMs suivantes (= clonez votre VM patron !) :
* **VM cliente** ou [`client1.tp4`](../../cours/procedures.md##changer-son-nom-de-domaine)
  * elle a une carte réseau dans `net1` (host-only) qui porte l'IP `10.1.0.10`
  * elle nous servira... de [client](../../cours/3.md#clientserveur) !
* **VM serveur** ou [`server1.tp4`](../../cours/procedures.md##changer-son-nom-de-domaine)
  * elle a une carte réseau dans `net2` (host-only) qui porte l'IP `10.2.0.10`
  * elle nous servira de [serveur](../../cours/3.md#clientserveur) :|
* **VM routeur** ou [`router1.tp4`](../../cours/procedures.md##changer-son-nom-de-domaine)
  * elle a une carte réseau dans `net1` (host-only) qui porte l'IP `10.1.0.254`
  * et une carte réseau dans `net2` (host-only) qui porte l'IP `10.2.0.254`
  * cette machine sera notre [routeur](../../cours/lexique.md#routeur). Ce sera la [passerelle](../../cours/lexique.md#passerelle-ou-gateway) de `client1` et `server1`

Je pense que vous avez compris le principe. Au cas où, je vous fais un schéma moche !
```
client  <--net1--> router <--net2--> server
```

---

**Checklist (à faire sur toutes les machines)** :
* [X] Désactiver SELinux
  * déja fait dans le patron
* [X] Installation de certains paquets réseau
  * déja fait dans le patron
* [X] **Désactivation de la carte NAT**
  * déja fait dans le patron
* [ ] [Définition des IPs statiques](../../cours/procedures.md#définir-une-ip-statique)
* [ ] La connexion SSH doit être fonctionnelle
  * une fois fait, vous avez vos trois fenêtres SSH ouvertes, une dans chaque machine
* [ ] [Définition du nom de domaine](../../cours/procedures.md#changer-son-nom-de-domaine)
* [ ] [Remplissage du fichier `/etc/hosts`](../../cours/procedures.md#editer-le-fichier-hosts)
* [ ] `client1` ping `router1.tp4` sur l'IP `10.1.0.254`
* [ ] `server1` ping `router1.tp4` sur l'IP `10.2.0.254`

> Pour tester si vos changements sont permanents, vous pouvez essayer de reboot. Je vous conseille de le faire si vous comptez bosser sur plusieurs jours. 

---

**Petit tableau récapitulatif** :

Machine | `net1` | `net2`
--- | --- | ---
`client1.tp4` | `10.1.0.10` | X
`router1.tp4` | `10.1.0.254` | `10.2.0.254`
`server1.tp4` | X | `10.2.0.10` 

> Habituez-vous à faire ce genre de tableau, c'est une méthode qui vous fera gagner énormément de temps. Pensez à quand vous aurez ~10 machines avec des IPs différentes. Je les ferai pas toujours à votre place ;)

## 3. Mise en place du routage statique

**Rappel : SELinux doit être désactivé** (fait dans le patron de VM normalement)

**Rappel : Votre carte NAT doit être désactivée** (fait dans le patron de VM normalement)

On va faire en sorte que notre `client1` puisse joindre `server1`, et vice-versa. Ceci, comme au [TP 3](../3/README.md), avec du routage statique.  

Pour ce faire : 
1. **sur `router1`** : 
    * activer l'IPv4 Forwarding (= transformer la machine en routeur)
      * `sudo sysctl -w net.ipv4.conf.all.forwarding=1`
    * désactiver le firewall (pour éviter certaines actions non voulues)
      * `sudo systemctl stop firewalld` (temporaire)
      * `sudo systemctl disable firewalld` (permanent)
    * vérifier qu'il a déjà des routes pour aller vers `net1` et `net2`
      * bah oui : il y est directement connecté !
      * `ip route show`

2. **sur `client1`** :
    * [faire en sorte que la machine ait une route](../../cours/procedures.md#ajouter-une-route-statique) vers `net1` et `net2`
    * laisser le firewall activé

3. **sur `server1`** :
    * [faire en sorte que la machine ait une route](../../cours/procedures.md#ajouter-une-route-statique) vers `net1` et `net2`
    * laisser le firewall activé

4. **test**
    * `client1` doit pouvoir ping `server1`
    * `server1` doit pouvoir ping `client1`
    * effectuez un [`traceroute`](../../cours/lexique.md#traceroute) depuis le client pour voir le chemin pris par votre message


# II. Spéléologie réseau

**Rappel : SELinux doit être désactivé**  

**Rappel : Votre carte NAT doit être désactivée** (sauf contre-indication)

**Rappel : vous DEVEZ utiliser SSH pour contrôler vos VMs**

## 1. ARP

ARP est le protocole qui permet de connaître la MAC d'une machine quand on connaît son IP.  

Pour toutes les actions liées à la table ARP sous CentOS, [c'est ici que ça se passe](../../cours/procedures.md#gérer-sa-table-arp). 

> **Il est inutile de juste dérouler le truc, inutile** ***d'apprendre***. **Essayez de bien** ***comprendre*** **et ça deviendra parfaitement naturel.**

### **A. Manip 1**

**Rappel : vous DEVEZ utiliser SSH pour contrôler vos VMs**

1. vider la table ARP de **toutes** vos machines
2. sur `client1`
    * vous DEVEZ utiliser SSH
    * afficher la table ARP
    * **expliquer la seule ligne visible** (hint : vous êtes connecté à cette VM, non ?... ;) )
3. sur `server1`
    * vous DEVEZ utiliser SSH
    * afficher la table ARP
    * **expliquer la seule ligne visible** (hint : celle-la aussi non ?)
4. sur `client1`
    * ping `server1`
    * afficher la table ARP
    * **expliquer le changement**
5. sur `server1`
    * afficher la table ARP
    * **expliquer le changement**

### **B. Manip 2**
1. vider la table ARP de **toutes** vos machines
2. sur `router1`
    * afficher la table ARP
    * **expliquer le(s) ligne(s)**
3. sur `client1`
    * ping `server1`
2. sur `router1`
    * afficher la table ARP
    * **expliquer le(s) changement(s)**

### **C. Manip 3**
1. vider la table ARP de **toutes** vos machines
2. sur l'hôte (votre PC)
    * afficher la table ARP
    * vider la table ARP 
    * afficher de nouveau la table ARP
    * attendre un peu
    * afficher encore la table ARP
    * **expliquer le(s) changement(s)** (c'est lié à votre [passerelle](../../cours/lexique.md#passerelle-ou-gateway))

### **D. Manip 4**
1. vider la table ARP de **toutes** vos machines
2. sur `client1`
    * afficher la table ARP
    * activer la carte NAT
    * joindre internet (`curl google.com` par exemple)
    * afficher la table ARP
    * **expliquer le(s) changement(s)**
      * expliquer quelle machine porte l'IP qui vient de pop dans cette table ARP
    * **n'oubliez pas de re-désactiver/débrancher la carte NAT**  

> **Je vous conseille très fortement de reprendre le tableau avec les IP plus haut et d'y ajouter les adresses MAC de chacune des interfaces pour la suite.**


## 2. Wireshark

Ok. On va aller voir ce qui s'est passé exactement sur le réseau. Analyser les trames réseau une par une !

Si ce n'est pas déjà fait :
* téléchargez Wireshark sur votre PC
* téléchargez `tcpdump` sur `router1`

On va capturer le trafic qui passe par `router1` :
* on doit dire à Wireshark d'intercepter et noter tout ce qui passe par une interface spécifique
* actuellement, votre PC est connecté en SSH à `router1`
* pour ce faire, vous avez choisi l'une de ses deux IPs pour vous connecter 
  * `10.1.0.254` ou `10.2.0.254`
* vu que vous êtes connecté en SSH, vous envoyez des trames en permanence sur l'IP choisie
* **on va donc capturer le trafic de l'interface à laquelle vous n'êtes PAS connecté** pour éviter le bruit généré par SSH

On va procéder comme suit :
* Wireshark s'appelle `tcpdump` en ligne de commande
* on va dire à `tcpdump`
  * d'intercepter le trafic sur une interface spécifique de `router1`
  * d'enregistrer tout ce qu'il voit passer dans un fichier
  * les fichiers Wireshark portent l'extension `.pcap`
* pendant que `tcpdump` intercepte le trafic
  * on va envoyer divers messages de `client1` à `server1`
* une fois que les messages auront été transmis
  * on fermera `tcpdump`
  * on enverra le fichier `.pcap` sur notre hôte
  * on pourra visualiser le contenu du fichier `.pcap` avec une jolie interface graphique !

Let's go !

## A. Interception d'ARP et `ping`

On a vu dans la partie du TP concernant l'ARP que le moindre message envoyé sur le réseau nécessite une MAC de destination. Elle est connue grâce à un message ARP broadcast.  

On va `ping server1` depuis `client1` et observer à la fois les messages ARP et les messages de `ping` :
1. sur `router1`
    * lancer Wireshark pour enregistrer le trafic qui passer par l'interface choisie et enregistrer le trafic dans un fichier `ping.pcap` :
      * `sudo tcpdump -i enp0s9 -w ping.pcap`
    
2. sur `client1`
    * vider la table ARP
    * envoyer 4 pings à `server1`
    * `ping -c 4 server1`

3. sur `router1`
    * quitter la capture (CTRL + C)
    * vérifier la présence du fichier `ping.pcap` avec un `ls`
    * envoyer le fichier `ping.pcap` sur votre hôte
      * si vous savez pas comment, ou si vous voulez des conseils sur des moyens rapides et/ou secure de le faire, appelez-moi !

4. sur l'hôte (votre PC) :
    * ouvrir le fichier `ping.pcap` dans Wireshark
    * essayez de comprendre un peu toutes les lignes (il devrait y en avoir une dizaine tout au plus !)
    * vous devriez voir :
      * la question pour connaître la MAC de la destination
        * protocole ARP
        * "Who has .... ? Tell ...." 
        * envoyée en broadcast
      * la réponse
        * protocole ARP
        * "... is at ..."
        * envoyée à celui qui a posé la question
      * les pings aller 
        * "ping !"
        * protocole ICMP
        * message `ECHO request`
      * les ping retour 
        * "pong !" 
        * protocole ICMP
        * message `ECHO reply`
    * **Important**
      * notez que ARP **n'est pas** encapsulé dans IP, c'est un paquet ARP dans une trame ethernet
      * notez que ICMP est encapsulé dans IP, c'est un datagramme ICMP, dans un paquet IP, dans une trame Ethernet !
      * **NOTEZ BIEN "QUI DISCUTE AVEC QUI" REELLEMENT** : au niveau des MAC
        * vous devriez en déduire qu'il vous manque la moitié des trames concernant cette communication
        * expliquez pourquoi 
        * **Appelez-moi pour discuter de cette question** si vous avez un doute. C'est essentiel pour bien comprendre un peu tout ce qu'il se passe !


## B. Interception d'une communication `netcat`

Bon bah je crois que vous le voyez venir :
* intercepter le trafic 
  * depuis `router1`
  * pendant que `client1` se connecte au serveur `netcat` de `server1`
    * oubliez pas d'ouvrir le port firewall sur `server1`
    * videz les tables ARP de tout le monde, comme ça on verra encore les messages ARP dans la capture
    * échangez quelques messages pour avoir de la matière à étudier :)
  * nommez la capture `netcat_ok.pcap`

Envoyez le fichier `netcat_ok.pcap` sur votre hôte, puis ouvrez le avec Wireshark. Mettez en évidence : 
* l'établissement de la connexion TCP
  * c'est le "3-way handshake" :
  * le client envoie `SYN` : demande de synchronisation
  * le serveur répond `SYN,ACK` : il accepte la synchronisation
  * le client répond `ACK` : "ok frer, on est bien connectés, on peut échanger de la donnée maintenant !"
* vos messages qui circulent

**HEY j'ai une idée** :
* fermer le port firewall du `server1`
* refaire la même chose 
  * se faire jeter la connexion parce que le port est fermé
  * intercepter le trafic dans un fichier `netcat_ko.pcap`
* exporter le fichier sur l'hôte
  * mettre en évidence les lignes qui correspondent au firewall qui dit "nop frer"

## C. Interception d'un trafic HTTP (BONUS)

**C'est un bonus mais c'est pas grand chose à faire (genre 5 min?) si vous avez fait le reste.** Et c'est délire.

Ca va être la même chose, mais on va intercepter du trafic HTTP. Du trafic web quoi ! De l'HTML qui transite sur le réseau toussa toussa.

Pour que ça se fasse dans de bonnes conditions, je vous propose :
* on va installer un serveur web sur `server1`
  * tkt frer, ce sera guidé, il y aura très peu de choses à faire, on veut juste un truc simple qui fonctionne
  * c'est quoi déjà un serveur web ?
    * c'est juste une application, qui écoute derrière le port d'une IP !
    * si on lui parle en HTTP, elle répond en HTTP
    * avec firefox ou `curl`
* et on va installer une interface graphique sur `client1` (facultatif)
  * ouais parce qu'il n'y a aucun problème pour avoir une interface graphique avec CentOS en fait !
  * ça simulera un peu mieux un "client" comme vous les connaissez
  * idem, ce sera guidé, y'aura juste à reboot la VM et paf une interface graphique
* le but ?
  * installer et lancer un serveur web sur `server1` (son nom c'est `nginx`)
  * installer et lancer un client web sur `client1` (son nom c'est Firefox :) )
  * se connecter au serveur web de `server1` avec le Firefox de `client1`
  * intercepter le trafic avec `router1`
  * visualiser le trafic HTTP sur votre hôte avec Wireshark

### Install et config du serveur Web

**Tout se passe sur `server1` uniquement ici !**

On va faire ça un peu bête et méchant, le but est juste d'avoir un truc qui marche. Vous jouerez avec des serveurs web ailleurs que dans mes cours :)

En partant du principe que vous n'avez raté aucune étape lors de [la réalisation de la VM-patron](#0-préparation-dune-vm-patron) :

```
# Allumer l'interface NAT
sudo ifup enp0s3

# Installation de nginx
sudo yum install -y nginx

# Ouverture du port firewall
sudo firewall-cmd --add-port=80/tcp
sudo firewall-cmd --reload

# Lancement du serveur web
sudo systemctl start nginx

# Eteindre l'interface NAT
sudo ifdown enp0s3
```

Pour tester si c'est ok :
* sur `server1`
  * `sudo systemctl status nginx`
  * `curl localhost:80`
* sur `router1`
  * `curl` vers l'IP de `server1`
* sur l'hôte (votre PC)
  * navigateur web sur `http://<IP_server1>:80`

### Install et config du client web

**Tout se passe sur `client1` uniquement ici !**

* si vous voulez vous pouvez [installer une interface graphique sur la VM](#annexe-1--installation-dun-client-graphique) `client1`. CentOS supporte ça sans problème
  * ce sera (très) long à l'école, alors c'est pas obligatoire

* sinon, `client1` peut utiliser la commande `curl`, c'est pareil !

### Interception du trafic
1. sur `server1`
    * s'assurer que le serveur web est fonctionnel
    * vider la table ARP
2. sur `client1`
    * vider la table ARP
3. sur `router1`
    * vider la table ARP
    * lancer la capture (fichier `http.pcap`)
4. sur `client1`
    * effectuer une connexion au serveur web à l'aide de votre client web
5. sur l'hôte (votre PC) 
    * analyser la capture :
      * repérez les messages ARP
      * repérez le trafic HTTP et le contenu HTML de la page demandée
      * analyser les lignes une à une
      * dans quels types de trames circulent le trafic HTTP ? Détaillez un peu ! 


## Annexe 1 : Installation d'un client graphique

Idem, bête et méchant, vous jouerez avec les interfaces graphiques Linux plus tard. (pour info on va installer l'interface [xfce](https://www.xfce.org/) réputée pour être légère)

Même si c'est "léger" ça va prendre plusieurs centaines de Mo à l'installation. La connexion à l'école sera probablement un peu short...

En partant du principe que vous n'avez raté aucune étape lors de [la réalisation de la VM-patron](#0-préparation-dune-vm-patron) :
* éteindre la VM
  * ajouter un peu de RAM, de RAM vidéo, et un proc histoire d'avoir un truc un minimum fluide
  * 1024Mo RAM
  * 128Mo RAM vidéo
  * 2 procs
* allumer la VM, et :
```
# Allumer l'interface NAT
sudo ifup enp0s3

# Installation d'un serveur X
sudo yum groupinstall "X Window system"

# Installtion de xfce
sudo yum groupinstall xfce

# Configuration du système
sudo systemctl isolate graphical.target
sudo systemctl set-default graphical.target

# Reboot frer
sudo reboot
```
