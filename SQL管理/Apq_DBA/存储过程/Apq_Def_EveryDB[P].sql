IF ( object_id('dbo.Apq_Def_EveryDB','P') IS NULL ) 
    EXEC sp_executesql N'CREATE PROCEDURE dbo.Apq_Def_EveryDB AS BEGIN RETURN END' ;
GO
/* =============================================
-- ����: ������
-- ����: 2010-06-01
-- ����: �������嵽�������ݿ�
-- ����: 
	1.�洢����	ɾ�����ؽ�
	2.����		ɾ�����ؽ�
	3.��		ɾ�����ؽ�,����ԭ����
-- ʾ��:
EXEC dbo.Apq_Def_EveryDB DEFAULT, 'Apq_Ext', DEFAULT
-- =============================================
*/
ALTER PROC dbo.Apq_Def_EveryDB
    @SchemaName sysname = 'dbo'
   ,@objName sysname
   ,@ToMsDB tinyint = 0
AS 
SET NOCOUNT ON ;

DECLARE @ExMsg nvarchar(max);
IF(@SchemaName IS NULL) SELECT @SchemaName = 'dbo';
IF(@ToMsDB IS NULL) SELECT @ToMsDB = 0;

DECLARE @objID int, @FullName nvarchar(512);
SELECT @FullName = '[' + @SchemaName + '].[' + @objName + ']';
SELECT @objID = object_id(@FullName);
IF(@objName IS NULL OR @objID IS NULL) RETURN;

DECLARE @sql nvarchar(max),@sqlDB nvarchar(max)
	,@sqlDetect nvarchar(max)	-- ���Ŀ����Ƿ����
	,@sqlDrop nvarchar(max)		-- ɾ��Ŀ����Ѵ��ڵĶ���(���������ݵ���ʱ��)
	,@sqlDef nvarchar(max)		-- ������[1.�洢����,2.����]
	,@sqlGrant nvarchar(max)	-- Ŀ�����Ȩ
	
	-- 3.��
	,@sqlDef_Table nvarchar(max)-- ����
	,@sqlDef_TCols nvarchar(max)-- �ж���
	,@sql_Cols nvarchar(max)	-- ��Դ��Ŀ������е�����
	,@sql_SI nvarchar(max)		-- ����ԭ����
	,@sqlDef_Index nvarchar(max)-- ��������
	,@sqlDrop_Index nvarchar(max)-- [ʵ�ʲ���ʹ��]����ɾ�����
	,@sqlDef_PX nvarchar(max)	-- ��չ�������
	;

-- �ֵ���� ------------------------------------------------------------------------------
DECLARE @DicFTX TABLE(
	[XName] [sysname],
	[value] nvarchar(max),
	def_exec nvarchar(max)
);
DECLARE @DicFC TABLE(
	[column_id] [int] NOT NULL,
	[name] [sysname],
	user_type_id int NOT NULL,
	[max_length] nvarchar(10) NOT NULL,
	[precision] nvarchar(10) NOT NULL,
	[scale] nvarchar(10) NOT NULL,
	[is_nullable] tinyint,
	[is_identity] tinyint NOT NULL,
	[is_computed] tinyint NOT NULL,
	[typename] [sysname] NOT NULL,
	def_default nvarchar(max),
	def nvarchar(max)
);
DECLARE @DicFCX TABLE(
	[column_id] [int] NOT NULL,
	[XName] [sysname],
	[value] nvarchar(max),
	def_exec nvarchar(max)
);
DECLARE @DicTC TABLE(
	[column_id] [int] NOT NULL,
	[name] [sysname]
);
-- =========================================================================================

-- 1/2.�洢����/����
IF((OBJECTPROPERTY(@objID,'IsProcedure') = 1 AND OBJECTPROPERTY(@objID,'IsExtendedProc') = 0 AND OBJECTPROPERTY(@objID,'IsReplProc') = 0)
	OR (OBJECTPROPERTY(@objID,'IsInlineFunction') = 1 OR OBJECTPROPERTY(@objID,'IsScalarFunction') = 1 OR OBJECTPROPERTY(@objID,'IsTableFunction') = 1)
)
BEGIN
	SELECT @sqlDef = OBJECT_DEFINITION(@objID);
	IF(@sqlDef IS NULL) RETURN;
END

