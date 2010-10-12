IF ( OBJECT_ID('dbo.ApqDBMgr_RSrv_List') IS NULL ) 
    EXEC sp_executesql N'CREATE FUNCTION dbo.ApqDBMgr_RSrv_List() RETURNS TABLE AS RETURN SELECT 1 ID' ;
GO
/* =============================================
-- ����: ������
-- ����: 2010-03-24
-- ����: ��ȡ�������б�
-- ʾ��:
SELECT * FROM dbo.ApqDBMgr_RSrv_List();
-- =============================================
*/
ALTER FUNCTION dbo.ApqDBMgr_RSrv_List ( )
RETURNS TABLE
    AS RETURN
    SELECT  ID, ParentID, Name, UID, PwdC, Type, LSMaxTimes, LSErrTimes, LSState, IPLan, IPWan1, IPWan2, FTPPort, FTPU, FTPPC, SqlPort
    FROM    dbo.RSrvConfig
GO
