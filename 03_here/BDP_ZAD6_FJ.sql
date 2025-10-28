WITH new_line AS (
    SELECT 
        ST_MakeLine(ST_Transform(geom, 3068) ORDER BY id) AS geom_3068
    FROM "input_points"
)
SELECT DISTINCT n.*
FROM "T2019_KAR_STREET_NODE" AS n
CROSS JOIN new_line AS l
WHERE ST_DWithin(ST_Transform(n.geom, 3068), l.geom_3068, 200);
