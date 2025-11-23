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

 Chercher les doublons de la table des personnes importée depuis DBpedia. Si on trouve des doublons, c'est-à-dire les mêmes URI plus d'une fois, et donc plusieurs lignes avec différents noms pour la même personne, il est impératif d'éliminer les doulbons car la table *person* ne doit comprendre qu'une ligne par individu.
 
 Si les doublons ne 
 faut supprimer manuellement les doublons éventuels, i.e. m inacceptable )

    # si le résultat est vide (pas de lignes) il n'y a pas de doublons
    SELECT person_uri
    FROM dbp_liste_personnes lp 
    GROUP BY person_uri
    HAVING COUNT(*) > 1 ;

    -- compter les personnes à importer
    SELECT COUNT(*)
    FROM dbp_liste_personnes lp;


* si nécessaire vider préalablement la table personne, cf. ci-dessus
* ajouter à la table personne la colonne _import_metadata_ and _original_uri_
* insérer les personnes avec la requête suivante:

&nbsp;

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




## Liste des occupations

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbp: <http://dbpedia.org/property/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    PREFIX rdfs:<http://www.w3.org/2000/01/rdf-schema#>
    SELECT DISTINCT (?o1 AS ?subject_uri) (dbo:occupation as ?property_uri) (?target AS ?object_uri)  (?name as ?label)
    #(COUNT(*) AS ?effectif) 
    WHERE {
    SELECT DISTINCT ?o1 ?target (str(?label) as ?name)
    WHERE { 
        {
            {dbr:List_of_astronomers ?p ?o1.}
        UNION
            {dbr:List_of_astrologers ?p ?o1.}
        UNION
            {?o1 ?p dbr:Astrologer.}
        UNION
            {?o1 ?p dbr:Astronomer.}
        UNION
            {?o1 ?p dbr:Mathematician.}
        }
        ?o1 a dbo:Person;
        dbp:birthDate | dbo:birthDate ?birthDate;
        dbp:occupation | dbo:occupation ?target.
    ?target rdfs:label ?label.
    BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( (?birthYear >= 1351   )  && LANG(?label) = 'en') 
            }
    ORDER BY ?birthYear
    }


## Création des occupations / activités 

Après avoir téléchargé le résultat de la requête en TSV, on créée la table _dbp_occupation_ en important les données comme ci-dessus pour les personnes avec DBeaver.

On inspecte ensuite les occupations existantes:

    SELECT target, name, COUNT(*) AS effectif
    FROM dbp_occupation do 
    GROUP BY target, name 
    ORDER BY effectif DESC ;

On constate alors une incohérences des termes utilisés dans Wikipedia et on déduit qu'il faudrait faire un travail de nettoyage. Nous ne le ferons pas fait ici car le but est d'illustrer la démarche d'importation de données.

Après avoir vidé la table si nécessaire, on créé ensuite les occupations regroupées dans la table correspondante ainsi:

    INSERT INTO occupation (original_uri, label)
    SELECT target, name
    FROM dbp_occupation do 
    GROUP BY target, name 
    ORDER BY name;

    --puis on inspecte le résultat
    SELECT label, original_uri 
    FROM occupation o ;

    /*
    on inspecte les données à travers la table jointure dbp_occupation
    */
    SELECT p.label, o.label 
    FROM dbp_occupation do 
    JOIN person p ON p.original_uri = do.o1 
    JOIN occupation o ON o.original_uri = do.target ;

On va ensuite créer les lignes de la table _pursuit_ en utilisant les lignes de la table _db_occupation_ qui associent chaque fois une personne à une occupation

    INSERT INTO pursuit (fk_person, fk_occupation )
    SELECT p.pk_person, o.pk_occupation 
    FROM dbp_occupation do 
    JOIN person p ON p.original_uri = do.o1 
    JOIN occupation o ON o.original_uri = do.target ;

On pourra constater que la table, et la vue correspondante _v_pursuit_ sont désormais remplies.

On pourrait ensuite ajouter toutes les métadonnées d'importation à travers la table _reference_ mais nous ne le ferons pas ici. La méthode sera identique à celle adoptée pour la table _person_ présentée ci-dessus.

Aussi, manquent les dates et autres éléments qu'on pourrait ajouter à partir d'autres sources de données, par importation ou manuellement.

On notera que la qualité de l'information issue de DBPedia n'est pas optimale mais que, en même temps, on peut disposer d'un premier lot de données intéressantes à analyser.
