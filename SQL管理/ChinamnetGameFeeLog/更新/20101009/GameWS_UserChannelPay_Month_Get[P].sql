IF( OBJECT_ID('dbo.GameWS_UserChannelPay_Month_Get', 'P') IS NULL )
	EXEC sp_executesql N'CREATE PROCEDURE dbo.GameWS_UserChannelPay_Month_Get AS BEGIN RETURN END';
GO
ALTER PROC dbo.GameWS_UserChannelPay_Month_Get
	 @ExMsg	nvarchar(max) OUT,
	 
	 @PayWay		int			-- ֧����ʽ:{1:����,2:�Ѻ�}
	,@uid			varchar(50)
	
	,@PayMonth		money OUT
AS
/* =============================================
-- ����: ������
-- ����: 2010-10-09
-- ����: ��ȡ�û��������ö��
-- ����:
-- ʾ��:
DECLARE @rtn int;
EXEC @rtn = dbo.GameWS_UserChannelPay_Month_Get;
SELECT @rtn;
-- =============================================
*/
SET NOCOUNT ON;

IF(@PayWay IS NULL) SELECT @PayWay = 1;

SELECT @PayMonth = 0;
SELECT @PayMonth = PayMonth
  FROM dbo.UserChannelPay_Month
 WHERE PayWay = @PayWay AND uid = @uid;

SELECT @ExMsg = '��ȡ�ɹ�';
RETURN 1;
GO
GRANT EXECUTE ON [dbo].[GameWS_UserChannelPay_Month_Get] TO GameW
GO
