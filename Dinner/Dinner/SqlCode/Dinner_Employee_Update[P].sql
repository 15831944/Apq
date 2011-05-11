IF ( object_id('dbo.Dinner_Employee_Update','P') IS NULL ) 
    EXEC sp_executesql N'CREATE PROCEDURE dbo.Dinner_Employee_Update AS BEGIN RETURN END' ;
GO
/* =============================================
-- ����: ������
-- ����: 2011-04-11
-- ����: �༭Ա��
-- ʾ��:
DECLARE @Pager_RowCount bigint
EXEC dbo.Dinner_Employee_Update 0, 5, @Pager_RowCount out
SELECT @Pager_RowCount;
-- =============================================
*/
ALTER PROC dbo.Dinner_Employee_Update
	 @ExMsg nvarchar(max) OUT

	,@EmID		bigint
	
	,@EmName	nvarchar(50)
	,@IsAdmin	tinyint
	,@EmStatus	int
	,@LoginName	nvarchar(50)
AS 
SET NOCOUNT ON ;

DECLARE @rtn int, @ExMsg1 nvarchar(max);
DECLARE @LoginID bigint;
SELECT @LoginID = LoginID FROM dbo.Employee WHERE EmID = @EmID;

-- �ظ����
IF(EXISTS(SELECT TOP 1 1 FROM dbo.Logins l WHERE LoginName = @LoginName AND LoginID <> @LoginID))
BEGIN
	SELECT @ExMsg = '��¼���ظ�,����������';
	RETURN -1;
END

UPDATE dbo.Logins
   SET _Time = getdate(), LoginName = @LoginName
 WHERE LoginID = @LoginID;

UPDATE dbo.Employee
   SET _Time = getdate(), EmName = @EmName, IsAdmin = @IsAdmin, EmStatus = @EmStatus
 WHERE EmID = @EmID;

RETURN 1;
GO
