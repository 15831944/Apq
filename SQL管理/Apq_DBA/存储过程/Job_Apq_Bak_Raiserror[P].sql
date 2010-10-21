IF( OBJECT_ID('bak.Job_Apq_Bak_Raiserror', 'P') IS NULL )
	EXEC sp_executesql N'CREATE PROCEDURE bak.Job_Apq_Bak_Raiserror AS BEGIN RETURN END';
GO
ALTER PROC bak.Job_Apq_Bak_Raiserror
AS
/* =============================================
-- 作者: 黄宗银
-- 日期: 2010-05-18
-- 描述: 备份系列作业状态检查,出现异常状况则抛出异常
-- 示例:
DECLARE @rtn int;
EXEC @rtn = bak.Job_Apq_Bak_Raiserror;
SELECT @rtn;
-- =============================================
*/
SET NOCOUNT ON;

DECLARE @Now datetime;
SELECT @Now = getdate();

IF(EXISTS(SELECT TOP 1 1 FROM bak.BakCfg WHERE Enabled = 1 AND ReadyAction > 0 AND PreBakTime < Dateadd(n,-TrnCycle*8,@Now)))
	RAISERROR('本地备份 出现异常',16,1);

IF(EXISTS(SELECT TOP 1 1 FROM bak.FTP_PutBak WHERE Enabled = 1 AND Len(LastFileName) > 1 AND DATABASEPROPERTYEX(DBName,'Recovery')<>'SIMPLE'
	AND Convert(datetime,Substring(LastFileName,Len(LastFileName)-17,8) + ' ' + Substring(LastFileName,Len(LastFileName)-8,2) + ':' + Substring(LastFileName,Len(LastFileName)-6,2)) < Dateadd(hh,-2,@Now)))
	RAISERROR('向外传送 出现异常',16,1);

IF(EXISTS(SELECT TOP 1 1 FROM bak.RestoreFromFolder WHERE Enabled = 1 AND Len(LastFileName) > 1 AND DATABASEPROPERTYEX(DBName,'Recovery')<>'SIMPLE'
	AND Convert(datetime,Substring(LastFileName,Len(LastFileName)-17,8) + ' ' + Substring(LastFileName,Len(LastFileName)-8,2) + ':' + Substring(LastFileName,Len(LastFileName)-6,2)) < Dateadd(hh,-24,@Now)))
	RAISERROR('还原或删除 出现异常',16,1);
RETURN 1;
GO
