IF ( OBJECT_ID('dbo.p_lockinfo','P') IS NULL ) 
    EXEC sp_executesql N'CREATE PROCEDURE dbo.p_lockinfo AS BEGIN RETURN END' ;
GO
IF ( NOT EXISTS ( SELECT    *
                  FROM      fn_listextendedproperty(N'MS_Description',N'SCHEMA',N'dbo',N'PROCEDURE',N'p_lockinfo',DEFAULT,DEFAULT) )
   ) 
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',@value = N'',@level0type = N'SCHEMA',@level0name = N'dbo',@level1type = N'PROCEDURE',
        @level1name = N'p_lockinfo'
EXEC sp_updateextendedproperty @name = N'MS_Description',@value = N'
/*--����BLOCK
 �鿴��ǰ����,��BLOCK����,�����Զ�ɱ��������
 ��Ϊ�����block��,���������block����,ֻ�ܲ鿴block����
 ��Ȼ,�����ͨ����������,������û��block,��ֻ�鿴block����
 ��л: caiyunxia,jiangopen ��λ�ṩ�Ĳο���Ϣ
--�޽� 2004.4(�����뱣������Ϣ)--*/
/*--����ʾ��
EXEC dbo.p_lockinfo 0, 1
--*/
',@level0type = N'SCHEMA',@level0name = N'dbo',@level1type = N'PROCEDURE',@level1name = N'p_lockinfo' ;
GO
ALTER PROC p_lockinfo
    @kill_lock_spid tinyint = 0  --�Ƿ�ɱ��block�Ľ���,1 ɱ��, 0 ����ʾ
   ,@show_spid_if_nolock tinyint = 1 --���û��block�Ľ���,�Ƿ���ʾ����������Ϣ,1 ��ʾ,0 ����ʾ
AS 
SET NOCOUNT ON
DECLARE @count int
   ,@s nvarchar(4000)
   ,@i int
SELECT  id = IDENTITY( bigint,1,1),��־,����ID = spid,�߳�ID = kpid,�����ID = blocked,���ݿ�ID = dbid,���ݿ��� = db_name(dbid),�û�ID = uid,�û��� = CONVERT(nvarchar(128),loginame),
        �ۼ�CPUʱ�� = cpu,��½ʱ�� = login_time,�������� = open_tran,����״̬ = CONVERT(nvarchar(30),status),����վ�� = CONVERT(nvarchar(128),hostname),
        Ӧ�ó����� = CONVERT(nvarchar(128),program_name),����վ����ID = CONVERT(nvarchar(10),hostprocess),���� = CONVERT(nvarchar(128),nt_domain),
        ������ַ = CONVERT(nvarchar(12),net_address)
INTO    #t
FROM    ( SELECT    ��־ = '|_����Ʒ(��BLOCK)_>',spid,kpid,blocked,dbid,uid,loginame,cpu,login_time,open_tran,status,hostname,program_name,hostprocess,nt_domain,
                    net_address,s1 = blocked,s2 = 1
          FROM      master..sysprocesses a
          WHERE     blocked <> 0
          UNION ALL
          SELECT    'BLOCK�Ľ���',spid,kpid,a.blocked,dbid,uid,loginame,cpu,login_time,open_tran,status,hostname,program_name,hostprocess,nt_domain,
                    net_address,s1 = a.spid,s2 = 0
          FROM      master..sysprocesses a
                    JOIN ( SELECT   blocked
                           FROM     master..sysprocesses
                           GROUP BY blocked
                         ) b
                        ON a.spid = b.blocked
          WHERE     a.blocked = 0
        ) a
ORDER BY s1,s2
SELECT  @count = @@rowcount,@i = 1
IF @count = 0
    AND @show_spid_if_nolock = 1 
    BEGIN
        INSERT  #t
                SELECT  ��־ = '�����Ľ���',spid,kpid,blocked,dbid,db_name(dbid),uid,loginame,cpu,login_time,open_tran,status,hostname,program_name,hostprocess,
                        nt_domain,net_address
                FROM    master..sysprocesses
        SET @count = @@rowcount
    END
IF @count > 0 
    BEGIN
        CREATE TABLE #t1 (
             id bigint IDENTITY(1,1)
            ,a nvarchar(50)
            ,b bigint
            ,EventInfo nvarchar(max)
            )
        IF @kill_lock_spid = 1 
            BEGIN
                DECLARE @spid varchar(10)
                   ,@��־ varchar(10)
                WHILE @i <= @count 
                    BEGIN
                        SELECT  @spid = ����ID,@��־ = ��־
                        FROM    #t
                        WHERE   id = @i
                        INSERT  #t1
                                EXEC ( 'DBCC INPUTBUFFER(' + @spid + ')'
                                    )
                        IF @@rowcount = 0 
                            INSERT  #t1 ( a )
                            VALUES  ( NULL )
                        IF @��־ = 'BLOCK�Ľ���' 
                            EXEC('kill '+@spid)
                        SET @i = @i + 1
                    END
            END
        ELSE 
            WHILE @i <= @count 
                BEGIN
                    SELECT  @s = 'DBCC INPUTBUFFER(' + cast(����ID AS varchar) + ')'
                    FROM    #t
                    WHERE   id = @i
                    INSERT  #t1
                            EXEC ( @s
                                )
                    IF @@rowcount = 0 
                        INSERT  #t1 ( a )
                        VALUES  ( NULL )
                    SET @i = @i + 1
                END
        SELECT  a.*,���̵�SQL��� = b.EventInfo
        FROM    #t a
                JOIN #t1 b
                    ON a.id = b.id
        ORDER BY ����ID
    END

