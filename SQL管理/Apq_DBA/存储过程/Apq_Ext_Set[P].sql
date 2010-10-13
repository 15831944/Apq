IF( OBJECT_ID('dbo.Apq_Ext_Set', 'P') IS NULL )
	EXEC sp_executesql N'CREATE PROCEDURE dbo.Apq_Ext_Set AS BEGIN RETURN END';
GO
/* =============================================
-- ����: ������
-- ����: 2009-02-05
-- ����: ������չ����ֵ(��ӻ��޸�)
-- ʾ��:
DECLARE @err int, @rtn int, @Msg nvarchar(MAX);
EXEC @rtn = dbo.Apq_Ext_Set @Msg out, '', 0, 'pName', 'zh-cn', '����ֵ';
SELECT @err = @@ERROR;
SELECT @err, @rtn, @Msg;
-- =============================================
*/
ALTER PROC dbo.Apq_Ext_Set
	 @TableName	nvarchar(256) = ''
	,@ID		bigint = 0
	,@Name		nvarchar(256)

	,@Value	nvarchar(MAX)
AS
SET NOCOUNT ON;

DECLARE @err int, @rtn int, @strID bigint;

UPDATE Apq_Ext
   SET Value = @Value
 WHERE TableName = @TableName AND ID = @ID AND Name = @Name;
IF( @@ROWCOUNT = 0 )
BEGIN
	INSERT Apq_Ext(TableName, ID, Name, Value)
	VALUES(@TableName, @ID, @Name, @Value);
END

RETURN 1;
GO
EXEC dbo.Apq_Def_EveryDB 'dbo', 'Apq_Ext_Set', DEFAULT
GO
