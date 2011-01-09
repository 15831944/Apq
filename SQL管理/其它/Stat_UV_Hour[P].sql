ALTER PROCEDURE dbo.Stat_UV_Hour
	 @StartTime	datetime
	,@EndTime	datetime
	,@IsAgain	tinyint = 0
AS
/* =============================================
-- 作者: 黄宗银
-- 日期: 2011-01-07
-- 描述: 统计 小时UV
-- 示例:
DECLARE @rtn int
EXEC @rtn = dbo.Stat_UV_Hour '20101001','20101015'
SELECT @rtn;
-- =============================================
*/
SET NOCOUNT ON;

DECLARE @sql nvarchar(4000), @cmd nvarchar(4000)
	,@Cols nvarchar(4000), @colsGroup nvarchar(max), @colg nvarchar(4000)
	,@i int, @pB int, @pE int
	;
	
-- UV_Hour_SG ----------------------------------------------------------------------------------
DELETE dbo.UV_Hour_SG WHERE FK_Hour >= @StartTime AND FK_Hour < @EndTime;

-- PlatForm, Model, Resolution, Area, Source, APPWidth, APPHeight, Provider
SELECT @Cols = 'Model,Area,Source,';
EXEC dbo.Apq_Combine @Cols,NULL,NULL,NULL,@colsGroup OUT,NULL;
SELECT @pB = 0, @pE = 0, @i = 0;
WHILE(@pE < Len(@colsGroup))
BEGIN
	SELECT @pB = @pE+1,@i = @i + 1;
	SELECT @pE = charindex(';',@colsGroup,@pB);
	IF(@pE <= 0) SELECT @pE = Len(@colsGroup);
	SELECT @colg = CASE WHEN @pE-@pB <= 1 THEN '' ELSE substring(@colsGroup,@pB,@pE-@pB) END;
	
	SELECT @sql = '
INSERT dbo.UV_Hour_SG (' + @colg + 'FK_Hour, UV)
SELECT ' + @colg + 'FK_Hour ,Count(DISTINCT Imei)
  FROM log.SG l(NOLOCK)
 WHERE FK_Hour >= @StartTime AND FK_Hour < @EndTime
	AND DownLoadPage = 0 AND l.Source>0 AND LEFT(l.ScStatus,1) IN(2,3)
 GROUP BY ' + @colg + 'FK_Hour;
';
	PRINT '-- UV_Hour_SG ---------------------------------------------------------------------------------------'
	PRINT @sql;
	PRINT '-- =================================================================================================='
	EXEC sp_executesql @sql, N'@StartTime datetime, @EndTime datetime'
		,@StartTime = @StartTime, @EndTime = @EndTime;
END
-- =============================================================================================

RETURN 1;

