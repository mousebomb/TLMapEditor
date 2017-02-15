package HLib.UICom.Component
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.system.System;
	
	import HLib.UICom.BaseClass.HTopBaseView;
	
	import Modules.Common.ComEventKey;
	import Modules.Common.HAssetsManager;
	import Modules.Common.SourceTypeEvent;
	import Modules.HpopMenu.HpopMenuVo;
	
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * 下拉菜单栏 
	 * @author Administrator
	 * 郑利本
	 */	
	public class HPopMenu extends Sprite
	{
		protected var _MenuBtnArgs:Array = [];
		private var _myWidth:Number;
		private var _myHeight:Number;
		private var _CharWidth:Number=40;
		private var _CharHeight:Number=22;
		private var _textSize:uint=13;
		private var _IsVisible:Boolean=true;
		private var _scale9Image:Scale9Image;
		private var _select9Img:Scale9Image;
		private var _isAddEvent:Boolean;
		public var menuVo:HpopMenuVo;
		public function HPopMenu()
		{
		}
		/**
		 * 设置菜单 
		 * @param MenuNameArray
		 * @param w
		 * 
		 */		
		public function setMenu(MenuNameArray:Array,w:Number=0):void{
			Clear();
			if(w <= 20)
				_myWidth = _CharWidth;
			else
				_myWidth=w;
			_myHeight=MenuNameArray.length*_CharHeight+10;
			if(_scale9Image)
			{
				_scale9Image.width = _myWidth;
				_scale9Image.height = _myHeight;
				_select9Img.width = _myWidth - 7;
				_select9Img.height = _CharHeight;
				_select9Img.y = 5;
			}	else {
				var texture:Scale9Textures = new Scale9Textures(HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE,"background/tips_background"),new Rectangle(7,7,2,2));
				_scale9Image = new Scale9Image(texture);
				addChild(_scale9Image);
				_scale9Image.width = _myWidth;
				_scale9Image.height = _myHeight;
				texture = new Scale9Textures(HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE,"background/tips_over"),new Rectangle(7,7,20,3));
				_select9Img = new Scale9Image(texture);
				_select9Img.touchable = false;
				_select9Img.width = _myWidth - 7;
				_select9Img.height = 20;
				this.addChild(_select9Img);
				
				_select9Img.x = 5;
				_select9Img.y = 5;
			}
			var btn:HSimpleButton;
			var leng:int = MenuNameArray.length;
			var btnLeng:int = _MenuBtnArgs.length;
			for(var i:int=0;i<leng;i++){
				if(i<btnLeng)
				{
					btn = _MenuBtnArgs[i];
					btn.label = MenuNameArray[i];
				}	else {
					btn=new HSimpleButton();
					btn.isclearMOuseCursor = true;
					btn.upColor=0;
					btn.downColor=0;
					btn.overColor=0x0;
					btn.disabledColor=0;
					btn.selectedColor=0x0;
					btn.textSize=_textSize;
					btn.upTextColor = "#9ab2c0"
					btn.overTextColor = "#fbb715"
					btn.init(MenuNameArray[i],_myWidth-8,_CharHeight-2);
					_MenuBtnArgs.push(btn);
					btn.addEventListener(Event.TRIGGERED, onClick);	
				}
				this.addChild(btn);
				btn.x=4;
				btn.y=5+i*_CharHeight;
			}
			this.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		/**
		 * 设置显示菜单内容(按钮皮肤)
		 * @param menuSkinArray	: 菜单按钮皮肤数组([[up, over, down, disabled, select(可传可不传,需要用才传)], [], [].....])
		 * @param labelArr		: 菜单按钮label数组,用于点击后派发事件操作执行(要与参数1传入的按钮一一对应)
		 * @param w				: 操作菜单宽度
		 * @param bgSkin		: 操作菜单背景
		 */		
		public function setMenuBySkin(menuSkinArray:Array, labelArr:Array, w:Number=0, bgSkin:Texture = null):void
		{
			Clear();
			if(w <= 20)
				_myWidth = _CharWidth;
			else
				_myWidth=w;
			_myHeight = menuSkinArray.length * menuSkinArray[0][0].height;
			var bg:Texture ,rect:Rectangle;
			if(bgSkin != null)
			{
				bg = bgSkin;
				rect = new Rectangle(int(bgSkin.width/3),int(bg.height/3),int(bgSkin.width/3),int(bg.height/3));
			}	else {
				bg = HAssetsManager.getInstance().getMyTexture("mainFaceSource","check_over");
				rect = new Rectangle(7,7,5,5)
			}
			if(_scale9Image)
			{
				_scale9Image.width = _myWidth;
				_scale9Image.height = _myHeight;
			}	else {
				var texture:Scale9Textures = new Scale9Textures(bg,rect);
				_scale9Image = new Scale9Image(texture);
				addChild(_scale9Image);
				_scale9Image.width = _myWidth;
				_scale9Image.height = _myHeight;
			}
			var button:HSimpleButton;
			var len:int = menuSkinArray.length;
			for(var i:int = 0; i < len; i++)
			{
				button = new HSimpleButton();
				button.setTextureSkin(
					 menuSkinArray[i][0]
					,menuSkinArray[i][1]
					,menuSkinArray[i][2]
					,menuSkinArray[i][3]
					,menuSkinArray[i][4]
				);
				button.init(labelArr[i]);
				this.addChild(button);
				_MenuBtnArgs.push(button);
				var value:Number = _scale9Image.width - button.myWidth >> 1;
				if(value % 2 != 0)
					value = value - value%2;
				button.x = value;
				value = i* button.height;
				if(value % 2 != 0)
					value = value - value%2;
				button.y = value;
				button.addEventListener(Event.TRIGGERED, onClick);
			}
			this.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function Clear():void{
			var leng:int = _MenuBtnArgs.length;
			for(var i:int=0; i<leng; i++)
			{
				if(_MenuBtnArgs[i].parent)
					_MenuBtnArgs[i].parent.removeChild(_MenuBtnArgs[i])
			}
		}
		private function onTouch(e:TouchEvent):void{
			if(HTopBaseView.getInstance().hasEvent) return; //顶层是否添加UI了
			var touch:Touch = e.getTouch(this);
			if(touch == null)
			{
				_isAddEvent = this.visible=false;
			} 	else {
				if(touch.phase == TouchPhase.HOVER)
				{
					if(e.target is Image)
					{
						if(Image(e.target).parent is HSimpleButton)
						{
							var btn:HSimpleButton = Image(e.target).parent as HSimpleButton
							_select9Img.y = btn.y;
							if(btn.label == "复制名称" && !_isAddEvent)
							{
								_isAddEvent = true;
								Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_UP, onClickStage);
							}
						}	
					}
				}
			}
		}
		
		private function onClickStage(e:MouseEvent):void
		{
			if(_isAddEvent)
			{
				_isAddEvent = false;
				System.setClipboard(menuVo.name);
			}
		}
		protected function onClick(event:Event):void{
			this.dispatchEventWith(ComEventKey.HPO_CLICK_MENU,false, (event.currentTarget as HSimpleButton).label);
			this.visible=false;
		}
		public function set myWidth(value:Number):void{
			_myWidth=value;
		}
		public function get myWidth():Number{
			return _myWidth;
		}
		public function set myHeight(value:Number):void{
			_myHeight=value;
		}
		public function get myHeight():Number{
			return _myHeight;
		}
		public function set CharWidth(value:Number):void{
			_CharWidth=value;
		}
		public function get CharWidth():Number{
			return _CharWidth;
		}
		public function set CharHeight(value:Number):void{
			_CharHeight=value;
		}
		public function get CharHeight():Number{
			return _CharHeight;
		}
		public function set TextSize(value:Number):void{
			_textSize=value;
		}
		public function get TextSize():Number{
			return _textSize;
		}
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			_IsVisible=value;
		}
		override public function dispose():void
		{
			this.removeEventListeners();
			for(var i:int=0;i<_MenuBtnArgs.length;i++){
				var btn:HSimpleButton = _MenuBtnArgs[i];
				btn.dispose();
				this.removeChild(btn);
				_MenuBtnArgs[i]=null;
			}
			
			super.dispose();
		}
		override public function set y(value:Number):void
		{
			if(value % 2 != 0)
				value = value - value%2;
			super.y = value;
		}
		
		override public function set x(value:Number):void
		{
			if(value % 2 != 0)
				value = value - value%2;
			super.x = value;
		}
		
	}
}