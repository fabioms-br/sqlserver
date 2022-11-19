/* 1. Habilitar executar comandos de console */

EXEC sp_configure 'xp_cmdshell', 1
RECONFIGURE

/* 2. Criar tabela temporária e Listar arquivos */
-- E:\Datasets\nfe_*

CREATE TABLE #arquivos(ID int IDENTITY(1,1), nome VARCHAR(MAX), XmlTexto xml);

INSERT INTO #arquivos (nome)
EXEC xp_cmdshell 'dir /B /S E:\Datasets\nfe_*'

SELECT * FROM #arquivos 

/* 3. Atualizando o Conteundo XML do registro */
-- 'E:\Datasets\nfe_001.xml'

DECLARE @xml AS xml = 
(SELECT CAST(XmlCol AS XML) 
FROM OPENROWSET(BULK 'E:\Datasets\nfe_001.xml',SINGLE_BLOB) AS T(XmlCol))

UPDATE #arquivos SET XmlTexto = @xml
WHERE nome = 'E:\Datasets\nfe_001.xml'

SELECT * FROM #arquivos 

/* 4. Lendo os arquivos e atualizar os registros na tabela */ 

DECLARE @i int = 1
DECLARE @fileName nvarchar(MAX)
DECLARE @command nvarchar(MAX)

While  @i <= (SELECT COUNT(*) FROM #arquivos)
Begin
	SET @filename = (SELECT nome FROM #arquivos WHERE id = @i)
	
	SET @command = N'

	DECLARE @xml AS xml = 
	(SELECT CAST(XmlCol AS XML) 
	FROM OPENROWSET(BULK '''+ @fileName +''',SINGLE_BLOB) AS T(XmlCol))

	UPDATE #arquivos SET XmlTexto = @xml
	WHERE nome = '''+ @fileName +'''

	'
	EXEC(@command)
  
	SET @i = @i + 1
End
GO

/* 5. Lendo o Conteúdo XML existente nos registros */

WITH XMLNAMESPACES (DEFAULT 'http://www.portalfiscal.inf.br/nfe')
SELECT 
	campo.value('(emit/CNPJ)[1]', 'varchar(MAX)') as CNPJ,
    campo.value('(emit/enderEmit/xBairro)[1]', 'varchar(MAX)') as xBairro,
    campo.value('(emit/enderEmit/xMun)[1]', 'varchar(MAX)') as xMun,
    campo.value('(total/ICMSTot/vNF)[1]', 'varchar(MAX)') as vNF
FROM  
(
   select XmlTexto from #arquivos
   WHERE nome IS NOT NULL

) AS T(XmlCol)
CROSS APPLY
	[XmlCol].nodes('/nfeProc/NFe/infNFe') AS XmlCol(campo)

/* 5 Excluindo a tabela temporária e desabilitando os recursos */

DROP TABLE #arquivos

EXEC sp_configure 'xp_cmdshell', 0  
RECONFIGURE 