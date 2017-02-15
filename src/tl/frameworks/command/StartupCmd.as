/**
 * Created by gaord on 2017/2/7.
 */
package tl.frameworks.command
{
	import away3d.containers.View3D;

	import org.robotlegs.mvcs.Command;

	import tl.core.GPUResProvider;
	import tl.frameworks.mediator.BrushSettingUIMediator;
	import tl.frameworks.mediator.CoveragePanelUIMediator;
	import tl.frameworks.mediator.CreateFileUIMediator;
	import tl.frameworks.mediator.FunctionPointUIMediator;
	import tl.frameworks.mediator.HelpUIMediator;
	import tl.frameworks.mediator.LogUIMediator;
	import tl.frameworks.mediator.PopMenuBarMediator;
	import tl.frameworks.mediator.PreviewView3DMediator;
	import tl.frameworks.mediator.PropertyPanelUIMediator;
	import tl.frameworks.mediator.SurfaceChartletUIMediator;
	import tl.frameworks.mediator.ThumbnailUIMediator;
	import tl.frameworks.mediator.ZoneSettingUIMediator;
	import tl.frameworks.model.LogModel;

	import tl.frameworks.model.TLEditorMapModel;
	import tl.frameworks.NotifyConst;
	import tl.frameworks.mediator.EditorScene3DMediator;
	import tl.frameworks.mediator.EditorUIMediator;
	import tl.frameworks.mediator.PreviewScene3DMediator;
	import tl.frameworks.mediator.StatusBarMediator;
	import tl.frameworks.mediator.TerrainTextureBarMediator;
	import tl.frameworks.mediator.ToolbarMediator;
	import tl.frameworks.mediator.OperationBarMediator;
	import tl.frameworks.mediator.WizardBarMediator;
	import tl.frameworks.model.CSV.SGCsvManager;
	import tl.frameworks.model.TerrainTextureListModel;
	import tl.frameworks.service.TLEditorMapService;
	import tl.mapeditor.scenes.EditorScene3D;
	import tl.mapeditor.scenes.PreviewScene3D;
	import tl.mapeditor.ui.CreateFileUI;
	import tl.mapeditor.ui.EditorUI;
	import tl.mapeditor.ui.OperationBar;
	import tl.mapeditor.ui.PopMenuBar;
	import tl.mapeditor.ui.Toolbar;
	import tl.mapeditor.ui.window.BrushSettingUI;
	import tl.mapeditor.ui.window.CoveragePanelUI;
	import tl.mapeditor.ui.window.FunctionPointUI;
	import tl.mapeditor.ui.window.HelpUI;
	import tl.mapeditor.ui.window.LogUI;
	import tl.mapeditor.ui.window.PropertyPanelUI;
	import tl.mapeditor.ui.window.SurfaceChartletUI;
	import tl.mapeditor.ui.window.ThumbnailUI;
	import tl.mapeditor.ui.window.ZoneSettingUI;

	public class StartupCmd extends Command
	{
		public function StartupCmd()
		{
			super();
		}

		override public function execute():void
		{
			// model
			injector.mapSingleton(TLEditorMapModel);
			injector.mapSingleton(TerrainTextureListModel);
			injector.mapSingleton(LogModel);
			injector.mapValue(SGCsvManager,SGCsvManager.getInstance());// SGCsvManager暂时改不掉，牵扯太多
			injector.mapValue(GPUResProvider,GPUResProvider.getInstance());
			// service
			injector.mapSingleton(TLEditorMapService);

			// map command
			commandMap.mapEvent(NotifyConst.NEW_MAP_UI, NewMapUICmd);
			commandMap.mapEvent(NotifyConst.NEW_MAP, NewTerrainCmd);
			commandMap.mapEvent(NotifyConst.LOAD_MAP, LoadMapCmd);
			commandMap.mapEvent(NotifyConst.SAVE_MAP, SaveMapCmd);
			commandMap.mapEvent(NotifyConst.NEW_THUMBNAIL_UI, ThumbnailUICmd);
			commandMap.mapEvent(NotifyConst.NEW_COVERAGEPANEL_UI, CoveragePanelCmd);
			commandMap.mapEvent(NotifyConst.NEW_PROPERTYPANEL_UI, PropertyPanelCmd);
			commandMap.mapEvent(NotifyConst.NEW_BRUSHSETTING_UI, BrushSettingUICmd);
			commandMap.mapEvent(NotifyConst.NEW_FUNCTIONPOINT_UI, FunctionPointUICmd);
			commandMap.mapEvent(NotifyConst.NEW_ZONESETTING_UI, ZoneSettingUICmd);
			commandMap.mapEvent(NotifyConst.NEW_SURFACECHARTLET_UI, SurfaceChartletUICmd);
			commandMap.mapEvent(NotifyConst.NEW_LONG_UI, LogUICmd);
			commandMap.mapEvent(NotifyConst.NEW_HELP_UI, HelpUICmd);
			commandMap.mapEvent(NotifyConst.STATUS, LogCmd);

			// map view mediator
			mediatorMap.mapView(EditorUI, EditorUIMediator);
			mediatorMap.mapView(Toolbar, ToolbarMediator);
			mediatorMap.mapView(StatusBar, StatusBarMediator);
			mediatorMap.mapView(TerrainTextureBar, TerrainTextureBarMediator);
			mediatorMap.mapView(WizardBar, WizardBarMediator);
			mediatorMap.mapView(OperationBar, OperationBarMediator);
			mediatorMap.mapView(PopMenuBar, PopMenuBarMediator);
			mediatorMap.mapView(CreateFileUI, CreateFileUIMediator);
			mediatorMap.mapView(CoveragePanelUI, CoveragePanelUIMediator);
			mediatorMap.mapView(ThumbnailUI, ThumbnailUIMediator);
			mediatorMap.mapView(PropertyPanelUI, PropertyPanelUIMediator);
			mediatorMap.mapView(BrushSettingUI, BrushSettingUIMediator);
			mediatorMap.mapView(FunctionPointUI, FunctionPointUIMediator);
			mediatorMap.mapView(ZoneSettingUI, ZoneSettingUIMediator);
			mediatorMap.mapView(SurfaceChartletUI, SurfaceChartletUIMediator);
			mediatorMap.mapView(LogUI, LogUIMediator);
			mediatorMap.mapView(HelpUI, HelpUIMediator);

			// map view Mediator 3D (3D的目前尚未实现自动addChild绑定，所以需要手动createMediator)
			mediatorMap.mapView(EditorScene3D , EditorScene3DMediator,null,false,false);
			mediatorMap.mapView(PreviewScene3D , PreviewScene3DMediator,null,false,false);
			mediatorMap.mapView(View3D, PreviewView3DMediator,null,false,false);

			//
			commandMap.execute(LoadCsvCmd);
			commandMap.execute(InitEditorUICmd);
			commandMap.execute(LoadTerrainTextureListCmd);


		}
	}
}
