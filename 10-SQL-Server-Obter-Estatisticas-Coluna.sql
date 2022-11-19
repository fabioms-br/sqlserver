SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY UnitPrice)
OVER (PARTITION BY NULL) AS MedianCont
FROM Sales.SalesOrderDetail

/*----Numeric Columns-----*/

select v.ColumnName as 'Nome da Coluna', 
    COUNT(*) - COUNT(v.ColumnValue) AS 'Linhas Vazias',
	AVG(v.ColumnValue) as Média, 
	STDEV(v.ColumnValue) as [Desv. Pad], 
	MIN(v.ColumnValue) as Min, 
	MAX(v.ColumnValue) as Máx	
from Sales.SalesOrderDetail ea cross apply
     (values ('OrderQty', ea.OrderQty),
			 ('UnitPrice', ea.UnitPrice),
             ('UnitPriceDiscount', ea.UnitPriceDiscount),
             ('LineTotal', ea.LineTotal)
     ) v(ColumnName, ColumnValue)
GROUP BY v.ColumnName



DECLARE @sqlCommand varchar(max) = 'SELECT * FROM [' + 'Sales' + '].[' + 'SalesOrderDetail' + '] WHERE ' 
	   
   SELECT @sqlCommand = @sqlCommand + '[' + COLUMN_NAME + '] LIKE ''' + '' + ''' OR '
   FROM INFORMATION_SCHEMA.COLUMNS 
   WHERE TABLE_SCHEMA = 'Sales'
   AND TABLE_NAME = 'SalesOrderDetail'
   AND DATA_TYPE IN ('char','nchar','ntext','nvarchar','text','varchar')

PRINT(@sqlCommand)


/*----String Columns-----*/

select v.ColumnName as 'Nome da Coluna', 
    COUNT(*) - COUNT(v.ColumnValue) AS 'Linhas Vazias',
	COUNT(DISTINCT v.ColumnValue) AS 'Linhas Únicas',
	MIN(v.ColumnValue) AS 'Min',
	MAX(v.ColumnValue) AS 'Máx'
from Sales.SalesOrderDetail ea outer apply
     (values 
		('SalesOrderID', CONVERT(varchar(max), SalesOrderID)),
		('ProductID', CONVERT(varchar(max), ProductID)),
		('CarrierTrackingNumber', CarrierTrackingNumber),
		('SpecialOfferID', CONVERT(varchar(max), SpecialOfferID))
     ) v(ColumnName, ColumnValue)
GROUP BY v.ColumnName


DESCRIBE 'Sales.SalesOrderDetail';


select v.ColumnName as 'Nome da Coluna', 
    COUNT(*) - COUNT(v.ColumnValue) AS 'Linhas Vazias'
	--COUNT(DISTINCT v.ColumnValue) AS 'Linhas Únicas',
	--MIN(v.ColumnValue) AS 'Min',
	--MAX(v.ColumnValue) AS 'Máx'
from Sales.SalesOrderDetail ea 
outer apply
(
	SELECT tc.COLUMN_NAME AS ColumnName, ea.CarrierTrackingNumber AS ColumnValue
	FROM INFORMATION_SCHEMA.COLUMNS tc           -- nome da tabela de colunas do sistema
	WHERE tc.DATA_TYPE IN ('nvarchar') -- Filtrar coluna pelo tipo de datos
		  AND tc.TABLE_NAME = 'SalesOrderDetail'
) AS v
GROUP BY v.ColumnName



SELECT tc.COLUMN_NAME AS ColumnName, 
    [COUNT] = (SELECT COUNT(*) FROM Sales.SalesOrderDetail)
FROM INFORMATION_SCHEMA.COLUMNS tc           -- nome da tabela de colunas do sistema
WHERE tc.DATA_TYPE IN ('nvarchar') -- Filtrar coluna pelo tipo de datos
		  AND tc.TABLE_NAME = 'SalesOrderDetail'






/***-------*/

	SELECT 
	'Mean' as 'Coluna',	AVG(UnitPrice) as 'UnitPrice',
	AVG(UnitPriceDiscount)as 'UnitPriceDiscount',AVG(LineTotal) as 'LineTotal'
	FROM Sales.SalesOrderDetail

/*------------------------------*/

	SELECT 
	'Mean' as 'Coluna',	AVG(UnitPrice) as 'UnitPrice',	
	AVG(UnitPriceDiscount)as 'UnitPriceDiscount',
	AVG(LineTotal) as 'LineTotal'
	FROM Sales.SalesOrderDetail

	UNION

	SELECT 
	'Min' as 'Coluna',	MIN(UnitPrice) as 'UnitPrice',
	MIN(UnitPriceDiscount)as 'UnitPriceDiscount',
	MIN(LineTotal) as 'LineTotal'
	FROM Sales.SalesOrderDetail


	UNION

	SELECT 
	'Max' as 'Coluna',	MAX(UnitPrice) as 'UnitPrice',
	MAX(UnitPriceDiscount)as 'UnitPriceDiscount',
	MAX(LineTotal) as 'LineTotal'
	FROM Sales.SalesOrderDetail

	UNION

	SELECT 
	'Std' as 'Coluna',	STDEV(UnitPrice) as 'UnitPrice',
	STDEV(UnitPriceDiscount)as 'UnitPriceDiscount',
	STDEV(LineTotal) as 'LineTotal'
	FROM Sales.SalesOrderDetail



SELECT 
    name,
    system_type_id,
    system_type_name,
    max_length,
    [precision],
    scale
FROM sys.dm_exec_describe_first_result_set(
    'select * from Sales.SalesOrderDetail', 
    null, 
    0);


	sys.


