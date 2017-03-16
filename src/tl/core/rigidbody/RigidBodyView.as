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
			super (new CubeGeometry(1,20,1));
			validate();
		}

		public function validate():void
		{
			this.scaleX = vo.rect.width;
			this.scaleZ = vo.rect.height;
			x           = vo.rect.x + vo.rect.width/2;
			z           = vo.rect.y + vo.rect.height/2;
			y           = vo.y - 10;
			rotationY   = vo.rotationY;
			rotationX   = vo.rotationX;
		}

		public function commit():void
		{
			vo.setXZWD(x, z, y, scaleX, scaleZ,20);
			vo.setRotation(rotationY);
			vo.setRotationX(rotationX);
			vo.validate();
		}

	}
}
