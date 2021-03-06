﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using WeifenLuo.WinFormsUI.Docking;
using System.Threading;
using System.Data.SqlClient;
using System.Data.Common;
using Apq_DBTools.Forms;
using Apq.TreeListView;
using System.IO;
using org.mozilla.intl.chardet;
using Apq.DllImports;
using System.Collections;
using MySql.Data.MySqlClient;
using System.Text.RegularExpressions;

namespace Apq_DBTools
{
	public partial class SqlGen : Apq.Windows.Forms.DockForm
	{
		public SqlGenPanel SqlGenPanel = null;

		private Apq.Windows.Forms.DockForms.ErrList ErrList = new Apq.Windows.Forms.DockForms.ErrList();

		public SqlGen()
		{
			InitializeComponent();

			//Apq.Windows.Forms.DataGridViewHelper.SetDefaultStyle(dataGridView1);
			Apq.Windows.Forms.DataGridViewHelper.AddBehaivor(dataGridView1);
			Apq.Windows.Forms.DataGridViewHelper.SetDefaultStyle(dgvTableKey);
			Apq.Windows.Forms.DataGridViewHelper.AddBehaivor(dgvTableKey);
		}

		private Apq.Data.Common.DBProduct _DBConnectionType = Apq.Data.Common.DBProduct.MySql;
		private DbConnection _DBConnection;

		public override void SetUILang(Apq.UILang.UILang UILang)
		{
			Text = Apq.GlobalObject.UILang["脚本生成"];
			TabText = Text;

			tsbConnectDB.Text = Apq.GlobalObject.UILang["连接"];
			tsmiRefresh.Text = Apq.GlobalObject.UILang["刷新(&F)"];

			tssbSelect.Text = Apq.GlobalObject.UILang["选择"];
			tsmiSelectAll.Text = Apq.GlobalObject.UILang["全选(&A)"];
			tsmiSelectReverse.Text = Apq.GlobalObject.UILang["反选(&R)"];
			tsmiSelectTable.Text = Apq.GlobalObject.UILang["表(&T)"];
			tsmiSelectProc.Text = Apq.GlobalObject.UILang["存储过程(&P)"];
			tsmiSelectTrigger.Text = Apq.GlobalObject.UILang["触发器(&I)"];

			tssbGenSql.Text = Apq.GlobalObject.UILang["生成"];
			tsmiMeta.Text = Apq.GlobalObject.UILang["元数据脚本(&M)"];
			tsmiData.Text = Apq.GlobalObject.UILang["初始化数据(&D)"];

			// 列
			checkStateDataGridViewTextBoxColumn.HeaderText = Apq.GlobalObject.UILang["选择"];
			objectTypeDataGridViewTextBoxColumn.HeaderText = Apq.GlobalObject.UILang["类型"];
			schemaNameDataGridViewTextBoxColumn.HeaderText = Apq.GlobalObject.UILang["架构"];
			objectNameDataGridViewTextBoxColumn.HeaderText = Apq.GlobalObject.UILang["名称"];

			schemaNameDataGridViewTextBoxColumn1.HeaderText = Apq.GlobalObject.UILang["架构"];
			tableNameDataGridViewTextBoxColumn.HeaderText = Apq.GlobalObject.UILang["表名"];
			primaryKeysDataGridViewTextBoxColumn.HeaderText = Apq.GlobalObject.UILang["数据Key"];

			sfdMeta.Filter = Apq.GlobalObject.UILang["SQL 文件(*.sql)|*.sql|所有文件(*.*)|*.*"];
		}

		private void SqlGen_Load(object sender, EventArgs e)
		{
			_xsd.Meta.RowChanged += new DataRowChangeEventHandler(Meta_RowChanged);

			tscbSqlProduct.SelectedIndex = 0;

			//tsbConnectDB_ButtonClick(sender, e);
		}

		void Meta_RowChanged(object sender, DataRowChangeEventArgs e)
		{
			if (e.Action == DataRowAction.Change)
			{
				e.Row.AcceptChanges();
				Menu_SetCheckState();
			}
		}

		#region IDataShow 成员
		/// <summary>
		/// 前期准备(如数据库连接或文件等)
		/// </summary>
		public override void InitDataBefore()
		{
			#region 数据库连接
			#endregion
		}
		/// <summary>
		/// 初始数据(如Lookup数据等)
		/// </summary>
		/// <param name="ds"></param>
		public override void InitData(DataSet ds)
		{
			#region 准备数据集结构
			#endregion

			#region 加载所有字典表
			_xsd.dic_ObjectType.InitData();
			_xsd.dbv_table_key.InitData();
			#endregion
		}
		/// <summary>
		/// 加载数据
		/// </summary>
		/// <param name="ds"></param>
		public override void LoadData(DataSet ds)
		{
		}
		#endregion

		public void UIEnable(bool Enable)
		{
			dataGridView1.Enabled = Enable;
			tsbConnectDB.Enabled = Enable;
			tssbGenSql.Enabled = Enable;

			Cursor = Enable ? Cursors.Default : Cursors.WaitCursor;
		}

		private void SqlGen_FormClosing(object sender, FormClosingEventArgs e)
		{
		}

		private void SqlGen_Activated(object sender, EventArgs e)
		{
		}

		private void SqlGen_Deactivate(object sender, EventArgs e)
		{

		}

