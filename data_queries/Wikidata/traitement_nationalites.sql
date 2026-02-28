

-- personnes avec plusieurs nationalités
SELECT personUri, COUNT(*) 
FROM wdt_person_citizenship
GROUP BY personUri 
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC ; 





-- effectifs des nationalités
SELECT TRIM(nationaliteUri) as nationaliteUri, 
    TRIM(nationaliteLabel) AS nationaliteLabel, COUNT(*) as effectif
FROM wdt_person_citizenship
GROUP BY TRIM(nationaliteUri), TRIM(nationaliteLabel)
ORDER BY effectif DESC;



-- effectifs des nationalités
SELECT TRIM(nationaliteUri) as nationaliteUri, 
    TRIM(nationaliteLabel) AS nationaliteLabel, 
    COUNT(*) as effectif, wc.label, wc.pk_wdt_country, wc.fk_geographic_area 
FROM wdt_person_citizenship wpc JOIN wdt_country wc 
    ON wc.wdt_uri = wpc.nationaliteUri 
GROUP BY TRIM(nationaliteUri), TRIM(nationaliteLabel)
ORDER BY effectif DESC;

-- IMPORTANT : requête permettant l'association aux domaines. i.e. le codage, 
-- dans un logiciel avec interface graphique
WITH TW1 AS (
SELECT nationaliteUri, COUNT(*) as effectif
FROM wdt_person_citizenship
GROUP BY nationaliteUri)
SELECT wc.pk_wdt_country, label, effectif, wc.fk_geographic_area
FROM tw1 JOIN wdt_country wc 
    ON wc.wdt_uri = tw1.nationaliteUri 
ORDER BY effectif DESC;


SELECT ga.label, COUNT(*) as eff 
FROM wdt_person_citizenship wpc
   JOIN wdt_country wc 
     ON wc.wdt_uri = wpc.nationaliteUri 
   JOIN geographic_area ga
     ON ga.pk_geographic_area = wc.fk_geographic_area;
GROUP BY ga.label    
ORDER BY effectif DESC;




-- effectifs par aire géographique
SELECT ga.label, COUNT(*) AS eff
FROM geographic_area ga
	JOIN wdt_country wc 
	    ON ga.pk_geographic_area = wc.fk_geographic_area
	JOIN wdt_person_citizenship wpc 
	    ON wpc.nationaliteUri = wc.wdt_uri
GROUP BY ga.pk_geographic_area   
ORDER BY eff DESC; 
	
	

SELECT wp.personLabel, ga.label, wp.birthYear 
FROM wdt_personne wp 
   JOIN wdt_person_citizenship wpc
	 ON wpc.personUri = wp.personUri
   JOIN wdt_country wc 
     ON wc.wdt_uri = wpc.nationaliteUri 
   JOIN geographic_area ga
     ON ga.pk_geographic_area = wc.fk_geographic_area
   ORDER BY wp.birthYear 
  LIMIT 20;

 -- LISTE des personnes avec aire géogr.
 SELECT wp.personUri, wp.personLabel, 
 CASE 
       WHEN wp.genderUri = 	'http://www.wikidata.org/entity/Q6581097'
       THEN 'M'
       WHEN wp.genderUri = 	'http://www.wikidata.org/entity/Q6581072'
       THEN 'F'
       ELSE 'A'
   END AS gender,
   max(ga.label) AS area_label, max(wp.birthYear) AS birthYear
FROM wdt_personne wp 
   JOIN wdt_person_citizenship wpc
	 ON wpc.personUri = wp.personUri
   JOIN wdt_country wc 
     ON wc.wdt_uri = wpc.nationaliteUri 
   JOIN geographic_area ga
     ON ga.pk_geographic_area = wc.fk_geographic_area
     GROUP BY wp.personUri, personLabel;
     
-- vérifier si on règle ainsi le problème des doublons
WITH tw1 AS (
SELECT wp.personUri, wp.personLabel, max(ga.label) AS area_label, max(wp.birthYear) AS birthYear
FROM wdt_personne wp 
   JOIN wdt_person_citizenship wpc
	 ON wpc.personUri = wp.personUri
   JOIN wdt_country wc 
     ON wc.wdt_uri = wpc.nationaliteUri 
   JOIN geographic_area ga
     ON ga.pk_geographic_area = wc.fk_geographic_area
     GROUP BY wp.personUri, personLabel)
SELECT personUri, personLabel
FROM tw1
GROUP BY personUri, personLabel
HAVING COUNT(*) > 1;


-- vérifier combien de personnes n'ont pas de région associée
SELECT COUNT(*)
FROM wdt_personne wp 
   JOIN wdt_person_citizenship wpc
	 ON wpc.personUri = wp.personUri
   JOIN wdt_country wc 
     ON wc.wdt_uri = wpc.nationaliteUri 
   LEFT JOIN geographic_area ga
     ON ga.pk_geographic_area = wc.fk_geographic_area
   WHERE ga.label IS NULL; 

