# Importer et structurer les données issues de DBPedia

Ces instructions concernent l'importation des données issues de DBPedia dans la base de données générique.

La base de données de ce projet se trouve dans le dossier [_astronomers/data/generic_database.sqlite_](https://github.com/Sciences-historiques-numeriques/astronomers/tree/main/data)


## Instructions générales

Pour vider complètement les tables, utiliser l'instruction suivante. Mais attention: cette instruction est irréversible !

    /*
    La ligne est commentée afin d'éviter toute erreur de manipulation — décommenter la ligne afin de l'exécuter, puis recommenter
    */
    --DELETE FROM "statement" ;
    /* 
    après avoir vidé la table exécuter une instruction vacuum afin de vider la mémoire
    */
    VACUUM;

Normalement cette instruction remet à zéro les valeurs des clés primaires autoincrémentées
&nbsp;

## Importation des données depuis les CSV

Importer les donnnées depuis le CSV dans la table 'statement', cf. les instructions dans la page Explorer DBPedia.




### Liste des astronomes—astrologues à exporter

Noter la propriété <http://dbpedia.org/ontology/birthYear> ajoutée en vue de l'import dans la base de données SQLite. 

Sauvegarder au format CSV, puis ouvrir dans DBeaver et importer dans la table 'statement' en mettant les valeurs dans les champs.

Si nécessaire, vider préalablement la table _statement_ en suivant les instructions ci-dessus.

ATTENTION: dans l'interface graphique DBeaver, ne pas créer de nouveaux champs mais mettre ainsi:

* ?subject dans le champs subject_uri
* ?predicate dans property_uri
* ?object dans numeric_value
* ?import_metadata dans import_metadata

Ce dernier champs est important pour tracer les import et garder souvenir de la source.

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbp: <http://dbpedia.org/property/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    PREFIX rdfs:<http://www.w3.org/2000/01/rdf-schema#>
    SELECT (?o1 as ?subject) (dbo:birthYear as ?predicate) (?birthYear AS ?object) ('20231204_1' as ?import_metadata)
    WHERE {
      SELECT DISTINCT ?o1 ?birthYear
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
      rdfs:label ?label.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( (?birthYear >= 1451   && ?birthYear < 1771 )  && LANG(?label) = 'en') 
              }
      ORDER BY ?birthYear
      }

292 lignes exportées le 3 décembre 2022

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
        }
    ?o1 a dbo:Person;
    dbp:birthDate | dbo:birthDate ?birthDate;
        ?p1 ?o2.
    BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
    FILTER ( (?birthYear >= 1451   && ?birthYear < 1771 )) 
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
        }
    ?o1 a dbo:Person;
    dbp:birthDate | dbo:birthDate ?birthDate.
    ?o2 ?p1 ?o1.
    BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
    FILTER ( (?birthYear >= 1451   && ?birthYear < 1771 )) 
      }
    GROUP BY ?p1
    ORDER BY DESC(?eff)

&nbsp;

### Le nom

Cette requête prépare les données pour importation. Enregistrer dans un fichier CSV puis importer dans la table statements
ATTENTION: ne pas créer de nouveaux champs mais mettre ainsi

* ?o1 dans le champs subject_uri
* ?property dans property_uri
* ?str_label dans text_value
* ?import_metadata dans import_metadata

&nbsp;

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbp: <http://dbpedia.org/property/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    PREFIX rdfs:<http://www.w3.org/2000/01/rdf-schema#>
    SELECT ?o1 (rdfs:label as ?property) ?str_label ('20221204_3' as ?import_metadata)
    WHERE {
      SELECT DISTINCT ?o1 (STR(?label) as ?str_label)
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
      rdfs:label ?label.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( (?birthYear >= 1451   && ?birthYear < 1771 )  && LANG(?label) = 'en') 
              }
      ORDER BY ?birthYear
      }

### Trouver les URI correspondantes à DBPedia francophone

Cette requête prépare les données pour importation. Enregistrer dans un fichier CSV puis importer dans la table statements
ATTENTION: ne pas créer de nouveaux champs mais mettre ainsi

* ?o1 dans le champs subject_uri
* ?property dans property_uri
* ?target dans object_uri
* ?import_metadata dans import_metadata