		private void Menu_SetCheckState()
		{
			bool hasSameCheckState_Table = true;// 记录所有行是否为同一种选中状态
			int iCheckState_Table = -1;// 记录上一行选中状态

			bool hasSameCheckState_Proc = true;// 记录所有行是否为同一种选中状态
			int iCheckState_Proc = -1;// 记录上一行选中状态

			bool hasSameCheckState_Trigger = true;// 记录所有行是否为同一种选中状态
			int iCheckState_Trigger = -1;// 记录上一行选中状态

			foreach (SqlGen_XSD.MetaRow dr in _xsd.Meta.Rows)
			{
				if (dr.ObjectType == 1)
				{
					if (iCheckState_Table >= 0 && iCheckState_Table != Apq.Convert.ChangeType<int>(dr._CheckState))
					{
						hasSameCheckState_Table = false;
					}
					iCheckState_Table = Apq.Convert.ChangeType<int>(dr._CheckState);
				}
				if (dr.ObjectType == 2)
				{
					if (iCheckState_Proc >= 0 && iCheckState_Proc != Apq.Convert.ChangeType<int>(dr._CheckState))
					{
						hasSameCheckState_Proc = false;
					}
					iCheckState_Proc = Apq.Convert.ChangeType<int>(dr._CheckState);
				}
				if (dr.ObjectType == 3)
				{
					if (iCheckState_Trigger >= 0 && iCheckState_Trigger != Apq.Convert.ChangeType<int>(dr._CheckState))
					{
						hasSameCheckState_Trigger = false;
					}
					iCheckState_Trigger = Apq.Convert.ChangeType<int>(dr._CheckState);
				}
			}

			if (hasSameCheckState_Table && iCheckState_Table >= 0)
			{
				tsmiSelectTable.CheckState = Apq.Convert.ChangeType<CheckState>(iCheckState_Table);
			}
			if (hasSameCheckState_Proc && iCheckState_Proc >= 0)
			{
				tsmiSelectProc.CheckState = Apq.Convert.ChangeType<CheckState>(iCheckState_Proc);
			}
			if (hasSameCheckState_Trigger && iCheckState_Trigger >= 0)
			{
				tsmiSelectTrigger.CheckState = Apq.Convert.ChangeType<CheckState>(iCheckState_Trigger);
			}
		}

