IF( OBJECT_ID('dbo.Apq_String_GetString', 'P') IS NULL )
	EXEC sp_executesql N'CREATE PROCEDURE dbo.Apq_String_GetString AS BEGIN RETURN END';
GO
/* =============================================
-- 作者: 黄宗银
-- 日期: 2009-02-05
-- 描述: 添加/获取 字符串
-- 示例:
DECLARE @rtn int, @ExMsg nvarchar(MAX), @str nvarchar(MAX);
SELECT @str = 'D:\Bak\';
EXEC @rtn = dbo.Apq_String_GetString @ExMsg out, 'zh-cn', 1, @str out;
SELECT @str;
-- =============================================
*/
ALTER PROC dbo.Apq_String_GetString
	 @ExMsg nvarchar(MAX) = '' out

	,@lang	nvarchar(10) = 'zh-cn'
	,@ID	bigint

	,@str	nvarchar(MAX) out
AS
SET NOCOUNT ON;

SELECT @str = str FROM Apq_String WHERE lang = @lang AND ID = @ID;
IF (@@ROWCOUNT = 0)
BEGIN
	INSERT INTO Apq_String(ID, lang, str)
	VALUES(@ID, @lang, @str);
END

RETURN 1;
GO
