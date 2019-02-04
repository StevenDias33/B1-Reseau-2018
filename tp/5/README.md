# B1 Réseau 2018 - TP5

# Notions vues avant le TP

* Manipulations IP et masque (avec le [binaire](../../cours/lexique.md#binaire))
* Notions :
  * Firewall
  * Routage (statique)
  * IP, Ports, MAC
* Utilisation de CentOS
  * installation simple
  * utilisation CLI simple (cf [les commandes du Lexique](../../cours/lexique.md#commandes)
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

Concernant le TP en lui-même, il n'y aura que peu de nouveaux concepts, le but étant de se familiariser un peu avec la ligne de commande Cisco.  

Oh et ptet on montera un petit DHCP à la fin !  

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
* [Config GNS3]()

# Config GNS3

# I. Préparation du lab
## 1. Préparation VMs
On va juste cloner deux VMs du TP précédent :
* `server1.tp5.b1` est dans `net1` et porte l'IP `10.5.1.10/24`
* `client1.tp5.b1` est dans `net2` et porte l'IP `10.5.2.10/24`
* `client2.tp5.b1` est dans `net2` et porte l'IP `10.5.2.11/24`

**Vous clonez juste les VMs, vous ne les allumez pas.**  

Ensuite RDV dans GNS3 : Edit > Preferences > VirtualBox VMs et vous ajoutez les deux VMs. 

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
* [X] **Désactivation de la carte NAT
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
* `router1.tp5.b1`  
  * directement connecté à `net1` et `net12`  
  * [route à ajouter](../../cours/procedures-cisco.md#ajouter-une-route-statique) : `net2`  
* `router2.tp5.b1`
  * directement connecté à `net2` et `net12`  
  * [route à ajouter](../../cours/procedures-cisco.md#ajouter-une-route-statique) : `net1`  
* `server1.tp5.b1`  
  * directement connecté à `net1`  
  * [route à ajouter](../../cours/procedures.md#ajouter-une-route-statique) : `net2`  
* `client1.tp5.b1`  
  * directement connecté à `net2`  
  * [route à ajouter](../../cours/procedures.md#ajouter-une-route-statique) : `net1`  
* `router1.tp5.b1`  
  * directement connecté à `net2`  
  * [route à ajouter](../../cours/procedures.md#ajouter-une-route-statique) : `net1`  

Pour tester : 
* remplir [les fichiers `hosts`](../../cours/procedures.md#editer-le-fichier-hosts) des VMs Linux
* les deux clients doivent pouvoir `ping server1.tp5.b1`
* et réciproquement

> **Notez que les clients/serveurs n'ont pas de route vers `net12`**. Et ui. C'est un réseau privé que seuls les routeurs connaissent. 

# III. DHCP
Attribuer des IPs statiques et des routes sur les VMs c'est chiant non ? Serveur DHCP à la rescousse.