/**
 * Created by Administrator on 2017/2/13.
 */
package tl.mapeditor.ui.common
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class MyDragBar extends MySprite
	{
		public var dragSpr:MySprite;
		public var maxValue:Number = 100;
		private var dragRect:Rectangle;
		public function MyDragBar()
		{
			init();
		}

		private function init():void
		{
			var bmd:BitmapData = new Skin_drag_1();
			this.drawByBtmd(bmd);

			bmd = new Skin_drag_0();

			var bm:Bitmap = new Bitmap(bmd)
			dragSpr = new MySprite();
			dragSpr.mouseEnabled = true;
			this.addChild(dragSpr);
			dragSpr.y = -1;
			dragSpr.x = 90  + 8;
			dragSpr.addChild(bm);
			bm.x = -8;

			dragRect = new Rectangle(8, -1, 269, 0);

		}
		public function set dragSprX(value:Number):void
		{
			dragSpr.x = value / maxValue * 269 + 8;
		}
		public function onMouseDown(event:MouseEvent):void
		{
			dragSpr.startDrag(true, dragRect );
		}
		public function onMouseUp(event:MouseEvent):void
		{
			dragSpr.stopDrag();
		}

		public function get dragBarPercent():Number
		{
			var num:Number;
			var percent:Number = (dragSpr.x - 8) / 269;
			if(maxValue > 1)
				num = Number((percent * maxValue).toFixed(0));
			else
				num = Number((percent * maxValue).toFixed(2));
			if(num < maxValue * 0.01)
			{
				num = maxValue * 0.01;
			}
			return num;
		}
	}
}
