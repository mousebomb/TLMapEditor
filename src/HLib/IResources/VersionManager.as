package HLib.IResources
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class VersionManager
	{
		private static var _inst:VersionManager;
		public static function get inst():VersionManager
		{
			return _inst ||= new VersionManager();
		}
		
		private var _verDect:Dictionary = new Dictionary();
		
		public function VersionManager()
		{
			
		}
		
		public function setVersion(bytes:ByteArray):void
		{
			bytes.uncompress();
			
			var verLen:int = bytes.readUnsignedInt();
			var verFileObj:VersionFileObject;
			var tmpByteLen:int;
			for (var i:int = 0; i < verLen; ++i)
			{
				verFileObj = new VersionFileObject();
				
				//				tmpByteLen = tmpStream.readShort();
				verFileObj.fileName = bytes.readUTF();
				
				//				tmpByteLen = tmpStream.readShort();
				verFileObj.fileVer = bytes.readUTF();
				
				verFileObj.fileSize = bytes.readUnsignedInt();
				
				_verDect[verFileObj.fileName] = verFileObj;
			}
		}
		
		private static const IS_CHECK_SIZE:Boolean = false;
		public function checkFileSize(fileName:String, size:uint):Boolean
		{
			if (IS_CHECK_SIZE == false)
			{
				return true;
			}
			var obj:VersionFileObject = _verDect[fileName];
			return obj ? obj.fileSize == size: true;
		}
		
		public function getFileSize(fileName:String):uint
		{
			var obj:VersionFileObject = _verDect[fileName];
			return obj ? obj.fileSize : 0;
		}
		
		public function getFileVer(fileName:String):String
		{
			/*while(fileName.indexOf("/") != -1)
			{
				fileName = fileName.replace("/", "\\");
			}*/
			var obj:VersionFileObject = _verDect[fileName];
			return obj ? "?ver=" + obj.fileVer : "?ver=0";
		}
	}
}