IF ( OBJECT_ID('dbo.Apq_WH_Init','P') IS NULL ) 
    EXEC sp_executesql N'CREATE PROCEDURE dbo.Apq_WH_Init AS BEGIN RETURN END' ;
GO
/* =============================================
-- ����: ������
-- ����: 2010-04-13
-- ����: ά����ҵ��ʼ��
-- ����: 1.���������ҵ 2.����ά����ҵ
-- ʾ��:
EXEC dbo.Apq_WH_Init
-- =============================================
*/
ALTER PROC dbo.Apq_WH_Init
AS
SET NOCOUNT ON ;

-- 1.���������ҵ
--EXEC msdb..sp_update_job @job_name = '��־ת��',@enabled = 0
DECLARE @job_name sysname
DECLARE @csr CURSOR
SET @csr = CURSOR FOR
SELECT name FROM msdb..sysjobs WHERE name LIKE '%��־�л�ת��'

OPEN @csr;
FETCH NEXT FROM @csr INTO @job_name
WHILE(@@FETCH_STATUS = 0)
BEGIN
	EXEC msdb..sp_update_job @job_name = @job_name,@enabled = 0

	FETCH NEXT FROM @csr INTO @job_name
END
CLOSE @csr;

-- 2.����ά����ҵ
EXEC msdb..sp_update_job @job_name = '����ά��',@enabled = 1

GO
