package HLib.UICom.Component.richText
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	
	import HLib.UICom.BaseClass.HBaseView;
	import HLib.UICom.BaseClass.HSprite;
	import HLib.UICom.BaseClass.HTopBaseView;
	
	import Modules.Common.Component.SuperTimer;
	import Modules.MainFace.MouseCursorManage;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class TextMovieClip extends HSprite
	{
		private var _isStart:Boolean;				//鼠标开始
		private var _mouseHand:Boolean;			//手形标志
		private var _length:int;					//纹理数组长度
		private var _vector:Vector.<Texture>;		//图片组
		private var _FrameKey:int;					//当前播放帧
		private var _isPlay:Boolean=false;	//是否开始播放
		private var _PlaySpeed:int=1;				//播放速度
		private var _SpeedFrameKey:int=0;			//播放速度几帧切换一次图片
		public var src:String;						//资源路经 
		public var nameStr:String;					//命名
		private var _timer:SuperTimer;
		public function TextMovieClip()
		{
			this.isNotDispatch = true;
			super();
		}
		
		
		/**鼠标事件*/	
		private function onTouch(e:TouchEvent):void
		{
			if(HTopBaseView.getInstance().hasEvent ) return; //顶层是否添加UI了
			var touch:Touch = e.getTouch(this);
			if(touch == null)
			{
				MouseCursorManage.getInstance().showCursor();
				return;
			}
			if(touch.phase == TouchPhase.BEGAN)
			{
				MouseCursorManage.getInstance().showCursor(9);
				_isStart = true;
			}
			if(touch.phase == TouchPhase.HOVER)
			{
				MouseCursorManage.getInstance().showCursor(3);
			}	
			if(touch.phase == TouchPhase.ENDED)
			{
				_isStart = false;
				MouseCursorManage.getInstance().showCursor(3);
				this.dispatchEventWith(starling.events.Event.TRIGGERED,true,{src:src, nameStr:nameStr});
				HBaseView.getInstance().clearMOuseCursor()
			}
		}
		/**开始播放*/	
		public function play():void
		{
			_isPlay=true;
			if(length < 1) return;
			if(_timer == null)
			{
				_timer = new SuperTimer(100, 0);
				_timer.addEventListener(TimerEvent.TIMER, advanceTime);	
			}
			_timer.start();
			if(_mouseHand)
				this.addEventListener(TouchEvent.TOUCH,onTouch)
		}
		
		/**停止播放 */
		public function stop():void
		{
			_isPlay=false;
			_timer.stop();
			this.removeEventListener(TouchEvent.TOUCH,onTouch)
		}
		
		public function set PlaySpeed(value:int):void{
			if(value<0){value=0;}
			_PlaySpeed=1;
		}
		public function get PlaySpeed():int{
			return _PlaySpeed;
		}
		/**定时刷新*/
		public function advanceTime(e:TimerEvent):void
		{
			if(_vector == null) return;
			if(_isPlay)
			{
				this.myDrawByTexture(_vector[_FrameKey]);
				_FrameKey++;
				if(_FrameKey >= _length)
					_FrameKey=0;
			}
			/*if(_isPlay){
				if(_SpeedFrameKey>=_PlaySpeed){
					_SpeedFrameKey=0;
					_length = _vector.length;
					this.myDrawByTexture(_vector[_FrameKey]);
					_FrameKey++;
					if(_FrameKey >= _length){
						_FrameKey=0;
					}
				}
				else{
					_SpeedFrameKey++;
				}
			}*/
			
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
			_length = _vector.length;		
			this.myDrawByTexture(_vector[0]);
		}

		public function get isPlay():Boolean
		{
			return _isPlay;
		}
		/**是否在播放		 */
		public function set isPlay(value:Boolean):void
		{
			_isPlay = value;
		}

	}
}