using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;
using System.IO;

namespace Apq.Config
{
	// �л�����Ҫʹ��ini�ļ���ʱ��ȷ���¶�д�ļ��Ƿ���Ҫ����
	/// <summary>
	/// ini������
	/// </summary>
	public partial class IniConfig : Apq.Config.clsConfig
	{
		/// <summary>
		/// д��INI�ļ�
		/// </summary>
		/// <param name="Section">��Ŀ����(�� [ClassName] )</param>
		/// <param name="Key">��</param>
		/// <param name="Value">ֵ</param>
		public void Write(string Section, string Key, string Value)
		{
			Apq.DllImports.Kernel32.WritePrivateProfileString(Section, Key, Value, Path);
		}

		/// <summary>
		/// ����INI�ļ�
		/// </summary>
		/// <param name="Section">��Ŀ����(�� [ClassName])</param>
		/// <param name="Key">��</param>
		public string Read(string Section, string Key)
		{
			FileInfo fi = new FileInfo(Path);
			StringBuilder temp = new StringBuilder(Apq.Convert.ChangeType<int>(fi.Length, 2048));
			int i = Apq.DllImports.Kernel32.GetPrivateProfileString(Section, Key, "", temp, temp.Capacity, Path);
			return temp.ToString();
		}

		/// <summary>
		/// ��ȡ�������ļ�·��
		/// </summary>
		public override string Path
		{
			get { return base.Path; }
			set
			{
				File.AppendAllText(value, string.Empty, Encoding.UTF8);

				base.Path = value;
			}
		}

		/// <summary>
		/// ��ȡ�������б�
		/// </summary>
		/// <returns></returns>
		public override string[] GetValueNames()
		{
			throw new NotImplementedException();
		}

		/// <summary>
		/// ��ȡ����������[�Ƽ�ʹ��]
		/// </summary>
		/// <param name="ClassName">����</param>
		/// <param name="PropertyName">������</param>
		/// <returns></returns>
		public override string this[string ClassName, string PropertyName]
		{
			get
			{
				return Read(ClassName, PropertyName);
			}
			set
			{
				Write(ClassName, PropertyName, value);
			}
		}
	}
}
