IF( OBJECT_ID('dbo.Apq_ConvertIP4_VarBinary', 'FN') IS NULL )
	EXEC sp_executesql N'CREATE FUNCTION dbo.Apq_ConvertIP4_VarBinary()RETURNS int AS BEGIN RETURN 0 END';
GO
/* =============================================
-- ����: ������
-- ����: 2007-09-28
-- ����: ��IP4��ת��Ϊ varbinary(max)
-- ʾ��:
SELECT dbo.Apq_ConvertIP4_VarBinary('255.255.255.255');
-- =============================================
*/
ALTER FUNCTION dbo.Apq_ConvertIP4_VarBinary(
	@IP	varchar(max)
)RETURNS varbinary(max)
AS
BEGIN
	SELECT @IP = LTRIM(RTRIM(@IP));

	DECLARE @Return varbinary(Max)
		,@Len int		-- �ַ���
		,@ib int		-- ��ǰ������ʼλ��
		,@ie int		-- ��ǰ��������λ��
		,@i int
		;
	SELECT @Return = 0x
		,@Len = LEN(@IP)
		,@ie = 0
		,@i = 1
		;

	IF(@Len < 7) RETURN @Return;

	WHILE(@i <= 4)
	BEGIN
		SELECT	@ib = @ie + 1;
		SELECT	@ie = CHARINDEX('.', @IP, @ib);
		IF(@ie = 0)
		BEGIN
			SELECT	@ie = @Len + 1;
		END
		
		IF(@ib >= @ie) BREAK;

		SELECT	@Return = ISNULL(@Return, 0x) + Convert(binary(1), Convert(int, SUBSTRING(@IP, @ib, @ie - @ib)));

		SELECT	@i = @i + 1;
	END

	RETURN @Return;
END
GO
EXEC dbo.Apq_Def_EveryDB 'dbo', 'Apq_ConvertIP4_VarBinary', DEFAULT
