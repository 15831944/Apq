IF( OBJECT_ID('dbo.Apq_VarBinary_Or', 'FN') IS NULL )
	EXEC sp_executesql N'CREATE FUNCTION dbo.Apq_VarBinary_Or()RETURNS int AS BEGIN RETURN 0 END';
GO
/* =============================================
-- 作者: 黄宗银
-- 日期: 2008-06-25
-- 描述: 二进制位或
-- 示例:
SELECT dbo.Apq_VarBinary_Or(0x000100, 0x010001)
-- =============================================
*/
ALTER FUNCTION dbo.Apq_VarBinary_Or(
	@vb1	varbinary(max),
	@vb2	varbinary(max)
)RETURNS varbinary(max) AS
BEGIN
	DECLARE	@rtn varbinary(max)
		,@l1 int, @l2 int
		,@lmin int, @lmax int, @i int
		,@t1 tinyint, @b2 binary(1)
		;
	SELECT @rtn = 0x, @l1 = DataLength(@vb1), @l2 = DataLength(@vb2);
	SELECT @i = 1, @lmin = CASE WHEN @l1 < @l2 THEN @l1 ELSE @l2 END, @lmax = CASE WHEN @l1 > @l2 THEN @l1 ELSE @l2 END;

	WHILE(@i <= @lmin)
	BEGIN
		SELECT @t1 = SubString(@vb1, @i, 1);
		SELECT @b2 = SubString(@vb2, @i, 1);

		SELECT @rtn = @rtn + Convert(binary(1),(@t1 | @b2));

		SELECT @i = @i + 1;
	END

	IF(@lmax > @lmin)
	BEGIN
		SELECT @rtn = @rtn + 
			CASE 
				WHEN @l1 = @lmax THEN SubString(@vb1, @i, @lmax - @lmin)
				ELSE SubString(@vb2, @i, @lmax - @lmin) 
			END;
	END
	
	RETURN @rtn;
END
GO
EXEC dbo.Apq_Def_EveryDB 'dbo', 'Apq_VarBinary_Or', DEFAULT
