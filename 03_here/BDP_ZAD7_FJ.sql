WITH buffer AS (
    SELECT ST_Buffer(ST_Union(ST_Transform(geom, 3068)), 300) AS geom_3068
    FROM "T2019_KAR_LAND_USE_A"
),
sport_pois AS (
    SELECT ST_Transform(geom, 3068) AS geom_3068
    FROM "T2019_KAR_POI_TABLE"
    WHERE "type" = 'Sporting Goods Store'
)
SELECT COUNT(*) AS count_sport_pois
FROM sport_pois AS s
CROSS JOIN buffer AS b
WHERE ST_Contains(b.geom_3068, s.geom_3068);