&nbsp;

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbp: <http://dbpedia.org/property/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    PREFIX rdfs:<http://www.w3.org/2000/01/rdf-schema#>
    PREFIX owl:	<http://www.w3.org/2002/07/owl#>
    SELECT ?o1 (owl:sameAs as ?property) ?target ('20221204_4' as ?import_metadata)
    # (COUNT(*) AS ?effectif) 
    WHERE {
      {
      SELECT DISTINCT ?o1 ?target 
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
          owl:sameAs ?target.
    
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( (?birthYear >= 1401   && ?birthYear < 1771 )  ) 
        ### Erreur sur Maldonado
        FILTER (CONTAINS( STR(?target), 'fr.dbp') && !CONTAINS( STR(?o1), 'Pedro_Vicente_Maldonado'))
              }
    }
    
      }

Seulement 257 renseignés

### Occupation

Si on ajoute le _label_ on n'a que les URI des _occupations_, si on enlève la condition de jointure sur le _label_ on a aussi les textes, les litérals (cf. requête ci-dessous).

Car la propriété pointe à la fois sur des literals et des URI. 

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbp: <http://dbpedia.org/property/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    PREFIX rdfs:<http://www.w3.org/2000/01/rdf-schema#>
    SELECT DISTINCT (?o1 AS ?subject_uri) (dbo:occupation as ?property_uri) (?target AS ?object_uri) (?name as ?label) ('20221211_1' as ?import_metadata)
    # (COUNT(*) AS ?effectif) 
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
        FILTER ( (?birthYear >= 1451   && ?birthYear < 1771 )  && LANG(?label) = 'en') 
              }
      ORDER BY ?birthYear
      }

170 lignes exportées le 3 décembre 2022

Une partie des individus n'a pas d'occupation explicite.

### Récupérer les occupations sous forme de literal

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbp: <http://dbpedia.org/property/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    PREFIX rdfs:<http://www.w3.org/2000/01/rdf-schema#>
    SELECT DISTINCT (?o1 AS ?subject_uri) (dbp:occupation as ?property_uri) (STR(?target) AS ?text_value) ('20221211_2' as ?import_metadata)
    # (COUNT(*) AS ?effectif) 
    WHERE {
      SELECT DISTINCT ?o1 ?target 
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
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( (?birthYear >= 1451   && ?birthYear < 1771 )  && !isIRI(?target) && strlen(STR(?target)) > 0)
              }
      ORDER BY ?birthYear
      }


67 lignes en décembre 2022. La propriété _dbo:occupation_ ne pointe pas vers des litérals


### Field(s) and Academic Discipline

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbp: <http://dbpedia.org/property/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    PREFIX rdfs:<http://www.w3.org/2000/01/rdf-schema#>
    SELECT DISTINCT (?o1 AS ?subject_uri) (dbp:field as ?property_uri) (?target AS ?object_uri) (?name as ?label) ('20221213_1' as ?import_metadata)
    (COUNT(*) AS ?effectif) 
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
          dbp:field | dbp:fields | dbo:academicDiscipline ?target.
      ?target rdfs:label ?label.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( (?birthYear >= 1451   && ?birthYear < 1771 )  && LANG(?label) = 'en') 
              }
      ORDER BY ?birthYear
      }

352 lignes 13 décembre 2022 : exporté sous forme de CSV et importé dans table _statement_


### Vérification après import des données

    -- compter les instances
    SELECT COUNT(*)
    FROM "statement" ;

### Créer les personnes

On a préalablement créé la classe _Person_ dans la table _Class_.

On effectue une requête sur la table _statement_, on sélection les entités qu'on vient d'importer et on ajoute dans la clause SELECT la valeur de la classe _Person_ et les métadonnées d'importation, pour garder trace explicite

    INSERT INTO "instance" (external_uri, fk_class, import_metadata)
    SELECT subject_uri, 1, '20221204_2' FROM "statement" s
    WHERE import_metadata LIKE '%20221204_1%' ;

#### Vérification

Regrouper les instances par classe. Noter la jointure avec la table _class_  


    SELECT c.label, COUNT(*) eff
    FROM "instance" i, class c 
    WHERE i.fk_class = c.pk_class 
    GROUP BY c.label 
    ORDER BY eff DESC ;

### Ajouter un lien en clé étrangère entre les instances et les assertions

    -- inspecter les instances avec les propriétés

    SELECT i.pk_instance, i.external_uri, s.pk_statement, s.subject_uri 
    FROM "instance" i , "statement" s 
    WHERE s.subject_uri = i.external_uri ;

    -- ajouter les valeurs de clé étrangère entre les assertions et les instances

    UPDATE "statement" set fk_subject_instance = i.pk_instance 
    FROM "instance" i 
    WHERE "statement".subject_uri = i.external_uri ;


### Ajouter les noms des personnes

Importer le CSV qui contient les labels selon les instructions de la page dédiée à DBPedia.

