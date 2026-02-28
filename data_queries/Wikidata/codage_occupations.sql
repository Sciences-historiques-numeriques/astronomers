/*** Codage des occupations
 * 
 * Dans ce document sont présentés différents scripts SQL qui illustrent
 * le processus de codage des occupations
 * 
 */

-- compter les relations personne-occupations
SELECT count(*)
FROM wdt_person_occupation wpo; 

-- regrouper par occupation avec tri par effectif déscendant
SELECT occupationUri, occupationLabel, COUNT(*) as effectif
FROM wdt_person_occupation
GROUP BY occupationUri , occupationLabel
ORDER BY effectif DESC;


-- distribution des effectifs par plages
WITH tw1 AS (
SELECT occupationUri, occupationLabel, COUNT(*) as effectif
FROM wdt_person_occupation
GROUP BY occupationUri, occupationLabel ),
tw2 AS (
SELECT 1001 a, 30000 b
UNION
SELECT 501 a, 1000 b
UNION
SELECT 101 a, 500 b
UNION
SELECT 51 a, 100 b
UNION
SELECT 21 a, 50 b
UNION
SELECT 11 a, 20 b
UNION
SELECT 5 a, 10 b
UNION
SELECT 2 a, 4 b
UNION
SELECT 0 a, 1 b
)
SELECT CAST(a as 'str') || '-' || CAST(b as 'str') as plage, count(*) as effectif, SUM(effectif) as sum , group_concat(occupationLabel, '; ')
FROM tw1 JOIN tw2 ON tw1.effectif BETWEEN tw2.a AND tw2.b
GROUP BY plage
ORDER BY effectif DESC;

-- inspecter les effectifs d'activités par personne
SELECT wp.personUri, wp.personLabel, count(*) as effectif, 
			min(wp.birthYear) birthYear, 
			group_concat(distinct occupationLabel) occupationLabels
FROM wdt_person_occupation wpo, wdt_personne wp 
WHERE wp.personUri = wpo.personUri 
GROUP BY wp.personUri, wp.personLabel
ORDER BY effectif DESC; 


-- Vérifier qu'il n'y a pas de doublons de personnnes
WITH tw1 as (
SELECT wp.personUri, wp.personLabel, count(*) as effectif, 
			min(wp.birthYear) birthYear, 
			group_concat(distinct occupationLabel) occupationLabels
FROM wdt_person_occupation wpo, wdt_personne wp 
WHERE wp.personUri = wpo.personUri 
GROUP BY wp.personUri, wp.personLabel
)
SELECT * 
FROM tw1
GROUP BY personUri, personLabel
HAVING COUNT(*) > 1;
LIMIT 10;

-- nombre de personnes par effectif
WITH tw1 as (
SELECT wp.personUri, wp.personLabel, count(*) as effectif, 
			min(wp.birthYear) birthYear, 
			group_concat(distinct occupationLabel) occupationLabels
FROM wdt_person_occupation wpo, wdt_personne wp 
WHERE wp.personUri = wpo.personUri 
GROUP BY wp.personUri, wp.personLabel
)
SELECT effectif AS eff_activite, count(*) AS effectif_eff
FROM tw1
GROUP BY effectif
ORDER BY effectif_eff DESC;


/*** CODAGE
 *  
 * Après avoir créé et alimenté une table occupation, 
 * afin de disposer d'une seule ligne identifiant une occupation, 
 * on crée une table "occupation_domain" qui représente les domaines des occupations
 * et qui est associée dans une relation de 1 à n à la table occupation.
 * On crée ensuite une relation de clé étrangère dans la base de données
 * et on peut coder avec la requête suivante dans DBeaver
 */


-- IMPORTANT : requête permettant l'association aux domaines. i.e. le codage, 
-- dans un logiciel avec interface graphique
WITH TW1 AS (
SELECT occupationUri, occupationLabel, COUNT(*) as effectif
FROM wdt_person_occupation
GROUP BY occupationUri , occupationLabel)
SELECT wo.pk_wdt_occupation, occupationUri, occupationLabel, effectif, fk_domain 
FROM tw1, wdt_occupation wo
WHERE tw1.occupationUri = wo.wdt_uri
ORDER BY effectif DESC;



-- inspecter les codages
SELECT wp.personUri, wp.personLabel, occupationLabel, od.label
FROM wdt_person_occupation po 
    JOIN wdt_occupation wo ON po.occupationUri = wo.wdt_uri
    JOIN wdt_personne wp ON wp.personUri = po.personUri 
    LEFT JOIN occupation_domain od ON od.pk_occupation_domain = wo.fk_domain
--WHERE od.label IS NULL
LIMIT 20;

