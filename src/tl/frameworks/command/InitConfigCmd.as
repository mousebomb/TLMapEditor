/**
 * Created by gaord on 2017/2/23.
 */
package tl.frameworks.command
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	import org.robotlegs.mvcs.Command;

	import tl.mapeditor.Config;

	public class InitConfigCmd extends Command
	{
		public function InitConfigCmd()
		{
			super();
		}

		override public function execute():void
		{
			var f :File = File.applicationDirectory.resolvePath("config.inf");
			var fs :FileStream = new FileStream();
			fs.open(f,FileMode.READ);
			var text :String = fs.readUTFBytes(fs.bytesAvailable);
			fs.close();

			var tArr :Array = text.split("\n");
			Config.PROJECT_URL = tArr[1];
		}
	}
}
