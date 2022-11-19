COMO ESTÁ: 
DATA SALARIO 
01/01/2020 - 1.300,00 
01/05/2020 - 1.500,00 
01/11/2021 - 2.000,00 

COMO DEVE FICAR: 
DATA SALARIO 
01/01/2020 - 1.300,00 
01/02/2020 - 1.300,00 
01/03/2020 - 1.300,00 
01/04/2020 - 1.300,00 
01/05/2020 - 1.500,00 
01/06/2020 - 1.500,00 
01/07/2020 - 1.500,00 
01/08/2020 - 1.500,00 
01/09/2020 - 1.500,00 
01/10/2020 - 1.500,00 
01/11/2021 - 2.000,00 

/* 1. Disponibilizar os dados (Tabela Constante, Criar Tabela) */

SELECT [Data], Salario 
INTO SALARIOS
FROM 
(
VALUES
	(CAST('01/01/2020' AS datetime),1300.00),
	(CAST('01/05/2020' AS datetime),1500.00),
	(CAST('01/11/2021' AS datetime),2000.00) 
) TSALARIOS([Data], Salario)


/* 2. Identificar o registro posterior (LEAD) */

SELECT 

[Data] AS Data_Inicial, 
LEAD([Data]) OVER(Order by [Data]) AS Data_Final,
Salario

FROM SALARIOS

/* 3. Listar datas e relacionar os Salários (CTE, Hierarquia) */
DECLARE @start_date DATETIME = (SELECT MIN([Data]) FROM SALARIOS);
DECLARE @end_date DATETIME =  (SELECT MAX([Data]) FROM SALARIOS);

WITH CALENDARIO AS ( 

	-- Hierarquia
    SELECT   @start_date AS [Date], 1 AS [level]
        UNION ALL
    SELECT   DATEADD(MONTH, 1, [Date]), [level] + 1
    FROM     CALENDARIO
    WHERE    [Date] < @end_date 

), DATA_SALARIOS AS (

	SELECT 
	[Data] AS Data_Inicial, 
	LEAD([Data]) OVER(Order by [Data]) AS Data_Final,
	Salario
	FROM SALARIOS

)
SELECT t1.[Date], t2.Salario
FROM CALENDARIO t1
JOIN DATA_SALARIOS t2 
ON (t1.[Date] >= t2.Data_Inicial AND t1.[Date] < t2.Data_Final)
    OR (t1.[Date] >= t2.Data_Inicial AND t2.Data_Final IS NULL)

