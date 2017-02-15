/**
 * Created by gaord on 2016/12/2.
 */
package away3d.core.precompiled
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import flash.utils.getTimer;

	import tool.StageFrame;

	public class PrecompiledShaders
	{
		public function PrecompiledShaders()
		{

		}


		public static function initFromBinary(ba:ByteArray):void
		{
			var t:int = getTimer();
			var num:int = 0;
			//读取现有shaders
			while (ba.bytesAvailable)
			{
				var key:String = ba.readUTF();
				var vertexByteCode:ByteArray = new ByteArray();
				var fragmentByteCode:ByteArray = new ByteArray();
				vertexByteCode.endian = fragmentByteCode.endian = Endian.LITTLE_ENDIAN;
				ba.readBytes(vertexByteCode, 0, ba.readShort());
				ba.readBytes(fragmentByteCode, 0, ba.readShort());
				// 记录和计数
				vertexDic[key] = vertexByteCode;
				fragmentDic[key] = fragmentByteCode;
				++num;
			}
			trace(StageFrame.renderIdx, "PrecompiledShaders/init  耗时:", getTimer() - t, "读取了预编译数量", num);
		}


		private static var vertexDic:Dictionary = new Dictionary();
		private static var fragmentDic:Dictionary = new Dictionary();


		public static function contains(key:String):Boolean
		{
			return vertexDic[key] != null;
		}

		public static function getVertexShader(key:String):ByteArray
		{
			return vertexDic[key];
		}

		public static function getFragmentShader(key:String):ByteArray
		{
			return fragmentDic[key];
		}
	}
}
