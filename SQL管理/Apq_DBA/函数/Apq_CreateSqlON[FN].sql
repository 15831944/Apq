IF( OBJECT_ID('dbo.Apq_CreateSqlON', 'FN') IS NULL )
	EXEC sp_executesql N'CREATE FUNCTION dbo.Apq_CreateSqlON()RETURNS int AS BEGIN RETURN 0 END';
GO
/* =============================================
-- 作者: 黄宗银
-- 日期: 2010-05-17
-- 描述: 创建对象的SQL表示串
-- 示例:
SELECT dbo.Apq_CreateSqlON(16.3)
SELECT dbo.Apq_CreateSqlON('16.3')
SELECT dbo.Apq_CreateSqlON(0x16)
DECLARE @V_dt datetime
SELECT @V_dt = getdate();
SELECT dbo.Apq_CreateSqlON(@V_dt)
DECLARE @V_un uniqueidentifier
SELECT @V_un = newid();
SELECT dbo.Apq_CreateSqlON(@V_un)
-- =============================================
*/
ALTER FUNCTION Apq_CreateSqlON(
	@Value sql_variant
)
RETURNS nvarchar(max)
AS
BEGIN
	IF(@Value IS NULL) RETURN 'NULL';
	
	DECLARE @Vr nvarchar(max), @BaseType sysname, @Precision int, @Scale int, @MaxLength int;
	SELECT @BaseType = Convert(sysname,SQL_VARIANT_PROPERTY(@Value,'BaseType'))
		,@Precision = Convert(int,SQL_VARIANT_PROPERTY(@Value,'Precision'))
		,@Scale = Convert(int,SQL_VARIANT_PROPERTY(@Value,'Scale'))
		,@MaxLength = Convert(int,SQL_VARIANT_PROPERTY(@Value,'MaxLength'))
	
	IF(Charindex('binary',@BaseType) > 0)
	BEGIN
		DECLARE @V_Binary varbinary(max);
		SELECT @V_Binary = CONVERT(varbinary(max),@Value);
		SELECT @Vr = '0x' + dbo.Apq_ConvertVarBinary_HexStr(@V_Binary);
	END
	ELSE IF(Charindex('char',@BaseType) > 0)
	BEGIN
		DECLARE @V_Char nvarchar(max);
		SELECT @V_Char = CONVERT(nvarchar(max),@Value);
		SELECT @Vr = '''' + REPLACE(@V_Char,'''','''''') + '''';
	END
	ELSE IF(Len(@BaseType)>=8 AND Right(@BaseType,8)='datetime')
	BEGIN
		SELECT @Vr = '''' + Convert(nvarchar(50),@Value,121) + '''';
	END
	ELSE IF(@BaseType = 'uniqueidentifier')
	BEGIN
		SELECT @Vr = '''' + Convert(nvarchar(max),@Value) + '''';
	END
	ELSE
		SELECT @Vr = Convert(nvarchar(max),@Value);
	
	Quit:
	RETURN @Vr;
END
GO
EXEC dbo.Apq_Def_EveryDB 'dbo', 'Apq_CreateSqlON', DEFAULT
GO