		// 刷新
		private void tsbRefresh_Click(object sender, EventArgs e)
		{
			try
			{
				_DBConnection.Open();
			}
			catch
			{
				MessageBox.Show(this, Apq.GlobalObject.UILang["数据库未连接或已断开"]);
				return;
			}
			finally
			{
				Apq.Data.Common.DbConnectionHelper.Close(_DBConnection);
			}

			ErrList.ErrXSD.ErrList.Clear();
			_xsd.Meta.Rows.Clear();
			_xsd.dbv_trigger.Rows.Clear();
			_xsd.dbv_proc.Rows.Clear();
			_xsd.dbv_column.Rows.Clear();
			_xsd.dbv_table.Rows.Clear();

			try
			{
				Apq.Data.Common.DbConnectionHelper dch = new Apq.Data.Common.DbConnectionHelper(_DBConnection);
				DbDataAdapter dda = dch.CreateAdapter();
				if (_DBConnectionType == Apq.Data.Common.DBProduct.MySql)
				{
					// 表
					dda.SelectCommand.CommandText = @"
SELECT `TABLE_SCHEMA` as SchemaName,`Table_Name` as TableName,`ENGINE`,`CREATE_OPTIONS`,`TABLE_COMMENT`,'' as PrimaryKeys
  FROM `information_schema`.`TABLES`
 WHERE `TABLE_SCHEMA` = DATABASE() AND `Table_Name` NOT IN ('dbv_BuildLog','dbv_table','dbv_column','dbv_trigger','dbv_view','dbv_proc');
";
					dda.Fill(_xsd.dbv_table);
					// 列
					dda.SelectCommand.CommandText = @"
SELECT `COLUMN_NAME` as ColName,
	CONVERT(`COLUMN_DEFAULT` USING utf8) AS DefaultValue,
	CASE `IS_NULLABLE` WHEN 'NO' THEN 0 ELSE 1 END as NullAble,
	`DATA_TYPE`,`CHARACTER_MAXIMUM_LENGTH`,`CHARACTER_OCTET_LENGTH`,`NUMERIC_PRECISION`,`NUMERIC_SCALE`,`CHARACTER_SET_NAME`,`COLLATION_NAME`,
	CONVERT(`COLUMN_TYPE` USING utf8) AS COLUMN_TYPE,
	`COLUMN_KEY`,
	CASE WHEN INSTR(`EXTRA`,'auto_increment') > 0 THEN 1 ELSE 0 END as is_auto_increment,
	`COLUMN_COMMENT`,c.`TABLE_SCHEMA` as SchemaName,c.`TABLE_NAME` as TableName
  FROM `information_schema`.`COLUMNS` c 
	INNER JOIN `information_schema`.`TABLES` t ON c.`TABLE_SCHEMA` = t.`TABLE_SCHEMA` AND c.`TABLE_NAME` = t.`TABLE_NAME` 
	-- INNER JOIN `dbv_table` dt ON t.`TABLE_SCHEMA` = dt.`SchemaName` AND t.`TABLE_NAME` = dt.`TableName`
 WHERE c.`TABLE_SCHEMA` = DATABASE() AND t.`Table_Name` NOT IN ('dbv_BuildLog','dbv_table','dbv_column','dbv_trigger','dbv_view','dbv_proc');
";
					dda.Fill(_xsd.dbv_column);
					// 视图
					dda.SelectCommand.CommandText = @"
SELECT `TABLE_SCHEMA` as SchemaName,`Table_Name` as TableName,`VIEW_DEFINITION`
  FROM `information_schema`.`VIEWS`
 WHERE `TABLE_SCHEMA` = DATABASE();
";
					dda.Fill(_xsd.dbv_view);
					// 存储过程,函数
					dda.SelectCommand.CommandText = @"
SELECT `db` AS SchemaName,`name` AS ProcName,
	CASE `type` WHEN 'FUNCTION' THEN 4 ELSE 2 END AS type,
	CONVERT(`param_list` USING utf8) AS param_list,
	CONVERT(`returns` USING utf8) AS RETURNS,
	CONVERT(`body` USING utf8) AS body,
	`comment`
  FROM `mysql`.`proc`
 WHERE `db` = DATABASE() AND `name` NOT IN ('Apq_CreateNewTable');
";
					dda.Fill(_xsd.dbv_proc);
					// 触发器
					dda.SelectCommand.CommandText = @"
SELECT `TRIGGER_SCHEMA` as SchemaName,`TRIGGER_NAME` as TriName,`EVENT_MANIPULATION`,`EVENT_OBJECT_TABLE` as TableName,`ACTION_ORDER`,`ACTION_CONDITION`,`ACTION_STATEMENT`,`ACTION_ORIENTATION`,`ACTION_TIMING`
  FROM `information_schema`.`TRIGGERS` t
 WHERE t.`TRIGGER_SCHEMA` = DATABASE();
";
					dda.Fill(_xsd.dbv_trigger);

					// 为列设置TID
					foreach (SqlGen_XSD.dbv_columnRow dr in _xsd.dbv_column.Rows)
					{
						SqlGen_XSD.dbv_tableRow drT = _xsd.dbv_table.FindByTableName(dr.SchemaName, dr.TableName);
						dr.TID = drT.TID;
					}
					// 为表查找主键列
					foreach (SqlGen_XSD.dbv_tableRow dr in _xsd.dbv_table.Rows)
					{
						SqlGen_XSD.dbv_columnRow[] drCs = dr.GetChildRows("FK_dbv_table_dbv_column") as SqlGen_XSD.dbv_columnRow[];
						string strCols = string.Empty;
						foreach (SqlGen_XSD.dbv_columnRow drc in drCs)
						{
							if ("PRI".Equals(drc.COLUMN_KEY, StringComparison.OrdinalIgnoreCase))
							{
								strCols += ",`" + drc.ColName + "`";
							}
						}
						if (strCols.Length > 0)
						{
							dr.PrimaryKeys = strCols.Substring(1);
						}
					}
					// 将名称加到元数据表，用于界面显示
					int nCheckState = Apq.Convert.ChangeType<int>(tsmiSelectTable.CheckState);
					foreach (SqlGen_XSD.dbv_tableRow drT in _xsd.dbv_table.Rows)
					{
						SqlGen_XSD.MetaRow drMeta = _xsd.Meta.NewMetaRow();
						drMeta.ObjectType = 1;
						drMeta._CheckState = nCheckState;
						drMeta.SchemaName = drT.SchemaName;
						drMeta.ObjectName = drT.TableName;
						_xsd.Meta.Rows.Add(drMeta);
					}
					foreach (SqlGen_XSD.dbv_viewRow drV in _xsd.dbv_view.Rows)
					{
						SqlGen_XSD.MetaRow drMeta = _xsd.Meta.NewMetaRow();
						drMeta.ObjectType = 6;
						drMeta._CheckState = nCheckState;
						drMeta.SchemaName = drV.SchemaName;
						drMeta.ObjectName = drV.TableName;
						_xsd.Meta.Rows.Add(drMeta);
					}
					nCheckState = Apq.Convert.ChangeType<int>(tsmiSelectProc.CheckState);
					foreach (SqlGen_XSD.dbv_procRow drP in _xsd.dbv_proc.Rows)
					{
						SqlGen_XSD.MetaRow drMeta = _xsd.Meta.NewMetaRow();
						drMeta.ObjectType = drP.type;
						drMeta._CheckState = nCheckState;
						drMeta.SchemaName = drP.SchemaName;
						drMeta.ObjectName = drP.ProcName;
						_xsd.Meta.Rows.Add(drMeta);
					}
					nCheckState = Apq.Convert.ChangeType<int>(tsmiSelectTrigger.CheckState);
					foreach (SqlGen_XSD.dbv_triggerRow drTri in _xsd.dbv_trigger.Rows)
					{
						SqlGen_XSD.MetaRow drMeta = _xsd.Meta.NewMetaRow();
						drMeta.ObjectType = 3;
						drMeta._CheckState = nCheckState;
						drMeta.SchemaName = drTri.SchemaName;
						drMeta.ObjectName = drTri.TriName;
						_xsd.Meta.Rows.Add(drMeta);
					}
				}
			}
			catch (Exception ex)
			{
				MessageBox.Show(this, ex.Message);
			}
			finally
			{
				if (ErrList.ErrXSD.ErrList.Rows.Count > 0)
				{
					ErrList.Show(SqlGenPanel.DockDoc);
				}
			}
		}

