namespace Apq.Windows.Forms
{
	partial class WizardDataSet
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
			this._ds = new System.Data.DataSet();
			((System.ComponentModel.ISupportInitialize)(this._ds)).BeginInit();
			this.SuspendLayout();
			// 
			// btnBack
			// 
			this.btnBack.Click += new System.EventHandler(this.btnBack_Click);
			// 
			// btnCancel
			// 
			this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
			// 
			// btnFinish
			// 
			this.btnFinish.Click += new System.EventHandler(this.btnFinish_Click);
			// 
			// btnNext
			// 
			this.btnNext.Click += new System.EventHandler(this.btnNext_Click);
			// 
			// _ds
			// 
			this._ds.DataSetName = "NewDataSet";
			// 
			// WizardDataSet
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
			this.ClientSize = new System.Drawing.Size(600, 423);
			this.Name = "WizardDataSet";
			this.Load += new System.EventHandler(this.WizardDataSet_Load);
			((System.ComponentModel.ISupportInitialize)(this._ds)).EndInit();
			this.ResumeLayout(false);

		}

		#endregion

		private System.Data.DataSet _ds;
	}
}
