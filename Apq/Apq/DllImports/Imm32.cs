using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;

namespace Apq.DllImports
{
	/// <summary>
	/// Imm32
	/// </summary>
	public class Imm32
	{
		/// <summary>
		/// ȫ��
		/// </summary>
		public const int IME_CMODE_FULLSHAPE = 0x8;
		/// <summary>
		/// ���
		/// </summary>
		public const int IME_CHOTKEY_SHAPE_TOGGLE = 0x11;

		#region OpenStatus
		/// <summary>
		/// ��ȡ���뷨��״̬
		/// </summary>
		/// <param name="himc"></param>
		/// <returns></returns>
		[DllImport("Imm32.dll")]
		public static extern bool ImmGetOpenStatus(IntPtr himc);
		/// <summary>
		/// �������뷨��״̬
		/// </summary>
		/// <param name="himc"></param>
		/// <param name="b"></param>
		/// <returns></returns>
		[DllImport("Imm32.dll")]
		public static extern bool ImmSetOpenStatus(IntPtr himc, int b);
		#endregion

		/// <summary>
		/// ��ȡ���뷨���
		/// </summary>
		/// <param name="hwnd"></param>
		/// <returns></returns>
		[DllImport("Imm32.dll")]
		public static extern IntPtr ImmGetContext(IntPtr hwnd);

		/// <summary>
		/// �������뷨��Ϣ
		/// </summary>
		/// <param name="himc"></param>
		/// <param name="lpdw"></param>
		/// <param name="lpdw2"></param>
		/// <returns></returns>
		[DllImport("Imm32.dll")]
		public static extern bool ImmGetConversionStatus(IntPtr himc, ref uint[] lpdw, ref uint[] lpdw2);
		/// <summary>
		/// ģ�ⰴ��(����ת�����)
		/// </summary>
		/// <param name="hwnd"></param>
		/// <param name="lngHotkey"></param>
		/// <returns></returns>
		[DllImport("Imm32.dll")]
		public static extern int ImmSimulateHotKey(IntPtr hwnd, uint lngHotkey);
	}
}
