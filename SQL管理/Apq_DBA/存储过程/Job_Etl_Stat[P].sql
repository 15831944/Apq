IF( OBJECT_ID('etl.Job_Etl_Stat', 'P') IS NULL )
	EXEC sp_executesql N'CREATE PROCEDURE etl.Job_Etl_Stat AS BEGIN RETURN END';
GO
ALTER PROC etl.Job_Etl_Stat
AS
/* =============================================
-- 作者: 黄宗银
-- 日期: 2010-10-29
-- 描述: 统计作业
-- 示例:
DECLARE @rtn int;
EXEC @rtn = etl.Job_Etl_Stat;
SELECT @rtn;
-- =============================================
*/
SET NOCOUNT ON;

--定义变量
DECLARE @ID bigint,
	@StatName nvarchar(256),
	@Detect nvarchar(4000),	-- 检测数据到位情况,通过时返回1(参数:@StatName,@StartTime,@EndTime)
	@STMT nvarchar(3500),	-- 统计存储过程或统计语句(参数:@StartTime,@EndTime)[可接受重复统计请求,时间段参数值内部可进行调整]
	@FirstStartTime datetime, -- 统计参数:开始时间初始值
	@Cycle int,			-- 统计周期(分钟)
	@RTime smalldatetime,-- 首次统计执行时间
	@PreRTime datetime	-- 上一次统计时间
	
	,@rtn int, @sql nvarchar(4000), @sqlDB nvarchar(4000)
	,@JobTime datetime	-- 作业启动时间
	,@Today smalldatetime
	,@TodaySTime smalldatetime -- 今天预定统计时间
	,@PreStartTime datetime	-- 上一次成功的统计开始时间
	,@PreEndTime datetime	-- 上一次成功的统计结束时间
	;
SELECT @JobTime=GetDate();
SELECT @Today = dateadd(dd,0,datediff(dd,0,@JobTime));

--定义游标
DECLARE @csr CURSOR;
SET @csr=CURSOR STATIC FOR
SELECT ID, StatName, Detect, STMT, FirstStartTime, Cycle, RTime, PreRTime
  FROM etl.StatCfg
 WHERE Enabled = 1;

OPEN @csr;
FETCH NEXT FROM @csr INTO @ID,@StatName,@Detect,@STMT,@FirstStartTime,@Cycle,@RTime,@PreRTime;
WHILE(@@FETCH_STATUS=0)
BEGIN
	-- 单次循环内的变量初始清空
	SELECT @PreStartTime = NULL, @PreEndTime = NULL;
	
	SELECT @PreRTime = ISNULL(@PreRTime,dateadd(n,4-@Cycle,@RTime))
	SELECT @TodaySTime = Convert(nvarchar(11),@Today,120) + Left(Convert(nvarchar(50),@RTime,108),6)+'00';
	
	-- 取上次统计结束时间为下次统计开始时间,直到结束时间超过当前作业执行时间,无执行记录时取初始时间
	SELECT TOP 1 @PreStartTime = StartTime, @PreEndTime = EndTime
	  FROM etl.Log_Stat
	 WHERE StatName = @StatName
	 ORDER BY StartTime DESC;
	SELECT @PreStartTime = ISNULL(@PreStartTime,Dateadd(n,-@Cycle,@FirstStartTime));
	SELECT @PreEndTime = ISNULL(@PreEndTime,Dateadd(n,@Cycle,@PreStartTime));
	
	WHILE(DATEDIFF(n, @PreRTime, @JobTime) >= @Cycle	-- 执行周期已到
		AND @JobTime >= @RTime	-- 首次执行时间已到
		AND Dateadd(n,@Cycle,@PreEndTime) <= @JobTime	-- 即将统计的结束时间未超过当前作业时间,即要求数据在一个执行周期内到位
	)BEGIN
		-- 即将统计的时间段
		SELECT @PreStartTime = @PreEndTime;
		SELECT @PreEndTime = Dateadd(n,@Cycle,@PreStartTime);
		
		-- 检测数据到位情况(通过才统计)
		IF(LEN(@Detect)>1)
		BEGIN
			EXEC @rtn = sp_executesql @Detect, N'@StatName nvarchar(256),@StartTime datetime,@EndTime datetime'
				, @StatName = @StatName, @StartTime = @PreStartTime,@EndTime = @PreEndTime;
			IF(@@ERROR <> 0 OR @rtn <> 1)
			BEGIN
				GOTO NEXT_Stat;
			END
		END
		
		EXEC @rtn = sp_executesql @STMT, N'@StartTime datetime,@EndTime datetime', @StartTime = @PreStartTime,@EndTime = @PreEndTime;
		IF(@@ERROR <> 0 OR @rtn <> 1)
		BEGIN
			GOTO NEXT_Stat;
		END
		
		-- 记录本次统计日志
		INSERT etl.Log_Stat ( StatName,STMT,StartTime,EndTime )
		VALUES  (@StatName,@STMT,@PreStartTime,@PreEndTime)
		
		-- 更新统计配置表记录的最后执行时间
		UPDATE etl.StatCfg SET _Time = getdate(), PreRTime = @JobTime WHERE ID = @ID;
	END
	
	NEXT_Stat:
	FETCH NEXT FROM @csr INTO @ID,@StatName,@Detect,@STMT,@FirstStartTime,@Cycle,@RTime,@PreRTime;
END
CLOSE @csr;

RETURN 1;
GO
