IF ( object_id('dbo.Dinner_Food_List','P') IS NULL ) 
    EXEC sp_executesql N'CREATE PROCEDURE dbo.Dinner_Food_List AS BEGIN RETURN END' ;
GO
/* =============================================
-- ����: ������
-- ����: 2011-04-13
-- ����: ��Ʒ�б�
-- ʾ��:
DECLARE @Pager_RowCount bigint
EXEC dbo.Dinner_Food_List 0, 5, @Pager_RowCount out
SELECT @Pager_RowCount;
-- =============================================
*/
ALTER PROC dbo.Dinner_Food_List
	@RestID	bigint
AS
SET NOCOUNT ON ;

SELECT FoodID, RestID, FoodName, FoodPrice
  FROM dbo.Food
 WHERE RestID = @RestID;

RETURN 1;
GO
