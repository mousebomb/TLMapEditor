package tl.mapeditor.ui.common
{
	/**
	 * 标题栏类
	 * @author 李舒浩
	 */	
	import Lib.BaseClass.MySprite;
	import Lib.Tool.Tool;
	
	public class MyTitleView extends MySprite
	{
		private var _titleTextVec:Vector.<MyTextField>;
		
		public var bgColor:uint = 0x191919;	//背景颜色
		public var lineColor:uint = 0x3D3D3D;	//线颜色
		public var textSize:uint = 12;			//标题文字大小
		public var textColor:uint = 0x999999;	//标题文字颜色
		
		public function MyTitleView()  {  super();  }
		/**
		 * 
		 * @param widthArr		: 每一个的标题宽度,[]
		 * @param labelArr		: 标题字符
		 */		
		public function init(widthArr:Array, labelArr:Array = null):void
		{
			if(this.isInit) return;
			this.isInit = true;
			
			var w:uint;
			var len:int = widthArr.length;
			_titleTextVec = new Vector.<MyTextField>(len, true);
			var text:MyTextField;
			var theX:int = 0;
			for(var i:int = 0; i < len; i++)
			{
				w += widthArr[i];
				text = Tool.getMyTextField(widthArr[i], -1, textSize, textColor, "center");
				text.background = true;
				text.backgroundColor = bgColor;
				text.border = true;
				text.borderColor = lineColor;
				text.text = (labelArr ? labelArr[i] : "");
				text.mouseEnabled = text.mouseWheelEnabled = false;
				this.addChild(text);
				text.x = theX;
				theX = text.x + text.width+1;
				_titleTextVec[i] = text;
			}
			this.myWidth = w;
			this.myHeight = text.height;
		}
		/**
		 * 设置标题文本内容
		 * @param titleArr
		 */		
		public function set titleLabel(titleArr:Array):void
		{
			_titleArr = titleArr;
			var len:int = _titleTextVec.length;
			for(var i:int = 0; i < len; i++)
			{
				_titleTextVec[i].text = (titleArr ? titleArr[i] : "");
			}
		}
		public function get titleTextVec():Vector.<MyTextField>  {  return _titleTextVec;  }

		private var _titleArr:Array;
		public function get titleArr():Array  {  return _titleArr;  }

		
		
	}
}