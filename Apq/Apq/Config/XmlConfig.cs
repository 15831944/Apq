using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace Apq.Config
{
	/// <summary>
	/// Xml 配置文件
	/// </summary>
	public partial class XmlConfig : Apq.Config.clsConfig
	{
		private System.Xml.XmlDocument xd = new System.Xml.XmlDocument();
		private System.Xml.XmlNode xn;
		private Apq.IO.FsWatcher fsw = new Apq.IO.FsWatcher();

		/// <summary>
		/// Xml 配置文件
		/// </summary>
		public XmlConfig()
			: base()
		{
			fsw.Changed += new FileSystemEventHandler(fsw_Changed);
		}

		/// <summary>
		/// 获取或设置文件路径
		/// </summary>
		public override string Path
		{
			get { return base.Path; }
			set
			{
				xn = null;
				object lockXml = Apq.Locks.GetFileLock(value);
				lock (lockXml)
				{
					try
					{
						xd.Load(value);
					}
					catch
					{
						string str = string.Format(@"<?xml version=""1.0"" encoding=""utf-8"" ?>
<{0}/>
", Root);
						File.WriteAllText(value, str, Encoding.UTF8);
						xd.Load(value);
					}
				}

				string strFolder = System.IO.Path.GetDirectoryName(value);
				string strFileName = System.IO.Path.GetFileName(value);
				if (fsw.FileSystemWatcher.Filter != strFileName)
				{
					fsw.FileSystemWatcher.Filter = strFileName;
				}
				if (fsw.FileSystemWatcher.Path != strFolder)
				{
					fsw.FileSystemWatcher.Path = strFolder;
					fsw.Start();
				}

				base.Path = value;
			}
		}

		// 文件改变自动读取
		private void fsw_Changed(object sender, FileSystemEventArgs e)
		{
			string strRoot = Root;
			Path = Path;
			Root = strRoot;
		}

		/// <summary>
		/// 获取或设置根(使用XPath,应该指向一个确定的结点)
		/// </summary>
		public override string Root
		{
			get
			{
				return base.Root;
			}
			set
			{
				xn = xd.SelectSingleNode(value);

				base.Root = value;
			}
		}

		/// <summary>
		/// 保存配置文件
		/// </summary>
		public override void Save()
		{
			fsw.Stop();
			object lockXml = Apq.Locks.GetFileLock(_Path);
			lock (lockXml)
			{
				xd.Save(_Path);
			}
			fsw.Start();
		}

		/// <summary>
		/// 另存为
		/// </summary>
		/// <param name="Path"></param>
		public override void SaveAs(string Path)
		{
			xd.Save(Path);
		}

		/// <summary>
		/// 获取配置名列表
		/// </summary>
		/// <returns></returns>
		public override string[] GetValueNames()
		{
			throw new NotImplementedException();
		}

		/// <summary>
		/// 获取或设置配置[推荐使用]
		/// </summary>
		/// <param name="ClassName">类名</param>
		/// <param name="PropertyName">属性名(特殊值:InnerText)</param>
		/// <returns></returns>
		public override string this[string ClassName, string PropertyName]
		{
			get
			{
				if (xn != null)
				{
					System.Xml.XmlNode xn1 = xn.SelectSingleNode(ClassName);
					if (xn1 != null)
					{
						if (xn1.Attributes[PropertyName] != null)
						{
							return xn1.Attributes[PropertyName].Value;
						}

						if (PropertyName == "InnerText")
						{
							return xn1.InnerText;
						}

						// 支持子节点
						if (xn1.HasChildNodes)
						{
							System.Xml.XmlNodeList xnl = xn1.SelectNodes(PropertyName);
							if (xnl.Count > 0)
							{
								return xnl[xnl.Count - 1].InnerText;
							}
						}
					}
				}
				return null;
			}
			set
			{
				if (xn == null)
				{
					throw new System.Exception("请先设置 Root!");
				}

				System.Xml.XmlNode xn1 = xn.SelectSingleNode(ClassName);
				if (xn1 == null)
				{
					xn1 = xd.CreateElement(ClassName);
					xn.AppendChild(xn1);
				}
				if (xn1.Attributes[PropertyName] == null)
				{
					xn1.Attributes.Append(xd.CreateAttribute(PropertyName));
				}
				xn1.Attributes[PropertyName].Value = value;
			}
		}

		/// <summary>
		/// 获取或设置集合型配置中的单项属性值
		/// </summary>
		/// <param name="ClassName">类名</param>
		/// <param name="CollectionElementName">集合元素名</param>
		/// <param name="ItemElementName">子项元素名</param>
		/// <param name="ItemName">子项name属性值</param>
		/// <param name="PropertyName">属性名(特殊值:InnerText)</param>
		/// <returns></returns>
		public string this[string ClassName, string CollectionElementName, string ItemElementName, string ItemName, string PropertyName]
		{
			get
			{
				if (xn != null)
				{
					System.Xml.XmlNode xn1 = xn.SelectSingleNode(ClassName + "/" + CollectionElementName + "/" + ItemElementName + "[@name=\"" + ItemName + "\"]");
					if (xn1 != null)
					{
						if (xn1.Attributes[PropertyName] != null)
						{
							return xn1.Attributes[PropertyName].Value;
						}

						if (PropertyName == "InnerText")
						{
							return xn1.InnerText;
						}

						// 支持子节点
						if (xn1.HasChildNodes)
						{
							System.Xml.XmlNodeList xnl = xn1.SelectNodes(PropertyName);
							if (xnl.Count > 0)
							{
								return xnl[xnl.Count - 1].InnerText;
							}
						}
					}
				}
				return null;
			}
			set
			{
				if (xn == null)
				{
					throw new System.Exception("请先设置 Root!");
				}

				System.Xml.XmlNode xn1 = xn.SelectSingleNode(ClassName + "/" + CollectionElementName + "/" + ItemElementName + "[@name=\"" + ItemName + "\"]");
				if (xn1 == null)
				{
					System.Xml.XmlNode xn2 = xn.SelectSingleNode(ClassName + "/" + CollectionElementName);
					if (xn2 == null)
					{
						System.Xml.XmlNode xn3 = xn.SelectSingleNode(ClassName);
						if (xn3 == null)
						{
							xn3 = xd.CreateElement(ClassName);
							xn.AppendChild(xn3);
						}
						xn2 = xd.CreateElement(CollectionElementName);
						xn3.AppendChild(xn2);
					}
					xn1 = xd.CreateElement(ItemElementName);
					xn2.AppendChild(xn1);
				}
				if (xn1.Attributes[PropertyName] == null)
				{
					xn1.Attributes.Append(xd.CreateAttribute(PropertyName));
				}
				xn1.Attributes[PropertyName].Value = value;
			}
		}

		#region 表配置
		/// <summary>
		/// 获取表类型配置
		/// </summary>
		/// <param name="ClassName">类名</param>
		/// <param name="TableElementName">表元素名</param>
		/// <returns></returns>
		public System.Data.DataTable GetTableConfig(string ClassName, string TableElementName)
		{
			if (xn != null)
			{
				System.Xml.XmlNode xn1 = xn.SelectSingleNode(ClassName + "/" + TableElementName);
				if (xn1 != null)
				{
					System.Data.DataTable dt = new System.Data.DataTable(TableElementName);
					StringReader sr = new StringReader(xn1.InnerXml);
					System.Xml.XmlReader xr = System.Xml.XmlReader.Create(sr);
					dt.ReadXml(xr);
					return dt;
				}
			}
			return null;
		}

		/// <summary>
		/// 设置表类型配置
		/// </summary>
		/// <param name="ClassName">类名</param>
		/// <param name="TableElementName">表元素名</param>
		/// <param name="dt">表配置</param>
		public void SetTableConfig(string ClassName, string TableElementName, System.Data.DataTable dt)
		{
			if (xn == null)
			{
				throw new System.Exception("请先设置 Root!");
			}

			System.Xml.XmlNode xn1 = xn.SelectSingleNode(ClassName);
			if (xn1 == null)
			{
				xn1 = xd.CreateElement(ClassName);
				xn.AppendChild(xn1);
			}

			System.Xml.XmlNode xn2 = xn1.SelectSingleNode(TableElementName);
			if (xn2 == null)
			{
				xn2 = xd.CreateElement(TableElementName);
				xn1.AppendChild(xn2);
			}

			if (xn2 != null && xn2.ChildNodes.Count > 0)
			{
				xn2.InnerXml = string.Empty;
			}

			StringWriter sw = new StringWriter();
			dt.WriteXml(sw, System.Data.XmlWriteMode.WriteSchema);
			xn2.InnerXml = sw.ToString();
		}
		#endregion
	}
}
