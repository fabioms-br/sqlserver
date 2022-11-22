/* 1. */

SELECT server_name, database_name, slo_name, user_data_directory_space_quota_mb, user_data_directory_space_usage_mb
FROM sys.dm_user_db_resource_governance
WHERE database_id = DB_ID();

/* 3. */

Exec sp_spaceused [SUP_DOCENTE_2019]

/* 4. */

SELECT    
      obj.NAME AS "TableName", 
      SUM(reserved_page_count) * 8.0 / 1024 AS "Size (MB)"
FROM sys.dm_db_partition_stats DPS
	INNER JOIN sys.objects obj
		ON (DPS.object_id = obj.object_id)
WHERE obj.Name = 'SUP_CURSO_2019'
GROUP BY obj.name
ORDER BY obj.name

/* 5. */

SELECT    
     *-- SUM(reserved_page_count) * 8.0 / 1024 AS "Size (MB)"
FROM sys.dm_db_partition_stats DPS


/* 6. 
 Obter o tamanho utilizado por cada Tabela
 Não necessita de VIEW DATABASE PERFORMANCE STATE
*/

SELECT
    t.NAME AS TableName,
    SUM(a.total_pages) * 8 AS TotalSpaceKB, 
    SUM(a.used_pages) * 8 AS UsedSpaceKB, 
    (SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS UnusedSpaceKB
FROM
    sys.tables t
INNER JOIN
    sys.partitions p ON t.object_id = p.OBJECT_ID
INNER JOIN
    sys.allocation_units a ON p.partition_id = a.container_id
GROUP BY
    t.Name


