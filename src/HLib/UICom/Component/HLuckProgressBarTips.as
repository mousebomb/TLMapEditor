package HLib.UICom.Component
{
	import flash.text.TextFormat;
	
	import HLib.UICom.BaseClass.HXYSprite;
	
	import Modules.Common.HAssetsManager;
	import Modules.Common.HCss;
	import Modules.Common.SGCsvManager;
	import Modules.Common.SourceTypeEvent;
	import Modules.DataSources.Item;
	import Modules.MainFace.MainInterfaceManage;
	import Modules.OperatingActivities.OperateActivityManage;
	import Modules.SFeather.SFTextField;
	
	import feathers.display.Scale9Image;
	
	import starling.display.Image;
	
	public class HLuckProgressBarTips extends HXYSprite
	{
		private var nameTxt:SFTextField;
		private var contentTxt:SFTextField;
		private var needConditionTxt:SFTextField;
		public var bg:Scale9Image;
		public var line0:Image;
		public var line1:Image;
		
		public function HLuckProgressBarTips()
		{
			myHeight = 268;
			init();
		}
		
		private function init():void
		{
			bg = new Scale9Image(MainInterfaceManage.getInstance().tips_scale9Textures);
			bg.touchable = true;
			bg.width = 260;
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
			nameTxt.y = 8;
			
			format = new TextFormat();
			format.letterSpacing = 1;
			format.leading = 4;
			contentTxt = new SFTextField();
			contentTxt.bold = true;
			contentTxt.format = format;
			addChild(contentTxt);
			contentTxt.y = 47;
			contentTxt.x = 13;
			
			format.letterSpacing = 1;
			format.leading = 4;
			needConditionTxt = new SFTextField();
			needConditionTxt.bold = true;
			needConditionTxt.format = format;
			addChild(needConditionTxt);
			needConditionTxt.y = 47;
			needConditionTxt.x = contentTxt.x;
		}
		
		public function setData(vo:Object):void
		{
			var percent:Number;
			var needItemNum:int;
			nameTxt.label = "#fff21b16当前祝福值：" + "#e506ff16" +  Number(vo.nowProgress/vo.maxNum*100).toFixed(0);;
			var msg:String = "";
			msg += "#d3af7913什么是祝福值：\n" + HCss.GeneralColor1 + 13 + "  祝福值越高就越接近成功。\n  祝福值达到100时，进阶必定成功。\n\n#d3af7913祝福值清空时间：";
			if(vo.isClearCd)
				msg += HCss.GeneralColor2 + 13 +  "\n  每日05:00清空祝福值。"
			else
				msg += HCss.GeneralColor2 + 13 +  "\n  祝福值不清空。"
			contentTxt.label = msg;
			nameTxt.x = bg.width - nameTxt.textWidth >> 1;
			line1.y = contentTxt.y + contentTxt.textHeight + 5;
			
			msg = "#d3af7913本次进阶完成预计消耗材料\n";
			var obj:Object = SGCsvManager.getInstance().table_bless.FindToObject("" + vo.blessID);
			if(int(obj.NeedGold) > 0)
				msg += HCss.GeneralColor1 + 13 +"  金      币： " + HCss.GeneralColor2 + 13 + (int(obj.NeedGold) * int(obj.Times)) + "\n";
			if(int(obj.NeedMoney) > 0)
				msg += HCss.GeneralColor1 + 13 +"  魔      晶： " + (int(obj.NeedMoney) * int(obj.Times)) + "\n";
			var arr:Array = obj.NeedItems.split("|");
			if(vo.activityId)
				percent = 1 - OperateActivityManage.getIntance().activityEffDic[vo.activityId]/100;
			if(arr.length > 1)
			{
				var item:Item = new Item();
				item.RefreshItemById("" + arr[0]);
				needItemNum = int(obj.Times) * int(arr[1])
				if(vo.activityId && OperateActivityManage.getIntance().activityEffDic[vo.activityId])
					msg += HCss.GeneralColor1 + 13 +"  "+ item.Item_Name + "：" + HCss.GeneralColor2 + 13 + needItemNum + HCss.TipsColor9 + 
						13 + "(活动日-" + OperateActivityManage.getIntance().activityEffDic[vo.activityId]+ "%,"+ int(percent * needItemNum) +")" + "\n";
				else
					msg += HCss.GeneralColor1 + 13+"  " + item.Item_Name + "： " + HCss.GeneralColor2 + 13 + needItemNum + "\n";
			}
			needConditionTxt.label = msg;
			needConditionTxt.y = line1.y + line1.height + 8;
			
			bg.height = needConditionTxt.y + needConditionTxt.textHeight + 20;
		}
	}
}