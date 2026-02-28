
SELECT *
FROM wdt_person_organisation wpo
LIMIT 100;

SELECT *
FROM wdt_organisation wo 
limit 10;



-- lister les organisations avec leurs effectifs
SELECT min(organisationLabel) org_label, COUNT(*) as eff, max(org_coordinates) as long_lat
FROM wdt_person_organisation wpo
GROUP BY organisation 
ORDER BY eff DESC;


-- lister les organisations avec leurs effectifs
-- fiiltre sur le type de relation
SELECT min(organisationLabel) org_label, COUNT(*) as eff, max(org_coordinates) as long_lat
FROM wdt_person_organisation wpo
WHERE wpo.r_property = 'employer' --'educated_at' -- 'member_of'
GROUP BY organisation 
ORDER BY eff DESC;
