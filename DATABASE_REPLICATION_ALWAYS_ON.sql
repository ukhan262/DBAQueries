-----------------**************************************************************************-----------------
				-- SETUP FOR DB REPLICATION - PRIMARY DB (MAIN) AND SECONDARY DB (DATAMART)--
-----------------**************************************************************************-----------------
--- YOU MUST EXECUTE THE FOLLOWING SCRIPT IN SQLCMD MODE.
:Connect "primary server"

IF (SELECT state FROM sys.endpoints WHERE name = N'Hadr_endpoint') <> 0
BEGIN
	ALTER ENDPOINT [Hadr_endpoint] STATE = STARTED
END


GO

use [master]

GO

GRANT CONNECT ON ENDPOINT::[Hadr_endpoint] TO ["service account access"]

GO

:Connect "primary server"

IF EXISTS(SELECT * FROM sys.server_event_sessions WHERE name='AlwaysOn_health')
BEGIN
  ALTER EVENT SESSION [AlwaysOn_health] ON SERVER WITH (STARTUP_STATE=ON);
END
IF NOT EXISTS(SELECT * FROM sys.dm_xe_sessions WHERE name='AlwaysOn_health')
BEGIN
  ALTER EVENT SESSION [AlwaysOn_health] ON SERVER STATE=START;
END

GO

:Connect "secondary server"

IF (SELECT state FROM sys.endpoints WHERE name = N'Hadr_endpoint') <> 0
BEGIN
	ALTER ENDPOINT [Hadr_endpoint] STATE = STARTED
END


GO

use [master]

GO

GRANT CONNECT ON ENDPOINT::[Hadr_endpoint] TO ["service account access"]

GO

:Connect "secondary server"

IF EXISTS(SELECT * FROM sys.server_event_sessions WHERE name='AlwaysOn_health')
BEGIN
  ALTER EVENT SESSION [AlwaysOn_health] ON SERVER WITH (STARTUP_STATE=ON);
END
IF NOT EXISTS(SELECT * FROM sys.dm_xe_sessions WHERE name='AlwaysOn_health')
BEGIN
  ALTER EVENT SESSION [AlwaysOn_health] ON SERVER STATE=START;
END

GO

:Connect "primary server"

USE [master]

GO

CREATE AVAILABILITY GROUP [Minerva ReadOnly]
WITH (AUTOMATED_BACKUP_PREFERENCE = SECONDARY,
DB_FAILOVER = OFF,
DTC_SUPPORT = NONE,
CLUSTER_TYPE = EXTERNAL,
REQUIRED_SYNCHRONIZED_SECONDARIES_TO_COMMIT = 0)
FOR DATABASE [db_Minerva]
REPLICA ON N'"secondary server"' WITH (ENDPOINT_URL = N'TCP://"secondary server".wedgewood-inc.com:5022', FAILOVER_MODE = EXTERNAL, AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT, BACKUP_PRIORITY = 50, SEEDING_MODE = AUTOMATIC, SECONDARY_ROLE(ALLOW_CONNECTIONS = ALL)),
	N'"primary server"' WITH (ENDPOINT_URL = N'TCP://"primary server".wedgewood-inc.com:5022', FAILOVER_MODE = EXTERNAL, AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT, BACKUP_PRIORITY = 50, SEEDING_MODE = AUTOMATIC, SECONDARY_ROLE(ALLOW_CONNECTIONS = NO));

GO

:Connect "secondary server"

ALTER AVAILABILITY GROUP [Minerva ReadOnly] JOIN WITH (CLUSTER_TYPE = EXTERNAL);

GO

ALTER AVAILABILITY GROUP [Minerva ReadOnly] GRANT CREATE ANY DATABASE;

GO


GO


