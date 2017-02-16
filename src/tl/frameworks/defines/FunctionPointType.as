/**
 * Created by gaord on 2017/2/16.
 */
package tl.frameworks.defines
{
	public class FunctionPointType
	{
		/**出生点*/
		public static const START :int = 1;
		/**跳转点*/
		public static const JUMP :int = 2;
		/**特殊点*/
		public static const SPECIAL :int = 3;
		/**预留点一*/
		public static const EXTRA_1 :int = 4;
		/**预留点二'*/
		public static const EXTRA_2 :int = 5;


		public static const LABEL :Array = ['','出生点', '跳转点', '特殊点', '预留点一', '预留点二'];

		public static const COLOR :Array = [0x0,0x66FFCCCC,0x66CCFFCC,0x66CCCCFF,0x660000CC,0x6600CCCC];
	}
}
