IF( OBJECT_ID('dbo.GameWS_UserChannelPayLimit_Today_List', 'P') IS NULL )
	EXEC sp_executesql N'CREATE PROCEDURE dbo.GameWS_UserChannelPayLimit_Today_List AS BEGIN RETURN END';
GO
ALTER PROC dbo.GameWS_UserChannelPayLimit_Today_List
	 @ExMsg	nvarchar(max) OUT
AS
/* =============================================
-- ����: ������
-- ����: 2010-09-30
-- ����: ��ȡ�����б�
-- ����:
-- ʾ��:
DECLARE @rtn int;
EXEC @rtn = dbo.GameWS_UserChannelPayLimit_Today_List;
SELECT @rtn;
-- =============================================
*/
SET NOCOUNT ON;

SELECT ID, PayWay, Limit, _InTime, _Time
  FROM dbo.UserChannelPayLimit_Today

SELECT @ExMsg = '�б�ɹ���';
RETURN 1;
GO
GRANT EXECUTE ON [dbo].[GameWS_UserChannelPayLimit_Today_List] TO GameW
GO
