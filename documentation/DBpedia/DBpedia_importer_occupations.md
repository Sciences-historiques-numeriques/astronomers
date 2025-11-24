



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
