IF( OBJECT_ID('bak.Job_Apq_Bak', 'P') IS NULL )
	EXEC sp_executesql N'CREATE PROCEDURE bak.Job_Apq_Bak AS BEGIN RETURN END';
GO
ALTER PROC bak.Job_Apq_Bak
AS
/* =============================================
-- 作者: 黄宗银
-- 日期: 2010-04-17
-- 描述: 备份作业(仅本地)
-- 参数:
@JobTime: 作业启动时间
@DBName: 数据库名
@BakFolder: 备份目录
@FTPFolder: FTP目录
-- 示例:
DECLARE @rtn int;
EXEC @rtn = bak.Job_Apq_Bak;
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
	@ReadyAction tinyint	-- 备份操作
	
	,@rtn int
	,@JobTime datetime	-- 作业启动时间
	;
SELECT @JobTime=Convert(nvarchar(16),GetDate(),120) + ':00'	--只精确到分

--定义游标
DECLARE @csr CURSOR;
SET @csr=CURSOR STATIC FOR
SELECT ID,DBName,BakFolder+CASE RIGHT(BakFolder,1) WHEN '\' THEN '' ELSE '\' END,FTPFolder+CASE RIGHT(FTPFolder,1) WHEN '\' THEN '' ELSE '\' END
	,ReadyAction
  FROM bak.BakCfg
 WHERE ID > 0 AND Enabled = 1 AND ReadyAction > 0;

-- 接收cmd返回结果
CREATE TABLE #t(s nvarchar(4000));

OPEN @csr;
FETCH NEXT FROM @csr INTO @ID,@DBName,@BakFolder,@FTPFolder,@ReadyAction;
WHILE(@@FETCH_STATUS=0)
BEGIN
	-- 计算当天完整备份的时间
	IF((@ReadyAction & 3) <> 0)
	BEGIN
		INSERT log.Bak(DBName,BakFolder,FTPFolder,BakTime,BakType)
		VALUES(@DBName,@BakFolder,@FTPFolder,@JobTime,@ReadyAction);
		
		EXEC @rtn = bak.Apq_Bak @DBName = @DBName,@BakType = @ReadyAction,@JobTime = @JobTime;
	END

	NEXT_DB:
	FETCH NEXT FROM @csr INTO @ID,@DBName,@BakFolder,@FTPFolder,@ReadyAction;
END
CLOSE @csr;

DROP TABLE #t;
RETURN 1;
GO
