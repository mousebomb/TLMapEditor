package HLib.Tool
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import HLib.DataUtil.HashMap;
	import HLib.Event.Dispatcher_F;
	import HLib.Event.ModuleEventDispatcher;
	import HLib.IResources.IResourceEvent;
	import tl.core.IResourceKey;
	import HLib.IResources.IResourceManager;
	import HLib.IResources.IResourcePool;
	import HLib.UICom.BaseClass.HMovieClip;
	
	import Modules.Common.ComEventKey;
	import Modules.Common.HAssetsManager;
	import Modules.Common.HAtfAssetsManager;
	import Modules.Common.MyLoaderUIManager;
	import Modules.Common.SGCsvManager;
	import Modules.Common.SourceTypeEvent;
	import Modules.DataSources.ChatDataSource;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	/**
	 * 特效播放类 
	 * @author Administrator
	 * 郑利本
	 */
	public class EffectPlayerManage
	{
		private static var _instance:EffectPlayerManage;
		private var _sourceList:Dictionary = new Dictionary;;					//资源集合
		//private var _moveLish:Vector.<HMovieClip> = new <HMovieClip>[];				//播放数组
		private var _hash:HashMap = new HashMap;
		private var _isInit:Boolean;
		private var _nameList:Array = [];
		public function EffectPlayerManage()
		{
		}
		
		public static function getMyInstance():EffectPlayerManage
		{
			if(_instance == null)
				_instance = new EffectPlayerManage;
			return _instance;
		}
		
		public function Init():void
		{
			/*IResourceManager.getInstance().addEventListener("icon_effect",onLoadComplete);
			var sourceType:String = IResourceKey.starlingCanUseATF == true ? ".atf" : ".png";
			IResourceManager.getInstance().AddAsk("icon_effect",["icon_effect", "icon_effect_A"],false,false,"Bitmap",sourceType);*/
			
			MyLoaderUIManager.myInstance.addEventListener("IconEffect",onLoadComplete);
			MyLoaderUIManager.myInstance.addUITask("IconEffect",[["icon_effect", 'Bitmap', '.atf'], ["icon_effect_A", 'Bitmap', '.atf']], 0);
		}
		
		/**数据找回时刷新*/
		private function onRestoreEffect(event:flash.events.Event):void
		{
			Dispatcher_F.getInstance().removeEventListener(ComEventKey.CONTEXT_CREATED, onRestoreEffect); 
			onLoadComplete(null);
		}

		private static function empty():void {}
		protected function onLoadComplete(event:IResourceEvent):void
		{
			MyLoaderUIManager.myInstance.removeEventListener("IconEffect",onLoadComplete);
			if(ChatDataSource.getMyInstance().isDisposed || Starling.context.driverInfo == "Disposed")
			{ 
				Dispatcher_F.getInstance().addEventListener(ComEventKey.CONTEXT_CREATED, onRestoreEffect); 
				return;
			}
			_isInit = true;
			if(IResourceKey.starlingCanUseATF)
			{
				if(!HAtfAssetsManager.getMyInstance().hasAtfAtlas('IconEffect', 'icon_effect'))
				{
					var byteArray:ByteArray = IResourcePool.getInstance().getByteArrayResource("icon_effect");
					xml = SGCsvManager.getInstance().getXml("icon_effect");
					var atlas:TextureAtlas = new TextureAtlas(Texture.fromAtfData(byteArray, 1, false,empty), xml);
					HAtfAssetsManager.getMyInstance().addAtfTextureAtlas("IconEffect", "icon_effect", atlas);
				}
				if(!HAtfAssetsManager.getMyInstance().hasAtfAtlas('IconEffect', 'icon_effect_A'))
				{	
					byteArray = IResourcePool.getInstance().getByteArrayResource("icon_effect_A");
					xml = SGCsvManager.getInstance().getXml("icon_effect_A");
					atlas = new TextureAtlas(Texture.fromAtfData(byteArray, 1, false,empty), xml);
					HAtfAssetsManager.getMyInstance().addAtfTextureAtlas("IconEffect", "icon_effect_A", atlas);	
				}
			}	
			else
			{
				return;
				var source:BitmapData = new BitmapData(2048, 2048, true, 0x0);
				var bmd:BitmapData = IResourceManager.getInstance().getImageBMD("icon_effect");
				var rect:Rectangle = new Rectangle(0, 0, 2048, 1024);
				source.copyPixels(bmd, rect, new Point);
				bmd = IResourceManager.getInstance().getImageBMD("icon_effect_A");
				source.copyPixels(bmd, rect, new Point(0, 1024));
				
				var sourceXml:XML = SGCsvManager.getInstance().getXml("icon_effect");
				var xml:XML = SGCsvManager.getInstance().getXml("icon_effect_A");
				var num:XML,vx:Number=0, vy:Number=0;
				for each (num in xml.SubTexture) {
					vy = Number(num.@y) + 1024;
					num.@y = vy;    
				}
				sourceXml.appendChild(xml.child("SubTexture"));
				HAssetsManager.getInstance().addTextureAtla("IconEffect", source, sourceXml);
			}
			
			for(var i:int=0; i<_nameList.length; i++)
			{
				var vector:Vector.<Texture> = HAssetsManager.getInstance().getMyTextures(_nameList[i][1], _nameList[i][0]);
				_sourceList[_nameList[i][0]] = vector;
			}
			ModuleEventDispatcher.getInstance().dispatchEventWith("IconEffectLoadComplete");
		}
		
		/**添加一组序列帧图片*/		
		public function addEffect(effectName:String, source:String = "IconEffect"):void
		{
			if(_sourceList[effectName])
			{
				return;
			}
			
			if(_isInit)
			{
				var vector:Vector.<Texture> = HAssetsManager.getInstance().getMyTextures(source, effectName);
				_sourceList[effectName] = vector;
			}
			else 
			{
				_nameList.push([effectName, source]);
			}
		}
		
		/**
		 * 播放指定的特效 
		 * @param effectName 	特效名
		 * @param parent		添加的父类
		 * @param isRemove		是否播放一次删除
		 * @param playSpeed 	播放速度
		 * @param vx			定位
		 * @param vy
		 * 
		 */		
		public function playEffect(effectName:String, parent:Sprite, vx:Number=0, vy:Number=0, playSpeed:int=1, isRemove:Boolean=true, sourceName:String="IconEffect"):HMovieClip
		{
			if(!_isInit)
			{
				addEffect(effectName, sourceName);
				return null;
			}
			if(_sourceList[effectName])
			{
				var mov:HMovieClip = getHmovieClip(effectName);
				mov.setTextureList(_sourceList[effectName]);
				mov.PlaySpeed = playSpeed;
				mov.IsPlayEvent = isRemove
				parent.addChild(mov);
				mov.x = vx;
				mov.y = vy;
				
				if(effectName == "inheritEffect" || effectName == "identifictaionEffect" || effectName == "RecastingEffect" || effectName == "SyntheticEffect" || effectName == "decompositionEffect")
				{
					return mov
				} 	else {
					if(isRemove)
						mov.addEventListener("PlayerOverOnce", removeEffect);
					mov.Play();
					return mov
				}
			}	else {
				var texture:Texture;
				var vector:Vector.<Texture> = new <Texture>[];
				var isAddArgs:Boolean , isAddOne:Boolean;
				if(effectName == "inheritEffect")
				{
					//传承背景
					isAddOne = true;
					texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_4, "effect/equipt_11");
				} 	else if(effectName == "decompositionEffect") {
					//分解背景
					isAddOne = true;
					texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_4, "effect/equipt_9");
				} 	else if(effectName == "SyntheticEffect") {
					//合成背景
					isAddOne = true;
					texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_4, "effect/equipt_7");
				}	else if(effectName == "identifictaionEffect") {
					//鉴定背景
					isAddOne = true;
					texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_4, "effect/equipt_6");
				}	else if(effectName == "RecastingEffect") {
					//重铸背景
					isAddOne = true;
					texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_4, "effect/equipt_5");	
				}	else if(effectName == "strongSucceed") {
					//强化成功字体
					isAddArgs = true;
					texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_4, "effect/equipt_4_1");
				}	else if(effectName == "strongFail") {
					//强化失败字体
					isAddArgs = true;
					texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_4, "effect/equipt_4_2");
				}	else if(effectName == "identifictaionSucceed") {
					//鉴定成功字体
					isAddArgs = true;
					texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_4, "effect/equipt_2");
				} 	else if(effectName == "saveSucceed") {
					//鉴定保存成功字体
					isAddArgs = true;
					texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_4, "effect/equipt_8");
				} 	else if(effectName == "RecastingSucceed") {
					//重铸成功字体
					isAddArgs = true;
					texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_4, "effect/equipt_3");
				} 	else if(effectName == "SyntheticSucceed") {
					//合成成功字体
					isAddArgs = true;
					texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_4, "effect/equipt_1");
				}	else if(effectName == "decompositionSucceed") {
					//分解成功字体
					isAddArgs = true;
					texture = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_4, "effect/equipt_10");
				}	else if (effectName == "playAutoWarEffect") {
					//自动战斗
					isAddArgs = true;
					texture = HAssetsManager.getInstance().getMyTexture(sourceName, "autoWar");
				}	else
					vector = HAssetsManager.getInstance().getMyTextures(sourceName, effectName);
				if(isAddArgs)
				{
					for(var i:int=0; i<8; i++)
					{
						vector.push(texture);
					}
				}
				if(isAddOne)
					vector.push(texture);
				if(vector)
				{
					_sourceList[effectName] = vector;
					return playEffect(effectName, parent, vx, vy, playSpeed, isRemove);
				}	else
					return null;
			}
		}
		
		private function removeEffect(e:starling.events.Event):void
		{
			var mov:HMovieClip = e.currentTarget as HMovieClip
			mov.removeEventListener("PlayerOverOnce", removeEffect);
			mov.Clear_FrameArgs();
			mov.parent.removeChild(mov);
			mov.Stop();
			var arr:Array = _hash.get(mov.name);
			if(arr)
			{
				arr.push(mov);
			}	else {
				arr = [mov];
				_hash.put(mov.name, arr);
			}
			//_moveLish.push(mov);
		}
		/**获取特效*/
		private function getHmovieClip(nameStr:String):HMovieClip
		{
			var arr:Array = _hash.get(nameStr);
			if(!arr)
			{
				arr = [];
				_hash.put(nameStr, arr);
			}
			
			var mov:HMovieClip;
			if(arr.length > 0)
			{
				mov = arr.pop();
			}	else {
				mov = new HMovieClip;
				mov.name = nameStr;
				mov.touchable = false;
				mov.name = nameStr;
			}
			return mov;
		}
		/**添加*/
		public function addHmovieClip(mov:HMovieClip):void
		{
			mov.Clear_FrameArgs();
			mov.removeEventListener("PlayerOverOnce", removeEffect);
			mov.parent.removeChild(mov);
			mov.Stop();
			var arr:Array = _hash.get(mov.name);
			if(arr)
			{
				arr.push(mov);
			}	else {
				arr = [mov];
				_hash.put(mov.name, arr);
			}
		}
		/**初始化标志*/
		public function get isInit():Boolean
		{
			return _isInit;
		}

	}
}