# B1 Réseau 2018 - TP5

# Notions vues avant le TP

* Manipulations IP et masque (avec le [binaire](../../cours/lexique.md#binaire))
* Notions :
  * Firewall
  * Routage (statique)
  * IP, Ports, MAC
* Utilisation de CentOS
  * installation simple
  * utilisation CLI simple (cf [les commandes du Lexique](../../cours/lexique.md#commandes))
    * `man`, `cd`, `ls`, `nano`, `cat`
    * `ip a`, `ping`, `nc`, `traceroute`, `ss`
  * configuration réseau (voir la fiche de [procédures](../../cours/procedures.md))
    * configuration d'[interfaces](../../cours/lexique.md#carte-réseau-ou-interface-réseau)
    * gestion simplifié de nom de domaine
      * [hostname, FQDN](../../cours/procedures.md#changer-son-nom-de-domaine), fichier [`/etc/hosts`](../../cours/procedures.md#editer-le-fichier-hosts)
    * configuration firewall
    * configuration routage statique ([TP 3](../3/README.md))
    * table ARP ([TP4](../4/README.md)) 

# TP 5 - Premier pas dans le monde Cisco
Cisco c'est un des leaders concernant la construction de matériel lié au réseau. On explorera cette partie un peu plus ensemble en cours.  

Concernant le TP en lui-même, il n'y aura que peu de nouveaux concepts, le but étant de se **familiariser un peu avec** la ligne de commande **Cisco**.  

Oh et on montera un petit **serveur DHCP** à la fin !  

**Encore un TP solo** ! Vous pouvez vous aider entre vous (oui, aidez-vous, vous êtes beaux et forts), **mais un rendu/personne exigé !**

# Déroulement et rendu du TP 
* vous aurez besoin de : 
  * [Virtualbox](https://www.virtualbox.org/wiki/Downloads)
  * [GNS3](https://www.gns3.com/)

* les machines virtuelles Linux : 
  * l'OS **devra être** [CentOS 7 (en version minimale)](http://isoredirect.centos.org/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1810.iso)
  * pas d'interface graphique (que de la ligne de commande)
  
* les routeurs Cisco :
  * l'iOS devra être celui d'un [Cisco 3640](https://drive.google.com/drive/folders/1DFe2u5tZldL_y_UYm32ZbmT0cIfgQM2p)

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
* [I. Préparation du lab](#i-préparation-du-lab)
* [II. Lancement et configuration du lab](#ii-lancement-et-configuration-du-lab)
* [III. DHCP](#iii-dhcp)

# I. Préparation du lab

---

**Pour ce I. il n'y a aucune machine à lancer. Uniquement des VMs/routeurs à préparer. Ce sont les infos préliminaires, avec un tableau récapitulatif à la fin. C'est pour que preniez connaissance et que vous mettiez en place le contexte du TP.**

---

## 1. Préparation VMs

**1. Création d'un nouveau host-only**
  * peu importe l'adresse on s'en servira juste pour faire du SSH
  * **activez le DHCP** comme ça on aura pas besoin de saisir les IPs

**2. Création des VMs**
* On va juste cloner trois VMs depuis le patron du TP précédent :
  * `server1.tp5.b1` est dans `net1` et porte l'IP `10.5.1.10/24`
  * `client1.tp5.b1` est dans `net2` et porte l'IP `10.5.2.10/24`
  * `client2.tp5.b1` est dans `net2` et porte l'IP `10.5.2.11/24`
* Ajoutez aux trois VMs une interface host-only **en deuxième carte** dans le host-only précédemment créé

**3. Vous clonez juste les VMs, vous ne les allumez pas.**  
* Ensuite RDV dans GNS3 : Edit > Preferences > VirtualBox VMs et vous ajoutez les trois VMs. 

**4. Config réseau des dans GNS3** 
* Sur les 3 VMs 
  * Clic-droit > Configure > Network
  * mettre 2 cartes réseau

## 2. Préparation Routeurs Cisco
Importez l'ISO du routeur et mettez-en deux dans GNS3 : 
* `router1.tp5.b1` est dans :
  * `net1` et porte l'IP `10.5.1.254/24`
  * `net12`
* `router2.tp5.b1` est dans :
  * `net2` et porte l'IP `10.5.2.254/24`
  * `net12`

**Vous devrez déterminer vous-même un réseau et un masque pour `net12` et le justifier**. Il n'y aura que deux routeurs dans ce réseau.

## 3. Préparation Switches
Rien à faire ici, on va utiliser les Ethernet Switches de GNS3 comme de bêtes multiprises. Un switch n'a pas d'IP. 

## 4. Topologie et tableau récapitulatif

**Topologie :**
```
                                             client1
                                            /
Server1 --net1-- R1 --net12-- R2 --net2-- Sw
                                            \
                                             client2
```

**Réseaux :**

* `net1` : `10.5.1.0/24`
* `net2` : `10.5.2.0/24`
* `net12` : **votre choix** (à justifier)

**Machines :**

Machine | `net1` | `net2` | `net12`
--- | --- | --- | ---
`client1.tp5.b1` | X | `10.5.2.10` | X
`client2.tp5.b1` | X | `10.5.2.11` | X
`router1.tp5.b1` | `10.5.1.254` | X | *Votre choix*
`router2.tp5.b1` | X | `10.5.2.254` | *Votre choix*
`server1.tp5.b1` | `10.5.1.10` | X | X

# II. Lancement et configuration du lab

Lancez toutes les machines (ou une par une). Je vous conseille de vous posez tranquillement, et de vous conformez à une liste d'étapes pour ce faire. Ici encore je la fais pour vous, **habituez-vous à utiliser ce genre de petites techniques pour gagner en rigueur**.  

**Prenez des notes de ce que vous faites.**  

### Checklist IP VMs 

On parle de `client1.tp5.b1`, `client2.tp5.b1` et `server1.tp5.b1` :
* [X] Désactiver SELinux
  * déja fait dans le patron
* [X] Installation de certains paquets réseau
  * déja fait dans le patron
* [X] Désactivation de la carte NAT
  * déja fait dans le patron
* [ ] [Définition des IPs statiques](../../cours/procedures.md#définir-une-ip-statique)
* [ ] La connexion SSH doit être fonctionnelle
  * une fois fait, vous avez vos trois fenêtres SSH ouvertes, une dans chaque machine
* [ ] [Définition du nom de domaine](../../cours/procedures.md#changer-son-nom-de-domaine)

### Checklist IP Routeurs 

On parle de `router1.tp5.b1` et `router2.tp5.b1` :
* [ ] [Définition des IPs statiques](../../cours/procedures-cisco.md#définir-une-ip-statique)
* [ ] [Définition du nom de domaine](../../cours/procedures-cisco.md#changer-son-nom-de-domaine)

### Checklist routes 

On parle de toutes les machines :
* [ ] `router1.tp5.b1`  
  * directement connecté à `net1` et `net12`  
  * [route à ajouter](../../cours/procedures-cisco.md#ajouter-une-route-statique) : `net2`  
* [ ] `router2.tp5.b1`
  * directement connecté à `net2` et `net12`  
  * [route à ajouter](../../cours/procedures-cisco.md#ajouter-une-route-statique) : `net1`  
* [ ] `server1.tp5.b1`  
  * directement connecté à `net1`  
  * [route à ajouter](../../cours/procedures.md#ajouter-une-route-statique) : `net2`
  * [fichiers `hosts`](../../cours/procedures.md#editer-le-fichier-hosts) à remplir : `client1.tp5.b1`, `client2.tp5.b1`
* [ ] `client1.tp5.b1`
  * directement connecté à `net2`  
  * [route à ajouter](../../cours/procedures.md#ajouter-une-route-statique) : `net1`
  * [fichiers `hosts`](../../cours/procedures.md#editer-le-fichier-hosts) à remplir : `server1.tp5.b1`, `client2.tp5.b1`
* [ ] `client2.tp5.b1`
  * directement connecté à `net2`  
  * [route à ajouter](../../cours/procedures.md#ajouter-une-route-statique) : `net1`
  * [fichiers `hosts`](../../cours/procedures.md#editer-le-fichier-hosts) à remplir : `server1.tp5.b1`, `client1.tp5.b1`
* [ ] `router1.tp5.b1`  
  * directement connecté à `net2`  
  * [route à ajouter](../../cours/procedures.md#ajouter-une-route-statique) : `net1`  

Pour tester : 
* remplir [les fichiers `hosts`](../../cours/procedures.md#editer-le-fichier-hosts) des VMs Linux
* les deux clients doivent pouvoir `ping server1.tp5.b1`
* et réciproquement :fire:

> **Notez que les clients/serveurs n'ont pas de route vers `net12`**. Et ui. C'est un réseau privé que seuls les routeurs connaissent. 

# III. DHCP
Attribuer des IPs statiques et des routes sur les VMs c'est chiant non ? **Serveur [DHCP](../../cours/lexique.md#dhcp--dynamic-host-configuration-protocol)** à la rescousse.  

Une section dédiée popera dans le cours d'ici peu.  

Un serveur [DHCP](../../cours/lexique.md#dhcp--dynamic-host-configuration-protocol) :
* permet d'attribuer dynamiquement des IPs
  * on a pas besoin de les définir à la main
* est principalement utilisé pour des [clients](../..//cours/3.md#clientserveur)
  * on préfère avoir des IPs fixes (statiques) pour les [serveurs](../../cours/3.md#clientserveur) et les équipements réseaux (comme les [routeurs](../../cours/lexique.md#routeur))
  * ce serait un peu le dawa s'ils changeaient tout le temps
* permet aussi de distribuer d'autres infos aux [clients](../..//cours/3.md#clientserveur)
  * comme des routes !

## 1. Mise en place du serveur DHCP

On va recycler `client2.tp5.b1` pour ça (pour économiser un peu de ressources).  

**1. [Renommer la machine](../../cours/procedures.md#changer-son-nom-de-domaine**)
  * pour porter le nom `dhcp-net2.tp5.b1`

**2. Installer le serveur DHCP** en faisant un peu de crasse : 
  * éteindre la VM dans GNS3
  * ouvrir VirtualBox
  * ajouter une carte NAT à la VM
  * démarrer la VM dans VirtualBox
  * allumer la carte NAT
  * `sudo yum install -y dhcp` 
  * shutdown la VM

**3. Rallumer la VM dans GNS**

**4. Configuration du serveur DHCP**
* le fichier de configuration se trouve dans `/etc/dhcp/dhcpd.conf`
  * [un modèle est trouvable ici](./dhcp/dhcpd.conf)

**5. Faire un test**
* avec une nouvelle VM ou `client1.tp5.b1`
  * [configurer l'interface en DHCP, en dynamique (pas en statique)](../../cours/procedures.md#définir-une-ip-dynamique-dhcp)
  * utiliser [`dhclient`](../../cours/lexique.md#dhclient-linux-only)
* dans un cas comme dans l'autre, vous devriez récupérer une IP dans la plage d'IP définie dans `dhcpd.conf`

## 2. Explorer un peu DHCP
Le principe du protocole DHCP est le suivant : 
* on a un serveur sur un réseau, il attend que des clients lui demande des IPs
* des clients peuvent arriver sur le réseau (câble, WiFi, ou autres) et demander une IP
* le serveur attribuera une IP dans une plage prédéfinie
* le serveur va créer un **"bail DHCP"** par client, pour s'en souvenir
  * **dans le bail il y a écrit "j'ai donné telle IP à telle MAC"**
  * comme ça, si le même client revient, il garde son IP

---

La discussion entre le client et le serveur DHCP se fait en 4 messages simples, **"DORA"** :
* **"Discover"** : du client vers le serveur
  * le client cherche un serveur DHCP en envoyant des Discover en broadcast
* **"Offer"** : du serveur vers le client
  * Si un serveur reçoit un "Discover" il peut répondre un "Offer" au client
  * Il propose une IP au client
* **"Request"** : du client vers le serveur
  * Permet de demander une IP au serveur
  * C'est celle que le serveur lui a proposé
* **"Acknowledge"** : du serveur vers le client
  * Le serveur attribue l'adresse IP au client
  * Il crée un bail DHCP en local
  * Il peut aussi fournir au client d'autres infos comme l'adresse de gateway

---

**OKAY**, le but : 
* faire une demande DHCP
  * avec [`dhclient`](../../cours/lexique.md#dhclient-linux-only)
  * capturer avec Wireshark l'échange du DORA
    * vous pouvez `tcpdump` sur le `client1.tp5.b1` ou sur `dhcp-net2.tp5.b1`
    * ou vous pouvez clic-droit sur un lien dans GNS3 et lancer une capture

### IV. Bonus
Parce qu'en vrai, sivous aviez bien bossé, ça va être vite plié tout ça nan ?  

For fun and profit : 
* installer un serveur web très simplement configuré (par défaut ?) sur le `server1`
  * se référer à la fin du [tp4](../4/README.md)
  * accéder à ce serveur depuis le client (avec `curl`)
* sécuriser la connexion SSH en forçant la connexion par échange de clés
  * ça se fait en quelques commandes très très facilement
  * cherchez un peu en ligne
* mettre en place le petit nuage "NAT" dans GNS3
  * cela peut permettre aux VMs d'accéder à Internet 
  * c'est l'un de vos routeurs qui devra être configuré pour faire du NAT
  * on a encore rien fait à ce sujet en cours alor gl & hf pour ceux qui veulent le faire
