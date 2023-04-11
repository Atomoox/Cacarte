
# Cacarte Dockerized

Une installation complète de la Webapp Cacarte en 1 commande.

La lecture de ce guide reste importante dans certains cas d'utilisation.

## Ressources
| Ressource | Lien du repo |
|--|--|
| Code PHP de l'interface | https://github.com/Atomoox/cacarte-php |
| Code Golang de l'api | https://github.com/Yuyugnat/sae-shortest-path-api |

  

## Première installation

Dans votre terminal rentrez:

`git clone https://github.com/Atomoox/cacarte-dockerized cacarte`

  

Puis

`cd cacarte`

  

Et enfin

`docker compose up -d`

  

Mais ce n'est pas tout a fait fini. En effet vu la quantité de données contenue dans les tables du sujet de la SAE, le téléchargement ainsi que la création des vues et tables nécessaires au bon fonctionnement du programme peuvent prendre plusieurs **dizaines** de minutes.

  

Si après 30 minutes, le calcul du chemin ou la base de donnée est toujours innaccessible, redémarrez votre Stack de container docker.

  

Aucune autre précaution d'utilisation n'est a prevoir, si ce n'est les (environ) 1.5GB d'espace libre sur le disque dur.