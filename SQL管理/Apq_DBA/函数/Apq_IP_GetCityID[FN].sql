
IF( OBJECT_ID('dbo.Apq_IP_GetCityID', 'FN') IS NULL )
	EXEC sp_executesql N'CREATE FUNCTION dbo.Apq_IP_GetCityID()RETURNS int AS BEGIN RETURN 0 END';
GO
/* =============================================
-- ����: ������
-- ����: 2008-11-19
-- ����: ����IP��ȡ���ڳ���ID
-- ����: ������IP
-- ����: ����ID,δ֪ʱ����-10
-- ʾ��:
SELECT dbo.Apq_IP_GetCityID(0x0000000000000000000000000029F4475B);
-- =============================================
-10: δ֪
*/
ALTER FUNCTION dbo.Apq_IP_GetCityID(
	@binIP	binary(16)
)RETURNS bigint
AS
BEGIN
	DECLARE @CityID bigint
	SELECT @CityID = -10;	-- δ֪
	SELECT TOP 1 @CityID = CityID FROM Apq_IP WHERE @binIP BETWEEN IPBegin AND IPEnd ORDER BY _Time DESC;
	RETURN @CityID;
END
GO
