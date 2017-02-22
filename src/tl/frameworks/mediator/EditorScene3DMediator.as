/**
 * Created by gaord on 2016/12/14.
 */
package tl.frameworks.mediator
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Object3D;
	import away3d.core.base.Object3D;
	import away3d.entities.Entity;
	import away3d.events.MouseEvent3D;

	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	import org.robotlegs.mvcs.Mediator;

	import tl.core.LightProvider;
	import tl.core.funcpoint.FuncPointVO;
	import tl.core.old.WizardObject;
	import tl.core.rigidbody.RigidBodyVO;
	import tl.core.rigidbody.RigidBodyView;
	import tl.core.role.Role;
	import tl.core.role.RolePlaceVO;
	import tl.core.role.RolePlaceVO;
	import tl.core.terrain.TLMapVO;
	import tl.frameworks.NotifyConst;
	import tl.frameworks.TLEvent;
	import tl.frameworks.defines.ToolBrushType;
	import tl.frameworks.defines.ZoneType;
	import tl.frameworks.model.CSV.SGCsvManager;
	import tl.frameworks.model.TLEditorMapModel;
	import tl.mapeditor.scenes.EditorScene3D;
	import tl.mapeditor.ui.controls.Gizmo3DBase;
	import tl.mapeditor.ui.controls.RotateGizmo3D;
	import tl.mapeditor.ui.controls.ScaleGizmo3D;
	import tl.mapeditor.ui.controls.TranslateGizmo3D;
	import tl.mapeditor.ui.events.Gizmo3DEvent;
	import tl.mapeditor.ui3d.BrushView;
	import tl.mapeditor.ui3d.FuncPointView;

	import tool.StageFrame;

	public class EditorScene3DMediator extends Mediator
	{

		[Inject]
		public var view:EditorScene3D;
		[Inject]
		public var mapModel:TLEditorMapModel;
		[Inject]
		public var csvModel:SGCsvManager;

		override public function onRegister():void
		{
			// 鼠标涂刷得
			eventMap.mapListener(view.terrainView,MouseEvent3D.MOUSE_DOWN, onMouseDown);
			eventMap.mapListener(view.terrainView,MouseEvent3D.MOUSE_UP, onMouseUp);
			eventMap.mapListener(view.terrainView,MouseEvent3D.MOUSE_MOVE, onMouseMove);
			eventMap.mapListener(view ,MouseEvent3D.MOUSE_MOVE,onMouseMoveAll);
			eventMap.mapListener(view ,MouseEvent3D.MOUSE_OUT,onMouseOutAnything);
			eventMap.mapListener(view ,MouseEvent3D.MOUSE_OVER,onMouseOverAnything);
			//拖拽柄
			currentGizmo=view.scaleGizmo;
			eventMap.mapListener(view.scaleGizmo,Gizmo3DEvent.MOVE, handleGizmoAction);
			eventMap.mapListener(view.scaleGizmo,Gizmo3DEvent.RELEASE, handleGizmoActionRelease);

			eventMap.mapListener(StageFrame.stage, KeyboardEvent.KEY_DOWN, onKeyDown);
			eventMap.mapListener(StageFrame.stage, KeyboardEvent.KEY_UP, onKeyUp);

			// 各种cancel
			eventMap.mapListener(StageFrame.stage, MouseEvent.MOUSE_UP, onStageMouseUp);

			// 镜头缩放的
			eventMap.mapListener(TLMapEditor.view3D,MouseEvent.MOUSE_WHEEL, onMouseWheel);
			eventMap.mapListener(TLMapEditor.view3D,MouseEvent.RIGHT_MOUSE_DOWN, onStageRightMouseDown);
			eventMap.mapListener(TLMapEditor.view3D,MouseEvent.MOUSE_MOVE, onStageMouseMove);
			eventMap.mapListener(TLMapEditor.view3D,MouseEvent.RIGHT_MOUSE_UP, onStageRightMouseUp);
			eventMap.mapListener(TLMapEditor.view3D,MouseEvent.MOUSE_OUT, onStageRightMouseUp);

			addContextListener(NotifyConst.MAP_VO_INITED, onMapVOInited);
			addContextListener(NotifyConst.TOOL_SELECT, onToolSelect);
			addContextListener(NotifyConst.TOOL_BRUSH, onToolBrush);
			addContextListener(NotifyConst.TOOL_BRUSH_SIZE_ADD, onToolBrushSizeAdd);
			addContextListener(NotifyConst.TOOL_BRUSH_SIZE,onToolBrushSize);
			addContextListener(NotifyConst.TOOL_BRUSH_QIANGDU,onToolBrushStrong);
			addContextListener(NotifyConst.TOOL_BRUSH_SPLATPOWER,onToolBrushSplatPower);
			addContextListener(NotifyConst.TOOL_BRUSH_ROUHE,onToolBrushSoftness);
			addContextListener(NotifyConst.TOOL_BRUSH_H_MAX,onTOOL_BRUSH_H_MAX);
			addContextListener(NotifyConst.TOOL_BRUSH_H_MIN,onTOOL_BRUSH_H_MIN);
			addContextListener(NotifyConst.TOOL_NEW_RIGIDBODY, onNewRigidBody);
			addContextListener(NotifyConst.TOOL_RIGIDBODY_SIZE_ADD, onToolRigidBodySizeAdd);
			addContextListener(NotifyConst.TOOL_RIGIDBODY_ROTATION_ADD, onToolRigidBodyRotated);

			addContextListener(NotifyConst.UI_START_ADD_WIZARD, onAddWizard);
			addContextListener(NotifyConst.UI_SELECT_WIZARD, onUISelectWizard);
			addContextListener(NotifyConst.MAP_TERRAIN_TEXTURE_CHANGED, onSPLAT_TEXTURE_CHANGED);
			addContextListener(NotifyConst.TOGGLE_GRID, onToggleGrid);
			addContextListener(NotifyConst.TOGGLE_ZONE, onToggleZone);
			addContextListener(NotifyConst.MAP_NODE_VAL_CHANGED,onMapNodeValChanged);
			addContextListener(NotifyConst.UI_ADD_FUNCPOINT, onAddFuncPoint);

			addContextListener(NotifyConst.TOOL_TARGET_ROTATE,onToolSelectRotate);
			addContextListener(NotifyConst.TOOL_TARGET_UP,onToolSelectUp);
			addContextListener(NotifyConst.TOOL_SKYBOX_SET,onTOOL_SKYBOX_SET);

			addContextListener(NotifyConst.LIGHT_DIRECTION_SET,onLIGHT_DIRECTION_SET);
			addContextListener(NotifyConst.UI_EDITOR_MOVE_CAM,onUI_EDITOR_MOVE_CAM);
			addViewListener(NotifyConst.SCENE_CAM_MOVED,onViewCamMoved);

		}

		// #pragma mark --  天空盒和光照  ------------------------------------------------------------
		/**设置光照角度 */
		private function onLIGHT_DIRECTION_SET( n: * ):void
		{
			LightProvider.getInstance().setSunLightDirection(n.data);
			mapModel.mapVO.sunLightDirection=n.data;
		}

		/**设置天空盒*/
		private function onTOOL_SKYBOX_SET( n: * ):void
		{
			var cubeTextureName:String = n.data;
			view.skyBoxView.setSkyBoxTextureName(cubeTextureName);
			mapModel.mapVO.skyboxTextureName = cubeTextureName;
		}

		// #pragma mark --  选中对象旋转和抬高  ------------------------------------------------------------
		private function onToolSelectRotate( n: * ):void
		{
			var target :Object3D = selectedTargetTransformBegin();
			if(target)
			{
				target.rotationY += n.data;
				selectedTargetTransformCommit();
			}
		}
		private function onToolSelectUp( n: * ):void
		{
			var target :Object3D = selectedTargetTransformBegin();
			if(target)
			{
				target.y += n.data;
				selectedTargetTransformCommit();
			}
		}

		private function selectedTargetTransformBegin():Object3D
		{
			var target:Object3D;
			if (_selectedRigidBody)
			{
				target = _selectedRigidBody;
			} else if (_selectedRole)
			{
				target = _selectedRole;
			}
			view.mousePointTrack.updateAABB(null);
			return target;
		}

		private function selectedTargetTransformCommit():void
		{
			// 保存移动数据
			if(_selectedRigidBody)
				_selectedRigidBody.commit();
			else if (_selectedRole)
				mapModel.commitWizard(_selectedRole, placeVOByRole[_selectedRole]);
		}
		// #pragma mark --  区域显示  ------------------------------------------------------------

		private function onMapNodeValChanged(n:*):void
		{
			var color : uint = ZoneType.COLOR_BY_TYPE[n.data.type];
			(view.zoneView).setZoneType(n.data.tileX,n.data.tileY,color);
		}

		private function onToggleZone(e:*):void
		{
			view.terrainView.isShowZone = !view.terrainView.isShowZone;
//			view.isShowZone = !view.isShowZone;
		}

		// #pragma mark --  网格显示  ------------------------------------------------------------
		private function onToggleGrid( n: * ):void
		{
			view.terrainView.isShowGrid = !view.terrainView.isShowGrid;
		}

		/** 地图数据就绪 */
		private function onMapVOInited(e:TLEvent):void
		{
			// 地形
			view.terrainView.fromMapVO(mapModel.mapVO);
			view.lookAtMapCenter();
			// 模型
			removeAllWizards();
			for each (var group:Vector.<RolePlaceVO> in mapModel.mapVO.entityGroups)
			{
				for (var i:int = 0; i < group.length; i++)
				{
					var vo:RolePlaceVO = group[i];
					fromMapWizard(vo);
				}
			}
			// 刚体
			removeAllRigidBodies();
			for (var i:int = 0; i < mapModel.mapVO.rigidBodies.length; i++)
			{
				var rigidBodyVO:RigidBodyVO = mapModel.mapVO.rigidBodies[i];
				var rigidBody:RigidBodyView = new RigidBodyView(rigidBodyVO);
				view.addChild(rigidBody);
				rigidBodiesInScene.push(rigidBody);
				rigidBody.addEventListener(MouseEvent3D.MOUSE_DOWN, onRigidBodyMouseDown);
			}
			// 灯光
			LightProvider.getInstance().setSunLightDirection(mapModel.mapVO.sunLightDirection);
			// 区域
			view.zoneView.fromMapVO(mapModel.mapVO);
			// 功能点
			removeAllFuncPoints();
			for (var i:int = 0; i < mapModel.mapVO.funcPoints.length; i++)
			{
				var funcPointVO:FuncPointVO = mapModel.mapVO.funcPoints[i];
				selectedFuncPoint  = new FuncPointView(funcPointVO);
				view.addChild(selectedFuncPoint);
				funcPointsInScene.push(selectedFuncPoint);
				// 提交后监听鼠标点击可选中
				selectedFuncPoint.addEventListener(MouseEvent3D.MOUSE_DOWN, onFuncPointMouseDown);
			}
			// 天空盒
			view.skyBoxView.setSkyBoxTextureName(mapModel.mapVO.skyboxTextureName);
		}

		private function onSPLAT_TEXTURE_CHANGED(n:TLEvent):void
		{
			view.terrainView.isTextureDirty = true;
		}

		// #pragma mark --  拖拽柄  ------------------------------------------------------------
		public var currentGizmo:Gizmo3DBase;

		private function gizmoSetTarget( target :ObjectContainer3D ):void
		{
			currentGizmo.show(target);
			currentGizmo.active=true;

		}
		private function clearGizmo3D():void
		{
			if (currentGizmo) {
				currentGizmo.active = false;
				currentGizmo.hide();
			}
		}

		private function handleGizmoActionRelease(e:Gizmo3DEvent):void
		{
			trace(StageFrame.renderIdx,"[EditorScene3DMediator]/handleGizmoActionRelease",e.mode, e.object, e.currentValue, e.startValue, e.endValue);
			selectedTargetTransformCommit();
		}

		private function handleGizmoAction(e:Gizmo3DEvent):void
		{
			trace(StageFrame.renderIdx,"[EditorScene3DMediator]/handleGizmoAction", e.mode, e.object, e.currentValue, e.startValue, e.endValue);
		}

		// #pragma mark --  WIZARD 角色添加删除和拖拽  ------------------------------------------------------------

		/** 编辑器使用 记录一幅地图里放置的数据对应关系; 恢复完视图也需要绑定 */
		private var placeVOByRole:Dictionary = new Dictionary();

		/** 清空地图：wizard */
		private function removeAllWizards():void
		{
			for (var i:int = 0; i < rolesInScene.length; i++)
			{
				var role:Role = rolesInScene[i];
				role.clearRole();
			}
			rolesInScene  = new Vector.<Role>();
			placeVOByRole = new Dictionary();
			if(draggingNewRole) draggingNewRole.clearRole();
			draggingNewRole = null;
			isSelectedDragging=false;
			selectedRole = null;
		}

		/** 从存档加入显示 */
		private function fromMapWizard(placeVO:RolePlaceVO):void
		{
			var wizardObject:WizardObject = new WizardObject();
			wizardObject.refreshByTable(placeVO.wizardId);
			var newRole:Role = new Role();
			newRole.actor3DInIt(wizardObject);
			newRole.x = placeVO.x;
			newRole.z = placeVO.z;
			newRole.y = placeVO.y;
			placeVO.wizard = newRole;
			view.addChild(newRole);
			rolesInScene.push(newRole);
			// 提交后监听鼠标点击可选中
			newRole.addEventListener(MouseEvent3D.MOUSE_DOWN, onRoleMouseDown);
			//
			placeVOByRole[newRole] = placeVO;
		}

		/** 从UI点选一个场上的模型 */
		private function onUISelectWizard(n:*):void
		{
			var vo :RolePlaceVO = n.data ;
			// 放弃一切在做的操作，点选一个角色模型
			clearSelection();
			var role:Role                 = vo.wizard;
			role.bodyUnit.showBounds      = true;
			selectedRole = role;
			// 镜头
			view.lookAtEntity(role);
		}
		/** 实体角色 开始添加 */
		private function onAddWizard(n:TLEvent):void
		{
			clearSelection();

			var wizardObject:WizardObject = n.data;
			// 记录开始拖拽添加，
			draggingNewRole               = new Role();
			draggingNewRole.actor3DInIt(wizardObject);
			track("EditorScene3DMediator/onAddWizard");
		}

		/** 当前要新放置的 */
		private var draggingNewRole:Role;

		private function onMouseMove4NewWizard(event:MouseEvent3D):void
		{
			// 没有对象 就是正常鼠标移动
			if (draggingNewRole == null) return;
			// 如果有对象且已经拖到在场景内了，首次则加入
			if (draggingNewRole.parent == null)
			{
				view.addChild(draggingNewRole);
				setTargetsMouseInteractive(false);
				track("EditorScene3DMediator/onMouseMove4NewWizard");
			}
			var downPos:Vector3D = event.scenePosition;
			draggingNewRole.x    = downPos.x;
			draggingNewRole.z    = downPos.z;
			draggingNewRole.y    = mapModel.getHeightWithRigidBody(downPos.x, downPos.z);
		}

		private function onStageMouseUp(e:MouseEvent):void
		{
			if (draggingNewRole)
			{
				if (draggingNewRole.parent == null)
				{
					// 尚未放入场景，则为放弃
					draggingNewRole.clearRole();
					draggingNewRole = null;
				} else
				{
					// 提交
					placeVOByRole[draggingNewRole] = mapModel.addWizard(draggingNewRole);
					rolesInScene.push(draggingNewRole);
					track("EditorScene3DMediator/onStageMouseUp addWizard");
					// 提交后监听鼠标点击可选中
					setTargetsMouseInteractive(true);
					draggingNewRole.addEventListener(MouseEvent3D.MOUSE_DOWN, onRoleMouseDown);
				}
				draggingNewRole = null;
			} else if (_selectedRole)
			{
				// 移动了重新保存 仍旧保持选中状态
				mapModel.commitWizard(_selectedRole, placeVOByRole[_selectedRole]);
				// 停止移动
				setTargetsMouseInteractive(true);
				isSelectedDragging            = false;
			}
			onStageMouseUp4RigidBody(e);
			onStageMouseUp4FuncPoint(e);
		}

		/** 当前在选中 已存在的role 标记选中的 */
		private var _selectedRole:Role;
		/** 是否在拖拽中 */
		private var isSelectedDragging:Boolean = false;

		/** 点选角色 */
		private function onRoleMouseDown(event:MouseEvent3D):void
		{
			clearSelection();

			var role:Role                 = event.target as Role;
			role.bodyUnit.showBounds      = true;
			selectedRole = role;
			// 开始拖拽
			isSelectedDragging            = true;
			// 拖拽的时候先屏蔽对role的鼠标事件
			setTargetsMouseInteractive(false);
		}

		private function onMouseMove4MoveWizard(event:MouseEvent3D):void
		{
			// 没有对象 就是正常鼠标移动
			if (_selectedRole == null || isSelectedDragging==false ) return;
			var downPos:Vector3D = event.scenePosition;
			_selectedRole.x = downPos.x;
			_selectedRole.z = downPos.z;
			_selectedRole.y = mapModel.getHeightWithRigidBody(downPos.x, downPos.z);
		}

		/** 清除当前选择 */
		public function clearSelection():void
		{
			if(draggingNewRole)
			{
				draggingNewRole.clearRole();
				draggingNewRole = null;
			}
			isSelectedDragging=false;
			if (_selectedRole)
			{
				_selectedRole.bodyUnit.showBounds = false;
				selectedRole                     = null;
			}
			if (_selectedRigidBody)
			{
				_selectedRigidBody.showBounds = false;
				isSelectedRBDragging          = false;
				selectedRigidBody            = null;
			}
			if (selectedFuncPoint)
			{
				selectedFuncPoint.showBounds = false;
				isSelectedFPDragging         = false;
				selectedFuncPoint            = null;
			}
			clearGizmo3D();
			if(curBrushType==ToolBrushType.BRUSH_TYPE_NONE)
				setTargetsMouseInteractive(true);
		}

		/** 为保障拖拽一个对象时，其它对象不影响拖拽，要清除除了地表以外的鼠标响应 */
		private function setTargetsMouseInteractive( isInteractive:Boolean ):void
		{
//			trace(StageFrame.renderIdx,"[EditorScene3DMediator]/setTargetsMouseInteractive" , isInteractive);
			for (var i:int = 0; i < rolesInScene.length; i++)
			{
				var role:Role = rolesInScene[i];
				role.mouseInteractive=isInteractive;
			}
			for (var i:int = 0; i < rigidBodiesInScene.length; i++)
			{
				var view1:RigidBodyView = rigidBodiesInScene[i];
				view1.mouseEnabled=isInteractive;
			}
			for (var i:int = 0; i < funcPointsInScene.length; i++)
			{
				var fp:FuncPointView = funcPointsInScene[i];
				fp.mouseEnabled      = isInteractive;
			}
		}

		/** 场景内现在的所有role */
		private var rolesInScene:Vector.<Role> = new <Role>[];

		///// 摄像机
		private var isStageRightMouseDown:Boolean;
		private var lastX:Number;
		private var lastY:Number;

		private function onKeyUp(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.UP:
				case Keyboard.W:
					view.camZSpeed = 0;
					break;
				case Keyboard.DOWN:
				case Keyboard.S:
					view.camZSpeed = 0;
					break;
				case Keyboard.LEFT:
				case Keyboard.A:
					view.camXSpeed = 0;
					break;
				case Keyboard.RIGHT:
				case Keyboard.D:
					view.camXSpeed = 0;
					break;
			}
		}

		private function onKeyDown(event:KeyboardEvent):void
		{
			// 对选中项的位移
			var target:Object3D = selectedTargetTransformBegin();
			if (target)
			{
				var moveStep:Number = 1.0;
				if (event.shiftKey)
					moveStep *= 10;
				switch (event.keyCode)
				{
					case Keyboard.UP:
					case Keyboard.W:
						moveTarget(target,0,-moveStep);
						break;
					case Keyboard.DOWN:
					case Keyboard.S:
						moveTarget(target,0,moveStep);
						break;
					case Keyboard.LEFT:
					case Keyboard.A:
						moveTarget(target,-moveStep,0);
						break;
					case Keyboard.RIGHT:
					case Keyboard.D:
						moveTarget(target,moveStep,0);
						break;
					case Keyboard.PAGE_UP:
						target.y += moveStep;
						break;
					case Keyboard.PAGE_DOWN:
						target.y -= moveStep;
						break;
					case Keyboard.HOME:
						target.rotationY+= moveStep;
						break;
					case Keyboard.END:
						target.rotationY-= moveStep;
						break;
				}
				// 保存移动数据
				selectedTargetTransformCommit();
			} else
			{
				switch (event.keyCode)
				{
					case Keyboard.UP:
					case Keyboard.W:
						view.camZSpeed = 1;
						break;
					case Keyboard.DOWN:
					case Keyboard.S:
						view.camZSpeed = -1;
						break;
					case Keyboard.LEFT:
					case Keyboard.A:
						view.camXSpeed = -1;
						break;
					case Keyboard.RIGHT:
					case Keyboard.D:
						view.camXSpeed = 1;
						break;
				}
			}
		}

		private var _tmpPoint:Point=new Point();
		[Inline]
		private final function moveTarget(target:Object3D,zStep:Number, xStep:Number):void
		{
			view.calcMixedSpeed(zStep,xStep,_tmpPoint);
			target.x += _tmpPoint.x;
			target.z+=_tmpPoint.y;
		}

		private function onUI_EDITOR_MOVE_CAM( n: * ):void
		{
			//  移动镜头
			view.lookAtMapPercent(n.data);
		}

		private function onViewCamMoved(e:*):void
		{
			dispatchWith(NotifyConst.SCENE_CAM_MOVED,false,view.lookPercentTile);
		}

		private function onMouseWheel(event:MouseEvent):void
		{
			view.camForward(event.delta);
		}

		private function onStageRightMouseDown(event:MouseEvent):void
		{
			isStageRightMouseDown = true;
			lastX                 = StageFrame.stage.mouseX;
			lastY                 = StageFrame.stage.mouseY;
		}

		private function onStageRightMouseUp(event:MouseEvent):void
		{
			isStageRightMouseDown = false;
		}

		private function onStageMouseMove(event:MouseEvent):void
		{
			// 摄像机
			if (isStageRightMouseDown/* && curBrushType == ToolBrushType.BRUSH_TYPE_NONE*/)
			{
				// 移动摄像机
				var deltaX:Number = StageFrame.stage.mouseX - lastX;
				var deltaY:Number = StageFrame.stage.mouseY - lastY;
				lastX             = StageFrame.stage.mouseX;
				lastY             = StageFrame.stage.mouseY;
				view.dragRoll(deltaX, deltaY);
			}
		}

		private function onMouseMove(event:MouseEvent3D):void
		{
			//位置
			mapModel.setCurMousePos(event.scenePosition);
			// 刷子
			onMouseMove4Brush(event);
			// 拖拽实体模型
			onMouseMove4NewWizard(event);
			// 拖拽已有实体
			onMouseMove4MoveWizard(event);
			//拖拽刚体
			onMouseMoveRigidBody(event);
			// 拖拽功能点
			onMouseMoveFuncPoint(event);
		}
		
		/// 探测指示

		private function onMouseOutAnything(event:MouseEvent3D):void
		{
			view.mousePointTrack.updateAABB(null);
		}
		private function onMouseOverAnything( event:MouseEvent3D ):void {
			if(isSelectedDragging|| isSelectedRBDragging || isSelectedFPDragging) return;
			view.mousePointTrack.updateAABB(event);
		}
		private function onMouseMoveAll(event:MouseEvent3D):void
		{
			view.mousePointTrack.update(event);
		}


		// #pragma mark --  图刷子  ------------------------------------------------------------

		private function onMouseMove4Brush(event:MouseEvent3D):void
		{
			if (brushView && brushView.parent)
			{
				var downPos:Vector3D = event.scenePosition;
				brushView.x          = downPos.x;
				brushView.z          = downPos.z;
				brushView.y =  mapModel.getHeight(downPos.x, downPos.z);
				// 除了地形高度刷100ms一次，区域刷子移动也执行 并且其它刷子y要设置 TODO 区域刷子移动也不够，要能改大小
				if(_isBrushPressed &&
						(curBrushType == curBrushType== ToolBrushType.BRUSH_TYPE_ZONE))
				{
					doBrush();
				}
			}
		}

		private function onMouseUp(event:MouseEvent3D):void
		{
			isBrushPressed = false;
		}

		private function onMouseDown(event:MouseEvent3D):void
		{
			clearSelection();
			var downPos:Vector3D = event.scenePosition;
			if (curBrushType == ToolBrushType.BRUSH_TYPE_HEIGHT || curBrushType == ToolBrushType.BRUSH_TYPE_TERRAINTEXTURE || curBrushType== ToolBrushType.BRUSH_TYPE_ZONE)
			{
				doBrush();
				isBrushPressed = true;
			}
		}

		// #pragma mark --  刷子工具  ------------------------------------------------------------
		/**当前笔刷用途*/
		private var curBrushType:int    = ToolBrushType.BRUSH_TYPE_NONE;
		/** 刷子工具 */
		private var brushView:BrushView = null;

		private function onToolBrush(n:TLEvent):void
		{
			clearSelection();

			if (brushView == null)
			{
				brushView = new BrushView();
			}
			view.coverView.addChild(brushView);
			curBrushType = n.data;
			// 恢复球不在的期间的数值
			brushView.brushSize = mapModel.brushSize;
			if(curBrushType== ToolBrushType.BRUSH_TYPE_HEIGHT)
			{
				brushView.brushStrong = mapModel.brushStrong;
			}else if (curBrushType == ToolBrushType.BRUSH_TYPE_TERRAINTEXTURE)
			{
				brushView.brushSplatPower = mapModel.brushSplatPower;
			}else if (curBrushType == ToolBrushType.BRUSH_TYPE_ZONE )
			{
				view.terrainView.isShowZone=true;
				view.lookDown();
			}
			// 刷子阶段 不监听其它鼠标单击
			setTargetsMouseInteractive( false );

		}

		private function onToolBrushSoftness(n:*):void
		{
			mapModel.brushSoftness = n.data;
		}
		private function onToolBrushSplatPower(n:*):void
		{
			trace(StageFrame.renderIdx,"[EditorScene3DMediator]/onToolBrushSplatPower alpha强度",n.data);
			mapModel.brushSplatPower = n.data;
			if(brushView) brushView.brushSplatPower = n.data;
		}
		private function onToolBrushStrong(n:*):void
		{
			mapModel.brushStrong = n.data;
			if(brushView)
			{
				brushView.brushStrong = n.data;
				trace(StageFrame.renderIdx,"[EditorScene3DMediator]/onToolBrushStrong 笔刷强度",n.data);
			}
		}
		private function onToolBrushSize( n: * ):void
		{
			mapModel.brushSize = n.data;
			if (brushView)
			{
				brushView.brushSize = n.data;
				trace(StageFrame.renderIdx,"EditorScene3DMediator/onToolBrushSize 笔刷大小", n.data);
			}
		}
		private function onToolBrushSizeAdd(n:TLEvent):void
		{
			mapModel.brushSize += n.data;
			if (brushView)
			{brushView.brushSize += n.data;}
		}

		private function onTOOL_BRUSH_H_MAX( n: * ):void
		{
			mapModel.brushHeightMax = n.data;
		}
		private function onTOOL_BRUSH_H_MIN( n: * ):void
		{
			mapModel.brushHeightMin = n.data;
		}

		// #pragma mark --  周期性 刷图  ------------------------------------------------------------

		private var brushTimer:Timer;
		private var _isBrushPressed:Boolean = false;

		/** 刷子按下时 周期调用 */
		private function doBrush():void
		{
			if (curBrushType == ToolBrushType.BRUSH_TYPE_HEIGHT)
			{
				mapModel.useHeightBrush(brushView.x, brushView.z, mapModel.brushStrong, mapModel.brushSize);
				// 显示 地形
				view.terrainView.isHeightDirty = true;
				// 区域
				view.zoneView.isHeightDirty = true;
			} else if (curBrushType == ToolBrushType.BRUSH_TYPE_TERRAINTEXTURE)
			{
				// 刷子的真实层 和强度  纹理刷强度是 0.01~1.00 之间
				mapModel.useTextureBrush(mapModel.curTextureBrushLayerIndex, brushView.x, brushView.z, mapModel.brushSplatPower, mapModel.brushSize, mapModel.brushSize*mapModel.brushSoftness);
			} else if(curBrushType == ToolBrushType.BRUSH_TYPE_ZONE)
			{
				// 画区域(阻挡等)
				mapModel.setZoneType(brushView.x ,brushView.z , mapModel.curZoneType,mapModel.brushSize);
			} else
			{
				// ...
			}
		}

		public function get isBrushPressed():Boolean
		{
			return _isBrushPressed;
		}

		public function set isBrushPressed(value:Boolean):void
		{
			if (value == _isBrushPressed) return;

			_isBrushPressed = value;
			if (brushTimer == null)
			{
				brushTimer = new Timer(100);
				brushTimer.addEventListener(TimerEvent.TIMER, onBrushTimer);
			}
			if (_isBrushPressed)brushTimer.start();
			else brushTimer.stop();
		}

		private function onBrushTimer(event:TimerEvent):void
		{
			doBrush();
		}


		// #pragma mark --  刚体  ------------------------------------------------------------

		/** 请求添加刚体， 让用户鼠标放置 */
		private function onNewRigidBody(n:TLEvent):void
		{
			// 不是实际放置，而是先比划一下 ，实际放置的时候找model
			clearSelection();
			var vo:RigidBodyVO = new RigidBodyVO();
			_selectedRigidBody = new RigidBodyView(vo);
			view.addChild(_selectedRigidBody);
			rigidBodiesInScene.push(_selectedRigidBody);
			mapModel.addRigidBody(vo);
			// 提交后监听鼠标点击可选中
			isSelectedRBDragging           = true;
			isNewRigidBody                 = true;
			_selectedRigidBody.addEventListener(MouseEvent3D.MOUSE_DOWN, onRigidBodyMouseDown);
			setTargetsMouseInteractive(false);
		}
		private function onToolRigidBodySizeAdd( n: TLEvent):void
		{
			if(_selectedRigidBody)
			{
				var deltaScale :Number = n.data;
				_selectedRigidBody.scaleX *=  deltaScale;
				_selectedRigidBody.scaleZ *=  deltaScale;
				_selectedRigidBody.commit();
			}
		}

		private function onToolRigidBodyRotated(n:TLEvent):void
		{
			if (_selectedRigidBody)
			{
				var deltaRot:Number = n.data;
				_selectedRigidBody.rotationY += deltaRot;
				_selectedRigidBody.commit();
			}
		}

		private function onRigidBodyMouseDown(event:MouseEvent3D):void
		{
			clearSelection();
			selectedRigidBody            = event.target as RigidBodyView;
			_selectedRigidBody.showBounds = true;
			isSelectedRBDragging          = true;
			setTargetsMouseInteractive(false);
		}

		private function onMouseMoveRigidBody(event:MouseEvent3D):void
		{
			if (_selectedRigidBody == null || isSelectedRBDragging == false) return;
			if (_selectedRigidBody.parent != null)
			{
				var downPos:Vector3D = event.scenePosition;
				_selectedRigidBody.x = downPos.x;
				_selectedRigidBody.z = downPos.z;
				if (isNewRigidBody)
				{
					_selectedRigidBody.y = mapModel.getHeight(downPos.x, downPos.z);
				} else
				{
					// 移动现有的，则不控制y
				}
				_selectedRigidBody.commit();
			}
		}

		private function onStageMouseUp4RigidBody(event:MouseEvent):void
		{
			if (_selectedRigidBody)
			{
				isSelectedRBDragging           = false;
				isNewRigidBody                 = false;
				setTargetsMouseInteractive(true);
				//
				gizmoSetTarget(_selectedRigidBody);
			}
		}

		private var isNewRigidBody:Boolean                    = false;
		private var isSelectedRBDragging:Boolean              = false;
		private var _selectedRigidBody:RigidBodyView;
		private var rigidBodiesInScene:Vector.<RigidBodyView> = new <RigidBodyView>[];

		private function removeAllRigidBodies():void
		{

			for (var i:int = 0; i < rigidBodiesInScene.length; i++)
			{
				var view1:RigidBodyView = rigidBodiesInScene[i];
				view1.disposeWithChildren();
			}
			rigidBodiesInScene   = new Vector.<RigidBodyView>();
			isNewRigidBody       = false;
			isSelectedRBDragging = false;
			_selectedRigidBody   = null;
		}

		// #pragma mark --  放置点		  ------------------------------------------------------------
		private var funcPointsInScene:Vector.<FuncPointView> = new Vector.<FuncPointView>();
		private var selectedFuncPoint:FuncPointView;
		private var isNewFuncPoint:Boolean                   = false;
		private var isSelectedFPDragging:Boolean             = false;

		private function removeAllFuncPoints():void
		{
			for (var i:int = 0; i < funcPointsInScene.length; i++)
			{
				var fp:FuncPointView = funcPointsInScene[i];
				fp.dispose();
			}
			funcPointsInScene    = new Vector.<FuncPointView>();
			selectedFuncPoint    = null;
			isNewFuncPoint       = false;
			isSelectedFPDragging = false;
		}

		private function onAddFuncPoint(n:*):void
		{
			clearSelection();
			var vo:FuncPointVO = new FuncPointVO();
			vo.type = n.data;
			selectedFuncPoint  = new FuncPointView(vo);
			view.addChild(selectedFuncPoint);
			funcPointsInScene.push(selectedFuncPoint);
			mapModel.addFuncPoint(vo);
			// 提交后监听鼠标点击可选中
			isSelectedFPDragging = true;
			isNewFuncPoint       = true;
			selectedFuncPoint.addEventListener(MouseEvent3D.MOUSE_DOWN, onFuncPointMouseDown);
			setTargetsMouseInteractive(false);
		}

		private function onFuncPointMouseDown(e:MouseEvent3D):void
		{
			clearSelection();
			selectedFuncPoint            = e.target as FuncPointView;
			selectedFuncPoint.showBounds = true;
			isSelectedFPDragging         = true;
			setTargetsMouseInteractive(false);
		}

		private function onMouseMoveFuncPoint(event:MouseEvent3D):void
		{
			if (selectedFuncPoint == null || isSelectedFPDragging == false) return;
			if (selectedFuncPoint.parent != null)
			{
				var downPos:Vector3D = event.scenePosition;
				selectedFuncPoint.vo.tileX  = mapModel.mouseTilePos.x;
				selectedFuncPoint.vo.tileY = mapModel.mouseTilePos.y;
				selectedFuncPoint.y = mapModel.getHeight(downPos.x, downPos.z);
				selectedFuncPoint.validate();
			}
		}

		private function onStageMouseUp4FuncPoint(event:MouseEvent):void
		{
			if (selectedFuncPoint)
			{
				isSelectedFPDragging           = false;
				isNewFuncPoint                 = false;
				setTargetsMouseInteractive(true);
			}
		}

		// #pragma mark --  使用选择工具  ------------------------------------------------------------

		private function onToolSelect(n:TLEvent):void
		{
			curBrushType   = ToolBrushType.BRUSH_TYPE_NONE;
			isBrushPressed = false;
			//
			if (brushView && brushView.scene)
			{
				brushView.parent.removeChild(brushView);
			}
			//
			// 选择阶段 监听其它鼠标单击
			setTargetsMouseInteractive(true);
		}

		public function set selectedRole(value:Role):void
		{
//			if(value)
				dispatchWith(NotifyConst.NEW_WIZARD_UI, false, value)
			_selectedRole = value;
		}

		public function set selectedRigidBody(value:RigidBodyView):void
		{
//			if(value)
				dispatchWith(NotifyConst.NEW_WIZARD_UI, false, value)
			_selectedRigidBody = value;
		}
	}
}
