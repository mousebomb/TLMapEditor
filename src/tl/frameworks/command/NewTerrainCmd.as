/**
 * Created by gaord on 2016/12/13.
 */
package tl.frameworks.command
{
	import away3d.materials.TextureMaterial;

	import flash.display.BitmapData;

	import flash.display.Loader;

	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	import org.mousebomb.framework.GlobalFacade;
	import org.mousebomb.framework.INotifyControler;
	import org.mousebomb.framework.Notify;
	import org.robotlegs.mvcs.Command;

	import tl.frameworks.model.TLEditorMapModel;

	import tl.core.terrain.TileView;

	import tl.frameworks.NotifyConst;
	import tl.frameworks.TLEvent;
	import tl.frameworks.model.vo.CreateMapVO;
	import tl.frameworks.service.TLEditorMapService;

	import tl.mapeditor.scenes.EditorScene3D;
	import tl.core.terrain.TLMapModel;
	import tl.mapeditor.ui.DebugHeightMap;

	public class NewTerrainCmd extends Command
	{
		public function NewTerrainCmd()
		{
		}

		[Inject]
		public var e:TLEvent;
		[Inject]
		public var mapModel:TLEditorMapModel;
		[Inject]
		public var mapService:TLEditorMapService;

		public override function execute():void
		{
			if(mapModel.busyLoading) return;
			var vo :CreateMapVO = e.data as CreateMapVO;
			if(vo.heightMapFile)
			{
				// 有高度图
				mapService.loadHeightMapFile( vo.heightMapFile,
				function ( bmd :BitmapData)
				{
					mapModel.setupNewTerrain(vo.mapW,vo.mapH , vo.mapName , bmd);
					DebugHeightMap.getInstance().showBitmapData(mapModel.mapVO.debugBmd);
				});
			}else{
				// 无高度图 生成平坦的
				mapModel.setupNewTerrain(vo.mapW,vo.mapH , vo.mapName);
				DebugHeightMap.getInstance().showBitmapData(mapModel.mapVO.debugBmd);
			}


		}
	}
}
