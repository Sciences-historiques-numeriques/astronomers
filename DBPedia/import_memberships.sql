
-- regrouper par type d'appartenance
SELECT da.membership_type, count(*) as number
FROM dbp_appartenance da 
GROUP BY da.membership_type ;


-- compter les organisations
SELECT da.organisation, count(*) as number
FROM dbp_appartenance da 
GROUP BY da.organisation 
ORDER BY number DESC;



-- il y en a quatre
 SELECT lp.organisation 
    FROM dbp_organisations_avec_noms lp 
    GROUP BY organisation
    HAVING COUNT(*) > 1 ;


SELECT organisation, min(label),  
"Importé le 25 novembre 2025 depuis le résultat d'une requête SPARQL sur DBPedia, 
cf. table dbp_organisations_avec_noms"
            FROM dbp_organisations_avec_noms
            GROUP BY organisation;


SELECT COUNT(*)
    FROM (SELECT organisation, min(label),  
"Importé le 25 novembre 2025 depuis le résultat d'une requête SPARQL sur DBPedia, 
cf. table dbp_organisations_avec_noms"
            FROM dbp_organisations_avec_noms
            GROUP BY organisation);



-- person definition

CREATE TABLE organisation (pk_organisation INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
label TEXT,
definition TEXT,
notes TEXT,
import_metadata TEXT,
dbpedia_uri TEXT,
wikidata_uri TEXT);




INSERT INTO organisation (label, dbpedia_uri, import_metadata)
        SELECT min(label), organisation,
"Importé le 25 novembre 2025 depuis le résultat d'une requête SPARQL sur DBPedia, 
cf. table dbp_organisations_avec_noms"
            FROM dbp_organisations_avec_noms
            GROUP BY organisation ;  


-- personnes qui étudient et travaillen dans la même organisation
SELECT da1.organisation, da2.organisation 
from dbp_appartenance da1 
    JOIN dbp_appartenance da2 ON da1.person = da2.person 
where da1.membership_type = 'almaMater'
and da2.membership_type = 'institution'
and da1.organisation = da2.organisation 



----
SELECT group_concat(' ', da.organisation)	
FROM dbp_appartenance da ;



