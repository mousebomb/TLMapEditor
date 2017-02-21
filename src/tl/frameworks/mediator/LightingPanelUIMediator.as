/**
 * Created by Administrator on 2017/2/18.
 */
package tl.frameworks.mediator
{
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.utils.setTimeout;

	import org.robotlegs.mvcs.Mediator;

	import tl.frameworks.NotifyConst;
	import tl.frameworks.model.TLEditorMapModel;

	import tl.mapeditor.ui.common.MyButton;

	import tl.mapeditor.ui.common.MyDragBar;

	import tl.mapeditor.ui.window.LightingPanelUI;

	import tool.StageFrame;

	/**灯光设置*/
	public class LightingPanelUIMediator extends Mediator
	{
		[Inject]
		public var view:LightingPanelUI;
		[Inject]
			public var mapModel: TLEditorMapModel;
		private var _isMouseDown:Boolean;
		public function LightingPanelUIMediator()
		{
			super();
		}

		override public function onRegister():void
		{
			super.onRegister();
			view.init('灯光设置', 425, 160);
			view.x = StageFrame.stage.stageWidth - view.myWidth >> 1;
			view.y = StageFrame.stage.stageHeight - view.myHeight >> 1;

			if(mapModel.mapVO)
				var positionArr:Array = [mapModel.mapVO.sunLightDirection.x, mapModel.mapVO.sunLightDirection.z, -mapModel.mapVO.sunLightDirection.y]
			else
					positionArr = [-0.2, -0.2, 0.78]
			for (var i:int = 0; i < 3; i++)
			{
				view.vectorDragBar[i].addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				view.vectorDragBar[i].addEventListener(MouseEvent.CLICK, onClickDragBar);
				if(view.vectorDragBar[i].isNegative)
				{
					view.vectorTxt[i].text = positionArr[i] + '';
					view.vectorDragBar[i].dragBarPercent = (positionArr[i] + view.vectorDragBar[i].halfValue)/view.vectorDragBar[i].maxValue;
				}
				else
				{
					view.vectorTxt[i].text = '-' + positionArr[i] ;
					view.vectorDragBar[i].dragBarPercent = positionArr[i]/view.vectorDragBar[i].maxValue;
				}
				view.vectorChageBtn[i].addEventListener(MouseEvent.MOUSE_DOWN, onChangeBtnMouseDown)
				view.vectorChageBtn[i].addEventListener(MouseEvent.MOUSE_UP, onChangeBtnMouseUp)
			}

			StageFrame.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		private function onChangeBtnMouseDown(event:MouseEvent):void
		{
			_isMouseDown = true;
			var btn:* = event.target;
			var clickName:String = String(event.currentTarget.name).substr(-1,1);
			updateInfo(btn, clickName);
		}
		private function onChangeBtnMouseUp(event:MouseEvent):void
		{
			_isMouseDown = false;
		}
		private function onMouseDown(event:MouseEvent):void
		{
			var drag:MyDragBar = event.currentTarget as MyDragBar;
			drag.onMouseDown(event);
		}

		private function updateInfo(btn:MyButton, clickName:String):void
		{
			if(!_isMouseDown) return;
			setTimeout(updateInfo, 200, btn, clickName)
			var addNum:Number = -0.01;
			var isChange:Boolean;
			if(btn.name == 'NarrowBtn' || btn.name == 'EnlargeBtn')
			{
				isChange = true;
				if(btn.name == 'EnlargeBtn')
					addNum = 0.01;

			};
			if(isChange)
			{
				var index:Number
				if(view.vectorDragBar[clickName].isNegative)
				{
					index = (view.vectorDragBar[clickName].dragBarPercent - 0.5) * view.vectorDragBar[clickName].maxValue;
					index += addNum;
					view.vectorTxt[clickName].text = index.toFixed(2);
					var percent:Number = index/view.vectorDragBar[clickName].maxValue + 0.5;
					view.vectorDragBar[clickName].dragBarPercent = percent;
				}
				else
				{
					index = view.vectorDragBar[clickName].dragBarPercent * view.vectorDragBar[clickName].maxValue ;
					index += addNum;
					if(index > 0)
						view.vectorTxt[clickName].text = '-' + index.toFixed(2)
					else
						view.vectorTxt[clickName].text = index.toFixed(2)
					view.vectorDragBar[clickName].dragBarPercent = index/view.vectorDragBar[clickName].maxValue;
				}
				onClickDragBar(null);
			}
		}
		private function onClickDragBar(event:MouseEvent):void
		{
			var v:Vector3D = new Vector3D(Number(view.vectorTxt[0].text), Number(view.vectorTxt[2].text), Number(view.vectorTxt[1].text))
			dispatchWith(NotifyConst.LIGHT_DIRECTION_SET, false, v);
		}

		public function onMouseUp(event:MouseEvent):void
		{
			for (var i:int = 0; i < 3; i++)
			{
				view.vectorDragBar[i].onMouseUp(event);
				var index:Number;
				if(view.vectorDragBar[i].isNegative)
				{
					index = view.vectorDragBar[i].dragBarPercent * view.vectorDragBar[i].maxValue - view.vectorDragBar[i].halfValue;
					view.vectorTxt[i].text = index.toFixed(2)
				}
				else
				{
					index = view.vectorDragBar[i].dragBarPercent * view.vectorDragBar[i].maxValue;
					if(index > 0)
						view.vectorTxt[i].text = '-' + index.toFixed(2)
					else
						view.vectorTxt[i].text = index.toFixed(2)
				}
			}
		}
	}
}
