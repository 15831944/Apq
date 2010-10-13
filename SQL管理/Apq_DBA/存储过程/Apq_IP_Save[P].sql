IF( OBJECT_ID('dbo.Apq_IP_Save', 'P') IS NULL )
	EXEC sp_executesql N'CREATE PROCEDURE dbo.Apq_IP_Save AS BEGIN RETURN END';
GO
/* =============================================
-- ����: ������
-- ����: 2007-11-02
-- ����: �����ѯ����һ�� IP �ĸ���ֵ
	ͬʱ�����ص���IP��
-- ʾ��:
EXEC dbo.Apq_IP_Save('61.133.8.125', '61.133.8.255', 'ɽ��ʡ����� ��ͨ', 1, 1, 0, getdate());
-- =============================================
*/
ALTER PROC dbo.Apq_IP_Save
	@Begin		nvarchar(max),
	@End		nvarchar(max),
	@Addr		nvarchar(max),
	@ProvinceID	bigint,
	@CityID		bigint,
	@IsMatched	smallint,
	@_Time		datetime
AS
SET NOCOUNT ON;

DECLARE	@binBegin binary(16), @binEnd binary(16), 
		@binBegin1 binary(16), @binEnd1 binary(16), @binBegin2 binary(16), @binEnd2 binary(16), 
		@Addr1 nvarchar(max), @Addr2 nvarchar(max), @ProvinceID1 bigint, @ProvinceID2 bigint, @CityID1 bigint, @CityID2 bigint, 
		@IsMatched1 smallint, @IsMatched2 smallint, @_Time1 datetime, @_Time2 datetime;
SELECT	 @binBegin = dbo.Apq_ConvertIP_Binary16(@Begin)
		,@binEnd = dbo.Apq_ConvertIP_Binary16(@End)
		;

-- ֱ��ɾ���ڲ���
DELETE	Apq_IP WHERE [Begin] >= @Begin AND [End] <= @End;

-- ��¼��ʼֵ����ԭ�ε� ��ֵ
SELECT	 @binBegin1 = [Begin]
		,@binEnd1 = [End]
		,@Addr1 = Addr
		,@ProvinceID1 = ProvinceID
		,@CityID1 = CityID
		,@IsMatched1 = IsMatched
		,@_Time1 = _Time
FROM	Apq_IP
WHERE	@binBegin BETWEEN [Begin] AND [End];
DELETE	Apq_IP WHERE @binBegin BETWEEN [Begin] AND [End];

-- Ĭ����ֵͬ
SELECT	 @binBegin2 = @binBegin1
		,@binEnd2 = @binEnd1
		,@Addr2 = @Addr1
		;

-- ��¼����ֵ����ԭ�ε� ��ֵ
SELECT	 @binBegin2 = [Begin]
		,@binEnd2 = [End]
		,@Addr2 = Addr
		,@ProvinceID2 = ProvinceID
		,@CityID2 = CityID
		,@IsMatched2 = IsMatched
		,@_Time2 = _Time
FROM	Apq_IP
WHERE	@binEnd BETWEEN [Begin] AND [End];
DELETE	Apq_IP WHERE @binEnd BETWEEN [Begin] AND [End];

-- ����ʼֵ֮ǰ��
IF(@binBegin > @binBegin1)
BEGIN
	INSERT	Apq_IP([Begin], [End], Addr, ProvinceID, CityID, IsMatched, _Time)
	VALUES(@binBegin1, @binBegin-1, @Addr1, @ProvinceID1, @CityID1, @IsMatched1, @_Time1);
END
-- ������ֵ֮���
IF(@binEnd < @binEnd2)
BEGIN
	INSERT	Apq_IP([Begin], [End], Addr, ProvinceID, CityID, IsMatched, _Time)
	VALUES(@binEnd+1, @binEnd2, @Addr2, @ProvinceID2, @CityID2, @IsMatched2, @_Time2);
END
-- �������ֵ
INSERT	Apq_IP([Begin], [End], Addr, ProvinceID, CityID, IsMatched, _Time)
VALUES(@binBegin, @binEnd, @Addr, @ProvinceID, @CityID, @IsMatched, @_Time);
GO
