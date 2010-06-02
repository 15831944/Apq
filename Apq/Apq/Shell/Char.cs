using System;
using System.Collections.Generic;
using System.Text;

namespace Apq.Shell
{
	/// <summary>
	/// �ַ�
	/// </summary>
	public class Char
	{
		/// <summary>
		/// ֵ
		/// </summary>
		public string Value = "";
		/// <summary>
		/// ����
		/// </summary>
		public int Type;

		/// <summary>
		/// ��ȡָ��λ�õ��ַ�[��Ϊת����Զ�ȡ��һλ��]
		/// </summary>
		/// <param name="str"></param>
		/// <param name="state"></param>
		/// <param name="ESCAPE"></param>
		/// <returns></returns>
		public static Char GetChar(string str, State state, string ESCAPE)
		{
			if (state.Index >= str.Length)
			{
				return null;
			}
			Char c = new Char();
			c.Value = str[state.Index].ToString();
			if (c.Value == ESCAPE)
			{
				try
				{
					c.Value = Transform(str[++state.Index].ToString());
				}
				catch { }
				c.Type = 1;
			}
			else
			{
				c.Type = Apq.Collections.IList.Contains(Apq.Shell.Common.SpecialChars, c.Value) ? 2 : 1;
			}
			return c;
		}

		/// <summary>
		/// �����ڴ�����ת���ַ��Ķ���
		/// </summary>
		/// <param name="c"></param>
		/// <returns></returns>
		public static string Transform(string c)
		{
			/* ����:
			if( c == 'n' )
			{
				return '\n';
			}
			if( c == 'v' )
			{
				return '\v';
			}
			*/
			return c;
		}
	}
}
