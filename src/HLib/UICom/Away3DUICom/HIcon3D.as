package HLib.UICom.Away3DUICom
{
	/**
	 * Away3D ICON
	 * @author 李舒浩
	 */	
	import HLib.IResources.IResourceEvent;
	import tl.core.IResourceKey;
	import HLib.IResources.IResourcePool;
	import HLib.IResources.MyLoader3DManager;
	import HLib.IResources.load.LoaderParam;
	
	import away3DExtend.MeshExtend;
	import away3DExtend.TextureMaterialExtend;
	
	import away3d.materials.TextureMaterial;
	import away3d.materials.utils.DefaultMaterialManager;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.Texture2DBase;
	
	public class HIcon3D extends MeshExtend
	{
		public var myWidth:int;
		public var myHeight:int;
		
		protected var _textureMateral:TextureMaterial;
		protected var _type:String = "";	//阵营类型
		protected var _planeGeo:PlaneGeometry;
		
		public function HIcon3D(planeGeo:PlaneGeometry = null)  
		{
			_textureMateral = new TextureMaterialExtend(DefaultMaterialManager.defTexture, true, false, false);
			
			_textureMateral.alphaBlending = true;
			_textureMateral.alphaPremultiplied = false;
			
			_planeGeo = planeGeo;
			
			super(_planeGeo, _textureMateral);
		}
		
		/**
		 * 设置ICON
		 * @param value	: MainUI中的位图连接名
		 */		
		public function set type(value:String):void
		{
			if(_type == value)
			{
				return;
			}

			if(_type && MyLoader3DManager.getInstance().hasEventListener(IResourceEvent.ResourceTaskComplete + _type))
			{
				MyLoader3DManager.getInstance().removeEventListener(IResourceEvent.ResourceTaskComplete + _type, onComplete);
			}
			
			_type = value;
			
			createGeo();
			
			var tmpKey:String = LoaderParam.generatePathKey(_type, IResourceKey.Suffix_ATF, "mainUI");
			if( IResourcePool.getInstance().getResourceByType(tmpKey, IResourceKey.resType_Texture) )
			{
				onComplete();
			}
			else
			{
				MyLoader3DManager.getInstance().addEventListener(IResourceEvent.ResourceTaskComplete + _type, onComplete);	//贴图加载完成
				MyLoader3DManager.getInstance().addTask(_type,[["mainUI", _type, IResourceKey.Suffix_ATF]]);
				_isLoadingHidding=true;
				validateVisible();
			}
		}

		/** 贴图可能没加载完; 若没加载完则先自动隐藏；除非已经设置过一次贴图（鼠标hover事件更换贴图）就不会自动隐藏（此时隐藏会闪烁） */
		private var _shouldVisible :Boolean=true;
		override public function get visible():Boolean
		{
			return _shouldVisible;
		}

		override public function set visible(value:Boolean):void
		{
			_shouldVisible = value;
			validateVisible();
		}

		/** 设置 或加载异步完成后恢复之前设置的 */
		private function validateVisible():void
		{
			// _shouldVisible 是设置的； 还需要（要么加载好了 , 要么贴图已经被设置过（维持之前的，鼠标事件up/down/hover时才不会闪烁））
			super.visible = _shouldVisible && (!_isLoadingHidding || 		_textureMateral.texture != DefaultMaterialManager.defTexture);
		}

		/**标记是因为贴图尚未加载完毕所以隐藏*/
		private var _isLoadingHidding:Boolean = false;
		
		protected function createGeo():void
		{
			if (_planeGeo == null)
			{
				geometry = _planeGeo = new PlaneGeometry(1, 1);
			}
		}
		
		public function get type():String 
		{ 
			return _type;
		}
		public function get textureMateral():TextureMaterial
		{
			return _textureMateral; 
		}
		
		private var _texture:Texture2DBase;
		
		/** 贴图加载完成 **/
		private function onComplete(e:IResourceEvent = null):void
		{
			MyLoader3DManager.getInstance().removeEventListener(IResourceEvent.ResourceTaskComplete + _type, onComplete);
			
			var tmpKey:String = LoaderParam.generatePathKey(_type, IResourceKey.Suffix_ATF, "mainUI");
			_texture = IResourcePool.getInstance().getResourceByType(tmpKey, IResourceKey.resType_Texture);
			if (_texture)
			{
				setTexture(_texture);
				_isLoadingHidding=false;
				validateVisible();
			}
		}
		
		public function setTexture(texture:Texture2DBase):void
		{
			_textureMateral.texture = texture;
			myWidth = _planeGeo.width = texture.width;
			myHeight = _planeGeo.height = texture.height;
		}
		
		public function clearIcon3D():void
		{
			MyLoader3DManager.getInstance().removeEventListener(IResourceEvent.ResourceTaskComplete + _type, onComplete);
			
			this.identity();
			
			_type = "";
			_textureMateral.texture = DefaultMaterialManager.defTexture;
			_textureMateral.alpha = 1;
			this.visible = true;
			
			if (parent)
			{
				parent.removeChild(this);
			}
		}
		
		protected function disposeGeo():void
		{
			_planeGeo.dispose();
		}
		
		override public function dispose():void
		{
			MyLoader3DManager.getInstance().removeEventListener(IResourceEvent.ResourceTaskComplete + _type, onComplete);
			_textureMateral.dispose();
			
			disposeGeo();
			
			super.dispose();
		}
	}
}