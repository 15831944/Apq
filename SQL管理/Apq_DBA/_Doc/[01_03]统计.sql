
1.����:
	ִ��ͳ��
	
2.��Ҫ����:
	����ͳ�����ñ�(etl.StatCfg),��ͳ��ʱ���ѵ�����,������ݵ�λ���(Detect),�ɹ���ִ��ͳ�ƴ���(STMT),ͳ�Ƴɹ���¼ͳ����־,����ͳ�����ñ�����ִ��ʱ��.
	
3.��Ҫ��:
	etl.StatCfg		ͳ������
	etl.Log_Stat	ͳ����־
	
4.�洢����:
	etl.Job_Etl_Stat	ͳ����ҵ
	
5.��ҵ:
	Etl_Stat		ͳ����ҵ
	
6.����˵��:
	6.1) etl.StatCfg
	
	StatName					������(����EtlName��Ӧ�鿴)
	Detect						������ݵ�λ���,ͨ��ʱ����1(����:@StatName,@StartTime,@EndTime)
	STMT						ͳ�ƴ洢���̻�ͳ�����(����:@StartTime,@EndTime)
	FirstStartTime				ͳ�Ʋ���:��ʼʱ���ʼֵ
	
	Cycle						ͳ������(����)
	RTime						�״�ͳ��ִ��ʱ��
