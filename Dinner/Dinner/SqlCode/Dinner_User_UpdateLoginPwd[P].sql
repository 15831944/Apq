IF ( object_id('dbo.Dinner_User_UpdateLoginPwd','P') IS NULL ) 
    EXEC sp_executesql N'CREATE PROCEDURE dbo.Dinner_User_UpdateLoginPwd AS BEGIN RETURN END' ;
GO
/* =============================================
-- ����: ������
-- ����: 2011-04-13
-- ����: Ա���޸�����
-- ʾ��:
DECLARE @Pager_RowCount bigint
EXEC dbo.Dinner_User_UpdateLoginPwd 0, 5, @Pager_RowCount out
SELECT @Pager_RowCount;
-- =============================================
*/
ALTER PROC dbo.Dinner_User_UpdateLoginPwd
	 @ExMsg nvarchar(max) out
	 
	,@LoginID	bigint
	
	,@LoginPwd	varbinary(64)
AS
SET NOCOUNT ON ;

DECLARE @rtn int, @ExMsg1 nvarchar(max);
DECLARE @RestIDDB bigint;

UPDATE dbo.Logins
   SET [_Time] = getdate(), LoginPwd = @LoginPwd
 WHERE LoginID = @LoginID;

SELECT @ExMsg = '�޸ĳɹ�';
RETURN 1;
GO
