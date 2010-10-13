IF ( OBJECT_ID('dbo.Apq_RenameDefault','P') IS NULL ) 
    EXEC sp_executesql N'CREATE PROCEDURE dbo.Apq_RenameDefault AS BEGIN RETURN END' ;
GO
/* =============================================
-- ����: ������
-- ����: 2010-06-06
-- ����: �ؽ�����Ĭ��ֵ(�����淶��)
-- ����:
	����������: DF_����_����
-- ʾ��:
EXEC dbo.Apq_RenameDefault
-- =============================================
*/
ALTER PROC dbo.Apq_RenameDefault
AS 
DECLARE @SchemaName nvarchar(128)
DECLARE @TableName nvarchar(128)
DECLARE @ColumnName nvarchar(128)
DECLARE @Defname nvarchar(128)
DECLARE @Definition nvarchar(128)
DECLARE @sql nvarchar(max)

DECLARE @csr_Constraints CURSOR ;
SET @csr_Constraints = CURSOR STATIC FOR 
SELECT  SCHEMA_NAME(o.schema_id),o.Name,c.Name,so.name,so.definition 
  FROM  sys.default_constraints so INNER JOIN sys.objects o  ON o.object_id = so.parent_object_id
								   INNER JOIN sys.columns c  ON C.DEFAULT_OBJECT_ID =so.object_id;

OPEN @csr_Constraints ;

FETCH NEXT FROM @csr_Constraints INTO @SchemaName,@TableName,@ColumnName,@Defname,@Definition ;
WHILE ( @@FETCH_STATUS = 0 ) 
BEGIN
    SELECT  @sql = 'ALTER TABLE [' + @SchemaName + '].[' + @TableName + '] DROP CONSTRAINT [' + @Defname + ']'
    EXEC sp_executesql @sql

    SELECT  @sql = 'ALTER TABLE [' + @SchemaName + '].[' + @TableName + '] ADD CONSTRAINT DF_' + @TableName + '_' + @ColumnName + ' DEFAULT '
            + @Definition + ' FOR [' + @ColumnName + ']'
    EXEC sp_executesql @sql

    FETCH NEXT FROM @csr_Constraints INTO @SchemaName,@TableName,@ColumnName,@Defname,@Definition ;
END

CLOSE @csr_Constraints
RETURN 1
GO
EXEC dbo.Apq_Def_EveryDB 'dbo', 'Apq_RenameDefault', DEFAULT
GO
