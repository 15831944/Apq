IF ( OBJECT_ID('dbo.Apq_DataSync','P') IS NULL ) 
    EXEC sp_executesql N'CREATE PROCEDURE dbo.Apq_DataSync AS BEGIN RETURN END' ;
GO
IF ( NOT EXISTS ( SELECT    *
                  FROM      fn_listextendedproperty(N'MS_Description',
                                                    N'SCHEMA',N'dbo',
                                                    N'PROCEDURE',
                                                    N'Apq_DataSync',DEFAULT,
                                                    DEFAULT) )
   ) 
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',@value = N'',
        @level0type = N'SCHEMA',@level0name = N'dbo',
        @level1type = N'PROCEDURE',@level1name = N'Apq_DataSync'
EXEC sp_updateextendedproperty @name = N'MS_Description',@value = N'
-- 数据同步
-- 作者: 黄宗银
-- 日期: 2010-03-08
-- 示例:
DECLARE @rtn int;
EXEC @rtn = dbo.Apq_DataSync;
SELECT @rtn;
',@level0type = N'SCHEMA',@level0name = N'dbo',@level1type = N'PROCEDURE',
    @level1name = N'Apq_DataSync' ;
GO
ALTER PROC dbo.Apq_DataSync
AS 
SET NOCOUNT ON ;

DECLARE @ExMsg nvarchar(4000)
   ,@rtn int
   ,@sql nvarchar(4000) ;

--定义游标
DECLARE @csr CURSOR ;
SET @csr=CURSOR FOR
SELECT TOP 1000 [ID],[DataType],[DataOwner],[EnTime],[DataKey],[OldValue],[NewValue],[RedoTimes],[RSP],SrvID,[LastSyncTime],[LastError]
FROM    dbo.DataSyncQueue t
WHERE t.RedoTimes > 0 AND NOT EXISTS(SELECT TOP 1 1 FROM dbo.DataSyncQueue d WHERE d.DataOwner = t.DataOwner AND d.DataKey = t.DataKey AND d.RedoTimes <= 0)
AND NOT EXISTS(SELECT TOP 1 1 FROM dbo.RSrvConfig r WHERE r.SrvID = t.SrvID AND r.LSState = 0)
ORDER BY EnTime;

DECLARE @ID bigint
   ,@DataType [int]
   ,@DataOwner [nvarchar](50)
   ,@EnTime [datetime]
   ,@DataKey [nvarchar](50)
   ,@OldValue [nvarchar](max)
   ,@NewValue [nvarchar](max)
   ,@RedoTimes [int]
   ,@RSP [nvarchar](512)
   ,@SrvID bigint
   ,@LastSyncTime [datetime]
   ,@LastError [nvarchar](max) ;
   
OPEN @csr ;
FETCH NEXT FROM @csr INTO @ID,@DataType,@DataOwner,@EnTime,@DataKey,@OldValue,@NewValue,@RedoTimes,@RSP,@SrvID,@LastSyncTime,@LastError ;
WHILE ( @@FETCH_STATUS = 0 ) 
    BEGIN
        IF ( NOT EXISTS ( SELECT TOP 1
                                    1
                          FROM      dbo.RSrvConfig r
                          WHERE     r.SrvID = @SrvID
                                    AND r.LSState = 0 )
           ) 
            BEGIN
                BEGIN TRY
                    SELECT  @sql = 'EXEC ' + @RSP
                            + ' @DataOwner=@DataOwner,@DataKey=@DataKey,@OldValue=@OldValue,@NewValue=@NewValue' ;
                    EXEC @rtn = sp_executesql @sql,
                        N'@DataOwner nvarchar(50),@DataKey nvarchar(50),@OldValue nvarchar(max),@NewValue nvarchar(max)',
                        @DataOwner = @DataOwner,@DataKey = @DataKey,
                        @OldValue = @OldValue,@NewValue = @NewValue ;
                    IF ( @@ERROR = 0
                         AND @rtn = 0
                       ) 
                        BEGIN
							-- 转历史,出队
                            INSERT  dbo.DataSyncQueue_His ( [_InTime],DataType,
                                                            DataOwner,EnTime,
                                                            DataKey,OldValue,
                                                            NewValue,RedoTimes,
                                                            RSP,SrvID,
                                                            LastSyncTime,
                                                            LastError )
                                    SELECT  getdate(),@DataType,@DataOwner,
                                            @EnTime,@DataKey,@OldValue,
                                            @NewValue,@RedoTimes,@RSP,@SrvID,
                                            @LastSyncTime,@LastError ;
				
                            DELETE  dbo.DataSyncQueue
                            WHERE   ID = @ID ;
                        
							-- 重置该服务器的错误次数
                            UPDATE  dbo.RSrvConfig
                            SET     LSErrTimes = 0
                            WHERE   SrvID = @SrvID
                                    AND LSErrTimes > 0
                        END
                END TRY
                BEGIN CATCH
                    UPDATE  dbo.DataSyncQueue
                    SET     LastSyncTime = getdate(),
                            LastError = Error_message()
                    WHERE   ID = @ID ;
                    IF ( Error_number() IN ( 10060,10061-- 连接问题
						,18456,18752 -- 登录问题
						) ) 
                        BEGIN
                            UPDATE  dbo.RSrvConfig
                            SET     LSState = 0
                            WHERE   SrvID = @SrvID
                                    AND LSErrTimes = LSMaxTimes
                            IF ( @@ROWCOUNT = 0 ) 
                                UPDATE  dbo.RSrvConfig
                                SET     LSErrTimes = LSErrTimes + 1
                                WHERE   SrvID = @SrvID ;
                        END
                    ELSE 
                        UPDATE  dbo.DataSyncQueue
                        SET     RedoTimes = RedoTimes - 1
                        WHERE   ID = @ID ;
                END CATCH
            END
        FETCH NEXT FROM @csr INTO @ID,@DataType,@DataOwner,@EnTime,@DataKey,@OldValue,@NewValue,@RedoTimes,@RSP,@SrvID,@LastSyncTime,@LastError ;
    END
CLOSE @csr ;
GO
