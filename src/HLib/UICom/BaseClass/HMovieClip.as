package HLib.UICom.BaseClass
{
	import Modules.MainFace.MainInterfaceManage;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
	import tool.PropertyCount;

	/**
	 * 序列帧播放器 
	 * @author Administrator
	 * 郑利本
	 */
	public class HMovieClip extends HSprite
	{
		private var _FrameArgs:Array;				//序列帧数组
		private var _PlaySpeed:int=1;				//播放速度
		private var _IsornotPlay:Boolean=false;	//是否开始播放
		private var _IsPlayEvent:Boolean=false;	//是否要发送事件
		private var _FrameKey:int=0;				//当前帧
		private var _SpeedFrameKey:int=0;			//播放速度几帧切换一次图片
		private var _vector:Vector.<Texture>;
		private var _isTexture:Boolean;			//是否texture
		private var _length:uint;
		private var _playTime:int = 1;				//播放次数.如果 是负数为持续播放
		private var _totalFrame:int;           //总帧数
		private var _isStopOver:Boolean = false;
		public function HMovieClip()
		{
			//移出舞台时执行
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoverFromStage);
		}

		private function onRemoverFromStage(e:Event):void		
		{ 
			if(_IsornotPlay && !_IsPlayEvent)
				Stop()
		}
		
		public function get isStopOver():Boolean
		{
			return _isStopOver;
		}

		public function set isStopOver(value:Boolean):void
		{
			_isStopOver = value;
		}

		public function get totalFrame():int
		{
			_totalFrame = _vector.length;
			return _totalFrame;
		}


		public function advanceTime(time:Number=0):void
		{
			if(_isTexture && _vector == null) return;
			if(!_isTexture && _FrameArgs==null) return;
			PropertyCount.getInstance().keyStart("UIScene.HMovieClip","HFrameWorkerManager");
			if(_IsornotPlay){
				if(_SpeedFrameKey>=_PlaySpeed){
					_SpeedFrameKey=0;
					if(_isTexture)
					{
						_length = _vector.length;
						this.myDrawByTexture(_vector[_FrameKey]);
					}	else {
						_length = _FrameArgs.length
						this.myDrawByTexture(Texture.fromBitmapData(_FrameArgs[_FrameKey], false));
					}
					_FrameKey++;
					if(_FrameKey >= _length){
						_FrameKey=0;
						if(_isStopOver)
						{
							Stop();
						}
						//如果需要发事件，则一组动作播完之后派发事件
						if(_IsPlayEvent){
							SendEvent();
						}
					}
				}
				else{
					_SpeedFrameKey++;
				}
			}
			PropertyCount.getInstance().keyEnd("UIScene.HMovieClip","HFrameWorkerManager");
		}
		
		
		public function gotoAndStop(index:int):void
		{
			Stop();
			if(_vector == null) return;
			if(_vector.length < index) index = _vector.length;
			if(index < 1) index = 1;
			this.myDrawByTexture(_vector[index - 1]);
			
		}
		
		public function gotoAndPlay(index:int):void
		{
			if(_vector == null) return;
			if(_vector.length < index) index = _vector.length;
			if(index <= 0) index = 1;
			this.myDrawByTexture(_vector[index - 1]);
			_FrameKey = index;
			Play();
		}
		
		/**
		 * 设定纹理图片组 
		 * @param vector
		 * 
		 */		
		public function setTextureList(vector:Vector.<Texture>):void
		{
			if(vector==null || vector.length<1 || vector[0]==null) return;
			_vector = vector
			_FrameKey=0;			
			_isTexture = true;
			this.myDrawByTexture(_vector[0]);
			//混合 效果
			//this.myImage.blendMode = BlendMode.ADD;
		}
		/**
		 *  播放设置
		 * @param frameargs	设定序列帧数组
		 * @param Direction 设定方向0为正常1为反方向
		 * 
		 */		
		public function setFrameArray(frameargs:Array,Direction:int=0):void{
			if(frameargs==null || frameargs.length<1 || frameargs[0]==null) return;
			if(Direction==1){
				for(var i:int=0;i<frameargs.length;i++){
					frameargs[i]=FrameArray.LevelFlip(frameargs[i]);
				}
			}
			_isTexture = false;
			_FrameKey=0;			
			_FrameArgs=frameargs;
			this.myDrawByTexture(Texture.fromBitmapData(_FrameArgs[0], false));
		}
		
		public function Play():void{
			if(_IsornotPlay) return;
			_IsornotPlay=true;
			MainInterfaceManage.getInstance().timeFrameWorker.addFunction(advanceTime);
		}
		public function Stop():void{
			if(!_IsornotPlay) return;
			_IsornotPlay=false;
			MainInterfaceManage.getInstance().timeFrameWorker.removeFunction(advanceTime);
		}
		public function Clear_FrameArgs():void{
			this.Stop();
			_vector = null;
			_FrameArgs=null;
		}
		private function SendEvent():void{
			this.dispatchEventWith("PlayerOverOnce");
		}
		public function set PlaySpeed(value:int):void{
			if(value<0){value=0;}
			_PlaySpeed=value;
		}
		public function get PlaySpeed():int{
			return _PlaySpeed;
		}
		public function set IsPlayEvent(value:Boolean):void{
			_IsPlayEvent=value;
		}
		public function get IsPlayEvent():Boolean{
			return _IsPlayEvent;
		}

		public function get playTime():int
		{
			return _playTime;
		}

		public function set playTime(value:int):void
		{
			_playTime = value;
		}
		/**是否在播放属性*/
		public function get IsornotPlay():Boolean
		{
			return _IsornotPlay;
		}

		public function disposeVectorTexture():void
		{
			Stop();
			super.disposeMyImage()
			var leng:int = _vector.length;
			for(var i:int=0; i<leng; i++)
			{
				_vector[i].dispose();
			}
			_vector = null;
		}

	}
}