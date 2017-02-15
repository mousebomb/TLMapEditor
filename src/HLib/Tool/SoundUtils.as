package HLib.Tool
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.setTimeout;
	
	import HLib.Event.Dispatcher_F;
	import HLib.Event.Event_F;
	import HLib.IResources.IResourceEvent;
	import HLib.IResources.IResourceManager;
	
	import Modules.Common.MyLoaderUIManager;
	import Modules.Map.HMapSources;
	import Modules.Wizard.WizardKey;
	
	public class SoundUtils
	{
		private static var MyInstance:SoundUtils;
		//private var _IsOpen:Boolean=true;				//声音控制
		private var _IsOpenMusic:Boolean=true;			//背景音乐控制
		private var _musicVolume:Number=0.5;			//背景音乐大小
		private var _IsOpenSount:Boolean=true;			//游戏音效控制
		private var _sountVolume:Number=0.5;			//游戏音效大小
		private var _ChannelArgs:Array=new Array();
		private var _SilentChannel:SoundChannel;
		private var _soundArr:Array;
		public function SoundUtils()
		{
			if( MyInstance ){
				throw new Error ("单例只能实例化一次,请用 getInstance() 取实例。");
			}
			MyInstance=this;
			
		}
		public static function getInstance():SoundUtils{
			if(!MyInstance){
				MyInstance = new SoundUtils();	
			}
			return MyInstance;
		}
		/**
		 * 播放音效
		 * @param packName		包名
		 * @param className		文件名
		 * @param loops			循环次数
		 * @param fileName		文件类型
		 * @param volume		音量
		 * @param delayTime		廷迟时间
		 * @param piror			优先级
		 * @param isMusic		背景音乐
		 * 
		 */		
		public function playSound(packName:String,className:String,loops:int = 0,fileName:String="",volume:Number=1.0, delayTime:int=0, piror:int=0, isMusic:int=0):void
		{
			if(isMusic > 0) //背景音乐过滤
			{
				if(!_IsOpenMusic)
					return;
			} 	else if(!_IsOpenSount)	{
				//音效过滤
				return;
			}
			var _Sound:Sound = IResourceManager.getInstance().getSound(packName,className);
			if(_Sound)
			{
				if(delayTime > 0)
				{
					setTimeout(playSoundChannel, delayTime, _Sound,className,loops,volume);
				}	else {
					playSoundChannel(_Sound,className,loops,volume)
				}
				
			}
			else
			{
				//判断当前声音是否在加载中,是加载中不再进入加载
				var eventKeyWord:String = className+"|"+loops+"|"+volume+"|"+delayTime+"|"+piror+"|"+isMusic;
				var index:int = _loadingSoundURL.indexOf(eventKeyWord);
				if(index > -1) return;
				_loadingSoundURL.push( eventKeyWord );
				
				MyLoaderUIManager.myInstance.addEventListener(eventKeyWord,onSoundComplete);
				MyLoaderUIManager.myInstance.addUITask(eventKeyWord,[[className, fileName, '.swf']], 0);
				
				//IResourceManager.getInstance().addEventListener(eventKeyWord, onSoundComplete);//packName+"|"+loops+"|"+volume,onSoundComplete);
				//IResourceManager.getInstance().AddAsk(eventKeyWord,[className],false,false,fileName);//packName+"|"+loops+"|"+volume,[packName],false,false,fileName);
			}
		}
		/**
		 * 播放音效
		 * @param _Sound
		 * @param className 文件名
		 * @param loops		定义在声道停止播放之前，声音循环回 startTime 值的次数。
		 * @param volume  	音量
		 */
		private function playSoundChannel(_Sound:Sound,className:String,loops:int,volume:Number):void
		{
			var _SoundChannel:SoundChannel = _Sound.play(0, loops);
			if(_SoundChannel)//加速报错过滤
			{
				var _SoundTransform:SoundTransform=new SoundTransform();
				_SoundTransform.volume=volume;
				_SoundChannel.soundTransform=_SoundTransform;
				if(loops<1){
					_SoundChannel.addEventListener(Event.SOUND_COMPLETE,onSoundPlayComplete);
				}
				_ChannelArgs.push([className,_SoundChannel]);
			}
		}
		private var _loadingSoundURL:Vector.<String> = new Vector.<String>();	//正在加载的声音
		
		private function onSoundComplete(e:IResourceEvent):void
		{
			//移除正在加载状态
			var eventKeyWord:String = String(e.data);
			var eventArr:Array = eventKeyWord.split("|");
			var index:int = _loadingSoundURL.indexOf(eventKeyWord);
			if(index > -1)
			{
				_loadingSoundURL.splice(index, 1);
			}	else {
				return;
			}
			MyLoaderUIManager.myInstance.removeEventListener(eventKeyWord,onSoundComplete);
			//IResourceManager.getInstance().removeEventListener(eventKeyWord, onSoundComplete);
			
			if(int(eventArr[5]) > 0 && !_IsOpenMusic) 	//背景音乐过滤
				return;
			else if(!_IsOpenSount)						//音效过滤
				return;
			var sound:Sound = IResourceManager.getInstance().getSound(eventArr[0],eventArr[0]);
			if(sound)
			{
				var delayTime:int = int(eventArr[3])
				if(delayTime > 0)
				{
					setTimeout(playSoundChannel, delayTime, sound,eventArr[0],int(eventArr[1]),Number(eventArr[2]));
				}	else {
					playSoundChannel(sound,eventArr[0],int(eventArr[1]),Number(eventArr[2]))
				}
				/*var soundChannel:SoundChannel = sound.play(0, int(eventArr[1]));
				if(soundChannel)
				{
					var soundTransform:SoundTransform=new SoundTransform();
					soundTransform.volume=Number(eventArr[2]);
					soundChannel.soundTransform=soundTransform;
					if(int(eventArr[1])<1){
						soundChannel.addEventListener(Event.SOUND_COMPLETE,onSoundPlayComplete);
					}
					_ChannelArgs.push([eventArr[0], soundChannel]);
				}*/
			}
		}
		private function onSoundPlayComplete(e:Event):void{
			var _SoundChannel:SoundChannel=e.target as SoundChannel;
			stopSoundChannel(_SoundChannel);
		}
		public function playSilentMusic():void{
			
			MyLoaderUIManager.myInstance.addEventListener("Music_Silent",onSilentComplete);
			MyLoaderUIManager.myInstance.addUITask("Music_Silent",[["Music_Silent", '', '.swf']], 0);
			
			/*IResourceManager.getInstance().addEventListener("Music_Silent",onSilentComplete);
			IResourceManager.getInstance().AddAsk("Music_Silent",["Music_Silent"],false,false);*/
		}
		private function onSilentComplete(e:IResourceEvent):void{/*
			IResourceManager.getInstance().removeEventListener("Music_Silent",onSilentComplete);
			_SilentChannel=IResourceManager.getInstance().getSound("Music_Silent","Music_Silent").play(0, int.MAX_VALUE);*/
			_SilentChannel=IResourceManager.getInstance().getSound("Music_Silent","Music_Silent").play(0, int.MAX_VALUE);
			MyLoaderUIManager.myInstance.removeEventListener('Music_Silent', onSilentComplete);
			Dispatcher_F.getInstance().addEventListener(WizardKey.FirAction_PlySound,onPlySound);
		}
		public function onPlySound(e:Event_F):void{
			if(!this._IsOpenSount) return;
			var _SoundArgs:Array=e.data as Array;
			var arr:Array = _SoundArgs[1].split("|");
			var soundName:String=arr.length > 1 ? arr[1] : arr[0];
			if(arr.length > 1)
				playSound(soundName,soundName,_SoundArgs[2],_SoundArgs[0], this._sountVolume, int(arr[0]), int(arr[2]));
			else
				playSound(soundName,soundName,_SoundArgs[2],_SoundArgs[0], this._sountVolume)
			
		}
		public function stopSound(_ClassName:String):void
		{
			var _Index:int=-1;
			for(var i:int=0;i<_ChannelArgs.length;i++){
				if(_ChannelArgs[i][0]==_ClassName){
					_Index=i;
					break;
				}
			}
			if(_Index>-1)
			{
				_ChannelArgs[_Index][1].stop();
				_ChannelArgs[_Index][1] = null;
				_ChannelArgs[_Index][0] = null;
				_ChannelArgs.splice(_Index,1);
			}
		}
		/**获取指定的音乐*/
		public function getSoundChannel(_ClassName:String):SoundChannel
		{
			for(var i:int=0;i<_ChannelArgs.length;i++){
				if(_ChannelArgs[i][0]==_ClassName){
					return _ChannelArgs[i][1];
				}
			}
			return null;
		}
		public function stopSoundChannel(_SoundChannel:SoundChannel):void
		{
			var _Index:int=-1;
			for(var i:int=0;i<_ChannelArgs.length;i++){
				if(_ChannelArgs[i][1]==_SoundChannel){
					_Index=i;
					break;
				}
			}
			if(_Index>-1)
			{
				_ChannelArgs[_Index][1].stop();
				_ChannelArgs[_Index][1] = null;
				_ChannelArgs[_Index][0] = null;
				_ChannelArgs.splice(_Index,1);
			}
		}
		public function stopAllSound():void
		{
			for(var i:int=0;i<_ChannelArgs.length;i++){
				_ChannelArgs[i][1].stop();
				_ChannelArgs[i][1] = null;
				_ChannelArgs[i][0] = null;
			}
			_ChannelArgs=new Array();
			_loadingSoundURL.length = 0;
		}
		
		public function isSoundPlaying(_ClassName:String):Boolean
		{
			var _Index:int=-1;
			for(var i:int=0;i<_ChannelArgs.length;i++){
				if(_ChannelArgs[i][0]==_ClassName){
					_Index=i;
					break;
				}
			}
			if(_Index>-1)
			{
				return true;
			}			
			return false;
		}
		/*public function set IsOpen(value:Boolean):void{
			_IsOpen=value;
		}*/
		/**声音控制*/
		/*public function get IsOpen():Boolean{
			return _IsOpen;
		}*/
		
		/**背景音乐控制, true为打开*/
		public function get IsOpenMusic():Boolean
		{
			return _IsOpenMusic;
		}
		/**背景音乐控制, true为打开*/
		public function set IsOpenMusic(value:Boolean):void
		{
			_IsOpenMusic = value;
			if(HMapSources.getInstance().mapData)
			{
				var music:String = HMapSources.getInstance().mapData.music;
				var flg:Boolean = isSoundPlaying(music);
				if(flg != value)
				{
					if(value)
						playSound(music, music, int.MAX_VALUE, "sound", _musicVolume, 0, 0, 1);
					else
						stopSound(music);
				}
			}
		}

		public function get IsOpenSount():Boolean
		{
			return _IsOpenSount;
		}
		/**游戏音效控制, true为打开*/
		public function set IsOpenSount(value:Boolean):void
		{
			_IsOpenSount = value;
		}

		public function get musicVolume():Number
		{
			return _musicVolume;
		}

		public function set musicVolume(value:Number):void
		{
			_musicVolume = value;
		}

		public function get sountVolume():Number
		{
			return _sountVolume;
		}

		public function set sountVolume(value:Number):void
		{
			_sountVolume = value;
		}


	}
}