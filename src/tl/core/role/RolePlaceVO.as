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


		/** 导出保存用的数据 */
		public function exportToByteArray( ba :ByteArray):void
		{
			ba.writeUTF(wizardId);
			ba.writeFloat(x);
			ba.writeFloat(y);
			ba.writeFloat(z);
		}

		public function readFromByteArray(ba:ByteArray):void
		{
			wizardId = ba.readUTF();
			x = ba.readFloat();
			y = ba.readFloat();
			z = ba.readFloat();
		}

	}
}
