IF( OBJECT_ID('dbo.GameWS_UserChannelPay_Current_Get', 'P') IS NULL )
	EXEC sp_executesql N'CREATE PROCEDURE dbo.GameWS_UserChannelPay_Current_Get AS BEGIN RETURN END';
GO
ALTER PROC dbo.GameWS_UserChannelPay_Current_Get
	 @ExMsg	nvarchar(max) OUT,
	 
	 @PayWay		int			-- ֧����ʽ:{1:����,2:�Ѻ�}
	,@uid			varchar(50)
	
	,@PayToday		money OUT
	,@PayMonth		money OUT
AS
/* =============================================
-- ����: ������
-- ����: 2010-10-12
-- ����: ��ȡ�û���ǰ���ö��
-- ����:
-- ʾ��:
DECLARE @rtn int;
EXEC @rtn = dbo.GameWS_UserChannelPay_Current_Get;
SELECT @rtn;
-- =============================================
*/
SET NOCOUNT ON;

SELECT @PayToday = 0, @PayMonth = 0;

IF(@PayWay IS NULL) SELECT @PayWay = 1;

SELECT @PayToday = PayToday
  FROM dbo.UserChannelPay_Today
 WHERE PayWay = @PayWay AND uid = @uid;

SELECT @PayMonth = PayMonth
  FROM dbo.UserChannelPay_Month
 WHERE PayWay = @PayWay AND uid = @uid;

SELECT @ExMsg = '��ȡ�ɹ�';
RETURN 1;
GO
GRANT EXECUTE ON [dbo].[GameWS_UserChannelPay_Current_Get] TO GameW
GO
