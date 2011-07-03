﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Windows;

namespace Apq.ICSharpCode.TreeView
{
	public class FileNode : FileSystemNode
	{
		public FileNode(string path)
		{
			this.name = Path.GetFileName(path);
			this.info = new FileInfo(path);
		}

		FileInfo info;
		string name;

		public override object Text
		{
			get
			{
				return name;
			}
		}

		public override object Icon
		{
			get
			{
				return Apq.Windows.Forms.IconChache.GetFileSystemIcon(FullPath);
			}
		}

		public override object ToolTip
		{
			get
			{
				return info.FullName;
			}
		}

		public override bool IsEditable
		{
			get
			{
				return true;
			}
		}

		public override string LoadEditText()
		{
			return name;
		}

		public override bool SaveEditText(string value)
		{
			if (value.Contains("?"))
			{
				MessageBox.Show("?");
				return false;
			}
			else
			{
				name = value;
				return true;
			}
		}

		public override long? FileSize
		{
			get { return info.Length; }
		}

		public override DateTime? FileModified
		{
			get { return info.LastWriteTime; }
		}

		public override string FullPath
		{
			get { return info.FullName; }
		}

		public override void Paste(IDataObject data)
		{
			Parent.Paste(data);
		}
	}
}
