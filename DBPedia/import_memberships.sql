/*
 * Inspecter le résultat de l'importation des appartenances 
 * aux organisations
 * 
 */

-- regrouper par type d'appartenance
SELECT da.membership_type, count(*) as number
FROM dbp_appartenance da 
GROUP BY da.membership_type ;


-- compter les organisations impliquées dans les appartenances
SELECT da.organisation, count(*) as number
FROM dbp_appartenance da 
GROUP BY da.organisation 
ORDER BY number DESC;

/*
 * Inspecter le résultat de la création de la table dbp_organisations
 */

-- Vérifier s'il y a des lignes à double:
-- il y en a quatre ! A cause des noms différents
 SELECT lp.organisation 
    FROM dbp_organisations_avec_noms lp 
    GROUP BY organisation
    HAVING COUNT(*) > 1 ;

-- Retenir seulement le permier nom dans l'ordre alphabétique
-- afin d'éliminer les organisations à double
SELECT organisation, min(label),  
"Importé le 25 novembre 2025 depuis le résultat d'une requête SPARQL sur DBPedia, 
cf. table dbp_organisations_avec_noms"
            FROM dbp_organisations_avec_noms
            GROUP BY organisation;

-- Compter les organisations agrégées
SELECT COUNT(*)
    FROM (SELECT organisation, min(label),  
"Importé le 25 novembre 2025 depuis le résultat d'une requête SPARQL sur DBPedia, 
cf. table dbp_organisations_avec_noms"
            FROM dbp_organisations_avec_noms
            GROUP BY organisation);



-- crérer la table des organisations

CREATE TABLE organisation (pk_organisation INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
label TEXT,
definition TEXT,
notes TEXT,
import_metadata TEXT,
dbpedia_uri TEXT,
wikidata_uri TEXT);



-- Insérer les organisations importées dans la table organisationd
-- tout en indiquant l'organisation correspondante dans DBpedia
INSERT INTO organisation (label, dbpedia_uri, import_metadata)
        SELECT min(label), organisation,
"Importé le 25 novembre 2025 depuis le résultat d'une requête SPARQL sur DBPedia, 
cf. table dbp_organisations_avec_noms"
            FROM dbp_organisations_avec_noms
            GROUP BY organisation ;  



-- personnes qui étudient et travaillent dans la même organisation
SELECT p.label, da1.person, da1.organisation, da2.organisation 
from dbp_appartenance da1 
    JOIN dbp_appartenance da2 ON da1.person = da2.person 
    join person p on p.dbpedia_uri = da1.person 
where da1.membership_type = 'almaMater'
and da2.membership_type = 'institution'
and da1.organisation = da2.organisation 






