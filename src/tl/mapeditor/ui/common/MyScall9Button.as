package tl.mapeditor.ui.common
{
	import HLib.Tool.HTextEffect;

	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import tl.utils.HCss;

	public class MyScall9Button extends MyScale9SimpleStateButton
	{
		private var _bmdUp:BitmapData=null;
		private var _bmdOver:BitmapData=null;
		private var _bmdDown:BitmapData=null;
		private var _bmdDisabled:BitmapData=null;
		private var _bmdSelected:BitmapData=null;
		
		public var upColor:uint=HCss.HButton_UpColor;
		public var downColor:uint=HCss.HButton_DownColor;
		public var overColor:uint=HCss.HButton_OverColor;	
		public var textColor:uint=0xFFffffff;
		public var textSize:uint=12;
		
		private var _label:TextField=new TextField();
		private var _myWidth:int;
		private var _myHeight:int;
		private var _isornotSelected:Boolean=false;
		private var _isornotDisabled:Boolean=false;
		private var _txtHfont:MyTextField;
		public function MyScall9Button()
		{
		}
		public function setSkin(bmdUp:BitmapData=null,
								bmdOver:BitmapData=null,
								bmdDown:BitmapData=null,
								bmdDisabled:BitmapData=null,
								bmdSelected:BitmapData=null
		):void{
			_bmdUp=bmdUp;
			_bmdOver=bmdOver;
			_bmdDown=bmdDown;
			_bmdDisabled=bmdDisabled;
			_bmdSelected=bmdSelected;
		}
		public function setDefaultSkin():void{
			/*_bmdUp= new Ofen_Button_Up();
			_bmdOver=new Ofen_Button_Over();
			_bmdDown=new Ofen_Button_Down();
			_bmdDisabled=new Ofen_Button_Disabled();
			_bmdSelected=new Ofen_Button_Select();*/
		}
		public function HButtonInIt(_text:String="",_width:int=60,_height:int=30):void{
			if(_width==0||_height==0) return;
			_myWidth=_width;
			_myHeight=_height;
			var _Rectangle:Rectangle;
			if(_bmdUp==null){
				_bmdUp=new BitmapData(_myWidth,_myHeight,true,upColor);
			}
			if(_bmdOver==null){
				_bmdOver=new BitmapData(_myWidth,_myHeight,true,overColor);
			}
			if(_bmdDown==null){
				_bmdDown=new BitmapData(_myWidth,_myHeight,true,downColor);
			}
			_Rectangle=new Rectangle(int(_bmdUp.width/3),int(_bmdUp.height/3),int(_bmdUp.width/3),int(_bmdUp.height/3));
			this.InIt(_Rectangle,_bmdUp,_bmdOver,_bmdDown);

			this.width=_myWidth;
			this.height=_myHeight;
			_label.selectable=false;
			_label.mouseEnabled=false;
			_label.text=_text;			
			HTextEffect.textFormat(_label,textSize,textColor);
			HTextEffect.textDropShadowFilter(_label);
			_label.width=_label.textWidth+5;
			_label.height=_label.textHeight+2;
			this.addChild(_label);
			_label.x=(_myWidth-_label.width)/2;
			_label.y=(_myHeight-_label.height)/2-2;
		}
		public function setTextSize(_size:int):void{
			HTextEffect.textFormat(_label,_size);
			_label.width=_label.textWidth+4;
			_label.height=_label.textHeight+2;	
			_label.x=(_myWidth-_label.width)/2;
			_label.y=(_myHeight-_label.height)/2-2;
		}
		public function set label(value:String):void{
			_label.text=value;
			HTextEffect.textFormat(_label,textSize,textColor);
			HTextEffect.textDropShadowFilter(_label);
			_label.width=_label.textWidth+4;
			_label.height=_label.textHeight+4;
			//this.addChild(_label);
			_label.x=(_myWidth-_label.width)/2;
			_label.y=(_myHeight-_label.height)/2-2;
		}
		public function get label():String{
			return _label.text;
		}
		public function set myWidth(value:Number):void{
			_myWidth=value;
			this.width=_myWidth;
		}
		public function get myWidth():Number{
			return _myWidth;
		}
		public function set myHeight(value:Number):void{
			_myHeight=value;
			this.height=_myHeight;
		}
		public function get myHeight():Number{
			return _myHeight;
		}
		public function changeText(value:String):void
		{
			if(!_txtHfont)
			{
				var format:TextFormat = new TextFormat;
				format.font = "宋体";
				_label.visible = false;
				_txtHfont = new MyTextField;
				_txtHfont.defaultTextFormat = format;
				this.addChild(_txtHfont);
				_txtHfont.mouseEnabled = _txtHfont.selectable = false;
				HTextEffect.textDropShadowFilter(_txtHfont);
			}
			_txtHfont.label = value;
			_txtHfont.width=_txtHfont.textWidth+6;
			_txtHfont.height=_txtHfont.textHeight+6;
			_txtHfont.x = (this.width - _txtHfont.width) * .5
			_txtHfont.y = (this.height - _txtHfont.height) * .5
		}
	}
}