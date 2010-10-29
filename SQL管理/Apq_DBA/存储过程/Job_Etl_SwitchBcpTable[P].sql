IF( OBJECT_ID('etl.Job_Etl_SwitchBcpTable', 'P') IS NULL )
	EXEC sp_executesql N'CREATE PROCEDURE etl.Job_Etl_SwitchBcpTable AS BEGIN RETURN END';
GO
ALTER PROC etl.Job_Etl_SwitchBcpTable
AS
/* =============================================
-- 作者: 黄宗银
-- 日期: 2010-10-28
-- 描述: 切换BCP接收表
-- 功能: 按预定时间切换BCP接收表
-- 示例:
DECLARE @rtn int;
EXEC @rtn = etl.Job_Etl_SwitchBcpTable;
SELECT @rtn;
-- =============================================
*/
SET NOCOUNT ON;

--定义变量
DECLARE @ID bigint,
	@DBName nvarchar(256),	-- 数据库名
	@SchemaName nvarchar(256),
	@TName nvarchar(256),
	@STName nvarchar(256),
	@Cycle int,			-- 切换周期(分钟)
	@STime smalldatetime,-- 切换时间
	@PreSTime datetime	-- 上一次切换时间
	
	,@rtn int, @sql nvarchar(4000), @sqlDB nvarchar(4000)
	,@JobTime datetime	-- 作业启动时间
	,@Today smalldatetime
	,@TodaySTime smalldatetime -- 今天预定切换时间
	;
SELECT @JobTime=GetDate();
SELECT @Today = dateadd(dd,0,datediff(dd,0,@JobTime));

--定义游标
DECLARE @csr CURSOR;
SET @csr=CURSOR STATIC FOR
SELECT ID, DBName, SchemaName, TName, STName, Cycle, STime, PreSTime
  FROM etl.BcpSTableCfg
 WHERE Enabled = 1;

OPEN @csr;
FETCH NEXT FROM @csr INTO @ID,@DBName,@SchemaName,@TName,@STName,@Cycle,@STime,@PreSTime;
WHILE(@@FETCH_STATUS=0)
BEGIN
	SELECT @PreSTime = ISNULL(@PreSTime,dateadd(n,4-@Cycle,@STime))
	SELECT @TodaySTime = Convert(nvarchar(11),@Today,120) + Left(Convert(nvarchar(50),@STime,108),6)+'00';

	IF(DATEDIFF(n, @PreSTime, @JobTime) >= @Cycle - 1	-- 执行周期已到
		--AND datediff(n,@JobTime,@TodaySTime) BETWEEN 0 AND 5	-- 今天执行时间已到
	)BEGIN
		-- 切换表
		SELECT @sqlDB = 'EXEC sp_rename ''' + @SchemaName + '.' + @STName + ''', ''' + @STName + '_SwithTmp'';
EXEC sp_rename ''' + @SchemaName + '.' + @TName + ''', ''' + @STName + ''';
EXEC sp_rename ''' + @SchemaName + '.' + @STName + '_SwithTmp'', ''' + @TName + ''';
';
		SELECT @sql = 'EXEC [' + @DBName + ']..sp_executesql @sqlDB';
		EXEC sp_executesql @sql, N'@sqlDB nvarchar(4000)', @sqlDB = @sqlDB;
		
		UPDATE etl.BcpSTableCfg SET _Time = getdate(), PreSTime = @JobTime WHERE ID = @ID;
	END

	FETCH NEXT FROM @csr INTO @ID,@DBName,@SchemaName,@TName,@STName,@Cycle,@STime,@PreSTime;
END
CLOSE @csr;

RETURN 1;
GO
