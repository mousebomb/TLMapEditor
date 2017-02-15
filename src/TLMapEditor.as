/**
 * Created by gaord on 2016/12/13.
 */
package
{
	import away3d.cameras.Camera3D;
	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DManager;
	import away3d.core.managers.Stage3DProxy;
	import away3d.debug.Trident;
	import away3d.events.Stage3DEvent;

	import flash.display.NativeWindow;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.system.Capabilities;

	import tl.core.old.OldSwfRes;
	import tl.frameworks.TLMapEditorContext;
	import tl.mapeditor.scenes.EditorScene3D;
	import tl.mapeditor.scenes.PreviewScene3D;

	import tool.DebugHelper;
	import tool.StageFrame;

	public class TLMapEditor extends Sprite
	{
		//
		private var myWidth:int;
		private var myHeight:int;

		private var _Stage3DManager:Stage3DManager;				//创建3d管理类
		private var _Stage3DProxy:Stage3DProxy;					//3d代理类
		private static var _View3D:View3D;								//3d显示窗口
		private static var _View3DForPreview:View3D;								//3d显示窗口 UI预览3D模型

		private var oldSwfRes:OldSwfRes;

		public static var robotlegsContext:TLMapEditorContext;

		public static function get view3D():View3D
		{
			return _View3D;
		}

		public static function get view3DForPreview():View3D
		{
			return _View3DForPreview;
		}

		public function TLMapEditor()
		{
			super();
			if (stage)
			{
				onSTAGE(null);
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, onSTAGE);
			}
			//
			oldSwfRes = new OldSwfRes();
			//初始化robotlegs框架和UI
			robotlegsContext = new TLMapEditorContext(this);
		}

		private var debugHelper :DebugHelper;
		private function onSTAGE(e:Event):void
		{
			debugHelper=new DebugHelper(stage);
			stage.addEventListener(MouseEvent.RIGHT_CLICK, function(e:MouseEvent):void
			{
			});

			this.removeEventListener(Event.ADDED_TO_STAGE, onSTAGE);

			// 窗口最大化
			var window:NativeWindow = stage.nativeWindow;
			window.minSize          = new Point(1000, 600);
			window.maxSize          = new Point(Capabilities.screenResolutionX, Capabilities.screenResolutionY);
			window.maximize();

			stage.scaleMode              = StageScaleMode.NO_SCALE;
			stage.align                  = StageAlign.TOP_LEFT;
			stage.quality                = StageQuality.LOW;
			stage.showDefaultContextMenu = false;	//屏蔽右键菜单

			StageFrame.setup(stage);
			stage.frameRate = 31;
			myWidth         = stage.nativeWindow.width;
			myHeight        = stage.nativeWindow.height;

			//初始化3D场景设置
			_Stage3DManager         = Stage3DManager.getInstance(stage);
			_Stage3DProxy           = _Stage3DManager.getFreeStage3DProxy();
			_Stage3DProxy.antiAlias = 0;           					//全局抗锯齿参数
			_Stage3DProxy.color     = 0xFF000000;  							//背景颜色
			_Stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, onProxyCreated);
			_Stage3DProxy.configureBackBuffer(myWidth, myHeight, 4);

//			Away3DConfig.myStage = stage;			//设置Away3D类库所用的stage
			//			Parsers.enableAllBundled();
			stage.addEventListener(Event.RESIZE, onResize);

		}

		public static const PADDING_LEFT :int = 90;
		public static const PADDING_TOP :int = 32;
		private function onResize(event:Event):void
		{
			if (_View3D)
			{
				myWidth  = stage.stageWidth;
				myHeight = stage.stageHeight;
				_Stage3DProxy.configureBackBuffer(myWidth, myHeight, 4);
				_View3D.width  = myWidth - PADDING_LEFT;
				_View3D.height = myHeight;
				_View3D.x = PADDING_LEFT;
				_View3D.y = PADDING_TOP;
			}
		}

		private function onProxyCreated(event:Stage3DEvent):void
		{
			_Stage3DProxy.removeEventListener(Stage3DEvent.CONTEXT3D_CREATED, onProxyCreated);

			myWidth                 = stage.stageWidth;
			myHeight                = stage.stageHeight;
			///
			StageFrame.stage3DProxy = _Stage3DProxy;
			var camera:Camera3D     = new Camera3D();
			_View3D                 = new View3D(new EditorScene3D(camera), camera);
			_View3D.stage3DProxy    = _Stage3DProxy;
			_View3D.shareContext    = true;						//允许共享执行
//			_View3D.forceMouseMove = true;
			_View3D.scene.addChild(new Trident());  		//显示三叉坐标轴
			this.addChild(_View3D);

			_View3DForPreview              = new View3D(new PreviewScene3D());
			_View3DForPreview.stage3DProxy = _Stage3DProxy;
			_View3DForPreview.shareContext = true;						//允许共享执行
			_View3DForPreview.width        = 180;
			_View3DForPreview.height       = 180;
			_View3DForPreview.visible = false;
			_View3DForPreview.layeredView = true;
			this.addChild(_View3DForPreview);


			StageFrame.mainFun = onEnterFrame;
			onResize(null);

			//启动框架
			robotlegsContext.startup();

			//3D层 手动map
			robotlegsContext.mediatorMap.createMediator(_View3D.scene);
			robotlegsContext.mediatorMap.createMediator(_View3DForPreview.scene);
			robotlegsContext.mediatorMap.createMediator(_View3DForPreview);

//			MediatorCenter.getInstance().mapMediator(_View3D.scene, EditorScene3DMediator);
//			MediatorCenter.getInstance().mapMediator(_View3DForPreview.scene, PreviewScene3DMediator);
		}

		private function onEnterFrame():void
		{
			(_View3D.scene as EditorScene3D).update(StageFrame.deltaTime);
			//清空Context3D 对象
			_Stage3DProxy.clear();
			//渲染Away3D图层
//			PropertyCount.getInstance().keyStart("Away3DRender","root");
			_View3D.render();
			if(_View3DForPreview.visible) _View3DForPreview.render();
			_Stage3DProxy.present();

		}

	}
}