Pour vérifier l'import exécuter la requête suivante:

    SELECT property_uri, COUNT(*) as effectif 
    FROM "statement" s   
    GROUP BY s.property_uri 
    ORDER BY effectif DESC ;

#### Ajouter les noms des personnes dans les instances

    UPDATE "instance" set label = s.text_value  
    FROM "statement" s 
    WHERE s.subject_uri = "instance".external_uri ;	

# Traitement des _occupations_

Importer les deux CSV contenant les _occupations_ sous forme de ressources et de _literals_

## Exploration

### Regroupement par URI de 'occupation'

On constate des inconsistences et des ortographes ou appellation différentes pour le même concept. Je corrige à la main les labels sur la base de cette liste et j'utiliserai les labels pour créer les 'occupations' dans la table Instances

    SELECT object_uri, count(*) as effectif  
    FROM "statement" s 
    WHERE import_metadata  = '20221211_1' 
    GROUP BY object_uri ;


J'efface deux lignes visiblement erronées:
* <http://dbpedia.org/resource/Riobamba>
* <http://dbpedia.org/resource/Mughal_Empire>

&nbsp;


### Liste des occupations qui seront créées

    SELECT label, count(*) as effectif  
    FROM "statement" s 
    WHERE import_metadata  = '20221211_1' 
    GROUP BY label
    ORDER BY effectif DESC ;


### Créer les occupations

    INSERT INTO "instance" (label, fk_class, import_metadata)
    SELECT label, 2, '20221211_3' 
    FROM "statement" s 
    WHERE import_metadata  = '20221211_1' 
    GROUP BY label;

#### Vérification
    SELECT c.label, COUNT(*) eff
    FROM "instance" i, class c 
    WHERE i.fk_class = c.pk_class 
    GROUP BY c.label 
    ORDER BY eff DESC ;

### Reporter la clé des occupations vers les statements

    UPDATE "statement" set fk_object_instance  = i.pk_instance 
    FROM "instance" i 
    WHERE i.fk_class = 2
    AND "statement".label = i.label 
    AND metadata_import = '20221211_1' ;

### Reporter la clé des personnes vers les statements
    UPDATE "statement" set fk_subject_instance = i.pk_instance 
    FROM "instance" i 
    WHERE "statement".subject_uri = i.external_uri
    AND "statement".import_metadata = '20221211_1'  ;

### Chercher puis supprimer les doublons

NB : il y a aussi des personnes non renseignées. Vérifier

    SELECT fk_subject_instance, fk_object_instance, COUNT(*) as eff 
    FROM "statement" s  
    WHERE s.import_metadata  = '20221211_1'  
    AND fk_subject_instance IS NOT NULL 
    GROUP BY fk_subject_instance, fk_object_instance
    HAVING COUNT(*) > 1 ;

#### Requête pour le nettoyage dans DBeaver

    SELECT * 
    FROM "statement" s2 
    WHERE fk_subject_instance IN (
        SELECT fk_subject_instance 
        FROM "statement" s  
        WHERE s.import_metadata  = '20221211_1'  
        AND fk_subject_instance IS NOT NULL 
        GROUP BY fk_subject_instance, fk_object_instance
        HAVING COUNT(*) > 1 )
    AND property_uri LIKE '%occupation%';


## Créer les pursuits

    INSERT INTO "instance" (import_metadata, notes, fk_class)
    SELECT pk_statement || '_20221211_4' , pk_statement, 3
    FROM "statement" s 
    WHERE import_metadata = '20221211_1'
    AND fk_subject_instance IS NOT NULL;


### Créer l'association à la personne

    INSERT INTO "statement" (fk_subject_instance, fk_property, fk_object_instance, import_metadata)
    SELECT  i.pk_instance, 1, s.fk_subject_instance, '20221211_6_'|| i.pk_instance 
    FROM "instance" i, "statement" s 
    WHERE i.notes = s.pk_statement ;

### Créer l'association à la profession
    INSERT INTO "statement" (fk_subject_instance, fk_property, fk_object_instance, import_metadata)
    SELECT  i.pk_instance, 2, s.fk_object_instance, '20221211_5_'|| i.pk_instance 
    FROM "instance" i, "statement" s 
    WHERE i.notes = s.pk_statement ;

