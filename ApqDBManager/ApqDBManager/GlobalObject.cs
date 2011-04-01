﻿using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using ApqDBManager.Forms;
using System.Data.SqlClient;
using System.Windows.Forms;

namespace ApqDBManager
{
	/// <summary>
	/// 全局对象
	/// </summary>
	public static class GlobalObject
	{
		#region TheAssembly
		private static System.Reflection.Assembly _TheAssembly;
		/// <summary>
		/// 该程序集配置文件(程序集名.后缀.xml)
		/// </summary>
		public static System.Reflection.Assembly TheAssembly
		{
			get
			{
				if (_TheAssembly == null)
				{
					_TheAssembly = System.Reflection.Assembly.GetExecutingAssembly();
				}
				return _TheAssembly;
			}
		}
		#endregion

		#region XmlAsmConfig
		private static Apq.Config.XmlConfig _XmlAsmConfig;
		/// <summary>
		/// 该程序集配置文件(程序集名.后缀.xml)
		/// </summary>
		public static Apq.Config.XmlConfig XmlAsmConfig
		{
			get
			{
				if (_XmlAsmConfig == null)
				{
					_XmlAsmConfig = Apq.Config.ApqConfigs.GetAsmConfig(TheAssembly) as Apq.Config.XmlConfig;
				}
				return _XmlAsmConfig;
			}
		}
		#endregion

		#region XmlUserConfig
		private static Apq.Config.XmlConfig _XmlUserConfig;
		/// <summary>
		/// 该程序集用户配置文件(程序集名.后缀.xml)
		/// </summary>
		public static Apq.Config.XmlConfig XmlUserConfig
		{
			get
			{
				if (_XmlUserConfig == null)
				{
					_XmlUserConfig = Apq.Config.ApqConfigs.GetUserConfig(TheAssembly) as Apq.Config.XmlConfig;
				}
				return _XmlUserConfig;
			}
		}
		#endregion

		#region XmlConfigChain
		private static Apq.Config.ConfigChain _XmlConfigChain;
		/// <summary>
		/// 该程序集配置文件链
		/// </summary>
		public static Apq.Config.ConfigChain XmlConfigChain
		{
			get
			{
				if (_XmlConfigChain == null)
				{
					_XmlConfigChain = new Apq.Config.ConfigChain(XmlAsmConfig, XmlUserConfig);
				}
				return _XmlConfigChain;
			}
		}
		#endregion

		#region RegSysConfig
		private static Apq.Config.RegConfig _RegSysConfig;
		/// <summary>
		/// 该程序集配置文件(程序集名.后缀.Reg)
		/// </summary>
		public static Apq.Config.RegConfig RegSysConfig
		{
			get
			{
				if (_RegSysConfig == null)
				{
					_RegSysConfig = new Apq.Config.RegConfig();
					_RegSysConfig.Path = "$reg$LocalMachine";
					_RegSysConfig.Root = @"SOFTWARE\Apq\ApqDBManager";
				}
				return _RegSysConfig;
			}
		}
		#endregion

		#region RegUserConfig
		private static Apq.Config.RegConfig _RegUserConfig;
		/// <summary>
		/// 该程序集用户配置文件(程序集名.后缀.Reg)
		/// </summary>
		public static Apq.Config.RegConfig RegUserConfig
		{
			get
			{
				if (_RegUserConfig == null)
				{
					_RegUserConfig = new Apq.Config.RegConfig();
					_RegUserConfig.Path = "$reg$CurrentUser";
					_RegUserConfig.Root = @"SOFTWARE\Apq\ApqDBManager";
				}
				return _RegUserConfig;
			}
		}
		#endregion

		#region RegConfigChain
		private static Apq.Config.ConfigChain _RegConfigChain;
		/// <summary>
		/// 该程序集配置文件链
		/// </summary>
		public static Apq.Config.ConfigChain RegConfigChain
		{
			get
			{
				if (_RegConfigChain == null)
				{
					_RegConfigChain = new Apq.Config.ConfigChain(RegSysConfig, RegUserConfig);
				}
				return _RegConfigChain;
			}
		}
		#endregion

		#region MainForm
		private static MainForm _MainForm;
		/// <summary>
		/// 获取主窗口
		/// </summary>
		public static MainForm MainForm
		{
			get
			{
				if (_MainForm == null)
				{
					_MainForm = new MainForm();
				}
				return _MainForm;
			}
		}
		#endregion

		#region SolutionExplorer
		private static SqlIns _SolutionExplorer;
		/// <summary>
		/// 获取解决方案视图
		/// </summary>
		public static SqlIns SolutionExplorer
		{
			get
			{
				if (_SolutionExplorer == null)
				{
					_SolutionExplorer = new SqlIns();
				}
				return _SolutionExplorer;
			}
		}
		#endregion

		#region Favorites
		private static Favorites _Favorites;
		/// <summary>
		/// 获取收藏夹视图
		/// </summary>
		public static Favorites Favorites
		{
			get
			{
				if (_Favorites == null)
				{
					_Favorites = new Favorites();
				}
				return _Favorites;
			}
		}
		#endregion

