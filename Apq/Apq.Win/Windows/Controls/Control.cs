using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;

namespace Apq.Windows.Controls
{
	/// <summary>
	/// 
	/// </summary>
	public class Control
	{
		#region ������뷨ȫ������
		/// <summary>
		/// Ϊ�ؼ������ӿؼ�����¼�,�������뷨��ʼΪ���
		/// </summary>
		/// <param name="Ctrl">�ؼ�/����</param>
		public static void AddImeHandler(System.Windows.Forms.Control Ctrl)
		{
			if (Ctrl != null)
			{
				#region ControlAdded
				Ctrl.ControlAdded += new System.Windows.Forms.ControlEventHandler(Ctrl_ControlAdded);
				#endregion

				#region Enter �� CellEnter

				Ctrl.Enter += new EventHandler(Ctrl_Enter);

				Type t = Ctrl.GetType();
				System.Reflection.EventInfo ei = t.GetEvent("CellEnter");
				if (ei != null)
				{
					ei.AddEventHandler(Ctrl, new System.Windows.Forms.DataGridViewCellEventHandler(Ctrl_Enter));
				}

				#endregion

				if (Ctrl.Controls != null)
				{
					foreach (System.Windows.Forms.Control ctr in Ctrl.Controls)
					{
						AddImeHandler(ctr);
					}
				}
			}
		}

		/// <summary>
		/// ��ӿؼ�ʱ,�����¼�����
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private static void Ctrl_ControlAdded(object sender, System.Windows.Forms.ControlEventArgs e)
		{
			// Ϊ�ؼ�������뷨����,������ AddImeHandler ����
			AddImeHandler(e.Control);
		}
		/// <summary>
		/// ����ؼ�ʱ,�������뷨Ϊ���
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private static void Ctrl_Enter(object sender, EventArgs e)
		{
			System.Windows.Forms.Control Ctrl = sender as System.Windows.Forms.Control;
			if (Ctrl == null)
			{
				return;
			}

			IntPtr HIme = Apq.DllImports.Imm32.ImmGetContext(Ctrl.Handle);
			if (Apq.DllImports.Imm32.ImmGetOpenStatus(HIme))
			{
				uint[] iMode = new uint[] { 0 };
				uint[] iSentence = new uint[] { 0 };
				if (Apq.DllImports.Imm32.ImmGetConversionStatus(HIme, ref iMode, ref iSentence))
				{
					if ((iMode[0] & Apq.DllImports.Imm32.IME_CMODE_FULLSHAPE) > 0) //�����ȫ��
					{
						Apq.DllImports.Imm32.ImmSimulateHotKey(Ctrl.Handle, Apq.DllImports.Imm32.IME_CHOTKEY_SHAPE_TOGGLE); //ת���ɰ��
					}
				}
			}
		}
		#endregion
	}
}
