using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;

namespace Apq.DllImports
{
	/// <summary>
	/// Kernel32
	/// </summary>
	public class Kernel32
	{
		#region PrivateProfileString
		/// <summary>
		/// д
		/// </summary>
		/// <param name="section">INI�ļ��еĶ���</param>
		/// <param name="key">INI�ļ��еĹؼ���</param>
		/// <param name="val">INI�ļ��йؼ��ֵ�ֵ</param>
		/// <param name="filePath">INI�ļ���������·��������</param>
		/// <returns></returns>
		[DllImport("Kernel32.dll")]
		public static extern long WritePrivateProfileString(string section, string key, string val, string filePath);
		/// <summary>
		/// ��ȡ
		/// </summary>
		/// <param name="section">INI�ļ��еĶ�������</param>
		/// <param name="key">INI�ļ��еĹؼ���</param>
		/// <param name="def">�޷���ȡʱ��ʱ���ȱʡֵ</param>
		/// <param name="retVal">��ȡֵ</param>
		/// <param name="size">ֵ�Ĵ�С</param>
		/// <param name="filePath">INI�ļ�������·��������</param>
		/// <returns></returns>
		[DllImport("Kernel32.dll")]
		public static extern int GetPrivateProfileString(string section, string key, string def, StringBuilder retVal, int size, string filePath);
		#endregion

		/// <summary>
		/// ��ȡ��������
		/// </summary>
		/// <param name="driveLetter"></param>
		/// <returns></returns>
		[DllImport("Kernel32.dll")]
		public static extern uint GetDriveType(String driveLetter);

		/// <summary>
		/// ��ȡ����Ϣ
		/// </summary>
		/// <param name="root"></param>
		/// <param name="name"></param>
		/// <param name="nameLen"></param>
		/// <param name="serial"></param>
		/// <param name="maxCompLen"></param>
		/// <param name="flags"></param>
		/// <param name="fileSysName"></param>
		/// <param name="fileSysNameLen"></param>
		/// <returns></returns>
		[DllImport("Kernel32.dll")]
		public static extern bool GetVolumeInformation(String root, byte[] name, int nameLen,
			out int serial, out int maxCompLen, out int flags, byte[] fileSysName,
			int fileSysNameLen);

		/// <summary>
		/// ������ͣ������
		/// </summary>
		[DllImport("Kernel32.dll")]
		public static extern void Sleep(uint dwMilliseconds);
	}
}
