package away3d.loaders.parsers.particleSubParsers.geometries
{
	import away3d.arcane;
	import away3d.core.base.ParticleGeometry;
	import away3d.errors.AbstractMethodError;
	import away3d.loaders.parsers.CompositeParserBase;
	use namespace arcane;
	
	public class GeometrySubParserBase extends CompositeParserBase
	{
		protected var _numParticles:int;
		
		public function GeometrySubParserBase()
		{
			super();
		}
		
		override public function parseAsync(data:*):void
		{
			super.parseAsync(data);
			_numParticles = _data.num;
		}
		
		public function get particleGeometry():ParticleGeometry
		{
			throw(new AbstractMethodError());
		}
	}

}
