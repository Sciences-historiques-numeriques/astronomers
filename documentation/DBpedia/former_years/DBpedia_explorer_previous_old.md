
## Le point de départ: Wikpedia


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


## La 'transcription' dans DBpedia


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

Les informations qui figurent sur cette page sont extraites de Wikipedia et produites sous forme de données structurées selon le [modéle RDF](https://fr.wikipedia.org/wiki/Resource_Description_Framework).

En d'autres termes, si la page apparaît comme étant du texte, en réalité elle présente, et rend lisibles, les données structurées sous forme de graphe concernant cette personne: un ensemble de triplets dont le sujet est toujours le même identifiant, ou URI/IRI, qui se réfère à la *ressouce* qu'il identifie.

Une ressource dans DBPedia est identifée par un URI dans l'espace de noms des ressources *http://dbpedia.org/resource/* et cette identification s'effectue par un nom qui est identifique à la partie spécifique de l'URL page web [*Giovanni_Domenico_Cassini*](https://en.wikipedia.org/wiki/Giovanni_Domenico_Cassini), *https://en.wikipedia.org/wiki/*. DBpedia (dbpedia.org) est une version sous forme de données structurées de la version anglophone de Wikipedia. Il existe aussi quelques versions linguistiques, français notamment.

On peut interroger le graphe DBpedia (voici l'adresse: https://dbpedia.org/sparql) et récupérer les triplets grâce à des requêtes formulées dans le langage SPARQL. Ce langage est une variante adapté au web sémantique du langage SQL.

    SELECT *  # ou ?p ?o 
    
    # FROM ... -- pas nécessaire, il y a une seule 'table', tout le 'triplestore'
    
    WHERE {
      <http://dbpedia.org/resource/Giovanni_Domenico_Cassini> ?p ?o
    }



Le contenu du graphe qui part du *sujet Cassini* (URI: http://dbpedia.org/resource/Giovanni_Domenico_Cassini) est identique à celui affiché sur la [page DBpedia](https://dbpedia.org/page/Giovanni_Domenico_Cassini). Notez que l'URI, même si formulée sour forme d'URL, c'est un identifiant et il contient le terme */resource/* alors que l'URL de la page, un vrai URL, contient le terme */page/*. On appelle ça le *dereferencing* de l'URI sur la page et donc l'URL. 

Notons aussi qu'on peut reécrire de manière plus compacte la requête en utilisant des préfixes:

    PREFIX dbr: <http://dbpedia.org/resource/>
    SELECT *
    WHERE 
    {
      dbr:Giovanni_Domenico_Cassini ?p ?o
    }

Par convention le préfixe-alias pour les ressources de DBpedia est dbr, pour *resources*.


Il s'agit maintenant d'inspecter la page [page DBpedia](https://dbpedia.org/page/Giovanni_Domenico_Cassini) (qui rend visible le graphe) et de  relever les  informations intéressantes qui sont disponibles. RDF fonctionne sur un modèle "sujet -> prédicat-> objet" qui constitue les triplets.

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
  * ce type de proriétés associée généralement un objet à un autre objet (et non à une valeur) et donc en sobjet du triplet on trouve une URI
  * essayez de naviguer d'un _influencer_ vers autre: c'est là qu'on voit des données structurées, toutes définies par des URI
  
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
  * [Le tutoriel SPARQL](https://web-semantique.developpez.com/tutoriels/jena/arq/introduction-sparql/) 
  * Tutoriel vidéo: [Partie I](https://www.youtube.com/watch?v=Z8_rTxy67-8) , [Partie II](https://www.youtube.com/watch?v=HlOJSsu3_to)

&nbsp;

### Occupation: astronomer

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

* Cette requête liste 200 astronomes (novembre 2025), le maximum des effectifs avec cette approche

#### Compter les astronomes

      PREFIX dbr: <http://dbpedia.org/resource/>
      PREFIX dbo: <http://dbpedia.org/ontology/>
      PREFIX dbp: <http://dbpedia.org/property/>
      SELECT (COUNT(*) as ?effectif)
      WHERE { ?s1 dbo:occupation dbr:Astronomer .
      }

* Noter que changer les espaces de noms dbp et dbo donne des résultats différents: essayez avec la propriété dbr:occupation

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

### Astronomes nés entre 1371 et nous jours / 1770

    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    PREFIX dbp: <http://dbpedia.org/property/>
    SELECT DISTINCT ?thing_1 ?intYear
    WHERE { ?thing_1 dbo:occupation dbr:Astronomer .
         ?thing_1 dbo:birthYear ?birthYear .
         BIND(xsd:integer(str(?birthYear)) AS ?intYear)
    FILTER ( (?intYear >= 1371
    ###  La clause de filtre ci-dessous est commentée, i.e. non active. Décommenter pour l'activer
    #              && ?intYear < 1771 
                  ) ) }
    ORDER BY ?intYear

Leur effectif (3 décembre 2022): 23 / 124

La requête ci-dessous ne change rien, en espace de noms dbr seulement 13 astronomes

    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    PREFIX dbp: <http://dbpedia.org/property/>
    SELECT (COUNT(*) as ?effectif)
    WHERE {
      {SELECT DISTINCT ?thing_1
           WHERE {
        { ?thing_1 dbo:occupation dbr:Astronomer }
        UNION
        {?thing_1 dbp:occupation dbr:Astronomer}
              }
        }
     ?thing_1 dbo:birthYear ?birthYear .
     BIND(xsd:integer(str(?birthYear)) AS ?intYear)
    FILTER ( (?intYear >= 1371 
      #        && ?intYear < 1771 
              ) ) }
    ORDER BY ?intYear

&nbsp;

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
    SELECT ?o1    # (COUNT(*) as ?eff)
    WHERE { 
    dbr:List_of_astronomers ?p ?o1.
    MINUS {?o1 a dbo:Person.}
      }

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

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbp: <http://dbpedia.org/property/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT (COUNT(*) as ?eff)
    WHERE { 
    dbr:List_of_astronomers ?p ?o1.
    ?o1 a dbo:Person;
      dbp:birthDate ?birthDate.
    BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
    FILTER ( (?birthYear >= 1371
    #            && ?birthYear < 1771
     ) ) 
          }

&nbsp;

Documentation: [Property path syntax](https://www.w3.org/TR/sparql11-property-paths/)

Alternative entre propriétés  ( | ):

Effectif: 56


    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbp: <http://dbpedia.org/property/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT DISTINCT ?o1 ?birthDate ?birthYear
    WHERE { 
    dbr:List_of_astronomers ?p ?o1.
    ?o1 a dbo:Person;
      dbp:birthDate | dbo:birthDate ?birthDate.
    BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
    FILTER ( (?birthYear >= 1371
      #          && ?birthYear < 1771 
                ) ) 
          }
    ORDER BY ?birthYear

&nbsp;

Astonomes et _astrologues_ et _mathématiciens_:

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbp: <http://dbpedia.org/property/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT DISTINCT ?o1 ?birthDate ?birthYear
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
      dbp:birthDate | dbo:birthDate ?birthDate.
    BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
    FILTER ( (?birthYear >= 1371
      #          && ?birthYear < 1771 
                ) ) 
          }
    ORDER BY ?birthYear

&nbsp;

Effectif : 292 / 5138 mathématiciens, astrologues, astronomes

__Définition de la population__: cette requêtes définit la population — cette requête sera la base de toutes les autres

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbp: <http://dbpedia.org/property/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT (COUNT(*) as ?effectif)
    WHERE {
      SELECT DISTINCT ?o1 ?birthDate ?birthYear
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
          dbp:birthDate | dbo:birthDate ?birthDate.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( (?birthYear >= 1371
           #         && ?birthYear < 1771 
                    
                    ) ) 
              }
      }

        

&nbsp;
Avec les labels des noms (en anglais), même effectif:

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbp: <http://dbpedia.org/property/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT (COUNT(*) as ?effectif)
    WHERE {
      SELECT DISTINCT ?o1 ?birthDate ?birthYear ?label
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
          UNION
              {?o1 ?p dbr:Physicist.}

        }
        ?o1 a dbo:Person;
          dbp:birthDate | dbo:birthDate ?birthDate;
          rdfs:label ?label.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( (?birthYear >= 1371
              #      && ?birthYear < 1771 
                  )
                    && LANG(?label) = 'en') 
              }
      }


&nbsp;

## Les propriétés

### Liste des propriétés sortantes

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT ?p1 (COUNT(*) as ?eff)
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
          UNION
              {?o1 ?p dbr:Physicist.}    
        }
    ?o1 a dbo:Person;
    dbp:birthDate | dbo:birthDate ?birthDate;
        ?p1 ?o2.
    BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
    FILTER ( (?birthYear >= 1371  )) 
      }
    GROUP BY ?p1
    ORDER BY DESC(?eff)

### Liste des propriétés entrantes

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT ?p1 (COUNT(*) as ?eff)
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
          UNION
              {?o1 ?p dbr:Physicist.}
        }
    ?o1 a dbo:Person;
    dbp:birthDate | dbo:birthDate ?birthDate.
    ?o2 ?p1 ?o1.
    BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
    FILTER ( (?birthYear >= 1371  )) 
      }
    GROUP BY ?p1
    ORDER BY DESC(?eff)

&nbsp;



### Liste des astronomes—astrologues

Cette requête produit une liste de personnes.

Si on veut importer les données dans une base de données SQLite, suivre les [instructions indiquées sur ces pages](Importer_DBpedia_base_personnelle.md): 



    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbp: <http://dbpedia.org/property/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT DISTINCT ?o1  (str(?label) as ?name) ?birthYear
    WHERE {
    SELECT DISTINCT ?o1 ?birthDate ?birthYear ?label
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
        UNION
            {?o1 ?p dbr:Physicist.}

      }
      ?o1 a dbo:Person;
        dbp:birthDate | dbo:birthDate ?birthDate;
        rdfs:label ?label.
      BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
      FILTER ( (?birthYear >= 1371
      #            && ?birthYear < 1771 
                  )
                  && LANG(?label) = 'en') 
            }
    }
    ORDER BY ?birthYear

  
