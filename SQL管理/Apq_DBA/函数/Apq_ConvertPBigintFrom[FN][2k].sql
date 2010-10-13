IF( OBJECT_ID('dbo.Apq_ConvertPBigintFrom', 'FN') IS NULL )
	EXEC sp_executesql N'CREATE FUNCTION dbo.Apq_ConvertPBigintFrom()RETURNS int AS BEGIN RETURN 0 END';
GO
/* =============================================
-- 作者: 黄宗银
-- 日期: 2007-09-29
-- 描述: [未检测溢出]将一串 @from 进制的字符串 @str 转换为Bigint正数
-- 示例:
SELECT dbo.Apq_ConvertPBigintFrom(16, '7FFFFFFFFFFFFFFF'/*所支持的最大值*/)
-- =============================================
*/
ALTER FUNCTION dbo.Apq_ConvertPBigintFrom
(
	@from	bigint,
	@str	varchar(8000)
)
RETURNS bigint
AS
BEGIN
	DECLARE @Return bigint;

	DECLARE @i int, @Length int, @c char(1);
	SELECT @Return = 0, @i = 0, @Length = LEN(@str);
	WHILE( @i < @Length )
	BEGIN
		SELECT @c = SUBSTRING( @str, @Length - @i, 1 );
		IF( ASCII(@c) <= ASCII('9') )
		BEGIN
			SELECT @Return = POWER( @from, @i ) * (ASCII(@c) - ASCII('0') + 0) + @Return;
		END
		ELSE
		BEGIN
			IF( ASCII(@c) > ASCII('Z') )
			BEGIN
				SELECT @c = CHAR(ASCII(@c) - 32);	-- 转换为大写
			END
			SELECT @Return = POWER( @from, @i ) * (ASCII(@c) - ASCII('A') + 10) + @Return;
		END

		SELECT @i = @i + 1;
	END

	RETURN @Return
END
GO
EXEC dbo.Apq_Def_EveryDB 'dbo', 'Apq_ConvertPBigintFrom', DEFAULT
