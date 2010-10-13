
-- ������ ------------------------------------------------------------------------------------------
CREATE TABLE [dbo].[DimDate](
	[PK_����] [datetime] NOT NULL,
	[����_����] [nvarchar](50) NULL,
	[��] [datetime] NULL,
	[��_����] [nvarchar](50) NULL,
	[����] [datetime] NULL,
	[����_����] [nvarchar](50) NULL,
	[�·�] [datetime] NULL,
	[�·�_����] [nvarchar](50) NULL,
	[��] [datetime] NULL,
	[��_����] [nvarchar](50) NULL,
	[ÿ���ĳһ��] [int] NULL,
	[ÿ���ĳһ��_����] [nvarchar](50) NULL,
	[ÿ�����ȵ�ĳһ��] [int] NULL,
	[ÿ�����ȵ�ĳһ��_����] [nvarchar](50) NULL,
	[ÿ�µ�ĳһ��] [int] NULL,
	[ÿ�µ�ĳһ��_����] [nvarchar](50) NULL,
	[ÿ�ܵ�ĳһ��] [int] NULL,
	[ÿ�ܵ�ĳһ��_����] [nvarchar](50) NULL,
	[ÿ���ĳһ��] [int] NULL,
	[ÿ���ĳһ��_����] [nvarchar](50) NULL,
	[ÿ���ĳһ��] [int] NULL,
	[ÿ���ĳһ��_����] [nvarchar](50) NULL,
	[ÿ�����ȵ�ĳһ��] [int] NULL,
	[ÿ�����ȵ�ĳһ��_����] [nvarchar](50) NULL,
	[ÿ���ĳһ����] [int] NULL,
	[ÿ���ĳһ����_����] [nvarchar](50) NULL,
 CONSTRAINT [PK_DimDate] PRIMARY KEY CLUSTERED 
(
	[PK_����] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'AllowGen', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'PK_����'
GO

EXEC sys.sp_addextendedproperty @name=N'DSVColumn', @value=N'����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'PK_����'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowGen', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'����_����'
GO

EXEC sys.sp_addextendedproperty @name=N'DSVColumn', @value=N'����_����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'����_����'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowGen', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'��'
GO

EXEC sys.sp_addextendedproperty @name=N'DSVColumn', @value=N'��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'��'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowGen', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'��_����'
GO

EXEC sys.sp_addextendedproperty @name=N'DSVColumn', @value=N'��_����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'��_����'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowGen', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'����'
GO

EXEC sys.sp_addextendedproperty @name=N'DSVColumn', @value=N'����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'����'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowGen', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'����_����'
GO

EXEC sys.sp_addextendedproperty @name=N'DSVColumn', @value=N'����_����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'����_����'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowGen', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'�·�'
GO

EXEC sys.sp_addextendedproperty @name=N'DSVColumn', @value=N'�·�' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'�·�'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowGen', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'�·�_����'
GO

EXEC sys.sp_addextendedproperty @name=N'DSVColumn', @value=N'�·�_����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'�·�_����'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowGen', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'��'
GO

EXEC sys.sp_addextendedproperty @name=N'DSVColumn', @value=N'��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'��'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowGen', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'��_����'
GO

EXEC sys.sp_addextendedproperty @name=N'DSVColumn', @value=N'��_����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'��_����'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowGen', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ���ĳһ��'
GO

EXEC sys.sp_addextendedproperty @name=N'DSVColumn', @value=N'ÿ���ĳһ��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ���ĳһ��'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowGen', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ���ĳһ��_����'
GO

EXEC sys.sp_addextendedproperty @name=N'DSVColumn', @value=N'ÿ���ĳһ��_����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ���ĳһ��_����'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowGen', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ�����ȵ�ĳһ��'
GO

EXEC sys.sp_addextendedproperty @name=N'DSVColumn', @value=N'ÿ�����ȵ�ĳһ��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ�����ȵ�ĳһ��'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowGen', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ�����ȵ�ĳһ��_����'
GO

EXEC sys.sp_addextendedproperty @name=N'DSVColumn', @value=N'ÿ�����ȵ�ĳһ��_����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ�����ȵ�ĳһ��_����'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowGen', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ�µ�ĳһ��'
GO

EXEC sys.sp_addextendedproperty @name=N'DSVColumn', @value=N'ÿ�µ�ĳһ��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ�µ�ĳһ��'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowGen', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ�µ�ĳһ��_����'
GO

EXEC sys.sp_addextendedproperty @name=N'DSVColumn', @value=N'ÿ�µ�ĳһ��_����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ�µ�ĳһ��_����'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowGen', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ�ܵ�ĳһ��'
GO

EXEC sys.sp_addextendedproperty @name=N'DSVColumn', @value=N'ÿ�ܵ�ĳһ��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ�ܵ�ĳһ��'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowGen', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ�ܵ�ĳһ��_����'
GO

EXEC sys.sp_addextendedproperty @name=N'DSVColumn', @value=N'ÿ�ܵ�ĳһ��_����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ�ܵ�ĳһ��_����'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowGen', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ���ĳһ��'
GO

EXEC sys.sp_addextendedproperty @name=N'DSVColumn', @value=N'ÿ���ĳһ��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ���ĳһ��'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowGen', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ���ĳһ��_����'
GO

EXEC sys.sp_addextendedproperty @name=N'DSVColumn', @value=N'ÿ���ĳһ��_����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ���ĳһ��_����'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowGen', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ���ĳһ��'
GO

EXEC sys.sp_addextendedproperty @name=N'DSVColumn', @value=N'ÿ���ĳһ��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ���ĳһ��'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowGen', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ���ĳһ��_����'
GO

EXEC sys.sp_addextendedproperty @name=N'DSVColumn', @value=N'ÿ���ĳһ��_����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ���ĳһ��_����'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowGen', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ�����ȵ�ĳһ��'
GO

EXEC sys.sp_addextendedproperty @name=N'DSVColumn', @value=N'ÿ�����ȵ�ĳһ��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ�����ȵ�ĳһ��'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowGen', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ�����ȵ�ĳһ��_����'
GO

EXEC sys.sp_addextendedproperty @name=N'DSVColumn', @value=N'ÿ�����ȵ�ĳһ��_����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ�����ȵ�ĳһ��_����'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowGen', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ���ĳһ����'
GO

EXEC sys.sp_addextendedproperty @name=N'DSVColumn', @value=N'ÿ���ĳһ����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ���ĳһ����'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowGen', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ���ĳһ����_����'
GO

EXEC sys.sp_addextendedproperty @name=N'DSVColumn', @value=N'ÿ���ĳһ����_����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'COLUMN',@level2name=N'ÿ���ĳһ����_����'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowGen', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate'
GO

EXEC sys.sp_addextendedproperty @name=N'DSVTable', @value=N'DimDate' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate'
GO

EXEC sys.sp_addextendedproperty @name=N'Project', @value=N'c8479882-99c6-4a28-8903-36c4d511c8c7' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowGen', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DimDate', @level2type=N'CONSTRAINT',@level2name=N'PK_DimDate'
GO
-- =================================================================================================

-- ������� ----------------------------------------------------------------------------------------
DECLARE @PK datetime, @PKEnd datetime
	,@yyyy int, @MM int, @dd int,@weekday int, @week int, @Quarter int, @dy int
	,@�� datetime, @���� datetime, @�·� datetime, @�� datetime;

SELECT @PK = '2007-01-01',@PKEnd = '2051-01-01';

DECLARE @p datetime;
SELECT @p = @PK;
WHILE(@p <= @PKEnd)
BEGIN
	IF(NOT EXISTS(SELECT TOP 1 1 FROM dbo.DimDate WHERE PK_���� = @p))
	BEGIN
		SELECT @yyyy = year(@p),@MM = month(@p),@dd = day(@p), @weekday = datepart(dw,@p), @week = datepart(ww,@p), @Quarter = datepart(qq,@p), @dy = datepart(dy,@p);
		SELECT @�� = Convert(nvarchar(50),@yyyy) + '-01-01',
			@���� = Convert(nvarchar(50),@yyyy) + '-' + Convert(nvarchar(50),@Quarter * 3 -2) + '-01',
			@�·� = Convert(nvarchar(50),@yyyy) + '-' + Convert(nvarchar(50),@MM) + '-01',
			@�� = Dateadd(dd,1-@weekday,@p);
		
		INSERT dbo.DimDate (PK_����, ����_����, 
			��, ��_����, 
			�·�, �·�_����, 
			����, ����_����, 
			��, ��_����, 
			ÿ�µ�ĳһ��, ÿ�µ�ĳһ��_����,
			ÿ���ĳһ��, ÿ���ĳһ��_����, 
			ÿ�����ȵ�ĳһ��, ÿ�����ȵ�ĳһ��_����, 
			ÿ�ܵ�ĳһ��, ÿ�ܵ�ĳһ��_����, 
			ÿ���ĳһ��, ÿ���ĳһ��_����, 
			ÿ���ĳһ��, ÿ���ĳһ��_����, 
			ÿ�����ȵ�ĳһ��, ÿ�����ȵ�ĳһ��_����, 
			ÿ���ĳһ����, ÿ���ĳһ����_����)
		VALUES  (@p,Convert(nvarchar(50),@yyyy) + '��' + Convert(nvarchar(50),@mm)+ '��'+Convert(nvarchar(50),@dd)+'��',
			@��,Convert(nvarchar(50),@yyyy) + '��',
			@�·�,Convert(nvarchar(50),@yyyy) + '��' + Convert(nvarchar(50),@mm)+ '��',
			@����,Convert(nvarchar(50),@yyyy) + '��' + Convert(nvarchar(50),@Quarter)+ '����',
			@��,Convert(nvarchar(50),@yyyy) + '��' + Convert(nvarchar(50),@week)+ '��',
			@dd,'��'+Convert(nvarchar(50),@dd)+ '��',
			@dy,'��'+Convert(nvarchar(50),@dy)+ '��',
			Datediff(dd,@����,@p)+1,'��'+Convert(nvarchar(50),Datediff(dd,@����,@p)+1)+ '��',
			@weekday,'��'+Convert(nvarchar(50),@weekday)+ '��',
			@week,'��'+Convert(nvarchar(50),@week)+ '��',
			@mm,'��'+Convert(nvarchar(50),@mm)+ '��',
			Datediff(mm,@����,@�·�)+1,'��'+Convert(nvarchar(50),Datediff(mm,@����,@�·�)+1)+ '��',
			@Quarter,'��'+Convert(nvarchar(50),@Quarter)+ '����'
			);
	END
	
	SELECT @p = Dateadd(dd,1,@p);
END
-- =================================================================================================
