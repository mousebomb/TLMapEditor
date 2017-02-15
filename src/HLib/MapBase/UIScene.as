package HLib.MapBase
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import HLib.Event.Dispatcher_F;
	import HLib.Event.Event_F;
	import HLib.Tool.HFrameWorker;
	import HLib.UICom.Away3DUICom.HIcon3D;
	import HLib.UICom.BaseClass.HTopBaseView;
	import HLib.WizardBase.HObject3DPool;
	
	import Modules.Wizard.WizardActor3D;
	import Modules.Wizard.WizardObject;
	
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.OrthographicLens;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.base.Object3D;
	import away3d.core.managers.Stage3DProxy;
	import away3d.events.MouseEvent3D;
	
	public class UIScene extends Scene3D
	{
		private static var _MyInstance:UIScene;
		
		private var _view3D:View3D;						        //３d模型界面
		
		private var _Camera3D:Camera3D;			  //摄像机
		private var _WizardArgs:Array = new Array();              //地图所有精灵数组
		private var _IsShow:Boolean = false;
		private var _prevMouseX:Number;
		private var _prevMouseY:Number;
		private var _mouseMove:Boolean;
		private var _showWizardActor:WizardActor3D;
		private var _iconArr:Array = [];
		
		private var _frameWorker:HFrameWorker;
		
		public function UIScene()
		{
			_frameWorker = new HFrameWorker();
		}
		
		public static function getInstance():UIScene 
		{
			return _MyInstance ||= new UIScene();
		}
		
		public function get mySView3D():View3D
		{
			return _view3D;
		}
		
		public function get camera3D():Camera3D  
		{  
			return _Camera3D;  
		}
		
		public var stage:Stage;
		private var _lens:OrthographicLens;
		public function InIt(paren:DisplayObjectContainer, proxy:Stage3DProxy):void
		{
			_lens = new OrthographicLens();
//			_lens.near = 0.1;
			_Camera3D = new Camera3D();
			_Camera3D.lens = _lens;
			_Camera3D.z = -1000;
//			_Camera3D.rotationX = 10;
			
			_Camera3D.y = 250;
			_Camera3D.lookAt(new Vector3D());
			
			_view3D = new View3D(this, _Camera3D);			
			_view3D.stage3DProxy = proxy;
			_view3D.shareContext = true;
			_view3D.layeredView = true;
			_view3D.antiAlias = 2;
			
			paren.addChild(_view3D);
			
			stage = paren.stage;
			Dispatcher_F.getInstance().addEventListener("UIActor3DPoint",onUIActor3DPoint);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseLeave);
			
			setWH(stage.stageWidth, stage.stageHeight);
		}
		
		
		private function onStageMouseDown(ev:MouseEvent):void
		{
			_prevMouseX = ev.stageX;
			_prevMouseY = ev.stageY;
			_mouseMove = true;
		}
		
		private function onStageMouseLeave(event:MouseEvent):void
		{
			_showWizardActor = null;
			_mouseMove = false;
		}
		
		private function onStageMouseMove(ev:MouseEvent):void
		{
			if(HTopBaseView.getInstance() && (HTopBaseView.getInstance().hasEvent || HTopBaseView.getInstance().isShowFull))
			{
				return
			}
			if (_mouseMove && _showWizardActor) 
			{
				_showWizardActor.showRotationY -= (ev.stageX - _prevMouseX);
			}
			_prevMouseX = ev.stageX;
			_prevMouseY = ev.stageY;
		}
		
		private function onUIActor3DPoint(e:Event_F):void
		{
			var role3DNameStr:String = e.data.role3DNameStr as String;
			var _Point:Point = e.data.rolePoint as Point;
			this.setWizardPosition(role3DNameStr, _Point);
		}
		
		/**帧渲染显示3d场景*/	
		public function render(force:Boolean = false):void
		{
			if(!_IsShow && force == false) 
			{
				return;
			}
			if (_view3D)
			{
				_view3D.render();
			}
		}
		
		private const cameraZ:Number = 1000;
		public function getWizard3DPoint(point:Point):Vector3D
		{
			var v3d:Vector3D = _view3D.unproject(point.x, point.y, cameraZ);
			return v3d;
		}
		
		/**设置精灵位置*/
		public function setWizardPosition(wizardName:String, point:Point):void
		{
			var _WizardActor:WizardActor3D = this.getWizard(wizardName);
			if(!_WizardActor)
			{
				return;
			}
			var v3d:Vector3D = _view3D.unproject(point.x, point.y, cameraZ);
			_WizardActor.position = v3d;
		}
		
		/**设置精灵位置*/
		public function setWizardXY(tmpActor:Object3D, tx:Number, ty:Number, tz:Number = 0):void
		{
			tz = tz ? tz : cameraZ;
			var v3d:Vector3D = _view3D.unproject(tx, ty, tz);
			tmpActor.position = v3d;
		}
		
		/**设置精灵朝向*/
		public function setWizardRotationY(wizardName:String, rotationY:Number):void
		{
			var _WizardActor:WizardActor3D = this.getWizard(wizardName);
			if(!_WizardActor)
			{
				return;
			}
			_WizardActor.showRotationY = rotationY;
		}
		
		/**隐藏指定精灵*/
		public function hideWizard(wizardName:String):void
		{
			var actor:WizardActor3D = this.getWizard(wizardName);
			if(!actor) 
			{
				return;
			}
			actor.visible = false;
			actor.mouseChildren = false;
			updateIsshow()
		}
		
		/**显示指定精灵*/
		public function showWizard(wizardName:String):void
		{
			var _WizardActor:WizardActor3D = this.getWizard(wizardName);
			if(!_WizardActor)
			{
				return;
			}
			_WizardActor.visible = true;
			_WizardActor.mouseChildren = true;
			_IsShow = true;
		}
		
		/**
		 * 创建精灵 
		 * @param id 编号
		 * @param direc 方向
		 * 
		 */
		public function CreateWizard(wizardId:String, wizardName:String, isShowName:Boolean = false):WizardActor3D
		{
			var actor:WizardActor3D = this.getWizard(wizardName);
			_IsShow = true;
			if(actor)
			{
				actor.mouseChildren = true;
				actor.visible = true;
				return actor;
			}
			var wizardObject:WizardObject = new WizardObject();
			wizardObject.refreshByTable(wizardId);
			wizardObject.isUI = true;
			if(!isShowName)
			{
				wizardObject.type = -1;
				wizardObject.wizardNameColor = null;
			}
			actor = HObject3DPool.getInstance().getWizardActor3D();//new WizardActor3D();//
			actor.name = wizardName
			wizardObject.Entity_UID = -1;
			actor.actor3DInIt(wizardObject);
			actor.loadStart();
			if(actor.wizardNameUnit)
			{
				actor.wizardNameUnit.isShowHp = false;
				if(actor.wizardNameUnit.vipIcon)
				{
					actor.wizardNameUnit.vipIcon.visible = false;
				}
				if(actor.wizardNameUnit.rankIcon)
				{
					actor.wizardNameUnit.rankIcon.visible = false;
				}
			}
			this.AddWizard(actor);
			return actor;
		}
		/**
		 * 创建精灵 
		 * @param id 编号
		 * @param direc 方向
		 * 
		 */
		public function CreateWizardByObject(wizardObj:WizardObject, wizardName:String):WizardActor3D
		{
			wizardObj.isUI = true;
			var actor:WizardActor3D = this.getWizard(wizardName);
			_IsShow = true;
			if(actor)
			{
				actor.visible = true;
				actor.mouseChildren = true;
				return actor;
			}
			actor = HObject3DPool.getInstance().getWizardActor3D();//new WizardActor3D();//
			actor.name = wizardName
			wizardObj.Entity_UID = -1;
			actor.actor3DInIt(wizardObj);
			actor.loadStart();
			actor.createNameBar();
			if(actor.wizardNameUnit)
			{
				actor.wizardNameUnit.isShowHp = false;
				if(actor.wizardNameUnit.vipIcon)
				{
					actor.wizardNameUnit.vipIcon.visible = false;
				}
				if(actor.wizardNameUnit.rankIcon)
				{
					actor.wizardNameUnit.rankIcon.visible = false;
				}
			}
			this.AddWizard(actor);
			return actor;
		}
		/**
		 * 添加精灵 
		 * @param _Wizard	: 需要添加到场景的精灵
		 */
		public function AddWizard(actor:WizardActor3D):void
		{
			_IsShow = true;
			if(_WizardArgs.indexOf(actor) > -1)
			{
				return;
			}
			_WizardArgs.push(actor);
			this.addChild(actor);
			
			actor.myMouseEnabled = true;
			actor.bodyUnit.mouseEnabled = true;
			actor.addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDown);
		}
		
		public function addBodyunitEvent(wizardActor3D:WizardActor3D):void
		{
			wizardActor3D.myMouseEnabled = true;
			wizardActor3D.mouseEnabled = true;
			wizardActor3D.addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDown);
		}
		
		protected function onMouseDown(event:MouseEvent3D):void
		{
			_showWizardActor = WizardActor3D(event.target);
		}
		
		/**移除背景*/
		public function getWizard3dBg(point:Point, type:String = "function_open_bg"):HIcon3D
		{
			var icon:HIcon3D = getIconByType(type);
			if(!icon)
			{
				icon = HObject3DPool.getInstance().getHIcon3D();//new HIcon3D;
				icon.type = "function_open_bg";	
				icon.scaleX = icon.scaleY = icon.scaleZ = .5
			}
			var v3d:Vector3D = _view3D.unproject(point.x, point.y, cameraZ + 50);
			icon.position = v3d;
			icon.rotationX = -90;
			icon.visible = true;
			this.addChild(icon);
			return icon
		}
		
		/**添加背景*/
		public function removeWizard3dBg(icon:HIcon3D):void
		{
			icon.visible = false;
			_iconArr.push(icon);
		}
		
		private function getIconByType(type:String):HIcon3D
		{
			var icon:HIcon3D
			var leng:int = _iconArr.length;
			for(var i:int = 0; i < leng; i++)
			{
				if(_iconArr[i].type == type)
				{
					icon = _iconArr.pop();
					break;
				}
			}
			return icon;
		}
		/**
		 * 移除精灵
		 * @param _WizardActor
		 */		
		public function removeWizard(actor:WizardActor3D):void
		{
			if(!actor || !actor.wizardObject)
			{
				return;
			}
			actor.mouseChildren = false;
			var index:int = _WizardArgs.indexOf(actor);
			if(index == -1)
			{
				return;
			}
			_WizardArgs.splice(index,1);
			actor.removeEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDown);
			actor.resetWizard();
			actor.dispose();
			//			HObject3DPool.getInstance().recoverWizardActor3D(actor);
			updateIsshow();
		}
		/**是否需要刷新*/
		private function updateIsshow():void
		{
			for each(var _WizardActor3D:WizardActor3D in _WizardArgs)
			{
				if(_WizardActor3D.visible)
				{
					_IsShow = true;
					
					return ;
				}
			}
			_IsShow = false;
		}
		
		/**
		 * 释放精灵对象 
		 * @param _Wizard	: 需要释放的精灵
		 * @param isDestroy	: 是否释放资源
		 */		
		public function DisopWizard(actor:WizardActor3D):void
		{
			var index:int = _WizardArgs.indexOf(actor);
			if(index == -1)
			{
				return;
			}
			_WizardArgs.splice(index,1);
			actor.removeEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDown);
			actor.resetWizard();
			actor.dispose();
			//			HObject3DPool.getInstance().recoverWizardActor3D(actor);
			updateIsshow();
		}
		
		/**
		 * 获取精灵对象 
		 * @param uid	: 精灵的UID
		 */		
		public function getWizard(wizardName:String):WizardActor3D
		{
			for each(var _WizardActor3D:WizardActor3D in _WizardArgs)
			{
				if(_WizardActor3D.name==wizardName)
				{
					return _WizardActor3D;
				}
			}
			return null;
		}
		
		
		public function setWH(w:Number, h:Number):void
		{
			if (_view3D)
			{
				_view3D.height = h;
				_view3D.width = w;
				
				_lens.projectionHeight = h * 0.6;
				
//				_view3D.render();
			}
		}
		
		public function get MyHFrameWorker():HFrameWorker
		{
			return _frameWorker;
		}
		
		public function get isShowWizardObjedt():Boolean
		{
			for each(var _WizardActor3D:WizardActor3D in _WizardArgs)
			{
				if(_WizardActor3D.parent)
				{
					var index:int = _WizardActor3D.name.indexOf('功能开放预览模型');
					if( index < 0)
						return true;
				}
			}
			return false;
		}
	}
}