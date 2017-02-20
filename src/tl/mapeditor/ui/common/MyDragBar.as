/**
 * Created by Administrator on 2017/2/13.
 */
package tl.mapeditor.ui.common
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	import tool.StageFrame;

	public class MyDragBar extends MySprite
	{
		private var _maxValue:Number  = 100;
		public var halfValue:Number;
		public var isNegative:Boolean = false;
		private var dragRect:Rectangle;
		private var dragSpr:MySprite;
		private var _dragBarPercent:Number;
		private var _isDown:Boolean;
		public function MyDragBar()
		{
			init();
		}

		private function init():void
		{
			var bmd:BitmapData = new Skin_drag_1();
			bm = new Bitmap(bmd);
			this.addChild(bm);
			this.myWidth = bm.width = 200;


			bmd = new Skin_drag_0();

			var bm:Bitmap = new Bitmap(bmd);
			dragSpr = new MySprite();
			dragSpr.mouseEnabled = true;
			this.addChild(dragSpr);
			dragSpr.y = -1;
			dragSpr.x = 90  + 8;
			dragSpr.addChild(bm);
			bm.x = -8;

			dragRect = new Rectangle(0, -1, 200, 0);

		}
		public function onMouseDown(event:MouseEvent):void
		{
			_isDown = true;
			dragSpr.startDrag(true, dragRect );
		}
		public function onMouseUp(event:MouseEvent):void
		{
			dragSpr.stopDrag();
			if(_isDown)
				_dragBarPercent = dragSpr.x / 200;
			_isDown = false;
		}

		public function set dragBarPercent(value:Number):void
		{
			if(value > 1)
				value = 1;
			else if (value < 0)
				value = 0;
			_dragBarPercent = value;
			dragSpr.x = value * 200;
		}
		public function get dragBarPercent():Number
		{
			return _dragBarPercent;
		}

		public function get maxValue():Number
		{
			return _maxValue;
		}

		public function set maxValue(value:Number):void
		{
			_maxValue = value;
			halfValue = value >> 1;
		}
	}
}
