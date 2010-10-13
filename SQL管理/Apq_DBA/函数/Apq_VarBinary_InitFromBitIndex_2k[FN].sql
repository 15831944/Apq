IF( OBJECT_ID('dbo.Apq_VarBinary_InitFromBitIndex_2k', 'FN') IS NULL )
	EXEC sp_executesql N'CREATE FUNCTION dbo.Apq_VarBinary_InitFromBitIndex_2k()RETURNS int AS BEGIN RETURN 0 END';
GO
/* =============================================
-- ����: ������
-- ����: 2008-06-25
-- ����: ��ָ������λΪ1����ʼ�������ƴ�
-- ʾ��:
SELECT dbo.Apq_VarBinary_InitFromBitIndex_2k(159)
-- =============================================
*/
ALTER FUNCTION dbo.Apq_VarBinary_InitFromBitIndex_2k(
	@idx	int
)RETURNS varbinary(8000) AS
BEGIN
	DECLARE @rtn varbinary(8000), @i tinyint
		,@q int, @r int;
	SELECT @rtn = 0x, @q = @idx / 8, @r = @idx % 8;
	IF(@q > 0 AND @r = 0)
	BEGIN
		SELECT @q = @q - 1;
	END

	SELECT @i = 0;
	WHILE(@i < @q)
	BEGIN
		SELECT @rtn = @rtn + 0x00;

		SELECT @i = @i + 1;
	END

	SELECT @rtn = @rtn + CASE @r WHEN 0 THEN 0x01 ELSE Convert(binary(1), Power(2,8-@r)) END;
	
	RETURN @rtn;
END
GO
EXEC dbo.Apq_Def_EveryDB 'dbo', 'Apq_VarBinary_InitFromBitIndex_2k', DEFAULT