## Créer la vue qui liste les professions

    --DROP VIEW v_pursuits;
    CREATE VIEW v_pursuits AS
    SELECT i.pk_instance, s1.pk_statement, i1.pk_instance, i1.label, i2.label label_occupation, s2.pk_statement pk_statement_occupation
    FROM "instance" i
    LEFT JOIN "statement" s1 ON s1.fk_subject_instance = i.pk_instance AND s1.fk_property = 1 
    LEFT JOIN "instance" i1 ON s1.fk_object_instance = i1.pk_instance
    LEFT JOIN "statement" s2 ON s2.fk_subject_instance = i.pk_instance AND s2.fk_property = 2  
    LEFT JOIN "instance" i2 ON s2.fk_object_instance = i2.pk_instance
    WHERE i.fk_class = 3;


### Interroger la vue

SELECT *
FROM v_pursuits;


## Traitement des _fields_

### Vérifier s'il y a des doublons entre _occupations_ et _fields_

352 fields, pas de superpositions

    WITH tw1 as (
    SELECT subject_uri, label 
    FROM "statement" s WHERE property_uri = 'http://dbpedia.org/property/field'
    EXCEPT 
    SELECT subject_uri, label
    FROM "statement" s WHERE property_uri = 'http://dbpedia.org/ontology/occupation'
    )
    SELECT s.subject_uri, s.label, s.property_uri 
    FROM tw1, "statement" s 
    WHERE s.subject_uri = tw1.subject_uri and s.label = tw1.label 
    ORDER by s.subject_uri ;

### Corrections des labels de 'field'

On constate les mêmes problèmes que pour occupation. Je corrige à la main les labels à partir des 'occupations' existantes


J'efface deux lignes visiblement erronées:
* <http://dbpedia.org/resource/Conic_section>

&nbsp;


### Liste des occupations qui seront créées

    WITH tw1 AS (
    SELECT label 
    FROM "statement" s 
    WHERE s.property_uri = 'http://dbpedia.org/property/field'
    EXCEPT
    SELECT label
    FROM "instance" i 
    WHERE fk_class = 2)
    SELECT s.label, count(*) as effectif   
    FROM "tw1" JOIN "statement" s ON s.label = "tw1".label 
    AND s.property_uri = 'http://dbpedia.org/property/field'
    GROUP BY s.label
    ORDER BY effectif DESC;



### Créer les occupations qui manquent

    WITH tw1 AS (
    SELECT label 
    FROM "statement" s 
    WHERE s.property_uri = 'http://dbpedia.org/property/field'
    EXCEPT
    SELECT label
    FROM "instance" i 
    WHERE fk_class = 2)
    INSERT INTO "instance" (label, fk_class, import_metadata)
    SELECT s.label, 2, '20221217_1' 
    FROM "tw1" JOIN "statement" s ON s.label = "tw1".label 
    AND s.property_uri = 'http://dbpedia.org/property/field'
    GROUP BY s.label;

#### Vérification
    SELECT c.label, COUNT(*) eff
    FROM "instance" i, class c 
    WHERE i.fk_class = c.pk_class 
    GROUP BY c.label 
    ORDER BY eff DESC ;

### Reporter la clé des occupations vers les statements

    UPDATE "statement" set fk_object_instance  = i.pk_instance 
    FROM "instance" i 
    WHERE i.fk_class = 2
    AND "statement".label = i.label 
    AND i.fk_class = 2;

### Reporter la clé des personnes vers les statements

    UPDATE "statement" set fk_subject_instance = i.pk_instance 
    FROM "instance" i 
    WHERE "statement".subject_uri = i.external_uri
    AND "statement".import_metadata = '20221213_1'
    AND i.fk_class = 1  ;


### Ajouter les personnes qui manquent

Étonnamment manquent un certain nombre de personnes. Je les ajoute

    INSERT INTO "instance" (external_uri, fk_class, import_metadata)
    SELECT DISTINCT  s.subject_uri, 1, '20221217_2'
    FROM "statement" s 
    WHERE fk_subject_instance  is null
    AND s.import_metadata = '20221213_1'  ;

Et je leur met rapidement un 'label':

    UPDATE "instance"
    SET label = TRIM(SUBSTRING(external_uri, LENGTH('http://dbpedia.org/resource/')+1))
    WHERE import_metadata = '20221217_2'

NB: il leur manque toutefois l'année de naissance !



### Chercher puis supprimer les doublons

NB : il y a aussi des personnes non renseignées. Vérifier

    SELECT fk_subject_instance, fk_object_instance, COUNT(*) as eff 
    FROM "statement" s  
    WHERE s.import_metadata  = '20221213_1'  
    AND fk_subject_instance IS NOT NULL 
    GROUP BY fk_subject_instance, fk_object_instance
    HAVING COUNT(*) > 1 ;

