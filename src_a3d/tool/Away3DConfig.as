package tool
{
	import flash.display.BitmapData;
	import flash.display.Stage;
	
	import away3d.core.base.Geometry;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;

	/**
	 * Away3D配置文件类,用于保存通用数据/配置数据等静态变量/常量
	 * @author 李舒浩
	 */	
	public class Away3DConfig
	{
		/** stage **/
		public static var myStage:Stage;	//stage
		
		//init texture
		/** 1x1 0x0 texture **/
		public static const initTexture_1x1:BitmapTexture = new BitmapTexture(new BitmapData(1, 1, false, 0), false);
		/** 2x2 0x0 texture **/
		public static const initTexture_2x2:BitmapTexture = new BitmapTexture(new BitmapData(2, 2, false, 0), false);
		/** 4x4 0x0 texture **/
		public static const initTexture_4x4:BitmapTexture = new BitmapTexture(new BitmapData(4, 4, false, 0), false);
		/** 8x8 0x0 texture **/
		public static const initTexture_8x8:BitmapTexture = new BitmapTexture(new BitmapData(8, 8, false, 0), false);
		/** 16x16 0x0 texture **/
		public static const initTexture_16x16:BitmapTexture = new BitmapTexture(new BitmapData(16, 16, false, 0), false);
		/** 32x32 0x0 texture **/
		public static const initTexture_32x32:BitmapTexture = new BitmapTexture(new BitmapData(32, 32, false, 0), false);
		/** 64x64 0x0 texture **/
		public static const initTexture_64x64:BitmapTexture = new BitmapTexture(new BitmapData(64, 64, false, 0), false);
		/** 128x128 0x0 texture **/
		public static const initTexture_128x128:BitmapTexture = new BitmapTexture(new BitmapData(128, 128, false, 0), false);
		/** 256x256 0x0 texture **/
		public static const initTexture_256x256:BitmapTexture = new BitmapTexture(new BitmapData(256, 256, false, 0), false);
		/** 512x512 0x0 texture **/
		public static const initTexture_512x512:BitmapTexture = new BitmapTexture(new BitmapData(512, 512, false, 0), false);
		/** 1024x1024 0x0 texture **/
		public static const initTexture_1024x1024:BitmapTexture = new BitmapTexture(new BitmapData(1024, 1024, false, 0), false);
		//init gray color texture
		/** 1x1 0x0 texture **/
		public static const initGrayTexture_1x1:BitmapTexture = new BitmapTexture(new BitmapData(1, 1, false, 0xFFAAAAAA), false);
		/** 2x2 0x0 texture **/
		public static const initGrayTexture_2x2:BitmapTexture = new BitmapTexture(new BitmapData(2, 2, false, 0xFFAAAAAA), false);
		/** 4x4 0x0 texture **/
		public static const initGrayTexture_4x4:BitmapTexture = new BitmapTexture(new BitmapData(4, 4, false, 0xFFAAAAAA), false);
		/** 8x8 0x0 texture **/
		public static const initGrayTexture_8x8:BitmapTexture = new BitmapTexture(new BitmapData(8, 8, false, 0xFFAAAAAA), false);
		/** 16x16 0x0 texture **/
		public static const initGrayTexture_16x16:BitmapTexture = new BitmapTexture(new BitmapData(16, 16, false, 0xFFAAAAAA), false);
		/** 32x32 0x0 texture **/
		public static const initGrayTexture_32x32:BitmapTexture = new BitmapTexture(new BitmapData(32, 32, false, 0xFFAAAAAA), false);
		/** 64x64 0x0 texture **/
		public static const initGrayTexture_64x64:BitmapTexture = new BitmapTexture(new BitmapData(64, 64, false, 0xFFAAAAAA), false);
		/** 128x128 0x0 texture **/
		public static const initGrayTexture_128x128:BitmapTexture = new BitmapTexture(new BitmapData(128, 128, false, 0xFFAAAAAA), false);
		/** 256x256 0x0 texture **/
		public static const initGrayTexture_256x256:BitmapTexture = new BitmapTexture(new BitmapData(256, 256, false, 0xFFAAAAAA), false);
		/** 512x512 0x0 texture **/
		public static const initGrayTexture_512x512:BitmapTexture = new BitmapTexture(new BitmapData(512, 512, false, 0xFFAAAAAA), false);
		/** 1024x1024 0x0 texture **/
		public static const initGrayTexture_1024x1024:BitmapTexture = new BitmapTexture(new BitmapData(1024, 1024, false, 0xFFAAAAAA), false);
		
		//init bitmapdata
		/** 1x1 0x0 texture **/
		public static const initBitmapData_1x1:BitmapData = new BitmapData(1, 1, false, 0);
		/** 2x2 0x0 texture **/
		public static const initBitmapData_2x2:BitmapData = new BitmapData(2, 2, false, 0);
		/** 4x4 0x0 texture **/
		public static const initBitmapData_4x4:BitmapData = new BitmapData(4, 4, false, 0);
		/** 8x8 0x0 texture **/
		public static const initBitmapData_8x8:BitmapData = new BitmapData(8, 8, false, 0);
		/** 16x16 0x0 texture **/
		public static const initBitmapData_16x16:BitmapData = new BitmapData(16, 16, false, 0);
		/** 32x32 0x0 texture **/
		public static const initBitmapData_32x32:BitmapData = new BitmapData(32, 32, false, 0);
		/** 64x64 0x0 texture **/
		public static const initBitmapData_64x64:BitmapData = new BitmapData(64, 64, false, 0);
		/** 128x128 0x0 texture **/
		public static const initBitmapData_128x128:BitmapData = new BitmapData(128, 128, false, 0);
		/** 256x256 0x0 texture **/
		public static const initBitmapData_256x256:BitmapData = new BitmapData(256, 256, false, 0);
		/** 512x512 0x0 texture **/
		public static const initBitmapData_512x512:BitmapData = new BitmapData(512, 512, false, 0);
		/** 1024x1024 0x0 texture **/
		public static const initBitmapData_1024x1024:BitmapData = new BitmapData(1024, 1024, false, 0);
		
		public static const com_PlaneGeometry:PlaneGeometry=new PlaneGeometry(1,1);
		public static const com_Geometry:Geometry=new Geometry();
		
	}
}