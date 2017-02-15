package HLib.Tool
{
//	import flash.filesystem.File;
//	import flash.filesystem.FileMode;
//	import flash.filesystem.FileStream;
//	import flash.utils.ByteArray;

	public class HFile
	{
		/**自定义路径*/
		public static const Path_Custom:int=0;
		/**桌面*/
		public static const Path_Desktop:int=1;
		/**用户目录*/
		public static const Path_UserDirectory:int=2;
		/**用户文档目录*/
		public static const Path_DocumentsDirectory:int=3;
		/**应用程序专用存储目录*/
		public static const Path_ApplicationStorageDirectory:int=4;
		/**应用程序目录*/
		public static const Path_ApplicationDirectory:int=5;
		/** 自定义存储路径 **/
		public static var Custom_URL:String = "";

		/**
		 * 保存文件到指定的目录 
		 * @param fileName 文件名
		 * @param value 文件的值
		 * @param path 文件的路径 路径类型可以在本类中找到
		 * 
		 */
		public static function saveFile(fileName:String,value:*,path:int=0):void {
//			var _Path:String="";
//			switch(path) {
//				case Path_Custom:						//自定义路径
//					_Path = Custom_URL;
//					break
//				case Path_Desktop:						//桌面
//					_Path=File.desktopDirectory.nativePath;
//					break;
//				case Path_UserDirectory:				//用户目录
//					_Path=File.userDirectory.nativePath;
//					break;
//				case Path_DocumentsDirectory:			//用户文档目录
//					_Path=File.documentsDirectory.nativePath;
//					break;
//				case Path_ApplicationStorageDirectory:	//应用程序专用存储目录
//					_Path=File.applicationStorageDirectory.nativePath;
//					break;
//				case Path_ApplicationDirectory:			//应用程序目录
//					_Path=File.applicationDirectory.nativePath;
//					break;
//				default:
//					break;
//			}
//			var file:File;
//			if(_Path==""){
//				file = new File();
//				file.save(value,fileName);
//			}
//			else{
//				file = new File(_Path);
//				file = file.resolvePath(fileName);			
//				var stream:FileStream = new FileStream;
//				stream.open(file, FileMode.WRITE);
//				//判断传入的是ByteArray还是对象做对应的存储
//				if(value is ByteArray)	stream.writeBytes(value);
//				else					stream.writeObject(value);
//				stream.close();
//			}
		}
	}
}