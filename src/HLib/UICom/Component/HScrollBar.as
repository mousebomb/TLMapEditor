package HLib.UICom.Component
{
	import Modules.SFeather.SFScrollBar;
	
	import feathers.controls.IScrollBar;
	import feathers.controls.ScrollBar;
	import feathers.controls.ScrollContainer;
	import feathers.events.FeathersEventType;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	
	/**
	 * 拖动条类 
	 * @author Administrator
	 * 郑利本
	 * 用法
	 _SFScrollBar = new SFScrollBar;
	 _SFScrollBar.width = 350;
	 _SFScrollBar.height = 200;
	 this.addChild(_SFScrollBar);
	 _SFScrollBar.y = -_SFScrollBar.height - 5;
	 _SFScrollBar.backgroundSkin = scale9image;
	 _SFScrollBar.isShowMax		//数据源更新后是否显示最大值，true显示最大值，false显示顶端，默认false
	 _SFScrollBar.isVertical    	//垂直滚动
	 _SFScrollBar.isHorizontal   //水平滚动
	 _SFScrollBar.isLeft 		//滚动条显示位置 true 左边 false 右边 默认false;
	 _SFScrollBar.scrollTarget = new DisplayObjectContainer;
	 */	
	public class HScrollBar extends ScrollContainer
	{
		private var _isVertical:Boolean = true;				//垂直滚动条
		private var _isHorizontal:Boolean = false;			//水平滚动条
		private var _scrollTarget:DisplayObjectContainer;
		public var isShowMax:Boolean;							//是否显示最大值
		public var isShowMin:Boolean ;							//是否显示最小值
		public var isLeft:Boolean;								//滚动条是否显示在左边
		public var scrollPosition:int;							//滚动条显示位置
		private var _isInit:Boolean;
		private var _scrollType:int;
		private var _myHeight:Number;
		private var _myWidth:Number;
		private var _maxHorizontal:Number = -1;						//要显示的最大位置
		private var _maxVertical:Number = -1;						//要显示的最大位置
		private var _ScrollVisible:Boolean = true;				//显示标志
		public var textureType:int;								//图片类型
		private var _horizontalScrollBarVisible:Boolean = true;	//横向显示标志
		public function HScrollBar()
		{
			super();
		}
		
		public function init(w:Number = 0, h:Number = 0):void
		{
			this.width = w;
			this.height = h;
			this._myHeight = h;
			this._myWidth = w;
		}
		public function get isVertical():Boolean
		{
			return _isVertical;
		}
		
		/**
		 * 设定垂直滚动 
		 * @param value
		 * 
		 */
		public function set isVertical(value:Boolean):void
		{
			_isVertical = value;
			if(value)
			{
				isHorizontal = false;
			}
		}
		
		public function get isHorizontal():Boolean
		{
			return _isHorizontal;
		}
		/**
		 * 设定水平滚动 
		 * @param value
		 * 
		 */
		public function set isHorizontal(value:Boolean):void
		{
			_isHorizontal = value;
			if(value)
			{
				isVertical = false;
			}
		}
		
		public function get scrollTarget():DisplayObjectContainer
		{
			return _scrollTarget;
		}
		/**
		 * 设定数据源 类
		 * @param value
		 * 
		 */		
		public function set scrollTarget(value:DisplayObjectContainer):void
		{
			if(_scrollTarget && _scrollTarget.parent)
			{
				if(_scrollTarget != value)
					_scrollTarget.parent.removeChild(_scrollTarget);
			}
			_scrollTarget = value;
			this.addChild(_scrollTarget);
			if(isShowMax)
			{
				this.invalidate(INVALIDATION_FLAG_SCROLL);
				this.invalidate(INVALIDATION_FLAG_SIZE);
				this.validate();
				if(isVertical)
					this.verticalScrollPosition = this.maxVertical;
				else if(isHorizontal)
					this.horizontalScrollPosition = this.maxHorizontal;
			}	else if(scrollPosition > 0) {
				this.invalidate(INVALIDATION_FLAG_SCROLL);
				this.invalidate(INVALIDATION_FLAG_SIZE);
				this.validate();
				if(isVertical)
					this.verticalScrollPosition = scrollPosition;
				else if(isHorizontal)
					this.horizontalScrollPosition = scrollPosition;
				scrollPosition = 0;
			}	else {
				this.invalidate(INVALIDATION_FLAG_SCROLL);
				this.invalidate(INVALIDATION_FLAG_SIZE);
				this.validate();
				if(isVertical)
					this.verticalScrollPosition = 0;
				else if(isHorizontal)
					this.horizontalScrollPosition = 0;
			}
			/*if(isShowMin){
			if(isVertical)
				this.verticalScrollPosition = 0;
			else if(isHorizontal)
				this.horizontalScrollPosition = 0;
			}*/
		}
		/**
		 * 设定拖动条位置
		 */
		override protected function layoutChildren():void
		{
			if(this.currentBackgroundSkin)
			{
				this.currentBackgroundSkin.width = this.actualWidth;
				this.currentBackgroundSkin.height = this.actualHeight;
			}
			
			if(this.horizontalScrollBar)
			{
				this.horizontalScrollBar.validate();
			}
			if(this.verticalScrollBar)
			{
				this.verticalScrollBar.validate();
			}
			if(this._touchBlocker)
			{
				this._touchBlocker.x = this._leftViewPortOffset;
				this._touchBlocker.y = this._topViewPortOffset;
				this._touchBlocker.width = this._viewPort.visibleWidth;
				this._touchBlocker.height = this._viewPort.visibleHeight;
			}
			
			this._viewPort.x = this._leftViewPortOffset - this._horizontalScrollPosition;
			this._viewPort.y = this._topViewPortOffset - this._verticalScrollPosition;
			
			if(this.horizontalScrollBar)
			{
				this.horizontalScrollBar.x = this._leftViewPortOffset;
				this.horizontalScrollBar.y = this._topViewPortOffset + this._viewPort.visibleHeight;
				if(this._scrollBarDisplayMode != SCROLL_BAR_DISPLAY_MODE_FIXED)
				{
					this.horizontalScrollBar.y -= this.horizontalScrollBar.height;
					if((this._hasVerticalScrollBar || this._verticalScrollBarHideTween) && this.verticalScrollBar)
					{
						this.horizontalScrollBar.width = this._viewPort.visibleWidth - this.verticalScrollBar.width;
					}
					else
					{
						this.horizontalScrollBar.width = this._viewPort.visibleWidth;
					}
				}
				else
				{
					this.horizontalScrollBar.width = this._viewPort.visibleWidth;
				}
				horizontalScrollBar.visible = _horizontalScrollBarVisible;
			}
			
			if(this.verticalScrollBar)
			{
				/*verticalScrollBar.visible = _ScrollVisible;*/
				if(isLeft)
				{
					this._viewPort.x = this._leftViewPortOffset - this._horizontalScrollPosition + this.verticalScrollBar.width;
					this.verticalScrollBar.x = 0;
				}	else 
					this.verticalScrollBar.x = this._leftViewPortOffset + this._viewPort.visibleWidth;
				this.verticalScrollBar.y = this._topViewPortOffset;
				if(this._scrollBarDisplayMode != SCROLL_BAR_DISPLAY_MODE_FIXED)
				{
					this.verticalScrollBar.x -= this.verticalScrollBar.width;
					if((this._hasHorizontalScrollBar || this._horizontalScrollBarHideTween) && this.horizontalScrollBar)
					{
						this.verticalScrollBar.height = this._viewPort.visibleHeight - this.horizontalScrollBar.height;
					}
					else
					{
						this.verticalScrollBar.height = this._viewPort.visibleHeight;
					}
				}
				else
				{
					this.verticalScrollBar.height = this._viewPort.visibleHeight;
				}
				if(!_ScrollVisible)
					SFScrollBar(verticalScrollBar).setBtnVisbile();
			}
		}
		
		override protected function draw():void
		{
			if(!_isInit)
			{
				initializer();
			}
			super.draw();
		}
		
		private function initializer():void
		{
			
			this.interactionMode = ScrollContainer.INTERACTION_MODE_MOUSE;
			this.scrollBarDisplayMode = ScrollContainer.SCROLL_BAR_DISPLAY_MODE_FIXED;
			this.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_ON;
			this.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_ON;
			if(_isVertical)
			{
				verticalScrollBarFactory = function ():IScrollBar {
					var scrollBar:SFScrollBar = new SFScrollBar;
					scrollBar.textureType = textureType;
					scrollBar.vertical = true;
					scrollBar.scrollType = _scrollType;
					scrollBar.direction = ScrollBar.DIRECTION_VERTICAL;
					scrollBar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_SINGLE;
					scrollBar.addEventListener(Event.CHANGE, onChangeHandler);
					
					scrollBar.addEventListener(FeathersEventType.BEGIN_INTERACTION, VerticalScrollBar_END_INTERACTION);
					scrollBar.visible = _ScrollVisible;
					return scrollBar;
				}
			}	else {
				this.verticalScrollBarFactory = null;
			}
			
			if(_isHorizontal)
			{
				this.horizontalScrollBarFactory = function ():IScrollBar {
					var scrollBar:SFScrollBar = new SFScrollBar;
					scrollBar.textureType = textureType;
					scrollBar.horizontal = true;
					scrollBar.scrollType = _scrollType;
					scrollBar.direction = ScrollBar.DIRECTION_HORIZONTAL;
					scrollBar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_SINGLE;
					return scrollBar;
				}
			}	else {
				this.horizontalScrollBarFactory = null;
			}
			_isInit = true;
		}
		
		private function VerticalScrollBar_END_INTERACTION(e:Event):void
		{
			this.dispatchEventWith("VerticalScrollBar_END_INTERACTION")
		}
		/** 拖动条位置改变*/		
		private function onChangeHandler(e:Event):void
		{
			this.dispatchEventWith("onVerticalScrollBar_changeHandler", false, SFScrollBar(e.currentTarget).value)
		}
		
		/**设定拖动条位置 */		
		public function set scrollBarValue(value:Number):void
		{
			if(verticalScrollBar)
				this.verticalScrollBar.value = value;
			else {
				this.invalidate(INVALIDATION_FLAG_SCROLL);
				this.invalidate(INVALIDATION_FLAG_SIZE);
				this.validate();
				if(isVertical)
					this.verticalScrollPosition = value;
			}
		}
		
		/**获取拖动条位置 */		
		public function get scrollBarValue():Number
		{
			return this.verticalScrollBar.value
		}
		
		public function get scrollType():int
		{
			return _scrollType;
		}
		/**
		 * 资源名类型 
		 * @param value
		 * 
		 */
		public function set scrollType(value:int):void
		{
			_scrollType = value;
		}

		public function get myHeight():Number
		{
			return _myHeight;
		}

		public function set myHeight(value:Number):void
		{
			_myHeight = value;
		}

		public function get myWidth():Number
		{
			return _myWidth;
		}

		public function set myWidth(value:Number):void
		{
			_myWidth = value;
		}

		public function get maxHorizontal():Number
		{
			if(_maxHorizontal == -1)
				return this.maxHorizontalScrollPosition;
			else
				return _maxHorizontal;
		}

		public function set maxHorizontal(value:Number):void
		{
			_maxHorizontal = value;
		}

		public function get maxVertical():Number
		{
			if(_maxVertical == -1)
				return this.maxVerticalScrollPosition;
			else
				return _maxVertical;
		}

		public function set maxVertical(value:Number):void
		{
			_maxVertical = value;
		}

		public function set ScrollVisible(value:Boolean):void
		{
			_ScrollVisible = value;
			if(this.verticalScrollBar)
			{
				this.verticalScrollBar.visible = value;
				if(textureType == 1)
					SFScrollBar(verticalScrollBar).setBtnVisbile();
			}
		}
		public function get ScrollVisible():Boolean
		{
			return _ScrollVisible;
		}
		
		public function set horizontalScrollBarVisible(value:Boolean):void
		{
			_horizontalScrollBarVisible = value;
			if(horizontalScrollBar)
				horizontalScrollBar.visible = value;
		}
		public function get myVerticalScrollBar():IScrollBar
		{
			return this.verticalScrollBar
		}

	}
}

