package away3d.loaders.parsers.particleSubParsers.values.oneD
{
	import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
	import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
	import away3d.loaders.parsers.particleSubParsers.values.setters.oneD.OneDConstSetter;
	
	public class OneDConstValueSubParser extends ValueSubParserBase
	{
		
		public function OneDConstValueSubParser(propName:String)
		{
			super(propName, CONST_VALUE);
		}
		
		override public function parseAsync(data:*):void
		{
			super.parseAsync(data);
			_setter = new OneDConstSetter(_propName, _data.value);
		}
		
		public static function get identifier():*
		{
			return AllIdentifiers.OneDConstValueSubParser;
		}
	
	}

}
