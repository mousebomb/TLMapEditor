package HLib.UICom.BaseClass
{
	import com.greensock.TweenLite;
	
	import flash.geom.Point;
	
	import HLib.DataUtil.HashMap;
	import HLib.Tool.HFrameWorkerManager;
	import HLib.UICom.Component.HScrollBar;
	import HLib.UICom.Component.Icons.HItemTips;
	
	import Modules.BloodVein.view.BloodVienWindow;
	import Modules.Common.IResourceBar;
	import Modules.MainFace.MainInterfaceManage;
	import Modules.MainFace.RaderMap.Tips3dManage;
	import Modules.Map.InitLoaderMapResControl;
	import Modules.Mount.MountWindow;
	import Modules.NewFortress.Window.NewFortressConstruction;
	import Modules.NewFortress.Window.NewFortressShop;
	import Modules.NewFortress.Window.NewFortressSupportModel;
	import Modules.Rank.view.RankWindow;
	import Modules.Shop.view.NpcShop;
	import Modules.alchemist.AlchemistWindow;
	import Modules.answer.ui.AnswerRankWindow;
	import Modules.material.MaterialWindow;
	import Modules.view.EquiptStrongWindow;
	import Modules.view.IconBag;
	import Modules.view.MyRolePanel;
	import Modules.view.OtherRolePanel;
	import Modules.view.SelectReviveWindow;
	import Modules.view.task.HTaskLinkText;
	import Modules.view.task.TaskWindow;
	import Modules.view.transact.CheckStallWindow;
	import Modules.view.transact.StallWindow;
	import Modules.view.transact.TransactWindow;
	
	import starling.core.RenderSupport;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Stage;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public dynamic class HBaseView extends HSprite
	{
		private static var MyInstance:HBaseView;
		public static var isComplete:Boolean;
		private var _Stage:Stage;
		private var _HashMap:HashMap=new HashMap();
		private var _ShowFun:Function;
		private var _HideFun:Function;
		private var _tips:HItemTips;
		private var _maxNum:int = 8;					//最大显示界面
		private var _childrenVector:Vector.<HWindow> = new <HWindow>[];
		private var _isClickStarling:Boolean; 			//点击界面了
		private var _isMoveStarling:Boolean;
		private var _oldObj:String;						//旧显示窗口
		private var _lastObj:String;					//当前显示窗口
		private var _hitTestPoint:Point = new Point;
		private var _isBegan:Boolean;					//点击结束
		private var _isMove:Boolean;					//移动鼠标
		public var myTouchable:Boolean = true;					//当前鼠标事件
		/**
		 * 开发者：黄栋 
		 * 基本视图类，做为其它显示对象的容器使用
		 */
		public function HBaseView()
		{
			if( MyInstance ){
				throw new Error ("单例只能实例化一次,请用 getInstance() 取实例。");
			}
			MyInstance=this;
			this.name = 'HBaseView'
		}
		public static function getInstance():HBaseView 
		{
			/*if ( MyInstance == null ) 
			{				
				MyInstance = new HBaseView();
			}*/
			return MyInstance;
		}
		public function InIt(w:int,h:int):void{
			if(!isComplete)
				this.addEventListener(TouchEvent.TOUCH, onTouch);
			isComplete = true;
			this.myWidth=w;
			this.myHeight=h;
			if(_lastObj)
			{//同步坐标
				if(_oldObj)
				{
					if(this[_lastObj] is IconBag || this[_lastObj] is NewFortressSupportModel)
						MainInterfaceManage.getInstance().tweenLiteEffectMoveWindow(this[_oldObj], this[_lastObj]);
					else
						MainInterfaceManage.getInstance().tweenLiteEffectMoveWindow(this[_lastObj], this[_oldObj]);
				}	else {
					MainInterfaceManage.getInstance().tweenLiteEffectMoveWindow(this[_lastObj]);
				}
			}
			
		}
		
		private function onTouch(e:TouchEvent):void
		{
			if(HTopBaseView.getInstance().hasEvent || HTopBaseView.getInstance().isShowFull)
			{
				return;//事件穿透
			}
			if(InitLoaderMapResControl.getInstance().isInitLoading)//
				return;
			var touch:Touch
			touch = e.getTouch(this)
			if(!touch)
			{
				if(_isMoveStarling)
					isMoveStarling = false;
			}
			touch = e.getTouch(this, TouchPhase.HOVER)
			if(touch)
			{
				if(!_isMoveStarling)
					isMoveStarling = true;
			}
				
			touch = e.getTouch(this,TouchPhase.BEGAN);
			if(touch)
			{
				_isBegan = true;
				if(touch.target is Image){
					
					touch = e.getTouch(this["_MainFace_ChatPanel"],TouchPhase.BEGAN);
					if(touch) {
						var flg:Boolean = this["_MainFace_ChatPanel"].isClickMe;
						if(!flg)
						{
							if(_isMoveStarling)
								isMoveStarling = false;
						}
					}	else  { 
						if(!_isMoveStarling)
							isMoveStarling = true;
					}
						
				}	else if(touch.target is HTaskLinkText) {
					if(!_isMoveStarling)
						isMoveStarling = true;
				}	else {
					touch = e.getTouch(this["_MainFace_ChatPanel"],TouchPhase.BEGAN);
					if(touch)
					{
						flg = this["_MainFace_ChatPanel"].isClickMe;
						if(!flg)
							isMoveStarling = false;
					}	else {
						touch = e.getTouch(this["_MainFace_TaskPanel"],TouchPhase.BEGAN);
						if(touch)
						{
							if(e.target is HScrollBar)
							{
								if(_isMoveStarling)
									isMoveStarling = false;
							}	else {
								if(!_isMoveStarling)
									isMoveStarling = true;
							}
						} 	else  {
							if(!_isMoveStarling)
								isMoveStarling = true;
						}
					}
						
				}
			}
			if(_isBegan)
			{
				if(_isMove)
				{
					touch = e.getTouch(this,TouchPhase.ENDED);
					if(touch)
					{
						_isBegan = false;
						_hitTestPoint.x = touch.globalX;
						_hitTestPoint.y = touch.globalY;
						var hit:* = this.hitTest(_hitTestPoint)
						if(!hit)
						{
							flg = false;
							isMoveStarling = false;
						}
					}
				}
				touch = e.getTouch(this,TouchPhase.MOVED);
				if(touch)
					_isMove = true;
				
			}
		}
		/**
		 * 模态显示内容
		 * @param displayerObject	: 显示内容
		 */		
		public function showModuleObject(displayerObject:DisplayObject):void
		{
			this.addChild(displayerObject);
		}
		/**
		 * 隐藏模态内容
		 * @param displayerObject	: 显示内容
		 */		
		public function hideModuleObject(displayerObject:DisplayObject):void
		{
			//移除显示窗口
			if(displayerObject.parent)
				displayerObject.parent.removeChild(displayerObject);
		}
		
		/**
		 * 注册对象
		 * @param objectName　     模块名
		 * @param objectClass      模块类型
		 * @param initFun　　      初始化时是否需要执行的方法
		 * @param parArgs　　      [宽度,高度]宽高数组
		 * @param showWeights　　  显示的权重，权重越高越不容易被其它对象覆盖
		 * 
		 * 示例HBaseView.getInstance.Register("_MainFace_ToolBar",MainFace_ToolBar,"InIt");
		 */
		public function Register(objectName:String,objectClass:Class,initFun:String=null,parArgs:Array=null,showWeights:int=0):Boolean{
			if(this.hasOwnProperty(objectName)) return false;
			this[objectName]=new objectClass();
			_HashMap.put(objectName,showWeights);
			if(initFun){
				if(parArgs){
					this[objectName][initFun](parArgs);
				}
				else{
					this[objectName][initFun]();
				}			
			}
			return true;
		}
		/**
		 * 注销对象 
		 * @param objectName 模块名
		 * @param initFun    注销时是否需要执行的方法
		 * @return 
		 * 
		 */
		public function Canceled(objectName:String,initFun:String=null):Boolean{
			if(!this.hasOwnProperty(objectName)) return false;
			if(initFun){
				this[objectName][initFun]();
			}
			if(this[objectName] is DisplayObject){
				this.removeChild(this[objectName]);
			}
			this[objectName]=null;
			return true;
		} 
		
		/**
		 * 显示指定的对象 
		 * @param objectName 对象名称
		 * @param tobjectName 并排显示对象名称
		 * @return 
		 * 
		 */
		public function ShowObject(objectName:String,tobjectName:String=null):Boolean
		{
			Tips3dManage.myInstance.hideTips();
			if((this[objectName] is MyRolePanel && this[_oldObj] is IconBag) || (this[objectName] is IconBag && this[_oldObj] is MyRolePanel))
			{
				if(_lastObj)
					HideObject(_lastObj);
				_lastObj = _oldObj;
			}	else if((this[objectName] is EquiptStrongWindow && this[_oldObj] is MaterialWindow) || (this[objectName] is MaterialWindow && this[_oldObj] is EquiptStrongWindow)){
				if(_lastObj)
					HideObject(_lastObj);
				_lastObj = _oldObj;
			}	else if((this[objectName] is MountWindow && this[_oldObj] is IconBag) || (this[objectName] is IconBag && this[_oldObj] is MountWindow)){
				if(_lastObj)
					HideObject(_lastObj);
				_lastObj = _oldObj;
			}   else if((this[objectName] is AlchemistWindow && this[_oldObj] is IconBag) || (this[objectName] is IconBag && this[_oldObj] is AlchemistWindow)){
				if(_lastObj)
					HideObject(_lastObj);
				_lastObj = _oldObj;
			}	else if((this[objectName] is BloodVienWindow && this[_oldObj] is IconBag) || (this[objectName] is IconBag && this[_oldObj] is BloodVienWindow)){
				if(_lastObj)
					HideObject(_lastObj);
				_lastObj = _oldObj;
			}	else if(this[objectName] is OtherRolePanel && this[_oldObj] is RankWindow){
				_lastObj = _oldObj;
			}	else if(this[objectName] is IconBag && this[_oldObj] is TransactWindow){
				_lastObj = _oldObj;
			}	else if(this[objectName] is NpcShop && this[_oldObj] is IconBag){
				if(this[_lastObj] is AlchemistWindow)
					HideObject(_lastObj);
				_lastObj = _oldObj;
			}	else if(this[objectName] is CheckStallWindow && this[_oldObj] is IconBag){
				_lastObj = _oldObj;
			}	else if(this[objectName] is StallWindow && this[_oldObj] is IconBag){
				_lastObj = _oldObj;
			}	else if(this[objectName] is NewFortressConstruction && this[_oldObj] is NewFortressSupportModel){
				_lastObj = _oldObj;
			}	else if(this[objectName] is NewFortressShop && this[_oldObj] is NewFortressSupportModel){
				_lastObj = _oldObj;
			}	else if(this[objectName] is IconBag && this[_oldObj] is CheckStallWindow){
				_lastObj = _oldObj;
			}	else if(_oldObj && _oldObj != objectName) {
				if(_lastObj && _lastObj != objectName) {
					HideObject(_lastObj);
					_lastObj = null
				}
				HideObject(_oldObj);
				_oldObj = null
			}
			if(!this.hasOwnProperty(objectName)) return false;
			if(tobjectName!=null){
				if(!this.hasOwnProperty(tobjectName)) return false;
			}			
			if(this[objectName]==null) return false;
			if(tobjectName && this[tobjectName]==null) return false;//if(this[tobjectName]=null) return false;
			if(!this[objectName] is DisplayObject) return false;
			if(!this[tobjectName] is DisplayObject) return false;
			
			if(this[objectName] is HWindow)
				_oldObj = objectName;
			if(this[objectName] is HSprite){
				if(this[objectName] is AnswerRankWindow)
					_lastObj = _oldObj;
				if(tobjectName==null){
					if(_ShowFun != null){
						_ShowFun(this[objectName]);
					}else{
						this.addChild(this[objectName]);
						this[objectName].visible=true;
					}
					if(this[objectName].myWidth>20){
						this[objectName].x=myWidth-this[objectName].myWidth >> 1;
						this[objectName].y=myHeight-this[objectName].myHeight >> 1;
					}
					else{
						this[objectName].x=myWidth-400 >> 1;
						this[objectName].y=myHeight-500 >>  1;
					}
					if(this[objectName].y<0) this[objectName].y=0;
					if(this[objectName].x<0) this[objectName].x=0;
				}else{
					this.addChildAt(this[objectName],this.numChildren);
					this.addChildAt(this[tobjectName],this.numChildren-1);
					if(_ShowFun != null){
						_ShowFun(this[objectName]);
						_ShowFun(this[tobjectName]);
					}else{
						this.addChild(this[objectName]);
						this.addChild(this[tobjectName]);
						this[objectName].visible=true;	
						this[tobjectName].visible=true;
					}
					this[objectName].x=myWidth-this[objectName].myWidth-this[tobjectName].myWidth >> 1;
					this[objectName].y=myHeight-this[objectName].myHeight >> 1;
					if(this[objectName].y<0) this[objectName].y=0;
					if(this[objectName].x<0) this[objectName].x=0;
					this[tobjectName].x=this[objectName].x+this[objectName].myWidth;
					this[tobjectName].y=this[objectName].y;
				}				
			}
			else{
				if(this[tobjectName]==null){			
					if(_ShowFun != null){
						_ShowFun(this[objectName]);
					}else{
						this.addChild(this[objectName]);
						this[objectName].visible=true;
					}
					this[objectName].x= myWidth-this[objectName].width >> 1;
					this[objectName].y=myHeight-this[objectName].height >> 1;
					if(this[objectName].y<0) this[objectName].y=0;
					if(this[objectName].x<0) this[objectName].x=0;	
				}else{
					this.addChildAt(this[objectName],this.numChildren);
					this.addChildAt(this[tobjectName],this.numChildren-1);
					if(_ShowFun != null){
						_ShowFun(this[objectName]);
						_ShowFun(this[tobjectName]);
					}else{
						this.addChild(this[objectName]);
						this.addChild(this[tobjectName]);
						this[objectName].visible=true;	
						this[tobjectName].visible=true;
					}
					this[objectName].x=myWidth-this[objectName].width-this[tobjectName].width >> 1;
					this[objectName].y=myHeight-this[objectName].height >> 1;
					if(this[objectName].y<0) this[objectName].y=0;
					if(this[objectName].x<0) this[objectName].x=0;
					this[tobjectName].x=this[objectName].x+this[objectName].width;
					this[tobjectName].y=this[objectName].y;
				}
			}
			if(IResourceBar.getInstance().parent)
				IResourceBar.getInstance().parent.setChildIndex(IResourceBar.getInstance(), IResourceBar.getInstance().parent.numChildren);
			return true;
		}
		/**
		 * 隐藏指定的对象 
		 * @param objectName 对象名称
		 * @return 
		 * 
		 */
		public function HideObject(objectName:String):Boolean{
			if(!this.hasOwnProperty(objectName)) return false;
			if(this[objectName]==null) return false;
			if(!this[objectName] is DisplayObject) return false;
			if(this[objectName].parent!=this) return false;
			if(this[objectName] is HWindow)
				HWindow(this[objectName]).hide3DWizard();
			if(_HideFun != null){
				_HideFun(this[objectName]);
			}else{
				this.removeChild(this[objectName]);
			}		
			if(_lastObj == objectName) {
				_lastObj = null
			}	else {
				_oldObj = _lastObj;
				_lastObj = null
			}
			if(_oldObj == objectName) {
				if(_lastObj)
				{
					_oldObj = _lastObj;
					_lastObj = null
				}
					
			}
			return true;
		}
		public function SetSite(objectName:String,nX:int,nY:int):Boolean{
			if(!this.hasOwnProperty(objectName)) return false;
			if(this[objectName]==null) return false;
			if(!this[objectName] is DisplayObject) return false;
			if(this[objectName].parent!=this) return false;
			this[objectName].x=nX;
			this[objectName].y=nY;
			return true;
		}
		public function set ShowFun(fun:Function):void{
			_ShowFun=fun;
		}
		public function get ShowFun():Function{
			return _ShowFun;
		}
		public function set HideFun(fun:Function):void{
			_HideFun=fun;
		}
		public function get HideFun():Function{
			return _HideFun;
		}
		private function DefaultShowObjectEffectFun(object:DisplayObject):void{
			object.alpha=0.2;
			object.visible=true;
			TweenLite.to(object, 0.2, {alpha:1,onComplete:myCompleteFunction, onCompleteParams:[object]});						
			function myCompleteFunction(myObject:DisplayObject):void{
				myObject.alpha=1;
			}
		}
		private function DefaultHideObjectEffectFun(object:DisplayObject):void{
			object.alpha=1;
			TweenLite.to(object, 0.2, {alpha:0.2,onComplete:myCompleteFunction, onCompleteParams:[object]});						
			function myCompleteFunction(myObject:DisplayObject):void{
				myObject.visible=false;
			}
		}

		/** 清除starling事件*/
		public function clearMOuseCursor():void
		{
			if(isMoveStarling)
				isMoveStarling = false;
		}


		public function get isMoveStarling():Boolean
		{
			return _isMoveStarling;
		}

		public function set isMoveStarling(value:Boolean):void
		{
			_isMoveStarling = value;
		}
		/**关闭所有打开界面*/
		public function hideOpenUI():void
		{
			if(SelectReviveWindow._isDeadOpenWindow){
				SelectReviveWindow._isDeadOpenWindow = false;
				return;
			}
			if(TaskWindow.getMyInstance().parent)
				TaskWindow.getMyInstance().parent.removeChild(TaskWindow.getMyInstance());
			if(_lastObj) {
				if(this[_lastObj] is HWindow)
					this[_lastObj].onClose();
				else
					HideObject(_lastObj);
				_lastObj = null
			}
			if(_oldObj) {
				if(this[_oldObj] is HWindow)
				{
					if(this[_oldObj].parent)
						this[_oldObj].onClose();
				}
				else
					HideObject(_oldObj);
				_oldObj = null
			}
		}
		
		public function closeShieldUI(point:Point):void
		{
			if(point == null) return;
			var obj:DisplayObject
			for(var i:int=0; i<this.numChildren; i++)
			{
				obj = this.getChildAt(i);
				_hitTestPoint.x = point.x - obj.x;
				_hitTestPoint.y = point.y - obj.y;
				if(obj is HWindow && !HWindow(obj).isLongShow)
				{
					if(obj.hitTest(_hitTestPoint))
						HWindow(obj).onClose();
				}
			}
		}
		/** @inheritDoc */
		public override function render(support:RenderSupport, parentAlpha:Number):void
		{
			this.curFps = HFrameWorkerManager.getInstance().fpsNow;
			super.render(support, parentAlpha);
		}
	}
}