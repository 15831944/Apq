IF ( OBJECT_ID('dbo.ApqDBMgr_RDB_List') IS NULL ) 
    EXEC sp_executesql N'CREATE FUNCTION dbo.ApqDBMgr_RDB_List() RETURNS TABLE AS RETURN SELECT 1 ID' ;
GO
/* =============================================
-- ����: ������
-- ����: 2010-03-24
-- ����: ��ȡ�������б�
-- ʾ��:
SELECT dbo.ApqDBMgr_RDB_List('FFFF::FFFF', 8);
-- =============================================
*/
ALTER FUNCTION dbo.ApqDBMgr_RDB_List ( )
RETURNS TABLE
    AS RETURN
    SELECT  RDBID,DBName,RDBDesc,RDBType,PLevel,GLevel,SrvID,GameID
    FROM    dbo.RDBConfig
GO
