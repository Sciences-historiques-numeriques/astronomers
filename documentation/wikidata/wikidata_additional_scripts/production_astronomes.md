# Importation de la population des astronomes depuis Wikidata vers la base Fuseki locale

Cette page documente l'importation de la population des astronomes vers Fuseki

On exécute d'abord les requêtes sur le point d'accès SPARQL de Wikidata: https://query.wikidata.org



## Liste des astronomes avec date et année de naissance, et genre

Avec cette requête on cherche toutes les personnes qui ont comme occupation astronome [occupation (P106)] ou qui ont astronomie comme champ d'activité [field of work (P101)]


### Effectif

10760 le 10 juillet 2024

    SELECT (COUNT(*) as ?eff)

    WHERE {

    SELECT DISTINCT ?item
        WHERE {
            {
        {?item wdt:P106 wd:Q11063}
        UNION
            {?item wdt:P101 wd:Q333} 

            }      
        ?item wdt:P31 wd:Q5;  # Any instance of a human.
        } 
    }
### Ajouter les noms et les dates

    SELECT DISTINCT ?item ?itemLabel ?birthYear ?birthDate ?gender
        WHERE {
            {
        {?item wdt:P106 wd:Q11063}
        UNION
            {?item wdt:P101 wd:Q333} 

            }        
        # Tous les humains, afin d'exclure des éventuelles instances d'autres classes    
        ?item wdt:P31 wd:Q5;  
            OPTIONAL { ?item wdt:P569 ?birthDate.
                    BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?birthYear)
                    }
            OPTIONAL { ?item wdt:P21 ?gender}
        OPTIONAL {
            SERVICE wikibase:label { bd:serviceParam wikibase:language "en, [AUTO_LANGUAGE]". }
        }
        } 
    ORDER BY ?birthYear



### Préparer la requête CONSTRUCT

Nous choisissons d'utiliser les URI des classes telles que présentes dans OntoME. Pour les label, on utilisera rdfs:label et pour l'année de naissance une propriété locale, _persodb:birthYear_.

    PREFIX persodb: <http://localhost.org/personal_db/>
    PREFIX ontome_class: <https://ontome.net/class/>


    CONSTRUCT {
    ?item a ontome_class:21.
    ?item rdfs:label ?itemLabel.
    ?item persodb:birthYear ?birthYear.
    ?item wdt:P21 ?gender.
    }
    WHERE {
    SELECT DISTINCT ?item ?itemLabel ?birthYear ?gender
        WHERE {
            {
        {?item wdt:P106 wd:Q11063}
        UNION
            {?item wdt:P101 wd:Q333} 

            }        
        # Tous les humains, afin d'exclure des éventuelles instances d'autres classes    
        ?item wdt:P31 wd:Q5;  
            OPTIONAL { ?item wdt:P569 ?birthDate.
                    BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?birthYear)
                    }
            OPTIONAL { ?item wdt:P21 ?gender}
        OPTIONAL {
            SERVICE wikibase:label { bd:serviceParam wikibase:language "en, [AUTO_LANGUAGE]". }
        }
        }
    ORDER BY DESC(?birthYear)
    LIMIT 10 
        }


## Créer les triplets dans sa base personnelle Fuseki

Exécuter dans la boîte de dialogue SPARQL de votre serveur Fuseki local, e.g.: http://localhost:3131/#/dataset/personal_db/query


    PREFIX persodb: <http://localhost.org/personal_db/>
    PREFIX ontome_class: <https://ontome.net/class/>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX wikibase: <http://wikiba.se/ontology#>
    PREFIX wdt: <http://www.wikidata.org/prop/direct/>
    PREFIX wd: <http://www.wikidata.org/entity/>
    PREFIX bd: <http://www.bigdata.com/rdf#>

    WITH <http://localhost.org/personal_db/wikidata>
    INSERT {
    ?item a ontome_class:21.
    ?item rdfs:label ?itemLabel.
    ?item persodb:birthYear ?birthYear.
    ?item wdt:P21 ?gender.
    }
    WHERE {
    SERVICE <https://query.wikidata.org/sparql> {
        SELECT DISTINCT ?item ?itemLabel ?birthYear ?gender
            WHERE {
                {
            {?item wdt:P106 wd:Q11063}
            UNION
                {?item wdt:P101 wd:Q333} 

                }        
            # Tous les humains, afin d'exclure des éventuelles instances d'autres classes    
            ?item wdt:P31 wd:Q5;  
                OPTIONAL { ?item wdt:P569 ?birthDate.
                        BIND(REPLACE(str(?birthDate), "(.*)([0-9]{4})(.*)", "$2") AS ?birthYear)
                        }
                OPTIONAL { ?item wdt:P21 ?gender}
            OPTIONAL {
                SERVICE wikibase:label { bd:serviceParam wikibase:language "en, [AUTO_LANGUAGE]". }
            }
            }
            }
    }


### Vérifier le nombre d'individus par classe

Comme le dépôt ne contenait pas de personnes, on a là l'effecitf des personnes importées

    SELECT ?class (COUNT(*) as ?eff)
    WHERE {
    GRAPH <http://localhost.org/personal_db/wikidata> {
    ?s a ?class
    }
    }
    GROUP BY ?class 