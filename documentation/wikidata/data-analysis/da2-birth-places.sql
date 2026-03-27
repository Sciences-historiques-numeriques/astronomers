
-- instpect the places table
SELECT *
FROM import_person_birth_place 
LIMIT 10;

SELECT COUNT(*)
FROM import_person_birth_place ;


-- persons having more than one birth place
SELECT person_uri, COUNT(*) as num
FROM import_person_birth_place
GROUP BY person_uri
ORDER BY num DESC
LIMIT 10;


-- number of persons having more then one birth place
-- 201
WITH tw1 AS (
SELECT person_uri
FROM import_person_birth_place
GROUP BY person_uri
HAVING COUNT(*) > 1
)
SELECT COUNT(*) as num
FROM tw1;





/*
 * Places
 */

-- places
SELECT DISTINCT birth_place_uri, place_label 
FROM import_person_birth_place
ORDER BY birth_place_uri
LIMIT 10;


-- no place with two labels 
WITH tw1 AS (
SELECT DISTINCT birth_place_uri, place_label 
FROM import_person_birth_place
)
SELECT count(*) num
--SELECT birth_place_uri 
FROM tw1 
GROUP BY birth_place_uri 
HAVING COUNT(*) > 1;



-- number of places
WITH tw1 AS (
SELECT DISTINCT birth_place_uri, place_label 
FROM import_person_birth_place
)
SELECT count(*) num
FROM tw1 ;


-- number of births per place

SELECT DISTINCT place_label, COUNT(*) AS n, birth_place_uri
FROM import_person_birth_place
GROUP BY birth_place_uri, place_label
ORDER BY n DESC
LIMIT 30;


-- Places without labels
SELECT *
FROM import_person_birth_place
WHERE LENGTH(place_label) = 0
LIMIT 10;


SELECT COUNT(*)
FROM import_person_birth_place
WHERE LENGTH(place_label) = 0;


/*
 * Geocoordinates
 */


-- first exploration
SELECT *
FROM import_birth_places_coordinates 
LIMIT 10;

SELECT COUNT(*)
FROM import_birth_places_coordinates ;


-- places with many coordinates ?
-- no unique set place_uri-geocoordinates
SELECT birth_place_uri, COUNT(*) AS num
FROM import_birth_places_coordinates 
GROUP BY birth_place_uri 
HAVING COUNT(*) > 1
ORDER BY num DESC
LIMIT 10;



-- Create geo_place table
--DROP TABLE geo_place;
CREATE TABLE geo_place (pk_geo_place INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
label TEXT,
definition TEXT,
geo_coordinates TEXT,
notes TEXT,
dbpedia_uri TEXT,
wikidata_uri TEXT);

--DROP INDEX idx_person;
CREATE UNIQUE INDEX idx_geo_place ON geo_place(wikidata_uri);



-- Places with labels and the geocoordinates
SELECT DISTINCT t1.birth_place_uri, t1.place_label, t2.long_lat 
FROM import_person_birth_place t1
	JOIN import_birth_places_coordinates t2 
		ON t2.birth_place_uri = t1.birth_place_uri 
GROUP BY t1.person_uri
LIMIT 10;



INSERT INTO geo_place (wikidata_uri,label,geo_coordinates)
SELECT DISTINCT t1.birth_place_uri, t1.place_label, t2.long_lat 
FROM import_person_birth_place t1
	JOIN import_birth_places_coordinates t2 
		ON t2.birth_place_uri = t1.birth_place_uri 
GROUP BY t1.person_uri;


-- inspect
SELECT *
FROM geo_place
LIMIT 10;

SELECT COUNT(*)
FROM geo_place
LIMIT 10;

-- inspect if twice the same place
SELECT wikidata_uri 
FROM geo_place
GROUP BY wikidata_uri 
HAVING COUNT(*) > 1;





/*
 * Query for analysis in notebook: persons and birth places
 *
 */


-- take just one birth place per person
SELECT person_uri, MAX(birth_place_uri) birth_place_uri
FROM import_person_birth_place
GROUP BY person_uri
LIMIT 10;



-- FINAL QUERY : export the result as a CSV
WITH tw1 AS(
SELECT person_uri, MAX(birth_place_uri) birth_place_uri
FROM import_person_birth_place
GROUP BY person_uri
)
SELECT p.wikidata_uri, p.label, p.birth_year, p.gender, gp.label, gp.geo_coordinates, gp.wikidata_uri 
FROM tw1
	JOIN person p ON p.wikidata_uri = tw1.person_uri 
	JOIN geo_place gp ON gp.wikidata_uri = tw1.birth_place_uri








/*
 * Place classes
 * 
 * Experiment with taxonomies
 * 
 */


-- group by multiple birth places and their classes
SELECT ibpc.place_class_label, COUNT(*) AS num
FROM import_person_birth_place ipbp 
	JOIN import_birth_places_classes ibpc ON ibpc.birth_place_uri = ipbp.birth_place_uri 
WHERE ipbp.person_uri IN (SELECT person_uri
			FROM import_person_birth_place
			GROUP BY person_uri
			HAVING COUNT(*) = 1)
GROUP BY ibpc.place_class_label 
ORDER BY num DESC;	


-- group by multiple birth places and their classes
SELECT GROUP_CONCAT(DISTINCT ipbp.place_label) as places, 
	GROUP_CONCAT(DISTINCT ibpc.place_class_label) as classes,ipbp.person_uri
FROM import_person_birth_place ipbp 
	JOIN import_birth_places_classes ibpc ON ibpc.birth_place_uri = ipbp.birth_place_uri 
WHERE ipbp.person_uri IN (SELECT person_uri
			FROM import_person_birth_place
			GROUP BY person_uri
			HAVING COUNT(*) = 1)
GROUP BY ipbp.person_uri  ;

-- group by multiple birth places and their classes
SELECT GROUP_CONCAT(DISTINCT ipbp.place_label) as places, 
	GROUP_CONCAT(DISTINCT ibpc.place_class_label) as classes,ipbp.person_uri
FROM import_person_birth_place ipbp 
	JOIN import_birth_places_classes ibpc ON ibpc.birth_place_uri = ipbp.birth_place_uri 
WHERE ipbp.person_uri IN (SELECT person_uri
			FROM import_person_birth_place
			GROUP BY person_uri
			HAVING COUNT(*) > 1)
GROUP BY ipbp.person_uri  ;			


-- birth place classes
SELECT ibpc.place_class_label, COUNT(*) as num
FROM import_birth_places_classes ibpc 
GROUP BY ibpc.place_class_label 
ORDER BY num DESC
LIMIT 20;


-- cooccurrences of types
SELECT t1.place_class_label type_1, t2.place_class_label type_2
FROM import_birth_places_classes t1
	JOIN import_birth_places_classes t2 ON t2.birth_place_uri = t1.birth_place_uri 
WHERE t2.place_class_uri > t1.place_class_uri 
LIMIT 20;


-- number of cooccurrences of types
WITH tw1 AS (SELECT t1.place_class_label type_1, t2.place_class_label type_2
FROM import_birth_places_classes t1
	JOIN import_birth_places_classes t2 ON t2.birth_place_uri = t1.birth_place_uri 
WHERE t2.place_class_uri > t1.place_class_uri 
)
SELECT type_1, type_2, count(*) as num
FROM tw1
GROUP BY type_1, type_2 
ORDER BY num DESC;








