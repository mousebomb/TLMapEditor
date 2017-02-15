package HLib.UICom.BaseClass
{
	import com.greensock.TweenLite;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	
	import HLib.DataUtil.HashMap;
	import HLib.Tool.HLog;
	import HLib.Tool.HObjectTips;
	
	import Modules.Map.InitLoader.MapInitLoaderSprite;
	import Modules.Map.MapTips.AreaTypeTips;
	import Modules.view.roleEquip.ItemIconTipsManage;
	import Modules.view.taskGuide.EffectOneWindow;
	import Modules.view.taskGuide.EffectTWSSEWindow;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.display.Stage;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	import tool.StageFrame;
	
	public dynamic class HTopBaseView extends HSprite
	{
		private static var MyInstance:HTopBaseView;
		public static var isComplete:Boolean;
		private var _Stage:Stage;
		private var _HashMap:HashMap=new HashMap();
		private var _ShowFun:Function;
		private var _HideFun:Function;
		public var isAddWindow:Boolean;						//是否添加界面了
		private var _fullBg:Quad;								//背景遮罩
		private var _rectangleVector:Vector.<Rectangle>		//点击区域
		private var _isCllickPirect:Boolean;					//是否开启事件穿透
		private var _hitTestPoint:Point = new Point;
		private var _hasEvent:Boolean;							//是否有鼠标事件
		private var _childArr:Array = [];						//顶层窗口
		private var _time:int;

		/**
		 * 开发者：黄栋 
		 * 基本视图类，做为其它显示对象的容器使用
		 */
		public function HTopBaseView()
		{
			if( MyInstance ){
				throw new Error ("单例只能实例化一次,请用 getInstance() 取实例。");
			}
			this.name = 'HTopBaseView';
			MyInstance=this;
		}
		public static function getInstance():HTopBaseView 
		{
			/*if ( MyInstance == null ) 
			{				
				MyInstance = new HTopBaseView();
			}*/
			return MyInstance;
		}
		public function InIt(w:int,h:int):void{
			this.myWidth=w;
			this.myHeight=h;
			if(_fullBg)
			{
				_fullBg.width = this.myWidth;
				_fullBg.height = this.myHeight;
			}
			if(!isComplete)
			{
				this.addEventListener(TouchEvent.TOUCH, onTouch);
				StageFrame.addActorFun(testingTouchable);
			}
			isComplete = true;
		}
		private function testingTouchable():void
		{
			if(!_hasEvent) return;
			_time ++;
			if(_time < 60)
			{
				return;
			}	else {
				_time = 0;
			}
			var isEvent:Boolean;
			var dis:DisplayObject;
			var leng:int = this.numChildren;
			var po:Point;
			var point:Point = new Point(Starling.current.nativeStage.mouseX, Starling.current.nativeStage.mouseY);
			for(var i:int=0; i<leng; i++)
			{
				dis = this.getChildAt(i)
				if(dis is EffectOneWindow || dis is EffectTWSSEWindow || dis is AreaTypeTips || dis is HObjectTips || dis is ItemIconTipsManage)
					continue;
				po = dis.globalToLocal(point);
				if(dis.hitTest(po))
				{
					isEvent = true;
					if(HLog.getInstance().parent)
					{
						var objName:String=getQualifiedClassName(dis);
						if(dis is DisplayObjectContainer)
							objName += '_' + DisplayObjectContainer(dis).numChildren
						HLog.getInstance().addPropertyCount(objName);
					}
				}
			}
			_hasEvent = isEvent;
		}
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch)
			{
				
				var isEvent:Boolean;
				var dis:DisplayObject;
				var leng:int = this.numChildren;
				for(var i:int=0; i<leng; i++)
				{
					dis = this.getChildAt(i)
					if(dis is EffectOneWindow || dis is EffectTWSSEWindow || dis is AreaTypeTips || dis is HObjectTips || dis is ItemIconTipsManage)
						continue;
					isEvent = true;
				}
				_hasEvent = isEvent;
			}	else {
				_hasEvent = false;
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
			if(!this.hasOwnProperty(objectName)) return false;
			if(tobjectName!=null){
				if(!this.hasOwnProperty(tobjectName)) return false;
			}			
			if(this[objectName]==null) return false;
			if(tobjectName && this[tobjectName]==null) return false;//if(this[tobjectName]=null) return false;
			if(!this[objectName] is DisplayObject) return false;
			if(!this[tobjectName] is DisplayObject) return false;
			
			if(this[objectName] is HSprite){
				if(tobjectName==null){
					if(this[objectName].myWidth>20){
						this[objectName].x=(myWidth-this[objectName].myWidth)/2;
						this[objectName].y=(myHeight-this[objectName].myHeight)/2;
					}
					else{
						this[objectName].x=(myWidth-400)/2;
						this[objectName].y=(myHeight-500)/2;
					}
					if(this[objectName].y<0) this[objectName].y=0;
					if(this[objectName].x<0) this[objectName].x=0;
					if(_ShowFun != null){
						_ShowFun(this[objectName]);
					}else{
						this.addChild(this[objectName]);
						this[objectName].visible=true;
					}
				}else{
					this[objectName].x=(myWidth-this[objectName].myWidth-this[tobjectName].myWidth)/2;
					this[objectName].y=(myHeight-this[objectName].myHeight)/2;
					if(this[objectName].y<0) this[objectName].y=0;
					if(this[objectName].x<0) this[objectName].x=0;
					this[tobjectName].x=this[objectName].x+this[objectName].myWidth;
					this[tobjectName].y=this[objectName].y;
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
				}				
			}
			else{
				if(this[tobjectName]==null){
					this[objectName].x=(myWidth-this[objectName].width)/2;
					this[objectName].y=(myHeight-this[objectName].height)/2;
					if(this[objectName].y<0) this[objectName].y=0;
					if(this[objectName].x<0) this[objectName].x=0;				
					if(_ShowFun != null){
						_ShowFun(this[objectName]);
					}else{
						this.addChild(this[objectName]);
						this[objectName].visible=true;
					}
				}else{
					this[objectName].x=(myWidth-this[objectName].width-this[tobjectName].width)/2;
					this[objectName].y=(myHeight-this[objectName].height)/2;
					if(this[objectName].y<0) this[objectName].y=0;
					if(this[objectName].x<0) this[objectName].x=0;
					this[tobjectName].x=this[objectName].x+this[objectName].width;
					this[tobjectName].y=this[objectName].y;
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
				}
			}
			
			var index:int = _childArr.indexOf(this[objectName]);
			if(index < 0)
				_childArr.push(this[objectName]);
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
			if(_HideFun != null){
				_HideFun(this[objectName]);
			}else{
				this.removeChild(this[objectName]);
			}	
			var index:int = _childArr.indexOf(this[objectName]);
			if(index > -1)
				_childArr.splice(index, 1);
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
		
		/** 添加 遮罩 *  */		
		public function showFullScreenBg(flg:Boolean, alpha:Number=0.4):void
		{
			if(flg)
			{
				if(_fullBg == null)
				{
					_fullBg = new Quad(1,1, 0x000000);
					_fullBg.alpha = 0.4
				}
				_fullBg.alpha = alpha
				this.addChild(_fullBg);
				_fullBg.width = this.myWidth;
				_fullBg.height = this.myHeight;
			}	else {
				if(_fullBg && _fullBg.parent)
				{
					_fullBg.parent.removeChild(_fullBg);
				}
				
				setTimeout(function ():void{
					_hasEvent = false;
					//trace("1111111111111111111111111111111111111111111111111111111113333333333333333333333333")
				}, 50);
			}
			
		}
		
		/**是否点击显示区域*/
		/*public function containsPoint(point:Point):Boolean
		{
			if(_fullBg && _fullBg.parent)
				return true;
			var leng:int = _childArr.length, child:DisplayObject;
			for(var j:int=0; j<leng; j++)
			{
				child = _childArr[j]	
				_hitTestPoint.x = point.x - child.x;
				_hitTestPoint.y = point.y - child.y;
				if(child.hitTest(_hitTestPoint))
					return true;
			}
			return false;
		}*/
		
		/**是否事件穿透判断*/
		public function get isShowFull():Boolean
		{
			if(_fullBg && _fullBg.parent)
				return true;
			else
				return false;
		}
		
		public function addClickChildWindow(child:HSprite):void
		{
			var index:int = _childArr.indexOf(child);
			if(index < 0)
				_childArr.push(child);
			this.addChild(child);
		}
		
		
		public function removeClickChildWindow(child:HSprite):void
		{
			if(child == null) return;
			var index:int = _childArr.indexOf(child);
			if(index > -1)
				_childArr.splice(index, 1);
			if(child.parent)
				child.parent.removeChild(child);
			this.hasEvent = false;
		}
		
		public function get hasEvent():Boolean
		{
			return _hasEvent;
		}

		public function set hasEvent(value:Boolean):void
		{
			_hasEvent = value;
			//trace("1111111111111111111111111111111111111111111111111111111114444444444", value)
		}
		
		override public function removeChild(child:DisplayObject, dispose:Boolean=false):DisplayObject
		{
			if(child is MapInitLoaderSprite)
				setTimeout(function ():void {_hasEvent = false;}, 100);
			var index:int = _childArr.indexOf(child);
			if(index > -1)
				_childArr.splice(index, 1);
			return super.removeChild(child, dispose);
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			return super.addChild(child);
		}
		
	}
}

