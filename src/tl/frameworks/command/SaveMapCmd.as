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

	import org.robotlegs.mvcs.Command;

	import tl.frameworks.model.TLEditorMapModel;
	import tl.mapeditor.Config;

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
//			var f:File = File.desktopDirectory.resolvePath(Config.MAP_URL);
//			f.save(mapModel.saveMapData(), "1001.tlmap");
			var f2:File = File.desktopDirectory.resolvePath(Config.MAP_URL);
			f2.addEventListener(Event.SELECT, onSelected);
			f2.browseForSave("输入一个地图名称保存(不需要扩展名)");
//			f2.save(mapModel.saveMapData(), "1003.tlmap");
		}

		private function onSelected(event:Event):void
		{
			var f:File = (event.target as File);

			var fXMLName :String ;
			var fMapName :String ;
			if(f.type)
			{
				fXMLName = f.nativePath.substr(0,f.nativePath.indexOf(f.type))+".xml";
				fMapName = f.nativePath.substr(0,f.nativePath.indexOf(f.type))+".tlmap";
			}else{
				fXMLName = f.nativePath +".xml";
				fMapName = f.nativePath+".tlmap";
			}
			writeFile(File.applicationDirectory.resolvePath(fMapName), mapModel.saveMapData());
			writeFile(File.applicationDirectory.resolvePath(fXMLName),mapModel.saveMapXMLData());
		}

		private function writeFile(f:File, bin:ByteArray):void
		{
			var fs:FileStream = new FileStream();
			fs.open(f, FileMode.WRITE);
			fs.writeBytes(bin);
			fs.close();
		}
	}
}
