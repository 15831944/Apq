IF ( OBJECT_ID('dbo.Apq_Dependent_List','P') IS NULL ) 
    EXEC sp_executesql N'CREATE PROCEDURE dbo.Apq_Dependent_List AS BEGIN RETURN END' ;
GO
IF ( NOT EXISTS ( SELECT    *
                  FROM      fn_listextendedproperty(N'MS_Description',N'SCHEMA',N'dbo',N'PROCEDURE',N'Apq_Dependent_List',DEFAULT,DEFAULT) )
   ) 
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',@value = N'',@level0type = N'SCHEMA',@level0name = N'dbo',@level1type = N'PROCEDURE',
        @level1name = N'Apq_Dependent_List'
EXEC sp_updateextendedproperty @name = N'MS_Description',@value = N'
-- 显示(可能)依赖于指定对象的对象
-- 作者: 黄宗银
-- 日期: 2010-05-11
-- 示例:
DECLARE @rtn int, @ExMsg nvarchar(max), @object_id int;
SELECT @object_id = object_id(''dbo.aa'')
EXEC @rtn = dbo.Apq_Dependent_List @object_id;
SELECT @rtn,@ExMsg;
',@level0type = N'SCHEMA',@level0name = N'dbo',@level1type = N'PROCEDURE',@level1name = N'Apq_Dependent_List' ;
GO
ALTER PROC dbo.Apq_Dependent_List
   @object_id int
AS 
SET NOCOUNT ON ;

DECLARE @SchemaName sysname, @ObjName sysname;
SELECT @SchemaName = schema_name(uid), @ObjName = object_name(id)
  FROM sys.sysobjects
 WHERE id = @object_id;
IF(@@ROWCOUNT = 0) RETURN -1;

CREATE TABLE #Apq_Dependent_List1(
	obj_id	int
);

INSERT #Apq_Dependent_List1
SELECT object_id(ROUTINE_SCHEMA+'.'+ROUTINE_NAME)
  FROM INFORMATION_SCHEMA.ROUTINES
 WHERE Charindex(@ObjName, ROUTINE_DEFINITION) > 0
 
INSERT #Apq_Dependent_List1
SELECT o.id
  FROM sys.syscomments cmt INNER JOIN sys.sysobjects o ON cmt.id = o.id
 WHERE Charindex(@ObjName, cmt.text) > 0

SELECT DISTINCT SchemaName=schema_name(uid),name,xtype
  FROM #Apq_Dependent_List1 t INNER JOIN sys.sysobjects o ON t.obj_id = o.id

TRUNCATE TABLE #Apq_Dependent_List1;
DROP TABLE #Apq_Dependent_List1;
RETURN 1 ;
GO
EXEC dbo.Apq_Def_EveryDB 'dbo', 'Apq_Dependent_List', DEFAULT
GO
