-- check the table that needs rebuild in order to optimize the forward records batch requests
SELECT
	OBJECT_NAME(object_id) AS table_name,
	forwarded_record_count,
	avg_fragmentation_in_percent,
	page_count
FROM
	sys.dm_db_index_physical_stats(
									  DB_ID(), DEFAULT, DEFAULT, DEFAULT,
									  'DETAILED'
								  )
WHERE
	forwarded_record_count IS NOT NULL;
GO

ALTER TABLE 'TABLENAME' REBUILD;

-- Rerun to check again
SELECT
	OBJECT_NAME(object_id) AS table_name,
	forwarded_record_count,
	avg_fragmentation_in_percent,
	page_count
FROM
	sys.dm_db_index_physical_stats(
									  DB_ID(), DEFAULT, DEFAULT, DEFAULT,
									  'DETAILED'
								  )
WHERE
	forwarded_record_count IS NOT NULL;
GO