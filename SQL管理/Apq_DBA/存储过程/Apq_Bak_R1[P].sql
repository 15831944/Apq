IF( OBJECT_ID('bak.Apq_Bak_R1', 'P') IS NULL )
	EXEC sp_executesql N'CREATE PROCEDURE bak.Apq_Bak_R1 AS BEGIN RETURN END';
GO
ALTER PROC bak.Apq_Bak_R1
	@ID			bigint,
	@JobTime	datetime = NULL
AS
/* =============================================
-- 作者: 黄宗银
-- 日期: 2010-12-29
-- 描述: 执行单个数据库备份
	获取备份配置,执行备份,更新最后备份时间,记录备份日志
-- 示例:
DECLARE @rtn int;
EXEC @rtn = bak.Apq_Bak_R1 'Apq_DBA';
SELECT @rtn;
-- =============================================
-1:读取备份队列错误,无法备份!
-2:空间可能不足,停止备份!
*/
SET NOCOUNT ON;

SELECT @JobTime = isnull(@JobTime,getdate())
	;

DECLARE @rtn int, @SPBeginTime datetime
	,@cmd nvarchar(4000), @sql nvarchar(4000), @sqlDB nvarchar(4000)
	,@DBName nvarchar(256)
	,@BakType tinyint
	,@BakFolder nvarchar(4000)
	,@FTPFolder nvarchar(4000)
	,@NeedTruncate tinyint
	,@NeedRestore tinyint
	,@RestoreFolder nvarchar(4000)
	,@DB_HisNum int
	,@Num_Full int		-- 完整备份文件保留个数
	
	,@FullFileToDel nvarchar(4000)	--在此文件之前的文件将被删除
	,@BakFileName nvarchar(256)
	,@BakFileFullName nvarchar(4000)
	,@FTPFileFullName nvarchar(4000)
	,@Num_HisDB int	-- 临时变量:已有历史库个数
	,@ProductVersion	decimal
	;
SELECT @SPBeginTime=GetDate();
SELECT @BakFolder = '', @NeedTruncate = 0;
SELECT TOP(1) @DBName = DBName, @BakType = BakType, @BakFolder = BakFolder, @FTPFolder = FTPFolder, @NeedTruncate = NeedTruncate
	,@NeedRestore = NeedRestore, @RestoreFolder = RestoreFolder, @DB_HisNum = DB_HisNum, @Num_Full = Num_Full
  FROM bak.BakQueue
 WHERE ID = @ID;
IF(@@ROWCOUNT = 0)
BEGIN
	PRINT '读取备份队列错误,无法备份!';
	RETURN -1;
END

