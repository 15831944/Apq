IF( OBJECT_ID('dbo.Apq_ConvertInt_TimeString', 'FN') IS NULL )
	EXEC sp_executesql N'CREATE FUNCTION dbo.Apq_ConvertInt_TimeString()RETURNS int AS BEGIN RETURN 0 END';
GO
/* =============================================
-- ����: ������
-- ����: 2010-06-11
-- ����: ��������ʾ��ʱ�� ת��Ϊ 24Сʱʱ���ַ���,��ʽ[hh:mi:ss]
-- ʾ��:
SELECT dbo.Apq_ConvertInt_TimeString('310')
-- =============================================
*/
ALTER FUNCTION dbo.Apq_ConvertInt_TimeString
(
	@nTime	int
)
RETURNS nvarchar(8)
AS
BEGIN
	DECLARE @Return nvarchar(8), @strTime nvarchar(8), @p int;
    SELECT @strTime = RIGHT('000000'+Convert(nvarchar(6),@nTime),6);
	SELECT @Return = LEFT(@strTime,2);
    SELECT @p = 3;
    WHILE(@p < 6)
    BEGIN
		SELECT @Return = @Return + ':' + Substring(@strTime,@p,2);
    
    	SELECT @p = @p + 2;
    END

	RETURN @Return;
END
GO
EXEC dbo.Apq_Def_EveryDB 'dbo', 'Apq_ConvertInt_TimeString', DEFAULT
GO
