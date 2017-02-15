/**
 * Created by gaord on 2017/2/9.
 */
package tl.frameworks.model.vo
{
	import flash.filesystem.File;

	/** 提交 新建地图 */
	public class CreateMapVO
	{
		public var mapW:uint;
		public var mapH:uint;
		public var mapName:String;
		public var heightMapFile:File;

		public function CreateMapVO(w:uint,h:uint,name:String,hmFile:File):void
		{
			mapW=w;
			mapH=h;
			mapName=name;
			heightMapFile=hmFile;

		}
	}
}
