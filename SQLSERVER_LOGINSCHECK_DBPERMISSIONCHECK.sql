IF OBJECT_ID('TEMPDB..#SQLLogins') IS NOT NULL 
	DROP TABLE #SQLLogins;
GO

IF OBJECT_ID('TEMPDB..#DBRolePermissions') IS NOT NULL
	DROP TABLE #DBRolePermissions;
GO

/*********************************************/
/*************	SQL Logins	******************/
/*********************************************/
CREATE TABLE #SQLLogins (
						Username NVARCHAR (MAX),
						UserType NVARCHAR (MAX),
						isSysAdmin BIT NOT NULL DEFAULT 0
						);
INSERT INTO
	#SQLLogins(
			  Username, UserType, isSysAdmin
			  )
SELECT
	sp.name,
	sp.type_desc,
	s.sysadmin
FROM
	sys.server_principals	 AS sp
	JOIN sys.syslogins		 AS s ON s.sid = sp.sid
	LEFT JOIN sys.sql_logins AS sl ON sl.principal_id = sp.principal_id
WHERE
	sp.type_desc IN ('SQL_LOGIN', 'WINDOWS_GROUP', 'WINDOWS_LOGIN')
	AND sp.name NOT LIKE '##%##'
	AND sp.name NOT IN ('SA')
ORDER BY
	sp.name;

	SELECT * FROM #SQLLogins


/*********************************************/
/*********    DB ROLE PERMISSIONS    *********/
/*********************************************/
CREATE TABLE #DBRolePermissions (
								DBUsername NVARCHAR (MAX),
								DBRole NVARCHAR (MAX)
								);
INSERT INTO
	#DBRolePermissions(
					  DBUsername, DBRole
					  )
SELECT
	USER_NAME(rm.member_principal_id) AS [User],
	USER_NAME(rm.role_principal_id)	  AS Role
FROM
	sys.database_role_members AS rm
WHERE
	USER_NAME(rm.member_principal_id)IN(
									   --get user names on the database
									   SELECT
										   name
									   FROM
										   sys.database_principals AS dp
									   WHERE
										   dp.principal_id > 4 -- 0 to 4 are system users/schemas
										   AND dp.type IN ('G', 'S', 'U') -- S = SQL user, U = Windows user, G = Windows group
									   )
ORDER BY
	[User];


SELECT
	*
FROM
	#SQLLogins					 AS sl
	JOIN #DBRolePermissions AS rp ON rp.DBUsername = sl.Username
ORDER BY
	sl.isSysAdmin DESC;