## Ler arquivo CSV com Bulk Insert no SQL Server

<img src="https://fabioms.com.br//uploads/youtube/70qnrUisj0I.png" alt="Ler arquivo CSV com Bulk Insert no SQL Server" title="SQL Server" width="320"/>

Aproveite os dados existentes do seu arquivo CSV e importe rapidamente para seu banco de dados SQL Server. 
#microsoft #SQLServer #Aprenda #dataplatform #SomosPower

Código de criação da tabela:
/* Nota: usamos o tipo de dados '[varchar](max)' apenas como exemplo, é importante conhecer a estrutura do seu arquivo e utilizar o melhor tipo necessário */
CREATE TABLE [cinema](
 [Titulo Original] [varchar](max) NULL,
 [Titulo no Brasil] [varchar](max) NULL,
 [Ano de producao] [varchar](max) NULL,
 [Diretor] [varchar](max) NULL,
 [Razao Social do Requerente] [varchar](max) NULL,
 [CNPJ Requerente] [varchar](max) NULL
) ON [PRIMARY] 
GO
======================
Arquivo CSV format UTF-8 (Fazer download para seu computador):
http:\\data.fabioms.com.br\Cinema.csv
======================
Código Bulk Insert

BULK INSERT cinema
FROM 'Z:\Cinema.csv' /*alterar o local do arquivo */
WITH (
FIELDTERMINATOR = ';',
CODEPAGE = '65001',
ROWS_PER_BATCH = 1000
);
Me sigam no linkedin: https://www.linkedin.com/in/fabioms/