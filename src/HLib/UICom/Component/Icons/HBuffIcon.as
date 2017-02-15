package HLib.UICom.Component.Icons
{
	import Modules.Common.HAssetsManager;
	import Modules.Common.SourceTypeEvent;
	import Modules.DataSources.Buff;
	import Modules.view.roleEquip.ItemIconTipsManage;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;

	public class HBuffIcon extends HIcon
	{
		private var _buff:Buff;
		public var buffType:int = 1;						//图标类型1、小图标，2、大图标，其它、普通图标
		public var showTips:Boolean;						//是否显示tips
		public var showTipsTime:Boolean = true;     //是否显示tips上的时间
		public function HBuffIcon()
		{
			super();
		}

		override public function init():void
		{
			if(buffType == 1)
			{
				this.myBackTexture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE,"skillIcon/buff_icon_00");
			}
			super.init();
			this.buff = _buff;
			
		}
		
		public function get buff():Buff
		{
			return _buff;
		}

		public function set buff(value:Buff):void
		{
			_buff = value;
			if(!value)
				super.data = null;
			else {
				
				if(buffType == 1)
					super.data = { Item_IconPack:SourceTypeEvent.MAIN_INTERFACE_SOURCE, Item_IconName:_buff.className };
				else
					super.data = { Item_IconPack:SourceTypeEvent.MAIN_INTERFACE_SOURCE, Item_IconName:_buff.BigClassName };
			}
		}
		
		override protected function onMouseEvent(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch)
			{
				showTips = true;
				ItemIconTipsManage.getInstance().showBuffTips(_buff,showTipsTime,touch.globalX + 30, touch.globalY + 10);
			}	else {
				if(showTips)
				{
					showTips = false;
					ItemIconTipsManage.getInstance().hideItemTips();	
				}
				
			}
		}
	}
}