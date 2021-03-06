﻿using System;
namespace ApqDBCManager.Forms
{
	public partial class DBS_XSD
	{
		public partial class ComputerTypeDataTable
		{
			public void InitData()
			{
				if (!this.Rows.Contains(1))
				{
					this.AddComputerTypeRow(1, Apq.GlobalObject.UILang["DB服务器"]);
				}
				if (!this.Rows.Contains(2))
				{
					this.AddComputerTypeRow(2, Apq.GlobalObject.UILang["Web服务器"]);
				}
			}
		}
		public partial class DBProductDataTable
		{
			public void InitData()
			{
				string[] DBPs = Enum.GetNames(typeof(Apq.Data.Common.DBProduct));
				foreach (string DBP in DBPs)
				{
					int DBPID = (int)Enum.Parse(typeof(Apq.Data.Common.DBProduct), DBP);
					if (!this.Rows.Contains(DBPID))
					{
						this.Rows.Add(DBPID, DBP);
					}
				}
			}
		}
		public partial class DBCUseTypeDataTable
		{
			public void InitData()
			{
				if (!this.Rows.Contains(1))
				{
					this.AddDBCUseTypeRow(1, Apq.GlobalObject.UILang["Web前台"]);
				}
				if (!this.Rows.Contains(2))
				{
					this.AddDBCUseTypeRow(2, Apq.GlobalObject.UILang["Web后台"]);
				}
			}
		}

		public partial class ComputerDataTable
		{
			/// <summary>
			/// 根据服务器编号查找数据行
			/// </summary>
			/// <param name="DBIID"></param>
			/// <returns></returns>
			public ComputerRow FindByComputerID(int ComputerID)
			{
				foreach (ComputerRow dr in this.Rows)
				{
					if (dr.ComputerID == ComputerID)
					{
						return dr;
					}
				}
				return null;
			}
		}

		public partial class DBITypeDataTable
		{
			/// <summary>
			/// 根据实例类型名称查找数据行
			/// </summary>
			/// <returns></returns>
			public DBITypeRow FindByTypeCaption(string TypeCaption)
			{
				foreach (DBITypeRow dr in this.Rows)
				{
					if (dr.TypeCaption == TypeCaption)
					{
						return dr;
					}
				}
				return null;
			}
		}

		public partial class DBIDataTable
		{
			/// <summary>
			/// 根据实例编号查找数据行
			/// </summary>
			public DBIRow FindByDBIID(int DBIID)
			{
				foreach (DBIRow dr in this.Rows)
				{
					if (dr.DBIID == DBIID)
					{
						return dr;
					}
				}
				return null;
			}
		}

	}
}
