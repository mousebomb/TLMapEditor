package HLib.UICom.BaseClass
{
	import HLib.UICom.Component.HSimpleButton;
	
	import Modules.Common.HCss;
	import Modules.Common.SourceTypeEvent;
	import Modules.SFeather.SFTextField;
	
	import starling.events.Event;
	import starling.textures.Texture;

	/**
	 * 引导 图 
	 * @author Administrator
	 * 郑利本
	 */
	public class GuideWindow extends HSprite
	{
		private var _btn:HSimpleButton;
		private var _timeTxt:SFTextField;
		public var delayCall:Function;
		private var _btnClose:HSimpleButton;
		public function GuideWindow()
		{
			
		}
		
		public function init():void
		{
			if(_btn) return;
			_btn = new HSimpleButton;
			_btn.setAssetsSkin(SourceTypeEvent.SOURCE_ACTIVITYICON_0, 'guide_btn');
			_btn.init('');
			this.addChild(_btn);
			_btn.x = this.myWidth - _btn.myWidth >> 1;
			_btn.y = 420;
			_btn.addEventListener(Event.TRIGGERED, onClickBtn);
			_timeTxt = new SFTextField;
			this.addChild(_timeTxt);
			_timeTxt.x = _btn.x + _btn.myWidth;
			_timeTxt.y = _btn.y + (_btn.myHeight - 16 >> 1);
			
			_btnClose = new HSimpleButton;
			_btnClose.setAssetsSkin(SourceTypeEvent.SOURCE_ACTIVITYICON_0, 'guide_close');
			_btnClose.init();
			this.addChild(_btnClose);
			_btnClose.x = this.myWidth - _btnClose.myWidth - 25;
			_btnClose.y = 75;
			_btnClose.addEventListener(Event.TRIGGERED, onClickBtn);
		}
		/**更新背景*/
		public function showBg(texture:Texture):void
		{
			this.myDrawByTexture(texture);
		}
		/**刷新倒计时文本*/
		public function updateTimeText(value:int):void
		{
			_timeTxt.label = HCss.GeneralColor6 + 13 + '(' + value + ')';
		}
		
		/**点击关闭*/
		public function onClickBtn(event:Event=null):void
		{
			if(event.currentTarget == _btn)
				delayCall(true);
			else
				delayCall(false);
		}
	}
}