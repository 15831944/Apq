IF( OBJECT_ID('dbo.Apq_RConvertVarBinary8_BigInt', 'FN') IS NULL )
	EXEC sp_executesql N'CREATE FUNCTION dbo.Apq_RConvertVarBinary8_BigInt()RETURNS int AS BEGIN RETURN 0 END';
GO
/* =============================================
-- ����: ������
-- ����: 2008-05-07
-- ����: ��������ת��(���֧��8�ֽ�,bigint����)
-- ʾ��:
SELECT dbo.Apq_RConvertVarBinary8_BigInt(0x0100)
-- =============================================
*/
ALTER FUNCTION dbo.Apq_RConvertVarBinary8_BigInt(
	@Input	varbinary(8)
)RETURNS bigint AS
BEGIN
	DECLARE	@bin varbinary(8), @rtn bigint;
	SELECT @bin = dbo.Apq_VarBinary_Reverse(@Input);
	SELECT @rtn = Convert(bigint, @bin);
	RETURN @rtn;
END
GO
EXEC dbo.Apq_Def_EveryDB 'dbo', 'Apq_RConvertVarBinary8_BigInt', DEFAULT
