# Cyprot Intro

* [Encoding (encodage)]()
* [Hashing (hachage)]()
* [Encryption (chiffrement)]()

## Encoding

**What ?**  
L'*encoding* ou *encodage* est le fait d'utilise un *code* pour changer la forme d'un message.  
Encoder un texte n'est pas une sécurité, et cela ne fait pas partie de la crypto.  
Obligé de le citer ici, parce qu'il est trop confondu avec le reste. 

**Examples**
* binaire (base2)
* décimal (base10)
* octal (base8)
* hexadécimal (base16)
* base64 (très utilisé en info pour stocker des petites données)
  * pendant le cours utilisation de `base64` et `base64 -d`

**Why ?**
Gagner de la place, économiser du trafic réseau, améliorer les performances.

## Hashing

**Vocab**
Un *hash* (ou *empreinte* ou *somme de contrôle* ou *checksum*) est le résultat d'un fichier/texte/whatever passé dans une *fonction de hachage*.

**What ?**
Ce sont des fonction mathématiques qui **doivent** respecter certaines propriétés :
* une *fonction de hachage* est une **one-way function** : on peut la faire dans un sens, mais pas dans l'autre 
  * tout le monde peut calculer un hash
  * personne peut calculer l'entrée qui a résulté en ce hash
* il doit être **facile et rapide** de calculer un *hash*
* il doit être difficile de trouver des *collisions*
  * une *collision* c'est quand deux entrées différentes donnent le même *hash*
* un tout petit changement dans le message résulte en une altération totale du ùhash*

**Examples**
* MD5
  * utilisation de `md5sum` en cours
* SHA1
* SHA256

**Why ?**
* **stockage de mot de passe**
  * on stocke le hash de l'utilisateur
  * quand il veut se reconnecter
  * on calcule le hash du mot de passe saisi
  * et on le compare saisi à l'inscription
  * si ce sont les mêmes alors les mots de passe sont identiques
* **contrôle d'intégrité**
  * lorsqu'un téléchargement est proposé
  * on fournit un fichier à télécharger et son *hash*
  * un client télécharge le fichier
  * une fois téléchargé, il calcule son hash et le compare à celui fourni par le site
  * si c'est les mêmes, alors le fichier n'a pas été altéré pendant le transport
* **plein d'autres choses**
  * vérification de l'identité d'un serveur SSH

## Encryption

**Vocab**
L'*encryption* ou *chiffrement* est l'art de transformer un message en un *message chiffré* ou *ciphertext* à l'aide d'une *clé de chiffrement* en utilisant un  *algorithme de chiffrement*.  

On oppose *message chiffré* à *message en clair*.  

Il existe deux principaux types de chiffrement :
* *symétrique* : la clé pour chiffrer et déchiffrer est la même
* *asymétrique* : il existe deux clés différentes pour chiffrer et déchiffrer  

* "*chiffrer*" = transformer un *message* en *ciphertext* avec un *algo de chiffrement* et une *clé*
* "*déchiffrer*" = transformer un *ciphertext* en son *message original*, lorsque l'on connaît l'*algo* et la *clé* utilisée
* "*décrypter*" = démarche de hacker consistant à retrouver le *message original* d'un *ciphertext* sans avoir connaissance de la *clé* et/ou de l'*algo* utilisé pour le *chiffrement*
* "crypter" = chiffrer sans avoir connaissance de l'algo ou de la clé ?...
  * **STRICTEMENT IMPOSSIBLE. PAR DEFINTION.**

**What ?**
* *chiffrement symétrique* 
  * la clé doit être partagé entre tous les membres d'une communication/d'un échange
  * soit partagée IRL, soit envoyée en clair à travers un réseau
  * c'est **très peu coûteux** en performances (CPU) de chiffrer symétriquement quelque chose

* *chiffrement asymétrique*
  * il existre deux clés
  * on peut utiliser n'importe laquelle pour chiffrer et l'autre pour déchiffrer

* utilisation du *chiffrement asymétrique*
  * Un participant (Alice) génère une paire de clés
  * Une qu'elle garde que pour elle et met dans un endroit sécure : n*la clé privée*
  * Une qu'elle donne à tout le monde : *la clé publique*
  * Il est possible de réaliser principalement deux choses :
  1. **Signature**
    * Alice chiffre un message avec sa clé privée et l'envoie sur le réseau
    * tout le monde peut le déchiffrer
    * mais si le déchiffrement marche, alors on est sûrs qu'Alice a envoyé le message
    * c'est de la **signature**
  2. **Echange sécurisé**
    * N'importe qui en possession de la *clé publique* de Alice, par exemple Bob, chiffre un message avec
    * Personne ne pourra ouvrir ce message sauf le détenteur de l'autre *clé*, qui est la *clé privée*
    * C'est Alice qui l'a : seule Alice pour ouvrir ce message

**Why ?**
* Signature de message
* Echange/Transaction sécurisée
  * échange de *clés symétriques* par exemple dans `https`

**Examples**
* *chiffrement par décalage*
  * *symétrique*
  * la clé est le nombre de fois qu'on se décale dans l'alphabet
  * l'algo de chiffrement est le chiffrement par décalage
  * un cas particulier est connu : avec la clé 13, appelé chiffrement de César
* *RSA*
  * *asymétrique*
  * initiales des trois chercheurs qui l'ont mis sur pied
  * mais le concept n'avait pas été inventé par eux
* *EC*
  * asymétrique
  * pour *Elliptical Curve*