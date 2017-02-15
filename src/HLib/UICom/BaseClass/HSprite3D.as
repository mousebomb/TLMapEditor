package HLib.UICom.BaseClass
{
	import away3d.containers.ObjectContainer3D;
	
	/**
	 * 3D对象基类
	 * @author 李舒浩
	 */	
	public class HSprite3D extends ObjectContainer3D
	{
		public var isInit:Boolean;
		
		public var myWidth:Number;
		public var myLength:Number;
		public var myHeight:Number;
		
		private var _openMouseEvent:Boolean = false;
		
		public function HSprite3D()  
		{  
			super();
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}