namespace Apq.Windows.Forms
{
	partial class NotifyIconForm
	{
		/// <summary>
		/// ����������������
		/// </summary>
		private System.ComponentModel.IContainer components = null;

		/// <summary>
		/// ������������ʹ�õ���Դ��
		/// </summary>
		/// <param name="disposing">���Ӧ�ͷ��й���Դ��Ϊ true������Ϊ false��</param>
		protected override void Dispose(bool disposing)
		{
			if (disposing && (components != null))
			{
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		#region Windows ������������ɵĴ���

		/// <summary>
		/// �����֧������ķ��� - ��Ҫ
		/// ʹ�ô���༭���޸Ĵ˷��������ݡ�
		/// </summary>
		private void InitializeComponent()
		{
			this.components = new System.ComponentModel.Container();
			this.notifyIcon1 = new System.Windows.Forms.NotifyIcon(this.components);
			this.timerNotifyIcon1 = new System.Windows.Forms.Timer(this.components);
			this.SuspendLayout();
			// 
			// notifyIcon1
			// 
			this.notifyIcon1.Text = "notifyIcon1";
			this.notifyIcon1.Visible = true;
			this.notifyIcon1.Click += new System.EventHandler(this.notifyIcon1_Click);
			// 
			// timerNotifyIcon1
			// 
			this.timerNotifyIcon1.Interval = 500;
			this.timerNotifyIcon1.Tick += new System.EventHandler(this.timerNotifyIcon1_Tick);
			// 
			// NotifyIconForm
			// 
			this.ClientSize = new System.Drawing.Size(292, 267);
			this.Name = "NotifyIconForm";
			this.SizeChanged += new System.EventHandler(this.NotifyIconForm_SizeChanged);
			this.ResumeLayout(false);

		}

		#endregion

		/// <summary>
		/// notifyIcon1
		/// </summary>
		public System.Windows.Forms.NotifyIcon notifyIcon1;
		/// <summary>
		/// ��ʱ��,��������ͼ��
		/// </summary>
		public System.Windows.Forms.Timer timerNotifyIcon1;

	}
}
