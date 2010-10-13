IF( OBJECT_ID('dbo.Apq_ConvertScale', 'FN') IS NULL )
	EXEC sp_executesql N'CREATE FUNCTION dbo.Apq_ConvertScale()RETURNS int AS BEGIN RETURN 0 END';
GO
/* =============================================
-- 作者: 黄宗银
-- 日期: 2007-09-28
-- 描述: 将一 @from 进制的串 @value 转换为 @to 进制表示的字符串
-- 示例:
SELECT dbo.Apq_ConvertScale(16, 10, '7FFFFFFFFFFFFFFF'/*所支持的最大值*/)
-- =============================================
*/
ALTER FUNCTION Apq_ConvertScale
(
	@from	int,
	@to		int,
	@value	varchar(max)
)
RETURNS varchar(max)
AS
BEGIN
	RETURN dbo.Apq_ConvertPBigintTo( @to, dbo.Apq_ConvertPBigintFrom( @from, @value ) );
END
GO
EXEC dbo.Apq_Def_EveryDB 'dbo', 'Apq_ConvertScale', DEFAULT
GO
