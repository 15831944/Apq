using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace Apq.Config
{
	/// <summary>
	/// Xml �����ļ�
	/// </summary>
	public partial class XmlConfig : Apq.Config.clsConfig
	{
		private System.Xml.XmlDocument xd = new System.Xml.XmlDocument();
		private System.Xml.XmlNode xn;
		private FileSystemWatcher fsw = new FileSystemWatcher();

		/// <summary>
		/// Xml �����ļ�
		/// </summary>
		public XmlConfig()
			: base()
		{
			fsw.Changed += new FileSystemEventHandler(fsw_Changed);
		}

		/// <summary>
		/// ��ȡ�������ļ�·��
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
				if (fsw.Path != strFolder)
				{
					fsw.Path = strFolder;
					fsw.EnableRaisingEvents = true;
				}
				if (fsw.Filter != strFileName)
				{
					fsw.Filter = strFileName;
				}

				base.Path = value;
			}
		}

		// �ļ��ı��Զ���ȡ
		private void fsw_Changed(object sender, FileSystemEventArgs e)
		{
			string strRoot = Root;
			Path = Path;
			Root = strRoot;
		}

		/// <summary>
		/// ��ȡ�����ø�(ʹ��XPath,Ӧ��ָ��һ��ȷ���Ľ��)
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
		/// ���������ļ�
		/// </summary>
		public override void Save()
		{
			fsw.EnableRaisingEvents = false;
			object lockXml = Apq.Locks.GetFileLock(_Path);
			lock (lockXml)
			{
				xd.Save(_Path);
			}
			fsw.EnableRaisingEvents = true;
		}

		/// <summary>
		/// ���Ϊ
		/// </summary>
		/// <param name="Path"></param>
		public override void SaveAs(string Path)
		{
			xd.Save(Path);
		}

		/// <summary>
		/// ��ȡ�������б�
		/// </summary>
		/// <returns></returns>
		public override string[] GetValueNames()
		{
			throw new NotImplementedException();
		}

		/// <summary>
		/// ��ȡ����������[�Ƽ�ʹ��]
		/// </summary>
		/// <param name="ClassName">����</param>
		/// <param name="PropertyName">������(����ֵ:InnerText)</param>
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

						// ֧���ӽڵ�
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
					throw new System.Exception("�������� Root!");
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
		/// ��ȡ�����ü���Ū����
		/// </summary>
		/// <param name="ClassName">����</param>
		/// <param name="CollectionElementName">����Ԫ����</param>
		/// <param name="ItemElementName">����Ԫ����</param>
		/// <param name="ItemName">����name����ֵ</param>
		/// <param name="PropertyName">������(����ֵ:InnerText)</param>
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

						// ֧���ӽڵ�
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
					throw new System.Exception("�������� Root!");
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
	}
}
