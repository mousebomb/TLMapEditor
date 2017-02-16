/**
 * Created by Administrator on 2017/2/15.
 */
package tl.mapeditor.ui.window
{
	import fl.controls.ScrollBar;

	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;

	import tl.mapeditor.ui.common.MyButton;
	import tl.mapeditor.ui.common.MyPageButton;
	import tl.mapeditor.ui.common.MySelectLineVC;
	import tl.mapeditor.ui.common.MySprite;
	import tl.mapeditor.ui.common.MyTextField;
	import tl.mapeditor.ui.common.MyTitleView;

	import tl.mapeditor.ui.common.UIBase;
	import tl.utils.Tool;

	public class WizardBarUI extends UIBase
	{
		private var _viewWidth:int = 240;
		private var _viewHeight:int = 200;
		public var modelTypeText:MyTextField;
		public var selectBtn:MyButton;				//选择按钮
		public var modelSprite:MySprite;			//模型表格
		public var modelPageBtn:MyPageButton;		//切页按钮
		public var modelListVC:MySelectLineVC;
		public var moveUI:Function;					//移动UI回调
		public var modelIdText:MyTextField;
		public var searchBtn:MyButton;				//查找按钮
		public var onSelectModelCallBack:Function;	//模型选择回调函数
		private const _showNum:int = 13;
		//模型id
		//模型数据
		public function WizardBarUI()
		{
		}

		override public function init(title:String, $width:int = 100, $height:int = 100, bgColor:uint = 0x2F2E2E, hasCloseBtn:Boolean = true, isDrag:Boolean = true):void
		{
			if(this.isInit) return;
			this.isInit = true;
			super.init(title, $width, $height, bgColor, hasCloseBtn);//, false);

			//挖坑
			_graphics.clear();
			_graphics.beginFill(0x2F2E2E);
			_graphics.drawRect(0, 0, $width, $height);
			_graphics.drawRect(10, titleY+10, _viewWidth, _viewHeight);	//挖空
			_graphics.endFill();
			//绘制渐变线
			var matr:Matrix = new Matrix();
			matr.createGradientBox(this.myWidth, 40, Math.PI/2, 0, 0);
			_graphics.beginGradientFill(GradientType.LINEAR, [0x4F4F4F, 0x2F2E2E], [100, 30], [0, 100], matr);
			_graphics.drawRect(0, 0, this.myWidth, 30);
			_graphics.endFill();

			//十字按钮
			var skinArr:Array = [
				new Skin_PageButton_L_Up(),
				new Skin_PageButton_L_Over(),
				new Skin_PageButton_L_Down(),
				new Skin_PageButton_L_Disabled()
			];

			var btnW:int = skinArr[0].width;
			var btnH:int = skinArr[0].height;
			var xLocation:Vector.<uint> = Vector.<uint>([ 15, 245 ]);
			var yLocation:Vector.<uint> = Vector.<uint>([ 125, 140 ]);
			var nameVec:Vector.<String> = Vector.<String>([ "left", "right" ]);
			var button:MyButton;
			var typeIndex:int;
			for(var i:int = 0; i < 2; i++)
			{
				button = Tool.getMyBtn("", btnW, btnH, skinArr[0], skinArr[1], skinArr[2], skinArr[3]);
				this.addChild(button);
				button.name = nameVec[i];
				button.x = xLocation[i];
				button.y = yLocation[i];
				//旋转按钮
				button.rotationZ = (i==0 ? 0 : -180);
			}

			//选择类型显示
			var textField:MyTextField = Tool.getTitleText("类型:");
			this.addChild(textField);
			textField.x = 10;
			textField.y = titleY + _viewHeight + 20;
			//显示文本
			modelTypeText = Tool.getInputText(150, 16);
			this.addChild(modelTypeText);
			modelTypeText.algin = "center";
			modelTypeText.name = "ModelTypeText";
			modelTypeText.x = textField.x + textField.width + 2;
			modelTypeText.y = textField.y + (textField.height - modelTypeText.height)/2;
			modelTypeText.mouseEnabled = modelTypeText.mouseWheelEnabled = false;
			//选择类型按钮
			var btnUpBtmd:BitmapData 	= new Skin_Button_Select();			//普通按钮
			var btnOverBtmd:BitmapData 	= new Skin_Button_Over();
			var btnDownBtmd:BitmapData 	= new Skin_Button_Down();
			selectBtn = Tool.getMyBtn("选择", 50, 20, btnUpBtmd, btnOverBtmd, btnDownBtmd);
			this.addChild(selectBtn);
			selectBtn.name = "SelectBtn";
			selectBtn.x = modelTypeText.x + modelTypeText.width + 5;
			selectBtn.y = modelTypeText.y + (modelTypeText.height - selectBtn.height)/2;

			textField  = Tool.getTitleText(" ID :");
			this.addChild(textField);
			textField.x = 10;
			textField.y = titleY + _viewHeight + 40;

			modelIdText = Tool.getInputText(150, 16);
			this.addChild(modelIdText);
			modelIdText.algin = "center";
			modelIdText.name = "modelIdText";
			modelIdText.restrict = "0-9";
			modelIdText.type = "input";
			modelIdText.tabEnabled = false;
			modelIdText.x = textField.x + textField.width + 2;
			modelIdText.y = textField.y + (textField.height - modelIdText.height)/2;
			//modelIdText.mouseEnabled = modelTypeText.mouseWheelEnabled = false;
			searchBtn = Tool.getMyBtn("查找", 50, 20, btnUpBtmd, btnOverBtmd, btnDownBtmd);
			this.addChild(searchBtn);
			searchBtn.name = "searchBtn";
			searchBtn.x = modelIdText.x + modelIdText.width + 5;
			searchBtn.y = modelIdText.y + (modelIdText.height - modelIdText.height)/2;

			//模型表
			modelSprite = new MySprite();
			this.addChild(modelSprite);
			Tool.drawRectByGraphics(modelSprite.graphics, null, _viewWidth, 16*(_showNum+1)+2, 0x191818, 1, 0, 0, 1, 0x3D3D3D);
			modelSprite.x = (this.myWidth - modelSprite.width)/2;
			modelSprite.y = textField.y + textField.height + 8;
			//绑定模型列表标题
			var sizeArr:Array = [30, 40, 164];
			var titleView:MyTitleView = new MyTitleView();
			modelSprite.addChild(titleView);
			titleView.init(sizeArr, ["选择", "ID", "模型名"]);
			titleView.y = 1;
			//骨骼显示列表
			modelListVC = new MySelectLineVC();
			modelSprite.addChild(modelListVC);
			modelListVC.init(sizeArr, _showNum);
			modelListVC.isSelectFirst = true;	//开启默认选择第一个
			modelListVC.y = titleView.y + titleView.myHeight;
			modelListVC.selectCallBack = onSelectModelCallBack;
			modelListVC.setData(null);	//初始化时清空所有数据
			//切页按钮
			modelPageBtn = new MyPageButton();
			modelPageBtn.setDefaultSkin();
			modelPageBtn.init();
			modelPageBtn.isCanInput = true;
			modelPageBtn.name = "ChangeModelPage";
			this.addChild(modelPageBtn);
			modelPageBtn.x = modelSprite.x + (modelSprite.width - modelPageBtn.myWidth)/2;
			modelPageBtn.y = modelSprite.y + modelSprite.height + 5;
		}

		override protected function onMouseUp(e:MouseEvent):void
		{
			super.onMouseUp(e);
			if(moveUI)
				moveUI();
		}
	}
}
