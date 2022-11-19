select storeIndex, storeName, storeCity, storeState, storeValue, storeGeo,
	  storeGeo.Lat as lat, storeGeo.Long as long from

(values 
	(1,'Store A','PORTO SEGURO','BAHIA', 12500, 
	geography::STGeomFromText('POINT(-39.06211352 -16.44905618)', 4326)),

	(2,'Store B','ILHÉUS','BAHIA', 42500, 
	geography::STGeomFromText('POINT(-39.04318429 -14.79332027)', 4326)),

	(3,'Store C','ITABUNA','BAHIA', 4500, 
	geography::STGeomFromText('POINT(-39.27310895 -14.78903955)', 4326)),

	(4,'Store D','SALVADOR','BAHIA', 62500, 
	geography::STGeomFromText('POINT(-38.48806148 -13.01477191)', 4326))

) a(storeIndex, storeName, storeCity, storeState, storeValue, storeGeo)