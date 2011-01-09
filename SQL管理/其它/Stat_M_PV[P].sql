ALTER PROCEDURE dbo.Stat_M_PV
	 @StartTime	datetime
	,@EndTime	datetime
	,@IsAgain	tinyint = 0
AS
/* =============================================
-- 作者: 黄宗银
-- 日期: 2011-01-06
-- 描述: 统计 PV,DC,DCS
-- 示例:
DECLARE @rtn int
EXEC @rtn = dbo.Stat_M_PV '20101001','20101015'
SELECT @rtn;
-- =============================================
*/
SET NOCOUNT ON;

DECLARE @sql nvarchar(4000), @cmd nvarchar(4000)
	,@Cols nvarchar(4000), @colsGroup nvarchar(max), @colg nvarchar(4000)
	,@i int, @pB int, @pE int
	;

DELETE dbo.[PV_M_SG] WHERE FK_Hour >= @StartTime AND FK_Hour < @EndTime;

INSERT dbo.[PV_M_SG] (PV, FK_Hour, PlatForm, Model, Resolution, Area, Source)
SELECT Count(1)
	,FK_Hour, PlatForm, Model, Resolution, Area, Source
  FROM log.SG l(NOLOCK)
 WHERE FK_Hour >= @StartTime AND FK_Hour < @EndTime
	AND DownLoadPage = 0 AND l.Source>0 AND LEFT(l.ScStatus,1) IN('2','3')
 GROUP BY FK_Hour, PlatForm, Model, Resolution, Area, Source, APPWidth, APPHeight, Provider

DELETE dbo.[DC_M_SG] WHERE FK_Hour >= @StartTime AND FK_Hour < @EndTime;

INSERT dbo.[DC_M_SG] (DC, DCS, FK_Hour, PlatForm, Model, Resolution, Area, Source, Provider, AppName)
SELECT Count(1)
	,SUM(CASE WHEN ScBytes<102400 THEN 1 ELSE 0 END)
	,FK_Hour, PlatForm, Model, Resolution, Area, Source, Provider, AppName
  FROM log.SG l(NOLOCK)
 WHERE FK_Hour >= @StartTime AND FK_Hour < @EndTime
	AND DownLoadPage > 0 AND l.Source>0 AND LEFT(l.ScStatus,1) IN('2','3')
 GROUP BY FK_Hour, PlatForm, Model, Resolution, Area, Source, Provider, AppName

RETURN 1;