		#region ErrList
		private static ErrList _ErrList;
		/// <summary>
		/// 获取错误列表视图
		/// </summary>
		public static ErrList ErrList
		{
			get
			{
				if (_ErrList == null)
				{
					_ErrList = new ErrList();
				}
				return _ErrList;
			}
		}
		#endregion

		#region SqlInstances
		private static Apq.DBC.XSD _Sqls;
		/// <summary>
		/// 获取服务器集
		/// </summary>
		public static Apq.DBC.XSD Sqls
		{
			get
			{
				if (_Sqls == null)
				{
					SqlsReload();
				}
				return _Sqls;
			}
		}

		public static void SqlsReload()
		{
			#region 从数据库加载实例列表
			Apq.ConnectionStrings.SQLServer.SqlConnection scHelper = new Apq.ConnectionStrings.SQLServer.SqlConnection();
			scHelper.DBName = GlobalObject.XmlConfigChain["ApqDBManager.Controls.MainOption.DBC", "DBName"];
			scHelper.ServerName = GlobalObject.XmlConfigChain["ApqDBManager.Controls.MainOption.DBC", "ServerName"];
			scHelper.UserId = GlobalObject.XmlConfigChain["ApqDBManager.Controls.MainOption.DBC", "UserId"];
			string PwdC = GlobalObject.XmlConfigChain["ApqDBManager.Controls.MainOption.DBC", "Pwd"];
			string PwdD = Apq.Security.Cryptography.DESHelper.DecryptString(PwdC, GlobalObject.RegConfigChain["Crypt", "DESKey"], GlobalObject.RegConfigChain["Crypt", "DESIV"]);
			scHelper.Pwd = PwdD;
			try
			{
				scHelper.TestAvailable();
			}
			catch
			{
				MessageBox.Show("请重新设置管理库", "异常");
				MainOption.nbiDBC_LinkPressed(null, null);
				MainForm.menuOption_ItemClick(null, null);
				return;
			}
			string strMgrDBConnectionString = scHelper.GetConnectionString();

			if (_Sqls == null)
			{
				_Sqls = new Apq.DBC.XSD();
				_Sqls.SqlInstance.Columns.Add("CheckState", typeof(int));
				_Sqls.SqlInstance.Columns.Add("IsReadyToGo", typeof(bool));
				_Sqls.SqlInstance.Columns.Add("Err", typeof(bool));
				_Sqls.SqlInstance.Columns.Add("DBConnectionString");
			}
			_Sqls.Clear();

			try
			{
				SqlDataAdapter sda = new SqlDataAdapter("dbo.ApqDBMgr_SqlInstance_List", strMgrDBConnectionString);
				sda.Fill(_Sqls.SqlInstance);
			}
			catch
			{
				return;
			}

			#endregion

			//解密密码,生成连接字符串
			foreach (Apq.DBC.XSD.SqlInstanceRow dr in _Sqls.SqlInstance.Rows)
			{
				if (!Apq.Convert.LikeDBNull(dr["PwdC"]))
				{
					dr.PwdD = Apq.Security.Cryptography.DESHelper.DecryptString(dr.PwdC, GlobalObject.RegConfigChain["Crypt", "DESKey"], GlobalObject.RegConfigChain["Crypt", "DESIV"]);
					Apq.ConnectionStrings.SQLServer.SqlConnection scHelper1 = new Apq.ConnectionStrings.SQLServer.SqlConnection();
					scHelper1.DBName = "master";
					scHelper1.ServerName = dr.IP;
					if (dr.SqlPort > 0)
					{
						scHelper1.ServerName += "," + dr.SqlPort;
					}
					scHelper1.UserId = dr.UserId;
					scHelper1.Pwd = dr.PwdD;
					dr["DBConnectionString"] = scHelper1.GetConnectionString();
				}
			}

#if Debug_Home
			foreach (Apq.DBC.XSD.SqlInstanceRow dr in _Sqls.SqlInstance.Rows)
			{
				dr["DBConnectionString"] = "Data Source=.;User ID=apq;Password=f;";
				dr.IPWan1 = "127.0.0.1";
			}
#endif

			_Sqls.SqlInstance.AcceptChanges();
		}
		#endregion

		#region MainOption
		private static MainOption _MainOption;
		/// <summary>
		/// 获取选项窗口
		/// </summary>
		public static MainOption MainOption
		{
			get
			{
				if (_MainOption == null)
				{
					_MainOption = new MainOption();
				}
				return _MainOption;
			}
		}
		#endregion

		#region AboutBox
		private static Apq.Windows.Forms.AboutBox _AboutBox;
		/// <summary>
		/// 获取选项窗口
		/// </summary>
		public static Apq.Windows.Forms.AboutBox AboutBox
		{
			get
			{
				if (_AboutBox == null)
				{
					_AboutBox = new Apq.Windows.Forms.AboutBox();
				}
				return _AboutBox;
			}
		}
		#endregion
	}
}
