/**
 * Created by Administrator on 2017/2/14.
 */
package tl.mapeditor.ui.window
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import tl.mapeditor.ui.common.MyButton;

	import tl.mapeditor.ui.common.MySprite;
	import tl.mapeditor.ui.common.MyTextField;
	import tl.utils.Tool;

	/**贴图显示信息*/
	public class ChartletInfo extends MySprite
	{
		public var chartletId:int;
		public var chartletName:String;
		public var clearBtn:MyButton;
		public var changeBtn:MyButton;
		private var _infoTxt:MyTextField;
		private var _bg:Bitmap;
		private var _nameTxt:MyTextField;
		public function ChartletInfo()
		{
			super();
		}

		public function init(id:int):void
		{
			chartletId = id;
			var bmd:BitmapData = new Skin_Add();
			_bg = new Bitmap(bmd);
			this.addChild(_bg)
			_bg.width = 120;
			_bg.height = 120;
			_bg.x = -60;
			_bg.y = -60;
			_nameTxt = Tool.getMyTextField(120, -1, 14, 0xFFFF00, "center");
			_nameTxt.mouseEnabled = _nameTxt.mouseWheelEnabled = false;
			this.addChild(_nameTxt);
			_nameTxt.y = -50;
			_nameTxt.x = -60;

			_infoTxt = Tool.getMyTextField(120, -1, 14, 0xFFFF00, "center");
			_infoTxt.mouseEnabled = _infoTxt.mouseWheelEnabled = false;
			this.addChild(_infoTxt);
			_infoTxt.y = -30;
			_infoTxt.x = -60;
		}

		public function createBtn():void
		{
			changeBtn = Tool.getMyBtn('更换贴图', 60);
			this.addChild(changeBtn);
			changeBtn.x = -60;
			changeBtn.y = 37;

			clearBtn = Tool.getMyBtn('取消贴图', 60);
			this.addChild(clearBtn);
			clearBtn.x = 0;
			clearBtn.y = 37;
			changeBtn.name = '' + chartletId;
			clearBtn.name = '' + chartletId;
		}
		public function updateIndex(id:int):void
		{
			if(chartletName)
			{
				chartletId = id;
				_nameTxt.text = '图层' + (chartletId + 1);
			}
			changeBtn.name = '' + chartletId;
			clearBtn.name = '' + chartletId;
		}

		public function showBgInfo(name:String, bmd:BitmapData):void
		{
			chartletName = name;
			_nameTxt.text = '图层' + (chartletId + 1);
			if(bmd)
			{
				_infoTxt.text = bmd.width + '*' + bmd.height;
				_bg.bitmapData = bmd;
				_bg.visible = true;
				_bg.width = 120;
				_bg.height = 120;
			}	else {
				_bg.visible = false;
				_infoTxt.text = '没有贴图'
			}

		}
	}
}
