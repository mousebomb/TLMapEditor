/**
 * Created by gaord on 2016/12/12.
 */
package HLib.DataUtil
{
	import tool.StageFrame;

	/** 剩余时间对象 ； 计算倒计时用的 */
	public class LeftTime
	{
		/** 构建一个剩余时间为val秒的对象 */
		public static function s(val:uint):LeftTime
		{
			var end:LeftTime = new LeftTime();
			end.leftS        = val;
			return end;
		}

		/** 构建一个剩余时间为val毫秒的对象 */
		public static function ms(val:uint):LeftTime
		{
			var end:LeftTime = new LeftTime();
			end.leftMS       = val;
			return end;
		}

		// 内部毫秒计算 0点为FP启动时间
		private var _endTimestamp:uint;

		/** 设置倒计时剩余秒数 */
		public function set leftS(dropTime:uint):void
		{
			_endTimestamp = StageFrame.curTime + dropTime * 1000;
		}

		/** 倒计时当前秒 */
		public function get leftS():uint
		{
			var end:int = _endTimestamp - StageFrame.curTime;
			if (end < 0)end = 0;
			return end / 1000;
		}

		/** 倒计时当前毫秒 */
		public function get leftMS():uint
		{
			var end:int = _endTimestamp - StageFrame.curTime;
			if (end < 0)end = 0;
			return end;
		}

		public function set leftMS(dropTime:uint):void
		{
			_endTimestamp = StageFrame.curTime + dropTime;
		}
	}
}
