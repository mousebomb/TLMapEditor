package HLib.IResources.Parsers
{
	/**
	 * 配置表,配置相关信息
	 * @author 李舒浩
	 */	
	import flash.display.BlendMode;

	public class ParsersConfig
	{
		//***************  const  *************
		public static const FONT:String = "宋体";
		
		public static const PLAY_SPEED:Number = 0.5;			//播放间隔
		public static const VERSION_NUN:String = "0.012";	//版本号
		public static const IS_COMPRESS:Boolean = true;		//是否压缩
		public static const COMPRESS_TYPE:String = "lzma";//CompressionAlgorithm.LZMA;	//压缩类型
		
		//***************  var  *************
		public static var MODEL_SIZE:uint = 100;				//模型大小,100==100% 200==200%..10==10%
		public static var CAMERA_SPEED:int = 5;				//镜头移动速度基础值
		public static var ALPHATHRESHOLD:Number = 0.9;		//AlphaThreshold值
		public static var SHOW_BOUNDS:Boolean = false;		//是否显示bounds
		public static var SHOW_TRIDENT:Boolean = true;		//是否显示坐标轴
		public static var SHOW_GRID:Boolean = true;			//是否显示背景格子
		public static var SHOW_STATS:Boolean = true;			//是否显示stats
		
		public static var SHOW_MATERIAL:Boolean = true;		//是否显示贴图
		public static var MODEL_IS_PLAY:Boolean = false;		//是否播放状态
		public static var MODEL_PLAY_SPEED:uint = 10;			//模型播放速度
		public static var SHOW_FLOOR:Boolean = false;			//是否显示地板
		public static var FIXED_ANGLE:Boolean = false;		//固定视角
		
		public static var FLOOR_SIZE:uint = 4;				//地板大小
		public static var ANGLE_INDEX:uint = 2;				//视角角度
		public static var BLEND_INDEX:uint = 0;				//混合模式索引
		
		//地图大小规格数组
		public static const FLOOR_SIZE_VECTOR:Vector.<uint> = Vector.<uint>([64, 128, 256, 512, 1024, 2048, 4096]);
		//角度规格数组
		public static const ANGLE_SIZE_VECTOR:Vector.<uint> = Vector.<uint>([15, 30, 45, 60, 90]);
		//混合模式数组
		public static const BLEND_VECTOR:Vector.<String> = Vector.<String>([BlendMode.NORMAL, BlendMode.LAYER, BlendMode.MULTIPLY, BlendMode.ADD
																			, BlendMode.SCREEN, BlendMode.OVERLAY, "colorDodge"]);
	}
}