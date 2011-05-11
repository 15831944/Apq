IF ( object_id('dbo.Dinner_Login','P') IS NULL ) 
    EXEC sp_executesql N'CREATE PROCEDURE dbo.Dinner_Login AS BEGIN RETURN END' ;
GO
/* =============================================
-- ����: ������
-- ����: 2011-04-08
-- ����: ��¼
-- ʾ��:
EXEC dbo.Dinner_Login 'Apq', 0x123
-- =============================================
*/
ALTER PROC dbo.Dinner_Login
	 @ExMsg nvarchar(max) OUT
	 
	,@LoginName	nvarchar(50)
	,@LoginPwd	varbinary(64)
AS 
SET NOCOUNT ON ;

DECLARE @LoginID bigint, @LoginPwdDB varbinary(64), @PwdExpire datetime, @LoginStatus int, @EmStatus int;
SELECT @LoginID = l.LoginID, @LoginPwdDB = LoginPwd, @LoginStatus = LoginStatus, @EmStatus = EmStatus
  FROM dbo.Logins l LEFT JOIN dbo.Employee e ON l.LoginID = e.LoginID
 WHERE LoginName = @LoginName;
IF(@@ROWCOUNT = 0)
BEGIN
	SELECT @ExMsg = '��¼�����������';
	RETURN -1;
END
IF(@LoginPwd <> @LoginPwdDB)
BEGIN
	SELECT @ExMsg = '��¼�����������';
	RETURN -1;
END
IF((@LoginStatus&1) = 0)
BEGIN
	SELECT @ExMsg = '��¼δ����';
	RETURN -1;
END
IF((@LoginStatus&2) > 0)
BEGIN
	SELECT @ExMsg = '��¼�ѽ���';
	RETURN -1;
END
IF((@LoginStatus&4) > 0)
BEGIN
	SELECT @ExMsg = '��¼�ѷ��';
	RETURN -1;
END
IF((@EmStatus&1) > 0)
BEGIN
	SELECT @ExMsg = 'Ա���ѽ���';
	RETURN -1;
END

SELECT l.LoginID, LoginName, LoginPwd, PwdExpire, LoginStatus, RegTime, e.EmID, e.IsAdmin, e.EmName, e.EmStatus
  FROM dbo.Logins l LEFT JOIN dbo.Employee e ON l.LoginID = e.LoginID
 WHERE l.LoginID = @LoginID;
RETURN 1;
GO