-- 3.��
ELSE IF(OBJECTPROPERTY(@objID,'IsUserTable') = 1)
BEGIN
	/*
	������:�ؽ���,��������,�ؽ�����(��)
	����:{
		˵��: ���/�޸�
	}
	type:{
		1: ��
		2: ����(��)
	}
	op:{
		1: ���
		2: �޸�
		3: ɾ��
	}
	*/
	
	-- ��Դ���ֵ佨�� --------------------------------------------------------------------------
	INSERT @DicFTX ( XName,value )
	SELECT name,CONVERT(nvarchar(max),value)
	  FROM sys.fn_listextendedproperty(DEFAULT,'SCHEMA', @SchemaName, 'TABLE', @objName, DEFAULT, DEFAULT);
	
	INSERT @DicFC ( column_id,name,user_type_id,max_length,precision,scale,is_nullable,is_identity,is_computed,typename,def_default )
	SELECT c.column_id,c.name,c.user_type_id,c.max_length,c.precision,c.scale,c.is_nullable,is_identity,is_computed,typename=t.name,d.definition
	  FROM sys.columns c
		INNER JOIN sys.objects o ON c.object_id = o.object_id
		INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
		LEFT JOIN sys.default_constraints d ON d.parent_object_id = o.object_id AND d.parent_column_id = c.column_id
	 WHERE o.object_id = object_id(@FullName);
	
	INSERT @DicFCX ( column_id,XName,value )
	SELECT c.column_id,XName=cx.name,CONVERT(nvarchar(max),value)
	  FROM sys.columns c CROSS APPLY sys.fn_listextendedproperty(DEFAULT,'SCHEMA', @SchemaName, 'TABLE', @objName, 'COLUMN', c.name) cx
	 WHERE c.object_id = object_id(@FullName)
	-- =========================================================================================
	
	-- �����ж������ --------------------------------------------------------------------------
	UPDATE @DicFC
	   SET def = '[' + name + '] [' + typename + ']' + CASE
			WHEN user_type_id BETWEEN 34 AND 61 THEN ''
			WHEN user_type_id IN(98,99,104,122,127,189,241,256) THEN ''
			ELSE '(' + CASE
					WHEN user_type_id = 62 THEN '53'	-- �̶�:float(53)
					WHEN user_type_id IN(106,108) THEN precision + ',' + scale
					WHEN max_length = -1 THEN 'max'
					WHEN user_type_id IN(231,239) THEN Convert(nvarchar(max),max_length / 2)
					ELSE max_length
				END
			+ ')'
		END + CASE is_identity WHEN 1 THEN ' IDENTITY' ELSE	-- �̶�:IDENTITY(1,1)
			CASE is_nullable WHEN 1 THEN '' ELSE ' NOT NULL' END
			+ CASE WHEN def_default IS NULL THEN '' ELSE ' DEFAULT' + def_default END
		END
	 WHERE is_computed = 0;
	 
	IF (EXISTS(SELECT TOP 1 1 FROM @DicFC WHERE def IS NULL)) RETURN;
	
	SELECT @sqlDef_TCols = '';
	SELECT @sqlDef_TCols = @sqlDef_TCols + def + ','
	  FROM @DicFC
	SELECT @sqlDef_TCols = Left(@sqlDef_TCols,Len(@sqlDef_TCols)-1);
	-- �������
	SELECT @sqlDef_Table = 'CREATE TABLE ' + @FullName + '(' + @sqlDef_TCols + ');';
	-- ������չ����
	UPDATE @DicFTX
	   SET def_exec = 'EXEC sp_addextendedproperty @name = N''' + XName + ''', @value = ''' + value + ''',
@level0type = N''SCHEMA'', @level0name = '''+ @SchemaName + ''',
@level1type = N''TABLE'',  @level1name = '''+ @objName + ''';
';
	UPDATE cx
	   SET cx.def_exec = 'EXEC sp_addextendedproperty @name = N''' + XName + ''', @value = ''' + value + ''',
@level0type = N''SCHEMA'', @level0name = '''+ @SchemaName + ''',
@level1type = N''TABLE'',  @level1name = '''+ @objName + ''',
@level2type = N''COLUMN'', @level2name = '''+ c.name + ''';
'
	  FROM @DicFCX cx INNER JOIN @DicFC c ON cx.column_id = c.column_id;
	SELECT @sqlDef_Table = @sqlDef_Table + def_exec
	  FROM @DicFTX;
	SELECT @sqlDef_Table = @sqlDef_Table + def_exec
	  FROM @DicFCX;
	
	EXEC dbo.Apq_DropIndex @ExMsg = @ExMsg out,
		@Schema_Name = @SchemaName,
		@Table_Name = @objName,
		@sql_Create = @sqlDef_Index out,
		@sql_Drop = @sqlDrop_Index out,
		@DoDrop = 0
	    
	--PRINT @sqlDef_Table; RETURN;
	-- =========================================================================================
END
ELSE RETURN;

DECLARE @DBName sysname, @DB_objID int;
DECLARE @csr CURSOR
SET @csr = CURSOR STATIC FOR
SELECT name
  FROM master.sys.databases
 WHERE name = 'model'
	OR (is_read_only = 0
		--AND database_id = db_id('Agiltron')	-- ֻ������Կ�
		AND database_id <> db_id() AND database_id <> db_id('tempdb') AND is_read_only = 0 AND state = 0
		AND (@ToMsDB <> 0 OR database_id > 4)
	);
	
OPEN @csr;
FETCH NEXT FROM @csr INTO @DBName;
WHILE(@@FETCH_STATUS = 0)
BEGIN
	-- 1.�洢����
	IF(OBJECTPROPERTY(@objID,'IsProcedure') = 1 AND OBJECTPROPERTY(@objID,'IsExtendedProc') = 0 AND OBJECTPROPERTY(@objID,'IsReplProc') = 0)
	BEGIN
		SELECT @sqlDef = OBJECT_DEFINITION(@objID);
		IF(@sqlDef IS NULL) BREAK;
		SELECT @DB_objID = NULL,@sqlGrant = '';
		SELECT @sqlDetect = 'SELECT @DB_objID = object_id(@FullName)';
		SELECT @sqlDB = 'EXEC [' + @DBName + ']..sp_executesql @sqlDetect, N''@DB_objID int out,@FullName nvarchar(512)'',@DB_objID = @DB_objID out,@FullName = @FullName';
		EXEC sp_executesql @sqlDB,N'@sqlDetect nvarchar(max),@DB_objID int out,@FullName nvarchar(512)',@sqlDetect = @sqlDetect, @DB_objID = @DB_objID OUT,@FullName = @FullName
		IF(@DB_objID IS NOT NULL)
		BEGIN
			-- ������Ȩ���
			SELECT @sqlDetect = '
SELECT @sqlGrant = @sqlGrant + ''
GRANT EXEC ON '+ @FullName + ' TO ['' + user_name(grantee_principal_id) + '']'' + CASE state WHEN ''W'' THEN '' WITH GRANT OPTION'' ELSE '''' END
  FROM sys.database_permissions
 WHERE type = ''EX'' AND permission_name = ''EXECUTE'' AND state IN (''G'',''W'') AND major_id = object_id(@FullName)';
			SELECT @sqlDB = 'EXEC [' + @DBName + ']..sp_executesql @sqlDetect, N''@sqlDetect nvarchar(max),@sqlGrant nvarchar(max) out, @FullName nvarchar(512)''
				,@sqlDetect = @sqlDetect,@sqlGrant = @sqlGrant out,@FullName = @FullName';
			EXEC sp_executesql @sqlDB,N'@sqlDetect nvarchar(max),@sqlGrant nvarchar(max) out,@FullName nvarchar(512)',@sqlDetect = @sqlDetect,@sqlGrant = @sqlGrant OUT,@FullName = @FullName

			SELECT @sqlDrop = 'DROP PROC ' + @FullName;
			SELECT @sqlDB = 'EXEC [' + @DBName + ']..sp_executesql @sqlDrop';
			EXEC sp_executesql @sqlDB,N'@sqlDrop nvarchar(max)',@sqlDrop = @sqlDrop
		END

		SELECT @sqlDB = 'EXEC [' + @DBName + ']..sp_executesql @sqlDef';
		EXEC sp_executesql @sqlDB,N'@sqlDef nvarchar(max)',@sqlDef = @sqlDef

		-- ��Ȩ
		IF(Len(@sqlGrant)>1)
		BEGIN
			SELECT @sqlDB = 'EXEC [' + @DBName + ']..sp_executesql @sqlGrant';
			EXEC sp_executesql @sqlDB,N'@sqlGrant nvarchar(max)',@sqlGrant = @sqlGrant
		END
	END
	
	-- 2.����
	IF(OBJECTPROPERTY(@objID,'IsInlineFunction') = 1 OR OBJECTPROPERTY(@objID,'IsScalarFunction') = 1 OR OBJECTPROPERTY(@objID,'IsTableFunction') = 1)
	BEGIN
		SELECT @sqlDef = OBJECT_DEFINITION(@objID);
		IF(@sqlDef IS NULL) BREAK;
		SELECT @DB_objID = NULL,@sqlGrant = '';
		SELECT @sqlDetect = 'SELECT @DB_objID = object_id(@FullName)';
		SELECT @sqlDB = 'EXEC [' + @DBName + ']..sp_executesql @sqlDetect, N''@DB_objID int out,@FullName nvarchar(512)'',@DB_objID = @DB_objID out,@FullName = @FullName';
		EXEC sp_executesql @sqlDB,N'@sqlDetect nvarchar(max),@DB_objID int out,@FullName nvarchar(512)',@sqlDetect = @sqlDetect, @DB_objID = @DB_objID OUT,@FullName = @FullName
		IF(@DB_objID IS NOT NULL)
		BEGIN
			-- ������Ȩ���
			SELECT @sqlDetect = '
