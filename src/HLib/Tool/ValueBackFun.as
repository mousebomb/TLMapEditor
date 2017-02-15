package HLib.Tool
{
	public class ValueBackFun extends CallBackFun
	{
		private var _value:*;
		
		public function ValueBackFun()
		{
			super();
		}

		public function get value():*
		{
			return _value;
		}

		public function set value(value:*):void
		{
			_value = value;
			
			exec();
		}
	}
}