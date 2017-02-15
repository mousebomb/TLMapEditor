package HLib.UICom.Component
{
	import HLib.UICom.BaseClass.HSprite;
	import HLib.UICom.BaseClass.HTopBaseView;
	
	import Modules.Common.HCss;
	import Modules.DataSources.ChatDataSource;
	import Modules.DataSources.Item;
	import Modules.MainFace.MouseCursorManage;
	import Modules.SFeather.SFTextField;
	import Modules.view.roleEquip.ItemIconTipsManage;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * 可点击物品名称
	 * @author Administrator
	 * 郑利本
	 */	
	public class HItemText extends HSprite
	{
		private var _isStart:Boolean;
		private var _item:Item;
		private var _data:Object;
		public var selectedColor:String="#ffdb02";
		public var upColor:String="#f2a304";
		public var overColor:String="#ffdb02";
		public var downColor:String="#925c14";
		public var disabledColor:String="#747473";
		public var textSize:String="13";
		private var _label:String;
		private var _isShowTips:Boolean;					//是否显示tips
		private var _itemArr:Array ;						//镶嵌宝石的数据
		private var _SFTextField:SFTextField;				//显示　文本
		private var _isFangZhengCuYuan:Boolean;
		public var isDis:Boolean = true;				//是否需要释放
		public var textType:int = 0; 					//文本类型，0物品，1、文本
		private var _mx:Number;							//点击时的鼠标位置
		private var _my:Number;
		public function HItemText()
		{
			super();
			this.touchGroup = true;
			_SFTextField = new SFTextField;  
			_SFTextField.myTouchable = true;
			this.addChild(_SFTextField);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage)
		}
		
		private function onAddToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage)	
			this.addEventListener(TouchEvent.TOUCH, onTouch)	
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage)			
		}
		private function onRemoveFromStage(e:Event):void
		{
			if(isDis)
			{
				this.dispose();
				this.removeEventListener(TouchEvent.TOUCH, onTouch)	
				this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage)	
			}		
		}
		public function myDispose():void
		{
			super.dispose();
			_SFTextField.myDispose();
			this.removeEventListener(TouchEvent.TOUCH, onTouch)	
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage)	
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage)	
		}
		private function onTouch(e:TouchEvent):void
		{
			if(HTopBaseView.getInstance().hasEvent && !isPierce) return; //顶层是否添加UI了
			var leng:int, i:int;
			var touch:Touch = e.getTouch(this);
			if(touch == null)
			{
				if(_isShowTips)
				{
					_isShowTips = false;
					ItemIconTipsManage.getInstance().hideChatItemTips();
				}
				
				if(textType == 0)
					MouseCursorManage.getInstance().showCursor();
				return;
			}
			if(touch.phase == TouchPhase.BEGAN)
			{
				_isStart = true;
				if(textType == 0)
					MouseCursorManage.getInstance().showCursor(9);
				_mx = touch.globalX;
				_my = touch.globalY;
			}
			if(touch.phase == TouchPhase.HOVER)
			{
				if(textType == 0)
					MouseCursorManage.getInstance().showCursor(3);
			}	
			if(touch.phase == TouchPhase.ENDED)
			{
				_isStart = false;
				if(textType == 0)
					MouseCursorManage.getInstance().showCursor(3);
				if(_item)
				{
					var vx:int = Math.abs(touch.globalX - _mx)
					var vy:int = Math.abs(touch.globalY - _my)
					if(vx > 2 || vy > 2)
						return
					if(!_isShowTips)
					{
						_isShowTips = true;
						ItemIconTipsManage.getInstance().showChatItemTips(_item, touch);
					}
					
				}
			}
		}
		
		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
			
			if(String(value.linkListSource) == "colortext")
			{
				textType = 1
				_SFTextField.eventLabel = value.color + textSize + "nn00" + value.src
				this.myHeight = _SFTextField.myHeight;
				return;
			}
			textType = 0;
			if(value.item)
				_item = value.item;
			else
			{
				if(String(value.linkListSource) != "")
				{
					var str:String;
					var subStr:String = String(value.linkListSource).substring(0, 5)
					if(subStr == 'show_' || subStr == 'item_')
					{
						var arr:Array = String(value.linkListSource).split("|");
						str = arr[1];
					}	else 
						str = String(value.linkListSource).substring(5);
					_item = new Item;
					_item.RefreshItemById(str);
				}	else {
					var vector:Array = ChatDataSource.getMyInstance().itemVector;
					_item = vector[int(value.itemIndex)];
					if(!_item || _item.Item_Id != value.qqviplv)
					{
						_item = new Item;
						if(value.qqviplv > 0)
							_item.RefreshItemById(value.qqviplv);
						else
							_item.RefreshItemById('970068');
					}
						
				}
					
			}
			upColor = HCss.QualityColorArray[_item.Item_Quality]
			_label = _item.Item_Name;
			if(arr)
			{
				if(subStr == 'item_')
				{
					//强化、重铸、鉴定不显示超链接
					this.touchable = false;
					_SFTextField.label = "#" + upColor + textSize + _label;
				} 	else {
					this.touchable = true;
					_SFTextField.eventLabel = "#" + upColor + textSize + "nu00" + _label + "#" + upColor + textSize + "nn00" + "*" + arr[2];
				}
			} 	else {
				this.touchable = true;
				_SFTextField.eventLabel = "#" + upColor + textSize + "nu00" + _label
			}
			this.myHeight = _SFTextField.textHeight;
		}

		public function get isFangZhengCuYuan():Boolean
		{
			return _isFangZhengCuYuan;
		}

		public function set isFangZhengCuYuan(value:Boolean):void
		{
			_isFangZhengCuYuan = value;
			_SFTextField.htext.defaultTextFormat.font = "宋体";
			_SFTextField.htext.embedFonts = value;
			_SFTextField.htext.isUseInterFace = value;
		}


	}
}