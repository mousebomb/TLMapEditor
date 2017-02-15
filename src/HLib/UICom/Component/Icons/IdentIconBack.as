package HLib.UICom.Component.Icons
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import HLib.Tool.HSysClock;
	import HLib.UICom.BaseClass.HSprite;
	
	import Modules.Common.HAssetsManager;
	import Modules.DataSources.ItemSkep;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;

	/**
	 * 装备辨识特效背景 
	 * @author Administrator
	 * 郑利本
	 */	
	public class IdentIconBack extends HSprite 
	{
		private var _skepId:int;
		private var _effectImage:Image;
		private var _isPlay:Boolean;
		private var _timeID:uint;
		private var _scale:Number = 1.2;
		private var _time:Timer;
		public function IdentIconBack()
		{
			init();
		}
		
		private function init():void
		{
			this.touchable = false;
			var texture:Texture = HAssetsManager.getInstance().getMyTexture("itemIconSoruce","icon_null");
			this.myDrawByTexture(texture);
			texture = HAssetsManager.getInstance().getMyTexture("itemIconSoruce","icon_quest");
			_effectImage = new Image(texture);
			_effectImage.pivotX = 24;
			_effectImage.pivotY = 24;
			_effectImage.x = 24;
			_effectImage.y = 24
			this.addChild(_effectImage)
		}
		
		
		private function onAddedToStage(e:Event):void			
		{ 
			if(_isPlay)
				playerEffcet();
		}
		private function onRemoverFromStage(e:Event):void		
		{ 
			stopEffect()
		}

		public function get skepId():int
		{
			return _skepId;
		}

		public function set skepId(value:int):void
		{
			_skepId = value;
			if(_skepId == ItemSkep.SKEP_ID_0)
			{
				_isPlay = true;
				playerEffcet();
				//添加到舞台时执行
				this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				//移出舞台时执行
				this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoverFromStage);
			} 	else {
				_isPlay = false;
				stopEffect();
			}
				
		}
		
		public function playerEffcet():void
		{
			if(!_time)
			{
				_time = new Timer(500);
				_time.addEventListener(TimerEvent.TIMER, onTimer);
			}
			_time.start();
		}
		
		protected function onTimer(event:TimerEvent):void
		{
			changeScale()
		}
		
		private function changeScale():void
		{
			if(_isPlay)
			{
				_effectImage.scaleX = _effectImage.scaleY = _scale;
				if(_scale == 1)
					_scale = 1.2;
				else
					_scale = 1;
			}
		}
		
		public function stopEffect():void
		{
			if(_time)
				_time.stop();
		}

		
	}
}