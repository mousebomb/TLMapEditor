package HLib.UICom.Component
{
	/**
	 * 公用切页按钮
	 * @author 李舒浩
	 * 用法:
	 * 		var pageButton:HPageButton = new HPageButton();
	 * 		//设置皮肤
	 * 		pageButton.setSkin(
	 * 				[
	 *					[
	 *						HAssetsManager.getInstance().getTexture("mainFaceSource", "topPage_Up")
	 *						,HAssetsManager.getInstance().getTexture("mainFaceSource", "topPage_Over")
	 *						,HAssetsManager.getInstance().getTexture("mainFaceSource", "topPage_Down")
	 *						,HAssetsManager.getInstance().getTexture("mainFaceSource", "topPage_Disabled") 
	 *					]
	 *					,[
	 *						HAssetsManager.getInstance().getTexture("mainFaceSource", "PrePage_Up")
	 *						,HAssetsManager.getInstance().getTexture("mainFaceSource", "PrePage_Over")
	 *						,HAssetsManager.getInstance().getTexture("mainFaceSource", "PrePage_Down")
	 *						,HAssetsManager.getInstance().getTexture("mainFaceSource", "PrePage_Disabled") 
	 *					]
	 *					,[
	 *						HAssetsManager.getInstance().getTexture("mainFaceSource", "NextPage_Up")
	 *						,HAssetsManager.getInstance().getTexture("mainFaceSource", "NextPage_Over")
	 *						,HAssetsManager.getInstance().getTexture("mainFaceSource", "NextPage_Down")
	 *						,HAssetsManager.getInstance().getTexture("mainFaceSource", "NextPage_Disabled") 
	 *					]
	 *					,[
	 *						HAssetsManager.getInstance().getTexture("mainFaceSource", "lastPage_Up")
	 *						,HAssetsManager.getInstance().getTexture("mainFaceSource", "lastPage_Over")
	 *						,HAssetsManager.getInstance().getTexture("mainFaceSource", "lastPage_Down")
	 *						,HAssetsManager.getInstance().getTexture("mainFaceSource", "lastPage_Disabled") 
	 *					]
	 *				]
	 * 		);
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
	 * 		ClearComponent	: (Event)清除该按钮时派发,一般用于清除内部样式后在外部移除相关事件,从父对象中移除,清空索引等
	 * 		Paging			: (Event)切页时执行
	 * 		setMaxPaging	: (Event)设置最大页时派发
	 */	
	import flash.geom.Rectangle;
	
	import HLib.UICom.BaseClass.HSprite;
	import HLib.UICom.BaseClass.HTextField;
	
	import Modules.Common.HAssetsManager;
	
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	import starling.textures.Texture;

	public class HPageButton extends HSprite
	{
		private var _btnArr:Array;			//切页按钮数组
		private var _pageText:HTextField;	//页数显示文本
		private var _nowPage:int = 1;		//当前页数
		private var _maxPage:int = 1;		//总页数
		private var _type:int = 0;			//切页按钮类型(0:2个按钮 1:4个按钮)
		private var _nowTime:int = 0;		//当前点住按钮停顿时间
		private var _actionTime:int = 5;	//停顿时间点
		private var _index:int = 1;		//切页标识
		
//		private var _timer:Timer;			//定时器
		private var _backImage:Scale9Image;	//页数背景图
		private var _backTexture:Texture;				//页数背景图背景
		private var _skinArr:Array;					//初始化皮肤数组
		public var isCanPaging:Boolean = true;			//是否可执行切换(false:不可切页 true:可切页)
		
		public function HPageButton()  {  super();  }
		
		/**
		 * 初始化 
		 * 
		 * @param maxPage	: 总页数
		 * @param $myWidth	: 切换按钮的宽度
		 * @param $myHeight	: 切换按钮的高度
		 */		
		public function init(maxPage:int = 1, $myWidth:int = 55, $myHeight:int = 20):void
		{
			_maxPage = maxPage;
			if(!_skinArr || _skinArr.length == 0) setDefaultSkin();
			var len:int = _skinArr.length;
			_type = (len == 2 ? 0 : 1);
			
			/*_timer = new Timer(100);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);*/
			//背景位图
			var scale9texture:Scale9Textures = new Scale9Textures(_backTexture,new Rectangle(int(_backTexture.width/3),int(_backTexture.height/3),int(_backTexture.width/3),int(_backTexture.height/3)));
			_backImage = new Scale9Image(scale9texture);
			this.addChild(_backImage);
			_backImage.width = $myWidth;
			_backImage.height = $myHeight;
			var w:int = 0;
			var h:int = 0;
			_btnArr = [];
			var btn:HSimpleButton;	//点击按钮
			var arr:Array;
			for(var i:int = 0; i < len; i++)
			{
				//保存宽高
				if(h < _skinArr[i][0].height) h = _skinArr[i][0].height;
				//实例化按钮
				arr = _skinArr[i];
				btn = new HSimpleButton();
				btn.setTextureSkin(arr[0],arr[1],arr[2],arr[3]);
				btn.init("");
				this.addChild(btn);
				btn.x = w;
				btn.y = (_backImage.height - btn.myHeight)/2;
				btn.addEventListener(Event.TRIGGERED, onMouseDown);
				/*btn.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				btn.addEventListener(MouseEvent.MOUSE_OUT, onMouseUp);*/
				_btnArr.push(btn);
				w += _btnArr[i].width;
			}
			
			if(_type == 0)	_backImage.x = _btnArr[0].width ;
			else 			_backImage.x = _btnArr[0].width + _btnArr[1].width ;
			
			//页数显示文本
			_pageText = new HTextField(_backImage.width,20,_nowPage + "/" + _maxPage,"宋体",12,0xffffffff);
			this.addChild(_pageText);
			/*Tool.setDisplayGlowFilter(_pageText, 0x0, 1, 2, 2, 3);*/
			_pageText.touchable = false;
			_pageText.x = _backImage.x;
			_pageText.y = _backImage.y + (_backImage.height - _pageText.height)/2;
			
			//重整切页界面后面的的按钮位置
			if(_type == 0)
				_btnArr[1].x = _backImage.x + _backImage.width;
			else
			{
				_btnArr[2].x = _backImage.x + _backImage.width;
				_btnArr[3].x = _btnArr[2].x + _btnArr[2].width ;
			}
			//设置宽高
			this.myWidth = w + _backImage.width;
			this.myHeight = (h > _backImage.height ? h : _backImage.height);
		}
		/**
		 * 设置皮肤 
		 * @param skinArr	: 切换按钮的皮肤数组,如果不传此参数则默认绘制皮肤,(二维数组,[i][[0]:up,[i][1]:over,[i][2]:down,[i][3]:disabled])
		 * 					: 皮肤规则从左到右皮肤顺序,如:[0]:上一页,[1]:下一页
		 * 					: 如果需要有最上一页或最下页,则规则为:[0]:最上一页,[1]:上一页, [2]:下一页,[3]:最下一页
		 * @param back		: 页数文字背景
		 */		
		public function setSkin(skinArr:Array = null, back:Texture = null):void
		{
			_skinArr = skinArr;
			_backTexture = back;
		}
		
		
		/**
		 * 初始化皮肤
		 * @param type	: 类型(0:2个按钮 1:4个按钮)
		 */		
		public function setDefaultSkin(type:int = 0):void
		{
			var arr:Array;
			//设置皮肤
			var backBtmd:Texture = HAssetsManager.getInstance().getTexture("mainFaceSource","Cave_NumberBG");
			//设置按钮
			switch(type)
			{
				case 0:
					arr = [
						[
							 HAssetsManager.getInstance().getTexture("mainFaceSource", "PrePage_up")
							,HAssetsManager.getInstance().getTexture("mainFaceSource", "PrePage_over")
							,HAssetsManager.getInstance().getTexture("mainFaceSource", "PrePage_down")
							,HAssetsManager.getInstance().getTexture("mainFaceSource", "PrePage_Disabled") 
						]
						,[
							 HAssetsManager.getInstance().getTexture("mainFaceSource", "NextPage_up")
							,HAssetsManager.getInstance().getTexture("mainFaceSource", "NextPage_over")
							,HAssetsManager.getInstance().getTexture("mainFaceSource", "NextPage_down")
							,HAssetsManager.getInstance().getTexture("mainFaceSource", "NextPage_disabled") 
						]
					]
					break;
				case 1:
					arr = [
						[
							HAssetsManager.getInstance().getTexture("mainFaceSource", "TopPage_up")
							,HAssetsManager.getInstance().getTexture("mainFaceSource", "TopPage_over")
							,HAssetsManager.getInstance().getTexture("mainFaceSource", "TopPage_down")
							,HAssetsManager.getInstance().getTexture("mainFaceSource", "TopPage_disabled") 
						]
						,[
							HAssetsManager.getInstance().getTexture("mainFaceSource", "PrePage_up")
							,HAssetsManager.getInstance().getTexture("mainFaceSource", "PrePage_over")
							,HAssetsManager.getInstance().getTexture("mainFaceSource", "PrePage_down")
							,HAssetsManager.getInstance().getTexture("mainFaceSource", "PrePage_disabled") 
						]
						,[
							HAssetsManager.getInstance().getTexture("mainFaceSource", "NextPage_up")
							,HAssetsManager.getInstance().getTexture("mainFaceSource", "NextPage_over")
							,HAssetsManager.getInstance().getTexture("mainFaceSource", "NextPage_down")
							,HAssetsManager.getInstance().getTexture("mainFaceSource", "NextPage_disabled") 
						]
						,[
							HAssetsManager.getInstance().getTexture("mainFaceSource", "Top_page2_up")
							,HAssetsManager.getInstance().getTexture("mainFaceSource", "Top_page2_over")
							,HAssetsManager.getInstance().getTexture("mainFaceSource", "Top_page2_down")
							,HAssetsManager.getInstance().getTexture("mainFaceSource", "Top_page2_disabled") 
						]
					]
					break;
			}
			
			setSkin(arr, backBtmd)
		}
		
		/** 鼠标点下事件 **/
		private function onMouseDown(e:Event):void
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
						/*_timer.start();
						_nowTime = 0;*/
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
					/*_timer.start();
					_nowTime = 0;*/
					break;
				case _btnArr[2]:	//下一页
					if(page < _maxPage) page++;
					_index = 1;
					/*_timer.start();
					_nowTime = 0;*/
					break;
				case _btnArr[3]:	//最后一页
					page = _maxPage;
					break;
			}
			nowPage = page;
		}
		/** 鼠标松开事件 **/
		/*private function onMouseUp(e:MouseEvent):void
		{
			_timer.stop();
			_nowTime = 0;
		}*/
		
		/** 点住切页按钮键快速切换执行 **/
		/*private function onTimer(e:TimerEvent):void
		{
			if(!isCanPaging) return;
			_nowTime++;
			if(_nowTime >= _actionTime)
			{
				_nowPage += _index;
				nowPage = _nowPage;
			}
		}*/
		
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
		 * @param value	: 设置当前页
		 */		
		public function set nowPage(value:int):void
		{
			if(value >= _maxPage) 
			{
				value = _maxPage;
				/*_timer.stop();
				_nowTime = 0;*/
			}
			else if(value <= 1)
			{
				value = 1;
				/*_timer.stop();
				_nowTime = 0;*/
			}
			_nowPage = value;
			_pageText.text = _nowPage + "/" + _maxPage;
			//执行不断切页
			this.dispatchEvent(new Event("Paging"));
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
			
			this.dispatchEvent(new Event("setMaxPaging"));
		}
		public function get maxPage():int { return _maxPage; }
		
		/** 按钮类型(0为2按钮 1为4按钮) **/
		public function get type():int  {  return _type;  }
		
		/** 清除方法 **/
		public override function dispose():void
		{
			/*_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);*/
			for each(var btn:HSimpleButton in _btnArr)
			{
				btn.removeEventListener(Event.TRIGGERED, onMouseDown);
				/*btn.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				btn.removeEventListener(MouseEvent.MOUSE_OUT, onMouseUp);*/
				btn.dispose()
				btn = null;
			}
			_btnArr.length = 0;
			_btnArr = null;
			_backImage.dispose();
			_backImage = null;
			_backTexture = null;
			_pageText = null;
			/*_timer = null;*/
			
			this.dispatchEvent(new Event("ClearComponent"));
		}
	}
}