IF( OBJECT_ID('bak.Job_Apq_Bak_R1', 'P') IS NULL )
	EXEC sp_executesql N'CREATE PROCEDURE bak.Job_Apq_Bak_R1 AS BEGIN RETURN END';
GO
ALTER PROC bak.Job_Apq_Bak_R1
AS
/* =============================================
-- 作者: 黄宗银
-- 日期: 2010-12-30
-- 描述: 备份作业(队列处理)
-- 参数:
@JobTime: 作业启动时间
@DBName: 数据库名
@BakFolder: 备份目录
@FTPFolder: FTP目录
-- 示例:
DECLARE @rtn int;
EXEC @rtn = bak.Job_Apq_Bak_R1;
SELECT @rtn;
-- =============================================
*/
SET NOCOUNT ON;

--定义变量
DECLARE @_RowCount bigint,
	@ID bigint,
	@DBName nvarchar(256),	-- 数据库名
	@BakFolder nvarchar(4000),--备份目录
	@FTPFolder nvarchar(4000),--FTP目录
	@BakType tinyint,
	
	@rtn int
	,@JobTime datetime	-- 作业启动时间
	;
SELECT @JobTime=Convert(nvarchar(16),GetDate(),120) + ':00'	--只精确到分

--定义游标
DECLARE @csr CURSOR;
SET @csr=CURSOR FOR
SELECT ID,DBName,BakFolder,FTPFolder,BakType
  FROM bak.BakQueue
 WHERE Enabled = 1 AND IsSuccess = 0;

-- 接收cmd返回结果
CREATE TABLE #t(s nvarchar(4000));

OPEN @csr;
WHILE(1=1)
BEGIN
	FETCH NEXT FROM @csr INTO @ID,@DBName,@BakFolder,@FTPFolder,@BakType;
	IF(@@FETCH_STATUS<>0) BREAK;
	
	IF((@BakType & 3) <> 0)
	BEGIN
		-- 记录启动日志
		INSERT log.Bak(DBName,BakFolder,FTPFolder,BakTime,BakType)
		VALUES(@DBName,@BakFolder,@FTPFolder,@JobTime,@BakType);
		
		EXEC @rtn = bak.Apq_Bak_R1 @ID, @JobTime;
	END
END
CLOSE @csr;

DROP TABLE #t;
RETURN 1;
GO
