/**
 * Created by gaord on 2016/12/15.
 */
package tl.frameworks.mediator
{
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;

	import fl.data.DataProvider;

	import flash.display.BitmapData;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	import org.mousebomb.framework.GlobalFacade;
	import org.mousebomb.framework.MediatorBase;
	import org.mousebomb.framework.Notify;
	import org.robotlegs.mvcs.Mediator;

	import tl.core.GPUResProvider;
	import tl.frameworks.TLEvent;

	import tl.frameworks.model.TLEditorMapModel;

	import tl.core.terrain.TLMapModel;
	import tl.core.terrain.TLMapVO;

	import tl.frameworks.NotifyConst;
	import tl.frameworks.model.TerrainTextureListModel;
	import tl.frameworks.service.bombloader.JYLoader;
	import tl.mapeditor.Config;

	import tool.StageFrame;

	public class TerrainTextureBarMediator extends Mediator
	{
		public function TerrainTextureBarMediator()
		{
			super();
		}

		[Inject]
		public var view:TerrainTextureBar;

		[Inject]
		public var mapModel:TLEditorMapModel;
		[Inject]
		public var terrainTextureListModel:TerrainTextureListModel;
		[Inject]
		public var gpuRes:GPUResProvider;


		override public function onRegister():void
		{
			//
			view.layerList.iconField = view.assetList.iconField  = null;
			view.layerList.labelField = view.assetList.labelField = "name";

			eventMap.mapListener(view.addLayerBtn,MouseEvent.CLICK, onAddClick);
			eventMap.mapListener(view.delLayerBtn,MouseEvent.CLICK, onDelClick);
			eventMap.mapListener(view.upBtn,MouseEvent.CLICK, onUpClick);
			eventMap.mapListener(view.downBtn,MouseEvent.CLICK, onDownClick);

			eventMap.mapListener(view.assetList,Event.CHANGE, onAssetChange);
			eventMap.mapListener(view.layerList,Event.CHANGE, onLayerChange);
			// 加载所有纹理
			addContextListener(NotifyConst.TERRAIN_TEXTURES_LIST_LOADED, onTERRAIN_TEXTURES_LIST_LOADED);
			dispatchWith(NotifyConst.LOAD_TERRAIN_TEXTURES_LIST);
			onTERRAIN_TEXTURES_LIST_LOADED( null );
			//
			onResize();
			eventMap.mapListener(view.stage,Event.RESIZE, onResize);
		}

		private function onLayerChange(event:Event):void
		{
			selectedAsset = (view.layerList.selectedItem);
			gpuRes.getTerrainTexturePreview(selectedAsset.name,onAssetLoaded);
		}

		// 编辑器为了能够展示在UI 方便，所以用bitmapdata，实际游戏内使用atf
		private function onAssetChange(event:Event):void
		{// 这里要改成5个材质按钮
			selectedAsset = (view.assetList.selectedItem);
			gpuRes.getTerrainTexturePreview(selectedAsset.name,onAssetLoaded);
		}

		private function onAssetLoaded(name:String, bmd:BitmapData):void
		{
			if(selectedAsset && name== selectedAsset.name)
			{
				var material:TextureMaterial = new TextureMaterial(new BitmapTexture(bmd));
				dispatchWith(NotifyConst.SELECT_TERRAIN_TEXTURE_PREVIEW, false, material);
			}
		}

		/** 当前 用户选中的材质 无论是哪个list里点的 */
		private var selectedAsset:Object;

		private function onTERRAIN_TEXTURES_LIST_LOADED(n:TLEvent):void
		{
			view.assetList.dataProvider = new DataProvider(terrainTextureListModel.list);
		}


		/** 下移一层 */
		private function onDownClick(event:MouseEvent):void
		{

		}

		/**上移一层*/
		private function onUpClick(event:MouseEvent):void
		{

		}

		/**删除当前层*/
		private function onDelClick(event:MouseEvent):void
		{
			var index : int = view.layerList.selectedIndex;
			view.layerList.dataProvider.removeItemAt(index);
			mapModel.setLayerTexture("" , TLMapVO.TEXTURES_MAX_LAYER-1-index);
		}

		/**添加层*/
		private function onAddClick(event:MouseEvent):void
		{
			// 判断是否超出最大层
			// 判断文件选择的是否重复
			for (var i:int = 0; i < view.layerList.dataProvider.length; i++)
			{
				var object:Object	 = view.layerList.dataProvider.getItemAt(i);
				if(object == selectedAsset)
				{
					trace(StageFrame.renderIdx,"TerrainTextureBarMediator/onAddClick 此材质已存在");
					dispatchWith(NotifyConst.LOG,false,"此材质已存在");
					return;
				}
			}
			// 加入
			var index : int = view.layerList.length;
			view.layerList.dataProvider.addItemAt(selectedAsset, index);
			mapModel.setLayerTexture(selectedAsset.name , TLMapVO.TEXTURES_MAX_LAYER-1-index);
		}

		private function onResize(e:* = null):void
		{
			view.y                         = 0;
			view.x                         = StageFrame.stage.stageWidth - 200;
			TLMapEditor.view3DForPreview.x = view.x + 10;
			TLMapEditor.view3DForPreview.y = view.y + 20;
			view.assetList.height          = StageFrame.stage.stageHeight - view.y - view.assetList.y;

		}


	}
}
