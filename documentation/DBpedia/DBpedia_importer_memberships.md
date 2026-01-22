


## Identifier les propriétés de type 'membership'

Identifier à partir de la requête suivante les propriétés qui se rapportent à des concepts ou phénomènes qu'on peut considérer comme proches du concept d'appartenance à une organisation, donc à la classe *membership*.


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
* http://dbpedia.org/ontology/almaMater pour 639 cas
  * "schools that they attended (en)" comme l'indique la notice de l'ontologie
* http://dbpedia.org/ontology/institution pour 408 cas
  * la définition de la propriété dans l'ontologie de DBpedia ne donne pas de précisions, juste "institution" mais en cible de la propriété il y a des organisations: *rdfs:range -> dbo:Organisation* et on peut donc utiliser pour les appartenances.



### Universités fréquentées

On rédige la requête qui récupère les données:

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT DISTINCT ?person (?almaMater AS ?organisation) 
                                   ("almaMater" as ?membership_type) (2 AS ?fk_sparql_query)
                                  (STR("Importation 21 janvier 2026") as ?metadata)
    WHERE { 
    dbr:List_of_astronomers ?p ?person.
    ?person a dbo:Person;
            dbo:birthDate ?birthDate ;
        dbo:almaMater ?almaMater.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( ?birthYear > 1770)
    }




Puis on télécharge le CSV (il contient le nom alma_mater) et on créé une table dans la base de données comme précédemment pour les personnes. La table s'appellera ***dbp_appartenance***.

Noter que déjà dans la requête SPARQL on a ajouté toute une série de **colonnes supplémentaires** qu'on retrouvera dans la table:
* une colonne avec le type d'appartenance, 'almaMater'
* noter qu'on a renommé à la volée la variable ?almaMater pour que la colonne s'appelle de manière plus générique 'organisation'
* une colonne avec la fk vers la pk de la table *sparql_query* qui contient la requête exécutée (pour la documentation)
* une colonne metadata avec la date d'importation



### Institutions (comme appartenance)

On rédige la requête qui récupère les données:

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT DISTINCT ?person (?institution AS ?organisation)
    ("institution" as ?membership_type) (3 AS ?fk_sparql_query)
    (STR("Importation 21 janvier 2026") as ?metadata)
    WHERE { 
    dbr:List_of_astronomers ?p ?person.
    ?person a dbo:Person;
            dbo:birthDate ?birthDate ;
        dbo:institution ?institution.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( ?birthYear > 1770)
    }



* télécharger le résultat de la requête sous forme de CSV
* ATTENTION: cette fois on va importer le CSV dans la table ***dbp_appartenance*** déjà existante **en ajoutant les lignes**:
  * il faut choisir dans DBeaver la table dbp_appartenance existante
  * on peut vérifier dans l'étape 'Tables mapping' que l'alignement des colonnes est correct
  * si on ne coche pas 'Truncate target table(s) before load' les données sont automatiquement ajoutées à la fin
* inspecter le résultat avec les requêtes qui se trouvent **[dans ce fichier](../../DBPedia/import_memberships.sql)** en ouvrant le fichier dans DBeaver.

Le résultat pour le projet Astronomers:

|membership_type|number|
|---------------|------|
|almaMater|312|
|institution|204|




## Récuperer les noms des organisations des deux types de relations d'appartenance

        PREFIX dbr: <http://dbpedia.org/resource/>
            PREFIX dbo: <http://dbpedia.org/ontology/>
            SELECT DISTINCT    ?organisation (STR(?organisationLabel) AS ?label)
        (group_concat(DISTINCT  ?type, ',') as ?types)
            (4 AS ?fk_sparql_query)
            (STR("Importation 21 janvier 2026") as ?metadata)
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

Voir le fichier SQL **[Importer Organisations](../../DBPedia/import_organisations.sql)** à ouvrir et exécuter directement dans DBeaver





## Importer et explorer les appartenances aux organisations

La dernière étape consiste à importer les données dans la table 'membership'