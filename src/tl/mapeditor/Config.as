/**
 * Created by gaord on 2016/12/15.
 */
package tl.mapeditor
{
	public class Config
	{



		public static const FONT:String = "宋体";

		public static const VERSION_NUN:String = "0.010";	//版本号

		public static var PROJECT_URL:String = "";



		///// old  compatible
		public static const STATE_TYPE_6:uint = 6;			//提升Y区域
		public static const MODEL_SIZE:Number = 3;			//模型窗口显示模型大小

		public function Config()
		{
		}

		public static function get TERRAIN_TEXTURE_URL():String
		{
			return PROJECT_URL +"TerrainTextures/";
		}

		public static function get MOXING_AWD_URL():String
		{
			return PROJECT_URL + "awd/";
		}

		public static function get SKYBOX_URL():String
		{
			return PROJECT_URL + "skybox/";
		}
		public static function get MAP_URL():String
		{
			return PROJECT_URL + "map/";
		}
	}
}
