package HLib.Pools
{
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	
	import away3d.textures.BitmapTexture;
	
	import tool.Pools.NormalPool;
	
	public class ResPool
	{
		private static var _inst:ResPool;
		public static function get inst():ResPool
		{
			return _inst ||= new ResPool();
		}
		//-------------------------------------------------------------------------------------------------------------------
		private static const DEFAULT_POOL_SIZE:uint = 100;
		
		private var _bitmapTexturePools:NormalPool;
		
		private var _blendBmdPoolDict:Dictionary = new Dictionary();
		private var _opaqueBmdPoolDict:Dictionary = new Dictionary();
		
		public function ResPool():void
		{
			_bitmapTexturePools = new NormalPool(30);
			
			_blendBmdPoolDict[1] = new BitmapDataPool(1, 100);
			_blendBmdPoolDict[2] = new BitmapDataPool(2, 50);
			_blendBmdPoolDict[4] = new BitmapDataPool(4, 50);
			_blendBmdPoolDict[8] = new BitmapDataPool(8, 50);
			_blendBmdPoolDict[16] = new BitmapDataPool(16, 100);
			_blendBmdPoolDict[32] = new BitmapDataPool(32, 300);
			_blendBmdPoolDict[64] = new BitmapDataPool(64, 30);
			_blendBmdPoolDict[128] = new BitmapDataPool(128, 30);
			_blendBmdPoolDict[256] = new BitmapDataPool(256, 30);
			_blendBmdPoolDict[512] = new BitmapDataPool(512, 10);
			_blendBmdPoolDict[1024] = new BitmapDataPool(1024, 10);
			
			_opaqueBmdPoolDict[1] = new BitmapDataPool(1, 100);
			_opaqueBmdPoolDict[2] = new BitmapDataPool(2, 50);
			_opaqueBmdPoolDict[4] = new BitmapDataPool(4, 50);
			_opaqueBmdPoolDict[8] = new BitmapDataPool(8, 50);
			_opaqueBmdPoolDict[16] = new BitmapDataPool(16, 100);
			_opaqueBmdPoolDict[32] = new BitmapDataPool(32, 300);
			_opaqueBmdPoolDict[64] = new BitmapDataPool(64, 30);
			_opaqueBmdPoolDict[128] = new BitmapDataPool(128, 30);
			_opaqueBmdPoolDict[256] = new BitmapDataPool(256, 30);
			_opaqueBmdPoolDict[512] = new BitmapDataPool(512, 10);
			_opaqueBmdPoolDict[1024] = new BitmapDataPool(1024, 10);
		}
		
		//--------------------------------------------------------------------------------------------------------------------------------
		// 位图纹理
		public function getBitmapTexture(bmp:BitmapData, generateMipmaps:Boolean = true):BitmapTexture
		{
			var bmpTexture:BitmapTexture = _bitmapTexturePools.getObject(BitmapTexture, bmp, generateMipmaps) as BitmapTexture;
			/*
			bmpTexture.generateMipmaps = generateMipmaps;
			bmpTexture.bitmapData = bmp;
			*/
			return bmpTexture;
		}
		
		public function recycleBitmapTexture(bitmapTexture:BitmapTexture):void
		{
			bitmapTexture.dispose();
//			_bitmapTexturePools.recycle(bitmapTexture);
		}
		//--------------------------------------------------------------------------------------------------------------------------------
		private var _bmpDatas:Dictionary = new Dictionary();
		// 位图
		public function getBlendBitmapData(width:uint, height:uint):BitmapData
		{
			var bdDict:Dictionary = _bmpDatas[width];
			if (bdDict)
			{
				var bdVec:Vector.<BitmapData> = bdDict[height];
				if (bdVec && bdVec.length)
				{
					return bdVec.pop();
				}
			}
			return new BitmapData(width, height);
		}
		
		public function recycleBlendBitmapData(bmd:BitmapData):void
		{
			var bdDict:Dictionary = _bmpDatas[bmd.width];
			if (bdDict == null)
			{
				_bmpDatas[bmd.width] = bdDict = new Dictionary();
			}
			var bdVec:Vector.<BitmapData> = bdDict[bmd.height];
			if (bdVec == null)
			{
				bdDict[bmd.height] = bdVec = new Vector.<BitmapData>();
			}
			bdVec.push(bmd);
		}
		//--------------------------------------------------------------------------------------------------------------------------------
	}
}