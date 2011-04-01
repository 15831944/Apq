IF ( object_id('dbo.ApqDBMgr_Computer_Save','P') IS NULL ) 
    EXEC sp_executesql N'CREATE PROCEDURE dbo.ApqDBMgr_Computer_Save AS BEGIN RETURN END' ;
GO
/* =============================================
-- ����: ������
-- ����: 2011-04-01
-- ����: ����Sqlʵ��
-- ʾ��:
EXEC dbo.ApqDBMgr_Computer_Save 1
	,-1,-1,'��������',0,-1,'172.16.0.20',1433,'apq', 'f'
-- =============================================
*/
ALTER PROC dbo.ApqDBMgr_Computer_Save
	 @SaveType		int				-- 1:UPDATE/INSERT,2:DELETE

	,@ComputerID	int
	,@ComputerName	nvarchar(50)
	,@ComputerType	int
AS
SET NOCOUNT ON ;

IF(@SaveType = 1)
BEGIN
	UPDATE dbo.Computer
	   SET ComputerName = @ComputerName, ComputerType = @ComputerType
	 WHERE ComputerID = @ComputerID;
	IF(@@ROWCOUNT = 0)
	BEGIN
		INSERT dbo.Computer ( ComputerID, ComputerName, ComputerType )
		VALUES ( @ComputerID,@ComputerName,@ComputerType );
	END	
END

IF(@SaveType = 2)
BEGIN
	DELETE dbo.Computer WHERE ComputerID = @ComputerID;
END
GO
