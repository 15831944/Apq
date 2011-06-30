using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;

namespace Apq.DllImports
{
	/// <summary>
	/// 
	/// </summary>
	public class User32
	{
		#region ����
		/// <summary>
		/// ��ͨ����
		/// </summary>
		public const int WS_SHOWNORMAL = 1;
		/// <summary>
		/// ͨ������ϵͳ��ȡ�Ƿ��Ѱ�װ���
		/// </summary>
		public const byte SM_MOUSEPRESENT = 19;
		/// <summary>
		/// ͨ������ϵͳ��ȡ��갴����
		/// </summary>
		public const byte SM_CMOUSEBUTTONS = 43;
		/// <summary>
		/// ͨ������ϵͳ��ȡ����Ƿ���й���
		/// </summary>
		public const byte SM_MOUSEWHEELPRESENT = 75;
		/// <summary>
		/// ����ƶ��¼�
		/// </summary>
		public const int MOUSEEVENTF_MOVE = 0x1;
		/// <summary>
		/// ��������¼�
		/// </summary>
		public const int MOUSEEVENTF_LEFTDOWN = 0x2;
		/// <summary>
		/// ����ſ��¼�
		/// </summary>
		public const int MOUSEEVENTF_LEFTUP = 0x4;
		/// <summary>
		/// �м������¼�
		/// </summary>
		public const int MOUSEEVENTF_MIDDLEDOWN = 0x20;
		/// <summary>
		/// �м��ſ��¼�
		/// </summary>
		public const int MOUSEEVENTF_MIDDLEUP = 0x40;
		/// <summary>
		/// �Ҽ������¼�
		/// </summary>
		public const int MOUSEEVENTF_RIGHTDOWN = 0x8;
		/// <summary>
		/// �Ҽ��ſ��¼�
		/// </summary>
		public const int MOUSEEVENTF_RIGHTUP = 0x10;
		#endregion

		#region ����ṹ��
		/// <summary>
		/// ��ʾ���λ��
		/// </summary>
		public struct POINTAPI
		{
			/// <summary>
			/// ���X����
			/// </summary>
			public int x;
			/// <summary>
			/// ���Y����
			/// </summary>
			public int y;
		}

		/// <summary>
		/// ��ʾ���δ�С
		/// </summary>
		public struct RECT
		{
			/// <summary>
			/// left
			/// </summary>
			public int left;
			/// <summary>
			/// top
			/// </summary>
			public int top;
			/// <summary>
			/// right
			/// </summary>
			public int right;
			/// <summary>
			/// bottom
			/// </summary>
			public int bottom;
		}
		#endregion

		#region ����ϵͳ
		/// <summary>
		/// ͨ������ϵͳ��ȡָ����Ϣ
		/// </summary>
		/// <returns></returns>
		[DllImport("User32.dll")]
		public extern static int GetSystemMetrics(int nIndex);
		#endregion

		#region ����
		/// <summary>
		/// ͨ�����ھ����ȡ����ID���߳�ID
		/// </summary>
		/// <param name="hWnd">���ھ��</param>
		/// <param name="lpdwProcessId">����ID</param>
		/// <returns>�߳�ID</returns>
		[DllImport("User32.dll")]
		public static extern int GetWindowThreadProcessId(IntPtr hWnd, ref Int64 lpdwProcessId);

		/// <summary>
		/// ��ȡ���ڵ���Ļ��Χ
		/// </summary>
		/// <returns></returns>
		[DllImport("User32.dll")]
		public extern static int GetWindowRect(IntPtr hwnd, ref RECT lpRect);

		/// <summary>
		/// ����/���� ����
		/// </summary>
		/// <returns></returns>
		[DllImport("User32.dll")]
		public extern static int EnableWindow(IntPtr hwnd, int fEnable);

		/// <summary>
		/// ��ʾ/���� ����
		/// </summary>
		/// <param name="hWnd"></param>
		/// <param name="type"></param>
		/// <returns></returns>
		[DllImport("User32.dll")]
		public static extern bool ShowWindow(IntPtr hWnd, int type);

