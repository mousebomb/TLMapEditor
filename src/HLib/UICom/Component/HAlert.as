package HLib.UICom.Component
{
	/**
	 * 提示框类(用于需要弹出多个提示框时用到)
	 */		
	import flash.utils.setTimeout;
	
	import HLib.UICom.BaseClass.HSprite;
	import HLib.UICom.BaseClass.HTopBaseView;
	
	import Modules.DataSources.ChatDataSource;
	import Modules.MainFace.FastSpeedWindow;
	import Modules.MainFace.MouseCursorManage;
	
	import starling.core.Starling;
	import starling.events.Event;

	public class HAlert
	{				
		private static var _hAlertItemAry:Array = [];
		
		public function HAlert()
		{
		}
		/**
		 * @param text		提示内容
		 * @param title		标题
		 * @param parent	父容器对象
		 * @param data		携带数据
		 * @param yeslabel	同意按钮
		 * @param nolabel	不同意按钮
		 * @param autoClose	是否为自动关闭  默认值为true 10秒自动关闭 
		 * @param align		: 提示内容对齐方式(默认居中)
		 * @param leading	: 提示内容间距(默认0)
		 * @param isEdge	: 内容是否显示黑边(默认无黑边)
		 * @param isHaveBg	: 是否有背景
		 * @return MyAlertItem
		 */		
		public static function show(	 text:String = "",
										 title:String = "",
										 parent:HSprite = null,
										 yeslabel:String = "", 
										 nolabel:String = "",
										 data:Object = null,
										 isPromptAgain:Boolean=false,
										 closeTime:int=0,
										 childEnabled:Boolean=true
										 ,align:String = "center"
										 ,leading:int = 0
										 ,isEdge:Boolean = false
										 ,isHaveBg:Boolean = false):HAlertItem
			
		{
			//如果提示硬件加速 则关闭硬件加速提示窗口
			if(FastSpeedWindow.getMyInstance().parent){
				FastSpeedWindow.getMyInstance().removePoint();
			}
			var alert:HAlertItem = new HAlertItem();
			if(ChatDataSource.getMyInstance().isDisposed || Starling.context.driverInfo == "Disposed")  return alert;
			alert.show(text,title,parent,yeslabel,nolabel,data,isPromptAgain,closeTime,childEnabled,align,leading,isEdge,isHaveBg);
			alert.addEventListener("WindowClose",onMyClose);
			_hAlertItemAry.push(alert);
			return alert;
		}
		
		private static function onMyClose(e:Event):void
		{
			var alert:HAlertItem=e.target as HAlertItem;
			if(alert)
			{
				var index:int = _hAlertItemAry.indexOf(alert);
				if(index > -1)
					_hAlertItemAry.splice(index, 1);
				closeHAlertItem(alert);
			}
		}
		
		private static function closeHAlertItem(alert:HAlertItem):void{
			if(!alert) return;
			alert.removeEventListener("WindowClose", onMyClose);
			if(!alert.parent) return;
			if(alert.parent == HTopBaseView.getInstance())
				HTopBaseView.getInstance().removeClickChildWindow(alert);
			else if(alert.parent)
				alert.parent.removeChild(alert);
			alert.dispose();
			setTimeout(function ():void{
				HTopBaseView.getInstance().hasEvent = false;
				MouseCursorManage.getInstance().showCursor();
			}, 30);
			alert=null;
		}
		
		public static function disposeAllHAlertItem():void{
			for( var i:int = 0; i < _hAlertItemAry.length; i++ ){
				_hAlertItemAry[i].HSBtn_No.dispatchEventWith(Event.TRIGGERED);
			}
			_hAlertItemAry.length = 0;
		}
	}
}