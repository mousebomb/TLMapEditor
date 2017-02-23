/**
 * Created by gaord on 2016/12/15.
 */
package tl.frameworks.mediator
{
	import away3d.cameras.Camera3D;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.primitives.CubeGeometry;

	import flash.geom.Vector3D;

	import org.robotlegs.mvcs.Mediator;

	import tl.core.old.WizardObject;
	import tl.core.role.Role;
	import tl.frameworks.NotifyConst;
	import tl.frameworks.TLEvent;
	import tl.frameworks.model.TLEditorMapModel;
	import tl.mapeditor.scenes.PreviewScene3D;

	import tool.StageFrame;

	public class PreviewScene3DMediator extends Mediator

	{
		public function PreviewScene3DMediator()
		{
			super();
		}

		[Inject]
		public var view:PreviewScene3D;

		private var lookAtPos:Vector3D = new Vector3D(0, 80, 0);

		override public function onRegister():void
		{
			var cam:Camera3D = TLMapEditor.view3DForPreview.camera;
			cam.position     = lookAtPos;
			cam.rotationX    = 20;
			cam.rotationY    = 0;
			cam.moveBackward(150);
			addContextListener(NotifyConst.SELECT_WIZARD_PREVIEW, onSELECT_WIZARD_PREVIEW);
			addContextListener(NotifyConst.SELECT_TERRAIN_TEXTURE_PREVIEW, onSELECT_TerrainTexturePREVIEW);

			addContextListener(NotifyConst.MAP_VO_INITED, onMapVOInited);
			addContextListener(NotifyConst.TOOL_SKYBOX_SET,onTOOL_SKYBOX_SET);
			//
			StageFrame.addAnimFun(onRotate);
			//
		}

		[Inject]
		public var mapModel:TLEditorMapModel;
		private function onMapVOInited(e:*):void
		{
			// 天空盒
			view.skyBoxView.setSkyBoxTextureName(mapModel.mapVO.skyboxTextureName);
		}
		/**设置天空盒*/
		private function onTOOL_SKYBOX_SET( n: * ):void
		{
			var cubeTextureName:String = n.data;
			view.skyBoxView.setSkyBoxTextureName(cubeTextureName);
		}

		private function onMouseDown(event:*):void
		{
			track("PreviewScene3DMediator/onMouseDown");
			dispatchWith(NotifyConst.UI_START_ADD_WIZARD,false, wizard.vo);

		}

		private function onRotate():void
		{
			var cam:Camera3D = TLMapEditor.view3DForPreview.camera;
			var to:Number    = cam.rotationY + 1;
			if (to > 180) to -= 360;
			cam.rotationX = 20;
			cam.rotationY = to;
			cam.position  = lookAtPos;
			cam.moveBackward(150);
		}

		private var wizard:Role;
		private function onSELECT_WIZARD_PREVIEW(n:TLEvent):void
		{
			clearTexture();
			clearWizard();
			var wo :WizardObject = n.data ;
			wizard ||= new Role();
			wizard.actor3DInIt(wo);
			view.addChild(wizard);
			wizard.mouseInteractive=true;
			wizard.addEventListener(MouseEvent3D.MOUSE_DOWN,onMouseDown);
		}

		private function clearWizard():void
		{
			if(wizard && wizard.parent)
			{
				view.removeChild(wizard);
				wizard.removeEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDown);
				wizard.clearRole();
			}
		}


		private var plane:Mesh;

		private function onSELECT_TerrainTexturePREVIEW(n:TLEvent):void
		{
			clearWizard();
			if (plane == null)
			{
				plane = new Mesh(new CubeGeometry(), null);
				plane.y = 80;
			}
			plane.material = n.data;
			if (plane.scene == null)
				view.addChild(plane);
		}

		private function clearTexture():void
		{
			if(plane && plane.parent)
			{
				view.removeChild(plane);
			}
		}
	}
}
