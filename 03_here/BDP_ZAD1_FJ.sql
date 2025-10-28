SELECT 
    b2019.*,
    CASE 
        WHEN b2018.geom IS NULL THEN 'new'          -- nowy budynek
        WHEN NOT ST_Equals(b2019.geom, b2018.geom) THEN 'changed'  -- zmieniona geometria
    END AS status
FROM "T2019_KAR_BUILDINGS" AS b2019
LEFT JOIN "T2018_KAR_BUILDINGS" AS b2018
  ON ST_Intersects(b2019.geom, b2018.geom)
WHERE 
    b2018.geom IS NULL OR NOT ST_Equals(b2019.geom, b2018.geom);
