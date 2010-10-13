
IF( OBJECT_ID('dbo.Apq_Tree_City_Save_PName', 'P') IS NULL )
	EXEC sp_executesql N'CREATE PROCEDURE dbo.Apq_Tree_City_Save_PName AS BEGIN RETURN END';
GO
/* =============================================
-- ����: ������
-- ����: 2008-11-19
-- ����: ���������
-- ����: ���������ϼ���
-- ���: ����ID
-- ʾ��:
DECLARE @rtn int, @ExMsg nvarchar(4000), @CityID bigint;
EXEC @rtn = dbo.Apq_Tree_City_Save_PName @ExMsg out, '���', 'ɽ��', @CityID out;
SELECT @rtn, @ExMsg, @CityID;
-- =============================================
*/
ALTER PROC dbo.Apq_Tree_City_Save_PName
	@ExMsg	nvarchar(4000) out,

	@CityName	nvarchar(450),	-- ����

	@ParentName	nvarchar(450)	-- �ϼ���

	,@CityID	bigint out
AS
SET NOCOUNT ON;

DECLARE @rtn int, @ParentID bigint;
-- ��ȡ�ϼ�ID
SELECT TOP 1 @ParentID = ID FROM Apq_Tree_City WHERE Name = @ParentName ORDER BY _Time DESC;

EXEC dbo.Apq_Tree_City_Save_PID @ExMsg out, @CityName, @ParentID, @CityID out;
RETURN 1;
GO
