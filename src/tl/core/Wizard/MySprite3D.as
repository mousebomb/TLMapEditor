package tl.core.Wizard
{
	/**
	 * 3D对象基类
	 * @author 李舒浩
	 */	
	import away3d.containers.ObjectContainer3D;
	
	public class MySprite3D extends ObjectContainer3D
	{
		public var isInit:Boolean = false;
		public var myWidth:Number;
		public var myHeight:Number;
		public var myX:Number;
		public var myY:Number;
		
		public function MySprite3D()  
		{  
			super();  
		}
		
	}
}