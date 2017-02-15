package tl.IResources
{
	import away3DExtend.E_MD5AnimParser;
	import away3DExtend.E_MD5MeshParser;
	import away3DExtend.MeshExtend;

	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.data.Skeleton;
	import away3d.animators.nodes.SkeletonClipNode;
	import away3d.entities.ParticleGroup;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.assets.AssetType;
	import away3d.loaders.AssetLoader;
	import away3d.loaders.misc.AssetLoaderContext;
	import away3d.loaders.parsers.ImageParser;
	import away3d.loaders.parsers.ParserBase;
	import away3d.loaders.parsers.ParticleGroupParser;
	import away3d.textures.Texture2DBase;

	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;

	import org.mousebomb.framework.GlobalFacade;

	import tl.frameworks.NotifyConst;
	import tl.mapeditor.Config;

	public class IResourceLoader3D extends AssetLoader
	{
		private var _PackName:String;
		private var _SubPath:String;
		private var _ExtString:String;
		private var _IsShowProgress:Boolean=false;
		private var _Register:Boolean=false;
		public function IResourceLoader3D()
		{
			super();
			this.addEventListener(LoaderEvent.LOAD_ERROR, onLoadError, false, 0, true);			    //加载失败
			this.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete, false, 0, true);			//每一面加载处理
			this.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);				    //加载进度
		}

		public function get register():Boolean
		{
			return _Register;
		}

		public function set register(value:Boolean):void
		{
			_Register = value;
		}

		public function set IsShowProgress(value:Boolean):void{
			_IsShowProgress=value;
		}
		public function get IsShowProgress():Boolean{
			return _IsShowProgress;
		}
		public function myLoad(packName:String,subPath:String,extString:String=".swf",context:AssetLoaderContext=null, ns:String=null, parser:ParserBase=null):void{
			_PackName=packName;
			_SubPath=subPath;
			_ExtString=extString;
			IResourceLoader3DManager.getInstance().Register(this);
		}
		public function start():void{
			var _Parser:*;
			var _ResSuffix:String;
			switch(_ExtString)
			{
				case IResourceKey.Suffix_Mesh:			//判断是否为网格(模型)
					_ResSuffix=IResourceKey.Suffix_Mesh;
					_Parser=new E_MD5MeshParser();
					break;
				case IResourceKey.Suffix_Material:	   //判断是否为贴图(png)
					_ResSuffix=IResourceKey.Suffix_TextureMaterial;
					_Parser=new ImageParser();
					break;
				case IResourceKey.Suffix_Anim:	      //判断是否为动作
					_ResSuffix=IResourceKey.Suffix_SkeletonClipNode;
					_Parser=new E_MD5AnimParser();
					break;
				case IResourceKey.Suffix_Effect:	      //判断是否为动作
					_ResSuffix=IResourceKey.Suffix_Effect;
					_Parser=new ParticleGroupParser();
					break;
				default:
					_ResSuffix="";
					_Parser=null;
					break;
			}
			if(IResourcePool.getInstance().getResource(_PackName+_ResSuffix)==null){
//				if(IResourceManager.getInstance().Config==null) return;
//				if(_IsShowProgress){
//					IResourceBar.getInstance().IsOver=false;
//					IResourceBar.getInstance().setProgress(0,100);
//				}
				
				this.load(new URLRequest(Config.PROJECT_URL+_SubPath+"/"+_PackName+_ExtString+"?v="+Config.VERSION_NUN),
					null,_PackName, _Parser
				);
				trace("Loading "+_PackName+_ResSuffix+"  go");
				GlobalFacade.sendNotify(NotifyConst.LOG,this,"Loading "+_PackName+_ResSuffix+"  go");
//				HLog.getInstance().appMsg("Loading "+_PackName+_ResSuffix+"  go" );
			}else{
				switch(_ResSuffix)
				{
					case IResourceKey.Suffix_Mesh:			//判断是否为网格(模型)
						this.dispatchEvent(new IResourceEvent(IResourceEvent.MeshComplete));
						break;
					case IResourceKey.Suffix_TextureMaterial:	   //判断是否为贴图(png)
						this.dispatchEvent(new IResourceEvent(IResourceEvent.MaterialComplete));
						break;
					case IResourceKey.Suffix_Anim:	        //判断是否为动作
						this.dispatchEvent(new IResourceEvent(IResourceEvent.SkeletonClipNodeComplete,_PackName));
						break;
					case IResourceKey.Suffix_Effect:	        //判断是否为特效
						this.dispatchEvent(new IResourceEvent(IResourceEvent.ParticleGroupComplete,_PackName+_ResSuffix));
						break;					
					default:
						this.dispatchEvent(new IResourceEvent(IResourceEvent.Error));
						break;
				}
				if(this.register){
					this.dispatchEvent(new IResourceEvent(IResourceEvent.RegisterComplete));
				}
//				trace("Loading "+_PackName+"  is exist");
//				HLog.getInstance().appMsg("Loading "+_PackName+"  is exist");
			}
		}
		private function onResWindowClose(e:Event):void{
			if(_IsShowProgress){
//				IResourceBar.getInstance().IsOver=true;
			}
		}
		private function onLoadError(e:LoaderEvent):void {
			_PackName=parserPackName(e.url)[2];
			trace("Loading "+_PackName+"    There was an error");
			GlobalFacade.sendNotify(NotifyConst.LOG,this,"Loading "+_PackName+"    There was an error");
//			HLog.getInstance().appMsg("Loading "+_PackName+"    There was an error");
//			var _HAlertItem:HAlertItem=HAlert.show("找不到加载需要的资源文件！"+_PackName,"加载错误",IResourceBar.getInstance(),"确定");
//			_HAlertItem.addEventListener("WindowClose",onResWindowClose);
			this.dispatchEvent(new IResourceEvent(IResourceEvent.Error,_PackName));	
		}
		
		private function onProgress(e:ProgressEvent):void {
			if(!_IsShowProgress) return;
//			IResourceBar.getInstance().setProgress(int(e.bytesLoaded),int(e.bytesTotal));
		}
		/** 每一面加载完成处理 **/
		private function onAssetComplete(e:AssetEvent):void
		{
			var _PackName:String = e.asset.assetNamespace;
			switch(e.asset.assetType)
			{
				case AssetType.MESH:			//判断是否为网格(模型)
					var mesh:MeshExtend = MeshExtend(e.asset);
					mesh.name = _PackName+IResourceKey.Suffix_Mesh;
					//保存模型
					IResourcePool.getInstance().addResource(mesh.name, mesh);
//					trace("获取模型完成："+mesh.name);
					GlobalFacade.sendNotify(NotifyConst.LOG,this,"获取模型完成："+mesh.name);
//					HLog.getInstance().addLog("获取模型完成："+mesh.name);
					this.dispatchEvent(new IResourceEvent(IResourceEvent.MeshComplete));
					break;
				case AssetType.TEXTURE:			//判断是否为贴图(png)
					var bitmapTexture:Texture2DBase=Texture2DBase(e.asset);
					bitmapTexture.name=_PackName+IResourceKey.Suffix_TextureMaterial;
					//保存模型
					IResourcePool.getInstance().addResource(bitmapTexture.name, bitmapTexture);
//					trace("获取贴图完成："+bitmapTexture.name);
					GlobalFacade.sendNotify(NotifyConst.LOG,this,"获取贴图完成："+bitmapTexture.name);
//					HLog.getInstance().addLog("获取贴图完成："+bitmapTexture.name);
					this.dispatchEvent(new IResourceEvent(IResourceEvent.MaterialComplete));
					break;
				case AssetType.ANIMATION_NODE:	//判断是否为动作
					var node:SkeletonClipNode = SkeletonClipNode(e.asset);
					node.name = _PackName
					//保存动作
					IResourcePool.getInstance().addResource(node.name, node);
//					trace("获取动作完成:"+node.name);
					GlobalFacade.sendNotify(NotifyConst.LOG,this,"获取动作完成:"+node.name);
//					HLog.getInstance().addLog("获取动作完成:"+node.name);
					this.dispatchEvent(new IResourceEvent(IResourceEvent.SkeletonClipNodeComplete,node.name));
					break;
				case AssetType.ANIMATION_SET:	//判断是否为动作数据集
					if(e.asset is SkeletonAnimationSet){
						var skeletonAnimationSet:SkeletonAnimationSet = SkeletonAnimationSet(e.asset);
						skeletonAnimationSet.name=_PackName+IResourceKey.Suffix_SkeletonAnimationSet;
						//保存动作数据集
						IResourcePool.getInstance().addResource(skeletonAnimationSet.name, skeletonAnimationSet);
//						trace("获取动作数据集完成:"+skeletonAnimationSet.name);
						GlobalFacade.sendNotify(NotifyConst.LOG,this,"获取动作数据集完成:"+skeletonAnimationSet.name);
//						HLog.getInstance().addLog("获取动作数据集完成:"+skeletonAnimationSet.name);
						this.dispatchEvent(new IResourceEvent(IResourceEvent.SkeletonAnimationSetComplete));
					}
					break;
				case AssetType.SKELETON:		//判断是否为骨骼
					var skeleton:Skeleton = Skeleton(e.asset);
					skeleton.name=_PackName+IResourceKey.Suffix_Skeleton;
					//保存骨骼
					IResourcePool.getInstance().addResource(skeleton.name, skeleton);
//					trace("获取骨骼完成:"+skeleton.name);
					GlobalFacade.sendNotify(NotifyConst.LOG,this,"获取骨骼完成:"+skeleton.name);
//					HLog.getInstance().addLog("获取骨骼完成:"+skeleton.name);
					this.dispatchEvent(new IResourceEvent(IResourceEvent.SkeletonComplete));
					break;
				case AssetType.CONTAINER:	  //判断是否为特效(awp)
					var particleGroup:ParticleGroup=e.asset as ParticleGroup;
					particleGroup.name = _PackName+IResourceKey.Suffix_Effect;
					//保存模型
					IResourcePool.getInstance().addResource(particleGroup.name, particleGroup);
//					trace("获取特效完成："+particleGroup.name);
					GlobalFacade.sendNotify(NotifyConst.LOG,this,"获取特效完成："+particleGroup.name);
//					HLog.getInstance().addLog("获取特效完成："+particleGroup.name);
					this.dispatchEvent(new IResourceEvent(IResourceEvent.ParticleGroupComplete,particleGroup.name));
					break;
				default:
					break;
			}
			if(this.register){
				this.dispatchEvent(new IResourceEvent(IResourceEvent.RegisterComplete));
			}
		}
		private function parserPackName(url:String):Array{
			var _Args1:Array=url.split("/");
			_Args1=_Args1[_Args1.length-1].split("?");
			_Args1=_Args1[0].split(".");
			_Args1.push(_Args1[0]+"."+_Args1[1]);
			return _Args1;
		}

		public function get packName():String
		{
			return _PackName;
		}

		public function get subPath():String
		{
			return _SubPath;
		}

		public function get extString():String
		{
			return _ExtString;
		}


	}
}

