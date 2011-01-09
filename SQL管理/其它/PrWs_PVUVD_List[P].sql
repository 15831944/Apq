ALTER PROCEDURE dbo.PrWs_PVUVD_List
	 @ExMsg nvarchar(max) = '' OUT
	
	,@BeginDay		datetime = NULL
	,@EndDay		datetime = NULL
    ,@AppName		varchar(500) = NULL
	,@PlatForm		varchar(500) = NULL
	,@Model			varchar(500) = NULL
	,@Resolution	varchar(500) = NULL
	,@Area			varchar(500) = NULL
	,@Provider		varchar(500) = NULL
	,@Source		int = NULL
AS
/* =============================================
-- 作者: 黄宗银
-- 日期: 2011-01-07
-- 描述: 列表PV,UV
-- 示例:
DECLARE @rtn int,@ExMsg nvarchar(max)
	,@BeginDay		datetime
	,@EndDay		datetime
    ,@AppName		varchar(500)
	,@PlatForm		varchar(500)
	,@Model			varchar(500)
	,@Resolution	varchar(500)
	,@Area			varchar(500)
	,@Provider		varchar(500)
	,@Source		int
	;
SELECT @BeginDay = '2010-10-01'
	,@EndDay = '2010-10-01'
    ,@AppName = NULL
	,@PlatForm = NULL--'''mtk6223'''
	,@Model = NULL--'''r53x608jc'''
	,@Resolution = NULL
	,@Area = NULL--'''山东'''
	,@Provider = NULL
	,@Source = NULL
EXEC @rtn = dbo.PrWs_PVUVD_List @ExMsg out, @BeginDay,@EndDay,@AppName,@PlatForm,@Model,@Resolution,@Area,@Provider,@Source
SELECT @rtn,@ExMsg;
-- =============================================
*/
SET NOCOUNT ON;

SELECT @BeginDay = ISNULL(@BeginDay,getdate());
SELECT @EndDay = ISNULL(@EndDay,getdate());

SELECT @BeginDay = Dateadd(dd,0,datediff(dd,0,@BeginDay));
SELECT @EndDay = Dateadd(dd,0,datediff(dd,0,@EndDay));

DECLARE @sql nvarchar(4000), @cmd nvarchar(4000)
	,@i int, @pB int, @pE int
	,@h_BeginTime datetime
	,@h_EndTime datetime
	
	,@cols_rt nvarchar(2000)
	
	,@cols_l nvarchar(2000)
	,@cd_l nvarchar(2000)
	
	,@jo_uvd nvarchar(2000)
	,@jo_uvdd nvarchar(2000)
	
	,@cd_pv nvarchar(2000)
	,@cd_uvd nvarchar(2000)
	,@cd_uvdd nvarchar(2000)
	;

SELECT @cols_rt = ''

	,@cols_l = ''
	,@cd_l = ''
	
	,@jo_uvd = ''
	,@jo_uvdd = ''
	
	,@cd_pv = ''
	,@cd_uvd = ''
	,@cd_uvdd = ''
	;
	
SELECT @h_BeginTime = @BeginDay
	,@h_EndTime = dateadd(hh,1,@EndDay)
	;
PRINT Convert(nvarchar(50),@h_BeginTime,120)
PRINT Convert(nvarchar(50),@h_EndTime,120)

SELECT @cd_pv = CASE WHEN @AppName IS NULL THEN '' ELSE ' AND pv.AppName IN (' + @AppName + ')' END
	+ CASE WHEN @PlatForm IS NULL THEN '' ELSE ' AND pv.PlatForm IN (' + @PlatForm + ')' END
	+ CASE WHEN @Model IS NULL THEN '' ELSE ' AND pv.Model IN (' + @Model + ')' END
	+ CASE WHEN @Resolution IS NULL THEN '' ELSE ' AND pv.Resolution IN (' + @Resolution + ')' END
	+ CASE WHEN @Area IS NULL THEN '' ELSE ' AND pv.Area IN (' + @Area + ')' END
	+ CASE WHEN @Provider IS NULL THEN '' ELSE ' AND pv.Provider IN (' + @Provider + ')' END
	+ CASE WHEN @Source IS NULL THEN '' ELSE ' AND pv.Source = ' + Convert(nvarchar(20),@Source) END
	;
