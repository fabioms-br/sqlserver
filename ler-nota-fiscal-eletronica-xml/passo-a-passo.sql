/* 1. Conhecer os dados */

SELECT CAST(XmlCol AS xml), XmlCol
   FROM OPENROWSET(BULK 'E:\Datasets\nfe_001.xml',SINGLE_BLOB) AS T(XmlCol) 
   -- Nota Fiscal de 2021


/* 2. XMLNAMESPACES e Selecionar colunas */

WITH XMLNAMESPACES 
(
    DEFAULT 'http://www.portalfiscal.inf.br/nfe'
)
SELECT 

	campo.value('CNPJ[1]', 'varchar(MAX)') as CNPJ

FROM  
(
   SELECT CAST(XmlCol AS xml) 
   FROM OPENROWSET(BULK 'E:\Datasets\nfe_002.xml',SINGLE_BLOB) AS T(XmlCol)
   -- Nota Fiscal de 2015

) AS T(XmlCol)
CROSS APPLY
	[XmlCol].nodes('/nfeProc/NFe/infNFe/emit') AS XmlCol(campo)



/* 3. Valor Total da Nota e Criando Tabela automaticamente */

WITH XMLNAMESPACES 
(
    DEFAULT 'http://www.portalfiscal.inf.br/nfe'
)
SELECT 
   campo.value('(emit/CNPJ)[1]', 'varchar(MAX)') as CNPJ,
   campo.value('(emit/xNome)[1]', 'varchar(MAX)') as idDocumento,
   campo.value('(emit/enderEmit/xLgr)[1]', 'varchar(MAX)') as xLgr,
   campo.value('(emit/enderEmit/xBairro)[1]', 'varchar(MAX)') as xBairro,
   campo.value('(emit/enderEmit/xMun)[1]', 'varchar(MAX)') as xMun,

   campo.value('(total/ICMSTot/vNF)[1]', 'varchar(MAX)') as vNF

--INTO SQLNotaFiscal

FROM  
(
   SELECT CAST(XmlCol AS xml) 
   FROM OPENROWSET(BULK 'E:\Datasets\nfe_003.xml',SINGLE_BLOB) AS T(XmlCol)
   -- Nota Fiscal de 2014

) AS T(XmlCol)
CROSS APPLY
	[XmlCol].nodes('/nfeProc/NFe/infNFe') AS XmlCol(campo)


