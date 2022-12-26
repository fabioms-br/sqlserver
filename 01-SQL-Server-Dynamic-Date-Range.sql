
/* 8. Definir variáveis */
DECLARE @meses int = 6;
DECLARE @data_nulo varchar(max) = '2021-01-01 00:00:00.000';

--Not necessary
DECLARE @BaseURL varchar(max) = 'https://ptax.bcb.gov.br/ptax_internet/';
DECLARE @RelativeURL varchar(max) = 'consultaBoletim.do?method=gerarCSVFechamentoMoedaNoPeriodo&ChkMoeda=61&DATAINI=01/01/2021&DATAFIM=11/04/2022';


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
			   ,[data_inicio] = t2.[ult_data] -- Obter Data Início
		FROM [MOEDA] t1

		LEFT JOIN ( 
		
			/* 1. Agrupar pela data máxima */
			SELECT MAX([Data])+1 as [ult_data] -- Obter última data atualizada
				   ,[Moeda_Id] 
			FROM [MOEDA_COTACOES]  
			GROUP BY [Moeda_Id] 		

		) AS t2 ON t2.[Moeda_Id] = t1.[Moeda_Id]

		-- Remover Moeda Real Brasil
		WHERE [Download_Id] <> '' 


	) AS RS

),
Data_Hierarquia AS ( 

	/* 4. Separar Datas em período de tempo (6 meses) */
	-- Nível Pai
	SELECT [Moeda_Sigla]
		   , [Download_Id]
		   , [data_inicio] AS [data] -- renomear coluna
		   , 1 AS [level] -- Exibir nível da hiearquia
	FROM Moedas
		
		UNION ALL -- Obter todos os registros

	-- Nível Filho
	SELECT  Moedas.[Moeda_Sigla]
		   , Moedas.[Download_Id], 
		   DATEADD(MONTH, 6, [data]), -- Adicionar 6 meses a data encontrada
		   [level] + 1 -- Exibir nível da hiearquia
	FROM  Data_Hierarquia, Moedas -- Selecionar as duas tabelas
	WHERE [data] < GETDATE() AND -- Obter Data Atual
		  Moedas.[Moeda_Sigla] = Data_Hierarquia.[Moeda_Sigla] 

), DataIntervalo AS (

	/* 5. Obter Intervalo de Datas */	
	SELECT [Moeda_Sigla]
	       ,[Download_Id] 
		   ,[data_inicio]
		   -- Limitar da Fim Condicionalmente
		   ,(CASE WHEN [data_fim] > [data_hoje] 
		          THEN [data_hoje]
				  ELSE [data_fim]         
		    END) AS [data_fim]
	FROM (
		-- Definir 6 meses da data início 
		SELECT [Moeda_Sigla]
			   , [Download_Id]
			   , [data] as [data_inicio]
			   , DATEADD(MONTH, 6, [data])-1 as [data_fim] -- Adicionar 6 meses a data encontrada
			   , GETDATE() AS [data_hoje] -- Obter Data Atual
		FROM   Data_Hierarquia 
		WHERE [data] < GETDATE()
	) AS D

) 
/* 7. Obter URL relativa */

	
SELECT [Moeda_Sigla]
		,[Download_Id]
		,CONVERT(varchar(20),[data_inicio],103) AS [data_inicio] 
		,CONVERT(varchar(20),[data_fim],103) AS [data_fim]
FROM DataIntervalo 
ORDER BY Moeda_Sigla
