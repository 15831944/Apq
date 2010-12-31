IF( OBJECT_ID('dbo.Apq_ShrinkLog', 'P') IS NULL )
	EXEC sp_executesql N'CREATE PROCEDURE dbo.Apq_ShrinkLog AS BEGIN RETURN END';
GO
ALTER PROC dbo.Apq_ShrinkLog
	@DBName			nvarchar(256),
	@NeedTruncate	tinyint = 0
AS
/* =============================================
-- 作者: 黄宗银
-- 日期: 2010-12-31
-- 描述: 收缩数据库日志文件
-- 示例:
DECLARE @rtn int;
EXEC @rtn = dbo.Apq_ShrinkLog 'AdventureWorks';
SELECT @rtn;
-- =============================================
*/
SET NOCOUNT ON;

SELECT @NeedTruncate = ISNULL(@NeedTruncate,0);

DECLARE @rtn int, @SPBeginTime datetime
	,@cmd nvarchar(4000), @sql nvarchar(4000), @sqlDB nvarchar(4000)
	,@BakType tinyint
	,@BakFolder nvarchar(4000)
	,@FTPFolder nvarchar(4000)
	,@NeedRestore tinyint
	,@RestoreFolder nvarchar(4000)
	,@DB_HisNum int
	,@Num_Full int		-- 完整备份文件保留个数
	
	,@FullFileToDel nvarchar(4000)	--在此文件之前的文件将被删除
	,@BakFileName nvarchar(256)
	,@BakFileFullName nvarchar(4000)
	,@FTPFileFullName nvarchar(4000)
	,@Num_HisDB int	-- 临时变量:已有历史库个数
	,@ProductVersion	decimal
	;
	
SELECT @ProductVersion = CONVERT(decimal,LEFT(Convert(nvarchar,SERVERPROPERTY('ProductVersion')),2));
IF(@ProductVersion<10 AND @NeedTruncate = 1)
BEGIN
	SELECT @sql='BACKUP LOG '+@DBName+' WITH NO_LOG';
	EXEC sp_executesql @sql;
END

SELECT @sql = '
SELECT @sqlDB = '''';
SELECT @sqlDB = @sqlDB + ''
DBCC SHRINKFILE('''''' + name + '''''',10);''
  FROM [' + @DBName + '].sys.database_files
 WHERE type = 1;';
EXEC sp_executesql @sql,N'@sqlDB nvarchar(4000) out',@sqlDB=@sqlDB out;

SELECT @sql = 'EXEC [' + @DBName + ']..sp_executesql @sqlDB';
EXEC sp_executesql @sql,N'@sqlDB nvarchar(4000)',@sqlDB=@sqlDB;
RETURN 1;
GO
