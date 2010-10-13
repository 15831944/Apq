IF( OBJECT_ID('dbo.Apq_ID_Reset', 'P') IS NULL )
	EXEC sp_executesql N'CREATE PROCEDURE dbo.Apq_ID_Reset AS BEGIN RETURN END';
GO
ALTER PROC dbo.Apq_ID_Reset
	@Name	nvarchar(256)
AS
SET NOCOUNT ON;
/* =============================================
-- 作者: 黄宗银
-- 日期: 2009-05-25
-- 描述: 操作 Apq_ID,将指定 Name 的正常行的当前值重置为初始值
-- 示例:
INSERT Apq_ID(Name, Init, Limit, Inc) VALUES('GameUser', 40000000, 60000000, 1);
DECLARE	@rtn int;
EXEC @rtn = dbo.Apq_ID_Reset 'GameUser';
SELECT	@rtn;
-- =============================================
*/

UPDATE Apq_ID
   SET Crt = Init
 WHERE State = 0
	AND (@Name = '' OR Name = @Name);
GO
EXEC dbo.Apq_Def_EveryDB 'dbo', 'Apq_ID_Reset', DEFAULT
GO
