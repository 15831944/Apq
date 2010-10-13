IF( OBJECT_ID('dbo.Apq_ConvertPBigintTo', 'FN') IS NULL )
	EXEC sp_executesql N'CREATE FUNCTION dbo.Apq_ConvertPBigintTo()RETURNS int AS BEGIN RETURN 0 END';
GO
/* =============================================
-- 作者: 黄宗银
-- 日期: 2007-09-29
-- 描述: 将一正整数 @value 转换为 @to 进制表示的字符串
-- 示例:
SELECT dbo.Apq_ConvertPBigintTo(16, 9223372036854775807/*Bigint正数最大值*/)
-- =============================================
*/
ALTER FUNCTION dbo.Apq_ConvertPBigintTo
(
	@to		int,
	@value	bigint
)
RETURNS varchar(max)
AS
BEGIN
	IF(@to < 2 OR @to > 36)
	BEGIN
		RETURN '';
	END

	DECLARE @Return varchar(max);

	DECLARE @q bigint, @r int;
	SELECT @q = @value, @Return = '';
	WHILE( @q <> 0 )
	BEGIN
		SELECT @r = @q % @to;
		IF( @r < 10 )
		BEGIN
			SELECT @Return = CHAR(@r + ASCII('0') - 0) + @Return;
		END
		ELSE
		BEGIN
			SELECT @Return = CHAR(@r + ASCII('A') - 10) + @Return;
		END

		SELECT @q = @q / @to;
	END

	RETURN @Return
END
GO
EXEC dbo.Apq_Def_EveryDB 'dbo', 'Apq_ConvertPBigintTo', DEFAULT
