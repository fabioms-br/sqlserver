
-- 3. Adicionar Expressão de Tabela Comum (CTE)
WITH DATAS AS (

	-- 2. Contar dias entre datas
	SELECT 
	*
	,DATEDIFF(day, ferias_inicio, ferias_fim) AS DIAS 

	FROM

	-- 1. Criar tabela de constantes
	(VALUES 

	('Fabio', CAST('2022-08-12' as datetime), CAST('2022-08-24' as datetime)), 
	('Eduardo', '2022-08-16', '2022-09-15'), -- 8 dias em conflito com Fabio
	('Rafael', '2022-09-16', '2022-09-21'), -- Nenhum conflito
	('Vivian', '2022-10-15', '2022-10-30'), -- 2 dias em conflito com Andrezza
	('Andrezza', '2022-10-28', '2022-11-27')


	) AS T(nome, ferias_inicio, ferias_fim)


)
-- 4. Comparar os valores existentes
/*
(nome_t1, ferias_inicio_t1, ferias_fim_t1, dias_t1,
 nome_t2, ferias_inicio_t2, ferias_fim_t2, dias_t2)
*/


, COMPARAR AS (

	SELECT t1.nome AS nome_t1, t1.ferias_inicio AS ferias_inicio_t1, t1.ferias_fim AS ferias_fim_t1, t1.DIAS AS dias_t1,
		   t2.nome AS nome_t2, t2.ferias_inicio AS ferias_inicio_t2, t2.ferias_fim AS ferias_fim_t2, t2.DIAS AS dias_t2
	FROM DATAS t1
	CROSS APPLY DATAS t2
)
-- 5. Identificar conflitos e contar os dias
 SELECT 
 *
 -- Férias em conflitos
 ,(CASE 
	WHEN (ferias_inicio_t1 BETWEEN ferias_inicio_t2 AND ferias_fim_t2) 
         OR (ferias_fim_t1 BETWEEN ferias_inicio_t2 AND ferias_fim_t2)  
	THEN 'Sim' 
	ELSE 'Não' 
   END) AS conflito

 -- Dias em conflito
 ,(CASE 
	WHEN (ferias_inicio_t1 BETWEEN ferias_inicio_t2 AND ferias_fim_t2) THEN DATEDIFF(day,ferias_inicio_t1,ferias_fim_t2)       
	WHEN (ferias_fim_t1 BETWEEN ferias_inicio_t2 AND ferias_fim_t2) THEN DATEDIFF(day,ferias_inicio_t2,ferias_fim_t1)  
	ELSE 0 
   END) AS dias
  
 FROM COMPARAR

-- 6. Filtrar comparações iguais
 WHERE nome_t1 <> nome_t2