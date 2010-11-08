﻿IF( OBJECT_ID('dbo.Wb_PV_Get', 'P') IS NULL )
	EXEC sp_executesql N'CREATE PROCEDURE dbo.Wb_PV_Get AS BEGIN RETURN END';
GO
ALTER PROC dbo.Wb_PV_Get
	@ExMsg nvarchar(max) = NULL out
	
	,@Imei nvarchar(50)
	
	,@FirstTime datetime = NULL OUT
	,@FirstLogType int = NULL OUT
	,@FirstSource int = NULL OUT
	,@FirstProvince nvarchar(50) = NULL OUT
	,@LastTime datetime = NULL OUT
	,@LastLogType int = NULL OUT
	,@LastSource int = NULL OUT
	,@LastProvince nvarchar(50) = NULL OUT
	,@VisitCountTotal int = NULL OUT
	,@VisitCountWeek int = NULL OUT
	,@VisitCountDWeek int = NULL OUT
	,@VisitCountMonth int = NULL OUT
	,@VisitCountNMonth int = NULL OUT
AS
/* =============================================
-- 作者: 黄宗银
-- 日期: 2010-11-08
-- 描述: 查询PV
-- 示例:
DECLARE @rtn int,@ExMsg nvarchar(max),@Imei nvarchar(50)
	,@FirstTime datetime,@FirstLogType int,@FirstSource int,@FirstProvince nvarchar(50)
	,@LastTime datetime,@LastLogType int,@LastSource int,@LastProvince nvarchar(50)
	,@VisitCountTotal int,@VisitCountWeek int,@VisitCountDWeek int,@VisitCountMonth int,@VisitCountNMonth int
	;
SELECT @Imei = '019d3110a2145081'
	;

EXEC @rtn = dbo.Wb_PV_Get @ExMsg out, @Imei
	,@FirstTime out, @FirstLogType out, @FirstSource out, @FirstProvince out
	,@LastTime out, @LastLogType out, @LastSource out,@LastProvince out
	,@VisitCountTotal out,@VisitCountWeek out,@VisitCountDWeek out,@VisitCountMonth out,@VisitCountNMonth out
	;
SELECT @rtn;
SELECT @FirstTime,@FirstLogType,@FirstSource,@FirstProvince
	,@LastTime,@LastLogType,@LastSource,@LastProvince
	,@VisitCountTotal,@VisitCountWeek,@VisitCountDWeek,@VisitCountMonth,@VisitCountNMonth
-- =============================================
*/
SET NOCOUNT ON;

SELECT @FirstTime = FirstTime,@FirstLogType=FirstLogType,@FirstSource=FirstSource,@FirstProvince=FirstProvince
	,@LastTime=LastTime,@LastLogType=LastLogType,@LastSource = LastSource,@LastProvince=LastProvince
	
	,@VisitCountTotal=VisitCountTotal,@VisitCountWeek=VisitCountWeek,@VisitCountDWeek=VisitCountDWeek,@VisitCountMonth=VisitCountMonth
	,@VisitCountNMonth=VisitCountNMonth
  FROM dbo.PV_Imei(NOLOCK)
 WHERE Imei = @Imei

RETURN 1;
GO
