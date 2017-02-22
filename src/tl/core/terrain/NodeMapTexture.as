/**
 * Created by gaord on 2017/2/14.
 */
package tl.core.terrain
{
	import away3d.textures.RenderTexture;
	import away3d.tools.utils.TextureUtils;

	import flash.display.BitmapData;

	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.display3D.textures.TextureBase;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	import tl.frameworks.defines.ZoneType;
	import tl.mapeditor.ui.DebugHeightMap;

	import tool.StageFrame;

	public class NodeMapTexture extends RenderTexture
	{
		/* 因为要满足2的幂，但是地图长宽又不一定是2的幂
		 * 所以先转换为大一些的，再用UV缩放，舍弃掉一部分texture到geom外面 */

		/** 因为满足显存 需要scale的UV */
		public var uvScaleW:Number;
		public var uvScaleH:Number;

		/** 有意义的宽高 */
		public var mapW:Number;
		public var mapH:Number;

		public function NodeMapTexture(mapW_:Number, mapH_:Number)
		{
			mapW              = mapW_;
			mapH              = mapH_;
			var expandedW:int = TextureUtils.getBestPowerOf2(mapW_);
			var expandedH:int = TextureUtils.getBestPowerOf2(mapH_);
			super(expandedW, expandedH);
			uvScaleW              = mapW_ / expandedW;
			uvScaleH              = mapH_ / expandedH;
			_byteArrayData        = new ByteArray();
			_byteArrayData.endian = Endian.LITTLE_ENDIAN;
			for (var i:int = 0; i < expandedW; i++)
			{
				for (var x:int = 0; x < expandedH; x++)
				{
					_byteArrayData.writeUnsignedInt(0);
				}
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

		/**增量更改*/
		public function setVal(x:int, y:int, val:uint):void
		{
			if (val == 0) setPixel32(x, y, 0);
			else setPixel32(x, y, ZoneType.COLOR_BY_TYPE[val]);
		}

		/** 增量更改 32bit uint */
		[Inline]
		public final function setPixel32(x:int, y:int, val:uint):void
		{
			if (val > 0xffffffff) val = 0xffffffff;
			_byteArrayData.position = 4*(y * width + x);
			// 显存 BGRA
			var startA :uint= val>0?0x66:0;//(uint(val) & 0xff000000) >> 24;
			var startR :uint= (uint(val) & 0xff0000) >> 16;
			var startG:uint = (uint(val) & 0xff00) >> 8;
			var startB:uint = uint(val) & 0xff;
			_byteArrayData.writeByte(startB);
			_byteArrayData.writeByte(startG);
			_byteArrayData.writeByte(startR);
			//a
			_byteArrayData.writeByte(startA);

		}

	}
}
