CREATE TABLE IF NOT EXISTS "T_DIFF_2018_2019" AS
SELECT 
    b2019.geom,
    CASE 
        WHEN b2018.geom IS NULL THEN 'new'
        WHEN NOT ST_Equals(b2019.geom, b2018.geom) THEN 'changed'
    END AS status
FROM "T2019_KAR_BUILDINGS" AS b2019
LEFT JOIN "T2018_KAR_BUILDINGS" AS b2018
  ON ST_Intersects(b2019.geom, b2018.geom)
WHERE 
    b2018.geom IS NULL OR NOT ST_Equals(b2019.geom, b2018.geom);

CREATE TABLE IF NOT EXISTS "T_NEW_POI_2019" AS
SELECT p2019.*
FROM "T2019_KAR_POI_TABLE" AS p2019
LEFT JOIN "T2018_KAR_POI_TABLE" AS p2018
  ON ST_Equals(p2019.geom, p2018.geom)
WHERE p2018.geom IS NULL;

SELECT 
    p.category,
    COUNT(*) AS liczba_nowych_poi
FROM "T_NEW_POI_2019" AS p
JOIN "T_DIFF_2018_2019" AS b
  ON ST_DWithin(
       ST_Transform(p.geom, 25832),   -- przekształcenie do metrycznego układu (jeśli SRID = 4326)
       ST_Transform(b.geom, 25832),
       500                             -- promień 500 m
     )
GROUP BY p.category
ORDER BY liczba_nowych_poi DESC;


	
