package away3d.debug
{
	
	/** Class for emmiting debuging messages, warnings and errors */
	public class Debug
	{
		public static var active:Boolean = false;
		public static var warningsAsErrors:Boolean = false;
		
		public static function clear():void
		{
		}
		
		public static function delimiter():void
		{
		}
		
		public static function trace(message:Object):void
		{
			if (active)
				dotrace(message);
		}
		
		public static function warning(message:Object):void
		{
			if (warningsAsErrors) {
				error(message);
				return;
			}
			trace("WARNING: " + message);
		}
		
		public static function error(message:Object):void
		{
			trace("ERROR: " + message);
			throw new Error(message);
		}


		/**统计当前的顶点数据对象使用数量 VertexBuffer3D 对象
		 * FP上限 4096 */
		public static var vertexBufferNum:uint = 0 ;

		/** 统计当前纹理使用情况
		 * 上限4096
		 * */
		public static var texturesNum : uint  = 0;

	}
}

/**
 * @private
 */
function dotrace(message:Object):void
{
	trace(message);
}
