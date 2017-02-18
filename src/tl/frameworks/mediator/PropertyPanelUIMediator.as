/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.mediator
{
	import flash.geom.Point;

	import org.robotlegs.mvcs.Mediator;

	import tl.core.terrain.TLMapVO;

	import tl.frameworks.NotifyConst;
	import tl.frameworks.TLEvent;

	import tl.frameworks.model.TLEditorMapModel;

	import tl.mapeditor.ui.window.PropertyPanelUI;

	/**属性面板*/
	public class PropertyPanelUIMediator extends Mediator
	{
		[Inject]
		public var view:PropertyPanelUI;
		[Inject]
		public var mapMdoel: TLEditorMapModel;
		public function PropertyPanelUIMediator()
		{
			super();
		}
		override public function onRegister():void
		{
			super.onRegister();

			view.init("属性面板", 260, 180);
			view.x = 90;
			view.y = 32 + 160;

			addContextListener(NotifyConst.MAP_VO_INITED , onMapInit);
			onMapInit();
		}

		private function onMapInit(event:TLEvent=null):void
		{
			//['属性', '地图文件夹名', '地图图片前缀', '地图文件名', '地图总大小', '地图行列数量', '地图块大小', '格子数量']
			if(mapMdoel.mapVO)
			{
				var arr:Array = ['地图名字', '地图行列数量', '地图大小', '长宽缩放比例', '', '', ''];
				var textArr:Array = [mapMdoel.mapVO.name, mapMdoel.mapVO.numTileX+ '*' + mapMdoel.mapVO.numTileY,
				mapMdoel.mapVO.terrainVerticlesX + '*' + mapMdoel.mapVO.terrainVerticlesY, TLMapVO.TERRAIN_SCALE, '', '', '']
				var leng:int = arr.length;
				for(var i:int=0; i<leng; i++)
				{
					view.titleTextVec[i].text = arr[i];
					view.valueTextVec[i].text = textArr[i];
				}
			}
		}
	}
}
