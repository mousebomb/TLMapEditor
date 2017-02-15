package HLib.Video
{
	/**
	 * 视频控制管理类
	 * @author 李舒浩
	 * 
	 * 使用URL播放:
	 * 	var videoControl:VideoControl = new VideoControl();
	 *	videoControl.videoWidth = 视频宽度;
	 *	videoControl.videoHeight = 视频高度;
	 *	videoControl.addParent( _videoSprite );
	 *  videoControl.url = "Res/TestCGFLV_1024x768.flv";
	 * 
	 * 视频流播放(暂时发现只支持FLV格式):
	 *  var urlLoader:URLLoader = new URLLoader();
	 *  urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
	 *  urlLoader.addEventListener(Event.COMPLETE, onURLLoaderComplete);
	 *  urlLoader.load(new URLRequest("Res/TestCGFLV_1024x768.flv"));
	 * 
	 *  private function onURLLoaderComplete(e:Event):void
	 *  {
	 * 		URLLoader(e.currentTarget).removeEventListener(Event.COMPLETE, onURLLoaderComplete);
	 * 
	 * 		var byteArray:ByteArray = URLLoader(e.currentTarget).data;
	 * 		videoControl.videoByte = byteArray;
	 * 		URLLoader(e.currentTarget).close();
	 *  }
	 * 
	 */	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.NetStreamAppendBytesAction;
	import flash.utils.ByteArray;

	public class VideoControl
	{
		/** 开始播放 **/
		public static const NETSTREAM_PLAY_START:String = "NetStream.Play.Start";
		/** 播放结束 **/
		public static const NETSTREAM_PLAY_STOP:String = "NetStream.Play.Stop";
		/** 
		 * 视频开始播放回调
		 * value : this
		 */
		public var videoStartCallBack:Function;
		/** 
		 * 播放完成回调
		 * value : this
		 */
		public var videoEndCallBack:Function;
		/** 
		 * 调用play后触发onMetaData时执行的回调 
		 * value : this
		 */
		public var metaDataCallBack:Function;
		
		private var _self:VideoControl;
		
		private var _parent:Sprite;	//父类
		
		private var _soundTransform:SoundTransform;
		private var _netStream:NetStream;
		private var _netConnection:NetConnection;
		private var _video:Video;
		
		private var _isPlaying:Boolean = true;	//是否在播放中
		private var _isPlayURL:Boolean = true;	//是否播放URL路径视频
		
		public function VideoControl()  { _self = this; init(); }
		
		private function init():void
		{
			//实例化声音控制
			_soundTransform = new SoundTransform();
			//实例化视频
			_netConnection = new NetConnection();
			_netConnection.connect(null);
			//实例化通道流
			_netStream = new NetStream(_netConnection);
			_netStream.client = {onMetaData:onMetaData};
//			_netStream.client.onMetaData = onMetaData;
			_netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);	//加载错误
			_netStream.addEventListener(NetStatusEvent.NET_STATUS, onStatus);		//执行事件
			//控制声音大小&&设置进度
			_netStream.soundTransform = _soundTransform;
			//视频播放器
			_video = new Video();
			_video.attachNetStream(_netStream);
		}
		/**
		 * 设置播放地址URL
		 * @param value
		 */		
		public function set url(value:String):void
		{
			_netStream.close();
			_netStream.dispose();
			
			_url = value;
			_isPlayURL = true;
			if(_isPlaying) _netStream.play(_url);
		}
		public function get url():String { return _url; }
		private var _url:String;
		/**
		 * 设置视频流二进制文件,只支持FLV格式
		 * 
		 *  var urlLoader:URLLoader = new URLLoader();
		 *	urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
		 *	urlLoader.addEventListener(Event.COMPLETE, function(e:Event):void
		 * {
		 * 		var byteArray:ByteArray = URLLoader(e.currentTarget).data;
		 * 		_videoControl.videoByte = byteArray;
		 * });
		 *	urlLoader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void{ trace("加载错误"); });
		 *	urlLoader.load(new URLRequest("Res/TestCGFLV.flv"));
		 */		
		public function set videoByte(value:ByteArray):void
		{
			_videoByte = value;
			_isPlayURL = false;
			
			_netStream.close();
			_netStream.dispose();
			//执行播放
			_netStream.play(null);
			_netStream.appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN);
			//_netStream.appendBytesAction(NetStreamAppendBytesAction.RESET_SEEK);
			//_netStream.appendBytesAction(NetStreamAppendBytesAction.END_SEQUENCE);
			_netStream.appendBytes(_videoByte);
		}
		public function get videoByte():ByteArray { return _videoByte; }
		private var _videoByte:ByteArray;
		
		
		/** 播放视频时出错提示 **/
		private function onAsyncError(e:AsyncErrorEvent):void
		{
			throw new Error("视频播放时出错" + e.text);
		}
		/**   播放情形侦听事件 **/
		private function onStatus(e:NetStatusEvent):void
		{
			switch (e.info.code)
			{
				case NETSTREAM_PLAY_START:			//开始播放
					if(videoStartCallBack != null) videoStartCallBack( _self );
					break;
				case NETSTREAM_PLAY_STOP:			//播放结束
					if(videoEndCallBack != null) videoEndCallBack( _self );
					break;
			}
		}
		
		/**
		 * 接收在正播放的 FLV 文件中嵌入的描述性信息时调度
		 * @param data
		 */		
		private function onMetaData(data:Object):void
		{
			_metaData = data;
			_duration = data.duration*1000;
			
			if(metaDataCallBack != null) metaDataCallBack( _self );
		}
		private var _duration:uint;	//视频的总长度
		/**
		 * 正播放的 FLV 文件信息数据对象
		 * @return Object
		 * {
		 * 	audiocodecid	: 指示所用音频编解码器（编码/解码技术）的字符串 -- 例如“Mp3”或“mp4a”
		 *  audiodaterate	: 一个数字，指示音频的编码速率，以每秒千字节为单位。
		 *  duration		: 一个数字，以秒为单位指定视频文件的持续时间。
		 *  framerate		: 一个数字，表示 FLV 文件的帧速率。
		 *  height			: 一个数字，以像素为单位表示 FLV 文件的高度。
		 *  videocodecid	: 一个字符串，表示用于编码视频的编解码器版本。- 例如，“avc1”或“VP6F”
		 *  videodatarate	: 一个数字，表示 FLV 文件的视频数据速率。
		 * 	width			: 一个数字，以像素为单位表示 FLV 文件的宽度。
		 * }
		 */		
		public function get metaData():Object { return _metaData; }
		private var _metaData:Object;
		/**
		 * 设置进度
		 * @param value	: 快进的毫秒数
		 */		
		public function set seek(value:uint):void
		{
			_seek = value;
			if(_seek > _duration) throw new Error("设置进度超出视频总时间");
			_netStream.seek( _seek );	
		}
		public function get seek():uint { return _seek; }
		private var _seek:uint;	//播放进度
		
		/** 当前播放头所在位置的毫秒数 **/
		public function get time():uint { return _netStream.time*1000; }
		/** 获取当前视频的总时间,毫秒数 **/
		public function get duration():uint { return _duration; }
		
		/**
		 * 声音大小
		 * @param value : 0~1范围值
		 */		
		public function set volume(value:Number):void
		{
			_volume = value;
			_soundTransform.volume = _volume;
			_netStream.soundTransform = _soundTransform;
		}
		public function get volume():Number  {  return _volume;  }
		private var _volume:Number;
		
		/** 执行播放 **/
		public function play():void
		{
			_isPlaying = true;	
			_netStream.resume();
		}
		/** 暂停播放 **/
		public function stop():void
		{
			_isPlaying = false;
			_netStream.pause(); 				//暂停
		}
		
		/** 停止播放 **/
		public function close():void
		{
			_isPlaying = false;
			_netStream.pause(); 				//暂停
			_netStream.seek(0);					//将当前播放点设置为0
		}
		/** 重播 **/		
		public function rebroadcast():void
		{
			close();
			play();
//			_netStream.play(_url);
//			_netStream.seek(0);					//将当前播放点设置为0
		}
		/**
		 * 全屏显示
		 * @param $stage
		 * 
		 * 如果报以下错误,请检查是使用按钮/键盘触发,非手动触发会触发此错误
		 * SecurityError: Error #2152: 不允许使用全屏模式
		 */		
		public function fullScreen($stage:Stage):void
		{
			$stage.displayState = "fullScreen";
		}
		/**
		 * 添加到父对象中
		 * @param $parent
		 */		
		public function addParent($parent:Sprite):void
		{
			_parent = $parent;
			$parent.addChild( _video );
		}
		/** 移除出父对象 **/
		public function removeParent():void
		{
			if(_parent)
				_parent.removeChild( _video );
		}
		
		public function set visible(value:Boolean):void
		{
			_video.visible = value;
		}
		public function get visible():Boolean { return _video.visible; }
		
		/**
		 * 视频宽度
		 * @param value
		 */		
		public function set videoWidth(value:uint):void
		{
			_videoWidth = value;
			_video.width = _videoWidth;
		}
		public function get videoWidth():uint { return _videoWidth; }
		private var _videoWidth:uint;
		
		/**
		 * 视频高度
		 * @param value
		 */		
		public function set videoHeight(value:uint):void
		{
			_videoHeight = value;
			_video.height = _videoHeight;
		}
		public function get videoHeight():uint { return _videoHeight; }
		private var _videoHeight:uint;
		
		/** 释放方法 **/
		public function dispose():void
		{
			removeParent();	
			
			close();
			_netStream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			_netStream.removeEventListener(NetStatusEvent.NET_STATUS, onStatus);
			_netStream.close();
			_netStream.dispose();
			_netStream.soundTransform = null;
			_netStream.client.onMetaData = null;
			_metaData = null;
			
			_netConnection.close();
			
			videoStartCallBack = null;
			videoEndCallBack = null;
			metaDataCallBack = null;
			
			_self = null;
			_parent = null;
			_soundTransform = null;
			_netStream = null;
			_netConnection = null;
			_video = null;
		}
	}
}