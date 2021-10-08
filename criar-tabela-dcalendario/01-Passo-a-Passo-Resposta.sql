/* 1. Criar tabela dCalendario */
--DROP TABLE IF EXISTS dCalendario;

CREATE TABLE dCalendario
(
  [Data] DATETIME PRIMARY KEY,
  [Ano] AS DATEPART(YEAR,[Data]),
  [Mês] AS DATEPART(MONTH,[Data]),
  [Dia]  AS DATEPART(DAY,[Data]), 
  [DiaAno]  AS DATEPART(DAYOFYEAR,[Data]), 
  [Trimestre] AS DATEPART(QUARTER,[Data]),
  [SemanaAno]AS DATEPART(WK,[Data]),
  [MêsNome] AS DATENAME(MONTH, [Data]),
  [DiaNome] AS DATENAME(WEEKDAY, [Data]),
  [AnoTrismestre_Nome] AS CONCAT(DATEPART(YEAR,[Data]),' - ',DATEPART(QUARTER,[Data]),'º Trismestre') 
);


/* 2. Identificar a Data inicial e Final das tabelas */
-- subquery

SELECT MIN(datamin), MAX(datamax) FROM (
	SELECT MIN([ShipDate]) AS datamin, MAX([ShipDate]) AS datamax 
	FROM [Purchasing].[PurchaseOrderHeader]

	UNION ALL

	SELECT MIN([DueDate]), MAX([DueDate]) 
	FROM [Production].[WorkOrder]
) RS


/* 3. Inserir datas na tabela dCalendario */ 
--expressão de tabela comum

WITH DATAS (datamin,datamax) AS (

	SELECT MIN(datamin), MAX(datamax) FROM (
		SELECT MIN([ShipDate]) AS datamin, MAX([ShipDate]) AS datamax 
		FROM [Purchasing].[PurchaseOrderHeader]

		UNION ALL

		SELECT MIN([DueDate]), MAX([DueDate]) 
		FROM [Production].[WorkOrder]
	) RS

)
,CALENDARIO AS ( 
-- (SELECT datamin FROM DATAS) 

    SELECT (SELECT datamin FROM DATAS) AS [Data], 1 AS [nivel] --Ponto Inicial
        
		UNION ALL
    
	SELECT DATEADD(DAY, 1, [Data]), [nivel] + 1 --Ponto Recursive
    FROM  CALENDARIO
    WHERE [Data] < (SELECT datamax FROM DATAS)  

)
INSERT INTO dCalendario ([Data])
SELECT [Data] FROM CALENDARIO
OPTION (MAXRECURSION 0)




SELECT * FROM [dCalendario]
