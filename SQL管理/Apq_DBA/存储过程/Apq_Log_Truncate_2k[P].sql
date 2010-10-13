IF( OBJECT_ID('dbo.Apq_Log_Truncate_2k', 'P') IS NULL )
	EXEC sp_executesql N'CREATE PROCEDURE dbo.Apq_Log_Truncate_2k AS BEGIN RETURN END';
GO
/* =============================================
-- ����: ������
-- ����: 2008-12-02
-- ����: �ض���־
-- ʾ��:
EXEC DBA_WH.dbo.Apq_Log_Truncate_2k 'FGameAreaDB_Log','dbo','UserLoginTimeLog', 0;
-- =============================================
*/
ALTER PROC dbo.Apq_Log_Truncate_2k
	@DBName			nvarchar(512),	-- ����
	@table_owner	nvarchar(512),	-- ������
	@table_name		nvarchar(512),	-- ����
	@NeedSave		tinyint = 1		-- �Ƿ���Ҫ����
AS
SET NOCOUNT ON;

DECLARE	@cmd nvarchar(4000), @sql nvarchar(4000), @FullTableName nvarchar(640), 
	@FileName nvarchar(256), @RarFileName nvarchar(256), @DirName nvarchar(256), 
	--@Cols nvarchar(4000), @Where1 nvarchar(4000), @Where2 nvarchar(4000), 
	@Now datetime, @rtn int--, @Critical datetime;
SELECT @Now = getdate()
	,@FullTableName = @DBName + '.' + @table_owner + '.' + @table_name
	--,@Cols = ''
	,@DirName = 'D:\'--DBA_WH.dbo.Apq_Ext_Get('',0,'BakFolder')
	;
SELECT @FileName = @DirName + @FullTableName + 
	Replace(
		Replace(
			Replace(Convert(nvarchar(19), @Now, 120), 
				':', ''
			), '-', ''
		), ' ', ''
	);
SELECT @RarFileName = @FileName + N'.rar';
SELECT @FileName = @FileName + N'.txt';

/*
-- ��ȡ���������� -------------------------------------------------------------
CREATE TABLE #sp_columns(
	TABLE_QUALIFIER	nvarchar(256),
	TABLE_OWNER	nvarchar(256),
	TABLE_NAME	nvarchar(256),
	COLUMN_NAME	nvarchar(256),
	DATA_TYPE	smallint,
	[TYPE_NAME]	varchar(256),
	[PRECISION]	int,
	LENGTH	int,
	SCALE	smallint,
	RADIX	smallint,
	NULLABLE	smallint,
	REMARKS	varchar(254),
	COLUMN_DEF	nvarchar(4000),
	SQL_DATA_TYPE	smallint,
	SQL_DATETIME_SUB	smallint,
	CHAR_OCTET_LENGTH	int,
	ORDINAL_POSITION	int,
	IS_NULLABLE	varchar(254),
	SS_DATA_TYPE	tinyint
);

SELECT @sql = N'INSERT #sp_columns(TABLE_QUALIFIER,TABLE_OWNER,TABLE_NAME,COLUMN_NAME,DATA_TYPE,TYPE_NAME,[PRECISION],LENGTH,SCALE,RADIX,NULLABLE,REMARKS,COLUMN_DEF,SQL_DATA_TYPE,SQL_DATETIME_SUB,CHAR_OCTET_LENGTH,ORDINAL_POSITION,IS_NULLABLE,SS_DATA_TYPE)
EXEC ' + @DBName + '..sp_columns @table_owner = ''' + @table_owner + ''',@table_name = ''' + @table_name + ''';
';
EXEC sp_executesql @sql;

DECLARE @csr CURSOR, @col nvarchar(256);
SET @csr = CURSOR FOR
SELECT COLUMN_NAME
  FROM #sp_columns
 WHERE Len(Type_Name) <= 8 OR (Len(Type_Name) > 8 AND SubString(Type_Name, Len(Type_Name)-7,8) <> 'identity');

OPEN @csr;
FETCH NEXT FROM @csr INTO @col;
WHILE(@@FETCH_STATUS = 0)
BEGIN
	SELECT @Cols = @Cols + ',' + @col;

	FETCH NEXT FROM @csr INTO @col;
END

IF(Len(@Cols) < 2)
BEGIN
	RETURN;
END
SELECT @Cols = SubString(@Cols, 2, Len(@Cols)-1);
-- ============================================================================

-- �������� -------------------------------------------------------------------
IF(@FullTableName = N'FGameAreaDB_Log.dbo.GameUserLogin_Log')
BEGIN
	SELECT @Critical = DateAdd(dd, -45, @Now);
	SELECT @Where1 = N'WriteTime < ''' + Convert(nvarchar(23), @Critical, 120) + N''''
		,@Where2 = N'WriteTime >= ''' + Convert(nvarchar(23), @Critical, 120) + N''''
		,@FileName = @DirName + @FullTableName + '\' + 
			Replace(
				Replace(
					Replace(Convert(nvarchar(19), @Critical, 120), 
						':', ''
					), '-', ''
				), ' ', ''
			) + N'.txt'
		;
END

IF(@FullTableName = N'FGameAreaDB_Log.dbo.UserLoginTimeLog')
BEGIN
	SELECT @Critical = DateAdd(dd, -7, @Now);
	SELECT @Where1 = N'EndTime < ''' + Convert(nvarchar(23), @Critical, 120) + N''''
		,@Where2 = N'EndTime >= ''' + Convert(nvarchar(23), @Critical, 120) + N''''
		,@FileName = @DirName + @FullTableName + '\' + 
			Replace(
				Replace(
					Replace(Convert(nvarchar(19), @Critical, 120), 
						':', ''
					), '-', ''
				), ' ', ''
			) + N'.txt'
		;
END

IF(@FullTableName = N'FGameAreaDB_Log.dbo.Log_LoginArea')
BEGIN
	SELECT @Critical = DateAdd(dd, -30, @Now);
	SELECT @Where1 = N'WriteTime < ''' + Convert(nvarchar(23), @Critical, 120) + N''''
		,@Where2 = N'WriteTime >= ''' + Convert(nvarchar(23), @Critical, 120) + N''''
		,@FileName = @DirName + @FullTableName + '\' + 
			Replace(
				Replace(
					Replace(Convert(nvarchar(19), @Critical, 120), 
						':', ''
					), '-', ''
				), ' ', ''
			) + N'.txt'
		;
END

IF(@FullTableName = N'FGameDB_Log.dbo.Log_Product_Trade')
BEGIN
	SELECT @Critical = DateAdd(dd, -45, @Now);
	SELECT @Where1 = N'TransTime < ''' + Convert(nvarchar(23), @Critical, 120) + N''''
		,@Where2 = N'TransTime >= ''' + Convert(nvarchar(23), @Critical, 120) + N''''
		,@FileName = @DirName + @FullTableName + '\' + 
			Replace(
				Replace(
					Replace(Convert(nvarchar(19), @Critical, 120), 
						':', ''
					), '-', ''
				), ' ', ''
			) + N'.txt'
		;
END
-- ============================================================================

-- ����BCPĿ¼
DECLARE @rtn int, @BakFolder nvarchar(3000);
SELECT @BakFolder = DBA_WH.dbo.Apq_Ext_Get('',0,'BakFolder');
IF(Len(@BakFolder)>5)
BEGIN
	SELECT @cmd = N'md ' + SubString(@BakFolder,1,Len(@BakFolder)-1);
	EXEC master..xp_cmdshell @cmd;
END
SELECT @cmd = N'md ' + @DirName + @FullTableName;
EXEC master..xp_cmdshell @cmd;
*/

