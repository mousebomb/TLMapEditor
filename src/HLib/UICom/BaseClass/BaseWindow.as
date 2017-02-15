package HLib.UICom.BaseClass
{
	import com.greensock.TweenLite;
	
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import HLib.UICom.Component.HSimpleButton;
	
	import Modules.MainFace.MouseCursorManage;
	import Modules.view.equiptStrong.HelpWindow;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	import tool.StageFrame;

	public class BaseWindow extends Sprite
	{
		protected var _TitleTF:HTextField;							//标题文本
		protected var _isClose:Boolean = false;						//窗口是否在关闭中
		private var _isMove:Boolean ;								//是否移动
		private var _movePoint:Point;								//移动点
		private var _moveX:Number = 0;								//移动距离
		private var _moveY:Number = 0; 
		private var _isCanDrag:Boolean = true;						//是否可拖动
		private var _TitleSize:int = 12;							//标题字体大小
		private var _TitleColor:uint = 0xFEFF89;					//标题字体颜色
		private var _title:String;									//标题
		private var _myWidth:Number = 0;
		private var _myHeight:Number = 0;
		private var _closeBtnY:int;									//关闭按钮位置
		private var _closeBtnX:int;									//关闭按钮位置
		private var _isPierce:Boolean;								//是否支持事件穿透
		private var _isChangeScale:Boolean = true;					//是否改变位置标志
		private var _bgImage:Image;									//背景图片
		private var _closeBtn:HSimpleButton;						//关闭按钮
		protected var _closeTweenLite:TweenLite;					//关闭界面缓动管理
		private var _openPoint:Point = new Point(0, 0);				//打开点
		private var _tileImage:Image;								//标题图片
		private var _tileBgImage:Image;								//设定标题背景
		public function BaseWindow()
		{
			super();
		}
		
		/**
		 * 窗口样式
		 * @param width			窗口宽度
		 * @param height		窗口高度
		 * @param title			标题
		 * @param bgTexture		背景
		 * @param defaultClose	默认关闭按钮
		 * 
		 */		
		protected function HWindowShow(width:Number, height:Number, title:String, bgTexture:Texture, defaultClose:Boolean=true):void
		{
			_title = title;
			this.myWidth = width;
			this.myHeight = height;		
			bgImageTexture = bgTexture;
			if(defaultClose)
				defaultCloseBtn();
		}
		public function init():void
		{
			
		}
		private function defaultCloseBtn():void
		{
			if(_closeBtn)
				return;
			_closeBtn = new HSimpleButton;
			_closeBtn.setCloseSkin();
			_closeBtn.init();
			this.addChild(_closeBtn);
			_closeBtn.addEventListener(starling.events.Event.TRIGGERED,onClickClose);
			_closeBtn.x = this.myWidth - _closeBtn.myWidth - _closeBtnX;
			_closeBtn.y = _closeBtnY 
		}
		/**标题图片*/
		protected function setTile(texture:Texture, vx, vy):void
		{
			if(!_tileImage)
			{
				_tileImage = new Image(texture);
				this.addChild(_tileImage);
				_tileImage.touchable = false;
			}	else {
				if(_tileImage.texture != texture)
				{
					_tileImage.texture = texture;
					_tileImage.readjustSize();
				}
			}
			_tileImage.x = vx; 
			_tileImage.y = vy;
		}
		/**设定标题背景*/
		protected function setTileBg(texture:Texture, vx, vy, isTouch:Boolean=true):void
		{
			if(!_tileBgImage)
			{
				_tileBgImage = new Image(texture);
				this.addChild(_tileBgImage);
				if(isTouch)
					_tileBgImage.addEventListener(TouchEvent.TOUCH, onTileBgTouch);
			}	else {
				if(_tileBgImage.texture != texture)
				{
					_tileBgImage.texture = texture;
					_tileBgImage.readjustSize();
				}
			}
			_tileBgImage.x = vx; 
			_tileBgImage.y = vy;
		}
		/**设置背景*/
		public function set bgImageTexture(texture:Texture):void
		{
			if(!texture)
			{
				if(_bgImage)
					_bgImage.visible = false;
				return;
			}
			if(!_bgImage)
			{
				_bgImage = new Image(texture);
				this.addChildAt(_bgImage, 0);
			}	else {
				if(_bgImage.texture != texture)
				{
					_bgImage.texture = texture;
					_bgImage.readjustSize();
				}
			}
		}
		public function get bgImage():Image
		{
			return _bgImage;
		}
		/** 鼠标down标题文本 **/
		private function onTileBgTouch(e:TouchEvent):void
		{
			if(HTopBaseView.getInstance().hasEvent && !_isPierce) return; //顶层是否添加UI了
			Starling.current.nativeStage.focus = null;
			var touch:Touch = e.getTouch(_tileBgImage);
			if(!touch || !this.stage)
				return;
			if(touch.phase == TouchPhase.BEGAN)//down
			{
				_movePoint = touch.getLocation(this.stage,_movePoint);
				_moveX = _movePoint.x - this.x;
				_moveY = _movePoint.y - this.y;
				_isMove = true;
				if(this.parent != null)
				{
					this.parent.setChildIndex(this, this.parent.numChildren - 1);
				}
			}
			if(touch.phase == TouchPhase.ENDED)//click
				_isMove = false;
			if(_isMove && touch.phase == TouchPhase.MOVED)//over
			{
				_movePoint = touch.getLocation(this.stage,_movePoint);
				var addx:Number = _movePoint.x - _moveX ;
				var addy:Number = _movePoint.y - _moveY;
				if(addx < -(this.myWidth >> 1)) addx = -(this.myWidth >> 1);
				if(addy < 0) addy = 0;
				if(addx > HBaseView.getInstance().myWidth - (this.myWidth >> 1)) addx = HBaseView.getInstance().myWidth - (this.myWidth >> 1);
				if(addy > HBaseView.getInstance().myHeight - (this.myHeight >> 1)) addy = HBaseView.getInstance().myHeight - (this.myHeight >> 1)
				this.x = addx;
				this.y = addy;
			}
		}
		/**
		 * 点击关闭界面 
		 * @param e
		 * 
		 */		
		protected function onClickClose(e:starling.events.Event):void
		{
			onClose();
		}
		/** 点击关闭按钮时执行 **/
		public function onClose():void 
		{
			if(HelpWindow.myInstance.isShow && HelpWindow.myInstance.parent == this)
				HelpWindow.myInstance.parent.removeChild(HelpWindow.myInstance);
			if(_isClose) return;
			_isClose = true;
			hide3DWizard();
			this.touchable = false;
			if(openPoint && (openPoint.x != 0 || openPoint.y != 0))
				_closeTweenLite = TweenLite.to(this, .3, {scaleX:.1, scaleY:.1, x:openPoint.x, y:openPoint.y,onComplete:myCompleteFunction, onCompleteParams:[this]});
			else 
				_closeTweenLite = TweenLite.to(this, .3, {alpha:0, onComplete:myCompleteFunction, onCompleteParams:[this]});
			function myCompleteFunction(_t:HWindow):void
			{
				_closeTweenLite.kill();
				_closeTweenLite = null;
				_t.alpha=1;
				_t.touchable = true;
				if(_t.parent)
					_t.parent.removeChild(_t);
				_isClose = false;
				StageFrame.addNextFrameFun(function ():void{MouseCursorManage.getInstance().showCursor()});
				setTimeout(function ():void{
					HBaseView.getInstance().clearMOuseCursor();
				}, 50);
			}
			
		}
		public function get openPoint():Point
		{
			return _openPoint;
		}
		
		public function set openPoint(value:Point):void
		{
			_openPoint = value;
			if(value && isChangeScale)
			{
				this.x = value.x;
				this.y = value.y;
				this.scaleX = this.scaleY = 0.1;
			}	else {
				this.scaleX = this.scaleY = 1;
			}
		}
		/** 鼠标down标题文本 **/
		private function onTouch(e:TouchEvent):void
		{
			if(HTopBaseView.getInstance().hasEvent && !isPierce) return; //顶层是否添加UI了
			Starling.current.nativeStage.focus = null;
			var touch:Touch = e.getTouch(_TitleTF);
			if(!touch || !this.stage)
				return;
			if(touch.phase == TouchPhase.BEGAN)//down
			{
				_movePoint = touch.getLocation(this.stage,_movePoint);
				_moveX = _movePoint.x - this.x;
				_moveY = _movePoint.y - this.y;
				_isMove = true;
				if(this.parent != null)
				{
					this.parent.setChildIndex(this, this.parent.numChildren - 1);
				}
			}
			if(touch.phase == TouchPhase.ENDED)//click
				_isMove = false;
			if(_isMove && touch.phase == TouchPhase.MOVED)//over
			{
				_movePoint = touch.getLocation(this.stage,_movePoint);
				var addx:Number = _movePoint.x - _moveX ;
				var addy:Number = _movePoint.y - _moveY;
				if(addx < -(this.myWidth >> 1)) addx = -(this.myWidth >> 1);
				if(addy < 0) addy = 0;
				if(addx > HBaseView.getInstance().myWidth - (this.myWidth >> 1)) addx = HBaseView.getInstance().myWidth - (this.myWidth >> 1);
				if(addy > HBaseView.getInstance().myHeight - (this.myHeight >> 1)) addy = HBaseView.getInstance().myHeight - (this.myHeight >> 1)
				this.x = addx;
				this.y = addy;
			}
		}
		/**隐藏3d模型*/
		public function hide3DWizard():void
		{
			
		}
		
		/**添加3d模型*/		
		public function add3DWizard():void
		{
			
		}
		/**
		 * 是否可拖动
		 * @param value
		 */		
		public function set isCanDrag(value:Boolean):void
		{
			_isCanDrag = value;
			if(!_TitleTF) return;
			if(_isCanDrag)
				_TitleTF.addEventListener(TouchEvent.TOUCH,onTouch);
			else
				_TitleTF.removeEventListener(TouchEvent.TOUCH,onTouch);
		}
		public function get isCanDrag():Boolean  {  return _isCanDrag;  }
		public function get isClose():Boolean  {  return _isClose;  }

		public function get myWidth():Number
		{
			return _myWidth;
		}

		public function set myWidth(value:Number):void
		{
			_myWidth = value;
		}

		public function get myHeight():Number
		{
			return _myHeight;
		}

		public function set myHeight(value:Number):void
		{
			_myHeight = value;
		}

		public function get closeBtnY():int
		{
			return _closeBtnY;
		}

		public function set closeBtnY(value:int):void
		{
			_closeBtnY = value;
		}

		public function get closeBtnX():int
		{
			return _closeBtnX;
		}

		public function set closeBtnX(value:int):void
		{
			_closeBtnX = value;
		}

		public function get isChangeScale():Boolean
		{
			return _isChangeScale;
		}

		public function set isChangeScale(value:Boolean):void
		{
			_isChangeScale = value;
		}

		public function get isPierce():Boolean
		{
			return _isPierce;
		}

		public function set isPierce(value:Boolean):void
		{
			_isPierce = value;
		}


	}
}