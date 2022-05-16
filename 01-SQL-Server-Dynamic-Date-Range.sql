
/* 8. Definir variáveis */
DECLARE ???;
DECLARE ??? = '2021-01-01 00:00:00.000';


WITH Moedas AS ( -- CTE Expressão de Tabela Comum

	/* 3. Definir Data Início Padrão se nulo */
	SELECT [Moeda_Sigla]
		   ,[Download_Id]
		   -- Definir data inicial se nulo 
		   ,[data_inicio] = (CASE WHEN [data_inicio] IS NULL 
							  	  THEN '2021-01-01 00:00:00.000'
								  ELSE [data_inicio]
							 END)	
	FROM( -- Subconsulta
	
		/* 2. Definir data de início da última atualização */
		SELECT [Moeda_Sigla]
			   ,[Download_Id] 
			   ,[data_inicio] = [ult_data] -- Obter Data Início
		FROM [DS_BCB_MOEDA] t1

		LEFT JOIN ( 
		
			/* 1. Agrupar pela data máxima */
			SELECT MAX([Data])+1 as [ult_data] -- Obter última data atualizada
				   ,[Moeda_Id] 
			FROM [API_BCB_COTACOES]  
			GROUP BY [Moeda_Id] 		

		) AS t2 ON t2.[Moeda_Id] = t1.[Moeda_Id]

		-- Remover Moeda Real Brasil
		WHERE [Download_Id] <> ''


	) AS RS

), -- CTE
Data_Hierarquia AS ( 

	/* 4. Separar Datas em período de tempo (6 meses) */
	-- Nível Pai
	SELECT [Moeda_Sigla]
		   , [Download_Id]
		   , [data_inicio] AS [data] -- renomear coluna
		   , 1 AS [nivel] -- Exibir nível da hiearquia
	FROM Moedas
		
		UNION ALL -- Obter todos os registros

	-- Nível Filho
	SELECT  Moedas.[Moeda_Sigla]
		   , Moedas.[Download_Id], 
		   DATEADD(MONTH, 6, [data]), -- Adicionar 6 meses a data encontrada
		   [nivel] + 1 -- Exibir nível da hierarquia
	FROM  Data_Hierarquia, Moedas -- Selecionar as duas tabelas
	WHERE [data] < GETDATE() AND -- Obter Data Atual
		  Moedas.[Moeda_Sigla] = Data_Hierarquia.[Moeda_Sigla] 

), DataIntervalo AS ( -- CTE

	/* 5. Obter Intervalo de Datas */	
	SELECT [Moeda_Sigla]
	       ,[Download_Id] 
		   ,[data_inicio]
		   -- Limitar da Fim Condicionalmente
		   ,(???) AS [data_fim]
	FROM (
		-- Definir 6 meses da data início 
		SELECT [Moeda_Sigla]
			   , [Download_Id]
			   , [data] as [data_inicio]
			   , DATEADD(MONTH, 6, [data]) as [data_fim] -- Adicionar 6 meses a data encontrada
			   , GETDATE() AS [data_hoje] -- Obter Data Atual
		FROM   Data_Hierarquia 
		WHERE [data] < GETDATE() -- Filtrar data início maior que a data atual
	) AS D

) 
/* 7. Obter URL relativa */
--???

--??? -- Subconsulta
	
	/* 6. Converter Tipo de Dados */
	SELECT [Moeda_Sigla]
		   ,[Download_Id]
		   ,???(varchar(20),[data_inicio],???) AS [data_inicio] -- Formato DD/MM/YYYY
		   ,???(varchar(20),[data_fim],???) AS [data_fim]
	FROM DataIntervalo 

--???
ORDER BY Moeda_Sigla
