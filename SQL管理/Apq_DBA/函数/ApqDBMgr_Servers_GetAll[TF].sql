IF ( OBJECT_ID('dbo.ApqDBMgr_Servers_GetAll') IS NULL ) 
    EXEC sp_executesql N'CREATE FUNCTION dbo.ApqDBMgr_Servers_GetAll() RETURNS TABLE AS RETURN SELECT 1 ID' ;
GO
/* =============================================
-- ����: ������
-- ����: 2010-03-24
-- ����: ��ȡ�������б�
-- ʾ��:
SELECT * FROM dbo.ApqDBMgr_Servers_GetAll();
-- =============================================
*/
ALTER FUNCTION dbo.ApqDBMgr_Servers_GetAll ( )
RETURNS TABLE
    AS RETURN
    SELECT  *
    FROM    dbo.RSrvConfig
GO
