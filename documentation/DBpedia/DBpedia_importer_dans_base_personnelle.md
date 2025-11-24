# Importer et structurer les données issues de DBPedia dans la base personnelle SQLite

Cette documentation concerne l'importation de données issues de DBpedia dans une base de données SQLite qui a la structure de celle du projet personnel.

Dans le contexte du présent projet la base de données s'appelle _astronomers_import.db_ et se trouve dans le dossier [_astronomers/data/astronomers_import.db_](https://github.com/Sciences-historiques-numeriques/astronomers/tree/main/data)


## Préparation de la base de données

Créer une copie de la base de données du projet personnel (par simple copier-coller du fichier SQLite contenant la base de données dans le dossier de travail), puir renommer la copie en ajoutant à la fin du nom, par exemple, '_import' ou semblable.

N.B.: au fur et à mesure de l'avancement de la recherche faire des *commits* avec Git dans VSCode afin de pouvoir revenir à une version précédente de la base de données si nécessaire.


Vider complètement les tables en utilisant l'instruction suivante. Mais attention: cette instruction est irréversible !


    /*
    La ligne est commentée (ajout de "--" avant la commande) afin d'éviter toute erreur de manipulation — décommenter la ligne afin de l'exécuter, puis recommenter.
    Noter que ces instructions se trouvent elles-mêmes dans un commentaire long du langage SQL. Elles ne sont pas 'vues' par le logiciel qui exécute les requêtes, précisément car elles sont 'commentées', ce sont des commentaires du code.
    */
    --DELETE FROM "person" ;

    /*
    * Remettre la séquence à zéro
    */
    UPDATE SQLITE_SEQUENCE 
    SET seq = 0
    WHERE name ='person';

    /* 
    après avoir vidé la table exécuter une instruction vacuum afin de vider la mémoire
    */
    VACUUM;



&nbsp;

## Production des données à importer


### Liste des astronomes à exporter

Exécuter la requête suivante sur le [serveur SPARQL de DBpedia](https://dbpedia.org) et choisir d'abord dans *result formats* le format de réponse HTML pour l'inspecter. Puis rééexecuter la requête en choisissant comme *result format* le 'texte séparé par virgule' (CSV) et enregistrer le fichier exporté dans un espace dédié (sous-dossier) du dossier de travail.

N.B. 

* Le genre n'est pas renseigné dans DBpaedia. 
* Noter également que plusieurs noms sont disponibles, on choisit ici de ne retenir que les noms en anglais, normalement un nom par personne.

### Requête sur le serveur SPARQL de DBPedia

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>

    SELECT DISTINCT ?person_uri (STR(?label) AS ?persName) ?birthYear
    WHERE { 
        dbr:List_of_astronomers ?p ?person_uri.
        ?person_uri a dbo:Person;
                dbo:birthDate ?birthDate;
                rdfs:label ?label.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( ?birthYear > 1770
                && LANG(?label) = 'en')
    }
    ORDER BY ?birthYear



### Creation de la table dans la base SQLIte

En utilisant DBeaver, sélectionner dans la base de données 'astronomers_import' à gauche l'onglet tables et activer par click droit l'import des données, puis suivre les étapes:

* selectionner le fichier CSV à importer qui vient d'être téléchargé à partir de la requête SQL
* dans le dialogue 'CSV' vérifier que le séparateur de colonnes (column delimiter) est bien virgule
* une nouvelle table sera créée, vous pouvez en modifier le nom sous 'target' et elle sera appelée: *dbp_liste_personnes* 
* le reste est à laisser comme tel, on peut vérifier dans l'étape 'Confirm' que tout est correct (ou revenir), puis:
* bouton 'Proceed' et la table sera créée
* si erreur dans la table, on l'efface avec DBeaver et on recommence


&nbsp;

## Importer les personnes


### Vérifier l'absence de doublons

 Chercher les doublons de la table des personnes importée depuis DBpedia. Si on trouve des doublons, c'est-à-dire les mêmes URI plus d'une fois, et donc plusieurs lignes avec différents noms pour la même personne, il est impératif d'éliminer les doublons car la table *person* ne doit comprendre qu'une ligne par individu.
 


    # si le résultat est vide (pas de lignes) il n'y a pas de doublons
    SELECT person_uri
    FROM dbp_liste_personnes lp 
    GROUP BY person_uri
    HAVING COUNT(*) > 1 ;

    -- compter les personnes à importer
    SELECT COUNT(*)
    FROM dbp_liste_personnes lp;


 * Si des doublons son présents, le mieux est de les chercher directement dans la table 'dbp_liste_personnes' et de supprimer manuellement les lignes en trop, en en laissant une par personne.
 * Si le nom des doublons est trop important il faudra recourir à cette requête en la mettant à la place du SELECT dans la requête d'insertion des personnes (INSERT INTO person ...) ci-dessous:

        SELECT max(birthYear), person_uri, max(persname),  "Importé le 22 novembre 2025 depuis le résultat d'une requête SPARQL sur DBPedia, cf. astronomers/DBpedia_importer_dans_base_personnelle"
            FROM dbp_liste_personnes lp
            GROUP BY person_uri;

Cf. le [document SQL](../../DBPedia/import_persons.sql).


&nbsp;

### Insertion des personnes



* si nécessaire vider préalablement la table personne, cf. ci-dessus
* ajouter à la table personne la colonne _import_metadata_ and _original_uri_ en utilisant DBeaver
* insérer les personnes avec la requête suivante:

        INSERT INTO person (birth_year, dbpedia_uri, label, import_metadata)
        SELECT birthYear, person_uri, persname, "Importé le 22 novembre 2025 depuis le résultat d'une requête SPARQL sur DBPedia, cf. astronomers/DBpedia_importer_dans_base_personnelle"
        FROM dbp_liste_personnes lp ;    

Noter qu'on a ajouté également une note d'importation qui indique l'origine des données, avec un renvoi à la documentation. On peut aussi créer une documentation plus précise avec la table 'reference' qui fait le lien entre chaque objet et la requête dont il est issu. Un exemple ci-dessous.




### Créer les lignes dans la table référence contenant l'URI

* ajouter une ligne manuellement concernant chaque requête SPARQL dans la table Document
* utiliser la clé primaire de la ligne concernée dans la requête suivante

&nbsp;

   
    INSERT INTO reference (fk_person , exact_reference , fk_document , fk_reference_type)
    SELECT pk_person, dbpedia_uri, 1, 1
    FROM person p ;

Avec cette requête on créé les lignes dans la table _reference_ associant chaque personne à la requête SPARQL d'origine et on indique quelle est l'URI de la personne dans la requête d'origine. On peut ainsi documenter différentes origines des données.


