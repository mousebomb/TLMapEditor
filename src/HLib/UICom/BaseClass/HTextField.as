package HLib.UICom.BaseClass
{
	import flash.text.TextFieldAutoSize;
	
	import Modules.MainFace.MainInterfaceManage;
	
	import starling.text.TextField;

	public class HTextField extends TextField
	{
		private var _label:String = "";
		public function HTextField(width:int,height:int,text:String,_fontName:String="Verdana",fontSize:Number=12,color:uint=0xffffff,bold:Boolean=false)
		{
			if(MainInterfaceManage.getInstance().fontName != null)
				_fontName = MainInterfaceManage.getInstance().fontName;
			if(_fontName == "") _fontName = "宋体";
			super(width,height,text,_fontName,fontSize,color,bold);
			this.hAlign = TextFieldAutoSize.LEFT;
		}
		
		/**
		 * 7位颜色+2位字体大小+内容
		 * #f9f9f912这里要显示的内容 
		 * @param value
		 */
		public function set label(value:String):void
		{
			_label = value;
			this.text = value;
		}
		public function get label():String  
		{  
			return _label;  
		}
	}
}