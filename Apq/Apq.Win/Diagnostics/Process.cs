using System;
using System.Collections.Generic;
using System.Text;

namespace Apq.Diagnostics
{
	/// <summary>
	/// Process
	/// </summary>
	public class Process
	{
		/// <summary>
		/// ��ȡ�������еı�����ʵ��
		/// </summary>
		/// <returns></returns>
		public static System.Diagnostics.Process GetRunningAnotherInstance()
		{
			System.Diagnostics.Process current = System.Diagnostics.Process.GetCurrentProcess();
			System.Diagnostics.Process[] processes = System.Diagnostics.Process.GetProcessesByName(current.ProcessName);

			foreach (System.Diagnostics.Process process in processes)
			{
				if (process.Id != current.Id && process.MainModule.FileName == current.MainModule.FileName)
				{
					return process;
				}
			}
			return null;
		}
	}
}
