/**
 * Created by gaord on 2016/12/13.
 */
package tl.mapeditor.ui
{
	import flash.display.Sprite;

	import tl.frameworks.NotifyConst;

	import tl.mapeditor.ToolBoxType;
	import tl.mapeditor.ui.window.WizardBarUI;

	import tool.StageFrame;

	public class EditorUI extends Sprite
	{
		public var toolbar:Toolbar;
		public var operation:OperationBar;
		public var wizardBar :WizardBar;
		public var wizardBarUI:WizardBarUI;
		public var terrainTextureBar :TerrainTextureBar;
		public var statusBar :StatusBar;
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
					/*wizardBar ||= new WizardBar();
					addChild(wizardBar);*/
					wizardBarUI ||= new WizardBarUI();
					if(wizardBarUI.parent)
					{
						wizardBarUI.parent.removeChild(wizardBarUI);
					}	else {
						addChild(wizardBarUI);
					}
					break;
				case ToolBoxType.TERRAIN_HEIGHT:

					break;
			}
		}
	}
}
