/**
 * Created by gaord on 2016/12/19.
 */
package tl.frameworks.command
{
	import org.mousebomb.framework.INotifyControler;
	import org.mousebomb.framework.Notify;
	import org.robotlegs.mvcs.Command;

	import tl.frameworks.model.TerrainTextureListModel;

	public class LoadTerrainTextureListCmd extends Command
	{
		public function LoadTerrainTextureListCmd()
		{
		}
[Inject]
public var terrainTextureListModel:TerrainTextureListModel;

		override public function execute():void
		{
			terrainTextureListModel.loadList();
		}
	}
}
