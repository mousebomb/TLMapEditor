/**
 * Created by gaord on 2017/2/16.
 */
package tl.mapeditor.ui3d
{
	import away3d.entities.Mesh;
	import away3d.primitives.CubeGeometry;

	import tl.core.GPUResProvider;
	import tl.core.funcpoint.*;
	import tl.core.terrain.TLMapVO;
	import tl.frameworks.defines.FunctionPointType;

	public class FuncPointView extends Mesh
	{
		public var vo:FuncPointVO;
		public var tf:HTextField3D;

		public function FuncPointView(vo_:FuncPointVO)
		{
			vo = vo_;
			super(new CubeGeometry(TLMapVO.TERRAIN_SCALE*.5, TLMapVO.TERRAIN_SCALE * 5, TLMapVO.TERRAIN_SCALE*.5)
			,GPUResProvider.getInstance().getColorMaterial(FunctionPointType.COLOR[vo.type]));
			validate();
		}


		override public function get y():Number
		{
			return super.y-TLMapVO.TERRAIN_SCALE;
		}

		override public function set y(val:Number):void
		{
			super.y = val+TLMapVO.TERRAIN_SCALE;
		}

		public function validate():void
		{
			x = (vo.tileX+.5) * TLMapVO.TERRAIN_SCALE;
			z = -(vo.tileY+.5) * TLMapVO.TERRAIN_SCALE;
			if (tf == null)
			{
				tf = new HTextField3D();
				tf.init(1);
				tf.size = TLMapVO.TERRAIN_SCALE;
				tf.y = TLMapVO.TERRAIN_SCALE * 2.5;
				addChild(tf);
			}
			tf.color = FunctionPointType.COLOR[vo.type];
			tf.text  = FunctionPointType.LABEL[vo.type]+"\n"+(vo.tileX + "," + vo.tileY);
		}


	}
}
