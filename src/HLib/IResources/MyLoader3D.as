package HLib.IResources
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import HLib.IResources.load.LoaderParam;
	
	import away3DExtend.E_MD5AnimParser;
	import away3DExtend.E_MD5MeshParser;
	import away3DExtend.SkeletonExtend;
	
	import away3d.arcane;
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.nodes.SkeletonClipNode;
	import away3d.core.base.Geometry;
	import away3d.entities.ParticleGroup;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.assets.AssetType;
	import away3d.loaders.AssetLoader;
	import away3d.loaders.parsers.ImageParser;
	import away3d.loaders.parsers.ParticleGroupParser;
	import away3d.textures.Texture2DBase;

	import tl.core.IResourceKey;

	use namespace arcane;
	/**
	 * 3D加载类
	 * @author 李舒浩
	 */	
	public class MyLoader3D extends AssetLoader implements IResLoader
	{
		private var _param:LoaderParam;
		
//		private var _overTimeId:int = 0;
		
		public function get param():LoaderParam
		{
			return _param;
		}
		
		public function MyLoader3D()
		{
			super();
			
		}
		
		/** 移除loader **/
		override protected function dispose():void
		{
			_param = null;
			
//			clearTimeOut();
			
			super.dispose();
		}
		
		/** 执行加载 **/
		public function startLoad(param:LoaderParam):void
		{
			_param = param;
			
			var parser:*;
			switch(_param.fileExt)
			{
				case IResourceKey.Suffix_MD5Mesh:			//判断是否为网格(模型)
					parser = new E_MD5MeshParser();
					break;
				case IResourceKey.Suffix_ATF:	   	//判断是否为贴图(png)
					parser = new ImageParser();
					break;
				case IResourceKey.Suffix_PNG:		//图片资源
					parser = new ImageParser();
					break;
				case IResourceKey.Suffix_MD5Anim:	      	//判断是否为动作
					parser = new E_MD5AnimParser();
					break;
				case IResourceKey.Suffix_Effect:	      //判断是否为特效
					parser = new ParticleGroupParser();
					break;
				default:
					break;
			}
			
			this.load( new URLRequest(_param.urlStr), null, _param.filename, parser );
			
			addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			addErrorHandler(loadError);
			addParseErrorHandler(loadError);
			
//			clearTimeOut();
//			_overTimeId = setTimeout(loadError, 60000, null);
		}
		
		override protected function onProgress(evt:ProgressEvent):void  
		{
			//			trace("------------------------------------------->", _param.resKey);
			
			_param.loadByte = evt.bytesLoaded;
			_param.totalByte = evt.bytesTotal;
			
			_param.loadRate = evt.bytesLoaded / evt.bytesTotal;
			
			super.onProgress(evt);
			
			_param.progressFun.exec(this);
		}
		
		/** 每一面加载处理 **/
		override protected function onAssetComplete(evt:AssetEvent):void
		{
			var packName:String = evt.asset.assetNamespace;
			var assetType:String = evt.asset.assetType;
			
			packName = _param.filename;
			
			var tmpKey:String = _param.resKey;
			
			if (param.fileExt == ".awp")
			{
				if (assetType == AssetType.CONTAINER)
				{
					//判断是否为特效(awp)
					var particleGroup:ParticleGroup = evt.asset as ParticleGroup;
					particleGroup.name = packName + IResourceKey.Suffix_Effect;
					//保存模型
					IResourcePool.getInstance().addResourceByType(tmpKey, particleGroup, IResourceKey.resType_Effect);
				}
			}
			else
			{
				switch(assetType)
				{
					case AssetType.GEOMETRY:	//模型数据结构
						var geometry:Geometry = Geometry(evt.asset);
						geometry.name = packName + IResourceKey.Suffix_MD5Mesh;
						IResourcePool.getInstance().addResourceByType(tmpKey, geometry, IResourceKey.resType_MD5Mesh);
						break;
					case AssetType.TEXTURE:	
						var bitmapTexture:Texture2DBase = Texture2DBase(evt.asset);
						bitmapTexture.name = packName + _param.fileExt;// + IResourceKey.Suffix_ATF;//Suffix_TextureMaterial;
						//保存模型
						IResourcePool.getInstance().addResourceByType(tmpKey, bitmapTexture, IResourceKey.resType_Texture);
						break;
					case AssetType.ANIMATION_NODE:	//判断是否为动作
						var node:SkeletonClipNode = SkeletonClipNode(evt.asset);
						node.name = packName;
						//保存动作
						IResourcePool.getInstance().addResourceByType(tmpKey, node, IResourceKey.resType_AnimNode);
						break;
					case AssetType.ANIMATION_SET:	//判断是否为动作数据集
						if(evt.asset is SkeletonAnimationSet)
						{
							var skeletonAnimationSet:SkeletonAnimationSet = SkeletonAnimationSet(evt.asset);
							skeletonAnimationSet.name = tmpKey;
							//保存动作数据集
							IResourcePool.getInstance().addResourceByType(tmpKey, skeletonAnimationSet, IResourceKey.resType_AnimSet);
						}
						break;
					case AssetType.SKELETON:		//判断是否为骨骼
						var skeleton:SkeletonExtend = SkeletonExtend(evt.asset);
						skeleton.name = tmpKey;
						//保存骨骼
						IResourcePool.getInstance().addResourceByType(tmpKey, skeleton, IResourceKey.resType_Skeleton);
						break;
				}
			}
			
			super.onAssetComplete(evt);
		}
		
		/** 全部加载完成 **/
		private function onResourceComplete(evt:Event):void
		{
//			clearTimeOut();
			
			_param.succFun.exec(this);
		}
		/*
		private function clearTimeOut():void
		{
			if (_overTimeId)
			{
				clearTimeout(_overTimeId);
				_overTimeId = 0;
			}
		}
		*/
		/** 加载失败 **/
		private function loadError(evt:Event):void
		{
//			clearTimeOut();
			
			if (evt == null)
			{
				_param.errCode = LoaderParam.ERR_TIMEOUT;
			}
			else
			{
				if (evt.type == IOErrorEvent.IO_ERROR)
				{
					_param.errCode = LoaderParam.ERR_NO_EXIST_IO;
				}
				else
				{
					_param.errCode = LoaderParam.ERR_NO_EXIST_SECURITY;
				}
			}
			
			_param.errFun.exec(this);
		}
	}
}