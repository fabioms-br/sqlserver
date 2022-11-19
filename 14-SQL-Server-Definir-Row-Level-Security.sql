/* 1. Conhecer os dados */

SELECT  f.[ideCadastro]
		,f.[sgPartido]
		,f.[sgUF]
		,Itens = COUNT(1)
		,[vlrLiquido] = SUM([vlrLiquido])
FROM [SQLPBI].[dbo].[Despesas-Ano-2021] f
GROUP BY      
	f.[txNomeParlamentar]
	,f.[ideCadastro]
	,f.[sgPartido]
	,f.[sgUF]	
ORDER BY f.[ideCadastro] DESC

/* 2. Criar tabela de permissões e inserir registros */ 
CREATE TABLE rls.ideCadastro
  ( ideCadastro sysname, 
    sgPartido varchar(20),
    sgUF varchar(20)
  );

INSERT INTO rls.ideCadastro VALUES ('92776', 'PSD', '*');
INSERT INTO rls.ideCadastro VALUES ('178937', 'PL', 'RJ');

SELECT * FROM rls.ideCadastro;

--Usuários do SQL SERVER
SELECT * FROM sysusers

/* 3. Definir consulta de validação */ 
--f.[sgPartido], f.[sgUF], '92776'

SELECT  f.[ideCadastro]
		,f.[sgPartido]
		,f.[sgUF]
		,Itens = COUNT(1)
		,[vlrLiquido] = SUM([vlrLiquido])
FROM [SQLPBI].[dbo].[Despesas-Ano-2021] f

-- Relacionar as tabelas
	INNER JOIN rls.ideCadastro s
            ON (s.sgPartido = | OR s.sgPartido = '*')
			AND (s.sgUF = | OR s.sgUF = '*')
	WHERE (s.ideCadastro = |)	

GROUP BY      
	f.[txNomeParlamentar]
	,f.[ideCadastro]
	,f.[sgPartido]
	,f.[sgUF]	
ORDER BY f.[ideCadastro]

/* 4. Criar função de validação */ 
 -- @sgPartido, @sgUF
CREATE FUNCTION rls.fn_despesas_ideCadastro
	(| AS varchar(20),| AS varchar(20) )
RETURNS TABLE
WITH SCHEMABINDING -- manter a estrutura
AS 
    RETURN ( 
		
		SELECT 1 as Result
		FROM [dbo].[Despesas-Ano-2021] f

		INNER JOIN rls.ideCadastro s
                     ON (s.sgPartido = | OR s.sgPartido = '*')
					 AND (s.sgUF = | OR s.sgUF = '*')

		WHERE (s.ideCadastro = USER_NAME())		
	);

/* 5. Definir concessão de consulta para os usuários */

GRANT SELECT ON rls.fn_despesas_ideCadastro TO [92776];  
GRANT SELECT ON rls.fn_despesas_ideCadastro TO [178937];  

/* 6. Definir a função da validação na tabela */

CREATE SECURITY POLICY despesasRLS -- Nome da política

ADD FILTER PREDICATE rls.fn_despesas_ideCadastro(sgPartido,sgUF) -- Função de Validação

ON [dbo].[Despesas-Ano-2021] -- Tabela para habilitar RLS

WITH (STATE = ON); -- Definir Status inicial (Ativo/Inativo)


/* 7. Consultar a tabela com RLS ativada */

EXECUTE AS USER = '92776'; 

SELECT  f.[ideCadastro]
		,f.[sgPartido]
		,f.[sgUF]
		,Itens = COUNT(1)
		,[vlrLiquido] = SUM([vlrLiquido])
FROM [SQLPBI].[dbo].[Despesas-Ano-2021] f
GROUP BY      
	f.[txNomeParlamentar]
	,f.[ideCadastro]
	,f.[sgPartido]
	,f.[sgUF]	
ORDER BY f.[ideCadastro] DESC

REVERT;

/* 8. Ativar e inativar depois de criada */

ALTER SECURITY POLICY despesasRLS  
WITH (STATE = OFF);  

ALTER SECURITY POLICY despesasRLS  
WITH (STATE = ON);  

