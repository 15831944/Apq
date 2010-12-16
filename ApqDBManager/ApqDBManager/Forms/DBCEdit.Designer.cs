﻿namespace ApqDBManager.Forms
{
	partial class DBCEdit
	{
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.IContainer components = null;

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		/// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
		protected override void Dispose(bool disposing)
		{
			if (disposing && (components != null))
			{
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		#region Windows Form Designer generated code

		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.btnConfirm = new DevExpress.XtraEditors.SimpleButton();
			this.btnCancel = new DevExpress.XtraEditors.SimpleButton();
			this.labelControl1 = new DevExpress.XtraEditors.LabelControl();
			this.beName = new DevExpress.XtraEditors.ButtonEdit();
			this.labelControl2 = new DevExpress.XtraEditors.LabelControl();
			this.labelControl3 = new DevExpress.XtraEditors.LabelControl();
			this.labelControl4 = new DevExpress.XtraEditors.LabelControl();
			this.labelControl5 = new DevExpress.XtraEditors.LabelControl();
			this.cbDBName = new System.Windows.Forms.ComboBox();
			this.cbServerName = new System.Windows.Forms.ComboBox();
			this.cbUserId = new System.Windows.Forms.ComboBox();
			this.txtPwd = new DevExpress.XtraEditors.TextEdit();
			this.txtOption = new DevExpress.XtraEditors.TextEdit();
			this.labelControl6 = new DevExpress.XtraEditors.LabelControl();
			((System.ComponentModel.ISupportInitialize)(this.beName.Properties)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.txtPwd.Properties)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.txtOption.Properties)).BeginInit();
			this.SuspendLayout();
			// 
			// btnConfirm
			// 
			this.btnConfirm.Location = new System.Drawing.Point(96, 181);
			this.btnConfirm.Name = "btnConfirm";
			this.btnConfirm.Size = new System.Drawing.Size(75, 23);
			this.btnConfirm.TabIndex = 0;
			this.btnConfirm.Text = "确定";
			this.btnConfirm.Click += new System.EventHandler(this.btnConfirm_Click);
			// 
			// btnCancel
			// 
			this.btnCancel.Location = new System.Drawing.Point(228, 181);
			this.btnCancel.Name = "btnCancel";
			this.btnCancel.Size = new System.Drawing.Size(75, 23);
			this.btnCancel.TabIndex = 1;
			this.btnCancel.Text = "取消";
			this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
			// 
			// labelControl1
			// 
			this.labelControl1.Location = new System.Drawing.Point(30, 13);
			this.labelControl1.Name = "labelControl1";
			this.labelControl1.Size = new System.Drawing.Size(24, 14);
			this.labelControl1.TabIndex = 2;
			this.labelControl1.Text = "命名";
			// 
			// beName
			// 
			this.beName.Location = new System.Drawing.Point(130, 10);
			this.beName.Name = "beName";
			this.beName.Properties.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[] {
            new DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Undo)});
			this.beName.Size = new System.Drawing.Size(244, 21);
			this.beName.TabIndex = 3;
			this.beName.ButtonClick += new DevExpress.XtraEditors.Controls.ButtonPressedEventHandler(this.beName_ButtonClick);
			// 
			// labelControl2
			// 
			this.labelControl2.Location = new System.Drawing.Point(30, 41);
			this.labelControl2.Name = "labelControl2";
			this.labelControl2.Size = new System.Drawing.Size(48, 14);
			this.labelControl2.TabIndex = 4;
			this.labelControl2.Text = "数据库名";
			// 
			// labelControl3
			// 
			this.labelControl3.Location = new System.Drawing.Point(30, 68);
			this.labelControl3.Name = "labelControl3";
			this.labelControl3.Size = new System.Drawing.Size(36, 14);
			this.labelControl3.TabIndex = 6;
			this.labelControl3.Text = "服务器";
			// 
			// labelControl4
			// 
			this.labelControl4.Location = new System.Drawing.Point(30, 95);
			this.labelControl4.Name = "labelControl4";
			this.labelControl4.Size = new System.Drawing.Size(36, 14);
			this.labelControl4.TabIndex = 8;
			this.labelControl4.Text = "用户名";
			// 
			// labelControl5
			// 
			this.labelControl5.Location = new System.Drawing.Point(30, 121);
			this.labelControl5.Name = "labelControl5";
			this.labelControl5.Size = new System.Drawing.Size(24, 14);
			this.labelControl5.TabIndex = 10;
			this.labelControl5.Text = "密码";
			// 
			// cbDBName
			// 
			this.cbDBName.FormattingEnabled = true;
			this.cbDBName.Location = new System.Drawing.Point(130, 38);
			this.cbDBName.Name = "cbDBName";
			this.cbDBName.Size = new System.Drawing.Size(244, 20);
			this.cbDBName.TabIndex = 12;
			this.cbDBName.DropDown += new System.EventHandler(this.cbDBName_DropDown);
			// 
			// cbServerName
			// 
			this.cbServerName.FormattingEnabled = true;
			this.cbServerName.Location = new System.Drawing.Point(130, 65);
			this.cbServerName.Name = "cbServerName";
			this.cbServerName.Size = new System.Drawing.Size(244, 20);
			this.cbServerName.TabIndex = 13;
			this.cbServerName.DropDown += new System.EventHandler(this.cbServerName_DropDown);
			// 
			// cbUserId
			// 
			this.cbUserId.FormattingEnabled = true;
			this.cbUserId.Location = new System.Drawing.Point(130, 92);
			this.cbUserId.Name = "cbUserId";
			this.cbUserId.Size = new System.Drawing.Size(244, 20);
			this.cbUserId.TabIndex = 14;
			this.cbUserId.DropDown += new System.EventHandler(this.cbUserId_DropDown);
			// 
			// txtPwd
			// 
			this.txtPwd.Location = new System.Drawing.Point(130, 118);
			this.txtPwd.Name = "txtPwd";
			this.txtPwd.Properties.PasswordChar = '*';
			this.txtPwd.Size = new System.Drawing.Size(244, 21);
			this.txtPwd.TabIndex = 15;
			// 
			// txtOption
			// 
			this.txtOption.Location = new System.Drawing.Point(130, 145);
			this.txtOption.Name = "txtOption";
			this.txtOption.Size = new System.Drawing.Size(244, 21);
			this.txtOption.TabIndex = 17;
			// 
			// labelControl6
			// 
			this.labelControl6.Location = new System.Drawing.Point(30, 148);
			this.labelControl6.Name = "labelControl6";
			this.labelControl6.Size = new System.Drawing.Size(24, 14);
			this.labelControl6.TabIndex = 16;
			this.labelControl6.Text = "选项";
			// 
			// DBCEdit
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(410, 227);
			this.Controls.Add(this.txtOption);
			this.Controls.Add(this.labelControl6);
			this.Controls.Add(this.txtPwd);
			this.Controls.Add(this.cbUserId);
			this.Controls.Add(this.cbServerName);
			this.Controls.Add(this.cbDBName);
			this.Controls.Add(this.labelControl5);
			this.Controls.Add(this.labelControl4);
			this.Controls.Add(this.labelControl3);
			this.Controls.Add(this.labelControl2);
			this.Controls.Add(this.beName);
			this.Controls.Add(this.labelControl1);
			this.Controls.Add(this.btnCancel);
			this.Controls.Add(this.btnConfirm);
			this.Name = "DBCEdit";
			this.Text = "连接设置";
			this.Load += new System.EventHandler(this.DBCEdit_Load);
			((System.ComponentModel.ISupportInitialize)(this.beName.Properties)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.txtPwd.Properties)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.txtOption.Properties)).EndInit();
			this.ResumeLayout(false);
			this.PerformLayout();

		}

		#endregion

		private DevExpress.XtraEditors.SimpleButton btnConfirm;
		private DevExpress.XtraEditors.SimpleButton btnCancel;
		private DevExpress.XtraEditors.LabelControl labelControl1;
		private DevExpress.XtraEditors.ButtonEdit beName;
		private DevExpress.XtraEditors.LabelControl labelControl2;
		private DevExpress.XtraEditors.LabelControl labelControl3;
		private DevExpress.XtraEditors.LabelControl labelControl4;
		private DevExpress.XtraEditors.LabelControl labelControl5;
		private System.Windows.Forms.ComboBox cbDBName;
		private System.Windows.Forms.ComboBox cbServerName;
		private System.Windows.Forms.ComboBox cbUserId;
		private DevExpress.XtraEditors.TextEdit txtPwd;
		private DevExpress.XtraEditors.TextEdit txtOption;
		private DevExpress.XtraEditors.LabelControl labelControl6;
	}
}