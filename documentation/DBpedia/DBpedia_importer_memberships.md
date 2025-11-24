


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
  * la définition de la propriété dans l'ontologie de DBpedia ne donne pas de précisions, juste "institution" mais en cible de la propriété il y a des organisations: rdfs:range dbo:Organisation et on peut donc utiliser pour les appartenances.



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




Puis on télécharge le CSV et on créé une table dans la base de données comme pour les personnes. La table s'appellera db_membership.

Noter toutefois que déjà dans la requête SPARQL on a ajouté toute une série de colonnes supplémentaires qu'on retrouvera dans la table:
* une colonne avec le type d'appartenance, 'almaMater'
* noter qu'on a renommé à la volée la variable ?almaMater pour que la colonne s'appelle de manière plus générique 'organisation'
* une colonne avec la fk vers la pk de la table *sparql_query* qui contient la requête exécutée
* une colonne metadata avec la date d'importation



### Institutions

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



*  ajouter