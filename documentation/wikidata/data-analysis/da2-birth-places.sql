
-- instpect the places table
SELECT *
FROM import_person_birth_place 
LIMIT 10;



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
LIMIT 20;


-- Places without labels
SELECT *
FROM import_person_birth_place
WHERE LENGTH(place_label) = 0
LIMIT 10;

-- Places without labels
SELECT *
FROM import_person_birth_place
WHERE LENGTH(place_label) = 0
LIMIT 10;


SELECT COUNT(*)
FROM import_person_birth_place
WHERE LENGTH(place_label) = 0;



/*
 * Place classes
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








