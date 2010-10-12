IF ( OBJECT_ID('dbo.p_who_lock','P') IS NULL ) 
    EXEC sp_executesql N'CREATE PROCEDURE dbo.p_who_lock AS BEGIN RETURN END' ;
GO
IF ( NOT EXISTS ( SELECT    *
                  FROM      fn_listextendedproperty(N'MS_Description',N'SCHEMA',N'dbo',N'PROCEDURE',N'p_who_lock',DEFAULT,DEFAULT) )
   ) 
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',@value = N'',@level0type = N'SCHEMA',@level0name = N'dbo',@level1type = N'PROCEDURE',
        @level1name = N'p_who_lock'
EXEC sp_updateextendedproperty @name = N'MS_Description',@value = N'
/********************************************************
//������ : fengyu���ʼ� : maggiefengyu@tom.com
//������ :2004-04-30
//���޸� : ��http://www.csdn.net/develop/Read_Article.asp?id=26566
//��ѧϰ������д
//��˵�� : �鿴���ݿ����������������
********************************************************/
',@level0type = N'SCHEMA',@level0name = N'dbo',@level1type = N'PROCEDURE',@level1name = N'p_who_lock' ;
GO
ALTER PROC p_who_lock
AS 
SET NOCOUNT ON
 
DECLARE @spid int
   ,@bl int
   ,@intTransactionCountOnEntry int
   ,@intRowcount int
   ,@intCountProperties int
   ,@intCounter int
CREATE TABLE #tmp_lock_who (
     id int IDENTITY(1,1)
    ,spid smallint
    ,bl smallint
    )
IF @@ERROR <> 0 
    RETURN @@ERROR
INSERT  INTO #tmp_lock_who ( spid,bl )
        SELECT  0,blocking_session_id
        FROM    ( SELECT * FROM master.sys.dm_exec_requests WHERE blocking_session_id> 0
                ) a
        WHERE   NOT EXISTS ( SELECT *
                             FROM   ( SELECT * FROM master.sys.dm_exec_requests WHERE blocking_session_id> 0
                                    ) b
                             WHERE  a.blocking_session_id = b.session_id )
        UNION
        SELECT  session_id,blocking_session_id
        FROM    master.sys.dm_exec_requests
        WHERE   blocking_session_id > 0
IF @@ERROR <> 0 
    RETURN @@ERROR
-- �ҵ���ʱ��ļ�¼��
SELECT  @intCountProperties = Count(*),@intCounter = 1
FROM    #tmp_lock_who
IF @@ERROR <> 0 
    RETURN @@ERROR
IF @intCountProperties = 0 
    SELECT  '����û��������������Ϣ' AS message
-- ѭ����ʼ
WHILE @intCounter <= @intCountProperties 
    BEGIN
		-- ȡ��һ����¼
        SELECT  @spid = spid,@bl = bl
        FROM    #tmp_lock_who
        WHERE   Id = @intCounter
        BEGIN
            IF @spid = 0 
                SELECT  '�������ݿ���������: ' + CAST(@bl AS varchar(10)) + '���̺�,��ִ�е�SQL�﷨����'
            ELSE 
                SELECT  '���̺�SPID��' + CAST(@spid AS varchar(10)) + '��' + '���̺�SPID��' + CAST(@bl AS varchar(10)) + '����,�䵱ǰ����ִ�е�SQL�﷨����'
            DBCC INPUTBUFFER (@bl )
        END
		-- ѭ��ָ������
        SET @intCounter = @intCounter + 1
    END
DROP TABLE #tmp_lock_who
RETURN 0
