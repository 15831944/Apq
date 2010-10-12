IF( OBJECT_ID('dbo.GameWS_UserChannelPay_Today_ListPager', 'P') IS NULL )
	EXEC sp_executesql N'CREATE PROCEDURE dbo.GameWS_UserChannelPay_Today_ListPager AS BEGIN RETURN END';
GO
ALTER PROC dbo.GameWS_UserChannelPay_Today_ListPager
	 @ExMsg	nvarchar(max) OUT,
	 
    @pSize		int = 20,			-- ÿҳ����
    @pNumber	int = 0				-- ҳ��(��0��ʼ)
	 
	,@PayWay		int			-- ֧����ʽ:{1:����,2:�Ѻ�}
	,@uid			varchar(50)
AS
/* =============================================
-- ����: ������
-- ����: 2010-09-30
-- ����: ��ҳ��ʾ�û��޶��
-- ����:
-- ʾ��:
DECLARE @rtn int;
EXEC @rtn = dbo.GameWS_UserChannelPay_Today_ListPager;
SELECT @rtn;
-- =============================================
*/
SET NOCOUNT ON;

IF(@uid IS NULL) SELECT @uid = '';

/*
DECLARE @nTop0 int;
SELECT @nTop0 = @pNumber * @pSize;

SELECT TOP(@nTop0) ID, PayWay, uid, PayToday, _Time
  INTO #UserChannelPay_Today_ListPager
  FROM UserChannelPay_Today(NOLOCK)
 ORDER BY PayToday DESC;

SELECT TOP(@pSize) ID, PayWay, uid, PayToday, _Time
  FROM #UserChannelPay_Today_ListPager Apq_Pager0
 WHERE NOT EXISTS(SELECT TOP 1 1 FROM #UserChannelPay_Today_ListPager Apq_Pager1 WHERE Apq_Pager0.ID = Apq_Pager1.ID)
 ORDER BY PayToday DESC;

TRUNCATE TABLE #UserChannelPay_Today_ListPager;
DROP TABLE #UserChannelPay_Today_ListPager;
*/

SELECT ID, PayWay, uid, PayToday, _Time
  FROM dbo.UserChannelPay_Today(NOLOCK)
 WHERE (@PayWay NOT IN (1,2) OR PayWay = @PayWay)
	AND (@uid = '' OR uid = @uid)
 ORDER BY PayToday DESC;

SELECT @ExMsg = '��ȡ�ɹ�';
RETURN 1;
GO
GRANT EXECUTE ON [dbo].[GameWS_UserChannelPay_Today_ListPager] TO GameW
GO
