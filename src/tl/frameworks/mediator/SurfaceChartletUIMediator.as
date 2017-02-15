/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.mediator
{
	import flash.display.BitmapData;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

	import org.robotlegs.mvcs.Mediator;

	import tl.core.GPUResProvider;
	import tl.frameworks.NotifyConst;
	import tl.frameworks.defines.ToolBrushType;
	import tl.frameworks.model.TLEditorMapModel;
	import tl.mapeditor.ui.common.MyDragBar;
	import tl.mapeditor.ui.window.ChartletInfo;
	import tl.mapeditor.ui.window.SurfaceChartletUI;

	import tool.StageFrame;

	/**地表贴图面板*/
	public class SurfaceChartletUIMediator extends Mediator
	{
		[Inject]
		public var view:SurfaceChartletUI
		[Inject]
		public var editorMapModel:TLEditorMapModel;
		[Inject]
		public var gpuRes:GPUResProvider;
		private var _drag:String;
		private var _sourceArr:Array = [];
		private var _dragChartlet:ChartletInfo;			//当前拖动的图层
		private var _firstX:Number;						//初始位置
		private var _firstY:Number;
		private var _canDrag:Boolean;					//可拖动标志
		//初始位置

		public function SurfaceChartletUIMediator()
		{
			super();
		}

		override public function onRegister():void
		{
			super.onRegister();

			eventMap.mapListener(view.stage,KeyboardEvent.KEY_DOWN, onKeyDown);
			eventMap.mapListener(view.stage,KeyboardEvent.KEY_UP, onKeyUp);
			view.init("地表贴图面板", 425, 440);
			view.x = StageFrame.stage.stageWidth - view.myWidth >> 1;
			view.y = StageFrame.stage.stageHeight - view.myHeight >> 1;

			var positionArr:Array = [editorMapModel.brushSize, editorMapModel.brushSplatPower, editorMapModel.brushSoftness]
			for (var i:int = 0; i < 6; i++)
			{
				if(i<3)
				{
					view.vectorDragBar[i].addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					view.vectorDragBar[i].dragSprX = positionArr[i];
					view.vectorTxt[i].text = view.vectorDragBar[i].dragBarPercent + '';
				}
				view.vectorChartlet[i].addEventListener(MouseEvent.MOUSE_DOWN, onChartletMouseDown)
				view.vectorChartlet[i].addEventListener(MouseEvent.MOUSE_UP, onChartletMouseUp)
			}
			eventMap.mapListener(view.stage, MouseEvent.MOUSE_UP, onMouseUp);
			if(editorMapModel.mapVO)
			{
				dispatchWith(NotifyConst.TOOL_BRUSH, false,ToolBrushType.BRUSH_TYPE_TERRAINTEXTURE);
				validatePickedList();
			}	else {

				// 土地，石头，青草，耕地，砖
				var arr:Array = ['db_107_01', 'db_107_shitou01', 'db_607_caodi02', 'db_107_a03', 'db_107_a01'];
				for(var i:int=0; i<5; i++)
				{
					gpuRes.getTerrainTexturePreview(arr[i],onAssetLoaded);
				}
			}
			//
			addContextListener(NotifyConst.MAP_VO_INITED,onMapVOInited);
		}

		private function onMapVOInited( n: * ):void
		{
			//地图数据就绪了
			validatePickedList();
		}
		private function validatePickedList():void
		{
			_sourceArr = [];
			// 土地，石头，青草，耕地，砖
			for(var i:int=0; i<5; i++)
			{
				gpuRes.getTerrainTexturePreview(editorMapModel.mapVO.textureFiles[i],onAssetLoaded);
			}
		}

		private function onAssetLoaded(name:String, bmd:BitmapData):void
		{
			_sourceArr.push([name, bmd]);
			if(_sourceArr.length == 5)
			{
				//资源收集完毕
				view.showMapChartlet(_sourceArr)
			}
		}
		override public function onRemove():void
		{
			//移除界面的时候派发
			super.onRemove();
			if(editorMapModel.mapVO)
			{
				dispatchWith(NotifyConst.TOOL_SELECT, false);
			}
		}

		private function onMouseDown(event:MouseEvent):void
		{
			var drag:MyDragBar = event.currentTarget as MyDragBar;
			drag.onMouseDown(event);
			_drag = drag.name;
		}

		private function onChartletMouseDown(event:MouseEvent):void
		{
			var chartlet:ChartletInfo = event.currentTarget as ChartletInfo;
			if(chartlet.chartletName && _canDrag)
			{
				//拖动图层的时候
				_dragChartlet = chartlet;
				chartlet.parent.setChildIndex(chartlet, chartlet.parent.numChildren-1)
				_firstX = _dragChartlet.x;
				_firstY = _dragChartlet.y;
				chartlet.startDrag(true, view.dragRect)
			}
		}

		private function onChartletMouseUp(event:MouseEvent):void
		{
			var chartlet:ChartletInfo = event.currentTarget as ChartletInfo;
			if(chartlet.chartletName)
			{
				//editorMapModel.setLayerTexture(chartlet.chartletName, chartlet.chartletId)
				if(chartlet.chartletId > 0)
				{
					//设置刷子材质
					editorMapModel.curTextureBrushLayerIndex = chartlet.chartletId;
				}
			}
		}

		public function onMouseUp(event:MouseEvent):void
		{
			if(_dragChartlet)
			{
				//交换图层材质
				if(_dragChartlet.chartletName)
				{
					_dragChartlet.stopDrag();
					if(_firstX != _dragChartlet.x || _firstY != _dragChartlet.y)
					{
						var index:int;
						var vx:int = _dragChartlet.x - 70;
						var vy:int = _dragChartlet.y - 70;
						var isChange:Boolean = vy < 60 ? false : true;
						if(vx < 60)
						{
							if(isChange)
							{
								index = 3;
							}	else {
								index = 0;
							}
						}	else if(vx < 190) {
							if(isChange)
							{
								index = 4;
							}	else {
								index = 1;
							}
						}	else {
							if(isChange)
							{
								index = 4;
							}	else {
								index = 2;
							}
						}
						var childIndex:int = view.vectorChartlet.indexOf(_dragChartlet);
						if(childIndex != index)
						{
							var chartlet:ChartletInfo = view.vectorChartlet[index];
							view.vectorChartlet[index] = _dragChartlet;
							view.vectorChartlet[childIndex] = chartlet;
							if(editorMapModel.mapVO)
								editorMapModel.setLayerIndex(index, childIndex, true)
						}
						for(var i:int=0; i<6; i++)
						{
							view.vectorChartlet[i].x = i % 3 * 130 + 70 ;
							view.vectorChartlet[i].y = int(i / 3) * 130 + 70;
							view.vectorChartlet[i].updateIndex(i);
						}
					}
				}	else {
					if(!_dragChartlet.chartletName)
					{
					}
				}
			}	else  if(_drag) {
				//设定刷子数据
				for (var i:int = 0; i < 3; i++)
				{
					view.vectorDragBar[i].onMouseUp(event);
					view.vectorTxt[i].text = view.vectorDragBar[i].dragBarPercent + '';
				}
				if(_drag == 'drageBar_0')
				{
					dispatchWith(NotifyConst.TOOL_BRUSH_QIANGDU, false, view.vectorDragBar[0].dragBarPercent);
				} 	else if(_drag == 'drageBar_1') {
					dispatchWith(NotifyConst.TOOL_BRUSH_SIZE, false, view.vectorDragBar[1].dragBarPercent);
				} 	else if(_drag == 'drageBar_2') {
					dispatchWith(NotifyConst.TOOL_BRUSH_ROUHE, false, view.vectorDragBar[2].dragBarPercent);
				}
			}
			_drag = null;
			_dragChartlet = null;
		}

		private function onKeyUp(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.CONTROL:
					_canDrag = false;
					break;
			}
		}

		private function onKeyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.CONTROL:
					_canDrag = true;
					break;
			}
		}
	}
}
