
IF(OBJECT_ID('dbo.Apq_Tree_City_List', 'IF') IS NULL)
	EXEC sp_executesql N'CREATE FUNCTION dbo.Apq_Tree_City_List()RETURNS TABLE AS RETURN SELECT ID=1;';
GO
/* =============================================
-- 作者: 黄宗银
-- 日期: 2008-11-19
-- 描述: 列表城市
-- 条件: 城市名及上级名
-- 示例:
DECLARE @rtn int, @ExMsg nvarchar(MAX);
EXEC @rtn = dbo.Apq_Tree_City_List @ExMsg out, '诸城', '山东';
SELECT @rtn, @ExMsg;
-- =============================================
*/
ALTER FUNCTION dbo.Apq_Tree_City_List(
	 @CityName		nvarchar(450)
	,@ParentName	nvarchar(450)
)RETURNS TABLE
AS
RETURN SELECT * FROM Apq_Tree_City
 WHERE Name = @CityName
	AND (@ParentName IS NULL
		OR (ParentID IN (SELECT ID FROM Apq_Tree_City WHERE Name = @ParentName))
		);
GO
