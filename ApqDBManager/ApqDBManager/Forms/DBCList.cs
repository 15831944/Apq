﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using WeifenLuo.WinFormsUI.Docking;
using System.Security.Cryptography;
using System.IO;

namespace ApqDBManager.Forms
{
	public partial class DBCList : Apq.Windows.Forms.DockForm, Apq.Editor.IFileLoader
	{
		public DBCList()
		{
			InitializeComponent();
		}

		protected DataSet ds = new DataSet();

		private void DBCList_Load(object sender, EventArgs e)
		{
			// 数据集结构
			DataTable dt = ds.Tables.Add("DBC");
			dt.Columns.Add("name");
			dt.Columns.Add("value");
			dt.Columns.Add("DBName");
			dt.Columns.Add("ServerName");
			dt.Columns.Add("UserId");
			dt.Columns.Add("Pwd");
			dt.Columns.Add("Option");

			// 设置绑定
			gridControl1.DataSource = ds;
			gridControl1.DataMember = "DBC";

			Apq.Windows.Controls.Control.AddImeHandler(this);
			Apq.Xtra.Grid.Common.AddBehaivor(gridView1);
		}

		#region IFileLoader 成员

		protected string _FileName = string.Empty;
		public string FileName
		{
			get
			{
				return _FileName;
			}
			set
			{
				_FileName = value;
				Text = value;
				TabText = value;
			}
		}

		public void Open()
		{
			OpenFileDialog openFileDialog = new OpenFileDialog();
			openFileDialog.RestoreDirectory = true;
			openFileDialog.Filter = "DBC文件(*.res)|*.res|所有文件(*.*)|*.*";
			if (openFileDialog.ShowDialog(this) == DialogResult.OK)
			{
				FileName = openFileDialog.FileName;
				string desKey = GlobalObject.RegConfigChain["Crypt", "DESKey"];
				string desIV = GlobalObject.RegConfigChain["Crypt", "DESIV"];
				string strCs = File.ReadAllText(FileName);
				string str = Apq.Security.Cryptography.DESHelper.DecryptString(strCs, desKey, desIV);
				StringReader sr = new StringReader(str);
				ds.Clear();
				ds.ReadXml(sr);
			}
		}

		public void Save()
		{
			if (FileName.Length < 1)
			{
				SaveFileDialog saveFileDialog = new SaveFileDialog();
				saveFileDialog.RestoreDirectory = true;
				saveFileDialog.Filter = "DBC文件(*.res)|*.res|所有文件(*.*)|*.*";
				if (saveFileDialog.ShowDialog(this) == DialogResult.OK)
				{
					FileName = saveFileDialog.FileName;
				}
				else
				{
					return;
				}
			}

			string csStr = ds.GetXml();
			string desKey = GlobalObject.RegConfigChain["Crypt", "DESKey"];
			string desIV = GlobalObject.RegConfigChain["Crypt", "DESIV"];
			string strCs = Apq.Security.Cryptography.DESHelper.EncryptString(csStr, desKey, desIV);
			File.WriteAllText(FileName, strCs, Encoding.UTF8);
		}

		public void SaveAs(string FileName)
		{
			this.FileName = FileName;
			Save();
		}

		#endregion

		private void ribeName_ButtonClick(object sender, DevExpress.XtraEditors.Controls.ButtonPressedEventArgs e)
		{
			ds.Tables[0].Rows[gridView1.FocusedRowHandle]["name"] = ds.Tables[0].Rows[gridView1.FocusedRowHandle]["DBName"];
			ds.Tables[0].AcceptChanges();
		}

		private void ribePwd_ButtonClick(object sender, DevExpress.XtraEditors.Controls.ButtonPressedEventArgs e)
		{
			//ribePwd.PasswordChar = ribePwd.PasswordChar == '*' ? new char() : '*';
			MessageBox.Show(ds.Tables[0].Rows[gridView1.FocusedRowHandle]["Pwd"].ToString(), "查看密码");
		}

