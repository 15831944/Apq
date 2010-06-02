using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace Apq.Configuration
{
	/// <summary>
	/// �ṩ�Կͻ���Ӧ�ó��������ļ��ķ��ʡ�
	/// </summary>
	public class ConfigurationManager
	{
		/// <summary>
		/// ��ָ���Ŀͻ��������ļ���Ϊ System.Configuration.Configuration ����򿪡�
		/// </summary>
		/// <param name="Path">�����ļ�������·��</param>
		/// <returns></returns>
		public static System.Configuration.Configuration Open(string Path)
		{
			if (!File.Exists(Path))
			{
				string str = @"<?xml version=""1.0"" encoding=""utf-8"" ?>
<configuration/>
";
				File.WriteAllText(Path, str, Encoding.UTF8);
			}

			System.Configuration.ExeConfigurationFileMap ecfm = new System.Configuration.ExeConfigurationFileMap();
			ecfm.ExeConfigFilename = Path;
			object LockFile = Apq.Locks.GetFileLock(Path);
			System.Configuration.Configuration Config = null;
			lock (LockFile)
			{
				Config = System.Configuration.ConfigurationManager.OpenMappedExeConfiguration(ecfm, System.Configuration.ConfigurationUserLevel.None);
			}
			return Config;
		}

		/// <summary>
		/// ��ָ���ĳ��򼯵������ļ���Ϊ System.Configuration.Configuration ����򿪡�
		/// </summary>
		/// <param name="Assembly">����</param>
		/// <returns></returns>
		public static System.Configuration.Configuration Open(System.Reflection.Assembly Assembly)
		{
			return Open(Configs.GetAppConfigFolder(Assembly)+System.IO.Path.GetFileName( Assembly.Location )+ ".config");
			//return Open(Assembly.Location + ".config");
		}
	}
}
