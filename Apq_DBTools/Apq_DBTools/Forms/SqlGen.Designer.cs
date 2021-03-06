﻿using Apq_DBTools.Forms;
namespace Apq_DBTools
{
	partial class SqlGen
	{
		/// <summary>
		/// 必需的设计器变量。
		/// </summary>
		private System.ComponentModel.IContainer components = null;

		/// <summary>
		/// 清理所有正在使用的资源。
		/// </summary>
		/// <param name="disposing">如果应释放托管资源，为 true；否则为 false。</param>
		protected override void Dispose(bool disposing)
		{
			if (disposing && (components != null))
			{
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		#region Windows 窗体设计器生成的代码

		/// <summary>
		/// 设计器支持所需的方法 - 不要
		/// 使用代码编辑器修改此方法的内容。
		/// </summary>
		private void InitializeComponent()
		{
			this.components = new System.ComponentModel.Container();
			System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(SqlGen));
			this.toolStrip1 = new System.Windows.Forms.ToolStrip();
			this.tsbConnectDB = new System.Windows.Forms.ToolStripSplitButton();
			this.tsmiRefresh = new System.Windows.Forms.ToolStripMenuItem();
			this.tssbSelect = new System.Windows.Forms.ToolStripSplitButton();
			this.tsmiSelectAll = new System.Windows.Forms.ToolStripMenuItem();
			this.tsmiSelectReverse = new System.Windows.Forms.ToolStripMenuItem();
			this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
			this.tsmiSelectTable = new System.Windows.Forms.ToolStripMenuItem();
			this.tsmiSelectProc = new System.Windows.Forms.ToolStripMenuItem();
			this.tsmiSelectTrigger = new System.Windows.Forms.ToolStripMenuItem();
			this.tssbGenSql = new System.Windows.Forms.ToolStripSplitButton();
			this.tsmiMeta = new System.Windows.Forms.ToolStripMenuItem();
			this.tsmiData = new System.Windows.Forms.ToolStripMenuItem();
			this.tscbSqlProduct = new System.Windows.Forms.ToolStripComboBox();
			this.tsbErrList = new System.Windows.Forms.ToolStripButton();
			this.dataGridView1 = new System.Windows.Forms.DataGridView();
			this.checkStateDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewCheckBoxColumn();
			this.objectTypeDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewComboBoxColumn();
			this.bsObjectType = new System.Windows.Forms.BindingSource(this.components);
			this._xsd = new Apq_DBTools.Forms.SqlGen_XSD();
			this.schemaNameDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
			this.objectNameDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
			this.bsMeta = new System.Windows.Forms.BindingSource(this.components);
			this.sfdMeta = new System.Windows.Forms.SaveFileDialog();
			this.dgvTableKey = new System.Windows.Forms.DataGridView();
			this.schemaNameDataGridViewTextBoxColumn1 = new System.Windows.Forms.DataGridViewTextBoxColumn();
			this.tableNameDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
			this.primaryKeysDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
			this.bsdbv_table_key = new System.Windows.Forms.BindingSource(this.components);
			this.splitContainer1 = new System.Windows.Forms.SplitContainer();
			this.toolStrip1.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.bsObjectType)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this._xsd)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.bsMeta)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.dgvTableKey)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.bsdbv_table_key)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).BeginInit();
			this.splitContainer1.Panel1.SuspendLayout();
			this.splitContainer1.Panel2.SuspendLayout();
			this.splitContainer1.SuspendLayout();
			this.SuspendLayout();
			// 
			// toolStrip1
			// 
			this.toolStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.tsbConnectDB,
            this.tssbSelect,
            this.tssbGenSql,
            this.tscbSqlProduct,
            this.tsbErrList});
			this.toolStrip1.Location = new System.Drawing.Point(0, 0);
			this.toolStrip1.Name = "toolStrip1";
			this.toolStrip1.Size = new System.Drawing.Size(760, 25);
			this.toolStrip1.TabIndex = 4;
			this.toolStrip1.Text = "toolStrip1";
			// 
			// tsbConnectDB
			// 
			this.tsbConnectDB.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text;
			this.tsbConnectDB.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.tsmiRefresh});
			this.tsbConnectDB.Image = ((System.Drawing.Image)(resources.GetObject("tsbConnectDB.Image")));
			this.tsbConnectDB.ImageTransparentColor = System.Drawing.Color.Magenta;
			this.tsbConnectDB.Name = "tsbConnectDB";
			this.tsbConnectDB.Size = new System.Drawing.Size(45, 22);
			this.tsbConnectDB.Text = "连接";
			this.tsbConnectDB.ButtonClick += new System.EventHandler(this.tsbConnectDB_ButtonClick);
			// 
			// tsmiRefresh
			// 
			this.tsmiRefresh.Name = "tsmiRefresh";
			this.tsmiRefresh.Size = new System.Drawing.Size(112, 22);
			this.tsmiRefresh.Text = "刷新(&F)";
			this.tsmiRefresh.Click += new System.EventHandler(this.tsbRefresh_Click);
			// 
			// tssbSelect
			// 
			this.tssbSelect.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text;
			this.tssbSelect.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.tsmiSelectAll,
            this.tsmiSelectReverse,
            this.toolStripSeparator1,
            this.tsmiSelectTable,
            this.tsmiSelectProc,
            this.tsmiSelectTrigger});
			this.tssbSelect.Image = ((System.Drawing.Image)(resources.GetObject("tssbSelect.Image")));
			this.tssbSelect.ImageTransparentColor = System.Drawing.Color.Magenta;
			this.tssbSelect.Name = "tssbSelect";
			this.tssbSelect.Size = new System.Drawing.Size(45, 22);
			this.tssbSelect.Text = "选择";
			// 
			// tsmiSelectAll
			// 
			this.tsmiSelectAll.Name = "tsmiSelectAll";
			this.tsmiSelectAll.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.A)));
			this.tsmiSelectAll.Size = new System.Drawing.Size(153, 22);
			this.tsmiSelectAll.Text = "全选(&A)";
			this.tsmiSelectAll.Click += new System.EventHandler(this.tsmiSelectAll_Click);
			// 
			// tsmiSelectReverse
			// 
			this.tsmiSelectReverse.Name = "tsmiSelectReverse";
			this.tsmiSelectReverse.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.R)));
			this.tsmiSelectReverse.Size = new System.Drawing.Size(153, 22);
			this.tsmiSelectReverse.Text = "反选(&R)";
			this.tsmiSelectReverse.Click += new System.EventHandler(this.tsmiSelectReverse_Click);
			// 
			// toolStripSeparator1
			// 
			this.toolStripSeparator1.Name = "toolStripSeparator1";
			this.toolStripSeparator1.Size = new System.Drawing.Size(150, 6);
			// 
			// tsmiSelectTable
			// 
			this.tsmiSelectTable.Checked = true;
			this.tsmiSelectTable.CheckOnClick = true;
			this.tsmiSelectTable.CheckState = System.Windows.Forms.CheckState.Checked;
			this.tsmiSelectTable.Name = "tsmiSelectTable";
			this.tsmiSelectTable.Size = new System.Drawing.Size(153, 22);
			this.tsmiSelectTable.Text = "表(&T)";
			this.tsmiSelectTable.Click += new System.EventHandler(this.tsmiSelectTable_Click);
			// 
			// tsmiSelectProc
			// 
			this.tsmiSelectProc.Checked = true;
			this.tsmiSelectProc.CheckOnClick = true;
			this.tsmiSelectProc.CheckState = System.Windows.Forms.CheckState.Checked;
			this.tsmiSelectProc.Name = "tsmiSelectProc";
			this.tsmiSelectProc.Size = new System.Drawing.Size(153, 22);
			this.tsmiSelectProc.Text = "存储过程(&P)";
			this.tsmiSelectProc.Click += new System.EventHandler(this.tsmiSelectProc_Click);
			// 
			// tsmiSelectTrigger
			// 
			this.tsmiSelectTrigger.Checked = true;
			this.tsmiSelectTrigger.CheckOnClick = true;
			this.tsmiSelectTrigger.CheckState = System.Windows.Forms.CheckState.Checked;
			this.tsmiSelectTrigger.Name = "tsmiSelectTrigger";
			this.tsmiSelectTrigger.Size = new System.Drawing.Size(153, 22);
			this.tsmiSelectTrigger.Text = "触发器(&I)";
			this.tsmiSelectTrigger.Click += new System.EventHandler(this.tsmiSelectTrigger_Click);
			// 
			// tssbGenSql
			// 
			this.tssbGenSql.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text;
			this.tssbGenSql.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.tsmiMeta,
            this.tsmiData});
			this.tssbGenSql.Image = ((System.Drawing.Image)(resources.GetObject("tssbGenSql.Image")));
			this.tssbGenSql.ImageTransparentColor = System.Drawing.Color.Magenta;
			this.tssbGenSql.Name = "tssbGenSql";
			this.tssbGenSql.Size = new System.Drawing.Size(45, 22);
			this.tssbGenSql.Text = "生成";
			// 
			// tsmiMeta
			// 
			this.tsmiMeta.Name = "tsmiMeta";
			this.tsmiMeta.Size = new System.Drawing.Size(148, 22);
			this.tsmiMeta.Text = "元数据脚本(&M)";
			this.tsmiMeta.Click += new System.EventHandler(this.tsmiMeta_Click);
			// 
			// tsmiData
			// 
			this.tsmiData.Name = "tsmiData";
			this.tsmiData.Size = new System.Drawing.Size(148, 22);
			this.tsmiData.Text = "初始化数据(&D)";
			this.tsmiData.Click += new System.EventHandler(this.tsmiData_Click);
			// 
			// tscbSqlProduct
			// 
			this.tscbSqlProduct.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
			this.tscbSqlProduct.Items.AddRange(new object[] {
            "MySql",
            "MsSql"});
			this.tscbSqlProduct.Name = "tscbSqlProduct";
			this.tscbSqlProduct.Size = new System.Drawing.Size(75, 25);
			// 
			// tsbErrList
			// 
			this.tsbErrList.CheckOnClick = true;
			this.tsbErrList.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text;
			this.tsbErrList.Image = ((System.Drawing.Image)(resources.GetObject("tsbErrList.Image")));
			this.tsbErrList.ImageTransparentColor = System.Drawing.Color.Magenta;
			this.tsbErrList.Name = "tsbErrList";
			this.tsbErrList.Size = new System.Drawing.Size(57, 22);
			this.tsbErrList.Text = "错误列表";
			this.tsbErrList.Click += new System.EventHandler(this.tsbErrList_Click);
			// 
			// dataGridView1
			// 
			this.dataGridView1.AllowUserToAddRows = false;
			this.dataGridView1.AllowUserToDeleteRows = false;
			this.dataGridView1.AutoGenerateColumns = false;
			this.dataGridView1.ClipboardCopyMode = System.Windows.Forms.DataGridViewClipboardCopyMode.EnableWithoutHeaderText;
			this.dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
			this.dataGridView1.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.checkStateDataGridViewTextBoxColumn,
            this.objectTypeDataGridViewTextBoxColumn,
            this.schemaNameDataGridViewTextBoxColumn,
            this.objectNameDataGridViewTextBoxColumn});
			this.dataGridView1.DataSource = this.bsMeta;
			this.dataGridView1.Dock = System.Windows.Forms.DockStyle.Fill;
			this.dataGridView1.Location = new System.Drawing.Point(0, 0);
			this.dataGridView1.Name = "dataGridView1";
			this.dataGridView1.RowTemplate.Height = 23;
			this.dataGridView1.Size = new System.Drawing.Size(292, 410);
			this.dataGridView1.TabIndex = 5;
			// 
			// checkStateDataGridViewTextBoxColumn
			// 
			this.checkStateDataGridViewTextBoxColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.DisplayedCells;
			this.checkStateDataGridViewTextBoxColumn.DataPropertyName = "_CheckState";
			this.checkStateDataGridViewTextBoxColumn.FalseValue = "0";
			this.checkStateDataGridViewTextBoxColumn.HeaderText = "选择";
			this.checkStateDataGridViewTextBoxColumn.IndeterminateValue = "2";
			this.checkStateDataGridViewTextBoxColumn.Name = "checkStateDataGridViewTextBoxColumn";
			this.checkStateDataGridViewTextBoxColumn.Resizable = System.Windows.Forms.DataGridViewTriState.True;
			this.checkStateDataGridViewTextBoxColumn.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.Automatic;
			this.checkStateDataGridViewTextBoxColumn.TrueValue = "1";
			this.checkStateDataGridViewTextBoxColumn.Width = 54;
			// 
			// objectTypeDataGridViewTextBoxColumn
			// 
			this.objectTypeDataGridViewTextBoxColumn.DataPropertyName = "ObjectType";
			this.objectTypeDataGridViewTextBoxColumn.DataSource = this.bsObjectType;
			this.objectTypeDataGridViewTextBoxColumn.DisplayMember = "TypeCaption";
			this.objectTypeDataGridViewTextBoxColumn.DisplayStyle = System.Windows.Forms.DataGridViewComboBoxDisplayStyle.Nothing;
			this.objectTypeDataGridViewTextBoxColumn.HeaderText = "类型";
			this.objectTypeDataGridViewTextBoxColumn.Name = "objectTypeDataGridViewTextBoxColumn";
			this.objectTypeDataGridViewTextBoxColumn.ReadOnly = true;
			this.objectTypeDataGridViewTextBoxColumn.Resizable = System.Windows.Forms.DataGridViewTriState.True;
			this.objectTypeDataGridViewTextBoxColumn.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.Automatic;
			this.objectTypeDataGridViewTextBoxColumn.ValueMember = "ObjectType";
			this.objectTypeDataGridViewTextBoxColumn.Width = 150;
			// 
			// bsObjectType
			// 
			this.bsObjectType.DataMember = "dic_ObjectType";
			this.bsObjectType.DataSource = this._xsd;
			// 
			// _xsd
			// 
			this._xsd.DataSetName = "SqlGen_XSD";
			this._xsd.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema;
			// 
			// schemaNameDataGridViewTextBoxColumn
			// 
			this.schemaNameDataGridViewTextBoxColumn.DataPropertyName = "SchemaName";
			this.schemaNameDataGridViewTextBoxColumn.HeaderText = "架构";
			this.schemaNameDataGridViewTextBoxColumn.Name = "schemaNameDataGridViewTextBoxColumn";
			this.schemaNameDataGridViewTextBoxColumn.ReadOnly = true;
			this.schemaNameDataGridViewTextBoxColumn.Width = 150;
			// 
			// objectNameDataGridViewTextBoxColumn
			// 
			this.objectNameDataGridViewTextBoxColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
			this.objectNameDataGridViewTextBoxColumn.DataPropertyName = "ObjectName";
			this.objectNameDataGridViewTextBoxColumn.HeaderText = "名称";
			this.objectNameDataGridViewTextBoxColumn.Name = "objectNameDataGridViewTextBoxColumn";
			this.objectNameDataGridViewTextBoxColumn.ReadOnly = true;
			// 
			// bsMeta
			// 
			this.bsMeta.DataMember = "Meta";
			this.bsMeta.DataSource = this._xsd;
			// 
			// sfdMeta
			// 
			this.sfdMeta.Filter = "SQL 文件|*.sql|所有文件|*.*";
			// 
			// dgvTableKey
			// 
			this.dgvTableKey.AutoGenerateColumns = false;
			this.dgvTableKey.ClipboardCopyMode = System.Windows.Forms.DataGridViewClipboardCopyMode.EnableWithoutHeaderText;
			this.dgvTableKey.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
			this.dgvTableKey.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.schemaNameDataGridViewTextBoxColumn1,
            this.tableNameDataGridViewTextBoxColumn,
            this.primaryKeysDataGridViewTextBoxColumn});
			this.dgvTableKey.DataSource = this.bsdbv_table_key;
			this.dgvTableKey.Dock = System.Windows.Forms.DockStyle.Fill;
			this.dgvTableKey.Location = new System.Drawing.Point(0, 0);
			this.dgvTableKey.Name = "dgvTableKey";
			this.dgvTableKey.RowTemplate.Height = 23;
			this.dgvTableKey.Size = new System.Drawing.Size(464, 410);
			this.dgvTableKey.TabIndex = 6;
			this.dgvTableKey.CellEndEdit += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvTableKey_CellEndEdit);
			this.dgvTableKey.UserDeletedRow += new System.Windows.Forms.DataGridViewRowEventHandler(this.dgvTableKey_UserDeletedRow);
			// 
			// schemaNameDataGridViewTextBoxColumn1
			// 
			this.schemaNameDataGridViewTextBoxColumn1.DataPropertyName = "SchemaName";
			this.schemaNameDataGridViewTextBoxColumn1.HeaderText = "架构";
			this.schemaNameDataGridViewTextBoxColumn1.Name = "schemaNameDataGridViewTextBoxColumn1";
			// 
			// tableNameDataGridViewTextBoxColumn
			// 
			this.tableNameDataGridViewTextBoxColumn.DataPropertyName = "TableName";
			this.tableNameDataGridViewTextBoxColumn.HeaderText = "表名";
			this.tableNameDataGridViewTextBoxColumn.Name = "tableNameDataGridViewTextBoxColumn";
			// 
			// primaryKeysDataGridViewTextBoxColumn
			// 
			this.primaryKeysDataGridViewTextBoxColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
			this.primaryKeysDataGridViewTextBoxColumn.DataPropertyName = "PrimaryKeys";
			this.primaryKeysDataGridViewTextBoxColumn.HeaderText = "数据Key";
			this.primaryKeysDataGridViewTextBoxColumn.Name = "primaryKeysDataGridViewTextBoxColumn";
			// 
			// bsdbv_table_key
			// 
			this.bsdbv_table_key.DataMember = "dbv_table_key";
			this.bsdbv_table_key.DataSource = this._xsd;
			// 
			// splitContainer1
			// 
			this.splitContainer1.Dock = System.Windows.Forms.DockStyle.Fill;
			this.splitContainer1.FixedPanel = System.Windows.Forms.FixedPanel.Panel2;
			this.splitContainer1.IsSplitterFixed = true;
			this.splitContainer1.Location = new System.Drawing.Point(0, 25);
			this.splitContainer1.Name = "splitContainer1";
			// 
			// splitContainer1.Panel1
			// 
			this.splitContainer1.Panel1.Controls.Add(this.dataGridView1);
			// 
			// splitContainer1.Panel2
			// 
			this.splitContainer1.Panel2.Controls.Add(this.dgvTableKey);
			this.splitContainer1.Size = new System.Drawing.Size(760, 410);
			this.splitContainer1.SplitterDistance = 292;
			this.splitContainer1.TabIndex = 7;
			// 
			// SqlGen
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.AutoScroll = true;
			this.ClientSize = new System.Drawing.Size(760, 435);
			this.CloseButtonVisible = false;
			this.Controls.Add(this.splitContainer1);
			this.Controls.Add(this.toolStrip1);
			this.DockAreas = WeifenLuo.WinFormsUI.Docking.DockAreas.Document;
			this.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
			this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
			this.MinimumSize = new System.Drawing.Size(768, 462);
			this.Name = "SqlGen";
			this.TabText = "文本文件编码转换";
			this.Text = "脚本生成";
			this.Activated += new System.EventHandler(this.SqlGen_Activated);
			this.Deactivate += new System.EventHandler(this.SqlGen_Deactivate);
			this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.SqlGen_FormClosing);
			this.Load += new System.EventHandler(this.SqlGen_Load);
			this.toolStrip1.ResumeLayout(false);
			this.toolStrip1.PerformLayout();
			((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.bsObjectType)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this._xsd)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.bsMeta)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.dgvTableKey)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.bsdbv_table_key)).EndInit();
			this.splitContainer1.Panel1.ResumeLayout(false);
			this.splitContainer1.Panel2.ResumeLayout(false);
			((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).EndInit();
			this.splitContainer1.ResumeLayout(false);
			this.ResumeLayout(false);
			this.PerformLayout();

		}

		#endregion

		private System.Windows.Forms.ToolStrip toolStrip1;
        private System.Windows.Forms.ToolStripSplitButton tsbConnectDB;
        private System.Windows.Forms.ToolStripMenuItem tsmiRefresh;
        private System.Windows.Forms.DataGridView dataGridView1;
        private System.Windows.Forms.ToolStripSplitButton tssbGenSql;
        private System.Windows.Forms.ToolStripMenuItem tsmiMeta;
		private System.Windows.Forms.BindingSource bsMeta;
		private SqlGen_XSD _xsd;
		private System.Windows.Forms.ToolStripMenuItem tsmiData;
		private System.Windows.Forms.ToolStripSplitButton tssbSelect;
		private System.Windows.Forms.ToolStripMenuItem tsmiSelectAll;
		private System.Windows.Forms.ToolStripMenuItem tsmiSelectReverse;
		private System.Windows.Forms.ToolStripSeparator toolStripSeparator1;
		private System.Windows.Forms.ToolStripMenuItem tsmiSelectTable;
		private System.Windows.Forms.ToolStripMenuItem tsmiSelectProc;
		private System.Windows.Forms.BindingSource bsObjectType;
		private System.Windows.Forms.DataGridViewCheckBoxColumn checkStateDataGridViewTextBoxColumn;
		private System.Windows.Forms.DataGridViewComboBoxColumn objectTypeDataGridViewTextBoxColumn;
		private System.Windows.Forms.DataGridViewTextBoxColumn schemaNameDataGridViewTextBoxColumn;
		private System.Windows.Forms.DataGridViewTextBoxColumn objectNameDataGridViewTextBoxColumn;
		private System.Windows.Forms.SaveFileDialog sfdMeta;
		private System.Windows.Forms.ToolStripComboBox tscbSqlProduct;
		private System.Windows.Forms.DataGridView dgvTableKey;
		private System.Windows.Forms.BindingSource bsdbv_table_key;
		private System.Windows.Forms.SplitContainer splitContainer1;
		private System.Windows.Forms.DataGridViewTextBoxColumn schemaNameDataGridViewTextBoxColumn1;
		private System.Windows.Forms.DataGridViewTextBoxColumn tableNameDataGridViewTextBoxColumn;
		private System.Windows.Forms.DataGridViewTextBoxColumn primaryKeysDataGridViewTextBoxColumn;
		private System.Windows.Forms.ToolStripMenuItem tsmiSelectTrigger;
		private System.Windows.Forms.ToolStripButton tsbErrList;
	}
}