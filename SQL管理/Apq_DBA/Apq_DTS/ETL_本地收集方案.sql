SQL Server 从本地文件收集数据

在ETL过程中,数据传送需要解决以下问题:
1.数据缺失
2.传送失败(由于网络等非逻辑因素造成)
3.数据重复

本数据传送框架正是为了解决这些不确定因素带来的问题或麻烦,减轻DBA日常工作负担.

为了实现目标,本方案假定同一数据在同一收集时间只需要收集一次,即具有相同 数据配置名(CfgName)和收集时间(PickTime)的数据文件,我们认为是唯一的.
在本方案中,数据传送分为三个处理阶段.
1.本地收集阶段.
2.数据传送阶段.
3.数据过滤阶段.

三个阶段分别解决本文开始提出的三个问题.

1.本地收集:
	因为此阶段的操作均在本地,所在不考虑失败情况(除非硬件故障/空间不足等).
	对每个需要收集的数据在本地数据库建立固定周期定时作业.该作业统计/提取 当前周期内数据仓库需要的数据到本地文件(文本/压缩),代码中需要注意的是要采用NOLOCK.
	提取成功后记录收集日志(Apq_DBA.dbo.Log_DTS_LocalPick),同时Apq_DBA.dbo.DTS_Send表里提供PickLastID,PickLastTime两常用列用于记录该数据的最后收集ID/时间.

2.数据传送:
	数据传送重点解决传送失败问题.
	本方案选择失败重传的方式.
	故数据传送作业定义为5分钟运行一次,仅当确认传送已成功后才认为本次传送成功.
	具体过程为:
		1.作业启动后检查收集日志表(Apq_DBA.dbo.Log_DTS_LocalPick),如果有需要传送的记录存在,则开始数据传送.
		2.尝试根据Apq_DBA.dbo.DTS_Send表里设置的传送方式将待传文件传送,传送成功后在目标服务器上通过LinkServer记录传送日志([DW_Src].dbo.Log_DTS_Receive)
			仅当此步骤所有过程都成功后才修改收集日志表的传送时间列(TransTime),否则直接下一步.
		3.继续尝试下一文件传送.
		4.全部待传文件尝试一遍后作业退出,最多5分钟后将再次启动该过程.
	注意:
		推荐使用BCP方式,同时由于FTP进程在遇到异常后可能出现进程卡死的情况,故不建议使用此方式.
		
3.数据过滤:
	这阶段是由数据仓库来完成,仅提供统一的算法支持.
	数据接收库(示例名为DW_Src的数据库)中对每一数据建立 原始接收表(无任何索引), [可省略]过滤表(采用忽略重复的唯一索引).
	数据仓库加载数据,两种来源:1.过滤表 2.适当的 DISTINCT 原始接收表.

本方案中部分关键表的作用:
	Apq_DBA.dbo.Log_DTS_LocalPick:本地收集日志.此表里的文件若具有CfgName则需要传送.
	Apq_DBA.dbo.DTS_Send:传送配置表.设置传送方式,目标服务器等配置信息.
	[DW_Src]dbo.Log_DTS_Receive:数据接收日志.用于记录已成功接收到的数据文件.

后续:
采用SSIS实现主动收集形式的数据提取.
数据仓库加载数据前等待全部数据到位,通过[DW_Src]dbo.Log_DTS_Receive表判断.
