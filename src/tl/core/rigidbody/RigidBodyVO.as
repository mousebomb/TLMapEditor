/**
 * Created by gaord on 2017/2/4.
 */
package tl.core.rigidbody
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	/** 刚体 */
	public class RigidBodyVO
	{
		/** 坐标 采用flash显示坐标单位 */
		public var y:Number = 0.0;
		public var rect:Rectangle = new Rectangle(0,0,100,100);
		public var rotationY:Number;

		public function setXZ(x:Number, z:Number):void
		{
			rect.x = x- rect.width/2;
			rect.y = z- rect.height/2;
		}
		public function setXZWD(x:Number , z:Number,y:Number, w:Number, d:Number , h:Number  = 20.0):void
		{
			rect.x      = x - w / 2;
			rect.width  = w;
			rect.y      = z - d / 2;
			rect.height = d;
			this.y      = y + h / 2;
		}

		public function setRotation(yRotation:Number):void
		{
			rotationY = yRotation;
		}

		public function contains(x:Number, z:Number):Boolean
		{
			//把点转换到rect旋转后的坐标系
			//rect rotation=a 相当于 p rotation=-a ;计算p逆向旋转后(设为p2) 是否在原始rect里
			// p 绕rect中心(设为o)为圆心 旋转-a°   op=
			var p:Point = new Point(x ,z);
			var p2:Point = new Point();
			var o:Point = new Point(rect.x+rect.width/2 ,rect.y+rect.height/2 );
			var op:Number = Math.sqrt(Math.pow(p.x - o.x ,2 )+Math.pow(p.y-o.y,2));
			var oldPRadRot :Number = Math.atan2(p.y-o.y , p.x -o.x);
			var radRot:Number = oldPRadRot -rotationY/180 * Math.PI;
			p2.y = o.y + Math.sin(radRot) * op;
			p2.x = o.x + Math.cos(radRot)*op;
			return rect.containsPoint(p2);
		}

		/** 导出保存用的数据 */
		public function exportToByteArray( ba :ByteArray):void
		{
			ba.writeFloat(y);
			ba.writeShort(rect.x);
			ba.writeShort(rect.y);
			ba.writeShort(rect.width);
			ba.writeShort(rect.height);
			ba.writeShort(rotationY);
		}

		/** 从bin文件读取
		 * @param version 存档文件的版本 */
		public function readFromByteArray(ba:ByteArray,version:uint):void
		{
			y = ba.readFloat();
			rect .x = ba.readShort();
			rect .y = ba.readShort();
			rect .width = ba.readShort();
			rect .height = ba.readShort();
			rotationY = ba.readShort();
		}

	}
}
