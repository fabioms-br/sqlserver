SELECT server_name, database_name, slo_name, user_data_directory_space_quota_mb, user_data_directory_space_usage_mb
FROM sys.dm_user_db_resource_governance
WHERE database_id = DB_ID();

Exec sp_spaceused [SUP_DOCENTE_2019]

SELECT    
      obj.NAME AS "TableName", 
      SUM(reserved_page_count) * 8.0 / 1024 AS "Size (MB)"
FROM sys.dm_db_partition_stats DPS
	INNER JOIN sys.objects obj
		ON (DPS.object_id = obj.object_id)
WHERE obj.Name = 'SUP_CURSO_2019'
GROUP BY obj.name
ORDER BY obj.name


SELECT    
     *-- SUM(reserved_page_count) * 8.0 / 1024 AS "Size (MB)"
FROM sys.dm_db_partition_stats DPS