SELECT @sqlGrant = @sqlGrant + ''
GRANT EXEC ON '+ @FullName + ' TO ['' + user_name(grantee_principal_id) + '']'' + CASE state WHEN ''W'' THEN '' WITH GRANT OPTION'' ELSE '''' END
  FROM sys.database_permissions
 WHERE type = ''EX'' AND permission_name = ''EXECUTE'' AND state IN (''G'',''W'') AND major_id = object_id(@FullName)';
			SELECT @sqlDB = 'EXEC [' + @DBName + ']..sp_executesql @sqlDetect, N''@sqlDetect nvarchar(max),@sqlGrant nvarchar(max) out,@FullName nvarchar(512)''
				,@sqlDetect = @sqlDetect,@sqlGrant = @sqlGrant out,@FullName = @FullName';
			EXEC sp_executesql @sqlDB,N'@sqlDetect nvarchar(max),@sqlGrant nvarchar(max) out,@FullName nvarchar(512)',@sqlDetect = @sqlDetect,@sqlGrant = @sqlGrant OUT,@FullName = @FullName

			SELECT @sqlDrop = 'DROP FUNCTION ' + @FullName;
			SELECT @sqlDB = 'EXEC [' + @DBName + ']..sp_executesql @sqlDrop';
			EXEC sp_executesql @sqlDB,N'@sqlDrop nvarchar(max)',@sqlDrop = @sqlDrop
		END

		SELECT @sqlDB = 'EXEC [' + @DBName + ']..sp_executesql @sqlDef';
		EXEC sp_executesql @sqlDB,N'@sqlDef nvarchar(max)',@sqlDef = @sqlDef

		-- ��Ȩ
		IF(Len(@sqlGrant)>1)
		BEGIN
			SELECT @sqlDB = 'EXEC [' + @DBName + ']..sp_executesql @sqlGrant';
			EXEC sp_executesql @sqlDB,N'@sqlGrant nvarchar(max)',@sqlGrant = @sqlGrant
		END
	END

	-- 3.��
	IF(OBJECTPROPERTY(@objID,'IsUserTable') = 1)
	BEGIN
		DELETE @DicTC;
		SELECT @DB_objID = NULL,@sqlGrant = '';
		SELECT @sqlDetect = 'SELECT @DB_objID = object_id(@FullName)';
		SELECT @sqlDB = 'EXEC [' + @DBName + ']..sp_executesql @sqlDetect, N''@DB_objID int out,@FullName nvarchar(512)'',@DB_objID = @DB_objID out,@FullName = @FullName';
		EXEC sp_executesql @sqlDB,N'@sqlDetect nvarchar(max),@DB_objID int out,@FullName nvarchar(512)',@sqlDetect = @sqlDetect, @DB_objID = @DB_objID OUT,@FullName = @FullName
		IF(@DB_objID IS NOT NULL)
		BEGIN
			-- Ŀ����ֵ佨�� --------------------------------------------------------------------------
			SELECT @sql = '
SELECT c.column_id,c.name
  FROM .sys.columns c
 WHERE c.object_id = object_id(@FullName);
';
			SELECT @sqlDB = 'EXEC [' + @DBName + ']..sp_executesql @sql, N''@FullName nvarchar(512)'',@FullName = @FullName';
			INSERT @DicTC ( column_id,name )
			EXEC sp_executesql @sqlDB,N'@sql nvarchar(max),@FullName nvarchar(512)',@sql = @sql, @FullName = @FullName
			-- =========================================================================================
			
			-- Ŀ������ݴ�����ʱ���ɾ����
			SELECT @sqlDrop = '
--TRUNCATE TABLE [' + @SchemaName + '].' + @objName +'_apqtmpt;
--DROP TABLE [' + @SchemaName + '].' + @objName +'_apqtmpt;
SELECT * INTO [' + @SchemaName + '].' + @objName +'_apqtmpt FROM ' + @FullName + ';
TRUNCATE TABLE ' + @FullName + ';
DROP TABLE ' + @FullName;
			SELECT @sqlDB = 'EXEC [' + @DBName + ']..sp_executesql @sqlDrop';
			EXEC sp_executesql @sqlDB,N'@sqlDrop nvarchar(max)',@sqlDrop = @sqlDrop
		END
		
		-- Ŀ��⽨��(��������/��) -----------------------------------------------------------------
		SELECT @sqlDB = 'EXEC [' + @DBName + ']..sp_executesql @sqlDef_Table';
		EXEC sp_executesql @sqlDB,N'@sqlDef_Table nvarchar(max)',@sqlDef_Table = @sqlDef_Table
		-- =========================================================================================
		
		-- ����ԭ����(����������),ɾ����ʱ�� -------------------------------------------------------
		IF(@DB_objID IS NOT NULL)
		BEGIN
			SELECT @sql_Cols = '';
			SELECT @sql_Cols = @sql_Cols + '[' + t.name + '],'
			  FROM @DicFC f INNER JOIN @DicTC t ON f.name = t.name;
			SELECT @sql_Cols = Left(@sql_Cols,Len(@sql_Cols)-1);
			IF(EXISTS(SELECT TOP 1 1 FROM @DicFC WHERE is_identity = 1)
				AND EXISTS(SELECT TOP 1 1 FROM @DicFC f INNER JOIN @DicTC t ON f.name = t.NAME WHERE f.is_identity = 1))
			BEGIN
				SELECT @sql_SI = '
SET IDENTITY_INSERT ' + @FullName + ' ON;
';
			END
			ELSE
			BEGIN
				SELECT @sql_SI = '';
			END
			SELECT @sql_SI = @sql_SI + '
INSERT ' + @FullName + '(' + @sql_Cols + ')
SELECT ' + @sql_Cols + '
  FROM [' + @SchemaName + '].' + @objName +'_apqtmpt;
TRUNCATE TABLE [' + @SchemaName + '].' + @objName +'_apqtmpt;
DROP TABLE [' + @SchemaName + '].' + @objName +'_apqtmpt;
';
			IF(EXISTS(SELECT TOP 1 1 FROM @DicFC WHERE is_identity = 1)
				AND EXISTS(SELECT TOP 1 1 FROM @DicFC f INNER JOIN @DicTC t ON f.name = t.NAME WHERE f.is_identity = 1))
			BEGIN
				SELECT @sql_SI = @sql_SI + '
SET IDENTITY_INSERT ' + @FullName + ' OFF;
';
			END
			SELECT @sqlDB = 'EXEC [' + @DBName + ']..sp_executesql @sql_SI';
			EXEC sp_executesql @sqlDB,N'@sql_SI nvarchar(max)',@sql_SI = @sql_SI
		END
		-- =========================================================================================
		
		-- ��������(��) ----------------------------------------------------------------------------
		SELECT @sqlDB = 'EXEC [' + @DBName + ']..sp_executesql @sqlDef_Index';
		EXEC sp_executesql @sqlDB,N'@sqlDef_Index nvarchar(max)',@sqlDef_Index = @sqlDef_Index
		-- =========================================================================================
	END

	FETCH NEXT FROM @csr INTO @DBName;
END

Quit:
CLOSE @csr;
GO
