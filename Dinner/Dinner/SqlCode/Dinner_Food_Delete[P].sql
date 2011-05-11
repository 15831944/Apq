IF ( object_id('dbo.Dinner_Food_Delete','P') IS NULL ) 
    EXEC sp_executesql N'CREATE PROCEDURE dbo.Dinner_Food_Delete AS BEGIN RETURN END' ;
GO
/* =============================================
-- ����: ������
-- ����: 2011-04-13
-- ����: ��Ʒɾ��
-- ʾ��:
DECLARE @Pager_RowCount bigint
EXEC dbo.Dinner_Food_Delete 0, 5, @Pager_RowCount out
SELECT @Pager_RowCount;
-- =============================================
*/
ALTER PROC dbo.Dinner_Food_Delete
	 @ExMsg nvarchar(max) OUT

	,@FoodID bigint
AS
SET NOCOUNT ON ;

DECLARE @rtn int, @ExMsg1 nvarchar(max);

IF(@FoodID >= 0)
BEGIN
	DELETE dbo.Food WHERE FoodID = @FoodID;
END
ELSE
BEGIN
	SELECT @ExMsg = '��Ʒ����쳣';
	RETURN -1;
END

RETURN 1;
GO
