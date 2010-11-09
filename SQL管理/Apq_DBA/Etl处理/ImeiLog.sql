
-- 1.补队列
DECLARE @BTime datetime, @ETime datetime, @CTime datetime, @rtn int;
SELECT @BTime = '20101101'
SELECT @ETime = '20101108'

SELECT @CTime = @BTime;
WHILE(@CTime <= @ETime)
BEGIN
	SELECT @CTime = dateadd(hh,1,@CTime);
	EXEC @rtn = etl.Job_Etl_BcpIn_Init 10000,@CTime;
END

-- 2.启动一次Etl_BcpIn作业

-- 3.切换表
DECLARE @rtn int;
EXEC @rtn = etl.Etl_SwitchBcpTable 'ImeiLog';
SELECT @rtn;

-- 4.加载
DECLARE @rtn int;
EXEC @rtn = etl.Etl_Load 'ImeiLog';
SELECT @rtn;
