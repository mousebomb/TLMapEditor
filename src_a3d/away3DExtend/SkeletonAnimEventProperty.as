package away3DExtend
{
	/**
	 * 骨骼动画指定时间派发事件类
	 * @author 李舒浩
	 */	
	public class SkeletonAnimEventProperty
	{
		private var _animName:String;
		private var _occurTime:Number;
		private var _customName:String;
		private var _initOccurTime:Number;//初始触发时间
	
		/** 是否派发事件完成 **/
		public var isDispatchComplete:Boolean = false;
		/**
		 * 构造函数
		 * @param animName		: 动作 类型
		 * @param occurTime		: 触发时间
		 * @param customName	: 派发事件类型
		 */		
		public function SkeletonAnimEventProperty(animName:String, occurTime:Number, customName:String)
		{
			_animName = animName;
			_initOccurTime = _occurTime = occurTime;
			_customName = customName;
		}
		/** 指定动作名 **/
		public function get animName():String  {  return _animName;  }
		/** 派发事件类型 **/
		public function get customName():String  {  return _customName;  }
		/** 触发时间(毫秒) **/
		public function set occurTime(value:Number):void  {  _occurTime = value;  }
		public function get occurTime():Number  {  return _occurTime;  }
		/** 初始触发时间 **/
		public function get initOccurTime():Number  {  return _initOccurTime;  }

	}
}