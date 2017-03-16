/**
 * Created by gaord on 2017/2/4.
 */
package tl.core.rigidbody
{
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;

	import tool.StageFrame;

	/** 刚体
	 * 3.16改动：
	 * 刚体为一个空间内3D的面，这个面可以对高度图产生额外承托
	 * 存档时保存一份合并好的高度
	 * */
	public class RigidBodyVO
	{
		// #pragma mark --  存储的字段  ------------------------------------------------------------
		/** 坐标 采用flash显示坐标单位 */
		public var rect:Rectangle   = new Rectangle(0,0,100,100);

		public var y:Number         = 0.0;
		public var rotationY:Number = 0.0;
		public var rotationX:Number = 0.0;

		// #pragma mark --  运行时用的字段  ------------------------------------------------------------
		/** rotationX施加上之后产生的水平面投影rect 用于快速判断是否落在选区 */
		public var touYingRect:Rectangle = new Rectangle();
		//

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

		/** 设置坡度 */
		public function setRotationX(xRotation:Number):void
		{
			rotationX = xRotation;
		}

		/** 根据参数更正mtx  用于判定 */
		public function validate():void
		{
			// rotationX作用后 height会变小；正好是cos(rotationX)
			touYingRect.width = rect.width;
			touYingRect.x = rect.x;
			touYingRect.height = rect.height * Math.cos(rotationX * Math.PI / 180);
			touYingRect.y = rect.y + (rect.height-touYingRect.height)/2;
		}

		/** 获得一个坐标处 刚体额外提供的高度 */
		public function provideY4XZ(x:Number, z:Number):Number
		{
			//把点转换到rect旋转后的坐标系
			//rect rotation=a 相当于 p rotation=-a ;计算p逆向旋转后(设为p2) 是否在原始rect里 (但是因为游戏坐标系z为负，所以旋转角度正好相反，所以rotationY取反)
			// p 绕rect中心(设为o)为圆心 旋转-a°   op=
			var p:Point = new Point(x ,z);
			var p2:Point = new Point();
			var o:Point = new Point(rect.x+rect.width/2 ,rect.y+rect.height/2 );
			var op:Number = Math.sqrt(Math.pow(p.x - o.x ,2 )+Math.pow(p.y-o.y,2));
			var oldPRadRot :Number = Math.atan2(p.y-o.y , p.x -o.x);
			var radRot:Number = oldPRadRot +rotationY/180 * Math.PI;//rotationY取反
			p2.y = o.y + Math.sin(radRot) * op;
			p2.x = o.x + Math.cos(radRot) * op;
			if(touYingRect.containsPoint(p2))
			{
				var radRotationX:Number = rotationX / 180*Math.PI;
				// 计算此处斜坡的刚体高度值，只看p2.y 对应哪一段;
				// op.y 就是要从中心往上找的y投影坐标 ， 结果高度= cotan(rotationX)*y投影偏移 + 刚体中心y
				return (o.y-p2.y) * Math.tan(radRotationX) + y;
			}
			return -Infinity;
		}

		public function clone():RigidBodyVO
		{
			var end:RigidBodyVO = new RigidBodyVO();
			end.y           = y;
			end.rect.x      = rect.x;
			end.rect.y      = rect.y;
			end.rect.width  = rect.width;
			end.rect.height = rect.height;
			end.rotationY   = rotationY;
			end.rotationX   = rotationX;
			return end;
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
			ba.writeShort(rotationX);
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
			if(version>=6)
				rotationX = ba.readShort();
			else
				rotationX =0.0;
			if(isNaN(rotationX)) rotationX=0.0;
			validate();
		}

	}
}
