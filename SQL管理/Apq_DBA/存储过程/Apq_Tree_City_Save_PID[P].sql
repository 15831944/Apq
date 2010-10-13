
IF( OBJECT_ID('dbo.Apq_Tree_City_Save_PID', 'P') IS NULL )
	EXEC sp_executesql N'CREATE PROCEDURE dbo.Apq_Tree_City_Save_PID AS BEGIN RETURN END';
GO
/* =============================================
-- ����: ������
-- ����: 2008-11-14
-- ����: ���������
-- ����: ���������ϼ�ID
-- ���: ����ID
-- ʾ��:
DECLARE @rtn int, @ExMsg nvarchar(4000), @CityID bigint;
EXEC @rtn = dbo.Apq_Tree_City_Save_PID @ExMsg out, '���', 1, @CityID out;
SELECT @rtn, @ExMsg, @CityID;
-- =============================================
*/
ALTER PROC dbo.Apq_Tree_City_Save_PID
	@ExMsg	nvarchar(4000) out,

	@CityName	nvarchar(450),	-- ����

	@ParentID	bigint	-- �ϼ�ID

	,@CityID	bigint out
AS
SET NOCOUNT ON;

DECLARE @rtn int;

-- ���ó���ID
IF(@CityID IS NULL OR @CityID = 0)
BEGIN
	EXEC @rtn = dbo.Apq_Identifier @ExMsg out, N'Apq_Tree_City', 1, @CityID out;
	IF(@@ERROR <> 0 OR @rtn <> 1)
	BEGIN
		RETURN -1;
	END
END

-- ������Ϣ
UPDATE Apq_Tree_City SET _Time = getdate(), ParentID = @ParentID, @CityID = ID WHERE Name = @CityName;
IF(@@ROWCOUNT = 0)
BEGIN
	INSERT Apq_Tree_City(ID,ParentID,Name) VALUES(@CityID,@ParentID,@CityName);
END
RETURN 1;
GO
