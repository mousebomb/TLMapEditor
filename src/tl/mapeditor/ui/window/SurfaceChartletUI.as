/**
 * Created by Administrator on 2017/2/10.
 */
package tl.mapeditor.ui.window
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	import tl.core.terrain.TLTileVO;
	import tl.mapeditor.ui.common.MyButton;

	import tl.mapeditor.ui.common.MyDragBar;
	import tl.mapeditor.ui.common.MySprite;

	import tl.mapeditor.ui.common.MyTextField;

	import tl.mapeditor.ui.common.UIBase;
	import tl.utils.Tool;

	/**地表贴图面板*/
	public class SurfaceChartletUI extends UIBase
	{
		public var vectorTxt:Vector.<MyTextField> ;
		public var vectorDragBar:Vector.<MyDragBar> ;
		public var vectorChartlet:Vector.<ChartletInfo> ;
		private var _rootSpr:MySprite;
		private var _isLoad:Boolean;
		public const dragRect:Rectangle = new Rectangle(70, 70, 260, 130);
		public var showBtn:MyButton;
		public var hideBtn:MyButton;
		public function SurfaceChartletUI()
		{
			super();
		}

		override public function init(title:String, $width:int = 100, $height:int = 100, bgColor:uint = 0x2F2E2E, hasCloseBtn:Boolean = true, isDrag:Boolean = true):void
		{
			if(this.isInit) return;
			this.isInit = true;
			super.init(title, $width, $height, bgColor, hasCloseBtn, isDrag);


			var bgSpr:MySprite = new MySprite();
			this.addChild(bgSpr);
			Tool.drawRectByGraphics(bgSpr.graphics, null, 400, 270, 0x191818, 1, 0, 0, 1, 0x3D3D3D);
			bgSpr.x = 12.5;
			bgSpr.y = titleY;

			var info:ChartletInfo ;
			vectorChartlet = new <ChartletInfo>[]
			for (var i:int = 0; i < 6; i++)
			{
				info = new ChartletInfo();
				info.init(i);
				bgSpr.addChild(info);
				info.x = i % 3 * 130 + 70 ;
				info.y = int(i / 3) * 130 + 70;
				vectorChartlet.push(info);
			}

			_rootSpr = new MySprite();
			this.addChild(_rootSpr);
			_rootSpr.y = 320 + titleY;

			text = Tool.getMyTextField(400, -1, 16, 0x999999, "center");
			text.text = '+Ctrl键可调整图层顺序';
			text.mouseEnabled = text.mouseWheelEnabled = false;
			_rootSpr.addChild(text);
			text.y = -40 ;
			text.x = 12.5;

			var text:MyTextField;
			var dragBar:MyDragBar;
			vectorTxt = new <MyTextField>[];
			vectorDragBar = new <MyDragBar>[];
			var labelArr:Array = ['笔刷大小', '笔刷强度', '柔和', 300, 1, 1];
			for (var i:int=0; i<3; i++)
			{
				text = Tool.getMyTextField(70, -1, 12, 0x999999, "center");
				text.background = true;
				text.backgroundColor = 0x191919;
				text.border = true;
				text.borderColor = 0x3D3D3D;
				text.text = labelArr[i];
				text.mouseEnabled = text.mouseWheelEnabled = false;
				_rootSpr.addChild(text);
				text.y = 36 * i ;
				text.x = 5;

				dragBar = new MyDragBar();
				_rootSpr.addChild(dragBar);
				dragBar.name = 'SurfaceChartletUI_' + i;
				dragBar.maxValue = labelArr[i + 3]
				dragBar.y = 36 * i;
				dragBar.x = 80;
				vectorDragBar.push(dragBar);

				text = Tool.getMyTextField(50, -1, 12, 0x999999, "center");
				text.background = true;
				text.backgroundColor = 0x191919;
				text.border = true;
				text.borderColor = 0x3D3D3D;
				text.text = dragBar.dragBarPercent + '';
				text.mouseEnabled = text.mouseWheelEnabled = false;
				_rootSpr.addChild(text);
				text.y = 36 * i ;
				text.x = 370;
				vectorTxt.push(text)
			}

			showBtn = Tool.getMyBtn('显示贴图刷', 120);
			showBtn.name = '显示贴图刷';
			this.addChild(showBtn);
			showBtn.x = 60;
			showBtn.y = 440;

			hideBtn = Tool.getMyBtn('隐藏贴图刷', 120);
			hideBtn.name = '隐藏贴图刷';
			this.addChild(hideBtn);
			hideBtn.x = 240;
			hideBtn.y = 440;
		}

		override protected function onClickClose(e:MouseEvent = null):void
		{
			super.onClickClose(e);
		}
		/**显示地表贴图*/
		public function showMapChartlet(_sourceArr:Array):void
		{
			var info:ChartletInfo ;
			var leng:int = _sourceArr.length;
			 for (var i:int = 0; i < leng; i++)
			 {
				 info = vectorChartlet[i];
				 info.showBgInfo(_sourceArr[i][0], _sourceArr[i][1]);
			 }
		}
	}
}