Remettre à jour les statements avec la personne:

    UPDATE "statement" set fk_subject_instance = i.pk_instance 
    FROM "instance" i 
    WHERE "statement".subject_uri = i.external_uri
    AND "statement".import_metadata = '20221213_1'
    AND i.fk_class = 1  ;

## Créer les _pursuits_

    INSERT INTO "instance" (import_metadata, notes, fk_class)
    SELECT pk_statement || '_20221217_3' , pk_statement, 3
    FROM "statement" s 
    WHERE import_metadata = '20221213_1'
    AND fk_subject_instance IS NOT NULL;


### Créer l'association à la personne

    IINSERT INTO "statement" (fk_subject_instance, fk_property, fk_object_instance, import_metadata)
    SELECT  i.pk_instance, 1, s.fk_subject_instance, '20221217_4_'|| i.pk_instance 
    FROM "instance" i, "statement" s 
    WHERE i.notes = s.pk_statement
    AND i.import_metadata like '%_20221217_3%';	

### Créer l'association à la profession

    SELECT  i.pk_instance, 2, s.fk_object_instance, '20221217_5_'|| i.pk_instance 
    FROM "instance" i, "statement" s 
    WHERE i.notes = s.pk_statement 
    AND i.import_metadata like '%_20221217_3%';	

## Créer la vue qui liste les professions

    --DROP VIEW v_pursuits;
    CREATE VIEW v_pursuits AS
    SELECT i.pk_instance, s1.pk_statement, i1.pk_instance, i1.label, i2.label label_occupation, s2.pk_statement pk_statement_occupation
    FROM "instance" i
    LEFT JOIN "statement" s1 ON s1.fk_subject_instance = i.pk_instance AND s1.fk_property = 1 
    LEFT JOIN "instance" i1 ON s1.fk_object_instance = i1.pk_instance
    LEFT JOIN "statement" s2 ON s2.fk_subject_instance = i.pk_instance AND s2.fk_property = 2  
    LEFT JOIN "instance" i2 ON s2.fk_object_instance = i2.pk_instance
    WHERE i.fk_class = 3;


### Interroger la vue

SELECT *
FROM v_pursuits;


## Ajouter le temps et l'espace à la vue

* Paul Guldin was a professor of mathematics in Graz and Vienna, <http://dbpedia.org/resource/Paul_Guldin>
* Noter que Johannes Kepler n'a pas d'_occupation_ mais qu'il a des _fields_ d'acitvité: <http://dbpedia.org/resource/Johannes_Kepler>

        DROP VIEW v_pursuits;
        CREATE VIEW v_pursuits AS
        SELECT i1.label, i2.label label_occupation, i3.label label_place,
            ts.begin_of_begin, ts.end_of_begin, ts.ongoing_throughout, ts.begin_of_end, ts.end_of_end, 
            i.pk_instance, s1.pk_statement pk_statemen_person, s2.pk_statement pk_statement_occupation, s3.pk_statement pk_statement_place
        FROM "instance" i
        LEFT JOIN time_span ts ON ts.pk_time_span = i.fk_time_span
        LEFT JOIN "statement" s1 ON s1.fk_subject_instance = i.pk_instance AND s1.fk_property = 1 
        LEFT JOIN "instance" i1 ON s1.fk_object_instance = i1.pk_instance
        LEFT JOIN "statement" s2 ON s2.fk_subject_instance = i.pk_instance AND s2.fk_property = 2  
        LEFT JOIN "instance" i2 ON s2.fk_object_instance = i2.pk_instance
        LEFT JOIN "statement" s3 ON s3.fk_subject_instance = i.pk_instance AND s3.fk_property = 3  
        LEFT JOIN "instance" i3 ON s3.fk_object_instance = i3.pk_instance
        WHERE i.fk_class = 3;


# Association à des données issues d'une autre source

### Vérifier l'import des liens vers DBPedia francophone

    SELECT property_uri, COUNT(*) as effectif 
    FROM "statement" s   
    GROUP BY s.property_uri 
    ORDER BY effectif DESC ;

&nbsp;

## Lien des deux population à travers l'URI dbpedia francophone

127 personnes de DBPedia et BNF data sont liées, après importation des données de BNF data. Reste la question de comment traiter celles qui manquent pour éviter de créer des doublons dans la table instance.


    SELECT s1.subject_uri, s2.subject_uri  
    FROM "statement" s1, "statement" s2
    WHERE s1.object_uri = s2.object_uri 
    AND s1.import_metadata = '20221204_4'
    AND s2.import_metadata = '20221204_6';  



