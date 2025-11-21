
## Le point de départ: Wikipedia


### Population d'astronomes

<https://en.wikipedia.org/wiki/List_of_astronomers>

&nbsp;


### Une fiche d'astronome dans Wikipedia (données non-structurées et semi-structurées)

<https://en.wikipedia.org/wiki/Giovanni_Domenico_Cassini>

* Observer l'information que contient le texte
* Observer les propriétés de l'objet présentes dans l'infobox
  * [Infobox](https://en.wikipedia.org/wiki/Infobox)
  * [HelpInfobox](https://en.wikipedia.org/wiki/Help:Infobox)
* Procédure 'analogique': extraire 'manuellement' l'information du texte et de l'infobox et la mettre dans la base de données SQLite

&nbsp;


## La 'transcription' sous forme de graphe dans DBpedia

Le texte de Wikipedia est transformé en graphe rémantique basé sur des triplets RDF.

## DBPedia  

Présentation de DBPedia dans Wikipedia:
<https://en.wikipedia.org/wiki/DBpedia>

Documentation:

* [Linked Data Access](https://www.dbpedia.org/resources/linked-data/). Entre autres: spécification des URI, Content Negotiation
* [SPARQL over Online Databases](https://www.dbpedia.org/resources/sparql/) (documentation en partie obsolète)
* __Interfaces__ pour requêtes __SPARQL__:
  * <https://dbpedia.org/sparql>
  * <https://dbpedia.org/snorql/>  (navigateur, apparaît désactivé en novembre 2025)  

### DBPedia Live

Modifier Wikipedia et voir les résultats en temps réel

* <https://www.dbpedia.org/resources/live/>
* <https://live.dbpedia.org/sparql> (inaccessible en novembre 2025)
* NB : Default Data Set Name :  <http://live.dbpedia.org>

&nbsp;

### Une fiche d'astronome dans DBPedia (données structurées)

<https://dbpedia.org/page/Giovanni_Domenico_Cassini>

Les informations qui figurent sur cette page sont extraites de Wikipedia et produites sous forme de données structurées selon le [modéle RDF](https://fr.wikipedia.org/wiki/Resource_Description_Framework). RDF fonctionne sur un modèle "sujet -> prédicat-> objet", un **triplet**, l'ensemble des triplets formant un graphe orienté.

En d'autres termes, si la page apparaît comme étant du texte, en réalité elle présente, et rend lisibles, les données structurées sous forme de graphe de triplets concernant cette personne: un ensemble de triplets dont le sujet est toujours le même identifiant, ou URI/IRI, qui se réfère à la *ressouce* du monde que l'URI/IRI identifie.

Une ressource dans DBPedia est identifée par un URI dans l'espace de noms des ressources *http://dbpedia.org/resource/* et cette identification s'effectue par un **nom** qui est identifique à la partie spécifique de l'URL page web [_**Giovanni_Domenico_Cassini**_](https://en.wikipedia.org/wiki/Giovanni_Domenico_Cassini), *https://en.wikipedia.org/wiki/*. 

DBpedia (dbpedia.org) est une version sous forme de données structurées de la version anglophone de Wikipedia. Il existe aussi quelques versions linguistiques, en [français notamment](https://fr.dbpedia.org/) avec son propre [accès de requêtes SPARQL](https://fr.dbpedia.org/sparql).

On peut interroger le graphe DBpedia (voici l'adresse: **https://dbpedia.org/sparql**) et récupérer les triplets grâce à des requêtes formulées dans le langage SPARQL. Ce langage est une variante adapté au web sémantique du langage SQL.

    SELECT *
    WHERE {
      <http://dbpedia.org/resource/Giovanni_Domenico_Cassini> ?p ?o
    }

Plus en détail:

    # des commentaires peuvent être ajoutés en les 
    # faisant précéder par un dièse

    SELECT *  # ?p ?o 
    
    # FROM ... -- la clause FROM pas nécessaire, il y a une seule 'table' pour ainsi dire et elle comprend tout le 'triplestore'
    
    WHERE {
      <http://dbpedia.org/resource/Giovanni_Domenico_Cassini> ?p ?o
    }




Le contenu du graphe qui part du *sujet Cassini* de la requête ci-dessus (URI: http://dbpedia.org/resource/Giovanni_Domenico_Cassini) est identique à celui affiché sur la [page DBpedia](https://dbpedia.org/page/Giovanni_Domenico_Cassini). Notez que l'URI ( I = identifier) de la ressource Cassini (formulée sour forme d'URL) est un identifiant unique dans le monde de DBpedia (l'espace de noms de DBPedia) et il contient le terme */resource/* alors que l'URL (L = locator) de la page qui permet de lire le graphe est un vrai URL et contient le terme */page/*. Dans le contexte des technologies du web sémantique on appelle ça le *dereferencing* de l'URI sur la page et donc sur l'URL. 

Notons aussi qu'on peut reécrire de manière plus compacte la requête en utilisant des préfixes permettant de ne pas répéter les espaces de noms:

    PREFIX dbr: <http://dbpedia.org/resource/>
    SELECT *
    WHERE 
    {
      dbr:Giovanni_Domenico_Cassini ?p ?o
    }

Par convention le préfixe-alias pour les ressources de DBpedia est **dbr**. 

Cf. le [carnet SPARQL](../../sparqlbooks/dbp_explore.sparqlbook.md) qui permet d'exécuter directement et de documenter en même temps les requêtes effectuées.

Il s'agit maintenant d'inspecter la page [page DBpedia](https://dbpedia.org/page/Giovanni_Domenico_Cassini) qui rend visible le graphe de triplets et de relever les  informations intéressantes qui sont disponibles.

Le sujet de la page est le sujet de tous les triplets (dans ce cas la personne). Les prédicats sont exprimés sous forme de propriétés (<u>_properties_</u> en anglais) 

Exemples de propriétés:

* dbp:birthDate
  * URI complète de la propriété: <http://dbpedia.org/property/birthDate>
  * préfixe de l'espace de noms: 'dbp' (pour <http://dbpedia.org/property/>) c'est-à-dire issu directement des liens hypertexte et de l'infobox
  * *dbp:birthDate* est ce qu'on appelle un qualified name, ou QName
  * noter que ces propriétés ont généralement comme cible une valeur (chaîne de caractères ou nombre) même si elles pointent sur un objet
* dbo:influencedBy
  * URI complète de la propriété: https://dbpedia.org/ontology/influenced
  * préfixe de l'espace de noms 'dbo': <http://dbpedia.org/ontology> qui se référe à des donnes qui ont été nettoyées
  * ce type de proriétés associée généralement un objet à un autre objet (et non à une valeur) et donc en objet du triplet on trouve une URI
  * essayez de naviguer d'un _influencer_ vers autre: c'est là qu'on voit des données structurées, toutes définies par des URI

Les triplets qui utilisent les propriétés de l'espace de noms 'http://dbpedia.org/property/' sont issues d'une première extraction, celles de l'espace de noms http://dbpedia.org/ontology/ ont été soumises à un processus de nettoyage et sont donc généralement à préférer.
  
&nbsp;

À noter (parmi d'autres entités):

* dbr:List_of_astrologers
* [dbr:List_of_astronomers](http://dbpedia.org/resource/List_of_astronomers)
  * En entier la première entrée donne http://dbpedia.org/resource/List_of_astrologers.
  * dbr:List_of_astrologers* est donc un QName
* [dbr:Astronomer](http://dbpedia.org/resource/astronomer)
* dbr:Astrology
* dbr:Astronomy


dbr: est le préfixe qui remplace http://dbpedia.org/resource/, le monde des ressources donc qui peuvent être des personnes, mais aussi des pages web, des concepts, etc. 

### Inspecter les propriétés disponibles



    ### Regrouper et compter les propriétés disponibles
    PREFIX dbr: <http://dbpedia.org/resource/>
    SELECT ?p (COUNT(*) as ?number)
    WHERE 
    {
      dbr:Giovanni_Domenico_Cassini ?p ?o
    }
    GROUP BY ?p
    ORDER BY DESC(?number)



&nbsp;

## Explorer DBpedia

### SPARQLIS

Une application qui liste les classes et les propriétés d'un graphe et facilite la recherche d'information

* [SPARQLIS sur DBPedia](http://www.irisa.fr/LIS/ferre/sparklis/?title=Core%20English%20DBpedia&endpoint=http%3A//servolis.irisa.fr/dbpedia/sparql)
* [Example queries for Sparklis](http://www.irisa.fr/LIS/ferre/sparklis/examples.html)

SPARQLIS permet de construire des requêtes SPARQL grâce à une interface graphique

&nbsp;

## Requêtes d'exploration

* Interface pour requêtes: __<https://dbpedia.org/sparql>__
* La syntaxe des requêtes (la recommandation du consortium W3C ): <https://www.w3.org/TR/sparql11-query>
  * Noter les exemples en particulier qui facilitent la compréhension et l'apprentissage
* Tutoriels:
  * [Tutoriel: *SPARQL Query Examples for Querying DBpedia*](https://sparql.dev/article/SPARQL_query_examples_for_querying_DBpedia.html)
  * [Un autre tutoriel SPARQL](https://web-semantique.developpez.com/tutoriels/jena/arq/introduction-sparql/) (plus technique) 
  

&nbsp;

### Occupation: astronomer

Dans l'exploration d'une population, on pourrait partir du métier ou autre forme d'activité, cf. la notice de Wikipedia [Astronomer](https://en.wikipedia.org/wiki/Astronomer) dont on utilise l'URI dans la requête SPARQL qui suit: 

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    
    SELECT DISTINCT ?s1 ?birthDate
    WHERE { ?s1 dbo:occupation dbr:Astronomer .
        OPTIONAL { 
                   ?s1 dbo:birthYear ?birthDate .
                   }
          }
    LIMIT 10

* Ici on utilise la propriété *dbo:occupation* en lien avec le concept (occupation) d'astronome (une ressource, dbr) pour retrover toutes les ressources en sujet qui ont 
* on associe en même temps la propriété facultative années de naissance
* cette requête liste 200 astronomes (novembre 2025), le maximum des effectifs avec cette approche

#### Compter les astronomes

      PREFIX dbr: <http://dbpedia.org/resource/>
      PREFIX dbo: <http://dbpedia.org/ontology/>
      PREFIX dbp: <http://dbpedia.org/property/>
      SELECT (COUNT(*) as ?effectif)
      WHERE { ?s1 dbo:occupation dbr:Astronomer .
      }

* Noter que changer les espaces de noms dbp et dbo donne des résultats différents: essayez avec la propriété dbr:occupation
* Les données liées à la propriété dbr étant en partie des chaînes de caractères 'astronomer' et non des URI, elles ne sortiront pas et il y a donc moins de résultats

#### Compter les astronomes en tant que personnes


      PREFIX dbr: <http://dbpedia.org/resource/>
      PREFIX dbo: <http://dbpedia.org/ontology/>
      PREFIX dbp: <http://dbpedia.org/property/>
      SELECT (COUNT(*) as ?effectif)
      WHERE { ?s1 dbo:occupation dbr:Astronomer ;
                  a dbo:Person.
      }

* On cherche seulement les personnes
* rdf:type est raccourci avec l'expression 'is a' et donc 'a'


#### Quel astronome n'est pas une personne ?

      PREFIX dbr: <http://dbpedia.org/resource/>
      PREFIX dbo: <http://dbpedia.org/ontology/>
      PREFIX dbp: <http://dbpedia.org/property/>
      SELECT ?s1
      WHERE { ?s1 dbo:occupation dbr:Astronomer.
                  MINUS { ?s1 a dbo:Person.}
      }

http://dbpedia.org/resource/Senku_Ishigami: un personnage de fiction


&nbsp;

## Utiliser les listes pour identifer la population


### Liste: dbr:List_of_astronomers

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT DISTINCT ?p ?o1 
    WHERE { 
      dbr:List_of_astronomers ?p ?o1.
      ?o1 a dbo:Person.
      }
    LIMIT 10

#### Objets qui ne sont pas des personnes

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT ?p ?o1
    WHERE { 
    dbr:List_of_astronomers ?p ?o1.
    MINUS {?o1 a dbo:Person.}
      }
##### Compter: les effectifs par propriété
    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT  ?p  (COUNT(*) as ?number)
    WHERE { 
    dbr:List_of_astronomers ?p ?o1.
    MINUS {?o1 a dbo:Person.}
      }
    GROUP BY ?p
    ORDER BY DESC(?number)

### Effectif de la population

Effectifs au 12 novembre 2025 : 768

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT (COUNT(*) as ?eff)
    WHERE { 
    dbr:List_of_astronomers ?p ?o1.
    ?o1 a dbo:Person.
      }

###  Propriétés sortantes et effectifs

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT ?p1 (COUNT(*) as ?eff)
    WHERE { 
    dbr:List_of_astronomers ?p ?o1.
    ?o1 a dbo:Person;
        ?p1 ?o2.
      }
    GROUP BY ?p1
    ORDER BY DESC(?eff)

Noter ces propriétés:

* <http://dbpedia.org/property/birthDate>: 443
* <http://dbpedia.org/ontology/birthDate>: 396

&nbsp;


## Limiter à la population de l'époque contemporaine


### Filtre par date de naissance

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT ?person ?birthYear
    WHERE {
       dbr:List_of_astronomers ?p ?person.
       ?person a dbo:Person;
            dbo:birthDate ?birthDate.

        # noter ici la restriction à l'année, la chaîne de caractères de la date au format ISO est transformée en entier    
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( ?birthYear > 1770) 
      }
    ORDER BY ?birthYear  



### Effectif de la population

Effectifs au 17 novembre 2025 : 368

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT (COUNT(*) as ?eff)
    WHERE {
       dbr:List_of_astronomers ?p ?person.
       ?person a dbo:Person;
            dbo:birthDate ?birthDate.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( ?birthYear > 1770) 
      }

###  Propriétés sortantes et effectifs

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT ?p1 (COUNT(*) as ?eff)
    WHERE { 
    dbr:List_of_astronomers ?p ?person.
    ?person a dbo:Person;
            dbo:birthDate ?birthDate ;
        ?p1 ?object.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( ?birthYear > 1770)
      }
    GROUP BY ?p1
    ORDER BY DESC(?eff)


###  Propriétés entrantes et effectifs

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT ?p1 (COUNT(*) as ?eff)
    WHERE { 
    dbr:List_of_astronomers ?p ?person.
    ?person a dbo:Person;
            dbo:birthDate ?birthDate.
    ?subject ?p1 ?person.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( ?birthYear > 1770)
      }
    GROUP BY ?p1
    ORDER BY DESC(?eff)



&nbsp;



Avec les labels des noms (en anglais), même effectif:

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>

    SELECT (COUNT(*) AS ?number)
    WHERE { 
        dbr:List_of_astronomers ?p ?person.
        ?person a dbo:Person;
                dbo:birthDate ?birthDate;
                rdfs:label ?label.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( ?birthYear > 1770
                && LANG(?label) = 'en')
      }

Toutes les personnes ont donc un (et apparemment un seul) nom en anglais, mais on va encore verifier.


## Liste des astronomes

Cette requête produit une liste de personnes avec leur nom en anglais et année de naissance.

Pour importer les données dans une base de données SQLite, suivre les [instructions indiquées sur cette page](DBpedia_importer_dans_base_personnelle.md) (et les suivantes): 



    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>

    SELECT ?person (STR(?label) AS ?persName) ?birthYear
    WHERE { 
        dbr:List_of_astronomers ?p ?person.
        ?person a dbo:Person;
                dbo:birthDate ?birthDate;
                rdfs:label ?label.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( ?birthYear > 1770
                && LANG(?label) = 'en')
      }
    ORDER BY ?birthYear

  
