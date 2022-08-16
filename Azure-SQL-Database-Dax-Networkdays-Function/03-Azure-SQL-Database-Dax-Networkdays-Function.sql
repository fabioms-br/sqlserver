/* 1. Calcular Quantidade de Dias úteis */
DECLARE @data_inicio AS datetime = '2022-09-01';
DECLARE @data_fim AS datetime = '2022-09-30';

/* 2. Calcular Dias úteis */
SELECT
  /* Contar dias entre datas */
   (DATEDIFF(DAY,@data_inicio,@data_fim) + 1)
  /* Contar semanas entre datas */ 
  - (DATEDIFF(WEEK,@data_inicio,@data_fim) * 2)
  /* Contar final de semana imcompleto */
  - (CASE WHEN DATENAME(WEEKDAY,@data_inicio) = 'Sunday' THEN 1 ELSE 0 END)
  - (CASE WHEN DATENAME(WEEKDAY,@data_fim) = 'Saturday' THEN 1 ELSE 0 END);
GO


/* 2. Criar Tipo de Dados Tabela */

CREATE TYPE holidaysTableType 
   AS TABLE
      ( date datetime );
GO

DECLARE @data_inicio AS datetime = '2022-05-01';
DECLARE @data_fim AS datetime = '2022-05-31';
DECLARE @holidays AS holidaysTableType
 
INSERT INTO @holidays VALUES ( '2022-05-01' );
INSERT INTO @holidays VALUES ( '2022-09-07' );

SELECT * FROM @holidays
GO


/*3. Converter texto em linhas */

DECLARE @holidays AS nvarchar(max) = '2022-05-01,2022-09-07';

SELECT CAST(value AS datetime) AS [Date] 
FROM STRING_SPLIT(@holidays, ',');


/* Criar Função NETWORKDAYS */
CREATE OR ALTER FUNCTION dbo.sf_NETWORKDAYS
(
    @start_date datetime,
    @end_date datetime,
	@weekend int = 1 ,
	@holidays nvarchar(max) = '' 
)
RETURNS INT
AS
BEGIN

	/* 1 or omitted: Saturday, Sunday; */
	DECLARE @weekend_days AS int = 2;
	DECLARE @start_day AS nvarchar(max) = 'Sunday';
	DECLARE @end_day AS nvarchar(max) = 'Saturday';

	/* 2: Sunday, Monday; */
	IF @weekend = 2 BEGIN
		SELECT @start_day = 'Monday';
		SELECT @end_day = 'Sunday';
	END

	/*
	3: Monday, Tuesday; 
	4: Tuesday, Wednesday; 
	5; Wednesday, Thursday; 
	6: Thursday, Friday; 
	7: Friday, Saturday; 
	11: Sunday only; */

	IF @weekend = 11 BEGIN
		SELECT @start_day = 'Sunday';
		SELECT @end_day = 'Sunday';
		SELECT @weekend_days = 1;
	END

	/*
	12: Monday only; 
	13: Tuesday only; 
	14: Wednesday only; 
	15: Thursday only; 
	16: Friday only; 
	17: Saturday only.
	*/	

	-- Inserir registros de datas separadas por vírgula
	DECLARE @holidaysTable AS holidaysTableType

	INSERT INTO @holidaysTable
	SELECT value 
	FROM STRING_SPLIT(@holidays, ',')

	RETURN(

	-- Contar Dias Úteis entre datas
		SELECT
		  /* Contar dias entre datas */
		   (DATEDIFF(DAY,@start_date,@end_date) + 1)
		  /* Contar semanas entre datas */ 
		  - (DATEDIFF(WEEK,@start_date,@end_date) * @weekend_days)
		  /* Contar final de semana imcompleto */
		  - (CASE WHEN DATENAME(WEEKDAY,@start_date) = @start_day THEN 1 ELSE 0 END)
		  - (CASE WHEN DATENAME(WEEKDAY,@end_date) = @end_day THEN 1 ELSE 0 END)
		  /* Remover as datas de feriados */
		  - (SELECT SUM(CASE WHEN [date] BETWEEN @start_date AND @end_date THEN 1 ELSE 0 END) FROM @holidaysTable) 


	)
	         
			                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
END


/* 5. Executar função */
SELECT [dbo].[sf_NETWORKDAYS]('2022-09-01','2022-09-30', DEFAULT, DEFAULT)


SELECT * FROM (

VALUES
    ('Sab/Dom', dbo.sf_NETWORKDAYS('2022-09-01','2022-09-30', DEFAULT, DEFAULT)), -- Ignorar Padrao
	('Domingo', dbo.sf_NETWORKDAYS('2022-09-01','2022-09-30', 11, DEFAULT)), -- Ignorar Domingo
	('Sab/Dom + 7 Setembro', dbo.sf_NETWORKDAYS('2022-09-01','2022-09-30', DEFAULT, '2022-05-01,2022-09-07'))


) AS T([Tipo],[Dias Uteis])
