-----------------**************************************************************************-----------------
								-- SETTING UP LINKED SERVER (AZURE) --
-----------------**************************************************************************-----------------

USE [master]
GO

/****** Object:  LinkedServer [server name]    Script Date: 7/30/2019 9:08:41 AM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'server name', @srvproduct=N'SQL AZURE', @provider=N'SQLNCLI', @datasrc=N'data source', @catalog=N'db name'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'server name',@useself=N'False',@locallogin=NULL,@rmtuser=N'username',@rmtpassword='password'
GO

EXEC master.dbo.sp_serveroption @server=N'server name', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'server name', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'server name', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'server name', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'server name', @optname=N'rpc', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'server name', @optname=N'rpc out', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'server name', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'server name', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'server name', @optname=N'collation name', @optvalue=NULL
GO

EXEC master.dbo.sp_serveroption @server=N'server name', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'server name', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'server name', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'server name', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO


