/* Uso de Expressão de Tabela Comum (CTE) */

WITH DATA_VALUES AS (
    SELECT *       
    FROM
        OPENROWSET(
            /* 01. Definir o caminho do arquivo CSV */
            BULK '[SEU CAMINHO]/bcb-dolar-cotacoes.csv',
            FORMAT = 'CSV',
            PARSER_VERSION = '2.0',
            FIELDTERMINATOR = ';'
        ) 
        WITH (

            /* 02. Definir formato dos dados COLLATE */
            [DATA] VARCHAR(10) COLLATE Latin1_General_100_BIN2_UTF8,
            MOEDA_COD VARCHAR(5) COLLATE Latin1_General_100_BIN2_UTF8,
            TIPO VARCHAR(2) COLLATE Latin1_General_100_BIN2_UTF8,
            SIGLA VARCHAR(3) COLLATE Latin1_General_100_BIN2_UTF8,
            VALOR VARCHAR(255) COLLATE Latin1_General_100_BIN2_UTF8

        )                    
        AS [result]
),

/* 03. Converter Tipo de Dados e uso Funções de Janela */
DATA_ANALYSIS AS (

    SELECT  
    *,
    -- Média móvel 50 dias
    AVG([Valor]) -- Definir o cálculo
    OVER(PARTITION BY Sigla ORDER BY [Data] -- Definir Over
        ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)-- Definir Período
    AS dia50_media_movel,

    -- Média móvel 200 dias
    AVG([Valor]) -- Definir o cálculo
    OVER(PARTITION BY Sigla ORDER BY [Data] -- Definir Over
        ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)-- Definir Período
    AS dia200_media_movel

    FROM (
        SELECT 

        SIGLA, 
        -- String para Datetime
        CONVERT(DATETIME, CONCAT(SUBSTRING([DATA],1,2),'-',SUBSTRING([DATA],3,2),'-',SUBSTRING([DATA],5,4)), 103) AS [DATA], --DD-MM-YYYY
        -- String para Numeric    
        CONVERT(NUMERIC(18,4),REPLACE([VALOR],',','.')) AS VALOR

        FROM DATA_VALUES 
    ) AS RS

)
/* 04. Executar a consulta */
SELECT *
FROM DATA_ANALYSIS

