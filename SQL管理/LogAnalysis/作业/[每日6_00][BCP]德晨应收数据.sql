USE [msdb]
GO
/****** 对象:  Job [[每日6:00]][BCP]]德晨应收数据]    脚本日期: 10/15/2010 14:28:08 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** 对象:  JobCategory [[Uncategorized (Local)]]]    脚本日期: 10/15/2010 14:28:08 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'[每日6:00][BCP]德晨应收数据', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'无描述。', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** 对象:  Step [BCP]    脚本日期: 10/15/2010 14:28:08 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'BCP', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @cmd nvarchar(4000);
--删除超过90天的日志文件
SELECT  @cmd=''del  D:\Gamelog\德晨\''+RTRIM(CONVERT(varchar,GETDATE()-91,112))+''.txt''
exec  xp_cmdshell  @cmd
--导出当天的日志
SELECT @cmd = ''bcp "EXEC [LogAnalysis].dbo.BcpOut_AR_dechen '' + CONVERT(VARCHAR(10),DATEADD(dd,-1,(GETDATE())),112) + ''" queryout "D:\Gamelog\德晨\''+CONVERT(VARCHAR(10),DATEADD(dd,-1,(GETDATE())),112)+''.txt" -c -t, -r\n -T''
EXEC xp_cmdshell @cmd
', 
		@database_name=N'LogAnalysis', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'计划1', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20101015, 
		@active_end_date=99991231, 
		@active_start_time=60000, 
		@active_end_time=235959
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
	IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
