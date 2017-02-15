/**
 * Created by gaord on 2017/2/9.
 */
package tl.frameworks.service
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLRequest;

	import org.robotlegs.mvcs.Actor;

	import tl.frameworks.NotifyConst;

	import tl.frameworks.model.TLEditorMapModel;

	public class TLEditorMapService extends Actor
	{

		public function TLEditorMapService()
		{
		}

		[Inject]
		public var editorMapModel:TLEditorMapModel;

		private var _callback:Function;

		/**加载位图资源 锁定操作*/
		public function loadHeightMapFile(heightMapFile:File, callback:Function):void
		{
			editorMapModel.busyLoading = true;
			dispatchWith(NotifyConst.LOCKED);

			_callback = callback;

			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,  onLoadComp);
			loader.load(new URLRequest(heightMapFile.url));
		}

		private function onLoadComp(event:Event):void
		{
			var bitmap:Bitmap = (event.target as LoaderInfo).content as Bitmap;
			_callback(bitmap.bitmapData);
			editorMapModel.busyLoading = false;
			dispatchWith(NotifyConst.UNLOCKED);
		}
	}
}
