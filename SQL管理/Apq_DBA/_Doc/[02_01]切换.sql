
1.����:
	���л�(BCP����)
	
2.��Ҫ����:
	�����л����ñ�(etl.BcpSTableCfg),�����ļ�Ŀ¼�����Ƿ����µ��ļ�,����,���������ļ����뵼�����,Ȼ���¼��ʼ����־.
		������д�����ҵ��鵽��Ҫִ�е�����к�,���ݸ�������ִ�е��붯��,����ɹ���ɾ���ļ�.
	
3.��Ҫ��:
	etl.BcpSTableCfg	�л�����
	
4.�洢����:
	4.1) etl.Job_Etl_SwitchBcpTable	������Ҫִ���л�����,����(4.2)ִ���л�
	4.2) etl.Etl_SwitchBcpTable		ִ���л�
	
5.��ҵ:
	Etl_SwitchBcpTable		�л���ҵ
	
6.����˵��:
	6.1) etl.EtlCfg
	
	EtlName						������(�������ñ���Ҫ����һ��)
	Folder						�����ļ�Ŀ¼
	PeriodType					ʱ������{1:��,2:����,3:����,4:��,5:��,6:��,7:ʱ,8:��}
	FileName					�ļ���(ǰ׺)(��ʽ:FileName[ʱ��][SrvID].txt),ʱ�ڸ�ʽ{1:yyyy,2:yyyy01/07,3:yyyy01/04/07/09,4:yyyyMM,5:yyyyww,6:yyyyMMdd,7:yyyyMMdd_hh,8:yyyyMMdd_hhmm}
	DBName, SchemaName, TName	Ŀ���
	t							�зָ
	r							�зָ
