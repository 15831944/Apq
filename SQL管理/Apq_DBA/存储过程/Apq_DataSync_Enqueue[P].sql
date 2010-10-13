IF ( OBJECT_ID('dbo.Apq_DataSync_Enqueue','P') IS NULL ) 
    EXEC sp_executesql N'CREATE PROCEDURE dbo.Apq_DataSync_Enqueue AS BEGIN RETURN END' ;
GO
IF ( NOT EXISTS ( SELECT    *
                  FROM      fn_listextendedproperty(N'MS_Description',N'SCHEMA',N'dbo',N'PROCEDURE',N'Apq_DataSync_Enqueue',DEFAULT,DEFAULT) )
   ) 
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',@value = N'',@level0type = N'SCHEMA',@level0name = N'dbo',@level1type = N'PROCEDURE',
        @level1name = N'Apq_DataSync_Enqueue'
EXEC sp_updateextendedproperty @name = N'MS_Description',@value = N'
-- 数据同步_入队
-- 作者: 黄宗银
-- 日期: 2010-03-08
-- 示例:
DECLARE @rtn int, @ExMsg nvarchar(max);
EXEC @rtn = dbo.Apq_DataSync_Enqueue @ExMsg out, 1, DEFAULT, ''127019'',''User1'',''User1'';
SELECT @rtn,@ExMsg;
',@level0type = N'SCHEMA',@level0name = N'dbo',@level1type = N'PROCEDURE',@level1name = N'Apq_DataSync_Enqueue' ;
GO
ALTER PROC [dbo].[Apq_DataSync_Enqueue]
    @ExMsg nvarchar(max) OUT
   ,@DataType int
   ,@DataOwner [nvarchar](50) = 'User'
   ,@DataKey [nvarchar](50)
   ,@OldValue [nvarchar](max)
   ,@NewValue [nvarchar](max)
AS 
SET NOCOUNT ON ;

IF ( @DataOwner IS NULL ) 
    SELECT  @DataOwner = 'User' ;

DECLARE @rtn int
   ,@sql nvarchar(4000) ;
	
IF ( NOT EXISTS ( SELECT    [DataType],[RDBType],[RDBID],[SPName]
                  FROM      dbo.DataSyncQueue_DataType
                  WHERE     DataType = @DataType )
   ) 
    BEGIN
        SELECT  @ExMsg = '不存在的数据同步类型' ;
        RETURN -1 ;
    END

-- 以 RDBType 分别处理
-- 0.指定数据库
INSERT  dbo.DataSyncQueue ( DataType,DataOwner,DataKey,OldValue,NewValue,RSP,SrvID )
        SELECT  @DataType,@DataOwner,@DataKey,@OldValue,@NewValue,LSName + '.' + DBName + '.' + SPName,c1.SrvID
        FROM    DataSyncQueue_DataType t
                INNER JOIN dbo.RDBConfig c1
                    ON c1.RDBID = t.RDBID
                INNER JOIN dbo.RSrvConfig s
                    ON c1.SrvID = s.SrvID
        WHERE   DataType = @DataType
                AND c1.RDBType = 0
                AND c1.Enabled = 1
                AND s.Enabled = 1
                
-- 其余按数据所有者类型分别处理

-- User:分发到用户已激活游戏的已登录的服库
IF ( @DataOwner = 'User' ) 
    BEGIN
        DECLARE @UserID int ;
        SELECT  @UserID = CONVERT(int,@DataKey) ;
        INSERT  dbo.DataSyncQueue ( DataType,DataOwner,DataKey,OldValue,NewValue,RSP,SrvID )
                SELECT  @DataType,@DataOwner,@DataKey,@OldValue,@NewValue,LSName + '.' + DBName + '.' + SPName,c1.SrvID
                FROM    DataSyncQueue_DataType t
                        INNER JOIN dbo.RDBConfig c1
                            ON c1.RDBType = t.RDBType
                        INNER JOIN dbo.RSrvConfig s
                            ON c1.SrvID = s.SrvID
                        INNER JOIN dbo.Game_UserActivated a-- 已激活的游戏
                            ON a.GameID = c1.GameID
                WHERE   DataType = @DataType
                        AND c1.RDBType <> 0
						AND c1.Enabled = 1
						AND s.Enabled = 1
                        AND a.UserID = @UserID
                        AND EXISTS(SELECT TOP 1 1 FROM dbo.GameMacLock gl-- 已登录的服
							WHERE gl.UserID = a.UserID AND gl.WorldName = c1.RDBDesc)
    END
RETURN 1 ;
GO
