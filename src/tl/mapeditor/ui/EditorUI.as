/**
 * Created by gaord on 2016/12/13.
 */
package tl.mapeditor.ui
{
	import flash.display.Sprite;

	import tl.frameworks.NotifyConst;

	import tl.mapeditor.ToolBoxType;

	import tool.StageFrame;

	public class EditorUI extends Sprite
	{
		public var toolbar:Toolbar;
		public var operation:OperationBar;
		public var wizardBar :WizardBar;
		public var terrainTextureBar :TerrainTextureBar;
		public var statusBar :StatusBar;
		public var popMenuBar:PopMenuBar;					//下拉菜单
		/** 当前显示的toolbox类型 */
		private const _type:String ;

		public function EditorUI()
		{
			toolbar = new Toolbar();
			addChild(toolbar);
			statusBar = new StatusBar();
			//addChild(statusBar);
			operation = new OperationBar();
			addChild(operation);
		}

		public function switchToolBox(type :String):void
		{
			if(type == _type) return;
			if(terrainTextureBar && terrainTextureBar.parent) {
				terrainTextureBar.parent.removeChild(terrainTextureBar);
			}
			//
			switch(type )
			{
				case ToolBoxType.TERRAIN_TEXTURE:
					terrainTextureBar||=new TerrainTextureBar();
					addChild(terrainTextureBar);
					break;
				case ToolBoxType.WIZARD_LIBRARY:
					wizardBar ||= new WizardBar();
					addChild(wizardBar);
					break;
				case ToolBoxType.TERRAIN_HEIGHT:

					break;
				case ToolBoxType.BAR_NAME_1 :
					popMenuBar ||= new PopMenuBar();
					this.parent.addChild(popMenuBar);
					popMenuBar.menu = popMenuBar.fillVector;
					break;
				case ToolBoxType.BAR_NAME_2 :
					popMenuBar ||= new PopMenuBar();
					this.parent.addChild(popMenuBar);
					popMenuBar.menu = popMenuBar.toolVector;
					break;
				case ToolBoxType.BAR_NAME_3:
					popMenuBar ||= new PopMenuBar();
					this.parent.addChild(popMenuBar);
					popMenuBar.menu = popMenuBar.uiVector;
					break;
				case ToolBoxType.BAR_NAME_4 :
					popMenuBar ||= new PopMenuBar();
					this.parent.addChild(popMenuBar);
					popMenuBar.menu = popMenuBar.ranVector;
					break;
				case ToolBoxType.BAR_NAME_5 :
					popMenuBar ||= new PopMenuBar();
					this.parent.addChild(popMenuBar);
					popMenuBar.menu = popMenuBar.helpVector;
					break;
			}
		}
	}
}
