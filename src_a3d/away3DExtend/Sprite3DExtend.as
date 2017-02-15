package away3DExtend
{
	/**
	 * Away3D Sprite3D扩展类,添加了MC序列帧播放功能
	 * extends Sprite3D
	 * 此MC类为一直是平面状态,如果需要根据镜头改变或旋转的MC类请使用HMeshMC.as
	 * @author 李舒浩
	 * 用法:
	 * 		var arr:Array = [bitmapdata, bitmapdata, bitmapdata, bitmapdata...];
	 * 		var sprite3DMC:MySprite3DMC = new MySprite3DMC();
	 *		sprite3DMC.init(arr[0].width, arr[0].height);
	 *		sprite3DMC.setBtmdArr(arr);
	 *		_scene.addChild(sprite3DMC);
	 * 		sprite3DMC.play();
	 * 
	 * 属性方法：
	 * 		isDispatch				: 是否每次播放完一次都派发一次事件
	 * 		isDispose				: 是否调用dispose()后销毁帧序列位图
	 * 		myWidth					: 宽度
	 * 		myHeight				: 高度
	 * 		currentFrame			: 当前播放所在帧
	 * 		totalFrames				: 总帧数
	 * 		playSpeed				: 播放速度,默认1
	 * 		setBtmdArr()			: 设置序列帧位图,如果序列帧位图是用完后不需要用到或非公用的请设置isDispose = true;
	 * 		play();					: 执行播放
	 * 		stop();					: 停止播放
	 * 		gotoAndStop()			: 停止到某一帧上
	 * 		gotoAndPlay()			: 从某一帧开始播放
	 * 		addFrameCallBack()		: 添加指定帧回调方法
	 * 		removeFrameCallBack()	: 移除指定帧回调方法
	 * 		hasCallBack()			: 判断是否有当前回调方法
	 * 		clear()					: 释放方法
	 * 
	 * 事件：
	 * 		HMeshMC.CLEAR			: (Event)调用clear()后派发的事件,用于释放后最外部释放处理,例如移除事件与meshMC = null;
	 * 		HMeshMC.PLAY_COMPLSTE	: (Event)每播放完一次执行派发,需要设置isDispatch = true;
	 */		
	import flash.events.Event;
	
	import away3d.arcane;
	import away3d.entities.Sprite3D;
	import away3d.materials.MaterialBase;
	
	use namespace arcane;
	
	public class Sprite3DExtend extends Sprite3D
	{
		/** 调用clear()后派发的事件,用于释放后最外部释放处理,例如移除事件与meshMC = null; **/
		public static const CLEAR:String = "clear";
		/** 每播放完一次执行派发,需要设置isDispatch = true; **/
		public static const PLAY_COMPLSTE:String = "Play_Complste";
		
		public var myWidth:int;						//宽度
		public var myHeight:int;						//高度
		public var isDispatch:Boolean = false;		//每播放完一次是否要派发一次事件
		
		private var _isDispose:Boolean = false;		//是否调用clear()后销毁帧序列位图
		private var _mcTexture:TextureMaterialExtend;		//MC动态位图
		private var _isInit:Boolean = false;			//是否初始化
		
		public function Sprite3DExtend(material:MaterialBase = null, width:Number = 100, height:Number = 100) 
		{ 
			super(material, width, height);
		}
		
		public function init($width:int = 100, $height:int =100):void
		{
			if(_isInit) return;
			_isInit = true;
			
			this.width = $width;
			this.height = $height;
			//动态贴图
			_mcTexture = new TextureMaterialExtend();
			_mcTexture.completeCallBack = onCompleteCallBack;	//监听每次播放完执行回调
			this.isDispose = _isDispose;
			_mcTexture.alphaBlending = true;
			
		}
		/**
		 * 设置序列帧位图数组
		 * @param value	: [bitmapdata, bitmapdata...]
		 */		
		public function setBtmdArr(value:Array):void
		{
			_mcTexture.setBitmapDataArr(value);
			this.material = _mcTexture;
		}
		/** 执行播放 **/
		public function play():void
		{
			_mcTexture.play();
		}
		/** 停止播放 **/
		public function stop():void
		{
			_mcTexture.stop();
		}
		/** 停止到指定位置 **/
		public function gotoAndStop(value:uint):void
		{
			_mcTexture.gotoAndStop(value);
		}
		/** 从指定位置开始播放 **/
		public function gotoAndPlay(value:uint):void
		{
			_mcTexture.gotoAndPlay(value);
		}
		/**
		 * 播放速度
		 * @param value
		 */		
		public function set playSpeed(value:int):void
		{
			_mcTexture.playSpeed = value;
		}
		public function get playSpeed():int { return _mcTexture.playSpeed; }
		/**
		 * 添加在指定帧处执行的回调
		 * @param index		: 帧下标
		 * @param callBack	: 回调的方法
		 */		
		public function addFrameCallBack(index:int, callBack:Function):void
		{
			_mcTexture.addFrameCallBack(index, callBack);
		}
		/**
		 * 移除指定帧处执行的回调
		 * @param index		: 帧下标
		 */		
		public function removeFrameCallBack(index:int):void
		{
			_mcTexture.removeFrameCallBack(index);
		}
		/**
		 * 是否有当前回调方法
		 * @param value	: function
		 */		
		public function hasCallBack(value:Function):Boolean
		{
			return _mcTexture.hasCallBack(value);
		}
		
		/** 清除释放方法 **/
		override public function dispose():void
		{
			stop();
			_mcTexture.dispose();
			
			_mcTexture = null;
			this.dispatchEvent(new Event(Sprite3DExtend.CLEAR));
			
			super.dispose();
		}
		
		/** [设置/读取] 是否调用clear()后销毁帧序列位图 **/
		public function set isDispose(value:Boolean):void
		{
			_isDispose = value;
			if(!_mcTexture)
			{
				return;
			}
			_mcTexture.isDispose = _isDispose;
		}
		public function get isDispose():Boolean  {  return _isDispose;  }
		/** [只读] 指定播放头在实例的时间轴中所处的帧的编号。 **/
		public function get currentFrame():int  {  return _mcTexture.currentFrame;  }
		/** [只读] 实例中帧的总数。 **/
		public function get totalFrames():int  { return _mcTexture.totalFrames; }
		/** 每播放完一次执行回调 **/
		private function onCompleteCallBack():void
		{
			if(isDispatch && this.hasEventListener(Sprite3DExtend.PLAY_COMPLSTE))
				this.dispatchEvent(new Event(Sprite3DExtend.PLAY_COMPLSTE));
		}
	}
}