


## Identifier les propriétés de type 'membership'

Identifier à partir de la requête suivante les propriétés qui se rapportent à des concepts qu'on peut considérer comme proches du concept d'appartenance à une organisation, donc à la classe *membership*.


    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT ?p1 (COUNT(*) as ?eff)
    WHERE { 
    dbr:List_of_astronomers ?p ?person.
    ?person a dbo:Person;
            dbo:birthDate ?birthDate ;
        ?p1 ?object.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        ### noter le filtre qui cherche uniquement les propriétés nettoyées de type 'ontology'
        FILTER (( ?birthYear > 1770) && (CONTAINS(STR(?p1), 'ontology') ))
    }
    GROUP BY ?p1
    ORDER BY DESC(?eff)

On relève notamment les propriétés:
* http://dbpedia.org/ontology/almaMater pour 308 cas
  * "schools that they attended (en)" comme l'indique la notice de l'ontologie
* http://dbpedia.org/ontology/institution pour 200 cas
  * la définition de la propriété dans l'ontologie de DBpedia ne donne pas de précisions, juste "institution" mais en cible de la propriété il y a des organisations: *rdfs:range -> dbo:Organisation* et on peut donc utiliser pour les appartenances.



### Universités fréquentées

On rédige la requête qui récupère les données:

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT DISTINCT ?person (?almaMater AS ?organisation) 
                                   ("almaMater" as ?membership_type) (2 AS ?fk_sparql_query)
                                  (STR("Importation 23 novembre 2025") as ?metadata)
    WHERE { 
    dbr:List_of_astronomers ?p ?person.
    ?person a dbo:Person;
            dbo:birthDate ?birthDate ;
        dbo:almaMater ?almaMater.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( ?birthYear > 1770)
    }




Puis on télécharge le CSV et on créé une table dans la base de données comme pour les personnes. La table s'appellera ***dbp_appartenance***.

Noter toutefois que déjà dans la requête SPARQL on a ajouté toute une série de colonnes supplémentaires qu'on retrouvera dans la table:
* une colonne avec le type d'appartenance, 'almaMater'
* noter qu'on a renommé à la volée la variable ?almaMater pour que la colonne s'appelle de manière plus générique 'organisation'
* une colonne avec la fk vers la pk de la table *sparql_query* qui contient la requête exécutée
* une colonne metadata avec la date d'importation



### Institutions (comme appartenance)

On rédige la requête qui récupère les données:

     PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT DISTINCT ?person (?institution AS ?organisation)
                                   ("institution" as ?membership_type) (3 AS ?fk_sparql_query)
                                  (STR("Importation 23 novembre 2025") as ?metadata)
    WHERE { 
    dbr:List_of_astronomers ?p ?person.
    ?person a dbo:Person;
            dbo:birthDate ?birthDate ;
        dbo:institution ?institution.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( ?birthYear > 1770)
    }



* télécharger le résultat de la requête sous forme de CSV
* importer le CSV dans la table ***dbp_appartenance*** déjà existante en ajoutant les lignes:
  * il faut choisir dans DBeaver la table dbp_appartenance existante
  * si on ne coche pas 'Truncate target table(s) before load' les données sont automatiquement ajoutées à la fin
* inspecter le résultat avec les requêtes qui se trouvent [dans ce fichier](../../DBPedia/import_memberships.sql) 



## Récuperer les noms des organisations des deux types de relations d'appartenance

        PREFIX dbr: <http://dbpedia.org/resource/>
            PREFIX dbo: <http://dbpedia.org/ontology/>
            SELECT DISTINCT    ?organisation (STR(?organisationLabel) AS ?label)
        (group_concat(DISTINCT  ?type, ',') as ?types)
                                        (4 AS ?fk_sparql_query)
                                        (STR("Importation 25 novembre 2025") as ?metadata)
            WHERE { 
            {
            dbr:List_of_astronomers ?p ?person.
            ?person a dbo:Person;
                    dbo:birthDate ?birthDate ;
                dbo:institution ?organisation.
        ?organisation rdfs:label ?organisationLabel
                BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
                BIND('institution' as ?type)
                FILTER ( ?birthYear > 1770 && LANG(?organisationLabel)='en')
        }
        UNION
        {
            dbr:List_of_astronomers ?p ?person.
            ?person a dbo:Person;
                    dbo:birthDate ?birthDate ;
                dbo:almaMater ?organisation.
        ?organisation rdfs:label ?organisationLabel
                BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
                BIND('almaMater' as ?type)
                FILTER ( ?birthYear > 1770 && LANG(?organisationLabel)='en')
        }
            }
        GROUP BY ?organisation ?organisationLabel


* télécharger le fichier du résultat
* créer une table à partir du CSV: *dbp_organisations_avec_noms*





&nbsp;

## Importer les organisation comme objets


### Vérifier l'absence de doublons
 


    # si le résultat est vide (pas de lignes) il n'y a pas de doublons
    SELECT 
    FROM dbp_organisations_avec_noms lp 
    GROUP BY person_uri
    HAVING COUNT(*) > 1 ;

    -- compter les personnes à importer
    SELECT COUNT(*)
    FROM (SELECT organisation, min(label),  
"Importé le 25 novembre 2025 depuis le résultat d'une requête SPARQL sur DBPedia, 
cf. table dbp_organisations_avec_noms"
            FROM dbp_organisations_avec_noms
            GROUP BY organisation);


 * Il y a des doublons

        SELECT organisation, min(label),  
    "Importé le 25 novembre 2025 depuis le résultat d'une requête SPARQL sur DBPedia, 
    cf. table dbp_organisations_avec_noms"
                FROM dbp_organisations_avec_noms
                GROUP BY organisation;



&nbsp;

### Insertion des organisations

adapter !!!



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

   
    INSERT INTO organisation (label, dbpedia_uri, import_metadata)
        SELECT min(label), organisation,
"Importé le 25 novembre 2025 depuis le résultat d'une requête SPARQL sur DBPedia, 
cf. table dbp_organisations_avec_noms"
            FROM dbp_organisations_avec_noms
            GROUP BY organisation ;  

Avec cette requête on créé les lignes dans la table _reference_ associant chaque personne à la requête SPARQL d'origine et on indique quelle est l'URI de la personne dans la requête d'origine. On peut ainsi documenter différentes origines des données.
