/**
 * Created by gaord on 2016/11/24.
 */
package tl.mapeditor.scenes
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.controllers.HoverController;
	import away3d.core.base.Object3D;

	import flash.geom.Point;
	import flash.geom.Vector3D;

	import tl.core.*;
	import tl.core.skybox.TLSkyBox;
	import tl.core.terrain.MapView;
	import tl.frameworks.NotifyConst;
	import tl.frameworks.TLEvent;
	import tl.mapeditor.ui.controls.ScaleGizmo3D;
	import tl.mapeditor.ui3d.MousePointTrack;

	public class EditorScene3D extends Scene3D
	{
		private var _camera:Camera3D;

		/** 地形 */
		public var terrainView:MapView;
		/**天空盒*/
		public var skyBoxView:TLSkyBox;

		private var _lookTarget:Vector3D = new Vector3D();

		public static var instance:EditorScene3D;

		/** 上盖ui层 3D标注类 */
		public var coverView:ObjectContainer3D;
		public var mousePointTrack:MousePointTrack;

		/** 摄像机控制器*/
		private var _camHC:HoverController;


		public function EditorScene3D(camera_:Camera3D)
		{
			instance = this;
			addChild(LightProvider.getInstance().sunLight);
			_camera           = camera_;
			_camera.lens      = new PerspectiveLens();
			_camera.lens.far  = 10240;
			_camera.rotationX = 75;
			_camera.position  = _lookTarget;
			_camera.moveBackward(800);
			_camHC = new HoverController(_camera, null, 180, 35, 800,0,90);


			terrainView = new MapView();
			addChild(terrainView);


			coverView = new ObjectContainer3D();
			addChild(coverView);

			skyBoxView= new TLSkyBox();
			addChild(skyBoxView);
			//
			mousePointTrack = new MousePointTrack();
			addChild(mousePointTrack);

			initGizmo3D();
		}

		/** 为当前摄像机朝向 计算一个二维化后的法线矢量方向 */
		[Inline]
		public final function calcMoveSpeedNormal(fixAngle :Number):Point
		{
			_moveSpeedNormalForward.x = Math.cos( (fixAngle+_camHC.panAngle) * Math.PI / 180);
			_moveSpeedNormalForward.y = Math.sin( (fixAngle+_camHC.panAngle) * Math.PI / 180);
			return _moveSpeedNormalForward;
		}
		/** 前进方向为正 */
		private var _moveSpeedNormalForward :Point = new Point();

		/**计算合力*/
		public function calcMixedSpeed(zSpeed:Number, xSpeed:Number,result:Point=null,isCamera:Boolean=false):Point
		{
			if(result == null) result = new Point();
			if(isCamera)
				calcMoveSpeedNormal(0);
			else
				calcMoveSpeedNormal(90);
			// 上下键作用于_moveSpeedNormalForward  左右键作用于_moveSpeedNormalRight
			var shangxiaJianZ :Number = zSpeed*(-_moveSpeedNormalForward.x);
			var shangxiaJianX :Number = zSpeed*(-_moveSpeedNormalForward.y);
			var zuoyouJianZ :Number = xSpeed * (_moveSpeedNormalForward.y);
			var zuoyouJianX :Number = xSpeed * (-_moveSpeedNormalForward.x);
			// y代表z
			result.y = shangxiaJianZ + zuoyouJianZ;
			result.x =  shangxiaJianX+zuoyouJianX;
			return result;
		}

		/**摄像机位移速度 （每毫秒）*/
		public var camZSpeed:Number = 0;
		public var camXSpeed:Number = 0;

		/** 每帧更新 delta:毫秒数*/
		public function update(delta:int):void
		{
			if (camZSpeed || camXSpeed)
			{
				// 自动转换方向为朝向
				var resultSpeed :Point = calcMixedSpeed(camZSpeed,camXSpeed,null,true);
				//
				_lookTarget.z += resultSpeed.y * delta;
				_lookTarget.x += resultSpeed.x * delta;
				_camHC.lookAtPosition = _lookTarget;
				//
				lookPercentTile.x = lookPercentTileX();
				lookPercentTile.y = lookPercentTileY();
				dispatchEvent(lookTargetChanged);
			}
		}

		private static const DRAG_ROLL_SENSITIVE :Number = 0.25;
		public function dragRoll(mouseX:Number, mouseY:Number):void
		{
			_camHC.panAngle += mouseX*DRAG_ROLL_SENSITIVE;
			_camHC.tiltAngle += mouseY*DRAG_ROLL_SENSITIVE;
		}

		/** UI主动要求跳转镜头 到百分比位置 */
		public function lookAtMapPercent(p:Point):void
		{
			_lookTarget.x = terrainView.bounds.max.x * p.x;
			_lookTarget.z = terrainView.bounds.max.z * p.y;
			_camHC.lookAtPosition = _lookTarget;
			lookPercentTile.x = p.x;
			lookPercentTile.y = p.y;
		}

		/** 当前镜头显示的是百分比的位置哪里 */
		public var lookPercentTile:Point=new Point();
		public function lookPercentTileX():Number {return _lookTarget.x / terrainView.bounds.max.x;}
		public function lookPercentTileY():Number {return _lookTarget.z / terrainView.bounds.max.z;}

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
			//
			lookPercentTile.x = lookPercentTileX();
			lookPercentTile.y = lookPercentTileY();
			dispatchEvent(lookTargetChanged);
		}
		private var lookTargetChanged:TLEvent = new TLEvent(NotifyConst.SCENE_CAM_MOVED,null);

		/** 跳转镜头 到地图中心位置 */
		public function lookAtMapCenter():void
		{
			_camHC.panAngle  = 180;
			_camHC.tiltAngle = 35;
			setLookTarget(terrainView.bounds.halfExtentsX, terrainView.bounds.halfExtentsZ, terrainView.bounds.halfExtentsY);
		}

		/** 跳转镜头 到某个实体位置 */
		public function lookAtEntity(obj:Object3D):void
		{
			setLookTarget(obj.x, obj.z, obj.y);
		}

		public function camForward(delta:int):void
		{
			_camHC.distance -= delta*10;
			if(_camHC.distance<100) _camHC.distance=100;
		}

		/** 进入俯视模式 */
		public function lookDown():void
		{
			_camHC.panAngle = 180;
			_camHC.tiltAngle=  89;
			_camHC.lookAtPosition = _lookTarget;
		}

		/** 设置摄像机聚焦点的高度 */
		public function set lookAtY(v:Number):void
		{
			_lookTarget.y         = v;
			_camHC.lookAtPosition = _lookTarget;
		}

		public function get lookAtY():Number
		{
			return _lookTarget.y;
		}



		// #pragma mark --  拖拽柄  ------------------------------------------------------------
//		public var translateGizmo:TranslateGizmo3D;
//		public var rotateGizmo:RotateGizmo3D;
		public var scaleGizmo:ScaleGizmo3D;

		/** 拖拽柄*/
		private function initGizmo3D():void
		{
			//Create Gizmos
//			translateGizmo = new TranslateGizmo3D();
//			addChild(translateGizmo);
//			rotateGizmo = new RotateGizmo3D();
//			addChild(rotateGizmo);
			scaleGizmo = new ScaleGizmo3D();
			addChild(scaleGizmo);
		}

	}
}
