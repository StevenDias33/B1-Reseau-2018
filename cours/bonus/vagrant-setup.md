# Vagrant Setup

Pour ceux qui veulent tester les Vagrantfiles pour les rendus de TP.  

* [installer Vagrant depuis le site officiel](https://www.vagrantup.com/) et suivre les instructions d'install/config

* cloner mon dépôt git
  * `git clone https://github.com/It4lik/B1-Reseau-2018`

* se déplacer dans le répertoire contenant le `Vagrantfile`
  * `cd B1-Reseau-2018/tp/X/rendu-type`

* j'utilise une `.iso` de base custom pour vous
  * c'est juste une CentOS 7 avec les paquets réseaux pré-installés et SELinux désactivé
  * faudra la faire aussi si vous voulez que ça marche :D (hésitez pas à me mp Discord)
  * ça évite que les machines téléchargent ça à chaque fois qu'on les allume : c'est déjà dans l'`iso` !

* `vagrant up`

* :fire: