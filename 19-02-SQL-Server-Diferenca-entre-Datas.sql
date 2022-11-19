/* 1. Conhecer os dados, selecionar registros */
select * FROM [padroes]


/* 2. Obter a data do registro anterior, LAG, OVER, PARTITION */
SELECT [Cód_Padrão], [Data] as data_atual,
        LAG([Data]) OVER (PARTITION BY [Cód_Padrão] ORDER BY [Data]) as data_anterior
FROM [padroes]


/* 3. Diferenças entre data, DATEDIFF */
/* data_anterior - data_atual */

SELECT [Cód_Padrão], [Data] as data_atual,
		DATEDIFF(DAY, 
			LAG([Data]) OVER (PARTITION BY [Cód_Padrão] ORDER BY [Data]),
			[DATA])
FROM [padroes]

/* 4. Alterar registro se nulo, ISNULL */

SELECT [Cód_Padrão], [Data] as data_atual,
		  ISNULL(
			DATEDIFF(DAY, 
				LAG([Data]) OVER (PARTITION BY [Cód_Padrão] ORDER BY [Data]),
				[Data])
           ,0)
FROM [padroes]


