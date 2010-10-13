IF( OBJECT_ID('dbo.Apq_Identifier', 'P') IS NULL )
	EXEC sp_executesql N'CREATE PROCEDURE dbo.Apq_Identifier AS BEGIN RETURN END';
GO
ALTER PROC dbo.Apq_Identifier
	 @ExMsg nvarchar(MAX) out

	,@Name	nvarchar(256)	-- 自增名
	,@Count	bigint = 1		-- 增长次数

	,@Next	bigint = 1 out	-- 可以使用的首个值
AS
SET NOCOUNT ON;
/* =============================================
-- 作者: 黄宗银
-- 日期: 2008-02-26
-- 描述: 自增, 范围:(Init, Limit]
-- 示例:
DECLARE	@err int, @rtn int, @Next bigint, @ExMsg nvarchar(MAX);
EXEC @rtn = dbo.Apq_Identifier @ExMsg out, N'Apq_String', 1, @Next out;
SELECT @err = @@ERROR;
SELECT @err, @rtn, @Next, @ExMsg;
-- =============================================
10: 无可分配值
11: 超出当前自增范围
*/

SELECT @Next = ISNULL(@Next,1);

DECLARE	@ID bigint, @Limit bigint, @Inc bigint, @End bigint;
SELECT @Limit = 9223372034707292160;

-- 查找第一条用于分配ID的行
SELECT TOP 1 @ID = ID
  FROM Apq_ID
 WHERE Name = @Name AND State = 0;
IF(@@ROWCOUNT = 0)
BEGIN
	IF(EXISTS(SELECT TOP 1 1 FROM Apq_ID WHERE Name = @Name AND State = 1))
	BEGIN
		SELECT @ExMsg = '自增名"' + @Name + '"已无可分配值!';
		RETURN -1;
	END
	ELSE
	BEGIN
		-- 提取自动初始化行,失败则不能分配
		UPDATE Apq_ID SET @ID = ID, State = 0 WHERE Name = @Name AND State = 2;
		IF(@@ROWCOUNT = 0)
		BEGIN
			SELECT @ExMsg = '自增名"' + @Name + '"未配置!';
			RETURN -1;
		END
	END
END

-- 尝试分配ID
UPDATE Apq_ID
   SET _Time = getdate(), @Limit = Limit, @Inc = Inc, @Next = Inc + Crt, @End = Crt = Inc * @Count + Crt
 WHERE ID = @ID;

IF((@Inc > 0 AND @End > @Limit) OR (@Inc < 0 AND @End < @Limit))
BEGIN
	UPDATE Apq_ID
	   SET State = 1
	 WHERE ID = @ID;

	SELECT @ExMsg = '超出当前自增范围,请重试!';
	RETURN -1;
END

RETURN 1;
GO
EXEC dbo.Apq_Def_EveryDB 'dbo', 'Apq_Identifier', DEFAULT
GO
