
1.����ʱ����,һ��30�뵽2����
2.SET ARITHABORT ON -- ��������ʱ��ֹ��ѯ,OFF����NULLΪ�������.
3.����ʹ�� NOLOCK,READPAST ����ʾ.
4.��ѯ��������(��)
	SET QUERY_GOVERNOR_COST_LIMIT 60	-- 1����
5.ָ�����ȴ����ͷŵĺ�����
	SET LOCK_TIMEOUT -1	-- Ĭ��-1���޵ȴ�,������Ϊ30��(30000)

�������
6.SET CURSOR_CLOSE_ON_COMMIT ON -- ���ύ��ع�ʱ�ر����д򿪵��α�,һ������ΪOFF
7.SET XACT_ABORT ON	-- ���д���ʱ,�Զ��ع���ǰ����,��ǰ��ѯ������ʱһ������ΪON

8.SET DATEFIRST 7	-- ������Ϊÿ�ܵĵ�һ��

9.�����������ȼ�
	SET DEADLOCK_PRIORITY @n	-- @n:[-10,10],��������ʱԽСԽ���ܱ�����{LOW:-5,NORMAL:0,HIGH:5}
	
10.SET FMTONLY ON	-- ֻ��Ԫ���ݷ��ظ��ͻ���,����ʵ��ִ�в�ѯ

11.������书��ʵ��
	SET PARSEONLY ON	-- ֻ����������
	SET NOEXEC ON	-- ֻ���벻ִ��,������ʵ������"����"�Ĺ���.
	
12.��ѯͳ����Ϣ
	SET STATISTICS IO ON	-- ��ʾ�йش��̻������Ϣ
	SET STATISTICS TIME ON	-- ��ʾ�����������ִ�и��������ĺ�����
	

ʹ�������й��������Ż�:
SET QUERY_GOVERNOR_COST_LIMIT 30
SET LOCK_TIMEOUT 750
SET DEADLOCK_PRIORITY @n	-- ��̨��:-5,��̨д:-1
SET XACT_ABORT ON	-- ������ʱʹ�ø����
