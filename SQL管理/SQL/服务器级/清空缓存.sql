
-- ��ѯִ�мƻ�
SELECT plan_handle, st.text
  FROM sys.dm_exec_cached_plans 
	CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS st
 WHERE text LIKE N'SELECT * FROM Person.Address%';


DBCC FREEPROCCACHE([plan_handle]/'default');	-- ָ��(������)�洢�������±���,��������ִ�мƻ�
DBCC DROPCLEANBUFFERS;		-- ������л���(д��Ӳ��)
DBCC FREESYSTEMCACHE('ALL')	-- ���ϵͳ����(�洢����&������)
