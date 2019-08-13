/*******************************************************************************************/
/* select data from a trace table.  set the table name and criteria before running script. */
/*******************************************************************************************/
SELECT	rownumber, starttime, endtime,
	CASE eventclass	WHEN	0	THEN 'TraceStart'
			WHEN	10	THEN 'RPC:Completed'
			WHEN	11	THEN 'RPC:Starting'
			WHEN	12	THEN 'SQL:BatchCompleted'
			WHEN	13	THEN 'SQL:BatchStarting'
 			WHEN	21	THEN 'ErrorLog'
 			WHEN	22	THEN 'ErrorLog'
 			WHEN	33	THEN 'Exception'
			WHEN	40	THEN 'SQL:StmtStarting'
			WHEN	41	THEN 'SQL:StmtCompleted'
			WHEN	42	THEN 'SP:Starting'
			WHEN	43	THEN 'SP:Completed'
			WHEN	44	THEN 'SP:StmtStarting'
			WHEN	45	THEN 'SP:StmtCompleted'
			WHEN	55	THEN 'Hash Warning'
			WHEN	69	THEN 'Sort Warnings'
			WHEN	79	THEN 'Missing Column Statistics'
			WHEN	80	THEN 'Missing Join Predicate'
			WHEN	162 THEN 'User Error Message'
			ELSE RTRIM(LTRIM(CONVERT(CHAR, eventclass)))
	END 'EventClass',
	reads,
	writes,
	duration,
	textdata
	--save the trace records to a table in the db and then remove the table later
FROM	'table where the trace is saved' 
--WHERE	
--eventclass IN (10)
--AND	textdata like 'exec sp_reset_connection%'
ORDER BY rownumber
GO




/*
SELECT * FROM a_trace_Login WHERE eventclass IN (10) AND textdata like 'exec sp_reset_connection%'


-- Grab the 1 row before and 1 row after target rows
;WITH CTE_Rows AS
(
	SELECT rownumber-1 AS RowNum FROM a_trace_Login WHERE eventclass IN (10) AND textdata like 'exec sp_reset_connection%'
	UNION
	SELECT rownumber AS RowNum FROM a_trace_Login WHERE eventclass IN (10) AND textdata like 'exec sp_reset_connection%'
	UNION
	SELECT rownumber+1 AS RowNum FROM a_trace_Login WHERE eventclass IN (10) AND textdata like 'exec sp_reset_connection%'
)
SELECT	A.rownumber, A.starttime, A.endtime,
	CASE A.eventclass	
			WHEN	0	THEN 'TraceStart'
			WHEN	10	THEN 'RPC:Completed'
			WHEN	11	THEN 'RPC:Starting'
			WHEN	12	THEN 'SQL:BatchCompleted'
			WHEN	13	THEN 'SQL:BatchStarting'
 			WHEN	21	THEN 'ErrorLog'
 			WHEN	22	THEN 'ErrorLog'
 			WHEN	33	THEN 'Exception'
			WHEN	40	THEN 'SQL:StmtStarting'
			WHEN	41	THEN 'SQL:StmtCompleted'
			WHEN	42	THEN 'SP:Starting'
			WHEN	43	THEN 'SP:Completed'
			WHEN	44	THEN 'SP:StmtStarting'
			WHEN	45	THEN 'SP:StmtCompleted'
			WHEN	55	THEN 'Hash Warning'
			WHEN	69	THEN 'Sort Warnings'
			WHEN	79	THEN 'Missing Column Statistics'
			WHEN	80	THEN 'Missing Join Predicate'
			WHEN	162 THEN 'User Error Message'
			ELSE RTRIM(LTRIM(CONVERT(CHAR, eventclass)))
	END 'EventClass',
	A.reads,
	A.writes,
	A.duration,
	A.textdata
FROM	dbo.a_trace_Login AS A
Inner Join CTE_Rows AS B ON A.RowNumber = B.RowNum
ORDER BY A.RowNumber;





-- select sum(duration) FROM	a_trace_Login

-- select MIN(starttime), max(endtime) FROM	a_trace_Login

-- 13 seconds to log into UAT.

*/


