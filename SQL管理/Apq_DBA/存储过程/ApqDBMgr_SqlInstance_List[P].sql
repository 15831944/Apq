IF ( object_id('dbo.ApqDBMgr_SqlInstance_List','P') IS NULL ) 
    EXEC sp_executesql N'CREATE PROCEDURE dbo.ApqDBMgr_SqlInstance_List AS BEGIN RETURN END' ;
GO
/* =============================================
-- ����: ������
-- ����: 2011-04-01
-- ����: ��ȡSqlʵ���б�
-- ʾ��:
EXEC dbo.ApqDBMgr_SqlInstance_List DEFAULT, 'Apq_Ext', DEFAULT
-- =============================================
*/
ALTER PROC dbo.ApqDBMgr_SqlInstance_List
AS 
SET NOCOUNT ON ;

SELECT ComputerID = ISNULL(i.ComputerID,-1), ComputerName = ISNULL(ComputerName,''), SqlID, SqlName, ParentID, SqlType, IP, SqlPort, UserId, PwdC
  FROM dbo.SqlInstance i LEFT JOIN dbo.Computer c ON i.ComputerID = c.ComputerID;
GO
