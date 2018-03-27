DECLARE @ts_now bigint = (SELECT cpu_ticks/(cpu_ticks/ms_ticks)FROM sys.dm_os_sys_info); 

SELECT TOP(1000) SQLProcessUtilization AS [SQL Server Process CPU Utilization], 
               SystemIdle AS [System Idle Process], 
               100 - SystemIdle - SQLProcessUtilization AS [Other Process CPU Utilization], 
               DATEADD(ms, -1 * (@ts_now - [timestamp]), GETDATE()) AS [Event Time] 
FROM ( 
	  SELECT record.value('(./Record/@id)[1]', 'int') AS record_id, 
			record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') 
			AS [SystemIdle], 
			record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 
			'int') 
			AS [SQLProcessUtilization], [timestamp] 
	  FROM ( 
			SELECT [timestamp], CONVERT(xml, record) AS [record] 
			FROM sys.dm_os_ring_buffers 
			WHERE ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR' 
			AND record LIKE '%<SystemHealth>%') AS x 
	  ) AS y 
ORDER BY record_id DESC;

select * from master..sysprocesses
where status = 'runnable' --comment this out
order by CPU
desc

select * from master..sysprocesses
order by CPU
desc

	sp_who2


	SELECT s.session_id,

r.status,

r.blocking_session_id 'Blk by',

r.wait_type,

wait_resource,

r.wait_time / (1000 * 60) 'Wait M',

r.cpu_time,

r.logical_reads,

r.reads,

r.writes,

r.total_elapsed_time / (1000 * 60) 'Elaps M',

Substring(st.TEXT,(r.statement_start_offset / 2) + 1,

((CASE r.statement_end_offset

WHEN -1

THEN Datalength(st.TEXT)

ELSE r.statement_end_offset

END - r.statement_start_offset) / 2) + 1) AS statement_text,

Coalesce(Quotename(Db_name(st.dbid)) + N'.' + Quotename(Object_schema_name(st.objectid, st.dbid)) + N'.' +
Quotename(Object_name(st.objectid, st.dbid)), '') AS command_text,
r.command,

s.login_name,

s.host_name,

s.program_name,

s.last_request_end_time,

s.login_time,

r.open_transaction_count

FROM sys.dm_exec_sessions AS s

JOIN sys.dm_exec_requests AS r

ON r.session_id = s.session_id

CROSS APPLY sys.Dm_exec_sql_text(r.sql_handle) AS st

WHERE r.session_id != @@SPID

ORDER BY r.cpu_time desc