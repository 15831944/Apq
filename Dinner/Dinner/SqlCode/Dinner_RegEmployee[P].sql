IF ( object_id('dbo.Dinner_RegEmployee','P') IS NULL ) 
    EXEC sp_executesql N'CREATE PROCEDURE dbo.Dinner_RegEmployee AS BEGIN RETURN END' ;
GO
/* =============================================
-- ����: ������
-- ����: 2011-04-08
-- ����: ��¼
-- ʾ��:
EXEC dbo.Dinner_RegEmployee 'Apq', 0x123
-- =============================================
*/
ALTER PROC dbo.Dinner_RegEmployee
	 @ExMsg nvarchar(max) OUT
	 
	,@EmName nvarchar(50)
	,@LoginName	nvarchar(50)
	,@LoginPwd	varbinary(64)
	
	,@EmID bigint OUT
	,@LoginID bigint OUT
AS 
SET NOCOUNT ON ;

DECLARE @rtn int, @ExMsg1 nvarchar(max);

-- �ظ����
IF(EXISTS(SELECT TOP 1 1 FROM dbo.Logins WHERE LoginName = @LoginName))
BEGIN
	SELECT @ExMsg = '��¼���ظ�,����������';
	RETURN -1;
END

-- ��¼��Ϣ¼��
EXEC @rtn = dbo.Apq_Identifier @ExMsg1 OUT, 'dbo.Logins',1,@LoginID OUT
IF(@@ERROR = 0 AND @rtn = 1)
BEGIN
	INSERT dbo.Logins(LoginID,LoginName,LoginPwd)
	VALUES (@LoginID,@LoginName,@LoginPwd);
END

-- Ա����Ϣ¼��
EXEC @rtn = dbo.Apq_Identifier @ExMsg1 OUT, 'dbo.Employee',1,@EmID OUT
IF(@@ERROR = 0 AND @rtn = 1)
BEGIN
	INSERT dbo.Employee(EmID,LoginID,EmName)
	VALUES (@EmID,@LoginID,@EmName);
END

GO
