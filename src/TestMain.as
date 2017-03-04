/**
 * Created by gaord on 2017/2/5.
 */
package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	import tool.StageFrame;

	public class TestMain extends Sprite
	{
		private var g:Shape;
		private var rotY:Number    = 0;
		private var rect:Rectangle = new Rectangle(100, 100, 200, 100);
		private var point:Point    = new Point(290, 190);
		private var g3:Shape       = new Shape();

		private var tf :TextField;
		public function TestMain()
		{
			super();
			tf = new TextField();
			addChild(tf);

			g = new Shape();
			g.graphics.beginFill(0xff0000, 0.3);
			g.graphics.drawRect(-rect.width / 2, -rect.height / 2, rect.width, rect.height);
			g.graphics.endFill();
			g.x = rect.x + rect.width / 2;
			g.y = rect.y + rect.height / 2;
			addChild(g);

			g = new Shape();
			g.graphics.beginFill(0xff0000, 0.3);
			g.graphics.drawRect(-rect.width / 2, -rect.height / 2, rect.width, rect.height);
			g.graphics.endFill();
			g.x = rect.x + rect.width / 2;
			g.y = rect.y + rect.height / 2;
			addChild(g);

			var g2:Shape = new Shape();
			g2.graphics.beginFill(0x00ff00, 0.5);
			g2.graphics.drawCircle(point.x, point.y, 5);
			g2.graphics.endFill();
			addChild(g2);

			g3.graphics.beginFill(0x000000, 0.5);
			g3.graphics.drawCircle(0,0, 5);
			g3.graphics.endFill();
			addChild(g3);


			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(event:Event):void
		{
			rotY++;
			g.rotation     = rotY;
			//
			//转换到rect的坐标系
			track("rotation="+ rotY);
			tf.text =  calcContainsPoint(point.x,point.y ,rect,rotY).toString();

		}

		public function calcContainsPoint(px:Number, py:Number, rect:Rectangle, rectRot:Number):Boolean
		{
			//把点转换到rect旋转后的坐标系
			//rect rotation=a 相当于 p rotation=-a ;计算p逆向旋转后(设为p2) 是否在原始rect里
			// p 绕rect中心(设为o)为圆心 旋转-a°   op=
			var p:Point = new Point(px ,py);
			var p2:Point = new Point();
			var o:Point = new Point(rect.x+rect.width/2 ,rect.y+rect.height/2 );
			var op:Number = Math.sqrt(Math.pow(p.x - o.x ,2 )+Math.pow(p.y-o.y,2));
			var oldPRadRot :Number = Math.atan2(p.y-o.y , p.x -o.x);
			var radRot:Number = oldPRadRot -rectRot/180 * Math.PI;
			p2.y = o.y + Math.sin(radRot) * op;
			p2.x = o.x + Math.cos(radRot)*op;
			g3.x = p2.x;g3.y=p2.y;
			return rect.containsPoint(p2);
		}


	}
}
