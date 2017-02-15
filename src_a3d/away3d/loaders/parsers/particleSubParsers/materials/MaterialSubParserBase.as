package away3d.loaders.parsers.particleSubParsers.materials
{
	import flash.display.BlendMode;
	import flash.display3D.Context3DCompareMode;
	
	import away3d.arcane;
	import away3d.errors.AbstractMethodError;
	import away3d.loaders.parsers.CompositeParserBase;
	import away3d.materials.MaterialBase;
	
	use namespace arcane;
	
	public class MaterialSubParserBase extends CompositeParserBase
	{
		protected var _bothSide:Boolean;
		protected var _blendMode:String = BlendMode.NORMAL;
		
		public var depthCompareMode:String = Context3DCompareMode.LESS_EQUAL;
		
		public function MaterialSubParserBase()
		{
			super();
		}
		
		override protected function proceedParsing():Boolean
		{
			if (_isFirstParsing)
			{
				_bothSide = _data.bothSide;
				if (_data.blendMode)
				{
					_blendMode = _data.blendMode;
				}
			}
			return super.proceedParsing();
		}
		
		public function get material():MaterialBase
		{
			throw(new AbstractMethodError());
		}
	}

}
