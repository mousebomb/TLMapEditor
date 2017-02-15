package tl.mapeditor.ui.common
{
	/**
	 * 公用组件TextField
	 * @author 李舒浩
	 * 
	 * 用法与HTextField用法一样
	 * 
	 * 属性与方法:
	 * 		algin		: 文本居中样式
	 * 		font		: 文本字体样式(默认为统一字体,只有特殊需要设置的字体才使用设置)
	 * 		size		: 字体大小
	 * 		color		: 字体颜色
	 * 		bold		: 是否加粗
	 * 		leading		: 文本间距
	 * 		eventLabel	: 带事件样式文本
	 * 		colorLabel	: 颜色与大小文本
	 * 		label		: 当前使用带事件样式或颜色大小文本输入的内容
	 */

	import flash.text.TextField;
	import flash.text.TextFormat;

	import tl.mapeditor.Config;

	public class MyTextField extends TextField
	{
		protected var _textFormat:TextFormat;	//文字样式
		protected var _label:String = "";
		
		public function MyTextField()  {  super();  init(); }
		
		private function init():void
		{
			//设置文本样式
			_textFormat = new TextFormat();
			_textFormat.font = Config.FONT;
			_textFormat.size = 12;
			_textFormat.color = 0xFFFFFF;
			this.defaultTextFormat = _textFormat;
		}
		/**
		 * 设置文本对齐样式
		 * @param vaule	: 对齐样式(left:左 center:居中 right:右)
		 */		
		public function set algin(vaule:String):void
		{
			_textFormat.align = vaule;
			this.defaultTextFormat = _textFormat;
		}
		/**
		 * 设置文本字体样式 
		 * @param vaule	: 文本字体
		 */		
		public function set font(vaule:String):void
		{
			_textFormat.font = vaule;
			this.defaultTextFormat = _textFormat;
		}
		/**
		 * 设置文本字体大小 
		 * @param vaule	: 字体大小值
		 */		
		public function set size(vaule:int):void
		{
			_textFormat.size = vaule;
			this.defaultTextFormat = _textFormat;
		}
		/**
		 * 设置文本字体颜色值 
		 * @param vaule	: 16进制颜色值
		 */		
		public function set color(vaule:uint):void
		{
			_textFormat.color = vaule;
			this.defaultTextFormat = _textFormat;
		}
		/**
		 * 是否加粗 
		 * @param vaule	: true:加粗 false:不加粗
		 */		
		public function set bold(vaule:Boolean):void
		{
			_textFormat.bold = vaule;
			this.defaultTextFormat = _textFormat;
		}
		/**
		 * 文本垂直间距
		 * @param value	: 间距
		 */		
		public function set leading(value:int):void
		{
			_textFormat.leading = value;
			this.defaultTextFormat = _textFormat;
		}
		
		/**
		 * 7位颜色+2位字体大小+n/b是否粗体+n/u是否下划线+两位数事件Key长度+事件Key+内容
		 * #f9f9f916bu08eventkey这里要显示的内容 
		 * #f9f9f916nu08eventkey这里要显示的内容 
		 * #f9f9f916nn00这里要显示的内容
		 * @param value
		 */
		public function set eventLabel(value:String):void
		{
			_label = value;
			if(_label == "" || _label == null)
			{
				this.htmlText = "";
				return;
			}
			
			var arr:Array = _label.split("#");
			_label = "";
			var colorStr:String;
			var sizeStr:String;
			var boldStr:String;
			var lineStr:String;
			var eventStr:String;
			var msgStr:String;
			var lenght:int = 0;
			var str:String="";
			if(arr[0].length < 1)
			{
				var len:int = arr.length;
				for(var i:int = 1; i < len; i++)
				{
					colorStr = arr[i].slice(0,6);
					sizeStr = arr[i].slice(6,8);
					boldStr = arr[i].slice(8,9);
					lineStr = arr[i].slice(9,10);
					lenght = int(arr[i].slice(10,12));
					eventStr = arr[i].slice(12,12+lenght);
					msgStr = arr[i].slice(12+lenght,arr[i].length);		
					str = "<font color='#"+colorStr+"'"+" size='"+sizeStr+"'>"+ msgStr+"</font>";	
					if(boldStr != "n")
					{
						str = "<b>" + str + "</b>";
					}
					if(lineStr != "n")
					{
						str = "<u>" + str + "</u>";
					}				
					if(lenght != 0)
					{
						str = "<a href='event:"+eventStr+"'>" + str + "</a>";
					}
					_label += str;
					str = "";
				}
			}
			else
			{
				_label = arr[0];
			}
			this.htmlText = _label;
			
		}		
		
		/**
		 * 7位颜色+2位字体大小+内容
		 * #f9f9f916这里要显示的内容 
		 * @param value
		 */
		public function set label(value:String):void
		{
			_label = value;
			if(_label == "" || _label == null)
			{
				this.htmlText = "";
				return;
			}
			var colorIndexArr:Array = new Array();
			var colorArr:Array=new Array();
			var sizeArr:Array=new Array();
			var len:int = _label.length;
			for(var i:int = 0; i < len; i++){
				if(_label.charAt(i) == "#")
				{
					colorIndexArr.push(i);
					colorArr.push(_label.slice(i, i+7));
					sizeArr.push(_label.slice(i+7, i+9));
				}				
			}
			var tempStr:String = "";
			len = colorIndexArr.length;
			for(i = 0; i < len;i++)
			{
				if(i == len-1)
					tempStr += "<font color='"+colorArr[i]+"'"+" size='"+sizeArr[i]+"'>"+_label.slice(colorIndexArr[i]+9,_label.length)+"</font>";					
				else
					tempStr += "<font color='"+colorArr[i]+"'"+" size='"+sizeArr[i]+"'>"+_label.slice(colorIndexArr[i]+9,colorIndexArr[i+1])+"</font>";
			}
			if(tempStr == "")
				this.htmlText = _label;
			else
				this.htmlText = tempStr;
		}
		public function get label():String  {  return _label;  }
		
		
	}
}