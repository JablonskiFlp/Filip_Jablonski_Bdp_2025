CREATE TABLE streets_reprojected AS
SELECT 
    *,
    ST_Transform(geom, 3068) AS geom_reprojected
FROM "T2019_KAR_STREETS";