
-- clean up database and save space
-- after big deletes, notably tables
VACUUM;

select *
from person_coded_features
limit 100;


select *
from mca_kmeans_clusters_centroids
WHERE "index" IN (19) --(14) --(11,5,30)
AND run='cen32' 
order by "index";

SELECT *
FROM kmodes_clusters_centroids
WHERE cluster IN (22) --(19,31,14)--(10,28)
AND run='cen32' --'cen32'
order by cluster;




SELECT mkc.person_uri, mkc.cluster cluster_kmean, kc.cluster cluster_kmode
from mca_kmeans_clusters mkc, kmodes_clusters kc 
where mkc.person_uri = kc.person_uri
and mkc.run = 'cen32'
and kc.run = 'cen32'
order by cluster_kmean, cluster_kmode;


SELECT mkc.cluster cluster_kmean, kc.cluster cluster_kmode, pcf.*
from mca_kmeans_clusters mkc, kmodes_clusters kc, person_coded_features pcf
where mkc.person_uri = kc.person_uri
and mkc.run = 'cen32'
and kc.run = 'cen32'
and pcf.person_uri = mkc.person_uri 
and pcf.person_uri = kc.person_uri 
order by cluster_kmean, cluster_kmode;





SELECT mkc.cluster, kc.cluster, 
	count(*) as num--, count(kc.cluster) c_mode, count(mkc.cluster) c_meand
from mca_kmeans_clusters mkc, kmodes_clusters kc 
where mkc.person_uri = kc.person_uri
and mkc.run = 'cen32'
and kc.run = 'cen32'
group BY mkc.cluster, kc.cluster;



-- 
with tw1 as (SELECT kc.cluster, count(*) as kmodes_num
from kmodes_clusters kc
group by kc.cluster
),
tw2 as (SELECT mkc.cluster, count(*) as kmeans_num
from mca_kmeans_clusters mkc
group BY mkc.cluster)
SELECT mkc.cluster, kc.cluster, 
	count(*) as num_common_persons, kmodes_num,
	kmeans_num, CAST(count(*) AS REAL)/kmodes_num  as prop_kmodes, 
	CAST(count(*) AS REAL)/kmeans_num as prop_kmeans
from mca_kmeans_clusters mkc, kmodes_clusters kc, tw1, tw2
where mkc.person_uri = kc.person_uri
and mkc.run = 'cen32'
and kc.run = 'cen32'
and tw1.cluster = kc.cluster 
and tw2.cluster = mkc.cluster 
group BY mkc.cluster, kc.cluster
having prop_kmodes > 0.4 or prop_kmeans > 0.4
order by num_common_persons desc;
order by prop_kmeans desc, prop_kmodes  desc ;
--order by prop_kmodes desc, prop_kmeans desc ;




/*
 * K-modes
 * 
 * Explore
 */


-- runs are the phases where you test with different 
-- numbers of clusters
SELECT run, count(*) as num
-- persons and their cluster in each run
FROM kmodes_clusters
group BY run ;


-- cluster profiles
SELECT run, count(*) as num
FROM kmodes_clusters_centroids 
group BY run ;


-- instpect cluster profiles
SELECT round(CAST(n_centroid AS REAL)/number, 2) prop_centroids, round(CAST(number_f AS REAL)/number, 2) prop_female,
*
FROM kmodes_clusters_centroids
WHERE 1 -- 1 is alway true, no filter condition
-- choose cluster numbers 
--AND cluster IN (20,18) --(26,20,22, 12,25)
-- choose runs (i.e. cluster nodes)
--AND run='cen32'
AND run='cen64'
AND prop_female > 0.1
order by prop_female desc;



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





/*
 * K-means clusters
 */

select *
from mca_kmeans_clusters
limit 10;



select run, count(*) as num
from mca_kmeans_clusters
group by run
order by num desc;


select *
from mca_kmeans_clusters_centroids
limit 10;


select run, count(*) as num
from mca_kmeans_clusters_centroids
group by run
order by num desc;




select *
from mca_kmeans_clusters_centroids
WHERE  run='cen32'
--AND "index" IN (12) --(11,5,30) 
order by "index";




select cluster, periodsActivity, count(*) as num
from mca_kmeans_clusters_centroids
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





