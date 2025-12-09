# Analyser des données importées depuis DBpedia

Ce document propose quelques analyes de données élémentaires qui utilisent les tables précédemment créées suite à importantion des données DBPedia (cf. [ce document](./Importer_DBpedia_base_personnelle.md)) et ajoute deux nouvelles tables (discipline académique et nationalité).


## Créer un table par requête

* Exporter en CSV ou TSV le résultat de la requête SPARQL
* En utilisant DBeaver, créer une table par fichier en ayant préalablement choisi la base de données dans laquelle on veut créer les tables
* Pour les tables des occupations, disciplines et nationalités ajouter une colonne supplémentaire dans laquelle on mettra les valeurs corrigées ou codées, en utilisant SQLite Studio
* Au final, on présuppose de disposer de quatre tables: dbp_liste_personnes, dpp_occupation, dbp_nationalite, dbp_academic_disciplines




### Liste des disciplines académiques


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
        dbp:academicDiscipline ?target.
    ?target rdfs:label ?label.
    BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( (?birthYear >= 1451   && ?birthYear < 1771 )  && LANG(?label) = 'en') 
            }
    ORDER BY ?birthYear
    }


### Nationalité

    PREFIX dbr: <http://dbpedia.org/resource/>
    PREFIX dbp: <http://dbpedia.org/property/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    PREFIX rdfs:<http://www.w3.org/2000/01/rdf-schema#>
    SELECT DISTINCT (?o1 AS ?subject_uri) (STR(?target) AS ?text_value) 
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
        dbp:nationality | dbo:nationality ?target.
        BIND(xsd:integer(SUBSTR(STR(?birthDate), 1, 4)) AS ?birthYear)
        FILTER ( (?birthYear >= 1451   && ?birthYear < 1771 )  && !isIRI(?target) && strlen(STR(?target)) > 0)
            }
    ORDER BY ?birthYear
    }




### Remplir ensuite les colonnes avec les valeurs existantes

Les données seront nettoyées plus tard:

    UPDATE dbp_academic_disciplines SET valeur_codee = label ;
    UPDATE dbp_liste_personnes SET valeur_nettoyee  = text_value  ;
    UPDATE dbp_occupation SET valeur_codee = name;


&nbsp;

### Ajouter des périodes (générations) à la tables des personnes

Trouver les valeurs de l'année minimale et maximale de naissance des personnes:

    SELECT MIN(birthYear) min_annee, MAX(birthYear) as max_annee  
    FROM dbp_liste_personnes dlp  ;

&nbsp;

Créer une séquence qui définit les périodes de regroupement des années de naissance (par exemples 20 ou 50 ans).

Par convention la période doit commencer à l'année 'une' de la décennie dans laquelle se situe la naissance de la première personne, par ex. 1501, et teminer avec l'année 'zéro' de la dernière décennies, par ex. 2000.

    WITH RECURSIVE
    cnt(x) AS (
    SELECT 1451
    UNION ALL
    SELECT x+50 FROM cnt
    WHERE x < 1751
    ), tw1 AS (
    SELECT x as begin_a, x+59 as end_a FROM cnt
    )
    SELECT * 
    FROM tw1;

&nbsp;    

Ajouter à la table _dbp_liste_personnes_, avec SQLite Studio, une colonne appelée _periode_, qui va contenir la période ou génération à l'intérieur de laquelle se situe la naissance de la personne.

Puis alimenter cette colonne avec la requête suivante:

    WITH RECURSIVE
    cnt(x) AS (
    SELECT 1451
    UNION ALL
    SELECT x+50 FROM cnt
    WHERE x < 1751
    ), tw1 AS (
    SELECT x as begin_a, x+49 as end_a FROM cnt
    )
    UPDATE dbp_liste_personnes SET periode = begin_a
    FROM tw1
    WHERE birthYear BETWEEN tw1.begin_a AND tw1.end_a;

L'année de naissance doit se trouver à l'intérieur d'une période et définit ainsi à quelle période appartient la personne.

On observera que la nouvelle colonne _periode_ est désormais remplie dans la table après le UPDATE.

&nbsp;

## Distribution par période: graphique

Exécuter la requête suivante, puis exporter sous format CSV le résultat et réaliser un graphique sous Calc (ou Excel)

    WITH tw1 AS (
    SELECT DISTINCT o1, periode
    from v_nationalite_discipline_annee_code
    )
    SELECT periode, count(*) effectif
    FROM tw1
    GROUP BY periode;

Il faut utiliser un diagramme à barres, sur l'axe des _x_ on aura les périodes et sur l'axe des _y_ l'effectif des personnes nées dans cette période.


&nbsp;



## Créer une vue SQL qui regroupe les personnes, occupations, nationalités et disciplines

Cette vue utilise les colonnes codées et ajoute un colonne avec les période sprécédemment créée.

Elle contient l'ensemble des données à explorer et analyser.


    DROP VIEW v_nationalite_discipline_annee_code ;
    CREATE VIEW v_nationalite_discipline_annee_code AS
    SELECT lp.o1, n.valeur_nettoyee AS nationalite, 
            lad.valeur_codee AS discipline,
            oc.valeur_nettoyee AS occupation,
            lp.birthYear AS annee_naissance,
            lp.periode
    FROM dbp_liste_personnes lp
        LEFT JOIN dbp_academic_disciplines lad 
            ON lp.o1 = lad.subject_uri
        LEFT JOIN dbp_occupation oc
            ON oc.o1 = lp.o1
        LEFT JOIN dbp_nationalite n 
            ON n.subject_uri = lp.o1; 

    SELECT *
    from v_nationalite_discipline_annee_code;




## Nettoyer les nationalités

Regrouper et inspecter les nationalités

    SELECT nationalite, count(*) as eff
    FROM v_nationalite_discipline_annee_code
    WHERE nationalite NOTNULL 
    GROUP BY  nationalite
    ORDER BY eff DESC  ; 


    -- chercher les occurrences d'un terme
    SELECT *
    FROM dbp_nationalite n 
    WHERE valeur_nettoyee  LIKE '%Italian, French%';

    -- remplacer toute la cellule par un autre terme
    /*
    * replaced: '%Mulhous%', '%Genev%', '%German, Russian%',
    * '%Tusc%' Italian, French
    */
    UPDATE dbp_nationalite set valeur_nettoyee = 'English'
    WHERE valeur_nettoyee LIKE 'British';


## Graphique des nationalités

Exécuter la requête, exporter le résultat sous forme de CSV et ouvrir avec Calc afin de réaliser un graphique

    SELECT DISTINCT o1, nationalite, periode
    FROM v_nationalite_discipline_annee_code
    WHERE nationalite in (
    SELECT nationalite
    FROM v_nationalite_discipline_annee_code
    WHERE nationalite NOTNULL 
    GROUP BY  nationalite
    HAVING count(*) > 2);