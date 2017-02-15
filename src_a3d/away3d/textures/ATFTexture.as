package away3d.textures
{
	import away3d.core.managers.Stage3DProxy;
	import away3d.debug.Debug;

	import flash.display3D.Context3D;
	import flash.display3D.textures.Texture;
	import flash.display3D.textures.TextureBase;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import away3d.arcane;

	import tool.StageFrame;

	use namespace arcane;
	
	public class ATFTexture extends Texture2DBase
	{
		private var _atfData:ATFData;
		
		public function ATFTexture(byteArray:ByteArray)
		{
			super();
			
			atfData = new ATFData(byteArray);
			_format = atfData.format;
			_hasMipmaps = _atfData.numTextures > 1;
		}
		
		public function get atfData():ATFData
		{
			return _atfData;
		}
		
		public function set atfData(value:ATFData):void
		{
			_atfData = value;
			
			invalidateContent();
			
			setSize(value.width, value.height);
		}
		
		override protected function uploadContent(texture:TextureBase):void
		{
			//2016-11-09 异步上传，如果产生bug要检查； 实际测试away3d的render是支持异步的，只是其它用法可能要注意
			Texture(texture).uploadCompressedTextureFromByteArray(_atfData.data, 0, true);
			if(_onTextureReadyCb !=null)
				Texture(texture).addEventListener(flash.events.Event.TEXTURE_READY,onTextureReady);
		}
		/** 异步回掉 */
		private var _onTextureReadyCb :Function = null;

		private function onTextureReady(e:*):void
		{
			if(_onTextureReadyCb!=null)
			{
				_onTextureReadyCb(this);
				_onTextureReadyCb=null;
			}
		}
		/**提前自行上传*/
		public function prepareUpload(onTextureReadyCb :Function):void
		{
			_onTextureReadyCb = onTextureReadyCb;
			// 如果已经丢失context，那么申请显存纹理不会成功，会报错；且导致无法触发加载完成回调； 这种情况，让他恢复后render时再上传；不需要这里特殊处理，就让他走正常调用（反正也会黑一下）
			if(_atfData!=null && StageFrame.stage3DProxy._context3D && StageFrame.stage3DProxy._context3D.driverInfo!="Disposed")
			{
				getTextureForStage3D(StageFrame.stage3DProxy);
			}else{
				// 显卡上下文已丢失; 直接回调解除异步等待
				onTextureReady( null );
			}
		}
		
		override protected function createTexture(context:Context3D):TextureBase
		{
			++Debug.texturesNum;
			return context.createTexture(_width, _height, atfData.format, false);
		}

		override public function dispose():void
		{
			super.dispose();
//			_atfData.data = null;
			_atfData = null;
			_format = null;
		}
	}
}
