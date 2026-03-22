
-- instpect the places table
SELECT *
FROM birth_places_import
LIMIT 10;


SELECT *
FROM person_birth_place_import
LIMIT 10;

SELECT person_uri, COUNT(*) as num
FROM person_birth_place_import
GROUP BY person_uri
ORDER BY num DESC
LIMIT 10;