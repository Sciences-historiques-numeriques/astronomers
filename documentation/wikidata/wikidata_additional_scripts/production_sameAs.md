# Production de relations sameAs

Pour trouver les URI des ressources correspondantes on utilisé les propriétés Wikidata mais on écrit en utiliant owl:sameAs .


## IdRef

Cette requête est à exécuter sur son propre serveur Fuseki. Elle va lire les liens dans Wikidata et les écrire dans le graphe indiqué dans la clause WITH.

    PREFIX wdt: <http://www.wikidata.org/prop/direct/>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>
    PREFIX wd: <http://www.wikidata.org/entity/>
    
    WITH <http://localhost.org/personal_db/wikidata>
    INSERT {
    ?item owl:sameAs ?idref_uri.
    }
    WHERE {
        SERVICE <https://query.wikidata.org/sparql> {
        {?item wdt:P106 wd:Q11063}
        UNION
        {?item wdt:P101 wd:Q333}    
        ?item wdt:P31 wd:Q5;
              wdt:P269 ?id.
    
    BIND(URI(CONCAT('http://www.idref.fr/', ?id, '/id')) as ?idref_uri)
        }
       }
   
