package HLib.UICom.Component
{
	import com.greensock.TweenLite;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import HLib.Tool.EffectPlayerManage;
	import HLib.UICom.BaseClass.HSprite;
	
	import Modules.Common.HCss;
	import Modules.MainFace.MainInterfaceManage;
	import Modules.SFeather.SFTextField;
	
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * 纹理进度条公共类 
	 * @author Administrator
	 * 郑利本
	 */
	public class HProgressBar extends HSprite
	{
		private var _minNum:Number = 0;
		private var _maxNum:Number = 0;			//最大值
		private var _gapX:int;						//文本偏移量
		private var _gapY:int;
		private var _downTexture:Texture;			//底板纹理
		private var _upTexture:Texture;			//面板纹理
		private var _downImage:Image;				//底板图片
		protected var _upImage:Image ;				//面板图片
		private var _effectImage:Image;			//特效图片
		private var _upSpr:HSprite;
		private var _rectangle:Rectangle = new Rectangle;
		private var _Inverted:Boolean;				//是否取反  面板和底板对调
		
		private var _progressBarBG:Image;			//纹理背景
		
		private var _FontName:String = "宋体";		//字体
		private var _FontSize:int=12;				//字体大小
		private var _FontColor:uint=0xffffff;		//字体颜色
		private var _isDisPatchDraw:Boolean;		//是否派发进度改变事件
		private var _nowProgress:Number = 100;		//当前进度
		protected var _ratio:Number = 0.00;					//比率
		private var _isConvertText:Boolean;		//是否只显示当前值
		private var _isShowText:Boolean = true;	//是否显示文本
		protected var _effectRatio:Number;			//原始数值
		protected var _isAdd:Boolean;
		protected var _timer:Timer;
		private var _currentImage:Image;
		public var isLuck:Boolean;					//是否祝福值进度条
		public var isVertical:Boolean;				//是否是竖直显示
		public var upColor:uint=0xFFb47015;		//面板颜色 ARPG格式
		public var downColor:uint=0xFF0d9b8c;		//底板颜色
		public var isDisPatchDraw:Boolean;			//是否派发事件
		private var _showTextType:int = 0;			
		public var fractionDigits:int = 0;			//保留小数点位数
		
		public var isShowNewProgress:Boolean;
		private var _newProgress:int;
		private var _newTexture:Texture;
		private var _newImage:Image;
		
		/**
		 *血条文字显示类型(0:显示数值 1:显示百分比 2:显示当前数值) 
		 */
		public function get showTextType():int
		{
			return _showTextType;
		}

		/**
		 * @private
		 */
		public function set showTextType(value:int):void
		{
			_showTextType = value;
		}

		public var repeatCall:Function;
		private var _isChangeMax:Boolean;
		private var _effectArr:Array;				//特效数据
		private var _success:int;					//是否成功
		private var _isPlayer:Boolean;				//正在播放特效
		protected var _change:Boolean;				//是否改变进度值图片
		private var _maxBless:int;					//最大值　
		private var _tempoImage:Image;				//进度光标
		protected var _isReverse:Boolean = false;
		private var _tempoSpr:Sprite;
		private var _tempoAddx:int;					//光标X轴偏移量
		protected var _txtProgress:SFTextField;		//进度文本
		public function HProgressBar()
		{
			super();
		}
		/**
		 * 进度条设置 
		 * @param downTexture 	背景纹理
		 * @param upTexturet  	进度纹理
		 * @param _Width		宽度
		 * @param _Height		高度
		 * @param min			数值显示最小值
		 * @param max			数值显示最大值
		 * @param gapX			文本坐标偏移量
		 * @param gapY
		 * 
		 */		
		public function  init(downTexture:Texture=null,upTexturet:Texture=null,_Width:Number=100,_Height:Number=20,min:Number=0,max:Number=100, gapX:int = 0, gapY:int = 0):void
		{
			_gapX = gapX;
			_gapY = gapY;
			_minNum = min;
			_maxNum = max;
			this.myWidth = _Width;
			this.myHeight = _Height;
			if(upTexturet!=null){
				_upTexture=upTexturet;
				this.myWidth = upTexturet.width;
				this.myHeight = upTexturet.height;
			}else{
				_upTexture = Texture.fromColor(this.myWidth,this.myHeight,upColor);
			}
			if(downTexture!=null){
				_downTexture = downTexture;
			}else{
				_downTexture = Texture.fromColor(this.myWidth,this.myHeight,downColor);
			}
			_downImage = new Image(_downTexture);
			this.addChild(_downImage);
			
			if(isShowNewProgress){
				_newTexture = Texture.fromColor(this.myWidth,this.myHeight,0x3333f300);
				_newImage = new Image(_newTexture);
				_newImage.width = 1;
				this.addChild(_newImage);
			}
			
			_upSpr = new HSprite;
			_upSpr.touchable = false;
			if(isLuck)
			{
				_effectImage = new Image(_upTexture);
				_upSpr.addChild(_effectImage);
				_effectImage.alpha = .2;	
			}
			_upImage = new Image(_upTexture);
			_upSpr.addChild(_upImage);
			if(_Inverted){
				this.addChildAt(_upSpr,0);
			}
			else{
				this.addChild(_upSpr);
			}
			var format:TextFormat = new TextFormat;
			format.font = MainInterfaceManage.getInstance().fontName == null ? "" : MainInterfaceManage.getInstance().fontName;
			format.color = _FontColor;
			format.size = _FontSize;
			if(_tempoSpr)
				this.addChild(_tempoSpr);
			_txtProgress = new SFTextField;
			_txtProgress.myWidth = this.myWidth;
			_txtProgress.myHeight = 20;
			_txtProgress.format = format;
			var str:String
			switch(showTextType)
			{
				case 0:	//显示当前值
					_txtProgress.label = HCss.QualityColor0 + 12 +""+_nowProgress+"  /  "+_maxNum;
					break;
				case 1:	//显示百分比
					str = Number(_nowProgress/_maxNum*100).toFixed(fractionDigits);
					_txtProgress.label = HCss.QualityColor0 + 12 +str + "%";
					break;
				case 2:	//显示当前数值
					_txtProgress.label = HCss.QualityColor0 + 12 +""+_nowProgress;
					break;
				case 3:	//显示百分比,但是不显示百分号
					str = Number(_nowProgress/_maxNum*100).toFixed(fractionDigits);
					_txtProgress.label =HCss.QualityColor0 + 12 + str ;
					break;
			}
			if(isShowText)
				this.addChild(_txtProgress);
			_txtProgress.x=(this.myWidth-_txtProgress.textWidth) * .5 + gapX;
			_txtProgress.y=(this.myHeight-_txtProgress.textHeight) * .5 + gapY;	
			this.isInit = true;
		}
		/**
		 * 设定当前进度值 
		 * @param value 
		 * 
		 */		
		public function set nowProgress(value:Number):void
		{
			if((_nowProgress == value && !_isChangeMax) || _isPlayer) return;
			if(_timer)
				_timer.stop();
			_isChangeMax = false;
			if(isDisPatchDraw)dispatchEvent(new Event("drawProgress"));
			_effectRatio = Number(_ratio.toFixed(4));
			if(_nowProgress < value)
				_isAdd =  true ;
			else {
				_isAdd = false;
				//_effectRatio = _upImage.scaleX = 0;
			}
			_nowProgress = value;
			var num:Number = Number(Number(value/_maxNum).toFixed(4));
			_ratio = Math.max(0.0, Math.min(1.0, num));
			
			if(isVertical)
				updateVertical();
			else
			{
				if(isReverse)
					updateReverse();
				else
					update();
			}
			if(isShowText)
			{
				switch(showTextType)
				{
					case 0:	//显示当前值
						_txtProgress.label = HCss.WhiteColor + 12 +""+_nowProgress+"  /  "+_maxNum;
						break;
					case 1:	//显示百分比
						var str:String = Number(_nowProgress/_maxNum*100).toFixed(fractionDigits);
						_txtProgress.label =HCss.WhiteColor + 12 +  str + "%";
						break;
					case 2:	//显示当前数值
						_txtProgress.label =HCss.WhiteColor + 12 + ""+_nowProgress;
						break;
					case 3:	//显示百分比,但是不显示百分号
						str = HCss.WhiteColor + 12 + Number(_nowProgress/_maxNum*100).toFixed(fractionDigits);
						_txtProgress.label = str ;
						break;
				}
				_txtProgress.x=(this.myWidth-_txtProgress.textWidth) * .5 + _gapX;
			}
		}
		
		private function updateVertical():void
		{
			var vy:Number = _upImage.height * _ratio;
			_rectangle.setTo(0,_upImage.height - vy,_upImage.width,vy);
			_upSpr.clipRect = _rectangle;
		}
		
		private function updateReverse():void
		{
			var vx:Number = _upImage.width * _ratio;
			_rectangle.setTo(_upImage.width *(1-_ratio) ,0,vx,_upImage.height);
			_upSpr.clipRect = _rectangle;
			if(_tempoImage)
			{
				if(_isReverse)//显示反转
					_tempoImage.x = (1 -  _ratio) * this.myWidth - _tempoAddx;
				else
					_tempoImage.x = _ratio * this.myWidth - _tempoAddx;
			}
		}
		/**
		 * 刷新显示 
		 */		
		private function update():void
		{
			if(_tempoImage)
			{
				if(_isReverse)//显示反转
					_tempoImage.x = (1 -  _ratio) * this.myWidth - _tempoAddx;
				else
					_tempoImage.x = _ratio * this.myWidth - _tempoAddx;
			}
			if(!isLuck)
			{
				_upImage.scaleX = _ratio;
				_upImage.setTexCoords(1, new Point(_ratio, 0.0));
				_upImage.setTexCoords(3, new Point(_ratio, 1.0));
			}	else {
				if(_effectImage)
				{
					if(_isAdd)
					{
						if(_ratio == 0)
							_effectImage.visible = false;
						else
							_effectImage.visible = true;
						_effectImage.scaleX = _ratio;
						_effectImage.setTexCoords(1, new Point(_ratio, 0.0));
						_effectImage.setTexCoords(3, new Point(_ratio, 1.0));
					}	else 
						_effectImage.visible = false;
				}
				if(_timer == null)
				{
					_timer = new Timer(10);
					_timer.addEventListener(TimerEvent.TIMER, onTimer);
				}
				if(_ratio != 0 && _effectRatio < _ratio)
				{
					_change = true;
					_timer.start();
				} 	else {
					_change = false;
					_upImage.scaleX = _ratio;
					_upImage.setTexCoords(1, new Point(_ratio, 0.0));
					_upImage.setTexCoords(3, new Point(_ratio, 1.0));
					
					if(repeatCall)
						repeatCall();
				}
			}
		}
		private function onTimer(e:TimerEvent):void
		{
			if(_isAdd)
			{
				if(_effectRatio >= _ratio)
				{
					_effectRatio = _ratio
					_timer.stop();
					if(repeatCall)
						repeatCall();
					return;
				} 	else {
					if(_ratio - _effectRatio > 0.1)
						_effectRatio += 0.08;
					else if(_ratio - _effectRatio > 0.05)
						_effectRatio += 0.05;
					else
						_effectRatio += 0.005;
				}
			}	else {
				if(_effectRatio <= _ratio)
				{
					_effectRatio = _ratio
					_timer.stop();
				} 	else {
					if(_effectRatio - _ratio > 0.2)
						_effectRatio -= 0.08;
					else if(_ratio - _effectRatio > 0.05)
						_effectRatio -= 0.05;
					else
						_effectRatio -= 0.005;
				}
			}
			if(_change)
			{
				_upImage.scaleX = _effectRatio;
				_upImage.setTexCoords(1, new Point(_effectRatio, 0.0));
				_upImage.setTexCoords(3, new Point(_effectRatio, 1.0));	
			}
			if(_tempoImage)
			{
				if(_isReverse)//显示反转
					_tempoImage.x = (1 -  _effectRatio) * this.myWidth - _tempoAddx;
				else
					_tempoImage.x = _effectRatio * this.myWidth - _tempoAddx;
			}
			
		}
		public function get nowProgress():Number{
			return _nowProgress;
		}
		
		public function get maxNum():Number
		{
			return _maxNum;
		}
		
		public function set maxNum(value:Number):void
		{
			if(_txtProgress && _isShowText && (_maxNum != value))
			{
				switch(showTextType)
				{
					case 0:	//显示当前值
						_txtProgress.label = ""+_nowProgress+"  /  "+value;
						break;
					case 1:	//显示百分比
						var str:String = Number(_nowProgress/value*100).toFixed(fractionDigits);
						_txtProgress.label = str + "%";
						break;
					case 2:	//显示当前数值
						_txtProgress.label = ""+_nowProgress;
						break;
					case 3:	//显示百分比,但是不显示百分号
						str = Number(_nowProgress/_maxNum*100).toFixed(fractionDigits);
						_txtProgress.label = str ;
						break;
				}
				_txtProgress.x=(this.myWidth-_txtProgress.textWidth) * .5 + _gapX;
			}
			if(_maxNum != value)
				_isChangeMax = true;
			_maxNum = value;
		}
		
		public function get TextField():SFTextField
		{
			return _txtProgress;
		}
		
		public function set TextField(value:SFTextField):void
		{
			_txtProgress = value;
		}
		
		public function get FontSize():int
		{
			return _FontSize;
		}
		/**
		 * 字体大小设置 
		 * @param value
		 * 
		 */
		public function set FontSize(value:int):void
		{
			_FontSize = value;
		}
		
		public function get FontName():String
		{
			return _FontName;
		}
		/**
		 * 字体设置 
		 * @param value
		 * 
		 */
		public function set FontName(value:String):void
		{
			_FontName = value;
		}
		
		public function get FontColor():uint
		{
			return _FontColor;
		}
		/**
		 * 字体颜色设置 
		 * @param value
		 * 
		 */
		public function set FontColor(value:uint):void
		{
			_FontColor = value;
		}
		
		public function get Inverted():Boolean
		{
			return _Inverted;
		}
		/**
		 * 取反设置，面底板对换 
		 * @param value
		 * 
		 */
		public function set Inverted(value:Boolean):void
		{
			_Inverted = value;
		}
		/**
		 * 替换 面纹理*/	
		public function set upTexture(texture:Texture):void{
			if(_upImage.texture != texture)
			{
				_upImage.texture = texture;
				_upImage.readjustSize();	
			}
		}

		public function get upTexture():Texture
		{
			return _upImage.texture;
		}
		
		/**
		 * 替换 面纹理*/	
		public function set downTexture(texture:Texture):void{
			if(_downImage.texture != texture)
			{
				_downImage.texture = texture;
				_downImage.readjustSize();
			}
		}
		
		public function get downImage():Image
		{
			return _downImage;
		}
		
		public function get isConvertText():Boolean
		{
			return _isConvertText;
		}

		public function set isConvertText(value:Boolean):void
		{
			_isConvertText = value;
			showTextType = 3;
		}
		/**
		 * 设置进度条背景(在init方法调用后执行)
		 * @param value		: 进度条背景纹理
		 * @param offsetX	: x偏移坐标
		 * @param offsetY	: y偏移坐标
		 */		
		public function setProgressBarBG(value:Texture, offsetX:int = 0, offsetY:int = 0):void
		{
			_progressBarBG ||= new Image(value);
			this.addChildAt(_progressBarBG, 0);
			if(_downImage)
			{
				_progressBarBG.x = ((_downImage.width - _progressBarBG.width) >> 1) + offsetX;
				_progressBarBG.y = ((_downImage.height - _progressBarBG.height) >> 1) + offsetY;
			}
		}
		
		
		public override function dispose():void
		{
			if(_txtProgress)
				_txtProgress.dispose();
			if(_downTexture)
				_downTexture.dispose();
			if(_upTexture)
				_upTexture.dispose();
			if(_downTexture)
				_downTexture.dispose();
			if(_downImage)
				_downImage.dispose();
			if(_upImage)
				_upImage.dispose();
			if(_upSpr)
				_upSpr.dispose();
			super.dispose();
		}

		public function get isShowText():Boolean
		{
			return _isShowText;
		}

		public function set isShowText(value:Boolean):void
		{
			_isShowText = value;
			if(_txtProgress)
			{
				_txtProgress.visible = value;
				if(value)
				{
					switch(showTextType)
					{
						case 0:	//显示当前值
							_txtProgress.label = ""+_nowProgress+"  /  "+_maxNum;
							break;
						case 1:	//显示百分比
							var str:String = Number(_nowProgress/_maxNum*100).toFixed(fractionDigits);
							_txtProgress.label = str + "%";
							break;
						case 2:	//显示当前数值
							_txtProgress.label = ""+_nowProgress;
							break;
						case 3:	//显示百分比,但是不显示百分号
							str = Number(_nowProgress/_maxNum*100).toFixed(fractionDigits);
							_txtProgress.label = str ;
							break;
						case 4:	//显示数字，又显示百分比
							str = ""+_nowProgress+"  /  "+_maxNum + "  (" + Number(_nowProgress/_maxNum*100).toFixed(fractionDigits) + "%)";
							_txtProgress.label = str ;
							break;
					}
					_txtProgress.x=(this.myWidth-_txtProgress.textWidth) * .5 + _gapX;
				}
			}
		}

		/**
		 * 
		 * @param arr		[当前值，　是否暴击]
		 * @param success	是否升级成功
		 * @param maxBless	最大值
		 * 
		 */		
		public function playerLuckEffect(arr:Array, success:int, maxBless:int):void
		{
			_isPlayer = true;
			_effectArr = arr;
			_success = success;
			_maxBless = maxBless;
			playerEffect();
		}
		
		private function playerEffect():void
		{
			if(_effectArr.length > 0)
			{
				var arr:Array = _effectArr.shift();
				if(int(arr[1]) > 0)
				{
					EffectPlayerManage.getMyInstance().playEffect("jindutiao_000", this, 20, 20); 
				}
				
				_nowProgress = int(arr[0]);
				var num:Number = Number(Number(int(arr[0])/_maxNum).toFixed(2));
				var scale:Number = Math.max(0.0, Math.min(1.0, num));
				if(isShowText)
				{
					switch(showTextType)
					{
						case 0:	//显示当前值
							_txtProgress.label = ""+_nowProgress+"  /  "+_maxNum;
							break;
						case 1:	//显示百分比
							var str:String = Number(_nowProgress/_maxNum*100).toFixed(fractionDigits);
							_txtProgress.label = str + "%";
							break;
						case 2:	//显示当前数值
							_txtProgress.label = ""+_nowProgress;
							break;
						case 3:	//显示百分比,但是不显示百分号
							str = Number(_nowProgress/_maxNum*100).toFixed(fractionDigits);
							_txtProgress.label = str ;
							break;
					}
					_txtProgress.x=(this.myWidth-_txtProgress.textWidth) * .5 + _gapX;
				}
				
				TweenLite.to(_upImage, 1, {scaleX:scale, onComplete:onComplete});
			}	else {
				_isPlayer = false;
				if(_maxBless != _maxNum)
				{
					_maxNum = _maxBless;
					
					num = Number(Number(_nowProgress/_maxNum).toFixed(2));
					_ratio = Math.max(0.0, Math.min(1.0, num));
					update();
					if(isShowText)
					{
						switch(showTextType)
						{
							case 0:	//显示当前值
								_txtProgress.label = ""+_nowProgress+"  /  "+_maxNum;
								break;
							case 1:	//显示百分比
								str = Number(_nowProgress/_maxNum*100).toFixed(fractionDigits);
								_txtProgress.label = str + "%";
								break;
							case 2:	//显示当前数值
								_txtProgress.label = ""+_nowProgress;
								break;
							case 3:	//显示百分比,但是不显示百分号
								str = Number(_nowProgress/_maxNum*100).toFixed(fractionDigits);
								_txtProgress.label = str ;
								break;
						}
						_txtProgress.x=(this.myWidth-_txtProgress.textWidth) * .5 + _gapX;
					}
				}
				if(repeatCall)
				{
					repeatCall();
					repeatCall = null;
				}
			}
		}
		
		private function onComplete():void
		{
			_upImage.setTexCoords(1, new Point(_upImage.scaleX, 0.0));
			_upImage.setTexCoords(3, new Point(_upImage.scaleX, 1.0));
			playerEffect()
		}
		/**
		 * 设定光标
		 * @param value，图标
		 * @param addX， x轴偏移量
		 * 
		 */
		public function setTempoImage(value:Image, addX:int):void
		{
			if(value)
			{
				if(!_tempoSpr)
				{
					_tempoSpr = new Sprite;
					if(this.isInit)
					{
						var index:int = this.getChildIndex(_txtProgress);
						if(index > -1)
							this.addChildAt(_tempoSpr, index);
						else
							this.addChild(_tempoSpr);
					}
					_tempoSpr.clipRect = new Rectangle(0, -10, this.myWidth, this.myHeight + 10)
				}
				_tempoImage = value;
				_tempoAddx = addX;
				clearTempoImage();
				_tempoSpr.addChild(_tempoImage)
				_tempoImage.y = this.myHeight - _tempoImage.height >> 1;
				if(_isReverse)//显示反转
					_tempoImage.x = (1 -  _upImage.scaleX) * this.myWidth - _tempoAddx;
				else
					_tempoImage.x = _upImage.scaleX * this.myWidth - _tempoAddx;
			}
		}

		private function clearTempoImage():void
		{
			while(_tempoSpr.numChildren > 0)
			_tempoSpr.removeChildAt(0);
		}
		
		public function get isReverse():Boolean
		{
			return _isReverse;
		}

		public function set isReverse(value:Boolean):void
		{
			_isReverse = value;
		}

		public function get gapX():int
		{
			return _gapX;
		}

		public function get gapY():int
		{
			return _gapY;
		}

		public function get newProgress():int
		{
			return _newProgress;
		}

		public function set newProgress(value:int):void
		{
			_newProgress = value;
			if(isShowNewProgress){
				if(!_newImage){
					_newTexture = Texture.fromColor(this.myWidth,this.myHeight,0x3333f300);
					_newImage = new Image(_newTexture);
					_newImage.width = 1;
					this.addChild(_newImage);
				}	else {
					_newImage.visible = true;
				}
				var distance:int = this.myWidth * (_newProgress/this.maxNum);
				if(distance > this.myWidth){
					distance = this.myWidth;
				}
				_newImage.width = distance;	
			}
		}

		public function get tempoImage():Image
		{
			return _tempoImage;
		}


	}
}

