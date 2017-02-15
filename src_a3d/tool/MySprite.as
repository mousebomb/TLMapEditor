package tool
{
	/**
	 * 2DSprite类,继承自Sprite类,提供某些方法方便调用
	 * @author 李舒浩
	 */	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class MySprite extends Sprite
	{
		public var myWidth:Number;
		public var myHeight:Number;
		public var myX:Number;
		public var myY:Number;
		public var isInit:Boolean = false;
		
		private var _graphics:Graphics;
		
		public function MySprite()  {  super();  }
		
		/** 初始化添加指定事件 **/
		public function initAddEvent():void
		{
			//添加到舞台时执行
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//移出舞台时执行
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoverFromStage);
		}
		/** 移除初始化添加的事件 **/
		public function removeAddEvent():void
		{
			//移除到舞台时执行
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//移除舞台时执行
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoverFromStage);
		}
		/**
		 * 绘制矩形
		 * @param $width	: 矩形宽度
		 * @param $hight	: 矩形高度
		 * @param $color	: 矩形颜色
		 * @param $alpha	: 矩形透明值
		 * @param $actionX	: 绘制起点X
		 * @param $actionY	: 绘制起点Y
		 * @param $isClear	: 绘制前是否清除原有样式
		 */		
		public function drawRect($width:Number, $hight:Number, $color:uint, $alpha:Number = 1, $actionX:Number = 0, $actionY:Number = 0, $isClear:Boolean = true):void
		{
			_graphics ||= this.graphics;
			//清空绘制
			if($isClear) _graphics.clear();
			_graphics.beginFill($color, alpha);
			_graphics.drawRect($actionX, $actionY, $width, $hight);
			_graphics.endFill();
		}
		/**
		 * 根据bitmapdata绘制矩形
		 * @param $btmd		: 填充bitmapdata
		 * @param $actionX	: 绘制起点X
		 * @param $actionY	: 绘制起点Y
		 * @param $isClear	: 绘制前是否清除原有样式
		 */		
		public function drawByBtmd($btmd:BitmapData, $actionX:Number = 0, $actionY:Number = 0, $isClear:Boolean = true):void
		{
			_graphics ||= this.graphics;
			//清空绘制
			if($isClear) _graphics.clear();
			_graphics.beginBitmapFill($btmd, null, false);
			_graphics.drawRect($actionX, $actionY, $btmd.width, $btmd.height);
			_graphics.endFill();
		}
		
		private function onAddedToStage(e:Event):void			{  addToStage();  }
		private function onRemoverFromStage(e:Event):void		{  removeFromStage();  }
		/** 初始化添加到场景执行,如果窗口需要每次打开时都执行某个操作可重写此方法 **/
		protected function addToStage():void  {  }
		/** 每次移除出舞台执行,如果窗口需要每次关闭时都执行某个操作可重写此方法 **/
		protected function removeFromStage():void  {  }
		/** 改变舞台大小时调用,需要在舞台改变大小时做处理可重写此方法 **/
		public function onResize():void  {  }
		/** 帧刷新执行方法,需要在每次刷新时可重写此方法 **/
		public function onEnterFrame():void {  }
	}
}