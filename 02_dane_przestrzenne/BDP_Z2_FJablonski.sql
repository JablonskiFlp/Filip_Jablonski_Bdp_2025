
--Create extension postgis;

-- CREATE TABLE buildings (
--     id SERIAL PRIMARY KEY,
--     name TEXT,
--     geometry GEOMETRY(POLYGON, 0)
-- );

-- CREATE TABLE roads (
--     id SERIAL PRIMARY KEY,
--     name TEXT,
--     geometry GEOMETRY(LINESTRING, 0)
-- );

-- CREATE TABLE poi (
--     id SERIAL PRIMARY KEY,
--     name TEXT,
--     geometry GEOMETRY(POINT, 0)
-- );

-- select * from poi

-- INSERT INTO buildings (name, geometry) VALUES
-- ('BuildingA', ST_GeomFromText('POLYGON((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))', 0)),
-- ('BuildingB', ST_GeomFromText('POLYGON((4 7, 6 7, 6 5, 4 5, 4 7))', 0)),
-- ('BuildingC', ST_GeomFromText('POLYGON((3 8, 5 8, 5 6, 3 6, 3 8))', 0)),
-- ('BuildingD', ST_GeomFromText('POLYGON((9 9, 10 9, 10 8, 9 8, 9 9))', 0)),
-- ('BuildingF', ST_GeomFromText('POLYGON((1 2, 2 2, 2 1, 1 1, 1 2))', 0));

-- INSERT INTO roads (name, geometry) VALUES
-- ('RoadX', ST_GeomFromText('LINESTRING(0 4.5, 12 4.5)', 0)),
-- ('RoadY', ST_GeomFromText('LINESTRING(7.5 10.5, 7.5 0)', 0));

-- INSERT INTO poi (name, geometry) VALUES
-- ('G', ST_GeomFromText('POINT(1.3 3.5)', 0)),
-- ('H', ST_GeomFromText('POINT(5.5 1.5)', 0)),
-- ('I', ST_GeomFromText('POINT(9.5 6)', 0)),
-- ('J', ST_GeomFromText('POINT(6.5 6)', 0)),
-- ('K', ST_GeomFromText('POINT(6 9.5)', 0));

-- Zad 6
-- a)
		SELECT SUM(ST_Length(geometry)) AS length
		FROM roads;
-- b)
		SELECT
		  name,
		  ST_AsText(geometry) AS wkt,
		  ST_Area(geometry) AS area,
		  ST_Perimeter(geometry) AS perimeter
		FROM buildings
		WHERE name = 'BuildingA';
-- c)
		SELECT name, ST_Area(geometry) AS area
		FROM buildings
		ORDER BY name;
-- d)
		SELECT name,
		       ST_Area(geometry) AS area,
		       ST_Perimeter(geometry) AS perimeter
		FROM buildings
		ORDER BY ST_Area(geometry) DESC
		LIMIT 2;
-- e)
		SELECT
		  ST_Distance(b.geometry, p.geometry) AS distance
		FROM buildings b
		JOIN poi p ON p.name = 'K'
		WHERE b.name = 'BuildingC';
-- f)
		SELECT ST_Area(
		         ST_Difference(
		           (SELECT geometry FROM buildings WHERE name='BuildingC'),
		           ST_Buffer((SELECT geometry FROM buildings WHERE name='BuildingB'), 0.5)
		         )
		       ) AS area_units;
-- g) 
		SELECT b.name,
		       ST_AsText(ST_Centroid(b.geometry)) AS centroid_wkt,
		       ST_Y(ST_Centroid(b.geometry)) AS centroid_y,
		       ST_Y(ST_ClosestPoint(r.geometry, ST_Centroid(b.geometry))) AS road_y_clst_point
		FROM buildings b
		JOIN roads r ON r.name = 'RoadX'
		WHERE ST_Y(ST_Centroid(b.geometry)) > ST_Y(ST_ClosestPoint(r.geometry, ST_Centroid(b.geometry)));
-- h)
		SELECT ST_Area(
		         ST_SymDifference(
		           (SELECT geometry FROM buildings WHERE name='BuildingC'),
		           ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))', 0)
		         )
		       ) AS symdiff_area_units;