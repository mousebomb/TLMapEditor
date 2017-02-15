package HLib.UICom.Component
{
	/**
	 * tweenLite特效文本文字显示(淡入后,延迟5秒后自动隐藏)
	 * @author 李舒浩
	 */	
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	
	import flash.text.TextFormat;
	
	import HLib.Tool.HObjectPool;
	
	import Modules.SFeather.SFTextField;
	
	import starling.display.Sprite;
	
	public class TweenEffectText extends Sprite
	{
		private var _isInit:Boolean;
		private var _self:TweenEffectText;
		private var _textField:SFTextField;				//显示文字
		private var tf:TextFormat;
		private var _tweenLite:TweenLite;
		private var _initColor:String = "#ffc000";	//默认颜色值
		private var _initSize:int = 14;				//默认字体大小
		
		public var addComplete:Function;		//淡出完成后执行回调
		public var complete:Function;			//消失后执行的回调方法
		private var _vx:int;
		
		public function TweenEffectText() {  super(); _self = this; }
		public function init():void
		{
			if(_isInit) return;
			_isInit = true;
			_textField = new SFTextField();
			_textField.size = _initSize
			_textField.myWidth = 350;
			_self.addChild(_textField);
			this.touchable = false;
			this.touchGroup = true;
		}
		/** 设置文本X坐标 **/
		public function setX($x:int):void  {  _vx = $x  }
		/** 设置文本Y坐标 **/
		public function setY($y:int):void  {  _textField.y = $y;  }
		/** 获取显示文本 **/
		public function get textField():SFTextField  {  return _textField;  }
		/** 获取显示文本的Y坐标 **/
		public function get textY():int { return _textField.y; }
		/** 获取效果文字的高 **/
		public function get textFieldHeight():int { return ((_textField==null) ? 20 : _textField.height); }
		/**
		 * 设置显示文字透明淡出并移动Y坐标效果
		 * @param str			: 显示的提示文字
		 * @param tweenTime_1	: 淡入效果的执行时间
		 * @param tweenTime_2	: 淡出+移动效果的执行时间
		 * @param delay			: 淡出+移动效果的延迟时间
		 * @param upY1			: 淡入时移动的距离
		 * @param upY2			: 淡出时移动的距离
		 */		
		public function setTextEff1(label:String, tweenTime_1:Number = 0.5, tweenTime_2:Number = 0.5, delay:Number = 1, moveY1:int = -100, moveY2:int = -10, isHtml:Boolean = false):void
		{
			if(isHtml)
				_textField.html = label;
			else
				_textField.label = label;
			this.x = _vx - (_textField.textWidth >> 1);
			//执行效果
			_textField.alpha = 0;
			_tweenLite = TweenLite.to(_textField, tweenTime_1, {alpha:1, y:(_textField.y+moveY1), onComplete:
				function():void
				{
					_tweenLite.kill();
					if(addComplete != null) addComplete();
					_tweenLite = TweenLite.to(_textField, tweenTime_2, {alpha:0, delay:delay,  y:(_textField.y+moveY2), onComplete:
						function():void
						{
							_tweenLite.kill();
							closeSelf();
						}});
				}});
		}
		/**
		 * 设置显示文字向上缓动后再向上缓动淡出效果 
		 * @param str			: 显示的文字
		 * @param tweenTime_1	: 缓动向上的时间
		 * @param tweenTime_2	: 缓动向上淡出的时间
		 * @param upY_1			: 第一次缓动的坐标距离(以初始化y坐标定点,向上移动为-,上下为+)
		 * @param upY_2			: 第二次缓动的移动距离
		 */		
		public function setTextEff2(label:String, tweenTime_1:Number = 2, tweenTime_2:Number = 1, upY_1:int = 0, upY_2:int = 0):void
		{
			_textField.label = label
			this.x = _vx - (_textField.textWidth >> 1);
			//执行效果
			_tweenLite = TweenLite.to(_textField, tweenTime_1, {y:(_textField.y+upY_1), ease:Elastic.easeOut, onComplete:
				function():void
				{
					_tweenLite.kill();
					_tweenLite = TweenLite.to(_textField, tweenTime_2, {alpha:0, y:(_textField.y+upY_2), onComplete:
						function():void
						{
							_tweenLite.kill();
							closeSelf();
						}
					});
				}
			});
		}
		/**
		 * 显示文字后淡出消失 
		 * @param str		: 显示的文字
		 * @param tweenTime	: 执行缓动使用的时间
		 */		
		public function setTextEff3(label:String, tweenTime:Number = 4):void
		{
			_textField.label = label
			this.x = _vx - (_textField.textWidth >> 1);
			_tweenLite = TweenLite.to(_textField, 4, {alpha:0, ease:Elastic.easeInOut, onComplete:
				function():void
				{
					_tweenLite.kill();
					closeSelf();
				}
			});
		}
		/**
		 * 设置显示文字透明淡出并移动Y坐标效果
		 * @param str			: 显示的提示文字
		 * @param tweenTime_1	: 淡入效果的执行时间
		 * @param tweenTime_2	: 淡出+移动效果的执行时间
		 * @param delay			: 淡出+移动效果的延迟时间
		 * @param upY			: 移动效果的坐标
		 */		
		public function setTextEff4(label:String, tweenTime_1:Number = 0.5, tweenTime_2:Number = 0.5, delay:Number = 1, upY:int = -30,isHtml:Boolean=true):void
		{
			if(isHtml)
				_textField.html = label;
			else if(label.substr(0,1) == "#")
				_textField.label = label;
			else
				_textField.label = _initColor + _initSize + label;
			this.x = _vx - (_textField.textWidth >> 1);
			//执行效果
			_textField.alpha = 0;
			_tweenLite = TweenLite.to(_textField, tweenTime_1, {alpha:1, onComplete:
				function():void
				{
					_tweenLite.kill();
					if(addComplete != null) addComplete();
					_tweenLite = TweenLite.to(_textField, tweenTime_2, {delay:delay,  y:(_textField.y+upY), onComplete:
						function():void
						{
							_tweenLite.kill();
							_tweenLite = TweenLite.to(_textField, tweenTime_2, {alpha:0,  y:(_textField.y+upY), onComplete:
								function():void
								{
									_tweenLite.kill();
									closeSelf();
								}});
						}});
				}});
		}
		public function playTextEff4():void
		{
			if(_tweenLite)
				_tweenLite.kill();
			_tweenLite = TweenLite.to(_textField, .4, {alpha:0,  y:(_textField.y-30), onComplete:
				function():void
				{
					_tweenLite.kill();
					closeSelf();
				}});
		}
		
		public function setTextEff5(label:String, tweenTime_1:Number = 0.5, tweenTime_2:Number = 0.5, delay:Number = 1, upY:int = -10):void
		{
			_textField.label = label
			this.x = _vx - (_textField.textWidth >> 1);
			//执行效果
			_textField.alpha = 0;
			_tweenLite = TweenLite.to(_textField, tweenTime_1, {alpha:1, onComplete:
				function():void
				{
					_tweenLite.kill();
					if(addComplete != null) addComplete();
					_tweenLite = TweenLite.to(_textField, tweenTime_2, {alpha:0, delay:delay,  y:(_textField.y+upY), onComplete:
						function():void
						{
							_tweenLite.kill();
							closeSelf();
						}});
				}});
		}
		public function setTextEff8(label:String):void
		{
			if(label.substr(0,1) == "#")
				_textField.label = label;
			else
				_textField.label = _initColor + _initSize + label;
			this.x = _vx - (_textField.textWidth >> 1);
			//执行效果
			_textField.alpha = 1;
			_tweenLite = TweenLite.to(_textField, 1, {y:(_textField.y-20), onComplete:
				function():void
				{
					_tweenLite = TweenLite.to(_textField, 1, {y:(_textField.y-20), onComplete:
						function():void
						{
							_tweenLite = TweenLite.to(_textField, 1, {y:(_textField.y-20), onComplete:
								function():void
								{
									_tweenLite = TweenLite.to(_textField, .5, {alpha:0,  y:(_textField.y-50), onComplete:
										function():void
										{
											closeSelf();
										}});
								}});
						}});
				}});
		}
		
		/** 移除处理 **/
		public function closeSelf():void
		{
			//移除tweenLite
			if(_tweenLite)
			{
				_tweenLite.kill();
				_tweenLite = null;
			}
			//移除对象
			if(_self.parent)
				_self.parent.removeChild(_self);
			//移除回调
			if(complete != null) 
			{
				complete(_self);
				complete = null;
			}
			if(_textField)
				_textField.dispose();
			addComplete = null;
			HObjectPool.getInstance().pushObj(_self);
		}
	}
}