package HLib.UICom.BaseClass
{
	/**
	 *  所有需要调整x,y来修正显示模糊的基类 
	 * @author Administrator
	 * 
	 */	
	public class HXYSprite extends HSprite
	{
		public function HXYSprite()
		{
			super();
		}
		
		override public function set x(value:Number):void
		{
			if(value % 2 != 0)
				value = value - value % 2;
			super.x = value;
		}
		
		override public function set y(value:Number):void
		{
			if(value % 2 != 0)
				value = value - value % 2;
			super.y = value;
		}
		
		
	}
}