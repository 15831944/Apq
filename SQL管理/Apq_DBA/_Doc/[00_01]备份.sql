
1.����:
	���ݿⱸ��:�������ݻ���־����.
	
2.��Ҫ����:
	�����������ñ�(bak.BakCfg),��Ӧ��ִ�б��ݵ����ݿ�ReadAction��Ϊ1(��������)��2(��־����).
	�����������ñ�(bak.BakCfg)��ReadActionΪ1��2����,ִ����Ӧ���ݶ���.��ɺ�ReadActionȡ����Ӧλ.
		���������ļ�ɾ��:���ݱ����ļ���ɾ����ʷ�ļ�,Ȼ��ִ����������.
	�����������ñ�(bak.FTP_PutBak),��δ���͵ı����ļ�����FTP���Ͷ���,Ȼ���¼����ļ���.
	
3.��Ҫ��:
	bak.BakCfg				��������
	bak.FTP_PutBak			��������
	
4.�洢����:
	bak.Apq_Bak_Full		ִ����������
	bak.Apq_Bak_Trn			ִ����־����
	bak.Job_Apq_Bak_Init	������ҵ����,ȷ�����ݶ�������¼�ڱ������ñ�
	bak.Job_Apq_Bak			������ҵ����,������Ӧ���ݶ���
	bak.Job_Apq_Bak_FTP_Enqueue	�����ļ�������ҵ����,�����ļ�����FTP���Ͷ���
	
5.��ҵ:
	Apq_Bak					������ҵ
	Apq_Bak_FTP_Enqueue		�����ļ����뷢�Ͷ���
	
6.����˵��:
	6.1) bak.BakCfg
	
	DBName			���ݿ���
	FTPFolder		�����ļ�����ת���Ŀ¼�Ա�FTP����
	BakFolder		����Ŀ¼(��Ҫ������,��Ϊ����Ŀ¼)
	FTPFolderT		��ת�ļ���(���ܲ���,��Ҫ��FTPFolderλ��ͬһ����)
	
	FullTime		�״���������ʱ��(5���ӵı���ʱ���)
	FullCycle		������������(��)
	TrnCycle		��־��������(����,5�ı���)
	NeedTruncate	�Ƿ���Ҫ�ض���־	-- 2008���°汾��Ч,��������ǰִ��
	
	NeedRestore		�Ƿ���Ҫ��ԭ����ʷ��
	RestoreFolder	��ԭĿ¼
	DB_HisNum		��ʷ�Ᵽ������
	
	Num_Full		���������ļ���������(ͬʱ�������л������������ļ�����־�����ļ�)
	
	6.2) bak.FTP_PutBak
	
	DBName			���ݿ���
	Folder			�����ļ�Ŀ¼
	
	FTPSrv			FTP������(IP)
	FTPPort			FTP�˿�
	U				�û���
	P				����
	FTPFolder		FTPĿ¼
	
	TransferIDCfg	ָ��������ҵ���(һ����Ϊ1)
	
	Num_Full		���������ļ���������(ͬʱ�������л������������ļ�����־�����ļ�)
