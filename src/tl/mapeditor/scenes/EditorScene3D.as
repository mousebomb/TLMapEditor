/**
 * Created by gaord on 2016/11/24.
 */
package tl.mapeditor.scenes
{
	import away3d.entities.Mesh;
	import away3d.primitives.PlaneGeometry;

	import tl.core.*;
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.controllers.HoverController;

	import flash.geom.Vector3D;

	import tl.core.terrain.MapView;
	import tl.mapeditor.ui3d.MapZoneView;

	import tool.StageFrame;

	public class EditorScene3D extends Scene3D
	{
		private var _camera:Camera3D;

		/** 地形 */
		public var terrainView:MapView;

		private var _lookTarget:Vector3D = new Vector3D();

		public static var instance:EditorScene3D;

		/** 上盖ui层 3D标注类 */
		public var coverView:ObjectContainer3D;

		/** 上盖地图区域显示 3D标注 */
		public var zoneView:MapZoneView;

		/** 摄像机控制器*/
		private var _camHC:HoverController;


		public function EditorScene3D(camera_:Camera3D)
		{
			instance = this;
			addChild(LightProvider.getInstance().sunLight);
			_camera           = camera_;
			_camera.lens      = new PerspectiveLens();
			_camera.lens.far  = 5000;
			_camera.rotationX = 75;
			_camera.position  = _lookTarget;
			_camera.moveBackward(800);
			_camHC = new HoverController(_camera, null, -180, 35, 800,0,90);


			terrainView = new MapView();
			addChild(terrainView);


			coverView = new ObjectContainer3D();
			addChild(coverView);

			zoneView = new MapZoneView();

			addChild(LightProvider.getInstance().skybox);
		}


		/**摄像机位移速度 （每毫秒）*/
		public var camZSpeed:Number = 0;
		public var camXSpeed:Number = 0;

		/**毫秒数*/
		public function update(delta:int):void
		{
			if (camZSpeed || camXSpeed)
			{
				_lookTarget.z += camZSpeed * delta;
				_lookTarget.x += camXSpeed * delta;
				_camHC.lookAtPosition = _lookTarget;
			}
		}

		public function dragRoll(mouseX:Number, mouseY:Number):void
		{
			_camHC.panAngle += mouseX;
			_camHC.tiltAngle += mouseY;
		}

		public function get lookTarget():Vector3D
		{
			return _lookTarget;
		}

		public function setLookTarget(lx:Number, ly:Number, lz:Number):void
		{
			_lookTarget.x         = lx;
			_lookTarget.z         = ly;
			_lookTarget.y         = lz;
			_camHC.lookAtPosition = _lookTarget;
		}

		public function lookAtMapCenter():void
		{
			_camHC.panAngle  = -180;
			_camHC.tiltAngle = 35;
			setLookTarget(terrainView.bounds.halfExtentsX, terrainView.bounds.halfExtentsZ, terrainView.bounds.halfExtentsY);
		}

		public function camForward(delta:int):void
		{
			_camHC.distance += delta*5;
		}




		// #pragma mark --  显示格子信息（区域）  ------------------------------------------------------------
		/** 地形区域显示格 */
		private var _isShowZone :Boolean = false;

		public function get isShowZone():Boolean
		{
			return _isShowZone;
		}

		public function set isShowZone(value:Boolean):void
		{
			if(_isShowZone == value ) return ;
			_isShowZone = value;
			if(_isShowZone)
			{
				addChild(zoneView);
			}else{
				removeChild(zoneView);
			}
		}
	}
}
