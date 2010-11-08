
USE master
GO

/*
修复孤立用户
EXEC sp_change_users_login 'Auto_Fix', 'VcWb';
EXEC sp_change_users_login 'Update_One', 'VcWb', 'VcWb';
*/

-- sa 改名 -----------------------------------------------------------------------------------------
IF(EXISTS(SELECT TOP 1 * FROM sys.syslogins WHERE name = 'sa'))
	ALTER LOGIN sa WITH NAME = sx	-- UM
GO

-- 创建Windows登录 ---------------------------------------------------------------------------------
-- 添加Windows管理员组并设为Sql管理员
IF(NOT EXISTS(SELECT TOP 1 * FROM sys.syslogins WHERE name = 'BUILTIN\administrators'))
BEGIN
	CREATE LOGIN [BUILTIN\administrators] FROM WINDOWS
	EXEC master..sp_addsrvrolemember @loginame = N'BUILTIN\administrators', @rolename = N'sysadmin'
END
IF(NOT EXISTS(SELECT TOP 1 * FROM sys.syslogins WHERE name = 'BUILTIN\Performance Log Users'))
	CREATE LOGIN [BUILTIN\Performance Log Users] FROM WINDOWS

IF(NOT EXISTS(SELECT TOP 1 * FROM sys.syslogins WHERE name = 'NT AUTHORITY\NETWORK SERVICE'))
	CREATE LOGIN [NT AUTHORITY\NETWORK SERVICE] FROM WINDOWS

IF(NOT EXISTS(SELECT TOP 1 * FROM sys.syslogins WHERE name = 'NT AUTHORITY\SYSTEM'))
	CREATE LOGIN [NT AUTHORITY\SYSTEM] FROM WINDOWS

-- 重建固定SID登录 ---------------------------------------------------------------------------------
IF(EXISTS(SELECT TOP 1 * FROM sys.syslogins WHERE name = 'limingzhe')) DROP LOGIN limingzhe;
CREATE LOGIN limingzhe WITH PASSWORD = N'muE2dhvyTjMHCtR4', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF, SID = 0x697BC82D93A7C74B836AA741C4D05A46;


IF(EXISTS(SELECT TOP 1 * FROM sys.syslogins WHERE name = 'BcpIn')) DROP LOGIN BcpIn;
CREATE LOGIN BcpIn WITH PASSWORD = N'm6hvdNCRMAJ71059', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF, SID = 0x45AF6DA7BA5D0C47A3B1198F22E1000B;

IF(EXISTS(SELECT TOP 1 * FROM sys.syslogins WHERE name = 'LinkIn')) DROP LOGIN LinkIn;
CREATE LOGIN LinkIn WITH PASSWORD = N'ucw81R3AdFDe2NEh', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF, SID = 0xFA488300C7EE6A4591D33BEAD66C5976;


IF(EXISTS(SELECT TOP 1 * FROM sys.syslogins WHERE name = 'Web')) DROP LOGIN Web;
CREATE LOGIN Web WITH PASSWORD = N'AcfGE4j81MRhB57i', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF, SID = 0xB7BEF97DBD3A9C468F8E098897BE2F2C;

IF(EXISTS(SELECT TOP 1 * FROM sys.syslogins WHERE name = 'Web_Bg')) DROP LOGIN Web_Bg;
CREATE LOGIN Web_Bg WITH PASSWORD = N'iAE9Cjeum6BnaG8v', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF, SID = 0xBAA9F7C874F6F74CAB3D1C97CDC24B4E;

IF(EXISTS(SELECT TOP 1 * FROM sys.syslogins WHERE name = 'Web_WS')) DROP LOGIN Web_WS;
CREATE LOGIN Web_WS WITH PASSWORD = N'JEkunAGrLBYW91t6', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF, SID = 0xD42D3E7C161A9C49AA1D87DED20877E5;


