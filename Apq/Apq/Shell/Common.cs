using System;
using System.Collections.Generic;
using System.Text;

namespace Apq.Shell
{
	/// <summary>
	/// ��������
	/// </summary>
	public class Common
	{
		/// <summary>
		/// Ĭ��ת���ַ�
		/// </summary>
		public static readonly string ESCAPE = "\\";
		/// <summary>
		/// �����ַ�(������:';')
		/// </summary>
		public static readonly string[] SpecialChars = new string[] { "(", ")", "," };

		/// <summary>
		/// ���ܸ�ʽ:����([�б�])+
		/// �б�ָ���","
		/// �����ַ���:{(),}
		/// </summary>
		/// <param name="str"></param>
		/// <param name="ESCAPE"></param>
		/// <returns></returns>
		public static int cmd(string str, string ESCAPE)
		{
			str = str.Trim();
			if (str.Length == 0)
			{
				return 0;
			}

			if (ESCAPE == null)
			{
				ESCAPE = Apq.Shell.Common.ESCAPE;
			}

			State state = new State();
			ParseResult obj = new ParseResult();

			obj.cmd = Apq.Shell.Common.GetCmd(str, state, ESCAPE);
			if (state.Index < str.Length)
			{
				Apq.Shell.Common.GetPars(str, state, ESCAPE, obj.Pars);
			}

			//return Apq.Shell.exec( obj );
			return 0;
		}

		/// <summary>
		/// ���ýӿ�
		/// </summary>
		/// <param name="str"></param>
		/// <returns></returns>
		public static int cmd(string str)
		{
			return cmd(str, null);
		}

		/// <summary>
		/// ��ȡ����
		/// </summary>
		/// <param name="str"></param>
		/// <param name="state"></param>
		/// <param name="ESCAPE"></param>
		/// <returns></returns>
		public static string GetCmd(string str, State state, string ESCAPE)
		{
			System.Collections.ArrayList ary = new System.Collections.ArrayList();
			for (Char c = Apq.Shell.Char.GetChar(str, state, ESCAPE); c != null; state.Index++, c = Apq.Shell.Char.GetChar(str, state, ESCAPE))
			{
				if (c.Type == 2)
				{
					if (c.Value == "(") break;
					throw new ArgumentException("�����в��ܺ��������ַ�!");
				}
				ary.Add(c);
			}
			StringBuilder cmd = new StringBuilder();
			for (int i = 0; i < ary.Count; i++)
			{
				cmd.Append((ary[i] as Char).Value);
			}

			return cmd.ToString();
		}

		/// <summary>
		/// ����ֵ
		/// </summary>
		/// <param name="Chars"></param>
		/// <param name="index"></param>
		/// <returns></returns>
		public static System.Collections.ArrayList BuildSym(System.Collections.ArrayList Chars, int index)
		{
			System.Collections.ArrayList ary = new System.Collections.ArrayList();
			StringBuilder chs = new StringBuilder();
			for (int i = index; i < Chars.Count; i++)
			{
				Char c = Chars[i] as Char;
				if (c.Type == 0)
				{
					continue;
				}
				if (c.Type == 2)
				{
					if (c.Value == "," || c.Value == ")")
					{
						ary.Add(chs.ToString());
					}
					chs.Remove(0, chs.Length);
					continue;
				}
				chs.Append(c.Value);
			}
			return ary;
		}

		/// <summary>
		/// ��ȡ���Ŷ�
		/// </summary>
		/// <param name="str"></param>
		/// <param name="state"></param>
		/// <param name="ESCAPE"></param>
		/// <param name="Pars"></param>
		public static void GetPars(string str, State state, string ESCAPE, System.Collections.ArrayList Pars)
		{
			System.Collections.ArrayList Chars = new System.Collections.ArrayList();	// �ַ�����
			int index = 0;	// ����������ʼλ��
			for (Char c = Apq.Shell.Char.GetChar(str, state, ESCAPE); c != null; state.Index++, c = Apq.Shell.Char.GetChar(str, state, ESCAPE))
			{
				Chars.Add(c);
				if (c.Type == 2)
				{
					if (c.Value == ")")
					{
						Pars.Add(Apq.Shell.Common.BuildSym(Chars, index));
						index = state.Index + 1;
					}
				}
			}
		}
	}
}
