IF ( object_id('dbo.ApqDBMgr_Computer_List','P') IS NULL ) 
    EXEC sp_executesql N'CREATE PROCEDURE dbo.ApqDBMgr_Computer_List AS BEGIN RETURN END' ;
GO
/* =============================================
-- ����: ������
-- ����: 2011-04-01
-- ����: ��ȡSqlʵ���б�
-- ʾ��:
EXEC dbo.ApqDBMgr_Computer_List DEFAULT, 'Apq_Ext', DEFAULT
-- =============================================
*/
ALTER PROC dbo.ApqDBMgr_Computer_List
AS 
SET NOCOUNT ON ;

SELECT ComputerID, ComputerName, ComputerType
  FROM dbo.Computer
GO
