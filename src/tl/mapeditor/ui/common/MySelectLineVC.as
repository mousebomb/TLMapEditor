package tl.mapeditor.ui.common
{
	/**
	 * 选择条管理类
	 * @author 李舒浩
	 */

	import flash.display.BitmapData;
	import flash.events.MouseEvent;

	import tl.utils.Tool;

	public class MySelectLineVC extends MySprite
	{
		private var _titleVec:Vector.<MyTitleView>;
		private var _btnVec:Vector.<MyButton>;	
		
		private var _nowSelect:MyButton;	//当前选择的按钮
		
		public var isSelectFirst:Boolean = false;		//是否默认选择第一个
		public var selectCallBack:Function;
		public var isShowSelectBtn:Boolean = true;		//是否显示选择按钮
		
		public function MySelectLineVC()  {  super();  }
		
		public function init(widthArr:Array, len:int):void
		{
			if(this.isInit) return;
			this.isInit = true;
			
			var checkUpBtmd:BitmapData 		= new Skin_CheckButton_Up();		//选择按钮
			var checkSelectBtmd:BitmapData 	= new Skin_CheckButton_Select();
			
			_titleVec = new Vector.<MyTitleView>(len, true);
			_btnVec = new Vector.<MyButton>(len, true);
			var titleView:MyTitleView;
			var btn:MyButton;
			for(var i:int = 0; i < len; i++)
			{
				titleView = new MyTitleView();
				titleView.init(widthArr);
				titleView.name = String(i);
				this.addChild(titleView);
				titleView.y = i * titleView.myHeight;
				_titleVec[i] = titleView;
				
				if(!isShowSelectBtn) continue;
				//选择按钮
				btn = Tool.getMyBtn("", checkUpBtmd.width, checkUpBtmd.height, checkUpBtmd, checkSelectBtmd, checkSelectBtmd, checkUpBtmd, checkSelectBtmd);
				this.addChild(btn);
				btn.name = "Btn_" + i;
				btn.x = (titleView.titleTextVec[0].width - btn.myWidth)/2;
				btn.y = titleView.y + (titleView.titleTextVec[0].height - btn.myHeight)/2;
				_btnVec[i] = btn;
			}
			this.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			if( !(e.target is MyButton) && !(e.target is MyTitleView)) return;
			var nameStr:String = e.target.name;
			nameStr = nameStr.replace("Btn_", "");
			
			if(_nowSelect) _nowSelect.selected = false;
			_nowSelect = MyButton(this.getChildByName("Btn_"+nameStr));//MyButton(e.target);
			_nowSelect.selected = true;
			if(selectCallBack != null) selectCallBack(int(nameStr));
		}
		/**
		 * 设置内容
		 * @param vec	: 内容数组
		 */		
		public function setData(vec:Vector.<Array>):void
		{
			_nowSelect = null;
			var len:int = _titleVec.length;
			for(var i:int = 0; i < len; i++)
			{
				if(!vec)
				{
					_titleVec[i].titleLabel = null;
					if(isShowSelectBtn) _btnVec[i].visible = false;
					continue;
				}
				if(vec.length <= i)
				{
					_titleVec[i].titleLabel = null;
					if(isShowSelectBtn) _btnVec[i].visible = false;
				}
				else
				{
					_titleVec[i].titleLabel = vec[i];
					if(isShowSelectBtn) 
					{
						_btnVec[i].visible = true;
						_btnVec[i].selected = false;
					}
				}
			}
			//判断是否默认选第一个
			if(isSelectFirst)
			{
				_btnVec[0].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}

		public function get titleVec():Vector.<MyTitleView>  {  return _titleVec;  }
		
		
		
	}
}