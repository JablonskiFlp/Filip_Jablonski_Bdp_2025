DROP TABLE IF EXISTS obiekty;
CREATE TABLE obiekty (
  id SERIAL PRIMARY KEY,
  nazwa TEXT,
  geometry GEOMETRY  
);

-- zad2

-- a) 
INSERT INTO obiekty (nazwa, geometry) 
VALUES (
  'obiekt1', 
  ST_SetSRID(
    ST_CollectionExtract(
      ST_CurveToLine(
        ST_GeomFromEWKT(
          'GEOMETRYCOLLECTION(
            LINESTRING(0 1, 1 1),
            CIRCULARSTRING(1 1, 2 0, 3 1),
            CIRCULARSTRING(3 1, 4 2, 5 1),
            LINESTRING(5 1, 6 1)
          )'
        )
      ),
      2  
    ),
    0  
  )
);

-- b) 
INSERT INTO obiekty(nazwa, geometry) 
VALUES
('obiekt2', 
	ST_SetSRID(
		ST_BuildArea(
			ST_Collect(
				ARRAY[
					'LINESTRING(10 6, 14 6)',
					'CIRCULARSTRING(14 6, 16 4, 14 2)',
					'CIRCULARSTRING(14 2, 12 0, 10 2)',
					'LINESTRING(10 2, 10 6)',
					ST_Buffer(ST_POINT(12, 2), 1, 6000)
				]
			)
		), 0
	)
)

-- c) 
INSERT INTO obiekty (nazwa, geometry) VALUES
('obiekt3', ST_GeomFromText('POLYGON((7 15, 10 17, 12 13, 7 15))', 0));

-- d) 
INSERT INTO obiekty (nazwa, geometry) VALUES
('obiekt4', ST_GeomFromText(
  'LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)', 0)
);

-- e)
INSERT INTO obiekty (nazwa, geometry)
VALUES (
  'obiekt5',
  ST_GeomFromText('LINESTRING Z (30 30 59, 38 32 234)', 0)
);

-- f)
INSERT INTO obiekty (nazwa, geometry)
VALUES (
  'obiekt6',
  ST_GeomFromText('GEOMETRYCOLLECTION(
    LINESTRING(1 1, 3 2),
    POINT(4 2)
  )', 0)
);

select * from obiekty

-- zad 2
SELECT 
  ST_Area(
    ST_Buffer(
      ST_ShortestLine(o3.geometry, o4.geometry), 
      5
    )
  ) AS area
FROM obiekty AS o3
JOIN obiekty AS o4 ON o3.nazwa = 'obiekt3' AND o4.nazwa= 'obiekt4';

-- zad 3
UPDATE obiekty
SET geometry = ST_MakePolygon(
                 ST_AddPoint(
                   geometry,
                   ST_StartPoint(geometry)
                 )
               )
WHERE "nazwa" = 'obiekt4';

-- zad 4

INSERT INTO obiekty ("nazwa", geometry)
SELECT 'obiekt7', ST_Collect(geometry)
FROM obiekty
WHERE "nazwa" IN ('obiekt3', 'obiekt4');

-- zad 5 
WITH bez_lukow AS (
  SELECT ST_Force3D(geometry) AS geom
  FROM obiekty
  WHERE NOT ST_HasArc(geometry)
),
polaczone AS (
  SELECT ST_Union(geom) AS geom
  FROM bez_lukow
),
buforowane AS (
  SELECT ST_Buffer(geom, 5) AS geom
  FROM polaczone
)
SELECT ST_Area(geom) AS area
FROM buforowane;
