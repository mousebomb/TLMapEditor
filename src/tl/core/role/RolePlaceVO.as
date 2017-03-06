/**
 * Created by gaord on 2017/2/20.
 */
package tl.core.role
{
	import flash.utils.ByteArray;


	/** 地图中 预先摆放好的模型数据 */
	public class RolePlaceVO
	{

		/** 表id */
		public var wizardId: String ;

		/** 放置于的位置 */
		public var x:Number;
		public var y:Number;
		public var z:Number;

		/** 旋转角度 */
		public var rotationY:Number;

		/**[编辑器使用] 模型 */
		public var wizard:Role;

		public function toString():String
		{
			if(wizard)
				return wizard.vo.csvVO.Name +"  x: "+x.toFixed()+", z: "+z.toFixed() +", y: "+y.toFixed();
			return "[RolePlaceVO ID"+wizardId+"@x"+x+",z"+z +",y"+y+"]";
		}

		/** 导出保存用的数据 */
		public function exportToByteArray( ba :ByteArray):void
		{
			ba.writeUTF(wizardId);
			ba.writeInt(x);
			ba.writeInt(y);
			ba.writeInt(z);
			ba.writeShort(rotationY);

		}

		public function readFromByteArray(ba:ByteArray):void
		{
			wizardId = ba.readUTF();
			x = ba.readInt();
			y = ba.readInt();
			z = ba.readInt();
			rotationY = ba.readShort();

		}

	}
}
