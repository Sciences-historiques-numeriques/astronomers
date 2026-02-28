

SELECT placeUri, placeLabel, MAX(placeCoord), COUNT(*) eff
FROM wdt_person_birth_place wpbp 
GROUP BY placeUri, placeLabel
ORDER BY eff DESC ; 


SELECT birthYear,placeUri, placeLabel, placeCoord AS geo_coord
FROM wdt_person_birth_place wpbp
-- il y a des erreurs dans Wikidata
WHERE placeCoord LIKE 'Point(%'
LIMIT 10;


SELECT generations, placeUri, placeLabel, geo_coord, COUNT(*) as effectif
FROM wdt_generations_birth_place wgbp
GROUP BY generations, placeUri, placeLabel, geo_coord;
