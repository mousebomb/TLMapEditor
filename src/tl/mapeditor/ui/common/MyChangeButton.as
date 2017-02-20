package tl.mapeditor.ui.common
{
	/**
	 * 调整按钮组
	 * @author 李舒浩
	 */

	import flash.display.BitmapData;
	import flash.events.MouseEvent;

	import tl.utils.Tool;

	public class MyChangeButton extends MySprite
	{
		public static const EVENT_CHANGE:String = "Change";
		public static const NARROW:String = "Narrow";
		public static const ENLARGE:String = "Enlarge";
		
		private var _upBtmd:BitmapData;			//按钮样式bitmapdata
		private var _overBtmd:BitmapData;
		private var _downBtmd:BitmapData;
		private var _disabledBtmd:BitmapData;
		private var _selectedBtmd:BitmapData;
		
		private var _upBtmd1:BitmapData;			//按钮样式bitmapdata
		private var _overBtmd1:BitmapData;
		private var _downBtmd1:BitmapData;
		private var _disabledBtmd1:BitmapData;
		private var _selectedBtmd1:BitmapData;
		public var isVertical:Boolean = true;
		
		public function MyChangeButton()  {  super();  }
		
		public function init():void
		{
			//缩小按钮
			var narrowBtn:MyButton = Tool.getMyBtn("", _upBtmd.width, _upBtmd.height, _upBtmd, _overBtmd, _downBtmd, _disabledBtmd, _selectedBtmd);
			narrowBtn.name = "NarrowBtn";
			this.addChild(narrowBtn);
			//放大按钮
			var enlargeBtn:MyButton = Tool.getMyBtn("", _upBtmd1.width, _upBtmd1.height, _upBtmd1, _overBtmd1, _downBtmd1, _disabledBtmd1, _selectedBtmd1);
			this.addChild(enlargeBtn);
			enlargeBtn.name = "EnlargeBtn";
			if(isVertical)
			{
				enlargeBtn.x = narrowBtn.x;
				enlargeBtn.y = narrowBtn.y + narrowBtn.myHeight;
				this.myWidth = _upBtmd.width;
				this.myHeight = _upBtmd.height*2;
			}	else {
				enlargeBtn.x = narrowBtn.x + narrowBtn.myWidth + 5;
				enlargeBtn.y = narrowBtn.y;
				this.myWidth = _upBtmd.width*2 + 5;
				this.myHeight = _upBtmd.height;
			}
			//this.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			switch(e.target.name)
			{
				case "NarrowBtn":
					//this.dispatchEvent(new MyEvent(MyChangeButton.EVENT_CHANGE, MyChangeButton.NARROW));
					break;
				case "EnlargeBtn":
					//this.dispatchEvent(new MyEvent(MyChangeButton.EVENT_CHANGE, MyChangeButton.ENLARGE));
					break;
			}
		}
		
		/**
		 * 默认按钮样式
		 */		
		public function setDefaultSkin():void
		{
			var upBtmd:BitmapData = new Skin_u_Up();
			var overBtmd:BitmapData = new Skin_u_Over();
			var downBtmd:BitmapData = new Skin_u_Down();
			
			var upBtmd1:BitmapData = new Skin_D_Up();		//↓
			var overBtmd1:BitmapData = new Skin_D_Over();
			var downBtmd1:BitmapData = new Skin_D_Down();
			
			
			//设置皮肤
			setSkin( Vector.<BitmapData>([upBtmd, overBtmd, downBtmd, upBtmd, overBtmd]), Vector.<BitmapData>([upBtmd1, overBtmd1, downBtmd1, upBtmd1, overBtmd1]) );
		}
		
		/**
		 * 设置按钮皮肤 
		 */		
		public function setSkin(vec:Vector.<BitmapData>, vec1:Vector.<BitmapData>):void
		{
			_upBtmd = vec[0];
			_overBtmd = vec[1];
			_downBtmd = vec[2];
			_disabledBtmd = vec[3];
			_selectedBtmd = vec[4];
			
			_upBtmd1 = vec1[0];
			_overBtmd1 = vec1[1];
			_downBtmd1 = vec1[2];
			_disabledBtmd1 = vec1[3];
			_selectedBtmd1 = vec1[4];
		}
		
	}
}