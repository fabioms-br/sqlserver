## Criar Tabela de Arquivos no SQL Server

<img src="https://fabioms.com.br//uploads/youtube/tnEWu1P9pIM.png" alt="Criar Tabela de Arquivos no SQL Server" title="SQL Server" width="320"/>

Apresentamos nesse vídeo como habilitar a criação de tabela de arquivos e utilizar o índice de texto completo para pesquisar por palavras existentes no contéudo de arquivos em formato PDF.

Iremos conhecer as técnicas:
- Gerar script de criação de Tabela de Arquivos usando modelo (FILETABLE TEMPLATE);
- Identificar se a tabela já existe na estrutura (IF, OBJECT_ID, IS NOT NULL)
- Excluir tabela (DROP TABLE); 
- Criar tabela de arquivos (CREATE TABLE, AS FILETABLE);
- Habilitar FILESTREAM na instância SQL Server (FILESTREAM TRANSACT-SQL ACCESS, LEVEL);
- Adicionar Filegroup a banco de dados existente (ALTER DATABASE, ADD FILEGROUP);
- Adicionar Arquivo associado ao Filegroup (ALTER TABLE, ADD FILE, TO FILEGROUP)
- Definir a pasta principal de armazenamentos dos arquivos (FILESTREAM DIRECTORY NAME);
- Definir o nível de acesso ao Filestream (NON-TRANSACTED ACCESS, READONLY, FULL);
- Explorar pastas da tabela de arquivos (EXPLORE FILETABLE DIRECTORY);
- Consultar tabela de arquivos (SELECT, TOP);
- Criar índice de texto completo (FULL-TEXT INDEX);
- Identificar os formatos de arquivo suportados pela pesquisa de texto completo (FULLTEXT DOCUMENT TYPES);
- Instalar suporte aos arquivos de formato PDF (ADOBE PDF FILTER);
- Pesquisar por arquivos que contém palavras selecionadas (WHERE, CONTAINS, AND);

✅ Acesse o vídeo no link abaixo:
http://www.fabioms.com.br/?url=sql-server-pesquisa-tabela-arquivos

😉 Gostou do conteúdo? Inscreva-se também no canal:
http://www.fabioms.com.br/?url=youtube-subscribe

#microsoft #dataplatform #sqlserver #dataanalysis #sql #data #dicadofabinho