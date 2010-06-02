using System;
using System.Collections.Generic;
using System.Text;
using System.Management;
using System.Configuration;

namespace Apq.Configuration
{
	/// <summary>
	/// �ṩ�����ļ�����
	/// </summary>
	public class Configs
	{
		private static string _AppConfigFolder;
		/// <summary>
		/// ��ȡ AppConfig �����ļ���
		/// </summary>
		/// <param name="Assembly">����</param>
		/// <returns></returns>
		public static string GetAppConfigFolder(System.Reflection.Assembly Assembly)
		{
			if (string.IsNullOrEmpty(_AppConfigFolder))
			{
				_AppConfigFolder = System.Configuration.ConfigurationManager.AppSettings["Apq.Configuration.Configs.AppConfigFolder"];
				if (string.IsNullOrEmpty(_AppConfigFolder))
				{
					_AppConfigFolder = System.IO.Path.GetFullPath(Assembly.Location);
				}
			}
			return _AppConfigFolder;
		}

		/// <summary>
		/// ��ȡһ�������ļ�
		/// </summary>
		/// <param name="Path">�����ļ�������·��</param>
		/// <returns></returns>
		public static System.Configuration.Configuration GetConfig(string Path)
		{
			if (!Apq.GlobalObject.Configs.ContainsKey(Path))
			{
				object LockFile = Apq.Locks.GetFileLock(Path);
				lock (LockFile)
				{
					Apq.GlobalObject.Configs.Add(Path, ConfigurationManager.Open(Path));
				}
			}
			return Apq.GlobalObject.Configs[Path];
		}

		/// <summary>
		/// ��ȡһ�����򼯵������ļ�
		/// </summary>
		/// <param name="Assembly">����</param>
		/// <returns></returns>
		public static System.Configuration.Configuration GetConfig(System.Reflection.Assembly Assembly)
		{
			return GetConfig(GetAppConfigFolder(Assembly) + System.IO.Path.GetFileName(Assembly.Location) + ".config");
		}

		/// <summary>
		/// �������������ļ�
		/// </summary>
		public static void SaveAll()
		{
			foreach (System.Configuration.Configuration Config in Apq.GlobalObject.Configs.Values)
			{
				object LockFile = Apq.Locks.GetFileLock(Config.FilePath);
				lock (LockFile)
				{
					Config.Save(System.Configuration.ConfigurationSaveMode.Minimal);
				}
			}
		}
	}
}
