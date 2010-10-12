IF ( OBJECT_ID('dbo.ApqDBMgr_RDBUser_List') IS NULL ) 
    EXEC sp_executesql N'CREATE FUNCTION dbo.ApqDBMgr_RDBUser_List() RETURNS TABLE AS RETURN SELECT 1 ID' ;
GO
/* =============================================
-- ����: ������
-- ����: 2010-03-24
-- ����: ��ȡ�������б�
-- ʾ��:
SELECT dbo.ApqDBMgr_RDBUser_List('FFFF::FFFF', 8);
-- =============================================
*/
ALTER FUNCTION dbo.ApqDBMgr_RDBUser_List ( )
RETURNS TABLE
    AS RETURN
    SELECT  [RDBUserID],RDBID,DBUserName,DBUserDesc,RDBLoginID
    FROM    dbo.RDBUser
GO
