
1.����:
	ͨ��ncftp�ϴ��ļ�(δ֧�ֶϵ�����)
	
2.��Ҫ����:
	�����ϴ����б�(dbo.FTP_SendQueue),�����ϴ�����δ�ɹ�����,�ϴ��������ļ����Լ�ǰ׺"_up"��ʽ��ʶ,�ϴ��ɹ���ȥ����ǰ׺.
		�ϴ��ɹ���,�������Ƶ���ʷ����(log.FTP_SendQueue).
	�ж��ϴ��Ƿ�ɹ�:�ϴ���ɺ�������ȡԶ���ļ���С,�뱾���ļ��ļ���С�Ƚ�,��ͬ���ϴ��ɹ�.
	
3.��Ҫ��:
	dbo.FTP_SendQueue		�ϴ�����
	log.FTP_SendQueue		��ʷ��¼
	
4.�洢����:
	dbo.Job_FTP_Send		ִ���ϴ�
	
5.��ҵ:
	Apq_FTP_Send			FTP�ϴ�
	
6.����˵��:
	6.1) dbo.FTP_SendQueue
	
	Folder			�����ļ�Ŀ¼
	FileName		�ļ���
	
	FTPSrv			FTP������(IP)
	FTPPort			FTP�˿�
	U				�û���
	P				����
	FTPFolder		FTPĿ¼
