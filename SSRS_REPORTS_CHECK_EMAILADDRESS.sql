/*
	This query is a modification of the query on this link
	https://social.msdn.microsoft.com/Forums/sqlserver/en-US/002475a9-0556-4722-af38-d17ab6972cbe/details-of-reports-scheduled-on-ssrs-report-name-userdetails-frequency-etc?forum=sqlreportingservices
*/
IF EXISTS (
		  SELECT 1 FROM sys.objects WHERE name LIKE '%ReportSubscriptionCheck%' AND type = 'P'
		  )
	DROP PROCEDURE ReportSubscriptionCheck;
GO

CREATE PROCEDURE ReportSubscriptionCheck(
										@EmailAddress NVARCHAR (MAX)
										)
AS
	BEGIN
		SELECT
			c.Name								   AS ReportName,
			CONVERT(XML, ExtensionSettings).value(
													 '(//ParameterValue/Value[../Name="TO"])[1]',
													 'nvarchar(max)'
												 ) AS [To],
			CONVERT(XML, ExtensionSettings).value(
													 '(//ParameterValue/Value[../Name="CC"])[1]',
													 'nvarchar(max)'
												 ) AS CC,
			CONVERT(XML, ExtensionSettings).value(
													 '(//ParameterValue/Value[../Name="BCC"])[1]',
													 'nvarchar(max)'
												 ) AS BCC,
			CONVERT(XML, ExtensionSettings).value(
													 '(//ParameterValue/Value[../Name="RenderFormat"])[1]',
													 'nvarchar(max)'
												 ) AS [Render Format],
			CONVERT(XML, ExtensionSettings).value(
													 '(//ParameterValue/Value[../Name="Subject"])[1]',
													 'nvarchar(max)'
												 ) AS Subject,
			LastStatus,
			EventType,
			LastRunTime,
			DeliveryExtension,
			Version
		FROM
			dbo.Catalog					  AS c
			INNER JOIN dbo.Subscriptions  AS S ON c.ItemID = S.Report_OID
			INNER JOIN dbo.ReportSchedule AS R ON S.SubscriptionID = R.SubscriptionID
		WHERE
			CONVERT(XML, ExtensionSettings).value(
													 '(//ParameterValue/Value[../Name="TO"])[1]',
													 'nvarchar(max)'
												 ) LIKE '%' + @EmailAddress
														+ '%'
			OR CONVERT(XML, ExtensionSettings).value(
														'(//ParameterValue/Value[../Name="CC"])[1]',
														'nvarchar(max)'
													) LIKE '%'
														   + @EmailAddress
														   + '%'
			OR CONVERT(XML, ExtensionSettings).value(
														'(//ParameterValue/Value[../Name="BCC"])[1]',
														'nvarchar(max)'
													) LIKE '%'
														   + @EmailAddress
														   + '%';

	END;

--EXEC dbo.ReportSubscriptionCheck @EmailAddress = N'' -- nvarchar(max)
