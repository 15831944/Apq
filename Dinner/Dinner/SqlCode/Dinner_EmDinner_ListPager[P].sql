IF ( object_id('dbo.Dinner_EmDinner_ListPager','P') IS NULL ) 
    EXEC sp_executesql N'CREATE PROCEDURE dbo.Dinner_EmDinner_ListPager AS BEGIN RETURN END' ;
GO
/* =============================================
-- ����: ������
-- ����: 2011-04-16
-- ����: �����ʷ
-- ʾ��:
DECLARE @Pager_RowCount bigint
EXEC dbo.Dinner_EmDinner_ListPager 1, 15, @Pager_RowCount out, 1
SELECT @Pager_RowCount;
-- =============================================
*/
ALTER PROC dbo.Dinner_EmDinner_ListPager
    @Pager_Page		int = 0				-- ҳ��(��0��ʼ)
   ,@Pager_PageSize	int = 20			-- ÿҳ����
   ,@Pager_RowCount	bigint OUT			-- ���������
   
   ,@EmID	bigint
AS
SET NOCOUNT ON ;

DECLARE @nTop0 int;
SELECT @nTop0 = @Pager_PageSize * @Pager_Page;

SELECT @Pager_RowCount = Count(1) FROM dbo.EmDinner e WHERE EmID = @EmID;

SELECT TOP(@Pager_PageSize) ID, DinnerTime, EmID, FoodID, FoodPrice, FoodName, RestID, RestName,State
  FROM dbo.EmDinner l
 WHERE NOT EXISTS(SELECT TOP 1 1 FROM (SELECT TOP(@nTop0) ID FROM dbo.EmDinner l0(NOLOCK) WHERE EmID = @EmID ORDER BY l0.ID DESC) Apq_Pager0 WHERE Apq_Pager0.ID = l.ID)
	AND EmID = @EmID
 ORDER BY l.ID DESC;

RETURN 1;
GO
