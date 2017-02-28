/**
 * Created by Administrator on 2017/2/10.
 */
package tl.frameworks.mediator
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;

	import org.robotlegs.mvcs.Mediator;

	import tl.core.GPUResProvider;
	import tl.core.terrain.TLMapVO;
	import tl.frameworks.NotifyConst;
	import tl.frameworks.defines.ToolBrushType;
	import tl.frameworks.model.TLEditorMapModel;
	import tl.mapeditor.ui.common.MyButton;
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
		// 对应name和bitmap
		private var _sourceImgDic :Dictionary = new Dictionary();
		private var _sourceImgLoaded : int ;
		private var _dragChartlet:ChartletInfo;			//当前拖动的图层
		private var _firstX:Number;						//初始位置
		private var _firstY:Number;
		private var _canDrag:Boolean;					//可拖动标志
		private var _file:File;
		private var _fileFilter:FileFilter = new FileFilter("*.png", "*.png");
		private var _selectIndex:int  ;
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
			view.init("地表贴图面板", 425, 470);
			view.x = StageFrame.stage.stageWidth - view.myWidth;
			view.y = 32;

			var positionArr:Array = [editorMapModel.brushSize, editorMapModel.brushSplatPower, editorMapModel.brushSoftness]
			for (var i:int = 0; i < 5; i++)
			{
				if(i<3)
				{
					view.vectorDragBar[i].addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					if(view.vectorDragBar[i].isNegative)
					{
						view.vectorTxt[i].text = positionArr[i] + '';
						view.vectorDragBar[i].dragBarPercent = (positionArr[i] + view.vectorDragBar[i].halfValue)/view.vectorDragBar[i].maxValue;
					}
					else
					{
						view.vectorTxt[i].text = '' + positionArr[i] ;
						view.vectorDragBar[i].dragBarPercent = positionArr[i]/view.vectorDragBar[i].maxValue;
					}
				}
				eventMap.mapListener(view.vectorChartlet[i],MouseEvent.MOUSE_DOWN, onChartletMouseDown);
				eventMap.mapListener(view.vectorChartlet[i],MouseEvent.MOUSE_UP, onChartletMouseUp);
				eventMap.mapListener(view.vectorChartlet[i].clearBtn,MouseEvent.CLICK, onMouseClear);
				eventMap.mapListener(view.vectorChartlet[i].changeBtn,MouseEvent.CLICK, onMouseChange);
			}
			eventMap.mapListener(view.hideBtn,MouseEvent.CLICK, onClickHide);
			eventMap.mapListener(view.showBtn,MouseEvent.CLICK, onClickShow);
			eventMap.mapListener(view.stage, MouseEvent.MOUSE_UP, onMouseUp);
			if(editorMapModel.mapVO)
			{
				onClickShow(null);
				validatePickedList();
			}	else {
				// 土地，石头，青草，耕地，砖
				var arr:Array = ['db_107_01', 'db_107_shitou01', 'db_607_caodi02', 'db_107_a03', 'db_107_a01'];
				for(var i:int=0; i<5; i++)
				{
					gpuRes.getTerrainTexturePreview(arr[i],onAssetLoaded);
				}
			}
			//地图资源创建完成
			addContextListener(NotifyConst.MAP_VO_INITED,onMapVOInited);

			addContextListener(NotifyConst.CLOSE_UI, onClose);
			addContextListener(NotifyConst.CLOSE_ALL_UI, onClose);
		}

		private function onMouseChange(event:MouseEvent):void
		{
			var btn:MyButton = event.currentTarget as MyButton;
			_selectIndex = int(btn.name);
			_file = new File();
			_file.addEventListener(Event.SELECT, onSelect, false, 0, true);			//选择后派发
			_file.browseForOpen("打开地图文件", [_fileFilter]);
		}
		/** 选择完成执行 **/
		private function onSelect(e:Event):void
		{
			var url:String = _file.nativePath;
			var fileName:String = String(_file.name).split(".")[0];
			editorMapModel.setLayerTexture(fileName, _selectIndex)
			_file.removeEventListener(Event.SELECT, onSelect);

			validatePickedList();
		}

		private function onMouseClear(event:MouseEvent):void
		{
			var btn:MyButton = event.currentTarget as MyButton;
			editorMapModel.setLayerTexture('', int(btn.name))
			validatePickedList();
		}

		private function onClose(event:*):void
		{
			if(view.parent)
				view.parent.removeChild(view)
		}
		/**显示笔刷*/
		private function onClickShow(event:MouseEvent):void
		{
			if(editorMapModel.mapVO)
				dispatchWith(NotifyConst.TOOL_BRUSH, false,ToolBrushType.BRUSH_TYPE_TERRAINTEXTURE);
		}
		/**隐藏笔刷*/
		private function onClickHide(event:MouseEvent):void
		{
			if(editorMapModel.mapVO)
				dispatchWith(NotifyConst.TOOL_SELECT, false);
		}

		private function onMapVOInited( n: * ):void
		{
			//地图数据就绪了
			validatePickedList();
		}
		private function validatePickedList():void
		{
			_sourceImgLoaded = 0;
			_sourceImgDic = new Dictionary();
			// 土地，石头，青草，耕地，砖
			for(var i:int=0; i<TLMapVO.TEXTURES_MAX_LAYER; i++)
			{
				if(editorMapModel.mapVO.textureFiles.length <= i || editorMapModel.mapVO.textureFiles[i] == '')
					onAssetLoaded("",null);
				else
					gpuRes.getTerrainTexturePreview(editorMapModel.mapVO.textureFiles[i],onAssetLoaded);
			}
		}

		private function onAssetLoaded(name:String, bmd:BitmapData):void
		{
			_sourceImgDic[name] = bmd;

			if(++_sourceImgLoaded >= TLMapVO.TEXTURES_MAX_LAYER)
			{
				//资源收集完毕
				view.showMapChartlet( editorMapModel.mapVO.textureFiles ,_sourceImgDic);
			}
		}
		override public function onRemove():void
		{
			//移除界面的时候派发
			super.onRemove();
			if(editorMapModel.mapVO)
			{
				onClickHide(null);
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
			if(event.target is MyButton) return;
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
			if(event.target is MyButton) return;
			var chartlet:ChartletInfo = event.currentTarget as ChartletInfo;
			if(chartlet.chartletName)
			{
				//editorMapModel.setLayerTexture(chartlet.chartletName, chartlet.chartletId)
//				if(chartlet.chartletId > 0)
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
						for(var i:int=0; i<5; i++)
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

					var percent:Number;
					if(view.vectorDragBar[i].isNegative)
						percent = view.vectorDragBar[i].dragBarPercent * view.vectorDragBar[i].maxValue - (view.vectorDragBar[i].maxValue >> 1);
					else
						percent = view.vectorDragBar[i].dragBarPercent * view.vectorDragBar[i].maxValue;
					if(view.vectorDragBar[i].maxValue == 1)
						view.vectorTxt[i].text = percent.toFixed(2);
					else
						view.vectorTxt[i].text = percent.toFixed(0)
				}
				if(_drag == 'SurfaceChartletUI_0')
				{
					dispatchWith(NotifyConst.TOOL_BRUSH_SIZE, false, int(view.vectorTxt[0].text));
				} 	else if(_drag == 'SurfaceChartletUI_1') {
					dispatchWith(NotifyConst.TOOL_BRUSH_SPLATPOWER, false, Number(view.vectorTxt[1].text));
				} 	else if(_drag == 'SurfaceChartletUI_2') {
					dispatchWith(NotifyConst.TOOL_BRUSH_ROUHE, false, int(view.vectorTxt[2].text));
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