--Effectifs des classes = domaines
SELECT od.label, od.pk_occupation_domain, COUNT(*) as eff 
FROM wdt_person_occupation po 
    JOIN wdt_occupation wo ON po.occupationUri = wo.wdt_uri
    LEFT JOIN occupation_domain od ON od.pk_occupation_domain = wo.fk_domain
GROUP BY od.label, od.pk_occupation_domain 
order by eff desc;





-- inspecter la table personne occupation
SELECT wp.personUri, wp.personLabel, count(*) AS eff, GROUP_CONCAT(occupationLabel) occupations,
    GROUP_CONCAT(od.label) domaines
FROM wdt_person_occupation po 
    JOIN wdt_occupation wo ON po.occupationUri = wo.wdt_uri
    JOIN wdt_personne wp ON wp.personUri = po.personUri 
    LEFT JOIN occupation_domain od ON od.pk_occupation_domain = wo.fk_domain
GROUP BY wp.personUri, wp.personLabel
-- vérifier si domaines non codés: normalement tous ont au moins astronomie, physique, etc
--HAVING domaines IS NOT NULL
ORDER BY eff --DESC
LIMIT 100;



-- inspecter les personnnes
SELECT wp.personUri, wp.personLabel, wp.birthYear, count(*) AS eff, GROUP_CONCAT(od.label) domaines
FROM wdt_person_occupation po 
    JOIN wdt_occupation wo ON po.occupationUri = wo.wdt_uri
    JOIN wdt_personne wp ON wp.personUri = po.personUri 
    LEFT JOIN occupation_domain od ON od.pk_occupation_domain = wo.fk_domain
GROUP BY wp.personUri, wp.personLabel
HAVING domaines LIKE '%Astrologie%';



-- regrouper par effectifs de domaines
WITH tw1 AS (
SELECT wp.personUri, wp.personLabel, count(*) AS eff, GROUP_CONCAT(od.label) domaines
FROM wdt_person_occupation po 
    JOIN wdt_occupation wo ON po.occupationUri = wo.wdt_uri
    JOIN wdt_personne wp ON wp.personUri = po.personUri 
    LEFT JOIN occupation_domain od ON od.pk_occupation_domain = wo.fk_domain
GROUP BY wp.personUri, wp.personLabel)
SELECT *
FROM tw1
GROUP BY domaines;

-- année et classe d'activité
SELECT DISTINCT wp.personUri, wp.personLabel, wp.birthYear, od.label domaine
FROM wdt_person_occupation po 
    JOIN wdt_occupation wo ON po.occupationUri = wo.wdt_uri
    JOIN wdt_personne wp ON wp.personUri = po.personUri 
    JOIN occupation_domain od ON od.pk_occupation_domain = wo.fk_domain
ORDER BY wp.personUri, od.label
LIMIT 50;


-- Requête pour le NOTEBOOK: personnes avec leurs domaines, leur genre et leurs dates de naissance
WITH tw1 as (
SELECT DISTINCT wp.personUri, wp.personLabel, 
   CASE 
       WHEN wp.genderUri = 	'http://www.wikidata.org/entity/Q6581097'
       THEN 'M'
       WHEN wp.genderUri = 	'http://www.wikidata.org/entity/Q6581072'
       THEN 'F'
       ELSE 'A'
   END AS gender, wp.birthYear, od.label domaine
FROM wdt_person_occupation po 
    JOIN wdt_occupation wo ON po.occupationUri = wo.wdt_uri
    JOIN wdt_personne wp ON wp.personUri = po.personUri 
    JOIN occupation_domain od ON od.pk_occupation_domain = wo.fk_domain
ORDER BY wp.personUri, od.label )
SELECT personUri, personLabel,gender, birthYear, count(*) as eff, group_concat(domaine)
FROM tw1
GROUP BY personUri, personLabel, birthYear
LIMIT 100;




WITH tw1 as (
SELECT DISTINCT wp.personUri, wp.personLabel, wp.birthYear, od.label domaine
FROM wdt_person_occupation po 
    JOIN wdt_occupation wo ON po.occupationUri = wo.wdt_uri
    JOIN wdt_personne wp ON wp.personUri = po.personUri 
    JOIN occupation_domain od ON od.pk_occupation_domain = wo.fk_domain
ORDER BY wp.personUri, od.label ),
tw2 AS (
SELECT personUri, personLabel, birthYear, count(*) as eff, group_concat(domaine) domaines
FROM tw1
GROUP BY personUri, personLabel, birthYear)
SELECT domaines, COUNT(*) as eff
FROM tw2
GROUP BY domaines
ORDER BY eff DESC;