		/// <summary>
		/// �첽��ʾ����
		/// </summary>
		/// <param name="hWnd"></param>
		/// <param name="cmdShow"></param>
		/// <returns></returns>
		[DllImport("User32.dll")]
		public static extern bool ShowWindowAsync(IntPtr hWnd, int cmdShow);

		/// <summary>
		/// ����ǰ̨����
		/// </summary>
		/// <param name="hWnd"></param>
		/// <returns></returns>
		[DllImport("User32.dll")]
		public static extern bool SetForegroundWindow(IntPtr hWnd);

		/// <summary>
		/// ���Ҵ���
		/// </summary>
		/// <param name="lpClassName"></param>
		/// <param name="lpWindowName">������</param>
		/// <returns></returns>
		[DllImport("User32.dll")]
		public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

		/// <summary>
		/// �����Ӵ���
		/// </summary>
		/// <param name="hwndParent">������</param>
		/// <param name="hwndChildAfter"></param>
		/// <param name="lpszClass"></param>
		/// <param name="lpszWindow"></param>
		/// <returns></returns>
		[DllImport("User32.dll")]
		public static extern IntPtr FindWindowEx(IntPtr hwndParent, IntPtr hwndChildAfter, string lpszClass, string lpszWindow);
		#endregion

		#region ��Ϣ
		/// <summary>
		/// �����巢����Ϣ
		/// </summary>
		/// <param name="hWnd"></param>
		/// <param name="Msg"></param>
		/// <param name="wParam"></param>
		/// <param name="lParam"></param>
		/// <returns></returns>
		[DllImport("User32.dll")]
		public static extern int SendMessage(IntPtr hWnd, int Msg, IntPtr wParam, string lParam);
		#endregion

		#region ����
		/// <summary>
		/// ��ȡ��״̬
		/// </summary>
		/// <param name="nVirtKey"></param>
		/// <returns></returns>
		[DllImport("User32.dll")]
		public static extern short GetKeyState(int nVirtKey);
		#endregion

		#region ���/���
		/// <summary>
		/// ����¼�
		/// </summary>
		[DllImport("User32.dll", EntryPoint = "mouse_event")]
		public static extern void mouse_event(
			 int dwFlags,
			 int dx,
			 int dy,
			 int cButtons,
			 int dwExtraInfo
		);

		/// <summary>
		/// ����������Ҽ�(���ּ�������)
		/// </summary>
		/// <returns></returns>
		[DllImport("User32.dll")]
		public extern static int SwapMouseButton(int bSwap);

		/// <summary>
		/// ���ù���ƶ���Χ
		/// </summary>
		/// <returns></returns>
		[DllImport("User32.dll")]
		public extern static int ClipCursor(ref RECT lpRect);

		/// <summary>
		/// ��ʾ/���� ���
		/// </summary>
		/// <returns></returns>
		[DllImport("User32.dll")]
		public extern static bool ShowCursor(bool bShow);

		/// <summary>
		/// ��ȡ���λ��
		/// </summary>
		/// <returns></returns>
		[DllImport("User32.dll")]
		public extern static int GetCursorPos(ref POINTAPI lpPoint);

		/// <summary>
		/// ���ù��λ��
		/// </summary>
		/// <returns></returns>
		[DllImport("User32.dll")]
		public extern static int SetCursorPos(int x, int y);

		/// <summary>
		/// ��ȡ���˫��ʱ��
		/// </summary>
		/// <returns></returns>
		[DllImport("User32.dll")]
		public extern static int GetDoubleClickTime();

		/// <summary>
		/// �������˫��ʱ��
		/// </summary>
		/// <returns></returns>
		[DllImport("User32.dll")]
		public extern static int SetDoubleClickTime(int wCount);
		#endregion

		#region �ļ�ϵͳ
		/// <summary>
		/// �ͷ�ͼ����Դ
		/// </summary>
		/// <param name="hIcon"></param>
		/// <returns></returns>
		[DllImport("User32.dll", EntryPoint = "DestroyIcon")]
		public static extern int DestroyIcon(IntPtr hIcon);
		#endregion
	}
}