-- 创建目录
IF(Len(@BakFolder)>3)
BEGIN
	IF(RIGHT(@BakFolder,1)<>'\') SELECT @BakFolder = @BakFolder+'\';
	SELECT @cmd = 'md ' + SUBSTRING(@BakFolder, 1, LEN(@BakFolder)-1);
	EXEC master..xp_cmdshell @cmd;
END
IF(Len(@FTPFolder)>3)
BEGIN
	IF(RIGHT(@FTPFolder,1)<>'\') SELECT @FTPFolder = @FTPFolder+'\';
	SELECT @cmd = 'md ' + SUBSTRING(@FTPFolder, 1, LEN(@FTPFolder)-1);
	EXEC master..xp_cmdshell @cmd;
END
IF(Len(@RestoreFolder)>3)
BEGIN
	IF(RIGHT(@RestoreFolder,1)<>'\') SELECT @RestoreFolder = @RestoreFolder+'\';
	SELECT @cmd = 'md ' + SUBSTRING(@RestoreFolder, 1, LEN(@RestoreFolder)-1);
	IF(@NeedRestore = 1) EXEC master..xp_cmdshell @cmd;
END

-- 接收cmd返回结果
CREATE TABLE #cmd(s nvarchar(4000));

IF(@BakType = 1 AND Len(@FTPFolder) > 1)
BEGIN
	-- 先删除历史备份文件 --------------------------------------------------------------------------
	-- 删除保留个数以外的备份文件
	TRUNCATE TABLE #cmd;
	SELECT @cmd = 'dir /a:-d/b/o:n "' + @FTPFolder + @DBName + '[*].*"';
	INSERT #cmd(s) EXEC master..xp_cmdshell @cmd;
	
	SELECT @FullFileToDel = '';
	IF(@Num_Full < = 1)
	BEGIN
		SELECT @cmd = '';
		SELECT @cmd = @cmd + '&&del /F /Q "' + @FTPFolder + s + '"'
		  FROM #cmd
		 WHERE Len(s) > 0;

		IF(Len(@cmd) > 2)
		BEGIN
			SELECT @cmd = Right(@cmd,Len(@cmd)-2);
			SELECT @cmd;
			EXEC master..xp_cmdshell @cmd;
		END
	END
	ELSE
	BEGIN
		SELECT TOP(@Num_Full-1) @FullFileToDel = s
		  FROM #cmd
		 WHERE Len(s) > Len(@DBName) + 6
			AND Left(s,Len(@DBName)+1) = @DBName+'['
			AND SubString(s,Len(@DBName)+ 15,5) = '].bak'
		 ORDER BY s DESC;
		IF(Len(@FullFileToDel) > 1)
		BEGIN
			SELECT @cmd = '';
			SELECT @cmd = @cmd + '&&del /F /Q "' + @FTPFolder + s + '"'
			  FROM #cmd
			 WHERE s < @FullFileToDel;

			IF(Len(@cmd) > 2)
			BEGIN
				SELECT @cmd = Right(@cmd,Len(@cmd)-2);
				SELECT @cmd;
				EXEC master..xp_cmdshell @cmd;
			END
		END
	END
	-- =============================================================================================
	
	-- 检测剩余空间 --------------------------------------------------------------------------------
	DECLARE @spused float, @disksp float;
	SELECT @sql = '
	CREATE TABLE #spused(
		name		nvarchar(256),
		rows		varchar(11),
		reserved	varchar(18),
		data		varchar(18),
		index_size	varchar(18),
		unused		varchar(18)
	);
	EXEC ' + @DBName + '..sp_MSforeachtable "INSERT #spused EXEC sp_spaceused ''?'', ''true''";
	SELECT @spused = 0;
	SELECT @spused = @spused + LEFT(reserved,LEN(reserved)-3) FROM #spused;
	SELECT @spused = @spused / 1024;
	DROP TABLE #spused;
	';
	
	BEGIN TRY
		EXEC @rtn = sp_executesql @sql, N'@spused float out', @spused = @spused out;
	END TRY
	BEGIN CATCH
	END CATCH
	
	CREATE TABLE #drives(
		drive	varchar(5),
		MB		float
	);
	INSERT #drives
	EXEC master..xp_fixeddrives;

	IF(EXISTS(SELECT TOP 1 1 FROM #drives WHERE MB < @spused * 0.7 AND drive IN(LEFT(@BakFolder,1),LEFT(@FTPFolder,1)))) -- 暂取0.7
	BEGIN
		PRINT '空间可能不足,停止备份!';
		RETURN -2;
	END
	DROP TABLE #drives;
	-- =============================================================================================
END

-- 计算备份文件名
SELECT @BakFileName = @DBName + '[' + LEFT(REPLACE(REPLACE(REPLACE(CONVERT(nvarchar,@SPBeginTime,120),'-',''),':',''),' ','_'),13)
	+ CASE @BakType WHEN 1 THEN '].bak' WHEN 2 THEN '].trn' ELSE '].btp' END;
SELECT @BakFileFullName = @BakFolder + '_' + @BakFileName;
-- 记录备份启动日志
--SELECT @cmd = '@echo [' + convert(nvarchar,@SPBeginTime,120) + ']' + @BakFileName + '>>' + @FTPFolder + '[Log]Apq_Bak.txt'
--EXEC @rtn = master..xp_cmdshell @cmd;

IF(@BakType = 1)
BEGIN--完整备份
	--截断日志(仅限2000使用)
	IF(@NeedTruncate=1)
	BEGIN
		EXEC dbo.Apq_ShrinkLog @DBName, 1;
	END
	
	UPDATE bak.BakQueue SET State = State | 1, RunTime = @JobTime WHERE ID = @ID;
	
	SELECT @sql = 'BACKUP DATABASE @DBName TO DISK=@BakFile WITH INIT';
	EXEC @rtn = sp_executesql @sql, N'@DBName nvarchar(256), @BakFile nvarchar(4000)', @DBName = @DBName, @BakFile = @BakFileFullName;
	IF(@@ERROR = 0 AND @rtn = 0)
	BEGIN
		-- 本地恢复历史库
		IF(@NeedRestore & 1 <> 0)
		BEGIN
			-- 删除历史库
			SELECT @Num_HisDB = Count(name)
			  FROM sys.databases
			 WHERE Len(name) > Len(@DBName) AND Left(name,Len(@DBName)+1) = @DBName + '_';
			IF(@Num_HisDB >= @DB_HisNum)
			BEGIN
				SELECT @sql = '';
				SELECT TOP(@Num_HisDB-@DB_HisNum+1) @sql = @sql + 'EXEC dbo.Apq_KILL_DB ''' + name + ''';DROP DATABASE [' + name + '];'
				  FROM sys.databases
				 WHERE Len(name) > Len(@DBName) AND Left(name,Len(@DBName)+1) = @DBName + '_'
				 ORDER BY name;
				EXEC sp_executesql @sql;
			END
			
			DECLARE @DBName_R nvarchar(256);
			SELECT @DBName_R = @DBName + '_' + LEFT(REPLACE(CONVERT(nvarchar,Dateadd(dd,-1,Substring(@BakFileName,Len(@DBName)+2,8)),120),'-',''),8);
			EXEC bak.Apq_Restore 1,@DBName_R,@BakFileFullName,1,@RestoreFolder
			EXEC dbo.Apq_ShrinkLog @DBName_R, 1;
		END
	END
	
	UPDATE bak.BakQueue SET State = State & (~1), IsSuccess = 1 WHERE ID = @ID;
END
IF(@BakType = 2)
BEGIN--日志备份
	UPDATE bak.BakQueue SET State = State | 2, RunTime = @JobTime WHERE ID = @ID;
	
	SELECT @sql = 'BACKUP LOG @DBName TO DISK=@BakFile';
	EXEC @rtn = sp_executesql @sql, N'@DBName nvarchar(256), @BakFile nvarchar(4000)', @DBName = @DBName, @BakFile = @BakFileFullName;
	IF(@@ERROR = 0 AND @rtn = 0)
	BEGIN
		-- 尝试收缩日志文件
		EXEC dbo.Apq_ShrinkLog @DBName;
	END
	
	UPDATE bak.BakQueue SET State = State & (~2), IsSuccess = 1 WHERE ID = @ID;
END

-- 移动到FTP目录 -----------------------------------------------------------------------------------
IF(Len(@FTPFolder)>0)
BEGIN
	SELECT @cmd = 'move /y "' + @BakFileFullName + '" "' + SUBSTRING(@FTPFolder, 1, LEN(@FTPFolder)-1) + '"';
	EXEC master..xp_cmdshell @cmd;
	SELECT @BakFileFullName = @FTPFolder + '_' + @BakFileName;
END
ELSE
BEGIN
	SELECT @FTPFolder = @BakFolder;
END
SELECT @FTPFileFullName = @FTPFolder + @BakFileName;
SELECT @cmd = 'move /y "' + @BakFileFullName + '" "' + @FTPFileFullName + '"';
EXEC master..xp_cmdshell @cmd;
-- =================================================================================================

DROP TABLE #cmd;
RETURN 1;
GO
