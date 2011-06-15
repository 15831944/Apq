using System;
using System.Collections.Generic;
using System.Text;
using System.Reflection;
using System.Diagnostics;
using System.Collections;

namespace Apq.Config
{
	/// <summary>
	/// ����
	/// </summary>
	public abstract class clsConfig : MarshalByRefObject
	{
		#region ����
		/// <summary>
		/// �ļ�·��
		/// </summary>
		protected string _Path;
		/// <summary>
		/// ��ȡ�������ļ�·��
		/// </summary>
		public virtual string Path
		{
			get { return _Path; }
			set { _Path = value; }
		}
		/// <summary>
		/// ��
		/// </summary>
		protected string _Root = "Root";	// Ĭ��ֵ
		/// <summary>
		/// ��ȡ�����ø�
		/// </summary>
		public virtual string Root
		{
			get { return _Root; }
			set { _Root = value; }
		}
		#endregion

		#region ��,����,�ر�
		/// <summary>
		/// ������
		/// �ṩ���ɽӿ�,�������ó�
		/// </summary>
		/// <param name="Path"></param>
		public void Open(string Path)
		{
			Open(Path, Root);
		}
		/// <summary>
		/// ������
		/// �ṩ���ɽӿ�,�������ó�
		/// </summary>
		/// <param name="Path"></param>
		/// <param name="Root"></param>
		public void Open(string Path, string Root)
		{
			this.Path = Path;
			this.Root = Root;
		}
		/// <summary>
		/// ��������
		/// </summary>
		public virtual void Save()
		{
		}
		/// <summary>
		/// ���Ϊ
		/// </summary>
		public virtual void SaveAs(string Path)
		{
		}
		/// <summary>
		/// �ر�����
		/// </summary>
		public virtual void Close()
		{
		}
		#endregion

		#region ��ȡ����������
		/// <summary>
		/// ��ȡ�������б�
		/// </summary>
		/// <returns></returns>
		public abstract string[] GetValueNames();

		/// <summary>
		/// ��ȡ����������[�Ƽ�ʹ��]
		/// </summary>
		/// <param name="ClassName">����</param>
		/// <param name="PropertyName">������</param>
		/// <returns></returns>
		public abstract string this[string ClassName, string PropertyName] { get; set; }

		/// <summary>
		/// ��ȡ����ֵ
		/// </summary>
		/// <param name="ClassName">����</param>
		/// <param name="PropertyName">������</param>
		/// <returns>����ֵ</returns>
		public virtual string GetValue(string ClassName, string PropertyName)
		{
			return this[ClassName, PropertyName];
		}

		/// <summary>
		/// ��������ֵ
		/// </summary>
		/// <param name="ClassName">����</param>
		/// <param name="PropertyName">������</param>
		/// <param name="Value">����ֵ</param>
		public virtual void SetValue(string ClassName, string PropertyName, string Value)
		{
			this[ClassName, PropertyName] = Value;
		}

		/// <summary>
		/// ��ȡ����������
		/// </summary>
		/// <param name="t">��</param>
		/// <param name="PropertyName">������</param>
		/// <returns></returns>
		public virtual string this[Type t, string PropertyName]
		{
			get { return this[t.FullName, PropertyName]; }
			set { this[t.FullName, PropertyName] = value; }
		}

		/// <summary>
		/// ��ȡ����ֵ
		/// </summary>
		/// <param name="t">��</param>
		/// <param name="PropertyName">������</param>
		/// <returns>����ֵ</returns>
		public virtual string GetValue(Type t, string PropertyName)
		{
			return this[t, PropertyName];
		}

		/// <summary>
		/// ��������ֵ
		/// </summary>
		/// <param name="t">��</param>
		/// <param name="PropertyName">������</param>
		/// <param name="Value">����ֵ</param>
		public virtual void SetValue(Type t, string PropertyName, string Value)
		{
			this[t, PropertyName] = Value;
		}

		/// <summary>
		/// ��ȡ�����õ�ǰ�������
		/// </summary>
		/// <param name="PropertyName">������</param>
		/// <returns></returns>
		public virtual string this[string PropertyName]
		{
			get
			{
				try
				{
					string strCallingClassName = Apq.Common.GetCallingClass().FullName;
					return this[strCallingClassName, PropertyName];
				}
				catch (System.Exception ex)	// һ���ǲ����ܲ����쳣��,��ֹ�������Ż�
				{
					throw (ex);
				}
			}
			set
			{
				try
				{
					string strCallingClassName = Apq.Common.GetCallingClass().FullName;
					this[strCallingClassName, PropertyName] = value;
				}
				catch (System.Exception ex)	// һ���ǲ����ܲ����쳣��,��ֹ�������Ż�
				{
					throw (ex);
				}
			}
		}

		/// <summary>
		/// ��ȡ��ǰ�������ֵ
		/// </summary>
		/// <param name="PropertyName">������</param>
		/// <returns>����ֵ</returns>
		public virtual string GetValue(string PropertyName)
		{
			try
			{
				string strCallingClassName = Apq.Common.GetCallingClass().FullName;
				return this[strCallingClassName, PropertyName];
			}
			catch (System.Exception ex)	// һ���ǲ����ܲ����쳣��,��ֹ�������Ż�
			{
				throw (ex);
			}
		}

		/// <summary>
		/// ���õ�ǰ�������ֵ
		/// </summary>
		/// <param name="PropertyName">������</param>
		/// <param name="Value">����ֵ</param>
		public virtual void SetValue(string PropertyName, string Value)
		{
			try
			{
				string strCallingClassName = Apq.Common.GetCallingClass().FullName;
				this[strCallingClassName, PropertyName] = Value;
			}
			catch (System.Exception ex)	// һ���ǲ����ܲ����쳣��,��ֹ�������Ż�
			{
				throw (ex);
			}
		}
		#endregion
	}
}
