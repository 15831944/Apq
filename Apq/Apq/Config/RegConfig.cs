using System;
using System.Collections.Generic;
using System.Text;
using System.Reflection;
using Microsoft.Win32;

namespace Apq.Config
{
	/// <summary>
	/// ע�������
	/// </summary>
	public partial class RegConfig : clsConfig
	{
		private RegistryKey rk;		// ע������
		private RegistryKey rkRoot;	// ����

		/// <summary>
		/// ��ȡ������[����]ע������
		/// <remarks>��ѡֵ:"$reg$" + {ClassesRoot, CurrentConfig, CurrentUser, DynData, LocalMachine, PerformanceData, Users}</remarks>
		/// </summary>
		public override string Path
		{
			get { return base.Path; }
			set
			{
				rk = null;
				rkRoot = null;

				if (!value.StartsWith("$reg$"))
				{
					throw new ArgumentOutOfRangeException("Path", value, @"��ѡֵΪ:
{
	 $reg$ClassesRoot
	,$reg$CurrentConfig
	,$reg$CurrentUser
	,$reg$DynData
	,$reg$LocalMachine
	,$reg$PerformanceData
	,$reg$Users
}
");
				}

				string str = value.Substring(5);
				Type t = typeof(Registry);
				FieldInfo fi = t.GetField(str);
				if (fi != null)
				{
					rk = fi.GetValue(null) as RegistryKey;
				}

				base.Path = value;
			}
		}
		/// <summary>
		/// ��ȡ������ע�����������ƻ�·��
		/// </summary>
		public override string Root
		{
			get
			{
				return base.Root;
			}
			set
			{
				if (rk == null)
				{
					throw new System.Exception("�������� Path��");
				}

				rkRoot = rk.CreateSubKey(value, RegistryKeyPermissionCheck.ReadWriteSubTree);

				base.Root = value;
			}
		}

		/// <summary>
		/// ��ȡ�������б�
		/// </summary>
		/// <returns></returns>
		public override string[] GetValueNames()
		{
			if (rkRoot != null)
			{
				return rkRoot.GetValueNames();
			}
			return null;
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
				if (rkRoot != null)
				{
					RegistryKey rk1 = rkRoot.OpenSubKey(ClassName);
					return rk1.GetValue(PropertyName).ToString();
				}
				return null;
			}
			set
			{
				if (rkRoot == null)
				{
					throw new System.Exception("�������� Root��");
				}

				RegistryKey rk1 = rkRoot.CreateSubKey(ClassName, RegistryKeyPermissionCheck.ReadWriteSubTree);
				rk1.SetValue(PropertyName, value);
			}
		}
	}
}
