package HLib.MapBase
{
	/**
	 * away3d场景基类 
	 * @author Administrator
	 * 郑利本
	 */

import Modules.Common.CameraConsts;

	import away3d.debug.Debug;

	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.setTimeout;
	
	import HLib.DataUtil.HashMap;
	import HLib.Effect.Vibrate3DEffect;
	import HLib.Tool.HLog;
	import HLib.UICom.BaseClass.HSprite3D;
	import HLib.UICom.BaseClass.HTextField3D;
	import HLib.WizardBase.HObject3DPool;
	
	import Modules.Map.InitLoaderMapResControl;
	import Modules.Map.Events.MapEvent;
	import Modules.Wizard.WizardActor3D;
	import Modules.Wizard.WizardKey;
	import Modules.Wizard.WizardObject;
	
	import away3DExtend.MeshExtend;
	
	import away3d.arcane;
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.OrthographicLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.math.MathConsts;
	import away3d.events.MouseEvent3D;
	import away3d.primitives.PlaneGeometry;
	
	import tool.MyAway3DClock;
	import tool.StageFrame;
	
	use namespace arcane;
	public class HMapBase3D extends Scene3D
	{
		public var stage:Stage;
		public function setStage(val:Stage):void
		{
			stage = val;
			
			StageFrame.addGameFun(onUpdateMousePos);
		}
		
		private var _mousev3d:Vector3D = new Vector3D();
		private var _mousePos:Point = new Point();
		/** 鼠标位置点 **/
		public function get mousePoint():Point  
		{
			return _mousePos; 
		}
		
		private function onUpdateMousePos():void
		{
			var tmpVal:Number = stage.mouseY - (stage.stageHeight >> 1);
			myView.unproject(stage.mouseX, stage.mouseY, ViewHeight - tmpVal, _mousev3d);
			_mousePos.setTo(_mousev3d.x, -_mousev3d.z);
		}
		
		public var myView:View3D;									//main view
		private var _HMapData:HMapData;								//地图数据
		private var _MainWizardActor3D:WizardActor3D;				//主角
//		public var mainPets:Vector.<WizardActor3D> = new Vector.<WizardActor3D>();
		
		protected var _Camera3D:Camera3D = new Camera3D();			//摄像机
		private var _Lens:OrthographicLens = new OrthographicLens();
		public var _floorMap:HSprite3D;								//地图
		private var _AngleX:int = 45;                         		//摄像机以X轴旋转角度
		private var _PropWH:Number=1;                         		//摄像机视野的宽高比
		private var _ViewWidth:Number=0;//摄像机视图宽度
		
		/** 振屏 */
		protected var _cameraEffect:Vibrate3DEffect = new Vibrate3DEffect();
		
		/**进入地图标志*/
		public function get isEntryMap():Boolean
		{
			return _isEntryMap;
		}
		
		public function get ViewWidth():Number
		{
			return _ViewWidth;
		}
		
		//摄像机视图高度    		
		private var _ViewHeight:Number=0;                     		
		
		public function get ViewHeight():Number
		{
			return _ViewHeight;
		}

		/**摄像机与瞄点之间的集中距离(当前使用)*/
		protected var _cameraDistance:int = 800;                		//摄像机与瞄点之间的集中距离
		private var _AStar:AStar = new AStar();						//A*寻路
		protected var _actorVec:Vector.<WizardActor3D> = new Vector.<WizardActor3D>();                  //地图所有精灵数组
		
		public function HMapBase3D()
		{
			super();
			
			_Lens.near = 1;
			_Lens.far = 10000;

			//			_cameraEffect.setVals(10, 1000);
		}
		
		/** 隐藏翅膀 */
		public function set isHideWing(val:Boolean):void
		{
			for each (var actor:WizardActor3D in _actorVec)
			{
				if (actor != mainWizardActor3D)
				{
					actor.isHideWing = val;
				}
			}
		}
		
		public function mapBase3DInIt():void
		{
			var mesh:MeshExtend;
			var plane:PlaneGeometry = new PlaneGeometry(512, 512);
			_floorMap = new HSprite3D();
			for(var i:int = 0; i < 20; i++)
			{
				for(var j:int = 0; j < 20; j++)
				{
					mesh = new MeshExtend(plane);
					_floorMap.addChild(mesh);
					mesh.x = -256 - (j * 512);
					mesh.z = 256 + (i * 512);
					mesh.rotationY = 180;
					mesh.name = "smesh_" + i + "_" + j;
					_tileViewHash.put(mesh.name, mesh);
					mesh.mouseEnabled = true;
					mesh.addEventListener(MouseEvent3D.MOUSE_UP, onTerrainMouseUp);
					mesh.addEventListener(MouseEvent3D.MOUSE_DOWN, onTerrainMouseDown);	
//					mesh.addEventListener(MouseEvent3D.MOUSE_MOVE, onTerrainMouseMove);
					//mesh.addEventListener(MouseEvent3D.DOUBLE_CLICK, onMouseDoubleClick);
				}
			}
			this.addChild(_floorMap);
			
			_floorMap.rotationY = 180;
			_floorMap.y = -1;
			MapFloor3D.getInstance().tileView3DParent = _floorMap;
			MapFloor3D.getInstance().tileViewHash = _tileViewHash;
		}
		
		/**
		 * 按给定的显示宽长高创建地图 
		 * @param width  宽
		 * @param length 长
		 * @param height 高
		 */
		public function loadMap(mapData:HMapData):void
		{
			_HMapData = mapData;
			_AStar.mapData = _HMapData;
			
			startCameratAt();
		}
		
		private function stopCameraAt():void
		{
			_isEntryMap = false;
			StageFrame.cameraAt = null;
		}
		
		protected var _isEntryMap:Boolean;
		public var isEntry:Boolean;

		public function startCameratAt( preferDistance: int = 0 ):void
		{
			// 如果传入0，则保持不变 只是重新调用下, 若非0 则为主动设置距离
			if(preferDistance>0)
				_cameraDistance = preferDistance;
			if (_HMapData && _MainWizardActor3D && _MainWizardActor3D.wizardObject && isEntry)
			{
				StageFrame.cameraAt = cameraAimAt;
				
				_isEntryMap = true;
				setTimeout(delayStartCameratAt, 1500);
//				StageFrame.addNextFrameFun(delayStartCameratAt);
			}
		}
		private function delayStartCameratAt( ):void
		{
			setCameraPara(_cameraDistance, _AngleX);

			InitLoaderMapResControl.getInstance().enterMapComplete();
			
			dispatchEvent(new MapEvent(MapEvent.ENTER_MAP));
		}
		//0-0000-----------------------------------------------------------------------------------------------------------------------------
		// 地表鼠标事件
		protected function onTerrainMouseDown(e:MouseEvent3D):void
		{ 
			
		}
		protected function onTerrainMouseUp(e:MouseEvent3D):void	
		{ 
			
		}
		//0-0000-----------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 设置摄像机属性，目前只支持集中对焦模式 
		 * @param cameraDistance 与焦点的集中距离
		 * @param angleX 摄像机绕X轴旋转的角度
		 * 
		 */
		public function setCameraPara(cameraDistance:Number = 800, angleX:Number = 45):void
		{
			_cameraDistance = cameraDistance;
			_AngleX = angleX;
			
			_ViewWidth = _cameraDistance * _PropWH;
			_ViewHeight = _cameraDistance / Math.cos(angleX * MathConsts.DEGREES_TO_RADIANS);//奇怪还是没有搞懂为什么会有400左右的误差......................
			MapFloor3D.getInstance().ViewWidth = _ViewWidth;
			MapFloor3D.getInstance().viewHeight = _ViewHeight;
			
			_Lens.projectionHeight = cameraDistance;
			_Camera3D.lens = _Lens;
			_Camera3D.rotationX = _AngleX;
			
			_HalfViewWidth = _ViewWidth / 2;
			_HalfViewHeight = _ViewHeight / 2;
			_offsetZ = _cameraDistance * Math.tan((90 - _AngleX) * MathConsts.DEGREES_TO_RADIANS);
			
			if (mainWizardActor3D && mainWizardActor3D.wizardObject)
			{
				MapFloor3D.getInstance().aimAt(mainWizardActor3D.wizardObject.x, mainWizardActor3D.wizardObject.z, true);
			}
		}
		
		private var _HalfViewWidth:Number;
		private var _HalfViewHeight:Number;
		private var _offsetZ:Number;
		/**
		 * 场景摄像机瞄准的焦点，需要逐帧更新 
		 * @param vector3D
		 * 
		 */
		private function cameraAimAt():void
		{
			var wizardX:Number;
			var wizardZ:Number;
			var tarX:Number;
			var tarY:Number;
			var tarZ:Number;
			
			wizardX = this.mainWizardActor3D.x;
			wizardZ = -this.mainWizardActor3D.z;
			
			MapFloor3D.getInstance().aimAt(wizardX, wizardZ);
			
			//			tarY = this.mainWizardActor3D.y + _cameraDistance;
			//设置镜头X位置
			if(wizardX >= _HalfViewWidth && wizardX <= this.mapData.myWidth - _HalfViewWidth)
			{
				tarX = wizardX;
			}
			else
			{
				if(wizardX < _HalfViewWidth)
				{
					tarX = _HalfViewWidth;
				}
				else
				{
					tarX = this.mapData.myWidth - _HalfViewWidth;
				}
			}
			//设置镜头Y,Z位置
			if(wizardZ >= _HalfViewHeight && wizardZ <= this.mapData.myHeight - _HalfViewHeight)
			{
				tarZ = -wizardZ - _offsetZ;
			}
			else
			{
				if(wizardZ > this.mapData.myHeight - _HalfViewHeight)
				{
					tarZ = this.mapData.myHeight - _HalfViewHeight;
				}
				else
				{
					tarZ = _HalfViewHeight;
				}
				tarZ = -tarZ - _offsetZ;
			}
			/*
			tarX = _Camera3D.position.x * 0.9 + tarX * 0.1;
			tarZ = _Camera3D.position.z * 0.9 + tarZ * 0.1;
			*/
			_tmpPos.setTo(tarX, _cameraDistance, tarZ);
			
			_cameraEffect.update();
			_tmpPos.x += _cameraEffect.offX;
			_tmpPos.y += _cameraEffect.offY;
			_tmpPos.z += _cameraEffect.offZ;
			
			_Camera3D.position = _tmpPos;
		}
		private var _tmpPos:Vector3D = new Vector3D();
		
		
		/** 是否开启动态阴影*/		
		public function set isOpenDynamicShadows(value:Boolean):void
		{
			_isOpenDynamicShadows = value;
			for each(var wizard:WizardActor3D in _actorVec)
			{
				if (wizard.wizardObject.type == WizardKey.TYPE_0 || 
					wizard.wizardObject.type == WizardKey.TYPE_1 || 
					wizard.wizardObject.type == WizardKey.TYPE_3 || 
					wizard.wizardObject.type == WizardKey.TYPE_4 || 
					wizard.wizardObject.type == WizardKey.TYPE_5 || 
					wizard.wizardObject.type == WizardKey.TYPE_8 || 
					wizard.wizardObject.type == WizardKey.TYPE_9 || 
					wizard.wizardObject.type == WizardKey.TYPE_10 || 
					wizard.wizardObject.type == WizardKey.TYPE_12 || 
					wizard.wizardObject.type == WizardKey.TYPE_16)
				{
					wizard.isOpenDynamicShadows = value;
				}
			}
		}
		
		/** 是否开启动态阴影*/	
		public function get isOpenDynamicShadows():Boolean
		{ 
			return _isOpenDynamicShadows;
		}
		
		/** 是否开启动态阴影*/	
		private var _isOpenDynamicShadows:Boolean = true;
		
		/**
		 * 依据起始与结束坐标返回a星寻路的路径,返回值是一个由Node对象组成的数组
		 * @param sPoint	: 起始点
		 * @param tPoint	: 目标点
		 * @return 
		 */		
		public function getPath(sPoint:Point, tPoint:Point):Array
		{
			var retPaths:Array;
			var node1:Node = this.mapData.getNodeByPoint(sPoint);
			var node2:Node = this.mapData.getNodeByPoint(tPoint);
			//判断目标点是否不可行走区域,返回一下null
			if(!node1 || !node2 || !node2.walkable) //|| !node1.walkable 
			{
				return retPaths;
			}
			if(_AStar.findPath(node1, node2))
			{
				retPaths = AstarFloyd.floyd(_AStar.path);
			}
			
			return retPaths;
		}
		
		/**
		 * 获得完整路径距离
		 * @param sPoint
		 * @param tPoint
		 * @return 
		 */		
		public function getCompletePath(sPoint:Point, tPoint:Point):Array
		{
			var retPaths:Array;
			var node1:Node = this.mapData.getNodeByPoint(sPoint);
			var node2:Node = this.mapData.getNodeByPoint(tPoint);
			//判断目标点是否不可行走区域,返回一下null
			
			if(!node1 || !node2) 
			{
				return retPaths;
			}
			if(!node2.walkable)
			{
				return null;
			}
			
			if( _AStar.findPath(node1, node2) )
			{
				retPaths = _AStar.path;
			}
			
			return retPaths;
		}
		
		public function getPathByDist(sPoint:Point, tPoint:Point, dist:uint):Array
		{
			var retPaths:Array = getCompletePath(sPoint, tPoint);
			
			if (retPaths)
			{
				retPaths.pop();
				var tmpNode:Node;
				var tmpPos:Point = new Point();
				
				while (retPaths.length)
				{
					tmpNode = retPaths.pop();
					tmpPos.setTo(tPoint.x - tmpNode.pointX, tPoint.y - tmpNode.pointY);
					if ((tmpPos.x * tmpPos.x + tmpPos.y * tmpPos.y) >= dist * dist)
					{
						retPaths.push(tmpNode);
						
						break;
					}
				}
			}
			
			return AstarFloyd.floyd(retPaths);
		}
		
		/**
		 * 创建精灵 
		 * @param wizardObject	: 精灵数据
		 * @param isRefresh		: 是否实时刷新精灵
		 */		
		protected function CreateWizard(wizardObject:WizardObject):WizardActor3D
		{
			var actor3d:WizardActor3D = wizardObject.actor3d;
			if(actor3d) 
			{
				return actor3d;
			}
			actor3d = HObject3DPool.getInstance().getWizardActor3D();
			actor3d.actor3DInIt(wizardObject);
			actor3d.rotationY = wizardObject.initAngle;
			actor3d.isOpenDynamicShadows = this.isOpenDynamicShadows;
			this.AddWizard(actor3d);
			return actor3d;
		}
		
		/**
		 * 添加精灵 
		 * @param _WizardActor	: 精灵对象
		 * @param isRefresh		: 是否实时是auxin
		 */		
		private function AddWizard(actor3d:WizardActor3D):void
		{
			if(!actor3d.wizardObject.isMainActor && actor3d.needMouseEnabled && 
				(_MainWizardActor3D && actor3d.wizardObject.Creature_MasterUID != _MainWizardActor3D.Entity_UID))
			{
				actor3d.addEventListener(MouseEvent3D.MOUSE_DOWN, onWizardMouseDown);
				actor3d.addEventListener(MouseEvent3D.MOUSE_UP, onWizardMouseUp);
				actor3d.addEventListener(MouseEvent3D.MOUSE_OVER, onWizardMouseOver);
				actor3d.addEventListener(MouseEvent3D.MOUSE_OUT, onWizardMouseOut);
			}
			/*
			if (_MainWizardActor3D && actor3d.wizardObject.Creature_MasterUID == _MainWizardActor3D.Entity_UID)
			{
				mainPets.push(actor3d);
			}
			*/
			_actorVec.push(actor3d);
			this.addChild(actor3d);
		}
		
		/**
		 * 释放精灵对象 
		 * @param _Wizard	: 需要释放的精灵
		 * @param isDestroy	: 是否释放资源
		 */		
		public function DisopWizard(actor3d:WizardActor3D):void
		{
			var index:int = _actorVec.indexOf(actor3d);
			if(index != -1) 
			{
				_actorVec[index] = _actorVec[_actorVec.length - 1];
				_actorVec.pop();
			}
			
			
			if (actor3d.isDispose == false && actor3d.wizardObject.isMainActor == false)
			{
				/*if (actor3d.wizardObject.Creature_MasterUID == _MainWizardActor3D.Entity_UID)
				{
					index = mainPets.indexOf(actor3d);
					if (index >= 0)
					{
						mainPets[index] = mainPets[mainPets.length - 1];
						mainPets.pop();
					}
				}*/
				
				actor3d.removeEventListener(MouseEvent3D.MOUSE_OVER, onWizardMouseOver);
				actor3d.removeEventListener(MouseEvent3D.MOUSE_OUT, onWizardMouseOut);
				actor3d.removeEventListener(MouseEvent3D.MOUSE_UP, onWizardMouseUp);
				actor3d.removeEventListener(MouseEvent3D.MOUSE_DOWN, onWizardMouseDown);
				actor3d.resetWizard();
				HObject3DPool.getInstance().recoverWizardActor3D(actor3d);
			}
		}
		
		/**
		 * 根据uid获取精灵对象 
		 * @param uid	: 精灵的UID
		 */		
		public function getWizard(uid:Number):WizardActor3D
		{
			var actorLen:uint = _actorVec.length;
			for (var i:int = 0; i < actorLen; ++i)
			{
				if (_actorVec[i].Entity_UID == uid)
				{
					return _actorVec[i];
				}
			}
			return null;
		}
		
		
		/**
		 * 根据ID获取精灵对象
		 * @param $id
		 */		
		public function getWizardFromId($id:String):WizardActor3D
		{
			var actorLen:uint = _actorVec.length;
			for (var i:int = 0; i < actorLen; ++i)
			{
				if(_actorVec[i].wizardObject.id == $id)
				{
					return _actorVec[i];
				}
			}
			return null;
		}
		
		/**通过actorid获取对象*/
		public function getWizardFormActorID(actorId:uint):WizardActor3D
		{
			var actorLen:uint = _actorVec.length;
			for (var i:int = 0; i < actorLen; ++i)
			{
				if(_actorVec[i].wizardObject.Player_ActorId == actorId)
				{
					return _actorVec[i];
				}
			}
			return null;
		}
		
		
		/**
		 * 清除地图
		 */		
		public function mapBaseClear():void
		{
			trace(StageFrame.renderIdx,"HMapBase3D/mapBaseClear <<<< vertexBufferNum:",Debug.vertexBufferNum);
			stopCameraAt();
			var wizardActor3D:WizardActor3D;
			while (_actorVec.length)
			{
				DisopWizard(_actorVec[0]);
			}
			
			if(this.mainWizardActor3D)
			{
				_actorVec.push(this.mainWizardActor3D);
			}
			
			MyAway3DClock.instance.setSerialNum(1);
//			trace(">>>>>>>>>>>>>>>>>>>>>>>>>>>>MyAway3DClock.callBackFunVecLength>>" + MyAway3DClock.instance.callBackFunVecLength);
//			trace(">>>>>>>>>>>>>>>>>>>>>>>>>>>>HMapBase3D.ChildLength>>" + this.numChildren);
			
			var objL:Array = [];
			var resMsg:String = "";
			var o:ObjectContainer3D;
			var tmpActor:WizardActor3D;
			for(var i:int = 0; i < this.numChildren; i++)
			{
				o = this.getChildAt(i);
				if(o is HTextField3D)
				{
					recoverTextField3D(o as HTextField3D);
				}
				else
				{
					objL.push(o);
					if (o is WizardActor3D)
					{
						tmpActor = o as WizardActor3D;
						if (tmpActor != _MainWizardActor3D)
						{
							resMsg += tmpActor.wizardObject.Player_Name;
						}
					}
				}
			}
			if (resMsg)
			{
				HLog.getInstance().addPropertyCount(resMsg);
			}
//			trace(objL);
			trace(StageFrame.renderIdx,"HMapBase3D/mapBaseClear END >>>>  vertexBufferNum:",Debug.vertexBufferNum);
		}
		
		
		/**
		 * 回收文本
		 * @param $textField3D	: 3D文本
		 */		
		protected function recoverTextField3D(txt3d:HTextField3D):void
		{
			txt3d.clearHTF3D();
			
			HObject3DPool.getInstance().recoverHTextField3D(txt3d);
		}
		
		//------------------------------------------------------------------------------------------------------------
		/** 精灵移入事件,用于到HMap3D中重写,移除时在此类移除 **/
		protected function onWizardMouseOver(e:MouseEvent3D):void 
		{
			
		}
		/** 精灵移出事件,用于到HMap3D中重写,移除时在此类移除 **/
		protected function onWizardMouseOut(e:MouseEvent3D):void 
		{
			
		}
		/** 精灵移出事件,用于到HMap3D中重写,移除时在此类移除 **/
		protected function onWizardMouseUp(e:MouseEvent3D):void
		{ 
			
		}
		/** 精灵移出事件,用于到HMap3D中重写,移除时在此类移除 **/
		protected function onWizardMouseDown(e:MouseEvent3D):void
		{ 
			
		}
		//------------------------------------------------------------------------------------------------------------
		
		public function get myCamera3D():Camera3D
		{ 
			return _Camera3D;
		}
		private var _tileViewHash:HashMap = new HashMap();	//地图模块数据
		/** 摄像机宽高比 **/
		public function set propWH(value:Number):void 
		{
			_PropWH = value; 
		}
		/** 地面mesh **/
		public function get floorMap():HSprite3D  
		{ 
			return _floorMap; 
		}
		/** 地图数据 **/
		public function get mapData():HMapData 
		{ 
			return _HMapData;
		}
		
		/** 主角数据 **/
		public function set mainWizardActor3D(value:WizardActor3D):void 
		{ 
			_MainWizardActor3D = value;
			StageFrame.mainActorMove = refreshMainActor;
			startCameratAt();
		}
		
		private function refreshMainActor():void
		{
			if (_MainWizardActor3D)
			{
				//				_MainWizardActor3D.refreshSkeleton();
				_MainWizardActor3D.refreshActor3D();
			}
		}
		
		public function get mainWizardActor3D():WizardActor3D 
		{ 
			return _MainWizardActor3D;
		}
		
		/** 摄像机角度 **/
		public function get angleX():Number  
		{ 
			return _AngleX;
		}
		
		/** 摄像机距离 **/
		public function get cameraDistance():Number 
		{  
			return _cameraDistance;  
		}
		
		public function get actorVec():Vector.<WizardActor3D>
		{
			return _actorVec;
		}
	}
}