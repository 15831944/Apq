using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using System.Management;
using System.Configuration;

namespace Apq.Config
{
	/// <summary>
	/// ���ù����
	/// </summary>
	public partial class ApqConfigs
	{
		/// <summary>
		/// Xml �����ļ�����׺["apq"]
		/// </summary>
		private static string XmlConfigExt;

		private static string _XmlConfigFolder;
		/// <summary>
		/// ��ȡ Xml �����ļ���
		/// </summary>
		/// <param name="Assembly">����</param>
		/// <returns></returns>
		public static string GetXmlConfigFolder(System.Reflection.Assembly Assembly)
		{
			if (string.IsNullOrEmpty(_XmlConfigFolder))
			{
				_XmlConfigFolder = ConfigurationManager.AppSettings["Apq.Config.ApqConfigs.XmlConfigFolder"];
				if (string.IsNullOrEmpty(_XmlConfigFolder))
				{
					_XmlConfigFolder = System.IO.Path.GetDirectoryName(Assembly.Location) + "\\";
				}
			}
			return _XmlConfigFolder;
		}

		#region AsmConfig
		/// <summary>
		/// [����]��ȡһ�����������ļ�
		/// </summary>
		/// <param name="Path">�����ļ�������·��</param>
		/// <param name="Root"></param>
		/// <param name="ClsName"></param>
		/// <returns></returns>
		public static clsConfig GetAsmConfig(string Path, string Root, string ClsName)
		{
			if (!Apq.GlobalObject.AsmConfigs.ContainsKey(Path))
			{
				clsConfig Config = Activator.CreateInstance(Type.GetType(ClsName)) as clsConfig;
				if (Config != null)
				{
					Config.Open(Path, Root);
					Path = Config.Path;	// ����ע���
					try
					{
						Apq.GlobalObject.AsmConfigs.Add(Path, Config);
					}
					catch { }
				}
			}
			return Apq.GlobalObject.AsmConfigs[Path] as clsConfig;
		}

		/// <summary>
		/// ��ȡһ�����������ļ�(XmlConfig)
		/// </summary>
		/// <param name="Path">�����ļ�������·��</param>
		/// <param name="Root">Root</param>
		/// <returns></returns>
		public static clsConfig GetAsmConfig(string Path, string Root)
		{
			return GetAsmConfig(Path, Root, "Apq.Config.XmlConfig");
		}

		/// <summary>
		/// ��ȡһ�����������ļ�(XmlConfig)
		/// </summary>
		/// <param name="Path">�����ļ�������·��</param>
		/// <returns></returns>
		public static clsConfig GetAsmConfig(string Path)
		{
			return GetAsmConfig(Path, "Root");
		}

		/// <summary>
		/// ��ȡһ�����򼯵ĳ��������ļ�(XmlConfig)
		/// </summary>
		/// <param name="Assembly">����</param>
		/// <returns></returns>
		public static clsConfig GetAsmConfig(System.Reflection.Assembly Assembly)
		{
			if (string.IsNullOrEmpty(XmlConfigExt))
			{
				XmlConfigExt = ConfigurationManager.AppSettings["Apq.Config.ApqConfigs.XmlConfigExt"];
				if (string.IsNullOrEmpty(XmlConfigExt))
				{
					XmlConfigExt = "apq";
				}
			}
			return GetAsmConfig(GetXmlConfigFolder(Assembly) + System.IO.Path.GetFileName(Assembly.Location) + "." + XmlConfigExt);
		}

		/// <summary>
		/// �������г��������ļ�
		/// </summary>
		public static void SaveAllAsmConfig()
		{
			foreach (clsConfig Config in Apq.GlobalObject.AsmConfigs.Values)
			{
				Config.Save();
			}
		}
		#endregion

		#region UserConfig
		/// <summary>
		/// [����]��ȡһ���û������ļ�
		/// </summary>
		/// <param name="Path">�����ļ�������·��</param>
		/// <param name="Root"></param>
		/// <param name="ClsName"></param>
		/// <returns></returns>
		public static clsConfig GetUserConfig(string Path, string Root, string ClsName)
		{
			if (!Apq.GlobalObject.UserConfigs.ContainsKey(Path))
			{
				clsConfig Config = Activator.CreateInstance(Type.GetType(ClsName)) as clsConfig;
				if (Config != null)
				{
					Config.Open(Path, Root);
					Path = Config.Path;	// ����ע���
					try
					{
						Apq.GlobalObject.UserConfigs.Add(Path, Config);
					}
					catch { }
				}
			}
			return Apq.GlobalObject.UserConfigs[Path] as clsConfig;
		}

		/// <summary>
		/// ��ȡһ���û������ļ�(XmlConfig)
		/// </summary>
		/// <param name="Path">�����ļ�������·��</param>
		/// <param name="Root">Root</param>
		/// <returns></returns>
		public static clsConfig GetUserConfig(string Path, string Root)
		{
			return GetUserConfig(Path, Root, "Apq.Config.XmlConfig");
		}

		/// <summary>
		/// ��ȡһ���û������ļ�(XmlConfig)
		/// </summary>
		/// <param name="Path">�����ļ�������·��</param>
		/// <returns></returns>
		public static clsConfig GetUserConfig(string Path)
		{
			return GetUserConfig(Path, "Root");
		}

		/// <summary>
		/// ��ȡһ�����򼯵��û������ļ�(XmlConfig)
		/// </summary>
		/// <param name="Assembly">����</param>
		/// <returns></returns>
		public static clsConfig GetUserConfig(System.Reflection.Assembly Assembly)
		{
			if (string.IsNullOrEmpty(XmlConfigExt))
			{
				XmlConfigExt = ConfigurationManager.AppSettings["Apq.Config.ApqConfigs.XmlConfigExt"];
				if (string.IsNullOrEmpty(XmlConfigExt))
				{
					XmlConfigExt = "apq";
				}
			}
			return GetUserConfig(GetXmlConfigFolder(Assembly) + System.IO.Path.GetFileName(Assembly.Location) + "." + Environment.UserName + "." + XmlConfigExt);
		}

		/// <summary>
		/// ���������û������ļ�
		/// </summary>
		public static void SaveAllUserConfig()
		{
			foreach (clsConfig Config in Apq.GlobalObject.UserConfigs.Values)
			{
				Config.Save();
			}
		}
		#endregion

		#region SaveAll
		/// <summary>
		/// �������������ļ�
		/// </summary>
		public static void SaveAll()
		{
			SaveAllAsmConfig();
			SaveAllUserConfig();
		}
		#endregion
	}
}
