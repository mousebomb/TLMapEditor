package tl.frameworks.service.bombloader
{
	/**
	 * @author rhett
	 */
	public class CallbackVO
	{
		public var fun:Function;
		public var mark:*;

		public function CallbackVO(fun:Function, mark:* )
		{
			this.fun = fun;
			this.mark = mark;
		}
	}
}
