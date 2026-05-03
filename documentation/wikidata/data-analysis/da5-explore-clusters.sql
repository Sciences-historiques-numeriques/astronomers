
-- clean up database and save space
-- after big deletes, notably tables
VACUUM;





/*
 * K-modes
 */



SELECT run, count(*) as num
FROM kmodes_clusters
group BY run ;


SELECT run, count(*) as num
FROM kmodes_clusters_centroids 
group BY run ;


SELECT *
FROM kmodes_clusters_centroids
WHERE cluster IN (5,31,29)
AND run='cen64' --'cen32'
order by cluster;



SELECT *
FROM clusters_kmodes_c54 ckc 
where ckc.cluster = 1
order by ckc.gender, ckc.periodsActivity desc ;


SELECT ckc.cluster, ckc.periodsActivity, count(*) as num
FROM clusters_kmodes_c54 ckc 
group by ckc.cluster, ckc.periodsActivity 
order by ckc.cluster, num desc ;


SELECT ckc.cluster, ckc.periodsActivity, count(*) as num
FROM clusters_kmodes_c8 ckc 
group by ckc.cluster, ckc.periodsActivity 
order by ckc.cluster, num desc ;




select *
from ACM_kmeans_c21
where cluster= 17
order by gender, periodsActivity;



select cluster, periodsActivity, count(*) as num
from ACM_kmeans_c15
group by cluster, periodsActivity
order by cluster, num desc;


select cluster, periodsActivity, count(*) as num
from ACM_kmeans_c15
group by cluster, periodsActivity
order by cluster, num desc;

with tw1 as (select cluster, periodsActivity, count(*) as num
from ACM_kmeans_c15
group by cluster, periodsActivity
)
select distinct tw1.cluster, tw1.periodsActivity, num
from tw1
	join (
	SELECT cluster, max(num) as mn
	from tw1
	group by cluster) tmn
	on tmn.mn=tw1.num and tmn.cluster = tw1.cluster;
	
	
	
-- Query for cluster alignment test	
SELECT mkc.person_uri, mkc.cluster cluster_kmean, kc.cluster cluster_kmode
from mca_kmeans_clusters mkc, kmodes_clusters kc 
where mkc.person_uri = kc.person_uri
order by cluster_kmean, cluster_kmode ;