SELECT @cd_uvd = CASE WHEN @Model IS NULL THEN ' AND uvd.Model IS NULL' ELSE ' AND uvd.Model IN (' + @Model + ')' END
	+ CASE WHEN @Area IS NULL THEN ' AND uvd.Area IS NULL' ELSE ' AND uvd.Area IN (' + @Area + ')' END
	+ CASE WHEN @Source IS NULL THEN ' AND uvd.Source IS NULL' ELSE ' AND uvd.Source = ' + Convert(nvarchar(20),@Source) END
	;
SELECT @cd_uvdd = CASE WHEN @Model IS NULL THEN ' AND uvdd.Model IS NULL' ELSE ' AND uvdd.Model IN (' + @Model + ')' END
	+ CASE WHEN @Area IS NULL THEN ' AND uvdd.Area IS NULL' ELSE ' AND uvdd.Area IN (' + @Area + ')' END
	+ CASE WHEN @Source IS NULL THEN ' AND uvdd.Source IS NULL' ELSE ' AND uvdd.Source = ' + Convert(nvarchar(20),@Source) END
	;
SELECT @cd_l = REplace(@cd_pv,'pv.','l.');

IF(@AppName IS NULL AND @PlatForm IS NULL AND @Resolution IS NULL AND @Provider IS NULL)
BEGIN
	SELECT @cols_rt = CASE WHEN @Model IS NULL THEN '' ELSE ', Model = ISnull(pv.Model,ISNULL(uvd.Model,uvdd.Model))' END
		+ CASE WHEN @Area IS NULL THEN '' ELSE ', Area = ISnull(pv.Area,ISNULL(uvd.Area,uvdd.Area))' END
		+ CASE WHEN @Source IS NULL THEN '' ELSE ', Source = ISnull(pv.Source,ISNULL(uvd.Source,uvdd.Source))' END;
		
	SELECT @cols_l = CASE WHEN @Model IS NULL THEN '' ELSE ', l.Model' END
		+ CASE WHEN @Area IS NULL THEN '' ELSE ', l.Area' END
		+ CASE WHEN @Source IS NULL THEN '' ELSE ', l.Source' END;
	
	SELECT @jo_uvd = CASE WHEN @Model IS NULL THEN '' ELSE ' AND pv.Model =  uvd.Model' END
		+ CASE WHEN @Area IS NULL THEN '' ELSE ' AND pv.Area =  uvd.Area' END
		+ CASE WHEN @Source IS NULL THEN '' ELSE ' AND pv.Source =  uvd.Source' END;
	
	SELECT @jo_uvdd = CASE WHEN @Model IS NULL THEN '' ELSE ' AND pv.Model =  uvdd.Model' END
		+ CASE WHEN @Area IS NULL THEN '' ELSE ' AND pv.Area =  uvdd.Area' END
		+ CASE WHEN @Source IS NULL THEN '' ELSE ' AND pv.Source =  uvdd.Source' END;
	
	SELECT @sql = '
