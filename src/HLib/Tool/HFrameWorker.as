package HLib.Tool
{
	/**
	 * HFrameWorker 逐帧工作机
	 * @authro 黄栋 
	 * 
	 * 用法：
	 * 		_HFrameWorker:HFrameWorker=new HFrameWorker();
	 *      _HFrameWorker.InIt(stage);
	 *      _HFrameWorker.addFunction(fun);
	 *      _HFrameWorker.removeFunction(fun);
	 *      _HFrameWorker.start();
	 *      _HFrameWorker.stop(); 
	 *      _HFrameWorker.clear(); 
	 * 属性与方法:
	 * 		addFunction		: 添加执行方法
	 * 		removeFunction	: 移除执行方法
	 * 		clear			: 清除方法
	 *  	start			: 执行过程中开启
	 *  	stop			: 执行过程中停卡
	 *   	frameFra		: 设置执行的倍速
	 */	
	import HLib.MyClientNamespace;
	
	import tool.FrameWorkerBase;
	
	use namespace MyClientNamespace;
	
	public class HFrameWorker extends FrameWorkerBase
	{	
		private var _isInit:Boolean = false;
		
		public function HFrameWorker()
		{
			super();
		}
		
		public function InIt(name:String):void
		{
			if(_isInit) 
			{
				return;
			}
			_isInit = true;
		}
		
		/** 添加实时执行的方法 **/
		public function addFunction(value:Function):void
		{
			if( value == null ) 
			{
				return;
			}
			if( value == null )
			{
				trace("参数传入类型不是Function, 请检查代码!");
				return;
			}
			
			addFun_1(value);
		}
		
		/** 移除实时执行的方法 **/
		public function removeFunction(value:Function):void
		{
			if( value == null )
			{
				return;
			}
			
			removeFun_1(value);
		}
		
		/**
		 * 获取当前方法是否已经添加
		 * @param fun
		 */		
		public function hasFunction(value:Function):Boolean
		{
			return hasFun(value);
		}
		
		/**清除所有 **/
		public function clear():void
		{
			clearVec();
		}
	}
}