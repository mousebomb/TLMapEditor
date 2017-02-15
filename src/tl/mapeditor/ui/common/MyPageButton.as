package tl.mapeditor.ui.common
{
	import tl.mapeditor.UIModule.*;
	/**
	 * 公用切页按钮
	 * @author 李舒浩
	 * 用法:
	 * 		var pageButton:HPageButton = new HPageButton();
	 * 		//默认皮肤类型
	 *		//pageButton.setDefaultSkin(1);//0为2按钮 1为4按钮
	 *		pageButton.init(10);
	 *		pageButton.textColor = 0xFF0000;
	 *		this.addChild(pageButton);
	 * 
	 * 	ps : 如果不需要顶页与最后一页,传如皮肤时只需要传入上一页与下一页数组即可
	 * 
	 *  方法与属性：
	 * 		textColor		: 页数显示16进制颜色值
	 * 		nowPage			: 当前页数
	 * 		maxPage			: 最大页数
	 * 		clear()			: 销毁清除方法(当不需要使用此组件时请调用此方法销毁以便释放内存)
	 * 		setDefaultSkin(): 默认皮肤方法,参数为类型
	 * 事件:
	 * 		MyPageButton.CLEARCOMPONENT	: (Event)清除该按钮时派发,一般用于清除内部样式后在外部移除相关事件,从父对象中移除,清空索引等
	 * 		MyPageButton.PAGING			: (Event)切页时执行
	 * 		MyPageButton.SETMAXPAGING	: (Event)设置最大页时派发
	 */	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import Lib.App.ResourcePool;
	import Lib.BaseClass.MySprite;
	import Lib.Tool.Tool;
	
	import tool.Away3DConfig;

	public class MyPageButton extends MySprite
	{
		public static const PAGING:String = "paging";
		public static const SETMAXPAGING:String = "setMaxPaging";
		public static const CLEARCOMPONENT:String = "clearComponent";
		
		private var _btnArr:Array;			//切页按钮数组
		private var _pageText:MyTextField;	//页数显示文本
		private var _nowPage:int = 1;		//当前页数
		private var _maxPage:int = 1;		//总页数
		private var _type:int = 0;			//切页按钮类型(0:2个按钮 1:4个按钮)
		private var _nowTime:int = 0;		//当前点住按钮停顿时间
		private var _actionTime:int = 5;	//停顿时间点
		private var _index:int = 1;		//切页标识
		
		private var _timer:Timer;			//定时器
		private var _backSprite:Bitmap;	//页数背景图
		private var _backBitmapdata:BitmapData;		//页数背景图背景
		private var _skinArr:Array;					//初始化皮肤数组
		public var isCanPaging:Boolean = true;			//是否可执行切换(false:不可切页 true:可切页)
		
		public function MyPageButton()  {  super();  }
		
		/**
		 * 初始化 
		 * @param maxPage	: 总页数
		 * @param $myWidth	: 切页按钮页数显示背景宽度
		 * @param $myHeight	: 切页按钮页数显示背景高度
		 */		
		public function init(maxPage:int = 1, $myWidth:int = 35, $myHeight:int = 12):void
		{
			_maxPage = maxPage;
			if(!_skinArr || _skinArr.length == 0) setDefaultSkin();
			var len:int = _skinArr.length;
			_type = (len == 2 ? 0 : 1);
			
			_timer = new Timer(100);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			
			//背景位图
			_backSprite = new Bitmap();
			_backSprite.bitmapData = _backBitmapdata;
			_backSprite.width = $myWidth;
			_backSprite.height = $myHeight;
			this.addChild(_backSprite);
			//页数显示文本
			_pageText = Tool.getMyTextField(_backSprite.width, -1, 10, 0xCCCCCC, "center", 0, false, "华文琥珀");
			this.addChild(_pageText);
			_pageText.text = _nowPage + "/" + _maxPage;
			_pageText.mouseEnabled = _pageText.mouseWheelEnabled = false;
			_pageText.y = _backSprite.y + (_backSprite.height - _pageText.height)/2;
		
			
			//实例化前面的按钮
			var btnWidth:int = 0;
			_btnArr = [];
			len = len >> 1;
			var btnW:int = _skinArr[0][0].width;
			var btnH:int = _skinArr[0][0].height;
			var btn:MyButton;	//点击按钮
			for(var i:int = 0; i < len; i++)
			{
				btn = Tool.getMyBtn("", btnW, btnH, _skinArr[i][0], _skinArr[i][1], _skinArr[i][2], _skinArr[i][3]);
				this.addChild(btn);
				btn.x = i * btn.myWidth;
				btn.y = (_backSprite.height - btn.myHeight)/2;
				btnWidth += btn.width;
				_btnArr.push(btn);
				
				btn.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				btn.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				btn.addEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
			}
			_backSprite.x = btn.x + btn.myWidth;
			_pageText.x = _backSprite.x;
			//实例化后面的按钮
			var btnNun:int = _btnArr.length;
			for(i = 0; i < len; i++)
			{
				btn = Tool.getMyBtn("", btnW, btnH, _skinArr[btnNun+i][0], _skinArr[btnNun+i][1], _skinArr[btnNun+i][2], _skinArr[btnNun+i][3]);
				this.addChild(btn);
				btn.x = _backSprite.x + $myWidth + i * btn.myWidth;
				btn.y = (_backSprite.height - btn.myHeight)/2;
				btnWidth += btn.width;
				_btnArr.push(btn);
				
				btn.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				btn.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				btn.addEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
			}
			//设置宽高
			this.myWidth = btnWidth + $myWidth;
			this.myHeight = $myHeight;
			
			isCanInput = isCanInput;
		}
		/**
		 * 设置皮肤 
		 * @param skinArr	: 切换按钮的皮肤数组,如果不传此参数则默认绘制皮肤,(二维数组,[i][[0]:up,[i][1]:over,[i][2]:down,[i][3]:disabled])
		 * 					: 皮肤规则从左到右皮肤顺序,如:[0]:上一页,[1]:下一页
		 * 					: 如果需要有最上一页或最下页,则规则为:[0]:最上一页,[1]:上一页, [2]:下一页,[3]:最下一页
		 * @param back		: 页数文字背景
		 */		
		public function setSkin(skinArr:Array = null, back:BitmapData = null):void
		{
			_skinArr = skinArr;
			_backBitmapdata = back;
		}
		
		/**
		 * 初始化皮肤
		 * @param type	: 类型(0:2个按钮 1:4个按钮)
		 */		
		public function setDefaultSkin(type:int = 0):void
		{
			var arr:Array;
			//设置皮肤
			var backBtmd:BitmapData = ResourcePool.getInstance().getBtmdBySwf("Skin", "Skin_PageButton_BG");
			//设置按钮
			switch(type)
			{
				case 0:
					arr = [
						[
							 ResourcePool.getInstance().getBtmdBySwf("Skin", "Skin_PageButton_L_Up")
							,ResourcePool.getInstance().getBtmdBySwf("Skin", "Skin_PageButton_L_Over")
							,ResourcePool.getInstance().getBtmdBySwf("Skin", "Skin_PageButton_L_Down")
							,ResourcePool.getInstance().getBtmdBySwf("Skin", "Skin_PageButton_L_Disabled") 
						]
						,[
							 ResourcePool.getInstance().getBtmdBySwf("Skin", "Skin_PageButton_R_Up")
							,ResourcePool.getInstance().getBtmdBySwf("Skin", "Skin_PageButton_R_Over")
							,ResourcePool.getInstance().getBtmdBySwf("Skin", "Skin_PageButton_R_Down")
							,ResourcePool.getInstance().getBtmdBySwf("Skin", "Skin_PageButton_R_Disabled") 
						]
					]
					break;
				case 1:
					arr = [
						[
							ResourcePool.getInstance().getBtmdBySwf("Skin", "Skin_PageButton_L_Up")
							,ResourcePool.getInstance().getBtmdBySwf("Skin", "Skin_PageButton_L_Over")
							,ResourcePool.getInstance().getBtmdBySwf("Skin", "Skin_PageButton_L_Down")
							,ResourcePool.getInstance().getBtmdBySwf("Skin", "Skin_PageButton_L_Disabled") 
						]
						,[
							ResourcePool.getInstance().getBtmdBySwf("Skin", "Skin_PageButton_L_Up")
							,ResourcePool.getInstance().getBtmdBySwf("Skin", "Skin_PageButton_L_Over")
							,ResourcePool.getInstance().getBtmdBySwf("Skin", "Skin_PageButton_L_Down")
							,ResourcePool.getInstance().getBtmdBySwf("Skin", "Skin_PageButton_L_Disabled") 
						]
						,[
							ResourcePool.getInstance().getBtmdBySwf("Skin", "Skin_PageButton_R_Up")
							,ResourcePool.getInstance().getBtmdBySwf("Skin", "Skin_PageButton_R_Over")
							,ResourcePool.getInstance().getBtmdBySwf("Skin", "Skin_PageButton_R_Down")
							,ResourcePool.getInstance().getBtmdBySwf("Skin", "Skin_PageButton_R_Disabled") 
						]
						,[
							ResourcePool.getInstance().getBtmdBySwf("Skin", "Skin_PageButton_R_Up")
							,ResourcePool.getInstance().getBtmdBySwf("Skin", "Skin_PageButton_R_Over")
							,ResourcePool.getInstance().getBtmdBySwf("Skin", "Skin_PageButton_R_Down")
							,ResourcePool.getInstance().getBtmdBySwf("Skin", "Skin_PageButton_R_Disabled") 
						]
					]
					break;
			}
			
			setSkin(arr, backBtmd)
		}
		
		/** 鼠标点下事件 **/
		private function onMouseDown(e:MouseEvent):void
		{
			if(!isCanPaging) return;
			var page:int = _nowPage;
			switch(e.currentTarget)	
			{
				case _btnArr[0]:	//上一页或最上一页
					if(_type == 0)	//判断是否为2个按钮类型
					{
						if(page > 1) page--;
						_index = -1;
						_timer.start();
						_nowTime = 0;
					}
					else
						page = 1;
					break;
				case _btnArr[1]:	//上一页或下一页
					if(_type == 0)	//判断是否为2个按钮类型
					{
						if(page < _maxPage) page++;
						_index = 1;
					}
					else
					{
						if(page > 1) page--;
						_index = -1;
					}
					_timer.start();
					_nowTime = 0;
					break;
				case _btnArr[2]:	//下一页
					if(page < _maxPage) page++;
					_index = 1;
					_timer.start();
					_nowTime = 0;
					break;
				case _btnArr[3]:	//最后一页
					page = _maxPage;
					break;
			}
			nowPage = page;
		}
		/** 鼠标松开事件 **/
		private function onMouseUp(e:MouseEvent):void
		{
			_timer.stop();
			_nowTime = 0;
		}
		
		/** 点住切页按钮键快速切换执行 **/
		private function onTimer(e:TimerEvent):void
		{
			if(!isCanPaging) return;
			_nowTime++;
			if(_nowTime >= _actionTime)
			{
				_nowPage += _index;
				nowPage = _nowPage;
			}
		}
		
		/**
		 * 设置切页字体显示颜色 
		 * @param value	: 字体颜色
		 */		
		public function set textColor(value:uint):void
		{
			_pageText.color = value;
			nowPage = _nowPage;
		}
		/**
		 * 设置当前页 
		 * @param value	: 设置当前页(从第一页算起)
		 */		
		public function set nowPage(value:int):void
		{
			if(value >= _maxPage) 
			{
				value = _maxPage;
				_timer.stop();
				_nowTime = 0;
			}
			else if(value <= 1)
			{
				value = 1;
				_timer.stop();
				_nowTime = 0;
			}
			_nowPage = value;
			_pageText.text = _nowPage + "/" + _maxPage;
			//执行不断切页
			this.dispatchEvent(new Event(MyPageButton.PAGING));
		}
		public function get nowPage():int { return _nowPage; }
		
		/**
		 * 设置页数最大值 
		 * @param value	: 设置最大页数
		 */		
		public function set maxPage(value:int):void
		{
			if(value < 0)
			{
				value = 1;
			}
			_maxPage = value;
			_pageText.text = _nowPage + "/" + _maxPage;
			
			this.dispatchEvent(new Event(MyPageButton.SETMAXPAGING));
		}
		public function get maxPage():int { return _maxPage; }
		
		/** 按钮类型(0为2按钮 1为4按钮) **/
		public function get type():int  {  return _type;  }
		/**
		 * 是否可输入设置
		 * @param value
		 */		
		public function set isCanInput(value:Boolean):void
		{
			_isCanInput = value;
			if(!_pageText) return;
			_pageText.mouseEnabled = _pageText.mouseWheelEnabled = _isCanInput;
			if(_isCanInput)
			{
				_pageText.type = "input";
				_pageText.restrict = "0-9";
				_pageText.tabEnabled = false;
				if( !_pageText.hasEventListener(FocusEvent.FOCUS_IN) )
				{
					_pageText.addEventListener(FocusEvent.FOCUS_IN, onTextFocusIn);
					_pageText.addEventListener(FocusEvent.FOCUS_OUT, onTextFocusOut);
					Away3DConfig.myStage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyBoard);
				}
			}
			else
			{
				_pageText.type = "input";
				_pageText.restrict = null;
				_pageText.tabEnabled = false;
				_pageText.removeEventListener(FocusEvent.FOCUS_IN, onTextFocusIn);
				_pageText.removeEventListener(FocusEvent.FOCUS_OUT, onTextFocusOut);
				Away3DConfig.myStage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyBoard);
			}
		}
		public function get isCanInput():Boolean { return _isCanInput; }
		private var _isCanInput:Boolean = false;
		
		/** 输入文本获得焦点执行 **/
		private function onTextFocusIn(e:FocusEvent):void
		{
			_oldPage = _nowPage;
			e.currentTarget.text = "";
		}
		private var _oldPage:int;
		
		/** 输入文本失去焦点执行 **/
		private function onTextFocusOut(e:FocusEvent):void
		{
			var textField:MyTextField = MyTextField(e.currentTarget);
			
			if(textField.text == "")
				nowPage = _oldPage;
			else
			{
				var inputPage:int = int(textField.text);
				nowPage = inputPage;
			}
		}
		/** 键盘点击执行 **/
		private function onKeyBoard(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case 13:	//回车
					Away3DConfig.myStage.focus = null;
//					_pageText.dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT));
					break;
			}
		}
		
		/** 清除方法 **/
		public function clear():void
		{
			isCanInput = false;
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			for each(var btn:MyButton in _btnArr)
			{
				btn.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				btn.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				btn.removeEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
				btn.clear();
				btn = null;
			}
			_btnArr.length = 0;
			_btnArr = null;
			_backBitmapdata.dispose();
			_backBitmapdata = null;
			_backSprite = null;
			_pageText = null;
			_timer = null;
			
			this.dispatchEvent(new Event(MyPageButton.CLEARCOMPONENT));
		}
	}
}