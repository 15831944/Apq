
/*
DBCC SQLPERF(LOGSPACE)					-- �鿴��־�ļ��ռ����(�ٷֱ�)
DBCC SRHINKFILE('LogFileGroupName')		-- ������־����ʾ�ռ����

-- �鿴�����ļ��ռ����
SELECT DB_NAME() AS DbName,name AS FileName,size/128.0 AS CurrentSizeMB,size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0 AS FreeSpaceMB
  FROM sys.database_files
*/

/*
-- 
EXEC sp_spaceused @updateusage = 'TRUE'
--sp_MSforeachdb	-- ��ÿ����
--sp_MSforeachtable	-- ��ÿ����
*/

-- �鿴���б�ռ�ʹ�����
CREATE TABLE #T(
	name		nvarchar(256),
	rows		varchar(11),
	reserved	varchar(18),
	data		varchar(18),
	index_size	varchar(18),
	unused		varchar(18)
);
INSERT #T(name,rows,reserved,data,index_size,unused)
EXEC sp_MSforeachtable "EXEC sp_spaceused '?',true";
-- ��Ϸ��
SELECT FGameDB.dbo.Apq_Ext_Get('',0,'��������'), * FROM #T ORDER BY Convert(int,SubString(reserved,1,Len(reserved)-3)) DESC;
-- ����
SELECT FGameAreaDB.dbo.Apq_Ext_Get('',0,'��������'), * FROM #T ORDER BY Convert(int,SubString(reserved,1,Len(reserved)-3)) DESC;
-- ����
SELECT * FROM #T ORDER BY Convert(int,SubString(reserved,1,Len(reserved)-3)) DESC;
DROP TABLE #T;
