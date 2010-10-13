USE master;
GO
IF( OBJECT_ID('dbo.Apq_LogTrans_Half', 'P') IS NULL )
	EXEC sp_executesql N'CREATE PROCEDURE dbo.Apq_LogTrans_Half AS BEGIN RETURN END';
GO
/* =============================================
-- ����: ������
-- ����: 2008-01-16
-- ����: ��־ת��(��Դ����ǰ30����ʹ��1,��30����ʹ��2)
-- ʾ��:
DECLARE @rtn int, @ExMsg nvarchar(4000), @Now datetime, @mn int, @TableNo int;
SELECT @Now = getdate();
SELECT @mn = DatePart(n, @Now);
SELECT @TableNo = CASE @mn/30 WHEN 0 THEN 2 WHEN 1 THEN 1 END;	-- (1+@mn/30): ��ǰ����д��ı���; @TableNo: ����ת�Ƶı���
EXEC @rtn = master.dbo.Apq_LogTrans_Half 'FGameDB', 'FGameDB_Log', 'dbo.Log_Family', @TableNo, 'FamilyID,Name,CreaterActorName,ShaikhActorID,Title,Enounce,Daily,IconId,Money,NPCCount,Grade,Credit,AutoDisCont1,AutoDisCont2,Birthday,State,KickFrom,KickTo,KickTime,ApplyShaikhID,ApplyShaikhTime,ApplyDisTime,_Time,_Reason,_OperID,_LogTime,NPCTimeSpan';
SELECT @rtn;
-- =============================================
*/
ALTER PROC dbo.Apq_LogTrans_Half
	--@ExMsg nvarchar(4000) out,
	@DBFrom		nvarchar(256),			-- ��Դ����
	@DBTo		nvarchar(256),			-- Ŀ�����
	@TableName	nvarchar(640),			-- ����(���ܹ���),����"1"��"2"��Ϊ��ǰ��ʱд�����������
	@TableNo	int,
	@ColsFrom	nvarchar(4000) = '*'	-- �����б�
AS
SET NOCOUNT ON;

DECLARE @ColsTo nvarchar(4000);
IF(@ColsFrom IS NULL OR @ColsFrom = '')
BEGIN
	SELECT @ColsFrom = '*';
END
SELECT @ColsTo = '(' + @ColsFrom + ')';
IF(@ColsFrom = '*')
BEGIN
	SELECT @ColsTo = '';
END

DECLARE @sql nvarchar(4000);

SELECT @sql = '
INSERT ^DBTo$.^TableName$^ColsTo$
SELECT ^ColsFrom$ FROM ^DBFrom$.^TableName$^TableNo$;
IF(@@ERROR=0)
BEGIN
	TRUNCATE TABLE ^DBFrom$.^TableName$^TableNo$;
END
';
SELECT @sql = REPLACE(@sql,'^DBFrom$', @DBFrom);
SELECT @sql = REPLACE(@sql,'^DBTo$', @DBTo);
SELECT @sql = REPLACE(@sql,'^TableName$', @TableName);
SELECT @sql = REPLACE(@sql,'^TableNo$', @TableNo);
SELECT @sql = REPLACE(@sql,'^ColsFrom$', @ColsFrom);
SELECT @sql = REPLACE(@sql,'^ColsTo$', @ColsTo);
--SELECT @sql;
EXEC sp_executesql @sql;
GO
