package away3DExtend
{
	/**
	 * 自定义贴图类
	 * @author 李舒浩
	 * 
	 * 添加UV子网格UV移动与序列帧播放功能
	 */	
	import flash.display.BitmapData;
	
	import away3d.arcane;
	import away3d.core.base.SubMesh;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	import away3d.textures.Texture2DBase;
	
	import tool.MyAway3DNameSpace;
	import tool.MyAway3DFrameWorker;
	
	use namespace arcane;
	use namespace MyAway3DNameSpace;
	
	public class TextureMaterialExtend extends TextureMaterial
	{
		public var isDispose:Boolean = false;			//是否调用dispose时释放掉bitmapdata
		public var playSpeed:int = 1;					//播放速度
		public var uvSpeed:Number = 0.01;				//UV移动速度
		public var completeCallBack:Function;			//播放完一次执行的回调
		
		private var _bitmapdata:BitmapData;			//UV材质bitmapdata
		private var _bitmapdataArr:Array;				//材质位图数组
		private var _callBackVec:Vector.<Function>;	//回调方法保存数组
		
		private var _subMesh:SubMesh;					//需要执行改变UV的subMesh
		
		private var _currentFrame:int = 0;				//当前所播放的帧
		private var _nowIndex:int = 0;					//当前播放标识
		private var _isPlay:Boolean = false;			//是否在播放中
		private var _isMoveUV:Boolean = false;		//是否为移动UC
		
		
		/**
		 * 
		 * @param texture	: 材质
		 * @param smooth	: 是否平滑
		 * @param repeat	: 是否重复
		 * @param mipmap	: 是否使用mipmap
		 */		
		public function TextureMaterialExtend(texture:Texture2DBase = null, smooth:Boolean = true, repeat:Boolean = false, mipmap:Boolean = true)  
		{  
			super(texture, smooth, repeat, mipmap);
//			this.texture = new BitmapTexture(_bitmapdata);
		}
		
		/** 设置材质位图数组 **/
		public function setBitmapDataArr(arr:Array):void
		{
			_isMoveUV = false;
			_bitmapdataArr = arr;
		}
		/**
		 * 设置材质位图
		 * @param btmd		: 材质位图,用于UV
		 * @param subMesh	: 要执行的uv对象
		 */		
		public function setUVMoveByBitmapData(btmd:BitmapData, subMesh:SubMesh):void
		{
			_isMoveUV = true;
			_bitmapdata = btmd;
			_subMesh = subMesh;
			if(this.texture)
				BitmapTexture(this.texture).bitmapData = _bitmapdata;
			else
				this.texture = new BitmapTexture(_bitmapdata);
		}
		
		/** 执行播放 **/
		public function play():void
		{
			if(_isPlay) return;
			_isPlay = true;
			if( !MyAway3DFrameWorker.instance.hasEnterFrameCallBack(this.name) )
				MyAway3DFrameWorker.instance.addEnterFrameCallBack(this.name, onEnterframe);
		}
		/** 停止播放 **/
		public function stop():void
		{
			if(!_isPlay) return;
			_isPlay = false;
			if( MyAway3DFrameWorker.instance.hasEnterFrameCallBack(this.name) )
				MyAway3DFrameWorker.instance.removeEnterFrameCallBack(this.name);
		}
		/** 停止到指定位置 **/
		public function gotoAndStop(value:uint):void
		{
			stop();
			frame = value;
		}
		/** 从指定位置开始播放 **/
		public function gotoAndPlay(value:uint):void
		{
			frame = value;
			play();
		}
		
		/**
		 * 添加在指定帧处执行的回调
		 * @param index		: 帧下标
		 * @param callBack	: 回调的方法
		 */		
		public function addFrameCallBack(index:int, callBack:Function):void
		{
			if(!_callBackVec) _callBackVec = new Vector.<Function>();
			if(_callBackVec[index]) 
			{
				removeFrameCallBack(index);
			}
			_callBackVec[index] = callBack;
		}
		/**
		 * 移除指定帧处执行的回调
		 * @param index		: 帧下标
		 */		
		public function removeFrameCallBack(index:int):void
		{
			if(!_callBackVec) return;
			delete _callBackVec[index];
			_callBackVec.splice(index, 1);
		}
		/**
		 * 是否有当前回调方法
		 * @param value	: function
		 */		
		public function hasCallBack(value:Function):Boolean
		{
			return (_callBackVec.indexOf(value)>-1 ? true : false);
		}
		/** [只读] 指定播放头在实例的时间轴中所处的帧的编号。 **/
		public function get currentFrame():int  {  return _currentFrame;  }
		/** [只读] 实例中帧的总数。 **/
		public function get totalFrames():int  { return (_bitmapdataArr ? _bitmapdataArr.length : 0); }
		/** 清除释放方法 **/
		override public function dispose():void
		{
			stop();
			//释放回调
			var index:int;
			for(var callBack:Function in _callBackVec)
			{
				index = _callBackVec.indexOf(callBack);
				removeFrameCallBack(index);
			}
			if(_callBackVec)
				_callBackVec.length = 0;
			_callBackVec = null;
			
			if(isDispose && _bitmapdataArr)
			{
				for each(var btmd:BitmapData in _bitmapdataArr)
				{
					btmd.dispose();
				}
			}
			if(_bitmapdataArr)
				_bitmapdataArr.length = 0;
			_bitmapdataArr = null;
			
			_subMesh = null;
			super.dispose();
		}
		
		private function onEnterframe():void
		{
			if(_nowIndex++ < playSpeed) return;
			_nowIndex = 0;
			frame = ++_currentFrame;
		}
		
		/**
		 * 设置当前播放位置的帧
		 * @param value
		 */		
		private function set frame(value:uint):void
		{
			_isMoveUV ? startChangeUV(value) : startChangeTexture(value);
		}
		/** 执行改变材质 **/
		private function startChangeTexture(value:uint):void
		{
			if(!_bitmapdataArr) return;
			if(value >= _bitmapdataArr.length) 
			{
				value = 0;
				//播放完了,执行回调
				if(completeCallBack != null) completeCallBack();
			}
			//判断是否有帧回调,执行方法
			if(_callBackVec && _callBackVec[value]) _callBackVec();
			//设置当前帧显示
			_currentFrame = value;
			BitmapTexture(this.texture).bitmapData  = _bitmapdataArr[_currentFrame];
		}
		
		/** 执行改变UC **/
		private function startChangeUV(value:uint):void
		{
			var offset:int = _subMesh.subGeometry.UVOffset;
			var stride:int = _subMesh.subGeometry.UVStride;
			var uvs:Vector.<Number> = _subMesh.subGeometry.UVData;
			var len:int = uvs.length;
			for (var i:uint = offset; i < len; i += stride) 
			{
				uvs[i] += uvSpeed;
				uvs[i + 1] += uvSpeed;
			}
			//更新UV坐标
			SkinnedSubGeometryExtend( _subMesh.subGeometry ).updateUVData(uvs);
		}
	}
}