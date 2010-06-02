using System;
using System.Collections.Generic;
using System.Text;

namespace Apq.Text
{
	/// <summary>
	/// StringBuilder
	/// </summary>
	public partial class StringBuilder
	{
		/// <summary>
		/// ��ָ�� StringBuilder ����������ַ���
		/// </summary>
		/// <param name="sb">StringBuilder</param>
		/// <param name="ary">��Ҫ��ӵĶ���(������ ToString() ����)</param>
		public static void Append(System.Text.StringBuilder sb, params object[] ary)
		{
			foreach (object obj in ary)
			{
				sb.Append(obj.ToString());
			}
		}
	}
}