SELECT PV=ISNULL(pv.PV,0),UV=ISNULL(uvd.UV,0),UVD=ISNULL(uvdd.UV,0), PK_Day=Convert(nvarchar(10),d_h.PK_Hour,120)' + @cols_rt + '
  FROM dbo.DimHour d_h(NOLOCK) LEFT JOIN
	(SELECT PV=ISNULL(Sum(l.PV),0),PK_Day = Convert(nvarchar(10),d_h1.PK_Hour,120)' + @cols_l + '
	   FROM dbo.DimHour d_h1(NOLOCK) LEFT JOIN dbo.PV_M_SG l(NOLOCK) ON d_h1.PK_Hour = l.FK_Hour
	  WHERE d_h1.PK_Hour >= @h_BeginTime AND d_h1.PK_Hour < @h_EndTime
		'+ @cd_l + '
	  GROUP BY Convert(nvarchar(10),d_h1.PK_Hour,120)' + @cols_l + '
	) pv ON d_h.PK_Hour = pv.PK_Day
	LEFT JOIN dbo.UV_Day_SG uvd(NOLOCK) ON d_h.PK_Hour = uvd.FK_Hour' + @jo_uvd + '
	LEFT JOIN dbo.UVD_Day_SG uvdd(NOLOCK) ON d_h.PK_Hour = uvdd.FK_Hour' + @jo_uvdd + '
 WHERE d_h.PK_Hour >= @h_BeginTime AND d_h.PK_Hour < @h_EndTime
	' + @cd_pv + @cd_uvd + @cd_uvdd + '
 ORDER BY d_h.PK_Hour DESC
';
END
ELSE
BEGIN
	SELECT @sql = '
SELECT PV=ISNULL(pv.PV,0),UV=ISNULL(uvd.UV,0),UVD=ISNULL(uvdd.UVD,0), PK_Day=Convert(nvarchar(10),d_h.PK_Hour,120)
  FROM dbo.DimHour d_h(NOLOCK) LEFT JOIN
	(SELECT PV=ISNULL(Sum(l.PV),0),PK_Day=Convert(nvarchar(10),d_h1.PK_Hour,120)
	   FROM dbo.DimHour d_h1(NOLOCK) LEFT JOIN dbo.PV_M_SG l(NOLOCK) ON d_h1.PK_Hour = l.FK_Hour
	  WHERE d_h1.PK_Hour >= @h_BeginTime AND d_h1.PK_Hour < @h_EndTime
		' + @cd_l + '
	  GROUP BY Convert(nvarchar(10),d_h1.PK_Hour,120)
	) pv ON d_h.PK_Hour = pv.PK_Day LEFT JOIN
	(SELECT UV=ISNULL(Count(distinct Imei),0), PK_Day=Convert(nvarchar(10),d_h2.PK_Hour,120)
	   FROM dbo.DimHour d_h2(NOLOCK) LEFT JOIN log.SG l(NOLOCK) ON d_h2.PK_Hour = l.FK_Hour
	  WHERE d_h2.PK_Hour >= @h_BeginTime AND d_h2.PK_Hour < @h_EndTime
		AND l.DownLoadPage = 0 AND l.Source>0 AND LEFT(l.ScStatus,1) IN(2,3)' + @cd_l + '
	  GROUP BY Convert(nvarchar(10),d_h2.PK_Hour,120)
	) uvd ON d_h.PK_Hour = uvd.PK_Day LEFT JOIN
	(SELECT UVD=ISNULL(Count(distinct Imei),0), PK_Day=Convert(nvarchar(10),d_h3.PK_Hour,120)
	   FROM dbo.DimHour d_h3(NOLOCK) LEFT JOIN log.SG l(NOLOCK) ON d_h3.PK_Hour = l.FK_Hour
	  WHERE d_h3.PK_Hour >= @h_BeginTime AND d_h3.PK_Hour < @h_EndTime
		AND l.DownLoadPage > 0 AND l.Source>0 AND LEFT(l.ScStatus,1) IN(2,3)' + @cd_l + '
	  GROUP BY Convert(nvarchar(10),d_h3.PK_Hour,120)
	) uvdd ON d_h.PK_Hour = uvdd.PK_Day
 WHERE d_h.PK_Hour >= @h_BeginTime AND d_h.PK_Hour < @h_EndTime
 ORDER BY d_h.PK_Hour DESC
';
END

PRINT @sql;
EXEC sp_executesql @sql, N'@h_BeginTime datetime, @h_EndTime datetime'
	,@h_BeginTime = @h_BeginTime, @h_EndTime = @h_EndTime;

RETURN 1;
