select
  t.TABLE_SCHEMA as 'Esquema', t.TABLE_NAME as 'Nome da Tabela', t.TABLE_TYPE as 'Tipo',
  'Total de Registros' = SUM(st.row_count)
from
  INFORMATION_SCHEMA.TABLES t
  INNER JOIN sys.dm_db_partition_stats st ON t.TABLE_NAME = object_name(st.object_id)
  AND (st.index_id < 2)
GROUP BY
  t.TABLE_SCHEMA, t.TABLE_NAME, t.TABLE_TYPE
ORDER BY
  TABLE_NAME
