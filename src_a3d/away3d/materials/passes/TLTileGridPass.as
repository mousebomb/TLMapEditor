package away3d.materials.passes
{
	import away3d.arcane;
	import away3d.cameras.Camera3D;
	import away3d.core.base.IRenderable;
	import away3d.core.managers.RTTBufferManager;
	import away3d.core.managers.Stage3DProxy;

	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.geom.Matrix3D;
	
	use namespace arcane;

	/**
	 * SegmentPass is a material pass that draws wireframe segments.
	 */
	public class TLTileGridPass extends MaterialPassBase
	{

		private var _constants:Vector.<Number> = new Vector.<Number>(4, true);
		private var _thickness:Number;


		private var _matrix : Matrix3D = new Matrix3D();

		public function TLTileGridPass(thickness:Number)
		{
			_thickness = thickness;
			_constants[1] = 1/255;
			
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		arcane override function getVertexCode():String
		{
			return "m44 vt0,va0,vc0\n" +
					"mov op, vt0\n"+
					"mov v0, vt0\n";
		}
		
		/**
		 * @inheritDoc
		 */
		arcane override function getFragmentCode(animationCode:String):String
		{
			return "mov oc, v0\n";
		}
		
		/**
		 * @inheritDoc
		 * todo: keep maps in dictionary per renderable
		 */
		arcane override function render(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D, viewProjection:Matrix3D):void
		{
			var context : Context3D = stage3DProxy._context3D;
			_matrix.copyFrom(renderable.sourceEntity.sceneTransform);
			_matrix.append(viewProjection);
			// va0 vertex
			renderable.activateVertexBuffer(0, stage3DProxy);
			//vc0 matrix
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _matrix, true);
			context.drawTriangles(renderable.getIndexBuffer(stage3DProxy), 0, renderable.numTriangles);
		}
		
		/**
		 * @inheritDoc
		 */
		override arcane function activate(stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			var context:Context3D = stage3DProxy._context3D;
			super.activate(stage3DProxy, camera);
			
			if (stage3DProxy.scissorRect)
				_constants[0] = _thickness/Math.min(stage3DProxy.scissorRect.width, stage3DProxy.scissorRect.height);
			else
				_constants[0] = _thickness/Math.min(stage3DProxy.width, stage3DProxy.height);
			
			// value to convert distance from camera to model length per pixel width
			_constants[2] = camera.lens.near;

			//fc0  thickness
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, _constants);
		}
		
		/**
		 * @inheritDoc
		 */
		arcane override function deactivate(stage3DProxy:Stage3DProxy):void
		{
			super.deactivate(stage3DProxy);
		}
	}
}
