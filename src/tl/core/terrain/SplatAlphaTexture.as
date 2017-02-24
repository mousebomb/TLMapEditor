/**
 * Created by gaord on 2016/12/20.
 */
package tl.core.terrain
{
	import away3d.materials.utils.MipmapGenerator;
	import away3d.textures.RenderTexture;

	import flash.display.BitmapData;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.display3D.textures.TextureBase;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getTimer;

	import tool.StageFrame;

	/** 动态生成 不断改变的 splatalpha 材质 ； 地图编辑模式用，编辑完毕后导出为静态atf给游戏实际用\
	 *  不采用flash的bitmapData ，因为bitmapData.setPixel32() 写入数据会立即预乘alpha而丢失rgb
	 *
	 * */
	public class SplatAlphaTexture extends RenderTexture
	{
		public function SplatAlphaTexture(width:Number, height:Number, maskData:ByteArray = null)
		{
			super(width, height);
			if (maskData == null)
			{
				_byteArrayData        = new ByteArray();
				_byteArrayData.endian = Endian.LITTLE_ENDIAN;
				for (var i:int = 0; i < height; i++)
				{
					for (var x:int = 0; x < width; x++)
					{
						_byteArrayData.writeByte(0);
						_byteArrayData.writeByte(0);
						_byteArrayData.writeByte(0);
						_byteArrayData.writeByte(0);
					}
				}
			}else{
				_byteArrayData = maskData;
			}
			_hasMipmaps = false;
			_format     = Context3DTextureFormat.BGRA;
		}

		/** 用的bmd ，用于在c3d不存在时编辑 */
		private var _byteArrayData:ByteArray;


		/** 要用时 以bmd 做最新 */
		override protected function uploadContent(texture:TextureBase):void
		{
			// 上传纹理
			Texture(texture).uploadFromByteArray(_byteArrayData, 0, 0);
		}

		public static const X:int = 2;
		public static const Y:int = 1;
		public static const Z:int = 0;
		public static const W:int = 3;
		public static const R:int = 2;
		public static const G:int = 1;
		public static const B:int = 0;
		public static const A:int = 3;

		/** 增量更改 */
		public function setVal(x:int, y:int, field:int, val:uint):void
		{
			if (val > 255) val = 255;
			_byteArrayData.position = (y * width + x) * 4 + field;
			_byteArrayData.writeByte(val);
		}

		public function getVal(x:int, y:int, field:int):uint
		{
			_byteArrayData.position = (y * width + x) * 4 + field;
			return _byteArrayData.readUnsignedByte();
		}

		/** 交换层级 */
		public function switchRGBA(fromField:int, toField:int):void
		{
			var tmpByteVal:uint;
			for (var y:int = 0; y < height; y++)
			{
				for (var x:int = 0; x < width; x++)
				{
					tmpByteVal = getVal(x, y, fromField);
					setVal(x, y, fromField, getVal(x, y, toField));
					setVal(x, y, toField, tmpByteVal);
				}
			}
			invalidateContent();
		}

		/** 增量更改了bmd后提交到GPU */
		public function commitChange():void
		{
			invalidateContent();
		}

		/** 导出实际数据 */
		public function exportByteArray():ByteArray
		{
			return _byteArrayData;
		}


		override public function dispose():void
		{
			_byteArrayData=null;
			super.dispose();
		}
	}
}
