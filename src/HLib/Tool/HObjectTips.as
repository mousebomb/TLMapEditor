package HLib.Tool
{
	/**
	 * 公用tips类 
	 */	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import HLib.DataUtil.HashMap;
	import HLib.UICom.BaseClass.HSprite;
	import HLib.UICom.BaseClass.HTextField2D;
	import HLib.UICom.BaseClass.HTopBaseView;
	import HLib.UICom.BaseClass.HXYSprite;
	
	import Modules.Common.HAssetsManager;
	import Modules.Common.SGCsvManager;
	import Modules.Common.SourceTypeEvent;
	import Modules.MainFace.MainInterfaceManage;
	import Modules.Map.InitLoaderMapResControl;
	import Modules.SFeather.SFTextField;
	import Modules.Setting.Configuration;
	import Modules.Setting.SettingSources;
	import Modules.Setting.Data.ConvenientKeyData;
	
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class HObjectTips extends HXYSprite
	{
		private static var MyInstance:HObjectTips;
		
		private var _hashMap:HashMap;
		private var _difWidth:int = 220;
		private var _isHide:Boolean;					//是否隐藏
		private var _backgroundImage:Scale9Image;		//背景图片
		private var _currentObj:Object;			//当前显示物体
		private var _currentShowStr:String = "";		//当前显示文本
		public var mouseX:Number = 0;
		public var mouseY:Number = 0;
		private var _tipsText:SFTextField;				//文本
		private var _textColor:String = "#ffffff12";
		private var _htext:HTextField2D;
		public function HObjectTips()
		{
			if( MyInstance )
				throw new Error ("单例只能实例化一次,请用 getInstance() 取实例。");
			MyInstance = this;	
		}
		public static function getInstance():HObjectTips 
		{
			if ( !MyInstance ) 
			{				
				MyInstance = new HObjectTips();
			}
			return MyInstance;
		}
		public function init():void
		{	
			if(this.isInit)
			{
				return;
			}
			var textures:Scale9Textures = new Scale9Textures(HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE,"background/tips_background"),new Rectangle(6,6,4,4));
			_backgroundImage = new Scale9Image(textures);
			this.addChild(_backgroundImage);
			_hashMap = new HashMap();
			_tipsText = new SFTextField;
			this.addChild(_tipsText);
			_tipsText.touchable = false;
			_tipsText.myWidth = _difWidth - 16;
			_tipsText.leading = 3;
			_tipsText.x = 8;
			_tipsText.y = 8;
			var fontName:String = MainInterfaceManage.getInstance().fontName == null ? "宋体" :MainInterfaceManage.getInstance().fontName
			var format:TextFormat = new TextFormat(fontName, 12,0xffffff, false, false, false, null, null,"left" , 0, 0, 0, 1);
			_htext = new HTextField2D;
			_htext.defaultTextFormat = format;
			_htext.wordWrap = false;
			_htext.embedFonts = true;
			_htext.selectable = false;  
			this.touchable = false;
			this.touchGroup = true;
			HTopBaseView.getInstance().addChild(this);
			this.visible = false;
			isInit = true;
		}
		/**
		 * 根据提示ID显示对应的tips 
		 * @param csvId			: 提示ID
		 * @param tipsWidth		: 提示文本宽度(如果不传参数则使用文本字数进行计算显示)
		 * @param tipsHeight	: 提示文本高度(如果不传参数则使用文本字数进行计算显示)
		 */		
		public function showTipsByCsvId(csvId:int, tipsWidth:int = 0, tipsHeight:int = 0):void
		{
			var tips:String=SGCsvManager.getInstance().table_tipsitem.FindCell(""+csvId,"Info").replace(/&/g,"\n");
			showTips(tips, tipsWidth, tipsHeight);
		}
		
		/**
		 * 显示指定字符串tips 
		 * @param tips		: 显示的文字
		 * @param tipsWidth	: 提示文本宽度(如果不传参数则使用文本字数进行计算显示)
		 * @param tipsHeight: 提示文本高度(如果不传参数则使用文本字数进行计算显示)
		 */		
		public function showTipsByString(tips:String, tipsWidth:int = 0, tipsHeight:int = 0):void
		{
			showTips(tips, tipsWidth, tipsHeight);
		}
		
		/**
		 * 添加指定的对象鼠标移入事件触发时按给定的字符串显示Tips 
		 * @param object	: 指定对象
		 * @param tips		: 提示文字
		 * @param tipsWidth	: 提示文本宽度(如果不传参数则使用文本字数进行计算显示)
		 * @param tipsHeight: 提示文本高度(如果不传参数则使用文本字数进行计算显示)
		 */		
		public function pushTips(object:*, tips:String, tipsWidth:int = 0, tipsHeight:int = 0):void
		{
			//判断是否有此提示保存,有的话先清除事件
			/*if( _hashMap.containsKey(object) )
			{
				var oldObj:* = _hashMap.get(object);
				oldObj.object.removeEventListener(TouchEvent.TOUCH, onTouchEvent);
				oldObj = null;
			}*/
			//添加保存内容
			if(!_hashMap) return;
			_hashMap.put( object, { tips:tips, tipsWidth:tipsWidth, tipsHeight:tipsHeight, object:object } );
			object.addEventListener(TouchEvent.TOUCH, onTouchEvent);
		}
		/**
		 * 根据scvID添加指定的对象鼠标移入事件触发时按Id显示Tips  
		 * @param object	: 指定对象
		 * @param csvId		: 提示文字
		 * @param tipsWidth	: 提示文本宽度(如果不传参数则使用文本字数进行计算显示)
		 * @param tipsHeight: 提示文本高度(如果不传参数则使用文本字数进行计算显示)
		 */		
		public function pushTipsByCsvId(object:*, csvId:int, tipsWidth:int = 0, tipsHeight:int = 0):void
		{
			if(_hashMap == null)
				_hashMap = new HashMap;
			//判断是否有此提示保存,有的话先清除事件
			if( _hashMap.containsKey(object) )
			{
				var oldObj:* = _hashMap.get(object);
				oldObj.object.removeEventListener(TouchEvent.TOUCH, onTouchEvent);
				oldObj = null;
			}
			var tips:String = SGCsvManager.getInstance().table_tipsitem.FindCell(""+csvId,"Info").replace(/&/g,"\n");
			_hashMap.put(object,{ tips:tips, tipsWidth:tipsWidth, tipsHeight:tipsHeight, object:object });
			object.addEventListener(TouchEvent.TOUCH, onTouchEvent);
		}
		/**
		 * 移除指定对象tips 
		 * @param object	: 需要移除的指定对象
		 */		
		public function removeTips(object:*):void{
			_hashMap.remove(object);
			object.removeEventListener(TouchEvent.TOUCH, onTouchEvent);
		}
		/** 隐藏提示 **/
		public function hideTips():void  {  this.visible = false;  }
		
		/** 鼠标移入执行 **/
		private function onTouchEvent(e:TouchEvent):void
		{
			if(HTopBaseView.getInstance().hasEvent || HTopBaseView.getInstance().isShowFull) {
				if(e.currentTarget is HSprite)
				{
					if(!HSprite(e.currentTarget).isPierce)
					{
						this.visible = false;
						return;
					}
				}	else {
					this.visible = false;
					return; //顶层是否添加UI了
				}
			}
			
			if(InitLoaderMapResControl.getInstance().isInitLoading)
				return;
			var object:* = e.currentTarget;
			var tipsObj:Object = _hashMap.get(object);
			var touch:Touch = e.getTouch(object);
			if(touch == null)
			{
				_isHide = false;
				_currentObj = null;
				this.visible = false;
			}	else {
				if(touch.phase == TouchPhase.BEGAN)
					_isHide = true;
				else if(touch.phase == TouchPhase.HOVER)
				{
					if(!_isHide)
					{
						mouseX = touch.globalX;
						mouseY = touch.globalY;
						if(tipsObj.object && tipsObj.object.name)
						{
							if(String(tipsObj.object.name).substr(0,26) == "mainFaceToolBarShowSetTips")
							{
								var id:String = String(tipsObj.object.name).substr(26, 2);
								var str:String = ConvenientKeyData.getKeyByIndex(int(id));
								var tips:String = String(tipsObj.tips).substr(0,String(tipsObj.tips).length - 3)
								tipsObj.tips = tips + "[" + str + "]";
							}
						}
						if(_currentObj != tipsObj || _currentShowStr != tipsObj.tips)
						{
							_currentObj = tipsObj;
							_currentShowStr = tipsObj.tips;
							showTips(tipsObj.tips, tipsObj.tipsWidth, tipsObj.tipsHeight);
						}
						autoSetLocation(this);
					}
				}	else if(touch.phase == TouchPhase.ENDED)
					this.visible = false;
			}
			//释放内存
			object = null;
			tipsObj = null;
		}
		
		/**
		 * 显示tips 
		 * @param tips		: 提示文字
		 * @param tipsWidth	: 提示宽度
		 * @param tipsHeight: 提示高度
		 */		
		private function showTips(tips:String, tipsWidth:int = 0, tipsHeight:int = 0):void
		{
			if(!this.isInit) return;
			if(_tipsText.label != "#ffffff12"+tips)
			{
				//判断宽度控制
				if(tipsWidth == 0)	_tipsText.myWidth = _difWidth-16;
				else				_tipsText.myWidth = tipsWidth-16;
				_htext.label = _textColor + tips; 
				//设置tips宽高
				if(_htext.text.length * 12 >= _tipsText.myWidth-16)
					_tipsText.wordWrap = true;
				else
					_tipsText.wordWrap = false;
				//赋值定位文本
				_tipsText.label = "#ffffff12"+tips;
				var vw:int = _tipsText.textWidth + 16;
				/*if(_currentShowStr == '一键出售白装物品') 
					vw = 125;*/
				this.myWidth = _backgroundImage.width = vw;
				var vh:Number = _tipsText.textHeight + 12;
				if(vh < 35)
					vh = 30;
				/*if(_currentShowStr == '一键出售白装物品') 
					vh = 50;*/
				this.myHeight = _backgroundImage.height = vh
				
			}
			/*if(_currentShowStr == '按照分解设定进行快速分解未打造过的装备。' || _currentShowStr == '一键出售白装物品') {
				SettingSources.getInstance().tipsDelayCall = updateTipsTime;
				updateTipsTime()
			} 	else {
				SettingSources.getInstance().tipsDelayCall = null;
			}*/
			HTopBaseView.getInstance().setChildIndex(this, HTopBaseView.getInstance().numChildren)
			//设置位置
			this.visible = true;
		}
		private function updateTipsTime():void
		{
			var str:String = ''
			if(SettingSources.getInstance().itemResolveTime > 0)
			{
				if(SettingSources.getInstance().getVIPFlagsByType( Configuration.TYPE_22 ) && _currentShowStr == '按照分解设定进行快速分解未打造过的装备。')
					str = '#f0220012自动分解冷却  ' + Tool.convertTimeToMinStr(SettingSources.getInstance().itemResolveTime, 'm:s');
				if(SettingSources.getInstance().getVIPFlagsByType( Configuration.TYPE_6 ) && _currentShowStr == '一键出售白装物品')
					str = '\n#f0220012自动清理冷却  ' + Tool.convertTimeToMinStr(SettingSources.getInstance().itemResolveTime, 'm:s');
				
			}
			_tipsText.label = "#ffffff12" + _currentShowStr + str;
		}
		public function autoSetLocation(setDisplayerObject:DisplayObject):void
		{
			//判断所提示的位置是否在显示区域内,控制显示位置
			var vx:int;
			var vy:int;
			 if(setDisplayerObject == this)
			 {
				 vx = this.myWidth;
				 vy = this.myHeight;
			 }	else {
				 vx = setDisplayerObject.width;
				 vy = setDisplayerObject.height;
			 }
			var mouseAndObjW:int = mouseX + vx + 30;
			var mouseAndObjH:int = mouseY + vy;
			
			if(mouseAndObjW > HTopBaseView.getInstance().myWidth)
				setDisplayerObject.x = mouseX - vx - 20;
			else
				setDisplayerObject.x = mouseX + 30;
			if(mouseAndObjH > HTopBaseView.getInstance().myHeight)
				setDisplayerObject.y = mouseY - vy 
			else
				setDisplayerObject.y = mouseY;
		}

		public function get bgVisible():Boolean
		{
			return _backgroundImage.visible;
		}

		public function set bgVisible(value:Boolean):void
		{
			_backgroundImage.visible = value;
		}

	}
}