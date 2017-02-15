package HLib.UICom.Component
{
	/**
	 * 提示框窗口类
	 */	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import HLib.Event.ModuleEvent;
	import HLib.IResources.IResourceManager;
	import HLib.Tool.HSysClock;
	import HLib.UICom.BaseClass.HBaseView;
	import HLib.UICom.BaseClass.HSprite;
	import HLib.UICom.BaseClass.HTopBaseView;
	import HLib.UICom.BaseClass.HWindow;
	
	import Modules.Common.HAssetsManager;
	import Modules.Common.HCss;
	import Modules.Common.SourceTypeEvent;
	import Modules.MainFace.MainInterfaceManage;
	import Modules.SFeather.SFTextField;
	
	import feathers.display.Scale9Image;
	
	import starling.events.Event;

	public class HAlertItem extends HWindow
	{
		private var _Text:String="";
		private var _Title:String="";
		private var _Parent:HSprite;
		private var _Data:Object;
		private var _Yeslabel:String="";
		private var _Nolabel:String="";
		private var _CloseTime:int=0;
		private var _ChildEnabled:Boolean=true;
		private var _IsPromptAgain:Boolean=false;
		private var _showAlertAgain:Boolean=false;
		
		private var _HCTF:SFTextField;
		private var _HSBtn_Yes:HSimpleButton=new HSimpleButton();
		private var _HSBtn_No:HSimpleButton=new HSimpleButton();
		private var _Timer:Timer;
		private var _timeid:uint;
		private var _timeTxt:SFTextField;
		private var _delayTime:int;
		private var _clickType:int;
		
		public function HAlertItem()  {  }
		
		/**
		 * @param text			: 提示内容
		 * @param title			: 标题
		 * @param parent		: 父容器对象
		 * @param yeslabel		: 同意按钮
		 * @param nolabel		: 不同意按钮
		 * @param data			: 携带数据
		 * @param isPromptAgain	: 此类提示是否再次提示
		 * @param closeTime		: 自动关闭时间  默认值为0
		 * @param align			: 提示内容对齐方式(默认居中)
		 * @param leading		: 提示内容间距(默认0)
		 * @param isEdge		: 内容是否显示黑边(默认无黑边)
		 * @param isHaveBack	: 是否有背景
		 * @return MyAlertItem
		 */		
		public function show(text:String = "", title:String = "", parent:HSprite = null, yeslabel:String = ""
							, nolabel:String = "", data:Object = null,  isPromptAgain:Boolean=false, closeTime:int=0, childEnabled:Boolean=true
							, align:String = "center", leading:int = 0, isEdge:Boolean = false, isHaveBack:Boolean = false):void			
		{
			_Text=text;
			if(title == "提示")
				_Title="hint";
			else
				_Title=title;
			_Parent=parent;
			_Yeslabel=yeslabel;
			_Nolabel=nolabel;
			_Data=data;
			_IsPromptAgain=isPromptAgain;
			_CloseTime=closeTime;
			_ChildEnabled=childEnabled;
			if(!IsInIt){
			   this.HWindowShow(362,240,_Title,4);
			   this.CloseHSBtn.visible=false;
			   IsInIt=true;
			}
			if(_Parent == HTopBaseView.getInstance())
			{
				_HSBtn_Yes.isPierce = _HSBtn_No.isPierce = true;
				HTopBaseView.getInstance().addClickChildWindow(this);
			}
			else
			{
				_HSBtn_Yes.isPierce = _HSBtn_No.isPierce = false;
				_Parent.addChild(this);
			}
			if(_Parent.myWidth){
				this.x=(_Parent.myWidth-this.myWidth) >> 1;
				this.y=(_Parent.myHeight-this.myHeight) >> 1;
			}
			else{
				this.x=(_Parent.width-this.myWidth) >> 1;
				this.y=(_Parent.height-this.myHeight) >> 1;
			}
			
			var scale9Image:Scale9Image = MainInterfaceManage.getInstance().getBackground3Image(330,105);
			this.addChild(scale9Image);
			scale9Image.x = 16;
			scale9Image.y = 60;
			
			//添加显示内容文本
			_HCTF=new SFTextField;// HTextField(this.myWidth-20,hfont.textHeight + 5,text);
			_HCTF.myWidth = 314;
			_HCTF.wordWrap = true;
			_HCTF.touchable = false;
			_HCTF.label = text;
			this.addChild(_HCTF);
			//_HCTF.x = 24;
			_HCTF.x = this.myWidth - _HCTF.textWidth >> 1;
			_HCTF.y = 60 + (105 - _HCTF.textHeight >> 1);
			if(_Yeslabel!=""){
				if(!MainInterfaceManage.getInstance().isLoadUI){
					_HSBtn_Yes.setTextureSkin(
						HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE , "background/public_btn3_up"),
						HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE , "background/public_btn3_down"),
						HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE , "background/public_btn3_over"),
						HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE , "background/public_btn3_disabled")
					);
				}else{
					_HSBtn_Yes.setDefaultSkin();
				}
				_HSBtn_Yes.init(_Yeslabel,60,30);
				this.addChild(_HSBtn_Yes);
				_HSBtn_Yes.addEventListener(Event.TRIGGERED,onYesClick);
			}
			
			if(_Nolabel!=""){
				if(!MainInterfaceManage.getInstance().isLoadUI){
					_HSBtn_No.setTextureSkin(
						HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE , "background/public_btn3_up"),
						HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE , "background/public_btn3_down"),
						HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE , "background/public_btn3_over"),
						HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE , "background/public_btn3_disabled")
					);
				}else{
					_HSBtn_No.setDefaultSkin();
				}
				_HSBtn_No.init(_Nolabel,60,30);
				this.addChild(_HSBtn_No);
				_HSBtn_No.addEventListener(Event.TRIGGERED,onNoClick);
			}
			_HSBtn_Yes.isclearMOuseCursor = _HSBtn_No.isclearMOuseCursor = true; //事件穿透
			_HSBtn_Yes.y=180;
			if(_Yeslabel!=""&&_Nolabel!=""){
				_HSBtn_Yes.x=(this.myWidth-_HSBtn_Yes.myWidth-_HSBtn_No.myWidth-40)/2;
				_HSBtn_No.x=_HSBtn_Yes.x+_HSBtn_Yes.myWidth+40;
				_HSBtn_No.y=_HSBtn_Yes.y;
			}
			else{
				_HSBtn_Yes.x=(this.myWidth-_HSBtn_Yes.myWidth)/2;
				_HSBtn_No.visible=false;
			}
			
			if(_CloseTime>0){
				
				_timeid = setTimeout(onTimer, _CloseTime * 1000);
			}
			if(_timeTxt)
				_timeTxt.visible = false;
		}
		public function setDelayTimeCloseWindow(time:int, clickType:int):void
		{
			_delayTime = time;
			_clickType = clickType;
			if(!_timeTxt)
			{
				_timeTxt = new SFTextField;
				this.addChild(_timeTxt);
			}	else {
				_timeTxt.visible = false;
			}
			_timeTxt.label = HCss.GeneralColor6 + 13 + '（' + _delayTime + '）';
			
			if(_clickType == 0)
			{
				_timeTxt.x = _HSBtn_Yes.x + (_HSBtn_Yes.myWidth - _timeTxt.textWidth >> 1);
				_timeTxt.y = _HSBtn_Yes.y + 30;
			}	else {
				_timeTxt.x = _HSBtn_No.x + (_HSBtn_No.myWidth - _timeTxt.textWidth >> 1);
				_timeTxt.y = _HSBtn_No.y + 30;
			}
			
			if(time > 0)
				HSysClock.getInstance().addCallBack('alertItemDelayCall', delayCall);
		}
		private function delayCall():void
		{
			_delayTime --;
			_timeTxt.label = HCss.GeneralColor6 + 13 + '（' + _delayTime + '）';
			if(_delayTime < 1)
			{
				HSysClock.getInstance().removeCallBack('alertItemDelayCall');
				onTimer();
				/*if(_clickType == 0)
					onYesClick(null);
				else
					onNoClick(null);*/
			}
		}
		public override function dispose():void
		{
			_HSBtn_No.removeEventListener(Event.TRIGGERED,onNoClick);
			_HSBtn_Yes.removeEventListener(Event.TRIGGERED,onYesClick);
			if(_Timer)
			{
				_Timer.stop();
				_Timer.removeEventListener(TimerEvent.TIMER,onTimer);
				_Timer = null;
			}
			HSysClock.getInstance().removeCallBack('alertItemDelayCall');
			super.dispose();
		}
		private function onYesClick(e:Event):void{
			clearTimeout(_timeid);
			HSysClock.getInstance().removeCallBack('alertItemDelayCall');
			if(_Data!=null){
				this.dispatchEventWith("HAlertYes",false,_Data);
			}
			else{
				this.dispatchEventWith("HAlertYes");
			}
			this.visible=false;
			this.dispatchEventWith("WindowClose");
		}
		
		override public function onClose():void
		{
			clearTimeout(_timeid);
			super.onClose();
		}
		
		private function onNoClick(e:Event):void{
			clearTimeout(_timeid);
			HSysClock.getInstance().removeCallBack('alertItemDelayCall');
			if(_Data!=null){
				this.dispatchEventWith("HAlertNo",false,_Data);
			}
			else{
				this.dispatchEventWith("HAlertNo");
			}
			this.visible=false;
			this.dispatchEventWith("WindowClose");
		}
		private function onTimer(e:TimerEvent=null):void{
			this.visible=false;
			this.dispatchEventWith("WindowClose");
		}
		public function set myParent(value:HSprite):void{
			_Parent=value;
		}
		public function get myParent():HSprite{
			return _Parent;
		}
		
		public function get showAlertAgain():Boolean{
			return _showAlertAgain;
		}
		
		public function get IsPromptAgain():Boolean{
			return _IsPromptAgain;
		}
		private function onSelectedCheckBox(event:Event):void{
			_IsPromptAgain=true;
			_showAlertAgain=true;
		}
		private function onNotSelectedCheckBox(event:Event):void{
			_IsPromptAgain=false;
			_showAlertAgain=false;
		}		

		/** 确定按钮 **/
		public function get HSBtn_Yes():HSimpleButton  {  return _HSBtn_Yes;  }
		/** 取消按钮 **/
		public function get HSBtn_No():HSimpleButton  {  return _HSBtn_No;  }
	}
}