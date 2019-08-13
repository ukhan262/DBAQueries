-----------------**************************************************************************-----------------
								-- DB BACKUP PROCESS FOR REPORTING SERVER --
-----------------**************************************************************************-----------------
BACKUP DATABASE [ReportServer] TO DISK='D:\BACKUP\ReportServer.bak'
BACKUP DATABASE [ReportServerTempDB] TO DISK='D:\BACKUP\ReportServerTempDB.bak'


-----------------**************************************************************************-----------------
								-- DB RESTORE PROCESS FOR REPORTING SERVER --
-----------------**************************************************************************-----------------
ALTER DATABASE [ReportServer] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE IF EXISTS [ReportServer]

RESTORE DATABASE [ReportServer] FROM   DISK = N'D:\Backup\ReportServer.bak'  WITH MOVE 'ReportServer' TO 'D:\Data\ReportServer.mdf',  MOVE 'ReportServer_log' TO 'L:\Logs\ReportServer_log.LDF',  NORECOVERY, REPLACE;

ALTER DATABASE [ReportServerTempDB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE IF EXISTS [ReportServerTempDB];

RESTORE DATABASE [ReportServerTempDB] FROM   DISK = N'D:\Backup\ReportServerTempDB.bak'  WITH MOVE 'ReportServerTempDB' TO 'D:\Data\ReportServerTempDB.mdf',  MOVE 'ReportServer_log' TO 'L:\Logs\ReportServerTempDB_log.LDF',  NORECOVERY, REPLACE;