

## Préparation

* Vérifier quelle version de Java est installée et isntaller Java si aucune version disponible
* Télécharger Fuseki et le mettre dans un dossier dédié (mais pas le dosseir GitHub !)
* Ouvrir un Powershell (Windows) ou un Terminal (MacOS / Linux)
* Se déplacer avec la commande *cd* dans le dossier Fuseki téléchargé
* Lancer Fuseki avec la commande ./fuseki-server ou fuseki-server
* Cf. [cette page d'instructions](https://jena.apache.org/documentation/fuseki2/fuseki-server.html)
* Le serveur va se lancer et l'interface graphique sera disponible à l'adresse http://localhost:3030
* Créer un nouveau dataset avec un nom correspondant à votre projet et en utilisant le type "Persistent (TDB2)"
* Ouvrir l'onglet 'Query' du dataset
* Pour importer des données et écrire dans Fuseki utiliser un URL de endpoint en écriture