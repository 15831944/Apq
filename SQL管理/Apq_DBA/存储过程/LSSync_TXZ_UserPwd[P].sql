IF ( OBJECT_ID('dbo.LSSync_TXZ_UserPwd','P') IS NULL ) 
    EXEC sp_executesql N'CREATE PROCEDURE dbo.LSSync_TXZ_UserPwd AS BEGIN RETURN END' ;
GO
IF ( NOT EXISTS ( SELECT    *
                  FROM      fn_listextendedproperty(N'MS_Description',
                                                    N'SCHEMA',N'dbo',
                                                    N'PROCEDURE',
                                                    N'LSSync_TXZ_UserPwd',
                                                    DEFAULT,DEFAULT) )
   ) 
    EXEC sys.sp_addextendedproperty @name = N'MS_Description',@value = N'',
        @level0type = N'SCHEMA',@level0name = N'dbo',
        @level1type = N'PROCEDURE',@level1name = N'LSSync_TXZ_UserPwd'
EXEC sp_updateextendedproperty @name = N'MS_Description',@value = N'
-- 数据同步_用户名密码
-- 作者: 黄宗银
-- 日期: 2010-03-10
-- 示例:
DECLARE @rtn int, @ExMsg nvarchar(max);
EXEC @rtn = dbo.LSSync_TXZ_UserPwd @ExMsg out, 1, DEFAULT, ''127019'',''User1'',''User1'';
SELECT @rtn,@ExMsg;
',@level0type = N'SCHEMA',@level0name = N'dbo',@level1type = N'PROCEDURE',
    @level1name = N'LSSync_TXZ_UserPwd' ;
GO
ALTER PROC [dbo].[LSSync_TXZ_UserPwd]
    @DataOwner [nvarchar](50) = 'User'
   ,@DataKey [nvarchar](50)
   ,@OldValue [nvarchar](max)
   ,@NewValue [nvarchar](max)
AS 
SET NOCOUNT ON ;

IF ( @DataOwner IS NULL ) 
    SELECT  @DataOwner = 'User' ;

DECLARE @rtn int
   ,@sql nvarchar(4000) ;
-- 测试无需处理	
RETURN 1 ;
GO
