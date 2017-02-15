package HLib.UICom.Component
{
	import com.greensock.TweenLite;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import HLib.Tool.EffectPlayerManage;
	import HLib.UICom.BaseClass.HSprite;
	
	import Modules.MainFace.MainInterfaceManage;
	import Modules.SFeather.SFTextField;
	
	import starling.display.Image;
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
		private var _upImage:Image ;				//面板图片
		private var _effectImage:Image;			//特效图片
		private var _upSpr:HSprite;
		private var _rectangle:Rectangle = new Rectangle;
		private var _Inverted:Boolean;				//是否取反  面板和底板对调
		
		private var _progressBarBG:Image;			//纹理背景
		
		private var _FontName:String = "宋体";		//字体
		private var _FontSize:int=12;				//字体大小
		private var _FontColor:uint=0xffffff;		//字体颜色
		private var _textField:SFTextField;		//进度文本
		private var _isDisPatchDraw:Boolean;		//是否派发进度改变事件
		private var _nowProgress:Number = 100;		//当前进度
		private var _ratio:Number = 0.00;			//比率
		private var _isConvertText:Boolean;		//是否只显示当前值
		private var _isShowText:Boolean = true;	//是否显示文本
		private var _effectRatio:Number;			//原始数值
		private var _isAdd:Boolean;
		private var _currentImage:Image;
		protected var _isLuck:Boolean;				//是否祝福值进度条
		public var isVertical:Boolean;				//是否是竖直显示
		public var upColor:uint=0xFFb47015;		//面板颜色 ARPG格式
		public var downColor:uint=0xFF0d9b8c;		//底板颜色
		public var isDisPatchDraw:Boolean;			//是否派发事件
		public var showTextType:int = 0;			//血条文字显示类型(0:显示数值 1:显示百分比 2:显示当前数值)
		public var fractionDigits:int = 0;			//保留小数点位数
		
		public var repeatCall:Function;
		private var _isChangeMax:Boolean;
		private var _maxBless:int;
		private var _sucess:int;
		private var _numArr:Array;
		private var _tween:TweenLite;
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
			_upSpr = new HSprite;
			_upSpr.touchable = false;
			if(_isLuck)
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
			_textField = new SFTextField;
			_textField.myWidth = this.myWidth;
			_textField.myHeight = 20;
			_textField.format = format;
			switch(showTextType)
			{
				case 0:	//显示当前值
					_textField.label = ""+_nowProgress+"  /  "+_maxNum;
					break;
				case 1:	//显示百分比
					var str:String = Number(_nowProgress/_maxNum*100).toFixed(fractionDigits);
					_textField.label = str + "%";
					break;
				case 2:	//显示当前数值
					_textField.label = ""+_nowProgress;
					break;
			}
			if(isShowText)
				this.addChild(_textField);
			_textField.x=(this.myWidth-_textField.textWidth) * .5 + gapX;
			_textField.y=(this.myHeight-_textField.textHeight) * .5 + gapY;	
			
		}
		/**
		 * 设定当前进度值 
		 * @param value 
		 * 
		 */		
		public function set nowProgress(value:Number):void
		{
			if(_isLuck)
			{
				playerLuckEffect([[value,0]],0,_maxNum, true)
				return;
			}
			if(_nowProgress == value && !_isChangeMax) return;
			_isChangeMax = false;
			if(isDisPatchDraw)dispatchEvent(new Event("drawProgress"));
			_effectRatio = Number(_ratio.toFixed(2));
			_isAdd = _nowProgress < value ? true : false;
			_nowProgress = value;
			var num:Number = Number(Number(value/_maxNum).toFixed(2));
			_ratio = Math.max(0.0, Math.min(1.0, num));
			if(isVertical)
				updateVertical();
			else
				update();
			if(isShowText)
			{
				switch(showTextType)
				{
					case 0:	//显示当前值
						_textField.label = ""+_nowProgress+"  /  "+_maxNum;
						break;
					case 1:	//显示百分比
						var str:String = Number(_nowProgress/_maxNum*100).toFixed(fractionDigits);
						_textField.label = str + "%";
						break;
					case 2:	//显示当前数值
						_textField.label = ""+_nowProgress;
						break;
				}
				_textField.x=(this.myWidth-_textField.textWidth) * .5 + _gapX;
			}
		}
		
		private function updateVertical():void
		{
			var vy:Number = _upImage.height * _ratio;
			_rectangle.setTo(0,_upImage.height - vy,_upImage.width,vy);
			_upSpr.clipRect = _rectangle;
		}
		/**
		 * 刷新显示 
		 */		
		private function update():void
		{
			if(!_isLuck)
			{
				if(_tween) _tween.kill();
				_tween = TweenLite.to(_upImage, 1, {scaleX:_ratio});
				_upImage.setTexCoords(1, new Point(_ratio, 0.0));
				_upImage.setTexCoords(3, new Point(_ratio, 1.0));
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
			if(_textField && _isShowText && (_maxNum != value))
			{
				switch(showTextType)
				{
					case 0:	//显示当前值
						_textField.label = ""+_nowProgress+"  /  "+value;
						break;
					case 1:	//显示百分比
						var str:String = Number(_nowProgress/value*100).toFixed(fractionDigits);
						_textField.label = str + "%";
						break;
					case 2:	//显示当前数值
						_textField.label = ""+_nowProgress;
						break;
				}
				_textField.x=(this.myWidth-_textField.textWidth) * .5 + _gapX;
			}
			if(_maxNum != value)
				_isChangeMax = true;
			_maxNum = value;
		}
		
		public function get TextField():SFTextField
		{
			return _textField;
		}
		
		public function set TextField(value:SFTextField):void
		{
			_textField = value;
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
			_upImage.texture = texture;
			_upImage.readjustSize();
		}

		public function get upTexture():Texture
		{
			return _upImage.texture;
		}
		
		/**
		 * 替换 面纹理*/	
		public function set downTexture(texture:Texture):void{
			_downImage.texture = texture;
			_downImage.readjustSize();
		}
		
		public function get downTexture():Texture
		{
			return _downImage.texture;
		}
		
		public function get isConvertText():Boolean
		{
			return _isConvertText;
		}

		public function set isConvertText(value:Boolean):void
		{
			_isConvertText = value;
			showTextType = 2;
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
			if(_textField)
				_textField.dispose();
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
			if(_textField)
			{
				_textField.visible = value;
				if(value)
				{
					switch(showTextType)
					{
						case 0:	//显示当前值
							_textField.label = ""+_nowProgress+"  /  "+_maxNum;
							break;
						case 1:	//显示百分比
							var str:String = Number(_nowProgress/_maxNum*100).toFixed(fractionDigits);
							_textField.label = str + "%";
							break;
						case 2:	//显示当前数值
							_textField.label = ""+_nowProgress;
							break;
					}
					_textField.x=(this.myWidth-_textField.textWidth) * .5 + _gapX;
				}
			}
		}

		private function setProgressBarValue(value:int):void
		{
			_nowProgress = value;
			var num:Number = Number(Number(value/_maxNum).toFixed(2));
			_ratio = Math.max(0.0, Math.min(1.0, num));
			if(_tween) _tween.kill();
			_tween = TweenLite.to(_upImage, 1, {scaleX:_ratio});
			_upImage.setTexCoords(1, new Point(_ratio, 0.0));
			_upImage.setTexCoords(3, new Point(_ratio, 1.0));
			if(isShowText)
			{
				switch(showTextType)
				{
					case 0:	//显示当前值
						_textField.label = ""+_nowProgress+"  /  "+_maxNum;
						break;
					case 1:	//显示百分比
						var str:String = Number(_nowProgress/_maxNum*100).toFixed(fractionDigits);
						_textField.label = str + "%";
						break;
					case 2:	//显示当前数值
						_textField.label = ""+_nowProgress;
						break;
				}
				_textField.x=(this.myWidth-_textField.textWidth) * .5 + _gapX;
			}
		}
		
		public function playerLuckEffect(arr:Array, success:int, maxBless:int, flg:Boolean=false):void
		{
			if(flg)
			{
				setProgressBarValue(arr[0][0]);
			}	else {
				_numArr = arr;
				_sucess = success;
				_maxBless = maxBless
				if(arr.length)
				{
					var ar:Array = arr.shift();
					if(ar[0] == 0 && success)
					{
						ar[0] = _maxNum;
						_numArr.unshift ([0,0]);
					}
					showLuckEffect(ar);	
				} 	else {
					maxNum = _maxBless;
				}
			}
			
		}
		
		private function showLuckEffect(arr:Array):void
		{
			var index:int = arr[0];
			if(_nowProgress == index && !_isChangeMax) return;
			_isChangeMax = false;
			if(isDisPatchDraw)dispatchEvent(new Event("drawProgress"));
			var num:Number = Number(Number(index/_maxNum).toFixed(2));
			_ratio = Math.max(0.0, Math.min(1.0, num));
			if(_nowProgress > index)
				_upImage.scaleX = 0;
			else
				EffectPlayerManage.getMyInstance().playEffect("jindutiao_000", this,this.myWidth*_ratio-29, -25);
			_nowProgress = index;
			
			if(_ratio == 0)
				_effectImage.visible = false;
			else
				_effectImage.visible = true;
			_effectImage.scaleX = _ratio;
			_effectImage.setTexCoords(1, new Point(_ratio, 0.0));
			_effectImage.setTexCoords(3, new Point(_ratio, 1.0));
			if(_tween) _tween.kill();
			_tween = TweenLite.to(_upImage, 1, {scaleX:_ratio, onComplete:playerLuckEffect, onCompleteParams:[_numArr,_sucess, _maxBless]});
			_upImage.setTexCoords(1, new Point(_ratio, 0.0));
			_upImage.setTexCoords(3, new Point(_ratio, 1.0));
			if(isShowText)
			{
				switch(showTextType)
				{
					case 0:	//显示当前值
						_textField.label = ""+_nowProgress+"  /  "+_maxNum;
						break;
					case 1:	//显示百分比
						var str:String = Number(_nowProgress/_maxNum*100).toFixed(fractionDigits);
						_textField.label = str + "%";
						break;
					case 2:	//显示当前数值
						_textField.label = ""+_nowProgress;
						break;
				}
				_textField.x=(this.myWidth-_textField.textWidth) * .5 + _gapX;
			}
		}
	}
}

