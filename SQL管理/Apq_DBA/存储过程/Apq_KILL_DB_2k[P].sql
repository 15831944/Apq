IF( OBJECT_ID('dbo.Apq_KILL_DB_2k', 'P') IS NULL )
	EXEC sp_executesql N'CREATE PROCEDURE dbo.Apq_KILL_DB_2k AS BEGIN RETURN END';
GO
/* =============================================
-- ����: ������
-- ����: 2007-09-20
-- ����: �Ͽ�ĳ�û����ݿ����������
-- ʾ��:
EXEC dbo.Apq_KILL_DB_2k N'DBName'
-- =============================================
*/
ALTER PROC dbo.Apq_KILL_DB_2k
	@DBName	nvarchar(256)
AS
SET NOCOUNT ON;

DECLARE	@stmt nvarchar(4000), @pSession cursor;

SET	@pSession = CURSOR FOR
SELECT N'KILL ' + CAST(spid AS nvarchar) FROM master..sysprocesses WHERE dbid = DB_ID(@DBName);

OPEN @pSession;
FETCH NEXT FROM @pSession INTO @stmt;
WHILE( @@FETCH_STATUS = 0 )
BEGIN
	EXEC sp_executesql @stmt;

	FETCH NEXT FROM @pSession INTO @stmt;
END
CLOSE @pSession;
GO
