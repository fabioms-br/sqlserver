
/*1 Criar tabela */
IF OBJECT_ID ( 'dbo.cidades', 'U' ) IS NOT NULL 
    DROP TABLE dbo.cidades;
GO

CREATE TABLE cidades 
    ( id int IDENTITY (1,1),
	cidade varchar(max),
	uf varchar(max),
    geocol geography);
GO


/*2. Inserir Registro, Point Lat Long Alt */
/*
cidade	        long	        lat	            uf
PORTO SEGURO	-39.06211352	-16.44905618	BAHIA
*/

insert into cidades ([cidade], [uf], [geocol])
values (
'PORTO SEGURO',
'BAHIA',
geography::STGeomFromText('POINT(-39.06211352 -16.44905618)', 4326)
);

/*LINESTRING
  POLYGON
*/


/* 3. visualizar mapa */
-- Inserir mais registros utilizando o arquivo '02-Inserir-registros.sql'

select 

cidade, uf, geocol,
geocol.Lat as geoLat,
geocol.Long as geoLong,
CONCAT('geography::STGeomFromText(POINT(''', geocol.Long, geocol.Lat,'''), 4326)')

from [cidades_dados]
where uf='BAHIA'




