

SELECT da.membership_type, count(*) as number
FROM dbp_appartenance da 
GROUP BY da.membership_type ;



SELECT da.organisation, count(*) as number
FROM dbp_appartenance da 
GROUP BY da.organisation 
ORDER BY number DESC;