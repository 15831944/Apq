IF ( object_id('dbo.ApqDBMgr_DBC_Delete','P') IS NULL ) 
    EXEC sp_executesql N'CREATE PROCEDURE dbo.ApqDBMgr_DBC_Delete AS BEGIN RETURN END' ;
GO
/* =============================================
-- ����: ������
-- ����: 2011-04-01
-- ����: ɾ�����ݿ�
-- ʾ��:
EXEC dbo.ApqDBMgr_DBC_Delete 1
	,-1,-1,'��������',0,-1,'172.16.0.20',1433,'apq', 'f'
-- =============================================
*/
ALTER PROC dbo.ApqDBMgr_DBC_Delete
	@DBID			int
AS
SET NOCOUNT ON ;

DELETE dbo.DBC WHERE [DBID] = @DBID;
GO
