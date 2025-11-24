
/*
 * Inspecter la table issue de DBpedia
 */


-- si le résultat est vide (pas de lignes) il n'y a pas de doublons
SELECT person_uri
FROM dbp_liste_personnes lp 
GROUP BY person_uri
HAVING COUNT(*) > 1 ;


/*
 * Vider la table des personnes,
 * puis importer depuis la liste des personnes
 */


--DELETE FROM "person" ;

/*
* Remettre la séquence à zéro
*/
UPDATE SQLITE_SEQUENCE 
SET seq = 0
WHERE name ='person';

/* 
après avoir vidé la table exécuter une instruction vacuum afin de vider la mémoire
*/
VACUUM;



-- importer les personnes
INSERT INTO person (birth_year, dbpedia_uri, label, import_metadata)
SELECT birthYear, person_uri, persname, "Importé le 22 novembre 2025 depuis le résultat d'une requête SPARQL sur DBPedia, cf. astronomers/DBpedia_importer_dans_base_personnelle"
FROM dbp_liste_personnes lp ;   

-- en cas de doublons
INSERT INTO person (birth_year, dbpedia_uri, label, import_metadata)
SELECT max(birthYear), person_uri, max(persname), "Importé le 22 novembre 2025 depuis le résultat d'une requête SPARQL sur DBPedia, cf. astronomers/DBpedia_importer_dans_base_personnelle"
FROM dbp_liste_personnes lp
GROUP BY person_uri   ; 