		private void bbiAdd_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
		{
			DBCEdit win = Apq.Windows.Forms.SingletonForms.GetInstance(typeof(DBCEdit)) as DBCEdit;
			if (win != null)
			{
				DataRow dr = ds.Tables[0].NewRow();
				win.ViewOne(dr, false);
				if (win.ShowDialog(this) == DialogResult.OK)
				{
					ds.Tables[0].Rows.Add(dr);
				}
			}
		}

		private void bbiOld_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
		{
			SaveFileDialog saveFileDialog = new SaveFileDialog();
			saveFileDialog.RestoreDirectory = true;
			saveFileDialog.Filter = "DBC旧版文件(*.res)|*.res|所有文件(*.*)|*.*";
			if (saveFileDialog.ShowDialog(this) == DialogResult.OK)
			{
				//FileName = saveFileDialog.FileName;
			}
			else
			{
				return;
			}

			System.Xml.XmlDocument xd = Apq.Xml.XmlDocument.NewXmlDocument();

			foreach (DataRow dr in ds.Tables[0].Rows)
			{
				System.Xml.XmlElement xe = xd.CreateElement("cs");
				xd.DocumentElement.AppendChild(xe);

				System.Xml.XmlAttribute xa = xd.CreateAttribute("name");
				xa.Value = dr["name"].ToString();
				xe.Attributes.Append(xa);

				xa = xd.CreateAttribute("value");
				string str = Apq.ConnectionStrings.SQLServer.SqlConnection.GetConnectionString(
					dr["ServerName"].ToString(),
					dr["UserId"].ToString(),
					dr["Pwd"].ToString(),
					dr["DBName"].ToString(),
					dr["Option"].ToString()
				);
				xa.Value = str;
				xe.Attributes.Append(xa);
			}

			string csStr = xd.DocumentElement.OuterXml;
			string desKey = GlobalObject.RegConfigChain["Crypt", "DESKey"];
			string desIV = GlobalObject.RegConfigChain["Crypt", "DESIV"];
			string strCs = Apq.Security.Cryptography.DESHelper.EncryptString(csStr, desKey, desIV);
			File.WriteAllText(saveFileDialog.FileName, strCs, Encoding.UTF8);
		}

		private void bbiEdit_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
		{
			if (gridView1.FocusedRowHandle >= 0)
			{
				DBCEdit win = Apq.Windows.Forms.SingletonForms.GetInstance(typeof(DBCEdit)) as DBCEdit;
				if (win != null)
				{
					DataRow dr = ds.Tables[0].Rows[gridView1.FocusedRowHandle];
					win.ViewOne(dr, false);
					win.ShowDialog(this);
				}
			}
		}

		private void bbiView_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
		{
			if (gridView1.FocusedRowHandle >= 0)
			{
				DBCEdit win = Apq.Windows.Forms.SingletonForms.GetInstance(typeof(DBCEdit)) as DBCEdit;
				if (win != null)
				{
					DataRow dr = ds.Tables[0].Rows[gridView1.FocusedRowHandle];
					win.ViewOne(dr, true);
					win.ShowDialog(this);
				}
			}
		}

		private void bbiCs_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
		{
			if (gridView1.FocusedRowHandle >= 0)
			{
				DataRow dr = ds.Tables[0].Rows[gridView1.FocusedRowHandle];
				string strCs = Apq.ConnectionStrings.SQLServer.SqlConnection.GetConnectionString(
					dr["ServerName"].ToString(),
					dr["UserId"].ToString(),
					dr["Pwd"].ToString(),
					dr["DBName"].ToString(),
					dr["Option"].ToString()
				);
				MessageBox.Show(strCs, "查看连接字符串");
			}
		}

		private void bbiDelete_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
		{
			if (gridView1.FocusedRowHandle >= 0)
			{
				ds.Tables[0].Rows.RemoveAt(gridView1.FocusedRowHandle);
				ds.Tables[0].AcceptChanges();
			}
		}
	}
}