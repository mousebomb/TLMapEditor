package HLib.UICom.Component
{
	import flash.text.TextFormat;
	
	import HLib.UICom.BaseClass.HXYSprite;
	
	import Modules.Common.HAssetsManager;
	import Modules.Common.HCss;
	import Modules.Common.SourceTypeEvent;
	import Modules.MainFace.MainInterfaceManage;
	import Modules.SFeather.SFTextField;
	
	import feathers.display.Scale9Image;
	
	import starling.display.Image;
	
	public class HLuckProgressBarTip2 extends HXYSprite
	{
		private var nameTxt:SFTextField;
		private var contentTxt:SFTextField;
		private var needConditionTxt:SFTextField;
		public var bg:Scale9Image;
		public var line0:Image;
		public var line1:Image;
		
		public function HLuckProgressBarTip2()
		{
			myHeight = 268;
			init();
		}
		
		private function init():void
		{
			bg = new Scale9Image(MainInterfaceManage.getInstance().tips_scale9Textures);
			bg.touchable = true;
			bg.width = 294;
			bg.height = 80;
			this.addChild(bg);
			this.myWidth = 220;
			
			line0 = new Image(HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE,"background/tips_line"));
			line0.touchable = false;
			line0.width = bg.width;
			line0.height = 2;
			line0.x = 0;
			line0.y = 38;
			bg.addChild(line0);
			
			line1 = new Image(HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE,"background/tips_line"));
			line1.touchable = false;
			line1.width = bg.width;
			line1.height = 2;
			line1.x = 0;
			line1.y = 38;
			bg.addChild(line1);
			
			var format:TextFormat = new TextFormat();
			format.letterSpacing = 3;
			format.leading = 4;
			nameTxt = new SFTextField();
			addChild(nameTxt);
			nameTxt.format = format;
			nameTxt.bold = true;
			//			nameTxt.needSide = false;
			nameTxt.y = 8;
			//			Tool.setDisplayGlowFilter(nameTxt.htext, 0xff7800, 0.8, 7, 7);
			
			format = new TextFormat();
			format.letterSpacing = 2;
			format.leading = 5;
			contentTxt = new SFTextField();
			contentTxt.bold = true;
			contentTxt.format = format;
			addChild(contentTxt);
			contentTxt.y = 47;
			contentTxt.x = 23;
			
			format.letterSpacing = 2;
			format.leading = 5;
			needConditionTxt = new SFTextField();
			needConditionTxt.bold = true;
			needConditionTxt.format = format;
			addChild(needConditionTxt);
			needConditionTxt.y = 47;
			needConditionTxt.x = contentTxt.x;
		}
		
		public function setData(vo:Object):void
		{
			if(vo.checkExp>0){
				nameTxt.label = "#fff21b16图鉴卡经验：" + "#e506ff16" + (vo.checkExp+vo.nowProgress)+"/"+vo.maxNum;
			}else
			{
				nameTxt.label = "#fff21b16当前经验值：" + "#e506ff16" +  vo.nowProgress;
			}
//			nameTxt.label = "#fff21b16已选取图鉴卡经验：" + "#e506ff16" +  vo.nowProgress;
			var str:String = "#d3af7913升级条件\n" + HCss.GeneralColor1 + 13 + "本次升级需要图鉴经验 : " + HCss.GeneralColor2 + 13 + vo.maxNum;
			var msg:String = "#d3af7913什么是图鉴经验?\n" + HCss.GeneralColor1 + 13 + "1、每张图鉴根据品质和图鉴等级具有\n不同的图鉴经验\n2、升级图鉴时会直接消耗其他图鉴来\n获得图鉴经验";
			contentTxt.label = str;
			nameTxt.x = bg.width - nameTxt.textWidth >> 1;
			line1.y = contentTxt.y + contentTxt.textHeight;
			
			needConditionTxt.label = msg;
			needConditionTxt.y = line1.y + line1.height + 3;
			
			bg.height = needConditionTxt.y + needConditionTxt.textHeight + 5;
		}
	}
}


