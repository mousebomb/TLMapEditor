package tl.frameworks.service.bombloader
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;

	[SWF(backgroundColor="#FFFFFF", frameRate="31", width="200", height="200")]

	/**
	 * @author rhett
	 */
	public class LoaderTestCase extends Sprite
	{
		public function LoaderTestCase()
		{
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}

		/**  */
		public static const GROUP_UI : int = 1;
		/**  */
		public static const GROUP_SCENE : int = 2;

		private function onStage(event : Event) : void
		{
			JYLoader.getInstance().reqResource("http://mousebomb-public.qiniudn.com/Painter.apk", JYLoader.RES_BYTEARRAY, 2, GROUP_SCENE, baLoaded);
			JYLoader.getInstance().reqResource("http://www.mousebomb.org/index/img/enter.png", JYLoader.RES_BITMAP, 2, GROUP_UI, bmdLoaded);
			JYLoader.getInstance().reqResource("http://images.apple.com/cn/environment/images/overview_imac_1998.png", JYLoader.RES_BITMAP, 2, GROUP_UI, bmdLoaded);
			JYLoader.getInstance().reqResource("http://www.mousebomb.org/index/img/enter2.png", JYLoader.RES_BITMAP, 2, GROUP_UI, bmdLoaded);
			JYLoader.getInstance().reqResource("http://www.mousebomb.org/index/img/enter3.png", JYLoader.RES_BITMAP, 2, GROUP_UI, bmdLoaded);
			JYLoader.getInstance().reqResource("http://www.mousebomb.org/index/img/enter3.png", JYLoader.RES_BITMAP, 2, GROUP_UI, bmdLoaded);
//			JYLoader.getInstance().reset(GROUP_SCENE);
			JYLoader.getInstance().reqResource("http://images.apple.com/cn/environment/images/overview_hero_image.jpg", JYLoader.RES_BITMAP, 2, GROUP_UI, bmdLoaded);
			JYLoader.getInstance().reqResource("http://www.mousebomb.org/index/img/enter4.png", JYLoader.RES_BITMAP, 2, GROUP_UI, bmdLoaded);
//			JYLoader.getInstance().reqResource("/Users/rhett/MyWork/2014_jy/yxsd/webclient/bin-debug/GameMain.swf", JYLoader.RES_RSL, 2, GROUP_UI, swfLoaded);
//			JYLoader.getInstance().pause(GROUP_UI);
			stage.addEventListener(MouseEvent.CLICK, onClick);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(event : Event) : void
		{
			var v : JYLoader = JYLoader.getInstance();
			JYLoader.getInstance().updateStats();
//			btrace(v.loadSpeed,"峰值",v.topSpeed,"流量",v.totalLoaded);
		}

		private function onProg(evt:ProgressEvent,vo:LoadQueueItemVO) : void
		{
			trace(evt.bytesLoaded,evt.bytesTotal);
		}

		private function onClick(event : MouseEvent) : void
		{JYLoader.getInstance().resume(GROUP_UI);
		}

		private function baLoaded(url:String,ba:ByteArray,mark:*) : void
		{trace("ba loaded ",url);
		}

		private function swfLoaded(url:String,b:Boolean,mark:*) : void
		{
			trace(url,b ,mark,JYLoader.getInstance().loadSpeed);
			var gameMain : Class = getDefinitionByName("GameMain") as Class;
//			trace("swf got class:" , gameMain);
		}

		private function bmdLoaded(url:String,bmd : BitmapData,mark:*) : void
		{
			trace(url,bmd ,mark,JYLoader.getInstance().loadSpeed);
			addChild(new Bitmap(bmd));
		}
	}
}
