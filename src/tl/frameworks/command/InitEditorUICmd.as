/**
 * Created by gaord on 2016/12/13.
 */
package tl.frameworks.command
{
	import org.robotlegs.mvcs.Command;

	import tl.mapeditor.ui.DebugHeightMap;
	import tl.mapeditor.ui.EditorUI;

	import tool.DebugHelper;

	public class InitEditorUICmd extends Command
	{
		public function InitEditorUICmd()
		{
		}


		public override function execute():void
		{
			var ui :EditorUI = new EditorUI();
			contextView.addChild(ui);
			contextView.addChild(DebugHeightMap.getInstance());

			DebugHelper.setView3D(TLMapEditor.view3D);
		}
	}
}
