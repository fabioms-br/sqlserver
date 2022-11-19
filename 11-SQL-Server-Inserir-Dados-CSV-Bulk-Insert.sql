


BULK INSERT DetailsDocumentos 
FROM 'E:\notes.txt'
WITH ( FIELDTERMINATOR = '^', ROWTERMINATOR = '\n', FIRSTROW=2, CODEPAGE ='ACP')



DECLARE @Notes varchar(max) = (SELECT * FROM OPENROWSET(
	   BULK 'E:\notes.txt',
	   SINGLE_CLOB) AS DATA
	);

SELECT value FROM STRING_SPLIT(@Notes, '\n');
