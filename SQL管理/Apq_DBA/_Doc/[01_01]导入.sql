
1.����:
	��������:
		bcp��ʽ���ı����(��ʱ��)
	
2.��Ҫ����:
	����Etl���ñ�(etl.EtlCfg),�����ļ�Ŀ¼�����Ƿ����µ��ļ�,����,���������ļ����뵼�����,Ȼ���¼��ʼ����־.
		������д�����ҵ��鵽��Ҫִ�е�����к�,���ݸ�������ִ�е��붯��,����ɹ���ɾ���ļ�.
	
3.��Ҫ��:
	etl.EtlCfg		��������
	etl.BcpInQueue	�������
	log.BcpInInit	��ʼ����־
	
4.�洢����:
	etl.Job_Etl_BcpIn_Init	ȷ����Ҫִ�е������,��ʼ������
	etl.Job_Etl_BcpIn		ִ�е���
	
5.��ҵ:
	Etl_BcpIn		������ҵ
	
6.����˵��:
	6.1) etl.EtlCfg
	
	EtlName						Etl������(��ĳһ����,�������ñ�����һ��ʱ�ɹ�����������,��������������,�Ͳ���ͬ��)
	Folder						�����ļ�Ŀ¼
	PeriodType					ʱ������{1:��,2:����,3:����,4:��,5:��,6:��,7:ʱ,8:��}
	FileName					�ļ���(ǰ׺)(��ʽ:FileName[ʱ��][SrvID].txt),ʱ�ڸ�ʽ{1:yyyy,2:yyyy01/07,3:yyyy01/04/07/09,4:yyyyMM,5:yyyyww,6:yyyyMMdd,7:yyyyMMdd_hh,8:yyyyMMdd_hhmm}
	DBName, SchemaName, TName	Ŀ���
	t							�зָ
	r							�зָ
