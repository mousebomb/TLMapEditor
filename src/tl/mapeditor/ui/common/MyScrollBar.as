package tl.mapeditor.ui.common
{
	import com.greensock.TweenLite;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;

	public class MyScrollBar extends Sprite
	{
		public var upButton:MyButton=new MyButton();
		public var downButton:MyButton=new MyButton();
		public var dragButton:MyScall9Button=new MyScall9Button();
		
		private var _Stage:Stage;
		protected var _backbmd:BitmapData=null;
		protected var _BackBarBmd:MyScale9BitmapSprite=new MyScale9BitmapSprite();
		protected var _Rectangle:Rectangle;
		protected var _generalWidth:Number=20;
		private var _EndLine:Boolean=false;
		private var _myWidth:Number=0;
		private var _myHeight:Number=0;
		private var _now:Number=0;
		private var _max:Number=0;
		private var _WheelStepLength:Number=6;
		private var _direction:String="Right";
		private var _scrollTarget:Sprite;
		private var _dragBtnWidth:int = 12;				//拖动条宽度
		protected var _mark:Sprite=new Sprite();
		private var _upBtnSkinArr:Array = [];		//上按钮皮肤数组
		private var _downBtnSkinArr:Array = [];	//下按钮皮肤数组
		private var _dragBtnSkinArr:Array = [];	//拖动按钮皮肤数组
		
		
		public var type:int = 0;					//拖动条样式(0:默认样式 1:无上下按钮样式,需要在调用InIt()方法前调用)
		public var backColor:uint=0xFFc74815;
		public var isTweenLite:Boolean = false;	//向上推动时是否使用缓动效果
		
		private var _lineBtm:Bitmap = new Bitmap();	//拖动条线
		
		public function MyScrollBar()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onSTAGE);
		}
		private function onSTAGE(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE, onSTAGE);
			_Stage=this.stage;
		}
		/**
		 * 初始化
		 * @param _width			: 拖动条背景宽度(type0 : 16 type1 : 3...)
		 * @param _height			: 拖动条背景高度(type0 : 74 type1 : 70...)
		 * @param isUserInitSkin	: 是否使用默认皮肤
		 */		
		public function InIt(_width:Number,_height:Number, isUserInitSkin:Boolean = true):void
		{
			//判断是否有皮肤,设置默认皮肤
			if(isUserInitSkin) setDefaultSkinByType(0);
			
			if(_backbmd==null){
				_backbmd=new BitmapData(_generalWidth,_height,true,backColor)
			}

//			_backbmd=IResourceManager.getInstance().getBitmapData("Skin","ScrollBar_BackPanel");
			_Rectangle=new Rectangle(int(_backbmd.width/3),int(_backbmd.height/3),int(_backbmd.width/3),int(_backbmd.height/3));
			_BackBarBmd.SpriteInIt(_backbmd,_Rectangle);
			_BackBarBmd.addEventListener(MouseEvent.CLICK,onClick);
			this.addChild(_BackBarBmd);
			this.myWidth=_width;
			this.myHeight=_height;
			
			upButton.setSkin(_upBtnSkinArr[0], _upBtnSkinArr[1], _upBtnSkinArr[2], _upBtnSkinArr[3], _upBtnSkinArr[4]);
			upButton.init("",_generalWidth,_generalWidth);
			this.addChild(upButton);
			
			downButton.setSkin(_downBtnSkinArr[0], _downBtnSkinArr[1], _downBtnSkinArr[2], _downBtnSkinArr[3], _downBtnSkinArr[4]);
			downButton.init("",_generalWidth,_generalWidth);
			//设置拖动背景位置
			_BackBarBmd.x = (upButton.width - _BackBarBmd.width)/2;
			
			dragButton.setSkin(_dragBtnSkinArr[0], _dragBtnSkinArr[1], _dragBtnSkinArr[2], _dragBtnSkinArr[3], _dragBtnSkinArr[4]);
			dragButton.HButtonInIt("",_dragBtnWidth,_dragBtnWidth);
			dragButton.x = _BackBarBmd.x + (_BackBarBmd.width - dragButton.width)/2;
			
			if(type == 0)
			{
				_lineBtm.bitmapData =  new ScrollBar_DragButton_Line();
				this.addChild(_lineBtm);
				_lineBtm.x = dragButton.x + (dragButton.width - _lineBtm.width)/2;
				_lineBtm.y = dragButton.y + (dragButton.height - _lineBtm.height)/2;
			}
			
			this.addChild(downButton);
			this.addChild(dragButton);	
			this.addChild(_mark);	

			Reorganizes();
			
			upButton.addEventListener(MouseEvent.CLICK, onClick);
			downButton.addEventListener(MouseEvent.CLICK, onClick);
			dragButton.addEventListener(MouseEvent.MOUSE_DOWN, OnDown);
			dragButton.addEventListener(MouseEvent.MOUSE_UP, OnUp);
			this.addEventListener(MouseEvent.ROLL_OVER,onRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT,onRollOut);
		}
		public function Reorganizes():void{
			if(_direction=="Right"){
				upButton.y=0;
				downButton.y=_myHeight-_generalWidth;
				dragButton.y=_generalWidth;
				_lineBtm.y = dragButton.y + (dragButton.height - _lineBtm.height)/2;
				_mark.x=-_mark.width;
				_mark.y=0;
				if(_scrollTarget!=null){
					_scrollTarget.x=this.x-_scrollTarget.width;
				}
				return;
			}
			if(_direction=="Left"){
				upButton.y=0;
				downButton.y=_myHeight-_generalWidth;
				dragButton.y=_generalWidth;
				_lineBtm.y = dragButton.y + (dragButton.height - _lineBtm.height)/2;
				_mark.x=_myWidth;
				_mark.y=0;
				if(_scrollTarget!=null){
					_scrollTarget.x=this.x+_myWidth;
				}
				return;
			}
		}
		protected function onClick(e:MouseEvent):void{
			var _TempButton:MyButton=e.target as MyButton;
			if(_TempButton==upButton&&dragButton.y>_generalWidth){
				if(dragButton.y-5>_generalWidth){
					dragButton.y-=5;
				}else{
					dragButton.y=_generalWidth;
				}
				_lineBtm.y = dragButton.y + (dragButton.height - _lineBtm.height)/2;
				_now=dragButton.y;
				if(_myHeight < _scrollTarget.height)
					_scrollTarget.y=this.y-(_now-_generalWidth)*(_scrollTarget.height-this.height)/(this.height-_generalWidth*2-dragButton.height)
				return;
			}
			if(_TempButton==downButton&&dragButton.y<this.height-_generalWidth*-dragButton.height){
				if(dragButton.y+5<this.height-_generalWidth-dragButton.height){
					dragButton.y+=5;
				}else{
					dragButton.y=this.height-_generalWidth-dragButton.height;
				}
				_lineBtm.y = dragButton.y + (dragButton.height - _lineBtm.height)/2;
				_now=dragButton.y;
				if(_myHeight < _scrollTarget.height)
					_scrollTarget.y=this.y-(_now-_generalWidth)*(_scrollTarget.height-this.height)/(this.height-_generalWidth*2-dragButton.height)
				return;
			}
			
			if(_TempButton==null){
				if(this.mouseY<dragButton.y){
					if(dragButton.y-15>_generalWidth){
						dragButton.y-=15;
					}else{
						dragButton.y=_generalWidth;
					}
					_lineBtm.y = dragButton.y + (dragButton.height - _lineBtm.height)/2;
					_now=dragButton.y;
					if(_myHeight < _scrollTarget.height)
						_scrollTarget.y=this.y-(_now-_generalWidth)*(_scrollTarget.height-this.height)/(this.height-_generalWidth*2-dragButton.height)
					return;
				}else if(this.mouseY>dragButton.y+dragButton.height){
					if(dragButton.y+15<this.height-_generalWidth-dragButton.height){
						dragButton.y+=15;
					}else{
						dragButton.y=this.height-_generalWidth-dragButton.height;
					}
					_lineBtm.y = dragButton.y + (dragButton.height - _lineBtm.height)/2;
					_now=dragButton.y;
					if(_myHeight < _scrollTarget.height)
						_scrollTarget.y=this.y-(_now-_generalWidth)*(_scrollTarget.height-this.height)/(this.height-_generalWidth*2-dragButton.height)
					return;
				}
			}
			
		}
		protected function OnDown(e:MouseEvent):void{
			var h:int = dragButton.height;
			if(type == 1)
				_Rectangle=new Rectangle(dragButton.x, _BackBarBmd.y, 0, _BackBarBmd.height - h);
			else
				_Rectangle=new Rectangle(dragButton.x, _BackBarBmd.y, 0, this.height-_generalWidth*2-h);/*_Rectangle=new Rectangle(0,_generalWidth,0,this.height-_generalWidth*2-dragButton.height);修正偏差*/
			dragButton.startDrag(false,_Rectangle);	
			this.addEventListener(MouseEvent.MOUSE_MOVE, OnMove);
			_Stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			_Stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove);
		}
		protected function OnUp(e:MouseEvent):void{
			dragButton.stopDrag();
			this.removeEventListener(MouseEvent.MOUSE_MOVE, OnMove);
			_Stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			_Stage.removeEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove);
		}
		private function onStageMouseUp(e:MouseEvent):void{
			dragButton.stopDrag();
			this.removeEventListener(MouseEvent.MOUSE_MOVE, OnMove);
			_Stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			_Stage.removeEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove);
		}
		private function OnMove(e:MouseEvent):void{
			if(_scrollTarget==null) return;
			_lineBtm.y = dragButton.y + (dragButton.height - _lineBtm.height)/2;
			_now=dragButton.y;
			_scrollTarget.y=this.y-(_now-_generalWidth)*(_scrollTarget.height-this.height)/(this.height-_generalWidth*2-dragButton.height)
		}
		private function onStageMouseMove(e:MouseEvent):void{
			if(_scrollTarget==null) return;
			_lineBtm.y = dragButton.y + (dragButton.height - _lineBtm.height)/2;
			_now=dragButton.y;
			_scrollTarget.y=this.y-(_now-_generalWidth)*(_scrollTarget.height-this.height)/(this.height-_generalWidth*2-dragButton.height);
		}
		protected function onRollOver(e:MouseEvent):void{
			_Stage.addEventListener(MouseEvent.MOUSE_WHEEL,onStageMouseWheel);
		}
		protected function onRollOut(e:MouseEvent):void{
			_Stage.removeEventListener(MouseEvent.MOUSE_WHEEL,onStageMouseWheel);
		}
		private function onStageMouseWheel(e:MouseEvent):void{
			if(!dragButton.visible) return;
			if(e.delta<0){
				dragButton.y-=e.delta*_WheelStepLength;
				if(dragButton.y>Number(this.myHeight-dragButton.height-_generalWidth)){
					dragButton.y=Number(this.myHeight-dragButton.height-_generalWidth);
				}
			}
			else{
				dragButton.y-=e.delta*_WheelStepLength;
				if(dragButton.y<_generalWidth){
					dragButton.y=_generalWidth;
				}
			}
			_lineBtm.y = dragButton.y + (dragButton.height - _lineBtm.height)/2;
			_now=dragButton.y;
			_scrollTarget.y=this.y-(_now-_generalWidth)*(_scrollTarget.height-this.height)/(this.height-_generalWidth*2-dragButton.height);
		}
		public function set generalWidth(value:Number):void{
			_generalWidth=value;
		}
		public function get generalWidth():Number{
			return _generalWidth;
		}
		public function set backSkin(value:BitmapData):void{
			_backbmd=value;
			
		}
		public function get backSkin():BitmapData{
			return _backbmd;
		}
		public function set direction(value:String):void{
			_direction=value;			
		}
		public function get direction():String{
			return _direction;
		}
		public function set endLine(value:Boolean):void{
			_EndLine=value;			
		}
		public function get ():Boolean{
			return _EndLine;
		}
		public function set wheelStepLength(value:Number):void{
			_WheelStepLength=value;
			
		}
		public function get wheelStepLength():Number{
			return _WheelStepLength;
		}
		public function set myWidth(value:Number):void{
			_myWidth=value;
			_BackBarBmd.width=_myWidth;
			//dragButtonDraw();
			MarkDraw();
			Reorganizes();
		}
		public function get myWidth():Number{
			return _myWidth;
		}
		public function set myHeight(value:Number):void{
			_myHeight=value;
			_BackBarBmd.height=_myHeight-_generalWidth*2;
			_BackBarBmd.y=_generalWidth;
			//dragButtonDraw();
			MarkDraw();
			Reorganizes();
		}
		public function get myHeight():Number{
			return _myHeight;
		}
		public function set scrollTarget(value:Sprite):void{
			if(_scrollTarget==null){
				_scrollTarget=value;
				_scrollTarget.addEventListener(MouseEvent.ROLL_OVER,onRollOver);
				_scrollTarget.addEventListener(MouseEvent.ROLL_OUT,onRollOut);
			}else{
				if(_scrollTarget!=value){
					_scrollTarget=value;
					_scrollTarget.addEventListener(MouseEvent.ROLL_OVER,onRollOver);
					_scrollTarget.addEventListener(MouseEvent.ROLL_OUT,onRollOut);
				}
				else{
					_scrollTarget=value;
				}				
			}			
			dragButtonDraw();
			MarkDraw();
			//是否总是指向最后一行
			if(_EndLine){
				if(isTweenLite)
					TweenLite.to( _scrollTarget, 0.6, { y:this.y-(_scrollTarget.height-this.myHeight) } );
				else
					_scrollTarget.y = this.y-(_scrollTarget.height-this.myHeight);
			}else{
				_scrollTarget.y=this.y;	
			}			
			Reorganizes();
			//重新设置拖动条位置
			if(_EndLine)
			{
				dragButton.y=this.height-_generalWidth-dragButton.height;
				_lineBtm.y = dragButton.y + (dragButton.height - _lineBtm.height)/2;
			}
			_scrollTarget.mask=_mark;
		}
		public function get scrollTarget():Sprite{
			return _scrollTarget;
		}
		public function dragButtonDraw():void{
			if(_scrollTarget==null) return;
			var _BH:Number=this.myHeight*(this.myHeight-_generalWidth*2)/_scrollTarget.height;
			if(_BH>2&&_BH<this.myHeight-_generalWidth*2){
				dragButton.visible=true;
				_lineBtm.visible = true;
				//dragButton.HButtonInIt("",_generalWidth,_BH);
				dragButton.height=_BH;
			}else{
				dragButton.visible=false;
				_lineBtm.visible = false;
			}
		}
		private function MarkDraw():void{
			if(_scrollTarget==null) return;
			_mark.graphics.clear();
			_mark.graphics.beginFill(0xFF0000);     
			_mark.graphics.drawRect(0, 0, _scrollTarget.width, _myHeight);     
			_mark.graphics.endFill();
		}
		
		/**
		 * 自定义皮肤,需要在调用InIt方法前设置
		 * @param upBtmSkinArr		: 上按钮皮肤数组,与HSimpleButton.setSkin()方法传参对应
		 * @param downBtmSkinArr	: 下按钮皮肤数组,与HSimpleButton.setSkin()方法传参对应
		 * @param dragSkinArr		: 拖动按钮皮肤数组,与HButton.setSkin()方法传参对应
		 * @param bgBtmd			: 拖动条背景位图
		 */		
		public function setSkin(upBtnSkinArr:Array = null, downBtnSkinArr:Array = null, dragBtnSkinArr:Array = null, bgBtmd:BitmapData = null):void
		{
			if(upBtnSkinArr)	_upBtnSkinArr = upBtnSkinArr;
			if(downBtnSkinArr)	_downBtnSkinArr = downBtnSkinArr;
			if(dragBtnSkinArr)	_dragBtnSkinArr = dragBtnSkinArr;
			if(bgBtmd)			_backbmd = bgBtmd;
		}
		/**
		 * 设置默认皮肤
		 * @param value	: 皮肤类型(0:传统有上下箭头的拖动条 1:无上下箭头拖动条)
		 */		
		public function setDefaultSkinByType(value:int = 0):void
		{
			type = value;

			//设置上按钮皮肤
			_upBtnSkinArr = [new ScrollBar_UpButton_Up(), new ScrollBar_UpButton_Over(), new ScrollBar_UpButton_Down(), new ScrollBar_UpButton_Disabled()];
			_downBtnSkinArr = [new ScrollBar_DownButton_Up(), new ScrollBar_DownButton_Over(), new ScrollBar_DownButton_Down(), new ScrollBar_DownButton_Disabled()];
			_dragBtnSkinArr = [new ScrollBar_DragButton_Up(), new ScrollBar_DragButton_Over(), new ScrollBar_DragButton_Down(), new ScrollBar_DragButton_Disabled()];

			//设置背景皮肤
			_backbmd = new ScrollBar_BackPanel();
		}
		/** 根据拖动内容的位置更新拖动条块的位置 **/
		public function updateScrollBarLocation():void
		{
			dragButton.y = ((this.y - _scrollTarget.y) /(_scrollTarget.height - this.height) * (this.height - _generalWidth * 2 - dragButton.height)) + _generalWidth;
			if(dragButton.y > Number(this.myHeight-dragButton.height-_generalWidth))
			{
				dragButton.y = Number(this.myHeight-dragButton.height-_generalWidth);
			}
			else if(dragButton.y < _generalWidth)
			{
				dragButton.y = _generalWidth;
			}
			_lineBtm.y = dragButton.y + (dragButton.height - _lineBtm.height)/2;
		}

		public function get dragBtnWidth():int
		{
			return _dragBtnWidth;
		}

		public function set dragBtnWidth(value:int):void
		{
			_dragBtnWidth = value;
		}

	}
}