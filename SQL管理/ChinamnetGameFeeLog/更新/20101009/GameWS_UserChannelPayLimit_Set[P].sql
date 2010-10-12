IF( OBJECT_ID('dbo.GameWS_UserChannelPayLimit_Set', 'P') IS NULL )
	EXEC sp_executesql N'CREATE PROCEDURE dbo.GameWS_UserChannelPayLimit_Set AS BEGIN RETURN END';
GO
ALTER PROC dbo.GameWS_UserChannelPayLimit_Set
	 @ExMsg	nvarchar(max) OUT,
	 
	 @PayWay	int			-- ֧����ʽ:{1:����,2:�Ѻ�}
	,@Limit		money
	,@LimitType	tinyint
AS
/* =============================================
-- ����: ������
-- ����: 2010-09-30
-- ����: �û��������޶�����
-- ����:
-- ʾ��:
DECLARE @rtn int;
EXEC @rtn = dbo.GameWS_UserChannelPayLimit_Set;
SELECT @rtn;
-- =============================================
*/
SET NOCOUNT ON;

IF(@PayWay IS NULL) SELECT @PayWay = 1;

UPDATE dbo.UserChannelPayLimit
   SET _Time = getdate(), Limit = @Limit
 WHERE PayWay = @PayWay AND LimitType = @LimitType;
IF(@@ROWCOUNT = 0)
BEGIN
	INSERT dbo.UserChannelPayLimit ( PayWay,Limit,LimitType )
	VALUES(@PayWay,@Limit,@LimitType);
END

SELECT @ExMsg = '���óɹ���';
RETURN 1;
GO
GRANT EXECUTE ON [dbo].[GameWS_UserChannelPayLimit_Set] TO GameW
GO
