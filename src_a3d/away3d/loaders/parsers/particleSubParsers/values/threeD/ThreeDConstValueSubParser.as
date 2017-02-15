package away3d.loaders.parsers.particleSubParsers.values.threeD
{
	import flash.geom.Vector3D;
	
	import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
	import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
	import away3d.loaders.parsers.particleSubParsers.values.setters.threeD.ThreeDConstSetter;
	
	/**
	 * ...
	 */
	public class ThreeDConstValueSubParser extends ValueSubParserBase
	{
		
		public function ThreeDConstValueSubParser(propName:String)
		{
			super(propName, CONST_VALUE);
		}
		
		override public function parseAsync(data:*):void
		{
			super.parseAsync(data);
			_setter = new ThreeDConstSetter(_propName, new Vector3D(_data.x, _data.y, _data.z));
		}
		
		public static function get identifier():*
		{
			return AllIdentifiers.ThreeDConstValueSubParser;
		}
	
	}

}
