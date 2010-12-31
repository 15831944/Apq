IF( OBJECT_ID('bak.Job_Apq_Bak_Init_R1', 'P') IS NULL )
	EXEC sp_executesql N'CREATE PROCEDURE bak.Job_Apq_Bak_Init_R1 AS BEGIN RETURN END';
GO
ALTER PROC bak.Job_Apq_Bak_Init_R1
AS
/* =============================================
-- 作者: 黄宗银
-- 日期: 2010-12-30
-- 描述: 备份作业的初始化(仅入队)
-- 示例:
DECLARE @rtn int;
EXEC @rtn = bak.Job_Apq_Bak_Init_R1;
SELECT @rtn;
-- =============================================
*/
SET NOCOUNT ON;

--定义变量
DECLARE @cmd nvarchar(4000), @sql nvarchar(4000),

	@DBName nvarchar(256),	-- 数据库名
	@recovery_model tinyint, -- 恢复模式{1:FULL,2:BULK_LOGGED,3:SIMPLE}
	
	-- 备份配置
	@BakFolder nvarchar(4000),--备份目录
	@FTPFolder nvarchar(4000),--FTP目录
	@NeedTruncate tinyint,
	@NeedRestore tinyint,
	@RestoreFolder nvarchar(4000),
	@DB_HisNum int,
	@Num_Full int,
	@FullCycle int,			-- 完整备份周期(天)
	@FullTime smalldatetime,-- 完整备份时间(每次日期与周期相关)
	@TrnCycle smallint,		-- 日志备份周期(分钟,请尽量作业周期的倍数)
	
	@ProductVersion	decimal,-- 服务器版本(取前两字符)
	@ForceFull tinyint,		-- 强制完整备份
	
	@LastBakTime datetime,	-- 最后完整备份时间
	@LastTrnTime datetime,	-- 最后日志备份时间
	@LastDoTime datetime,	-- 最后备份时间
	@Time_C datetime,		-- 本次理论备份时间
	
	@strHisTime nvarchar(9),
	
	@rtn int
	,@JobTime datetime	-- 作业启动时间
	;
SELECT @JobTime=Convert(nvarchar(16),GetDate(),120) + ':00'	--只精确到分
	,@ProductVersion = CONVERT(decimal,LEFT(Convert(nvarchar,SERVERPROPERTY('ProductVersion')),2));

-- 接收cmd返回结果
--CREATE TABLE #t(s nvarchar(4000));

-- 遍历数据库
DECLARE @csr CURSOR;
SET @csr=CURSOR STATIC FOR
SELECT ds.name,recovery_model
  FROM sys.databases ds
 WHERE database_id NOT IN (2,3) AND state = 0 AND is_in_standby = 0
	AND NOT EXISTS(SELECT TOP 1 1 FROM bak.BakQueue q WHERE q.DBName = ds.name AND q.Enabled = 1 AND IsSuccess = 0);