-- BCP(out & in)
-- ע��:����ʱ�н���������ʹ��Ĭ��ֵ
IF(@NeedSave = 1)
BEGIN
	SELECT @cmd = N'bcp "' + @FullTableName + N'" out "' + @FileName + N'" -c -r~*$ -T';
	EXEC @rtn = master..xp_cmdshell @cmd;
	IF(@@ERROR <> 0 OR @rtn <> 0)
	BEGIN
		RAISERROR('BCP OUT ʱ����',16,1);
		RETURN -1;
	END
END

SELECT @sql = N'TRUNCATE TABLE ' + @FullTableName;
EXEC sp_executesql @sql;

IF(@NeedSave = 1)
BEGIN
	-- ѹ���ļ�
	--DECLARE @RarFolder nvarchar(4000);
	--SELECT @RarFolder = ISNULL(DBA_WH.dbo.Apq_Ext_Get('',0,'RarFolder'),'');
	--IF(Len(@RarFolder) < 2)
	--BEGIN
		--SELECT @RarFolder = 'C:\Program Files\WinRAR';
	--END
	--SELECT @cmd=SubString(@RarFolder,1,2) + '&&cd"' + @RarFolder + '"&&WinRAR a '+ @RarFileName + ' ' + @FileName;	-- -m1/*���*/
	SELECT @cmd='"WinRAR a '+ @RarFileName + ' ' + @FileName;	-- -m1/*���*/
	EXEC @rtn = master..xp_cmdshell @cmd;
	IF(@@ERROR <> 0 OR @rtn <> 0)
	BEGIN
		RAISERROR('ѹ��ʱ����',16,2);
		RETURN -1;
	END

	-- ��������Ŀ¼
	SELECT @cmd='move "'+ @RarFileName +'" "'+DBA_WH.dbo.Apq_Ext_Get('',0,'BakFolder') + '"';
	IF(Len(@cmd)>5)
	BEGIN
		EXEC @rtn = master..xp_cmdshell @cmd;
		IF(@@ERROR <> 0 OR @rtn <> 0)
		BEGIN
			RAISERROR('�ƶ�ʱ����',16,3);
			RETURN -1;
		END
	END

	-- ɾ��BCP�ļ�
	SELECT @cmd = N'del "' + @FileName + '" /q';
	EXEC master..xp_cmdshell @cmd;
END
GO
