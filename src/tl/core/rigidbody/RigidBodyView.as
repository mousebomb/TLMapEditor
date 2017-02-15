/**
 * Created by gaord on 2017/2/4.
 */
package tl.core.rigidbody
{
	import away3d.entities.Mesh;
	import away3d.primitives.CubeGeometry;

	/** 刚体 */
	public class RigidBodyView extends Mesh
	{
		public var vo:RigidBodyVO;

		public function RigidBodyView(vo_:RigidBodyVO)
		{
			vo = vo_;
			super (new CubeGeometry(1,100,1));
			validate();
		}

		public function validate():void
		{
			this.scaleX = vo.rect.width;
			this.scaleZ = vo.rect.height;
			x           = vo.rect.x;
			z           = vo.rect.y;
			y           = vo.y - 50;
		}

		public function commit():void
		{
			vo.setXZWD(x, z, y, scaleX, scaleZ);
			vo.setRotation(rotationY);
		}

	}
}
