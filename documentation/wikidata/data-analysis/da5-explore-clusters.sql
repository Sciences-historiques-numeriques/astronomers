
SELECT *
FROM clusters_kmodes ck 
WHERE ck.cluster = 4 ; -- 7;


SELECT gender, count(*) as num
FROM clusters_kmodes ck 
WHERE ck.cluster = 5 --0  --7
group by gender;