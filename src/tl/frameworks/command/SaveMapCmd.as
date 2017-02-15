/**
 * Created by gaord on 2017/2/6.
 */
package tl.frameworks.command
{
	import flash.events.Event;
	import flash.filesystem.File;

	import org.mousebomb.framework.INotifyControler;
	import org.mousebomb.framework.Notify;
	import org.robotlegs.mvcs.Command;

	import tl.frameworks.model.TLEditorMapModel;

	public class SaveMapCmd extends Command
	{
		public function SaveMapCmd()
		{
		}
		[Inject]
		public var e:Event;
		[Inject]
		public var mapModel:TLEditorMapModel;

		public override function execute():void
		{
			var f:File = File.desktopDirectory;
			f.save(mapModel.saveMapData(), "1001.tlmap");
		}
	}
}
