/* 1. Selecionar registros da Tabela */






/* 2. Agrupar os registros por região */
select 

* 

from fBrasil


/* 3. Uso do STUFF */
select 

[Regiao]

from fBrasil
group by [Regiao]


/* 4. Sub-Consulta e XML PATH */
select 

[Regiao],
STUFF(',SP',1,1,'') as Sigla

from fBrasil
group by [Regiao]


/* 5. Resultado */
select * from  fBrasil

select 
[Regiao],
STUFF((select distinct ',' + Sigla from fBrasil rs 
	   where rs.Regiao = tb.Regiao FOR XML PATH(''))
	  ,1,1,'') as Sigla
from fBrasil tb
group by [Regiao] 