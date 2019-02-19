# Procédures

Vous trouverez ici quelques mini-procédures pour réaliser certaines opérations récurrentes. Ce sera évidemment principalement utilisé pour notre cours de réseau, mais peut-être serez-vous amenés à le réutiliser plus tard.  

**Elles sont écrites pour un système CentOS7**. Vous en apprendrez (au moins un peu) plus sur le monde GNU/Linux en temps et en heure. Sachez que :
* tout ça est faisable (pour la plupart) sur Windows et Mac. Vous demanderez à google des équivalents
* pour ce qui est du réseau, la plupart des Linux sont très similaires
* ces instructions sont valables pour d'autres systèmes basés sur RedHat, comme Fedora
* pour certaines choses, ça peut changer si vous avez une base Debian (comme Ubuntu)

## Sommaire

* [Définir une IP statique](#définir-une-ip-statique)
* [Définir une IP dynamique](#définir-une-ip-dynamique-dhcp)
* [Ajouter une route statique](#ajouter-une-route-statique)
* [Changer son nom de domaine](#changer-son-nom-de-domaine)
* [Editer le fichier hosts](#editer-le-fichier-hosts)
* [Interagir avec le firewall](#interagir-avec-le-firewall)
* [Gérer sa table ARP](#gérer-sa-table-arp)


---

### Définir une IP statique
**1. Repérer le nom de l'interface dont on veut changer l'IP**
```
ip a
```
**2. Modifier le fichier correspondant à l'interface**
* il se trouve dans `/etc/sysconfig/network-scripts`
* il porte le nom `ifcfg-<NOM_DE_L'INTERFACE>`
* on peut le créer s'il n'existe pas
* exemple de fichier minimaliste qui assigne `192.168.1.19/24` à l'interface `enp0s8`
  * c'est donc le fichier `/etc/sysconfig/network-scripts/ifcfg-enp0s8`
```
NAME=enp0s8
DEVICE=enp0s8

BOOTPROTO=static
ONBOOT=yes

IPADDR=192.168.1.19
NETMASK=255.255.255.0
GATEWAY=192.168.1.254
```
**3. Redémarrer l'interface**
```
sudo ifdown <INTERFACE_NAME>
sudo ifup <INTERFACE_NAME>
```

---

### Définir une IP dynamique (DHCP)
**1. Repérer le nom de l'interface dont on veut changer l'IP**
```
ip a
```
**2. Modifier le fichier correspondant à l'interface**
* il se trouve dans `/etc/sysconfig/network-scripts`
* il porte le nom `ifcfg-<NOM_DE_L'INTERFACE>`
* on peut le créer s'il n'existe pas
* exemple de fichier minimaliste qui assigne `192.168.1.19/24` à l'interface `enp0s8`
  * c'est donc le fichier `/etc/sysconfig/network-scripts/ifcfg-enp0s8`
```
NAME=enp0s8
DEVICE=enp0s8

BOOTPROTO=dhcp
ONBOOT=yes
```
**3. Redémarrer l'interface**
```
sudo ifdown <INTERFACE_NAME>
sudo ifup <INTERFACE_NAME>
```

---

### Ajouter une route statique

* **temporairement**
  * `sudo ip route add <NETWORK_ADDRESS> via <IP_GATEWAY> dev <LOCAL_INTERFACE_NAME>`
  * par exemple `sudo ip route add 10.2.0.0/24 via 10.2.0.254 dev eth0`
  * ce changement sera effacé après `reboot` ou `systemctl restart network`

* **définitivement**
  * comme toujours, afin de rendre le changement permanent, on va l'écrire dans un fichier
  * il peut exister un fichier de route par interface
  * les fichiers de routes :
    * sont dans `/etc/sysconfig/network-scripts/`
    * sont nommés `route-<INTERFACE_NAME>`
    * par exemple `/etc/sysconfig/network-scripts/route-enp0s8`
    * contiennent la même ligne que `ip route add` : 
```
10.2.0.0/24 via 10.2.0.254 dev eth0
10.1.0.0/24 via 10.1.0.254 dev eth0`
```

* **pour vérifier**
  * `ip route show`
  
---

### Changer son nom de domaine

**1. Changer le FQDN immédiatement** (temporaire)
```
# commande hostname
sudo hostname <NEW_HOSTNAME>
# par exemple
sudo hostname vm1.tp3.b1
```
**2. Définir un FQDN quand la machine s'allume** (permanent)
* écriture du FQDN dans le fichier (avec `nano`) : `sudo nano etc/hostname`
* **OU** en une seule commande `echo 'vm1.tp1.b3' | sudo tee /etc/hostname`

**3. Pour consulter votre FQDN actuel**
```
hostname --fqdn
```

---

### Editer le fichier hosts

Le fichier `hosts` se trouve au chemin `/etc/hosts`. Sa structure est la suivante :
* une seule IP par ligne
* une ligne est une correspondance entre une IP et un (ou plusieurs) noms (FQDN ou nom d'hôte)
* on peut définir des commentaires avec `#`
Par exemple, pour faire correspondre l'IP `192.168.1.19` aux noms `monpc` et `monpc.chezmoi` :
```
192.168.1.19  monpc monpc.chezmoi
```
* on peut tester le fonctionnement avec un `ping`
```
ping monpc.chezmoi
```

### Interagir avec le firewall

CentOS 7 est aussi équipé d'un pare-feu. Par défaut, il bloque tout, à part quelques services comme `ssh`.  
Pour manipuler le firewall de CentOS 7, on utilise la commande `firewall-cmd` :
* `sudo firewall-cmd --list-all` pour lister toutes les règles
* `sudo firewall-cmd --add-port=80/tcp --permanent` pour autoriser les connexions sur le port TCP 80 
* `sudo firewall-cmd --remove-port=80/tcp --permanent` pour supprimer une règle qui autorisait les connexions sur le port TCP 80 
* `sudo firewall-cmd --reload` permet aux modifications effectuées de prendre effet

### Gérer sa table ARP

On utilise encore la commande `ip` pour ça. Pour la table ARP, c'est le mot-clé `neighbour` (on peut l'abréger `neigh`) :
* voir sa table ARP 
  * `ip neigh show`
  * pour une interface spécifique : `ip neigh show dev enp0s8`
* voir la ligne correspondant à une IP spécifique :
  * `ip neigh show 10.0.1.1`
* ajouter une ligne permanente
  * `sudo ip neigh add 10.0.1.10 lladdr de:4d:b3:3f:de:4d dev enp0s8 nud permanent`
* changer une ligne
  * `sudo ip neigh change 10.0.1.10 lladdr aa:bb:cc:dd:ee:ff dev enp0s8`
* supprimer une ligne
  * `sudo ip neigh del 10.0.1.10 lladdr aa:bb:cc:dd:ee:ff dev enp0s8 nud permanent`
* vider la table ARP
  * `sudo ip neigh flush all`
