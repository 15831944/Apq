IF( OBJECT_ID('dbo.Apq_Ext_Get', 'FN') IS NULL )
	EXEC sp_executesql N'CREATE FUNCTION dbo.Apq_Ext_Get()RETURNS int AS BEGIN RETURN 0 END';
GO
/* =============================================
-- ����: ������
-- ����: 2009-01-14
-- ����: ��������ת��,������չ(���֧��8�ֽ�,bigint����)
-- ʾ��:
SELECT dbo.Apq_Ext_Get('',0,'ServerID')
-- =============================================
*/
ALTER FUNCTION dbo.Apq_Ext_Get(
	 @TableName	nvarchar(256) = N''
	,@ID		bigint = 0
	,@Name		nvarchar(256) = N''
)  
RETURNS nvarchar(max) AS
BEGIN
	DECLARE	@Return nvarchar(max);
	SELECT @Return = Value FROM Apq_Ext	WHERE TableName = @TableName AND ID = @ID AND Name = @Name;
	RETURN @Return;
END
GO
EXEC dbo.Apq_Def_EveryDB 'dbo', 'Apq_Ext_Get', DEFAULT
GO
