package HLib.MapBase
{
	/**
	 * 地图子模型控制类
	 */

	import away3d.textures.ATFTexture;

	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import HLib.IResources.IResourceEvent;
	import tl.core.IResourceKey;
	import HLib.MapBase.MapLoader.MyMapLoader3DManager;
	import HLib.MapBase.MapLoader.MyMapResTool;
	
	import away3DExtend.MeshExtend;
	
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	import away3d.textures.Texture2DBase;
	
	import tool.Away3DConfig;
	
	public class TileView3D extends EventDispatcher
	{
		public static var status_NoTexture:int = 0;
		public static var status_MosaicsTexture:int = 1;
		public static var status_FormalTexture:int = 2;
		
		private var _width:Number;
		
		private var _height:Number;
		
		private var _mapName:String="";
		
		private var _subMesh:MeshExtend;
		private var _subMeshMaterial:TextureMaterial;					//地图贴图
		private var _bitmapTexture:BitmapTexture;
		private var u:int;//横向索引
		private var v:int;//纵向索引	
		private var _subPath:String="";
		
		private var _status:int;
		
		public function get status():int
		{
			return _status;
		}
		
		public function TileView3D(x:int, y:int, width:Number, height:Number, subMesh:MeshExtend, isFar:Boolean=false)
		{
			u = x;
			v = y;
			_width = width;
			_height = height;
			_subMesh = subMesh;
			
			_subMesh.castsShadows = false;
			
			_status = status_NoTexture;
		}
		
		/**
		 * 资源url命名格式
		 * @param file
		 * 
		 */		
		public function seturl(subName:String, mapName:String):void
		{
			_subPath = subName;
			var _u:String = u > 9 ? String(u) : "0" + u;	
			var _v:String = v > 9 ? String(v) : "0" + v;				
			_mapName = mapName + "_" + _v + "_" + _u;
		}
		
		/**
		 * 加载地图 
		 */
		public function loadMap(bmd:BitmapData = null):void
		{
			if(_mapName == "" || _subPath == "") 
			{
				return;
			}
			
			_status = status_MosaicsTexture;
			if(_bitmapTexture)
			{
				if (_bitmapTexture.bitmapData)
				{
					_bitmapTexture.bitmapData.dispose();
				}
				
				_bitmapTexture.bitmapData = bmd;
			}
			else
			{
				_bitmapTexture = new BitmapTexture(bmd, false);
			}
			_bitmapTexture.name = _mapName;
			if(!_subMeshMaterial)
			{
				_subMeshMaterial = new TextureMaterial(_bitmapTexture, false, false, false);
				//				_subMeshMaterial.depthWrite = false;
				_subMesh.material = _subMeshMaterial;
				//					_subMeshMaterial.alpha = 0;
				isOpenSunLight = isOpenSunLight;//设置灯光
			}
			else
			{
				_subMeshMaterial.smooth = false;
				_subMeshMaterial.mipmap = false;
				_subMeshMaterial.texture = _bitmapTexture;
			}
			//			MyMapLoader3DManager.instance.removeKey(_curLoaderKey);
			
			removeEvt();
			_tmpKey = _subPath + "/" + _mapName + IResourceKey.Suffix_ATF;
			MyMapLoader3DManager.instance.addEventListener(IResourceEvent.ResourceTaskComplete + _tmpKey, loadMapComplete);
			MyMapLoader3DManager.instance.addLoader(_tmpKey, _mapName, _subPath, IResourceKey.Suffix_ATF);
		}
		
		private var _tmpKey:String;
		private function removeEvt():void
		{
			if (_tmpKey)
			{
				MyMapLoader3DManager.instance.removeEventListener(IResourceEvent.ResourceTaskComplete + _tmpKey, loadMapComplete);
				_tmpKey = "";
			}
		}
		
		/**资源加载完成*/
		private function loadMapComplete(evt:Event):void
		{
			removeEvt();
			
			var _t2b:ATFTexture = MyMapResTool.instance.getResource(_mapName + IResourceKey.Suffix_ATF);
			if(_t2b)
			{
				_status = status_FormalTexture;

				_subMeshMaterial.smooth = true;
				_subMeshMaterial.mipmap = true;
				_subMeshMaterial.texture = _t2b;
				if (_bitmapTexture)
				{
					_bitmapTexture.bitmapData.dispose();
					_bitmapTexture.dispose();
					_bitmapTexture = null;
				}
			} 
			else 
			{
				//				Debug.error("获取地图资源失败,资源名为：" + _mapName + IResourceKey.Suffix_Map);
			}
		}
		/**
		 * 是否开启阳光
		 * @param value
		 */		
		public function set isOpenSunLight(value:Boolean):void
		{
			_isOpenSunLight = value;
			if(!_subMeshMaterial)
			{
				return;
			}
			if(_isOpenSunLight)
			{
				_subMeshMaterial.lightPicker = HLightManager.getInstance().lightPicker;//应用光源
				_subMeshMaterial.shadowMethod = HLightManager.getInstance().shadowMapMethod;//引用阴影
			}
			else
			{
				if(!_subMeshMaterial.lightPicker)
				{
					return;
				}
				_subMeshMaterial.lightPicker = null;
				_subMeshMaterial.shadowMethod = null;
			}
		}
		
		public function get isOpenSunLight():Boolean
		{
			return _isOpenSunLight;
		}
		
		private var _isOpenSunLight:Boolean = false;
		
		public function clear():void
		{
			removeEvt();
			
			_subPath = "";
			_mapName = "";
			
			_subMeshMaterial.texture = Away3DConfig.initTexture_1x1;
			
			//			MyMapLoader3DManager.instance.removeKey(_curLoaderKey);
			_status = status_NoTexture;
		}
	}
}