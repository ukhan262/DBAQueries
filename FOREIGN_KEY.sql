-----------------**************************************************************************-----------------
								-- FOREIGN KEY CHECKS BASED ON THE COLUMN ID--
-----------------**************************************************************************-----------------
SELECT
	OBJECT_NAME(FK.referenced_object_id)						'Referenced Table',
	OBJECT_NAME(FK.parent_object_id)							'Referring Table',
	FK.name														'Foreign Key',
	COL_NAME(FK.referenced_object_id, FKC.referenced_column_id) 'Referenced Column',
	COL_NAME(FK.parent_object_id, FKC.parent_column_id)			'Referring Column'
FROM
	sys.foreign_keys				   AS FK
	INNER JOIN sys.foreign_key_columns AS FKC ON FKC.constraint_object_id = FK.object_id
WHERE
	COL_NAME(FK.referenced_object_id, FKC.referenced_column_id) = '';