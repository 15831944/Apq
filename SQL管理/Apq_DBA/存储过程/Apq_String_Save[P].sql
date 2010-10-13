IF( OBJECT_ID('dbo.Apq_String_Save', 'P') IS NULL )
	EXEC sp_executesql N'CREATE PROCEDURE dbo.Apq_String_Save AS BEGIN RETURN END';
GO
/* =============================================
-- 作者: 黄宗银
-- 日期: 2009-02-05
-- 描述: 保存 字符串
	@ID 可指定,指定时不请求新ID
-- 示例:
DECLARE @rtn int, @ExMsg nvarchar(MAX), @str nvarchar(MAX), @ID bigint;
--SELECT @ID = 4;
SELECT @str = 'Apq_Bak_Apq';
EXEC @rtn = dbo.Apq_String_Save @ExMsg out, 'zh-cn', @str, @ID out;
SELECT @ID;
-- =============================================
*/
ALTER PROC dbo.Apq_String_Save
	 @ExMsg nvarchar(MAX) = '' out

	,@lang	nvarchar(10) = 'zh-cn'
	,@str	nvarchar(MAX)

	,@ID	bigint out
AS
SET NOCOUNT ON;

DECLARE	@rtn int;

IF(@ID IS NULL OR @ID = 0)
BEGIN
	EXEC @rtn = dbo.Apq_Identifier @ExMsg out, N'Apq_String', 1, @ID out;
	IF(@@ERROR <> 0 OR @rtn <> 1)
	BEGIN
		RETURN -1;
	END
END

UPDATE Apq_String SET str = @str, _Time = getdate() WHERE ID = @ID AND lang = @lang;
IF(@@ROWCOUNT = 0)
BEGIN
	INSERT Apq_String(ID, lang, str) VALUES(@ID, @lang, @str);
END

RETURN 1;
GO
