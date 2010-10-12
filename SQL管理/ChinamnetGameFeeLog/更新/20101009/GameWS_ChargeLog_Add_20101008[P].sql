IF( OBJECT_ID('dbo.GameWS_ChargeLog_Add_R1', 'P') IS NULL )
	EXEC sp_executesql N'CREATE PROCEDURE dbo.GameWS_ChargeLog_Add_R1 AS BEGIN RETURN END';
GO
ALTER PROC dbo.GameWS_ChargeLog_Add_R1
	 @ExMsg	nvarchar(max) OUT,
	 
	 @PayWay		int			-- ֧����ʽ:{1:����,2:�Ѻ�}
	,@pid			varchar(50)
	,@porder		varchar(50)
	,@uid			varchar(50)
	,@amt			money
	,@scene			varchar(50)
	,@phone			varchar(13)
	,@private		varchar(250)
	,@status		tinyint
	,@faildcount	int
	,@chargetime	datetime
	,@channel		varchar(30)
	,@buycode		varchar(30)
	,@beginposttime	datetime
	,@ipaddress		varchar(30)
	,@keyvalue		varchar(50)
	,@Imei			nvarchar(50)
AS
/* =============================================
-- ����: ������
-- ����: 2010-10-08
-- ����: ���δ�����־��¼,�û��������޶�,���޶�
-- ����:
-- ʾ��:
DECLARE @rtn int;
EXEC @rtn = dbo.GameWS_ChargeLog_Add_R1;
SELECT @rtn;
-- =============================================
*/
SET NOCOUNT ON;

IF(@PayWay IS NULL) SELECT @PayWay = 1;

-- ��¼��־
IF(@PayWay = 1)
BEGIN
	INSERT INTO T_Chuangyidaishou(pid,porder,uid,amt,scene,phone,private,status,faildcount,chargetime,channel,buycode,Imei,ipaddress)
	VALUES(@pid,@porder,@uid,Convert(int,@amt),@scene,@phone,@private,@status,@faildcount,@chargetime,@channel,@buycode,@Imei,@ipaddress);
END
IF(@PayWay = 2)
BEGIN
	INSERT INTO dbo.T_Sohudaishou(pid,porder,uid,amt,scene,phone,private,status,faildcount,chargetime,channel,buycode,ipaddress,keyvalue,Imei)
	VALUES(@pid,@porder,@uid,Convert(int,@amt),@scene,@phone,@private,@status,@faildcount,@chargetime,@channel,@buycode,@ipaddress,@keyvalue,@Imei);
END

-- ���µ���ͳ�Ʊ�
UPDATE dbo.UserChannelPay_Today
   SET [_Time] = getdate(), PayToday = PayToday + @amt, Imei = @Imei
 WHERE PayWay = @PayWay AND uid = @uid;
IF(@@ROWCOUNT = 0)
BEGIN
	INSERT dbo.UserChannelPay_Today ( PayWay,uid,PayToday,Imei )
	VALUES(@PayWay,@uid,@amt,@Imei);
END

-- ���µ���ͳ�Ʊ�
UPDATE dbo.UserChannelPay_Month
   SET [_Time] = getdate(), PayMonth = PayMonth + @amt, Imei = @Imei
 WHERE PayWay = @PayWay AND uid = @uid;
IF(@@ROWCOUNT = 0)
BEGIN
	INSERT dbo.UserChannelPay_Month ( PayWay,uid,PayMonth,Imei )
	VALUES(@PayWay,@uid,@amt,@Imei);
END

-- �ж����޶��Ƿ�ﵽ
IF(EXISTS(
SELECT TOP 1 1
  FROM dbo.UserChannelPay_Month a INNER JOIN dbo.UserChannelPayLimit b ON a.PayWay = b.PayWay AND b.LimitType = 2
 WHERE a.PayMonth >= b.Limit
	AND a.PayWay = @PayWay AND uid = @uid
))
BEGIN
	-- �ﵽ����ʱ����ͳ��ֵ����Ϊ�ܴ��ֵ
	UPDATE dbo.UserChannelPay_Today
	   SET [_Time] = getdate(), PayToday = 99999
	 WHERE PayWay = @PayWay AND uid = @uid;
END

SELECT @ExMsg = '��¼�ɹ�����ͳ����Ϣ�Ѹ��£�';
RETURN 1;
GO
GRANT EXECUTE ON [dbo].[GameWS_ChargeLog_Add_R1] TO GameW
GO
