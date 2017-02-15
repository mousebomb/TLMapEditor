package tl.mapeditor.ui
{
	/**
	 *菜单栏
	 */

	import flash.events.MouseEvent;

	import tl.mapeditor.ToolBoxType;

	import tl.mapeditor.ui.common.MySprite;
	import tl.mapeditor.ui.common.MyTextButton;
	import tl.mapeditor.ui.common.MyTextField;
	import tl.utils.Tool;

	public class PopMenuBar extends MySprite
	{
		
		public var selectCallBack:Function;
		public const fillVector:Vector.<String> = new <String>[ToolBoxType.BAR_NAME_17, ToolBoxType.BAR_NAME_18, ToolBoxType.BAR_NAME_19];
		public const toolVector:Vector.<String> = new <String>[ToolBoxType.BAR_NAME_21, ToolBoxType.BAR_NAME_22, ToolBoxType.BAR_NAME_23, ToolBoxType.BAR_NAME_24];
		public const uiVector:Vector.<String> = new <String>[ToolBoxType.BAR_NAME_25, ToolBoxType.BAR_NAME_26, ToolBoxType.BAR_NAME_29,
			ToolBoxType.BAR_NAME_31, ToolBoxType.BAR_NAME_32];
		public const ranVector:Vector.<String> = new <String>[];
		public const helpVector:Vector.<String> = new <String>[ToolBoxType.BAR_NAME_33, ToolBoxType.BAR_NAME_34]
		
		public function PopMenuBar()
		{
			init();
		}

		
		private function init():void
		{
			this.myWidth = 100;
			/*this.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOut);
			this.addEventListener(MouseEvent.CLICK, onMouseClick);*/
		}
		
		private function onMouseRollOut(e:MouseEvent):void
		{
			hideMenu();
		}
		private function onMouseClick(e:MouseEvent):void
		{
			if(!(e.target is MyTextField)) return;
			hideMenu();
			if(selectCallBack != null) selectCallBack(int(e.target.name));
		}
		
		/**
		 * 设置菜单显示
		 * @param menuVec	: 菜单列表
		 */		
		public function set menu(menuVec:Vector.<String>):void
		{
			//清除所有选择
			clearSelect();
			//添加选择项
			var index:int = 0;
			var len:int = menuVec.length;
			var textField:MyTextButton
			while(len--)
			{
				textField = new MyTextButton();
				this.addChild(textField);
				textField.setColor([0xCCCCCC, 0x999999, 0x666666, 0x0, 0x333333]);
				textField.size = 12;
				textField.algin = "center";
				textField.text = menuVec[index];
				textField.width = this.myWidth;
				textField.height = textField.textHeight+4;
				textField.name = menuVec[index];
				textField.selectable = false;
				textField.x = (this.myWidth - textField.width)/2;
				textField.y = 5 + (textField.height+2)*index;
				index++;
			}
			this.visible = true;
			var vh:int = 100;
			if(textField )
			{
				vh = (textField.height+2)*index+10
			}
			//绘制背景
			this.drawRect(this.myWidth, vh, 0x424242);
			//边框线
			Tool.drawReacLineByGraphics(this.graphics, null, this.myWidth, this.height, 1, 1, 0x0, 0, 0, false);
			if(menuVec == fillVector)
			{
				this.x = 75;
			}	else if(menuVec == toolVector) {
				this.x = 160;
			}	else if(menuVec == uiVector) {
				this.x = 245;
			}	else if(menuVec == ranVector) {
				this.x = 330;
			}	else if(menuVec == helpVector) {
				this.x = 415
			}
			this.y = 32;
		}
		
		public function showMenu():void  
		{  
			this.visible = true;  
			if(this.parent)
				this.parent.setChildIndex(this, this.parent.numChildren-1);
		}
		public function hideMenu():void  {  this.parent.removeChild(this) }
		
		/** 清除选项文本 **/
		private function clearSelect():void
		{
			var numChild:int = this.numChildren;
			var child:MyTextButton;
			while(numChild--)
			{
				child = MyTextButton(this.removeChildAt(0));
				child.clear();
				child = null;
			}
		}
		
	}
}