IF( OBJECT_ID('dbo.Apq_RandomString', 'P') IS NULL )
	EXEC sp_executesql N'CREATE PROCEDURE dbo.Apq_RandomString AS BEGIN RETURN END';
GO
/* =============================================
-- ����: ������
-- ����: 2009-03-31
-- ����: ��������ַ���
-- ʾ��:
DECLARE @rtn int, @ExMsg nvarchar(max), @SimpleChars nvarchar(max);
SELECT @SimpleChars = 'ABCDEFGHJLMNRTWYacdefhijkmnprtuvwxy0123456789';
SELECT @SimpleChars = 'ABCDEFGHJLMNRTWY0123456789';
EXEC @rtn = dbo.Apq_RandomString @ExMsg out, @SimpleChars, 50000, 8, 1, 1;
SELECT @rtn, @ExMsg;
-- =============================================
*/
ALTER PROC dbo.Apq_RandomString
	 @ExMsg nvarchar(max) out
	 
	,@Chars		nvarchar(max)='ABCDEFGHJLMNRTWYacdefhijkmnprtuvwxy0123456789'	-- �ַ���(һ�㲻�ظ�)
	,@Count		int	= 10		-- ����
	,@Length	int = 16		-- ����
	,@Repeat	tinyint = 1		-- ÿ�������Ƿ������ظ�
	,@Distinct	tinyint	= 0		-- �໥֮���Ƿ�Ψһ(Ϊ1ʱ��Ҫ��֤ ������ >= @Count)
AS
SET NOCOUNT ON;

DECLARE @Now datetime, @i int, @l int, @chrs nvarchar(max)
	,@s nvarchar(max)	-- ��ǰ�����ɵĴ�
	,@p int			-- ��ǰѡ�е�λ��(@chrs��)
	--,@pl int			-- �ϴ�ѡ�е�λ��(@chrs��)
	,@c nvarchar(1)	-- �ϴ�ѡ�е��ַ�
	;
SELECT @Now = getdate();

CREATE TABLE #t(
	s	nvarchar(max)
);
IF(@Distinct = 1)
BEGIN
	CREATE INDEX [IX_#t:s] ON #t(s)
END

SELECT @i = 0;
WHILE(@i < @Count)
BEGIN
	SELECT @l = 0, @p = 0, @chrs = @Chars, @s = '', @c='';
	WHILE(@l < @Length)
	BEGIN
		IF(@Repeat = 0 AND LEN(@c) > 0)
		BEGIN
			-- ȥ���ϴ�ѡ�е��ַ�
			SELECT @chrs = REPLACE(@chrs, @c,'');
		END
		
		SELECT @p = Convert(int,RAND()*LEN(@chrs)) + 1;
		SELECT @c = SUBSTRING(@chrs, @p,1);
		SELECT @s = @s + @c;
	
		SELECT @l = @l + 1;
	END
	
	IF(@Distinct = 1 AND EXISTS(SELECT 1 FROM #t WHERE s = @s))
	BEGIN
		-- �����ظ�
		CONTINUE;
	END
	
	INSERT #t(s) SELECT @s;
	SELECT @i = @i + 1;
END

SELECT * FROM #t;
 
TRUNCATE TABLE #t;
DROP TABLE #t;

SELECT @ExMsg = '���ɳɹ�';
RETURN 1;
GO
EXEC dbo.Apq_Def_EveryDB 'dbo', 'Apq_RandomString', DEFAULT
