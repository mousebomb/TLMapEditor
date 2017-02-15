package HLib.Tool
{
	import flash.utils.getTimer;
	
	import HLib.Net.Socket.Connect;
	import HLib.UICom.BaseClass.HBaseView;
	import HLib.UICom.Component.HSimpleButton;
	
	import Modules.MainFace.MainInterfaceManage;
	import Modules.SFeather.SFScrollBar;
	import Modules.SFeather.SFTextField;
	
	import feathers.controls.ScrollBar;
	import feathers.controls.ScrollContainer;
	import feathers.controls.ScrollText;
	import feathers.display.Scale9Image;
	import feathers.layout.AnchorLayoutData;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.Color;
	
	public class HLog extends Sprite
	{
		private static var MyInstance:HLog;
		private var _isInit:Boolean;			//是否初始化完成
		private var _Count:int;				//文本显示行数控制器
		private var _IsApp:Boolean = true;	//是否要更新文本
		private var _loadStr:String;			//显示加载6文本
		private var _currentStr:String = ""; 	//显示当前
		private var _msgStr:String = "";		//显示消息计数
		public var allBytesLoaded:Number = 0; //所有加载总量
		private var _scrollText:ScrollText;
		private var _parent:Object;
		private var _btnAll:HSimpleButton;
		private var _btnLoad:HSimpleButton;
		private var _btnMsg:HSimpleButton;
		private var _btnCurrent:HSimpleButton;
		private var _showCurrent:Boolean;		//显示当前
		private var _courrentBtn:HSimpleButton;
		private var _load:int;
		private var _msg:int;
		private var _logArr:Array = [];
		private var _loadArr:Array = [];
		private var _msgArr:Array = [];
		private var _fowText:SFTextField;
		private var _flow:String = "流量：";
		private var _time:String = "";
		public function HLog()
		{
			if( MyInstance ){
				throw new Error ("单例只能实例化一次,请用 getInstance() 取实例。");
			}
			MyInstance=this;
		}
		public static function getInstance() :HLog 
		{
			if ( MyInstance == null ) 
			{				
				MyInstance = new HLog();
			}
			return MyInstance;
		}
		public function InIt():void
		{
			if(MainInterfaceManage.getInstance().isLoadUI)
			{
				var scale:Scale9Image = MainInterfaceManage.getInstance().getBackground1Image(360,440);
				this.addChild(scale);
			}	else {
				var que:Quad = new Quad(365,430);
				que.color = Color.GRAY;
				this.addChild(que);
			}
			
			this._scrollText = new ScrollText();
			_scrollText.horizontalScrollBarFactory = function ():SFScrollBar{
				var scrollBar:SFScrollBar = new SFScrollBar;
				scrollBar.vertical = true;
				scrollBar.scrollType = 1;
				scrollBar.direction = ScrollBar.DIRECTION_VERTICAL;
				scrollBar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_SINGLE;
				return scrollBar;
			};
			_scrollText.verticalScrollBarFactory = function ():SFScrollBar{
				var scrollBar:SFScrollBar = new SFScrollBar;
				scrollBar.vertical = true;
				scrollBar.scrollType = 1;
				scrollBar.direction = ScrollBar.DIRECTION_VERTICAL;
				scrollBar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_SINGLE;
				return scrollBar;
			};
			_scrollText.interactionMode = ScrollContainer.INTERACTION_MODE_MOUSE;
			_scrollText.scrollBarDisplayMode = ScrollContainer.SCROLL_BAR_DISPLAY_MODE_FIXED;
			this._scrollText.width = 350;
			this._scrollText.height = 360;
			this._scrollText.text = "" 
			this._scrollText.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			this.addChild(_scrollText);
			_scrollText.y = 40;
			_scrollText.x = 5;
			_scrollText.background = true;
			_scrollText.backgroundColor = Color.GRAY;
			
			
			_btnAll = new HSimpleButton;
			_btnAll.setDefaultSkin();
			_btnAll.init("显示所有");
			_btnAll.width = 80;
			this.addChild(_btnAll);
			_btnAll.addEventListener(Event.TRIGGERED, clickBtn);
			_btnAll.x = 5;
			
			_btnLoad = new HSimpleButton;
			_btnLoad.setDefaultSkin();
			_btnLoad.init("显示加载");
			_btnLoad.width = 80;
			this.addChild(_btnLoad);
			_btnLoad.addEventListener(Event.TRIGGERED, clickBtn);
			_btnLoad.x = 95;
			
			_btnMsg = new HSimpleButton;
			_btnMsg.setDefaultSkin();
			_btnMsg.init("显示消息");
			_btnMsg.width = 80;
			this.addChild(_btnMsg);
			_btnMsg.addEventListener(Event.TRIGGERED, clickBtn);
			_btnMsg.x = 185;
			
			_btnCurrent = new HSimpleButton;
			_btnCurrent.setDefaultSkin();
			_btnCurrent.init("显示当前");
			_btnCurrent.width = 80;
			this.addChild(_btnCurrent);
			_btnCurrent.addEventListener(Event.TRIGGERED, clickBtn);
			_btnCurrent.x = 275;
			_btnAll.y = _btnLoad.y = _btnMsg.y = _btnCurrent.y = 5;
			_courrentBtn = _btnCurrent;
			_isInit = true;
			_fowText = new SFTextField;
			_fowText.myWidth = 300;
			_fowText.y = 400;
			_fowText.x = 5;
			_fowText.label = '0xff0000当前流量';
			this.addChild(_fowText);
		}
		
		private function clickBtn(e:Event):void
		{
			_courrentBtn.selected = false;
			var text:String = "", i:int, leng:int;
			var btn:HSimpleButton = e.target as HSimpleButton;
			_showCurrent = false;
			switch(btn)
			{
				case _btnAll :
					leng = _logArr.length;
					if(leng == 0)
						text = _currentStr;
					else {
						for(i=0; i<leng; i++)
						{
							text += _logArr[i];
						}	
					}
					
					_courrentBtn = _btnAll;
					break;
				case _btnLoad :
					leng = _loadArr.length
					if(leng == 0)
						text = _loadStr;
					else {
						for(i=0; i<leng; i++)
						{
							text += _loadArr[i];
						}
					}
					_courrentBtn = _btnLoad;
					break;
				case _btnMsg :
					leng = _msgArr.length
					if(leng == 0)
						text = _msgStr;
					else {
						for(i=0; i<leng; i++)
						{
							text += _msgArr[i];
						}
					}
					_courrentBtn = _btnMsg;
					break;
				default :
					_showCurrent = true;
					text = _currentStr;
					_courrentBtn = _btnCurrent;
					break;
			}
			_courrentBtn.selected = true;
			_scrollText.text = text;
			_scrollText.verticalScrollPosition = _scrollText.maxVerticalScrollPosition;
		}
		
		public function appMsg(value:String):void
		{return
			if(value)
			{
				var str:String
				_currentStr += value + "\n";
				_Count++;
				if(_Count>50){
					str = _currentStr
					_logArr.push(str);
					_currentStr = value + "\n";
					_Count=0;
				}
				str = value.substr(0,4);
				if(str == "Load" || str == "load" || str == "reLo")
				{
					_load ++;
					_loadStr += value + "\n";
					if(_load > 50)
					{
						str = _loadStr;
						_loadArr.push(str);
						_loadStr = value + "\n";
						_load = 0;
					}
				}	else if(str == "Rece") {
					_msg ++;
					_msgStr += value + "\n";
					if(_msg == 0)
					{
						_msgArr.push(_msgStr);
					}
					if(_msg > 50)
					{
						str = _msgStr;
						_msgArr.push(str);
						_msg = 0;
						_msgStr = value + "\n";
					}
				}
			}
			
			if(!_isInit || !_showCurrent) return;
			_scrollText.text = _currentStr;
			_scrollText.verticalScrollPosition = _scrollText.maxVerticalScrollPosition;
		}
		public function addLog(value:String):void
		{return
			if(value)
			{
				var str:String
				_currentStr += value + "\n";
				_Count++;
				if(_Count>50){
					str = _currentStr
					_logArr.push(str);
					_currentStr = value + "\n";
					_Count=0;
				}
				str = value.substr(0,4);
				if(str == "Load" || str == "reLo")
				{
					_load ++;
					_loadStr += value + "\n";
					if(_load > 50)
					{
						str = _loadStr;
						_loadArr.push(str);
						_loadStr = value + "\n";
						_load = 0;
					}
				}	else if(str == "Rece") {
					_msg ++;
					_msgStr += value + "\n";
					if(_msg > 50)
					{
						str = _msgStr;
						_msgArr.push(str);
						_msg = 0;
						_msgStr = value + "\n";
					}
				}
			}
			if(!_isInit || !_showCurrent) return;
			_scrollText.text = _currentStr;
			_scrollText.verticalScrollPosition = _scrollText.maxVerticalScrollPosition;
		}
		public function addPropertyCount(value:String):void
		{
			if(value)
			{
				_currentStr += value + "\n";
			}
			if(!_isInit || !_showCurrent) return;
			_scrollText.text = _currentStr;
			_scrollText.verticalScrollPosition = _scrollText.maxVerticalScrollPosition;
		}
		public function removeFromStage():void
		{
			if(this.parent)
			{
				_parent = this.parent;
				_parent.removeChild(this);
			}
		}
		
		
		private var _curByte:uint;
		private var _oldBytes:uint;
		private var _maxByte:uint;
		private var _tmpTime:uint;
		private function onRefeshTxt():void
		{
			var tmpT1:uint = (getTimer() - _tmpTime) / 1000;
//			if (tmpT1 > 1000)
			{
				var tmpTotalFlow:uint = Connect.getInstance().totalFlow;
				
				_tmpTime = getTimer();
				
				_curByte = tmpTotalFlow - _oldBytes;
				_oldBytes = tmpTotalFlow;
				_maxByte = Math.max(_curByte, _maxByte);
				_flow = Math.floor(_curByte / tmpT1 ) + ":" + Math.floor(_maxByte / tmpT1 );
			}
		}
		
		
		public function showFlow():void
		{
			onRefeshTxt();
		}
		
		public function showTime(str:String=''):void
		{
			_fowText.label = _time + '\n#33669912'+ _flow + str ;
			_time = '#33669912'+ _flow + str ;
		}
		public function addToStage():void
		{
			if(_parent)
				_parent.addChild(this);
			else if(this.parent == null){
				this.InIt();
				HBaseView.getInstance().addChild(this);
				this.y = 110;
			};
			_scrollText.text = _currentStr;
			_showCurrent = true;
			_courrentBtn.selected = false;
			_courrentBtn = _btnCurrent;
			_courrentBtn.selected = true;
			_scrollText.verticalScrollPosition = _scrollText.maxVerticalScrollPosition;
		}
	}
}

