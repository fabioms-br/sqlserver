DECLARE @g geometry;  
DECLARE @h geometry;  
SET @g = geometry::STGeomFromText('POLYGON((0 0, 2 0, 2 2, 0 2, 0 0))', 0);  
SET @h = geometry::STGeomFromText('POINT(1 1)', 0);  
SELECT @g.STContains(@h);  

GO


SELECT [nome],  [area].STContains([ponto]) AS [ponto_localizado] FROM (
	
	SELECT * FROM (
		VALUES ('Area A', geometry::STGeomFromText('POLYGON((0 0, 2 0, 2 2, 0 2, 0 0))', 0), 
					geometry::STGeomFromText('POINT(1 1)', 0)),
			   ('Area B', geometry::STGeomFromText('POLYGON((0 0, 2 0, 2 2, 0 2, 0 0))', 0), 
					geometry::STGeomFromText('POINT(3 2)', 0))

	)AS T([nome], [area], [ponto])

) AS RS

GO