IF(EXISTS(SELECT TOP 1 * FROM sys.syslogins WHERE name = 'VcWb')) DROP LOGIN VcWb;
CREATE LOGIN VcWb WITH PASSWORD = N'xDr3RFpmG7cBWJd1', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF, SID = 0xD8F517F200CE564F839C52AF51627A63;
IF(EXISTS(SELECT TOP 1 * FROM sys.syslogins WHERE name = 'VpWs')) DROP LOGIN VpWs;
CREATE LOGIN VpWs WITH PASSWORD = N'JTh3xW9euMciHNC2', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF, SID = 0x97C53C65C185054092DE0A0CEAC91124;
IF(EXISTS(SELECT TOP 1 * FROM sys.syslogins WHERE name = 'Pay')) DROP LOGIN Pay;
CREATE LOGIN Pay WITH PASSWORD = N'26uCBdYtF1imkLva', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF, SID = 0x7531B6071A6485499256281857200C68;
IF(EXISTS(SELECT TOP 1 * FROM sys.syslogins WHERE name = 'Pay2')) DROP LOGIN Pay2;
CREATE LOGIN Pay2 WITH PASSWORD = N'WvEy3tda4JTf5Lwr', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF, SID = 0x1BE583F0027763418E37C6F01A03BB5C;
IF(EXISTS(SELECT TOP 1 * FROM sys.syslogins WHERE name = 'PayWs')) DROP LOGIN PayWs;
CREATE LOGIN PayWs WITH PASSWORD = N'eMp0N2vhHftJdF8B', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF, SID = 0xB6351CA8D6ED8542A4A8B0B7BF5984DE;


IF(EXISTS(SELECT TOP 1 * FROM sys.syslogins WHERE name = 'DynaTerminal')) DROP LOGIN DynaTerminal;
CREATE LOGIN DynaTerminal WITH PASSWORD = N'57nfGrtpAeiJvCuw', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF, SID = 0xDB617274F9F79E4E958552C34978648E;

IF(EXISTS(SELECT TOP 1 * FROM sys.syslogins WHERE name = 'BaseBusinessDb')) DROP LOGIN BaseBusinessDb;
CREATE LOGIN BaseBusinessDb WITH PASSWORD = N'eH5rC8tBFnEAyNkJ', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF, SID = 0x8F783C6E9BF31545ADB1F814C1161A05;

IF(EXISTS(SELECT TOP 1 * FROM sys.syslogins WHERE name = 'AppmanStatics3')) DROP LOGIN AppmanStatics3;
CREATE LOGIN AppmanStatics3 WITH PASSWORD = N'L2Bkvr0C4xWADfG7', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF, SID = 0xBA153506A468844EBA5776F9F2326FC0;

IF(EXISTS(SELECT TOP 1 * FROM sys.syslogins WHERE name = 'GameW')) DROP LOGIN GameW;
CREATE LOGIN GameW WITH PASSWORD = N'yxF29T1jtf5cuhap', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF, SID = 0x8D804EC8FC7DC04D980D66F7A720C5FC;

IF(EXISTS(SELECT TOP 1 * FROM sys.syslogins WHERE name = 'Videos')) DROP LOGIN Videos;
CREATE LOGIN Videos WITH PASSWORD = N'Aktav7Jcy40YweGm', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF, SID = 0xFD6307EF676E8944AC2738870E31AD22;

IF(EXISTS(SELECT TOP 1 * FROM sys.syslogins WHERE name = 'StreamMedia')) DROP LOGIN StreamMedia;
CREATE LOGIN StreamMedia WITH PASSWORD = N'n0Cau7hwtp2RvBke', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF, SID = 0x3056328E3822E142B4FE8CAB75920549;

IF(EXISTS(SELECT TOP 1 * FROM sys.syslogins WHERE name = 'PayCenter')) DROP LOGIN PayCenter;
CREATE LOGIN PayCenter WITH PASSWORD = N'J1TarDN5MLCWjBEe', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF, SID = 0xC05AFE3A4424E14F9B7F1CE1BCA00A4C;

IF(EXISTS(SELECT TOP 1 * FROM sys.syslogins WHERE name = 'AppBigMan')) DROP LOGIN AppBigMan;
CREATE LOGIN AppBigMan WITH PASSWORD = N'wCcTHWvDeuNMra4B', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF, SID = 0xA6D5D30927DFE1488A35A3E7370C8280;

GO
