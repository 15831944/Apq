IF ( OBJECT_ID('dbo.Apq_WH','P') IS NULL ) 
    EXEC sp_executesql N'CREATE PROCEDURE dbo.Apq_WH AS BEGIN RETURN END' ;
GO
/* =============================================
-- ����: ������
-- ����: 2010-04-13
-- ����: ά����ҵ:1.Ĭ��ֵ������,2.��������(�����Ƭ�ʵ���30����INDEXDEFRAG���������30����DBREINDEX)
-- ʾ��:
EXEC dbo.Apq_WH
-- =============================================
*/
ALTER PROC dbo.Apq_WH
AS
SET NOCOUNT ON ;

DECLARE @sql nvarchar(max),@DBName nvarchar(128)
DECLARE @csr CURSOR
SET @csr = CURSOR STATIC FOR
SELECT DBName
  FROM dbo.Cfg_WH
 WHERE Enabled = 1

OPEN @csr
FETCH NEXT FROM @csr INTO @DBName
WHILE(@@FETCH_STATUS = 0)
BEGIN
	SELECT @sql = 'EXEC [' + @DBName + ']..Apq_RenameDefault';
	EXEC sp_executesql @sql;
	SELECT @sql = 'EXEC [' + @DBName + ']..Apq_RebuildIdx';
	EXEC sp_executesql @sql;
	SELECT @sql = 'EXEC [' + @DBName + ']..sp_updatestats';
	EXEC sp_executesql @sql;
	
	FETCH NEXT FROM @csr INTO @DBName
END
CLOSE @csr
GO
