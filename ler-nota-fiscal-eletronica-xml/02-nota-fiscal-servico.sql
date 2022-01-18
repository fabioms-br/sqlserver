

-- O Segredo está no XMLNAMESPACES, para cada ns[*] existente no XML é preciso nomeá-los
-- Nota: É necessário fazer as alterações necessárias para atender a sua solução
-- Como por exemplo o cabeçalho e os itens de serviço
WITH XMLNAMESPACES 
(
	'http://www.w3.org/2000/09/xmldsig#' as ns2,
    'http://www.ginfes.com.br/servico_consultar_nfse_envio' as ns4,
    'http://www.ginfes.com.br/tipos' as ns3,
    'http://www.ginfes.com.br/servico_cancelar_nfse_envio' as ns5
)
SELECT 

	XmlHeader.campo.value('(ns3:DataEmissao)[1]', 'varchar(MAX)') as DataEmissao,
	XmlHeader.campo.value('(ns3:PrestadorServico/ns3:IdentificacaoPrestador/ns3:Cnpj)[1]', 'varchar(MAX)') as CNPJ,
	XmlItems.campo.value('(ns3:Discriminacao)[1]', 'varchar(MAX)') as xServ
   
FROM  
(
   SELECT CAST(XmlCol AS xml) 
   FROM OPENROWSET(BULK 'E:\Datasets\EXEMPLOSERV.XML',SINGLE_BLOB) AS T(XmlCol)
   -- Nota Fiscal de 2014

) AS T(XmlCol)

CROSS APPLY
	[XmlCol].nodes('/ns2:NFSE/ns2:Nfse') AS XmlHeader(campo) -- cabeçalho 
CROSS APPLY
	[XmlCol].nodes('/ns2:NFSE/ns2:Nfse/ns3:Servico') AS XmlItems(campo) -- itens 
