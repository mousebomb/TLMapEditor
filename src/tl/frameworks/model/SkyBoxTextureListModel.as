/**
 * Created by gaord on 2017/2/18.
 */
package tl.frameworks.model
{
	import flash.filesystem.File;

	import org.robotlegs.mvcs.Actor;

	import tl.frameworks.NotifyConst;
	import tl.mapeditor.Config;

	public class SkyBoxTextureListModel extends Actor
	{
		/** 可用的天空盒纹理 */
		public var list:Array;
		public function SkyBoxTextureListModel()
		{
			super();
		}
		public function loadList():void
		{
			var file :File = File.applicationDirectory.resolvePath(Config.SKYBOX_URL);
			var files : Array  = file.getDirectoryListing();
			list = [];
			for (var i:int = 0; i < files.length; i++)
			{
				var file1:File = files[i];
				// UI中只显示png的
				if(file1.extension == "atf")
				{
					var fileNameBase:String = file1.name.substr(0,file1.name.length-file1.type.length);
					list.push({name:fileNameBase});
				}
			}
			dispatchWith(NotifyConst.SKYBOX_TEXTURES_LIST_LOADED,false);

		}

	}
}
