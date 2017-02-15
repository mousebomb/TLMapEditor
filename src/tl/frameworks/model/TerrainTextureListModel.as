/**
 * Created by gaord on 2016/12/19.
 */
package tl.frameworks.model
{
	import flash.filesystem.File;

	import org.mousebomb.framework.GlobalFacade;
	import org.robotlegs.mvcs.Actor;

	import tl.frameworks.NotifyConst;

	import tl.mapeditor.Config;

	public class TerrainTextureListModel extends Actor
	{


		public var list:Array;

		public function loadList():void
		{
			var file :File = File.applicationDirectory.resolvePath(Config.TERRAIN_TEXTURE_URL);
			var files : Array  = file.getDirectoryListing();
			list = [];
			for (var i:int = 0; i < files.length; i++)
			{
				var file1:File = files[i];
				// UI中只显示png的
				if(file1.extension == "png")
				{
					var fileNameBase:String = file1.name.substr(0,file1.name.length-file1.type.length);
					list.push({name:fileNameBase});
				}
			}
			dispatchWith(NotifyConst.TERRAIN_TEXTURES_LIST_LOADED,false);

		}
	}
}