		private void tsbConnectDB_ButtonClick(object sender, EventArgs e)
		{
			// 连接到数据库并执行刷新动作
			Apq.Windows.Forms.DBConnector DBConnector = new Apq.Windows.Forms.DBConnector();
			if (DBConnector.ShowDialog(GlobalObject.MainForm) == System.Windows.Forms.DialogResult.OK)
			{
				_DBConnectionType = DBConnector.DBSelected;
				_DBConnection = DBConnector.DBConnection;
				tsbRefresh_Click(sender, e);

				this.Show();
			}
		}
		// 生成元数据语句并保存到文件
		private void tsmiMeta_Click(object sender, EventArgs e)
		{
			if (tscbSqlProduct.SelectedIndex != 0)
			{
				string strExMsg = Apq.GlobalObject.UILang["尚未实现！"];
				//ErrList.AddRow(DateTime.Now, 4, 16, Apq.GlobalObject.UILang["尚未实现"], strExMsg);
				MessageBox.Show(this, strExMsg);
				return;
			}
			try
			{
				_DBConnection.Open();
			}
			catch
			{
				MessageBox.Show(this, Apq.GlobalObject.UILang["数据库未连接或已断开"]);
				return;
			}
			finally
			{
				Apq.Data.Common.DbConnectionHelper.Close(_DBConnection);
			}

			StringBuilder sb = new StringBuilder();
			sfdMeta.InitialDirectory = GlobalObject.XmlConfigChain[this.GetType(), "sfdMeta_InitialDirectory"];
			if (sfdMeta.ShowDialog(this) == System.Windows.Forms.DialogResult.OK)
			{
				GlobalObject.XmlConfigChain[this.GetType(), "sfdMeta_InitialDirectory"] = Path.GetDirectoryName(sfdMeta.FileName);

				if (tscbSqlProduct.SelectedIndex == 0)
				{
					#region 创建元数据表
					// 为列表中已选中的项生成语句，语句完成将这些项插入到dbv_table,dbv_column,dbv_proc中
					sb.Append(string.Format(@"
/* -------------------------------------------------------------------------------------------------
该文件由Apq_DBTools自动生成

数据库创建
dbv表创建
元数据导入
基本存储过程（根据元数据无损构建数据库）

====================================================================================================
*/
CREATE DATABASE IF NOT EXISTS `{0}` DEFAULT CHARACTER SET utf8;
USE `{0}`;
SET FOREIGN_KEY_CHECKS=0;",_DBConnection.Database));
					sb.Append(@"
-- 元数据表 -----------------------------------------------------------------------------------------");
					string strFilePath = Path.GetDirectoryName(Apq.GlobalObject.TheProcess.MainModule.FileName) + @"\Sql\MySql\dbv_table.sql";
					string strFileContent = Environment.NewLine + File.ReadAllText(strFilePath) + Environment.NewLine;
					sb.Append(strFileContent);
					strFilePath = Path.GetDirectoryName(Apq.GlobalObject.TheProcess.MainModule.FileName) + @"\Sql\MySql\dbv_column.sql";
					strFileContent = Environment.NewLine + File.ReadAllText(strFilePath) + Environment.NewLine;
					sb.Append(strFileContent);
					strFilePath = Path.GetDirectoryName(Apq.GlobalObject.TheProcess.MainModule.FileName) + @"\Sql\MySql\dbv_view.sql";
					strFileContent = Environment.NewLine + File.ReadAllText(strFilePath) + Environment.NewLine;
					sb.Append(strFileContent);
					strFilePath = Path.GetDirectoryName(Apq.GlobalObject.TheProcess.MainModule.FileName) + @"\Sql\MySql\dbv_trigger.sql";
					strFileContent = Environment.NewLine + File.ReadAllText(strFilePath) + Environment.NewLine;
					sb.Append(strFileContent);
					strFilePath = Path.GetDirectoryName(Apq.GlobalObject.TheProcess.MainModule.FileName) + @"\Sql\MySql\dbv_proc.sql";
					strFileContent = Environment.NewLine + File.ReadAllText(strFilePath) + Environment.NewLine;
					sb.Append(strFileContent);
					sb.Append(@"
-- =================================================================================================

-- 基本存储过程 -------------------------------------------------------------------------------------");
					strFilePath = Path.GetDirectoryName(Apq.GlobalObject.TheProcess.MainModule.FileName) + @"\Sql\MySql\Apq_CreateNewTable.sql";
					strFileContent = Environment.NewLine + File.ReadAllText(strFilePath) + Environment.NewLine;
					sb.Append(strFileContent);
					sb.Append(@"
-- =================================================================================================

-- 元数据 ------------------------------------------------------------------------------------------"
					);
					#endregion

					#region 填充元数据
					foreach (SqlGen_XSD.MetaRow dr in _xsd.Meta.Rows)
					{
						if (dr.ObjectType == 1)
						{
							SqlGen_XSD.dbv_tableRow drT = _xsd.dbv_table.FindByTableName(dr.SchemaName, dr.ObjectName);
							sb.Append(string.Format(@"

-- 表:{0}
INSERT INTO `dbv_table`(`TID`,`SchemaName`,`TableName`,`ENGINE`,`CREATE_OPTIONS`,`TABLE_COMMENT`,`PrimaryKeys`) VALUES({1},{2},{3},{4},{5},{6},{7});",
									drT.TableName,
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drT.TID),
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drT.SchemaName),
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drT.TableName),
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drT["ENGINE"]),
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drT["CREATE_OPTIONS"]),
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drT["TABLE_COMMENT"]),
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drT.PrimaryKeys)
								)
							);
							SqlGen_XSD.dbv_columnRow[] drCs = drT.GetChildRows("FK_dbv_table_dbv_column") as SqlGen_XSD.dbv_columnRow[];
							foreach (SqlGen_XSD.dbv_columnRow drC in drCs)
							{
								sb.Append(string.Format(@"
INSERT INTO `dbv_column`(`TID`,`ColName`,`DefaultValue`,`NullAble`,`DATA_TYPE`,`CHARACTER_MAXIMUM_LENGTH`,`CHARACTER_OCTET_LENGTH`,`NUMERIC_PRECISION`,`NUMERIC_SCALE`,`CHARACTER_SET_NAME`,`COLLATION_NAME`,`COLUMN_TYPE`,`COLUMN_KEY`,`is_auto_increment`,`COLUMN_COMMENT`,`SchemaName`,`TableName`) VALUES({0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11},{12},{13},{14},{15},{16});",
										Apq.Data.MySqlClient.Common.ConvertToSqlON(drC.TID),
										Apq.Data.MySqlClient.Common.ConvertToSqlON(drC.ColName),
										Apq.Data.MySqlClient.Common.ConvertToSqlON(drC["DefaultValue"]),
										Apq.Data.MySqlClient.Common.ConvertToSqlON(drC.NullAble),
										Apq.Data.MySqlClient.Common.ConvertToSqlON(drC.DATA_TYPE),
										Apq.Data.MySqlClient.Common.ConvertToSqlON(drC["CHARACTER_MAXIMUM_LENGTH"]),
										Apq.Data.MySqlClient.Common.ConvertToSqlON(drC["CHARACTER_OCTET_LENGTH"]),
										Apq.Data.MySqlClient.Common.ConvertToSqlON(drC["NUMERIC_PRECISION"]),
										Apq.Data.MySqlClient.Common.ConvertToSqlON(drC["NUMERIC_SCALE"]),
										Apq.Data.MySqlClient.Common.ConvertToSqlON(drC["CHARACTER_SET_NAME"]),
										Apq.Data.MySqlClient.Common.ConvertToSqlON(drC["COLLATION_NAME"]),
										Apq.Data.MySqlClient.Common.ConvertToSqlON(drC.COLUMN_TYPE),
										Apq.Data.MySqlClient.Common.ConvertToSqlON(drC["COLUMN_KEY"]),
										Apq.Data.MySqlClient.Common.ConvertToSqlON(drC.is_auto_increment),
										Apq.Data.MySqlClient.Common.ConvertToSqlON(drC["COLUMN_COMMENT"]),
										Apq.Data.MySqlClient.Common.ConvertToSqlON(drC.SchemaName),
										Apq.Data.MySqlClient.Common.ConvertToSqlON(drC.TableName)
									)
								);
							}
						}
						if (dr.ObjectType == 6)
						{
							SqlGen_XSD.dbv_viewRow drV = _xsd.dbv_view.FindByTableName(dr.SchemaName, dr.ObjectName);
							sb.Append(string.Format(@"

-- 视图:{0}
INSERT INTO `dbv_view`(`SchemaName`,`TableName`,`VIEW_DEFINITION`) VALUES({1},{2},{3});",
									drV.TableName,
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drV.SchemaName),
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drV.TableName),
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drV.VIEW_DEFINITION)
								)
							);
						}
						if (dr.ObjectType == 2)
						{
							SqlGen_XSD.dbv_procRow drP = _xsd.dbv_proc.FindByProcName(dr.SchemaName, dr.ObjectName);
							sb.Append(string.Format(@"

-- 存储过程:{0}
INSERT INTO `dbv_proc`(`SchemaName`,`ProcName`,`type`,`param_list`,`returns`,`body`,`comment`) VALUES({1},{2},{3},{4},{5},{6},{7});",
									drP.ProcName,
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drP.SchemaName),
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drP.ProcName),
									drP.type,
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drP.param_list),
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drP.returns),
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drP.body),
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drP.comment)
								)
							);
						}
						if (dr.ObjectType == 4)
						{
							SqlGen_XSD.dbv_procRow drP = _xsd.dbv_proc.FindByProcName(dr.SchemaName, dr.ObjectName);
							sb.Append(string.Format(@"

-- 函数:{0}
INSERT INTO `dbv_proc`(`SchemaName`,`ProcName`,`type`,`param_list`,`returns`,`body`,`comment`) VALUES({1},{2},{3},{4},{5},{6},{7});",
									drP.ProcName,
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drP.SchemaName),
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drP.ProcName),
									drP.type,
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drP.param_list),
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drP.returns),
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drP.body),
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drP.comment)
								)
							);
						}
						if (dr.ObjectType == 3)
						{
							SqlGen_XSD.dbv_triggerRow drTri = _xsd.dbv_trigger.FindByTriName(dr.SchemaName, dr.ObjectName);
							sb.Append(string.Format(@"

-- 触发器:{0}
INSERT INTO `dbv_trigger`(`SchemaName`,`TriName`,`EVENT_MANIPULATION`,`TableName`,`ACTION_ORDER`,`ACTION_CONDITION`,`ACTION_STATEMENT`,`ACTION_ORIENTATION`,`ACTION_TIMING`) VALUES({1},{2},{3},{4},{5},{6},{7},{8},{9});",
									drTri.TriName,
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drTri.SchemaName),
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drTri.TriName),
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drTri.EVENT_MANIPULATION),
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drTri.TableName),
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drTri.ACTION_ORDER),
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drTri["ACTION_CONDITION"]),
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drTri.ACTION_STATEMENT),
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drTri.ACTION_ORIENTATION),
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drTri.ACTION_TIMING)
								)
							);
						}
					}
					#endregion

					sb.Append(@"
-- =================================================================================================

COMMIT;
");
				}
				if (tscbSqlProduct.SelectedIndex == 1)
				{
					MessageBox.Show(this, Apq.GlobalObject.UILang["尚未实现！"]);
					return;
				}

				File.WriteAllText(sfdMeta.FileName, sb.ToString());
				MessageBox.Show(this, Apq.GlobalObject.UILang["保存成功！"]);

				if (ErrList.ErrXSD.ErrList.Rows.Count > 0)
				{
					ErrList.Show(SqlGenPanel.DockDoc);
				}
			}
		}
		// 生成初始数据语句并保存到文件
		private void tsmiData_Click(object sender, EventArgs e)
		{
			try
			{
				_DBConnection.Open();
			}
			catch
			{
				MessageBox.Show(this, Apq.GlobalObject.UILang["数据库未连接或已断开"]);
				return;
			}
			finally
			{
				Apq.Data.Common.DbConnectionHelper.Close(_DBConnection);
			}

			Apq.Data.Common.DbConnectionHelper dch = new Apq.Data.Common.DbConnectionHelper(_DBConnection);
			StringBuilder sb = new StringBuilder();
			sfdMeta.InitialDirectory = GlobalObject.XmlConfigChain[this.GetType(), "sfdMeta_InitialDirectory"];
			if (sfdMeta.ShowDialog(this) == System.Windows.Forms.DialogResult.OK)
			{
				GlobalObject.XmlConfigChain[this.GetType(), "sfdMeta_InitialDirectory"] = Path.GetDirectoryName(sfdMeta.FileName);

				if (tscbSqlProduct.SelectedIndex == 0)
				{
					#region MySql
					#region 初始数据文件头
					// 为列表中已选中的表生成初始化语句，语句功能：完成将数据库中的数据插入到对应的表中，按主键添加
					sb.Append(string.Format(@"
USE `{0}`;

-- 为INSERT准备临时表
DROP TABLE IF EXISTS `_Apq_Ins`;
CREATE TEMPORARY TABLE `_Apq_Ins` (
  `_ID` INT(11) DEFAULT NULL
) ENGINE = HEAP;
INSERT  INTO `_Apq_Ins`(`_ID`) VALUES (1);

-- 初始数据", _DBConnection.Database)
					);
					#endregion
					foreach (SqlGen_XSD.MetaRow dr in _xsd.Meta.Rows)
					{
						if (dr._CheckState == 0 || dr.ObjectType != 1)
						{
							continue;
						}

						SqlGen_XSD.dbv_tableRow drT = _xsd.dbv_table.FindByTableName(dr.SchemaName, dr.ObjectName);
						SqlGen_XSD.dbv_columnRow[] drCs = drT.GetChildRows("FK_dbv_table_dbv_column") as SqlGen_XSD.dbv_columnRow[];

						#region 数据Key
						/* 
						1.dbv_table_key已有指定数据Key时，使用此值
						2.否则查找其它表中的存在同名主键列(2列以上)，看作关联型数据
						3.否则将主键作为对象型数据Key，加入到WHERE条件中
						4.否则将自增列作为对象型数据Key，加入到WHERE条件中
						*/
						List<SqlGen_XSD.dbv_columnRow> colKeys = new List<SqlGen_XSD.dbv_columnRow>();
						if (colKeys.Count == 0)
						{
							SqlGen_XSD.dbv_table_keyRow drTK = _xsd.dbv_table_key.FindBySchemaNameTableName(dr.SchemaName, dr.ObjectName);
							if (drTK != null)
							{
								string[] aryDataKeys = drTK.PrimaryKeys.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
								for (int i = 0; i < aryDataKeys.Length; i++)
								{
									aryDataKeys[i] = Apq.Data.MySqlClient.Common.ConvertToSqlON(aryDataKeys[i]);
								}
								SqlGen_XSD.dbv_columnRow[] drDataKeys = _xsd.dbv_column.Select(string.Format("SchemaName = {0} AND TableName = {1} AND ColName IN ({2})",
									Apq.Data.MySqlClient.Common.ConvertToSqlON(dr.SchemaName),
									Apq.Data.MySqlClient.Common.ConvertToSqlON(dr.ObjectName),
									string.Join(",", aryDataKeys))) as SqlGen_XSD.dbv_columnRow[];
								colKeys.AddRange(drDataKeys);
							}
						}
						if (colKeys.Count == 0)
						{
							foreach (SqlGen_XSD.dbv_columnRow drC in drCs)
							{
								DataRow[] aryTemp = _xsd.dbv_column.Select(string.Format("TableName <> {0} AND ColName = {1} AND COLUMN_KEY = 'PRI'",
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drC.TableName),
									Apq.Data.MySqlClient.Common.ConvertToSqlON(drC.ColName)));
								if (aryTemp != null && aryTemp.Length > 0)
								{
									colKeys.Add(drC);
								}
							}
							if (colKeys.Count < 2)
							{
								colKeys.Clear();
							}
						}
						if (colKeys.Count == 0)
						{
							foreach (SqlGen_XSD.dbv_columnRow drC in drCs)
							{
								if ("PRI".Equals(drC.COLUMN_KEY, StringComparison.OrdinalIgnoreCase))
								{
									colKeys.Add(drC);
								}
							}
						}
						if (colKeys.Count == 0)
						{
							foreach (SqlGen_XSD.dbv_columnRow drC in drCs)
							{
								if (drC.is_auto_increment)
								{
									colKeys.Add(drC);
								}
							}
						}
						#endregion
						#region 输出列
						string strCols = string.Empty;
						List<SqlGen_XSD.dbv_columnRow> colInserts = new List<SqlGen_XSD.dbv_columnRow>();
						foreach (SqlGen_XSD.dbv_columnRow drC in drCs)
						{
							if (drC.is_auto_increment && !colKeys.Contains(drC))
							{
								// 跳过无意义的自增列
								continue;
							}
							colInserts.Add(drC);
							strCols += ",`" + drC.ColName + "`";
						}
						#endregion
						#region WHERE语句(替换模式)
						string strWhereTmp = string.Empty;// WHERE 条件

						if (colKeys.Count > 0)
						{
							for (int i = 0; i < colKeys.Count; i++)
							{
								strWhereTmp += string.Format(" AND `{0}`", colKeys[i].ColName) + " = {" + i + "}";
							}
							if (strWhereTmp.Length > 1)
							{
								strWhereTmp = " WHERE" + strWhereTmp.Substring(4);
							}
						}
						else
						{
							string strExMsg = string.Format("无法生成条件的表：{0}，请检查其数据Key设置、关联列名、主键、自增列。", drT.TableName);
							ErrList.AddRow(DateTime.Now, 4, 16, Apq.GlobalObject.UILang["生成表失败"], strExMsg);
							continue;
						}
						#endregion

						if (strCols.Length > 1)
						{
							#region 表说明
							strCols = strCols.Substring(1);
							sb.Append(string.Format(@"

-- 表：`{0}`", drT.TableName));
							#endregion

							#region 分页查询并输出一个表
							long CRow = 0, PageSize = 1000;
							while (true)
							{
								#region 从数据库读取一页
								DataSet ds = new DataSet();
								DbDataAdapter dda = dch.CreateAdapter(string.Format(@"SELECT * FROM {0} LIMIT {1},{2};", drT.TableName, CRow, PageSize));
								int RowCount = dda.Fill(ds);
								#endregion

								if (RowCount > 0)
								{
									foreach (DataRow drData in ds.Tables[0].Rows)
									{
										#region 输出一行
										List<object> objWhere = new List<object>();
										for (int i = 0; i < colKeys.Count; i++)
										{
											objWhere.Add(Apq.Data.MySqlClient.Common.ConvertToSqlON(drData[colKeys[i].ColName]));
										}
										List<string> aryValues = new List<string>();
										for (int i = 0; i < colInserts.Count; i++)
										{
											aryValues.Add(Apq.Data.MySqlClient.Common.ConvertToSqlON(drData[colInserts[i].ColName]));
										}
										string strValues = string.Join(",", aryValues);
										string strWhere = string.Format(strWhereTmp, objWhere.ToArray());

										sb.Append(string.Format(@"
INSERT INTO `{0}`({1}) SELECT {2} FROM `_Apq_Ins` WHERE NOT EXISTS(SELECT 1 FROM `{0}`{3});", drT.TableName, strCols, strValues, strWhere));
										#endregion
									}
								}
								if (RowCount < PageSize)
								{
									break;
								}
								CRow += RowCount;
							}
							#endregion
						}
					}
					#region 文件尾
					sb.Append(@"

-- 删除临时表
DROP TABLE IF EXISTS `_Apq_Ins`;

COMMIT;
");
					#endregion
					#endregion
				}
				if (tscbSqlProduct.SelectedIndex == 1)
				{
					#region MsSql
					// 为列表中已选中的表生成初始化语句，语句功能：完成将数据库中的数据插入到对应的表中，按主键添加
					sb.Append(string.Format(@"
USE [{0}];

-- 初始数据", _DBConnection.Database)
					);
					foreach (SqlGen_XSD.MetaRow dr in _xsd.Meta.Rows)
					{
						if (dr._CheckState == 0 || dr.ObjectType != 1)
						{
							continue;
						}

						SqlGen_XSD.dbv_tableRow drT = _xsd.dbv_table.FindByTableName(dr.SchemaName, dr.ObjectName);
						SqlGen_XSD.dbv_columnRow[] drCs = drT.GetChildRows("FK_dbv_table_dbv_column") as SqlGen_XSD.dbv_columnRow[];

						#region 计算WHERE语句(替换模式)
						/* 
						1.dbv_table_key已有指定数据Key时，使用此值
						2.否则查找其它表中的存在同名主键列(2列以上)，看作关联型数据
						3.否则将主键作为对象型数据Key，加入到WHERE条件中
						4.否则将自增列作为对象型数据Key，加入到WHERE条件中
						*/
						List<SqlGen_XSD.dbv_columnRow> colKeys = new List<SqlGen_XSD.dbv_columnRow>();
						if (colKeys.Count == 0)
						{
							SqlGen_XSD.dbv_table_keyRow drTK = _xsd.dbv_table_key.FindBySchemaNameTableName(dr.SchemaName, dr.ObjectName);
							if (drTK != null)
							{
								string[] aryDataKeys = drTK.PrimaryKeys.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
								for (int i = 0; i < aryDataKeys.Length; i++)
								{
									aryDataKeys[i] = Apq.Data.SqlClient.Common.ConvertToSqlON(aryDataKeys[i]);
								}
								SqlGen_XSD.dbv_columnRow[] drDataKeys = _xsd.dbv_column.Select(string.Format("SchemaName = {0} AND TableName = {1} AND ColName IN ({2})",
									Apq.Data.SqlClient.Common.ConvertToSqlON(dr.SchemaName),
									Apq.Data.SqlClient.Common.ConvertToSqlON(dr.ObjectName),
									string.Join(",", aryDataKeys))) as SqlGen_XSD.dbv_columnRow[];
								colKeys.AddRange(drDataKeys);
							}
						}
						if (colKeys.Count == 0)
						{
							foreach (SqlGen_XSD.dbv_columnRow drC in drCs)
							{
								DataRow[] aryTemp = _xsd.dbv_column.Select(string.Format("TableName <> {0} AND ColName = {1} AND COLUMN_KEY = 'PRI'",
									Apq.Data.SqlClient.Common.ConvertToSqlON(drC.TableName),
									Apq.Data.SqlClient.Common.ConvertToSqlON(drC.ColName)));
								if (aryTemp != null && aryTemp.Length > 0)
								{
									colKeys.Add(drC);
								}
							}
							if (colKeys.Count < 2)
							{
								colKeys.Clear();
							}
						}
						if (colKeys.Count == 0)
						{
							foreach (SqlGen_XSD.dbv_columnRow drC in drCs)
							{
								if ("PRI".Equals(drC.COLUMN_KEY, StringComparison.OrdinalIgnoreCase))
								{
									colKeys.Add(drC);
								}
							}
						}
						if (colKeys.Count == 0)
						{
							foreach (SqlGen_XSD.dbv_columnRow drC in drCs)
							{
								if (drC.is_auto_increment)
								{
									colKeys.Add(drC);
								}
							}
						}

						string strWhereTmp = string.Empty;// WHERE 条件

						if (colKeys.Count > 0)
						{
							for (int i = 0; i < colKeys.Count; i++)
							{
								strWhereTmp += string.Format(" AND [{0}]", colKeys[i].ColName) + " = {" + i + "}";
							}
							if (strWhereTmp.Length > 1)
							{
								strWhereTmp = " WHERE" + strWhereTmp.Substring(4);
							}
						}
						else
						{
							string strExMsg = string.Format("无法生成条件的表：{0}，请检查其数据Key设置、关联列名、主键、自增列。", drT.TableName);
							ErrList.AddRow(DateTime.Now, 4, 16, Apq.GlobalObject.UILang["生成表失败"], strExMsg);
							continue;
						}
						#endregion

						//将表读到内存，并为每一行生成脚本
						DataSet ds = new DataSet();
						DbDataAdapter dda = dch.CreateAdapter(string.Format(@"SELECT * FROM {0}", drT.TableName));
						dda.Fill(ds);

						if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
						{
							string strCols = string.Empty;
							List<SqlGen_XSD.dbv_columnRow> colInserts = new List<SqlGen_XSD.dbv_columnRow>();
							foreach (SqlGen_XSD.dbv_columnRow drC in drCs)
							{
								if (drC.is_auto_increment && !colKeys.Contains(drC))
								{
									// 跳过无意义的自增列
									continue;
								}
								colInserts.Add(drC);
								strCols += ",[" + drC.ColName + "]";
							}
							if (strCols.Length > 1)
							{
								strCols = strCols.Substring(1);
								sb.Append(string.Format(@"

-- 表：[{0}]", drT.TableName));
							}

							foreach (DataRow drData in ds.Tables[0].Rows)
							{
								List<object> objWhere = new List<object>();
								for (int i = 0; i < colKeys.Count; i++)
								{
									objWhere.Add(Apq.Data.SqlClient.Common.ConvertToSqlON(drData[colKeys[i].ColName]));
								}
								List<string> aryValues = new List<string>();
								for (int i = 0; i < colInserts.Count; i++)
								{
									aryValues.Add(Apq.Data.SqlClient.Common.ConvertToSqlON(drData[colInserts[i].ColName]));
								}
								string strValues = string.Join(",", aryValues);
								string strWhere = string.Format(strWhereTmp, objWhere.ToArray());

								sb.Append(string.Format(@"
IF(NOT EXISTS(SELECT TOP(1) 1 FROM [dbo].[{0}]{3})) INSERT INTO [dbo].[{0}]({1}) VALUES({2})", drT.TableName, strCols, strValues, strWhere));
							}
						}
					}
					sb.Append(@"
");
					#endregion
				}
				File.WriteAllText(sfdMeta.FileName, sb.ToString());
				MessageBox.Show(this, Apq.GlobalObject.UILang["保存成功！"]);

				if (ErrList.ErrXSD.ErrList.Rows.Count > 0)
				{
					ErrList.Show(SqlGenPanel.DockDoc);
				}
			}
		}

		#region 选择

		private void tsmiSelectTable_Click(object sender, EventArgs e)
		{
			dataGridView1.EndEdit();
			int _CheckState = Apq.Convert.ChangeType<int>(tsmiSelectTable.Checked);
			foreach (SqlGen_XSD.MetaRow dr in _xsd.Meta.Rows)
			{
				if (dr.ObjectType == 1)
				{
					dr._CheckState = _CheckState;
				}
			}
		}

		private void tsmiSelectProc_Click(object sender, EventArgs e)
		{
			dataGridView1.EndEdit();
			int _CheckState = Apq.Convert.ChangeType<int>(tsmiSelectProc.Checked);
			foreach (SqlGen_XSD.MetaRow dr in _xsd.Meta.Rows)
			{
				if (dr.ObjectType == 2)
				{
					dr._CheckState = _CheckState;
				}
			}
		}

		private void tsmiSelectTrigger_Click(object sender, EventArgs e)
		{
			dataGridView1.EndEdit();
			int _CheckState = Apq.Convert.ChangeType<int>(tsmiSelectTrigger.Checked);
			foreach (SqlGen_XSD.MetaRow dr in _xsd.Meta.Rows)
			{
				if (dr.ObjectType == 3)
				{
					dr._CheckState = _CheckState;
				}
			}
		}

		private void tsmiSelectAll_Click(object sender, EventArgs e)
		{
			dataGridView1.EndEdit();
			foreach (SqlGen_XSD.MetaRow dr in _xsd.Meta.Rows)
			{
				dr._CheckState = 1;
			}
		}

		private void tsmiSelectReverse_Click(object sender, EventArgs e)
		{
			dataGridView1.EndEdit();
			foreach (SqlGen_XSD.MetaRow dr in _xsd.Meta.Rows)
			{
				dr._CheckState = Math.Abs(dr._CheckState - 1);
			}
		}
		#endregion

		private void dgvTableKey_CellEndEdit(object sender, DataGridViewCellEventArgs e)
		{
			try
			{
				string strFile = Path.GetDirectoryName(Apq.GlobalObject.TheProcess.MainModule.FileName) + @"\dbv_table_key.xml";
				_xsd.dbv_table_key.WriteXml(strFile, XmlWriteMode.IgnoreSchema);
			}
			catch (Exception ex)
			{
				string strExMsg = Apq.GlobalObject.UILang["数据Key保存失败！"];
				Apq.GlobalObject.ApqLog.Error(strExMsg, ex);
				MessageBox.Show(this, Apq.GlobalObject.UILang["数据Key保存失败！"]);
			}
		}

		private void dgvTableKey_UserDeletedRow(object sender, DataGridViewRowEventArgs e)
		{
			try
			{
				string strFile = Path.GetDirectoryName(Apq.GlobalObject.TheProcess.MainModule.FileName) + @"\dbv_table_key.xml";
				_xsd.dbv_table_key.WriteXml(strFile, XmlWriteMode.IgnoreSchema);
			}
			catch (Exception ex)
			{
				string strExMsg = Apq.GlobalObject.UILang["数据Key保存失败！"];
				Apq.GlobalObject.ApqLog.Error(strExMsg, ex);
				MessageBox.Show(this, Apq.GlobalObject.UILang["数据Key保存失败！"]);
			}
		}

		private void tsbErrList_Click(object sender, EventArgs e)
		{
			if (tsbErrList.Checked)
			{
				ErrList.Show(SqlGenPanel.DockDoc);
			}
			else
			{
				ErrList.Hide();
			}
		}
	}
}