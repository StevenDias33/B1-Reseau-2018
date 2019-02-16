# DoS & DDoS

## Vocab
* *DoS* : Denial of Service
  * Déni de Service
* *DDoS* : Distributed Denial of Service  
  * Déni de Service ditribué

Donc un DDoS c'est un juste un DoS distribué, un DoS à grande échelle. Faire tomber un serveur web c'est facile. Faire tomber une flotte de plusieurs milliers de serveurs web c'est autre chose. 

Un DoS, c'est quand un service est inaccessible, pour une raison ou une autre. Par exemple, `google.com` est down ? Déni de service. Tu peux plus te co à Fortnite ? Déni de service.   

En soit, un DoS, c'est parfois voulu par l'éditeur : une grosse mise à jour sur un par informatique peut amener à une interruption de service. Quand c'est voulu on dit "interruption", quand ça ne l'est pas on dit "déni". 

## Concept

Le DoS c'est donc juste le fait de rendre indisponible un service, quelqu'il soit et peu importe le moyen : **le DoS est une conséquence possible d'une attaque, pas l'attaque elle-même.**  

Le concept est né dans les années 6x/7x dans les premiers réseaux reliant des universités entre elles. A l'époque, la sécurité informatique n'en était qu'à ses balbutiements, le moindre comportement non prévu résultait en un gros bug = DoS.

## Moyens courants qui aboutissent à du DoS

* **flood simple**
  * vous utilisez un PC pour flooder un serveur donné
  * le but est de remplir la bande passante du serveur afin qu'il ne puisse communiquer avec l'extérieur

* **flood *via* un réseau de botnets**
  * un réseau de botnets c'est juste des PCs qui sont sur internet et que vous contrôlez
  * plutôt que d'utilisez un seul PC, le réseau de botnets est utilisé pour flooder le serveur cible
   

* **attaque par réflexion/amplification**
  * on utilise des infras déjà en place (par exemple l'infra DNS internet, ou une flotte de serveur NTP)
  * on leur pose une question qui nécessite une réponse très grande
    * par exemple "salut serveur DNS, stp, liste moi tous les domaines qui sont sous `.com`"
  * on pose la question en se faisant passer pour la cible
  * la réponse des serveurs sera alors dirigée vers la cible
    * car un serveur répond toujours à quelqu'un qui lui pose une question
  * suivant les serveurs utilisés, les conséquences peuvent être nombreuses
    * c'est souvent un pur flood de la bande passante aussi
    * avec du DNS, on parle vite en To/sec

* **slow Loris**
  * attaque présentée en cours
  * concept très simple : on va saturer le nombre de connexions simultanées du serveur
    * plutôt que de saturer sa bande passante
  * avantage ? Possibilité de faire tomber des gros serveurs avec un petit PC (car ne demande pas trop de puissance pour être réalisée)
