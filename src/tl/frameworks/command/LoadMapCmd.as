/**
 * Created by gaord on 2017/2/6.
 */
package tl.frameworks.command
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	import org.mousebomb.framework.INotifyControler;
	import org.mousebomb.framework.Notify;
	import org.robotlegs.mvcs.Command;

	import tl.frameworks.model.TLEditorMapModel;
	import tl.frameworks.TLEvent;
	import tl.mapeditor.scenes.EditorScene3D;
	import tl.mapeditor.ui.DebugHeightMap;

	public class LoadMapCmd extends Command
	{
		public function LoadMapCmd()
		{
		}
		[Inject]
		public var mapModel:TLEditorMapModel;

		[Inject]
		public var e:TLEvent;

		override public function execute():void
		{
			var f:File = e.data;
			var fs :FileStream = new FileStream();
			fs.open(f,FileMode.READ);
			var ba :ByteArray = new ByteArray();
			fs.readBytes(ba ,0);
			mapModel.readMapVO(ba);
			fs.close();
			//
			DebugHeightMap.getInstance().showBitmapData(mapModel.mapVO.debugBmd);
		}
	}
}