OPEN @csr;
WHILE(1=1)
BEGIN
	FETCH NEXT FROM @csr INTO @DBName,@recovery_model;
	IF(@@FETCH_STATUS<>0) BREAK;
	
	-- 跳过历史库
	IF(Len(@DBName) > 9)
	BEGIN
		IF(Substring(@DBName,Len(@DBName)-8,1) = '_')
		BEGIN
			SELECT @strHisTime = Right(@DBName,8);
			BEGIN TRY
				SELECT Convert(datetime,@strHisTime,120);
				IF(@@ERROR = 0) CONTINUE;
			END TRY
			BEGIN CATCH
			END CATCH
		END
	END
	
	-- 变量初始化
	SELECT @LastBakTime = NULL, @LastTrnTime = NULL;

	-- 获取预设配置
	SELECT @BakFolder = 'D:\DBA\Bak\', @FTPFolder = 'D:\DBA\Bak2FTP\' + @DBName
		,@NeedTruncate = 0, @NeedRestore = 0, @RestoreFolder = 'D:\DB_His\'
		,@DB_HisNum = 15, @Num_Full = 1
		,@FullCycle = 1, @FullTime = '2010-12-29 04:00:00', @TrnCycle = 60;
	-- 获取默认配置
	SELECT @BakFolder = BakFolder, @FTPFolder = FTPFolder + CASE RIGHT(FTPFolder,1) WHEN '\' THEN '' ELSE '\' END+ @DBName
		,@NeedTruncate = NeedTruncate, @NeedRestore = NeedRestore, @RestoreFolder = RestoreFolder
		,@DB_HisNum = DB_HisNum, @Num_Full = Num_Full
		,@FullCycle = FullCycle, @FullTime = FullTime, @TrnCycle = TrnCycle
	  FROM bak.BakCfg
	 WHERE ID = 0;
	-- 获取实例配置
	SELECT @BakFolder = BakFolder, @FTPFolder = FTPFolder
		,@NeedTruncate = NeedTruncate, @NeedRestore = NeedRestore, @RestoreFolder = RestoreFolder
		,@DB_HisNum = DB_HisNum, @Num_Full = Num_Full
		,@FullCycle = FullCycle, @FullTime = FullTime, @TrnCycle = TrnCycle
	  FROM bak.BakCfg
	 WHERE ID > 0 AND DBName = @DBName AND Enabled = 1;
	
	-- 通过备份队列获取 最后完整备份时间 和 最后日志备份时间
	SELECT TOP(1) @LastBakTime = RunTime
	  FROM bak.BakQueue
	 WHERE Enabled = 1 AND DBName = @DBName AND BakType = 1
	 ORDER BY RunTime DESC;
	SELECT TOP(1) @LastTrnTime = RunTime
	  FROM bak.BakQueue
	 WHERE Enabled = 1 AND DBName = @DBName AND BakType = 2
	 ORDER BY RunTime DESC;
	SELECT @LastDoTime = CASE WHEN @LastTrnTime > @LastBakTime THEN @LastTrnTime ELSE @LastBakTime END;
	
	-- 2000以上版本判断是否已完整备份过,没有则强制完整备份
	SELECT @ForceFull = 0;
	IF(@ProductVersion > 8 AND @recovery_model <> 3)
	BEGIN
		SELECT @sql = 'SELECT @ForceFull = 0;
IF(EXISTS(SELECT TOP 1 1 FROM sys.database_recovery_status WHERE last_log_backup_lsn IS NULL AND database_id = DB_ID(@DBName)))
SELECT @ForceFull = 1;';
		EXEC sp_executesql @sql,N'@ForceFull int out, @DBName nvarchar(256)', @ForceFull = @ForceFull out, @DBName = @DBName;
	END
	
	IF(@ForceFull = 1 OR @LastBakTime IS NULL
		OR DATEDIFF(n, @LastBakTime, @JobTime) >= 1440 * @FullCycle - 2
	)BEGIN--完整备份
		INSERT bak.BakQueue(DBName, BakFolder, FTPFolder, NeedTruncate, BakType, NeedRestore, RestoreFolder, DB_HisNum, Num_Full)
		VALUES(@DBName, @BakFolder, @FTPFolder, @NeedTruncate, 1, @NeedRestore, @RestoreFolder, @DB_HisNum, @Num_Full)
	END
	ELSE IF(@recovery_model <> 3 AND DateDiff(N,@LastDoTime,@JobTime) >= @TrnCycle - 1)
	BEGIN--日志备份
		INSERT bak.BakQueue(DBName, BakFolder, FTPFolder, NeedTruncate, BakType, NeedRestore, RestoreFolder, DB_HisNum, Num_Full)
		VALUES(@DBName, @BakFolder, @FTPFolder, @NeedTruncate, 2, @NeedRestore, @RestoreFolder, @DB_HisNum, @Num_Full)
	END
END
CLOSE @csr;

--DROP TABLE #t;
RETURN 1;
GO
