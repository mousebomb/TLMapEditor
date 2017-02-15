package HLib.UICom.Component
{
	import HLib.Tool.EffectPlayerManage;
	import HLib.UICom.BaseClass.HMovieClip;
	import HLib.UICom.BaseClass.HTopBaseView;
	
	import Modules.Common.HAssetsManager;
	import Modules.Common.HCss;
	import Modules.Common.SGCsvManager;
	import Modules.Common.SourceTypeEvent;
	import Modules.DataSources.Item;
	import Modules.MainFace.MainInterfaceManage;
	import Modules.OperatingActivities.OperateActivityManage;
	import Modules.SFeather.SFTextField;
	import Modules.view.achieve.TipsVo;
	import Modules.view.roleEquip.ItemIconTipsManage;
	
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * 带祝福值提示的进度条 
	 * @author Administrator
	 * 郑利本
	 */
	public class HLuckProgressBar extends HProgressBar
	{
		public var _textField:SFTextField;
		public var id:int ;
		public var blessID:int;
		public var activityId:int;
		public var NeedGold:int;
		public var NeedMoney:int;
		public var Times:int;
		public var isClearCd:Boolean = true;
		private var _isShowTxt:Boolean = true;
		private var _data:Object;
		public function HLuckProgressBar()
		{
			super();
		}
		
		override public function init(downTexture:Texture=null, upTexturet:Texture=null, _Width:Number=100, _Height:Number=20, min:Number=0, max:Number=100, gapX:int=0, gapY:int=0):void
		{
			isLuck = true;
			super.init(downTexture, upTexturet, _Width, _Height, min, max, gapX, gapY);
			var image:Image = new Image(HAssetsManager.getInstance().getMyTexture("mainFaceSource", "cursor"));
			this.setTempoImage(image, image.width - 8);
			_textField = new SFTextField;
			_textField.touchable = false;
			this.addChild(_textField);
			_textField.myWidth = 120;
			_textField.label = HCss.TipsColor8 + "13祝福值越高，成功率也越高";
			_textField.x = this.myWidth - _textField.textWidth >> 1;
			_textField.y = this.myHeight + 10;
			_textField.visible = _isShowTxt;
			
			addEvent();
		}
		public override function dispose():void
		{
			if(_textField)
				_textField.dispose();
			super.dispose();
		}
		
		private function addEvent():void
		{
			this.addEventListener(TouchEvent.TOUCH,touchHandle);
		}
		
		private var _isShow:Boolean;	
		private var _effect:HMovieClip;
		public var _effcetX:int;
		public var _effcetY:int;
		private var _rot:Number = 3.14;
		private var _tipsvo:TipsVo = new TipsVo;
		private function touchHandle(event:TouchEvent):void
		{
			if(!MainInterfaceManage.getInstance().isLoadUI) return;
			if(HTopBaseView.getInstance().hasEvent || HTopBaseView.getInstance().isShowFull ) return; //顶层是否添加UI了
			var touch:Touch = event.getTouch(this);
			if(touch)
			{
				if (touch.phase == TouchPhase.HOVER)
				{
					if(!_isShow&& blessID > 0) {
						_isShow = true;
						var obj:Object = new Object();
						obj.nowProgress = nowProgress;
						obj.maxNum = maxNum;
						obj.isClearCd = isClearCd;
						obj.blessID = blessID;	
						obj.activityId = activityId;
						_tipsvo.tipsWidth = 236;
						_tipsvo.tipsTitle = "#fff21b16当 前 祝 福 值：" + "#e506ff16" +  Number(obj.nowProgress/obj.maxNum*100).toFixed(0);
						if(obj.isClearCd){
							_tipsvo.tipsLabel = "#d3af7913什么是祝福值：\n" + HCss.GeneralColor1 + 13 
								+ "    祝福值越高就越接近成功。\n    祝福值达到100时，进阶必定成功。\n#d3af7913祝福值清空时间："
								+ HCss.GeneralColor2 + 13 +  "\n    每日05:00清空祝福值。";
						}else{
							_tipsvo.tipsLabel = "#d3af7913什么是祝福值：\n" + HCss.GeneralColor1 + 13 
								+ "    祝福值越高就越接近成功。\n    祝福值达到100时，进阶必定成功。\n#d3af7913祝福值清空时间："
								+ HCss.GeneralColor2 + 13 +  "\n    祝福值不清空。";
						}
						
						var GoldMoney:Object = SGCsvManager.getInstance().table_bless.FindToObject("" + obj.blessID);
						var msg:String = "";
						msg = "#d3af7913本次进阶完成预计消耗材料\n";
						if(int(GoldMoney.NeedGold) > 0)
							msg += HCss.GeneralColor1 + 13 +"    金        币： " + HCss.GeneralColor2 + 13 + (int(GoldMoney.NeedGold) * int(GoldMoney.Times)) + "\n";
						if(int(GoldMoney.NeedMoney) > 0)
							msg += HCss.GeneralColor1 + 13 +"    魔        晶： " + HCss.GeneralColor2 + 13 + (int(GoldMoney.NeedMoney) * int(GoldMoney.Times)) + "\n";
						
						var arr:Array = GoldMoney.NeedItems.split("|");
						var percent:Number;
						var needItemNum:int;
						if(obj.activityId)
							percent = 1 - OperateActivityManage.getIntance().activityEffDic[obj.activityId]/100;
						if(arr.length > 1)
						{
							var item:Item = new Item();
							item.RefreshItemById("" + arr[0]);
							needItemNum = int(GoldMoney.Times) * int(arr[1])
							if(obj.activityId && OperateActivityManage.getIntance().activityEffDic[obj.activityId])
								msg += HCss.GeneralColor1 + 13 +"    "+ item.Item_Name + "：" + HCss.GeneralColor2 + 13 + needItemNum + HCss.TipsColor9 + 
									13 + "(活动日-" + OperateActivityManage.getIntance().activityEffDic[obj.activityId]+ "%,"+ int(percent * needItemNum) +")" + "\n";
							else
								msg += HCss.GeneralColor1 + 13+"    " + item.Item_Name + "： " + HCss.GeneralColor2 + 13 + needItemNum + "\n";
						}
						_tipsvo.tipsLabel1 = msg;
						_tipsvo.tipsType = 1;
						//ItemIconTipsManage.getInstance().showHluckProgressTips(obj,touch.globalX + 20,touch.globalY + 20 );
						ItemIconTipsManage.getInstance().showBloodDataTips(_tipsvo);
					}
					ItemIconTipsManage.getInstance().moveTips(touch.globalX + 20,touch.globalY + 20 );	
				}				
			}	else {
				if(_isShow)
				{
					hideTips();
				}
			}
		}
		
		public function hideTips():void
		{
			if(_isShow)
			{
				_isShow = false;
				ItemIconTipsManage.getInstance().hideItemTips();
			}
		}
		
		public function playerOneKeyUpgradeEffect():void
		{
			this._change = true;
			this._isAdd = true;
			this._effectRatio = _ratio
			this._ratio = 0.9;
			this._timer.start();
		}
		
		public function get isShowTxt():Boolean
		{
			return _isShowTxt;
		}
		
		public function set isShowTxt(value:Boolean):void
		{
			_isShowTxt = value;
			if(_textField){
				_textField.visible = value;
			}
		}
		/**显示已满阶文本*/
		public function showFullText(str:String = "已满阶"):void
		{
			_txtProgress.label = HCss.GeneralColor3 + "12" + str;
			_txtProgress.x=(this.myWidth-_txtProgress.textWidth) * .5 + gapX;
		}
		
		override public function set maxNum(value:Number):void
		{
			// TODO Auto Generated method stub
			super.maxNum = value;
		}
		
		override public function set nowProgress(value:Number):void
		{
			// TODO Auto Generated method stub
			super.nowProgress = value;
			if(value > 0)
				playerZhufuzhiEffect();
		}
		/**播放祝福值特效*/
		public function playerZhufuzhiEffect():void
		{
			if(HAssetsManager.getInstance().getTextureAtlas(SourceTypeEvent.SOURCE_EFFECT_E))
			{
				_effcetY = this.myHeight - 50 >> 1;
				_effect =  EffectPlayerManage.getMyInstance().playEffect("zhufuzhi/zhufuzhi_000", this, _effcetX, _effcetY, 1, true, SourceTypeEvent.SOURCE_EFFECT_E);
				if(_effect)
				{
					_effect.scaleX = this.myWidth/248;
					if(this._isReverse)
					{
						_effect.rotation = 3.141;
						_effect.x = this.myWidth;
						_effect.y = 50 + _effcetY;
					} 	else {
						_effect.rotation = 0;
						_effect.x = 0;
						_effect.y = _effcetY;
					}
				}
			}
		}
		public function playerFortressEffect():void
		{
			if(HAssetsManager.getInstance().getTextureAtlas(SourceTypeEvent.SOURCE_EFFECT_E))
			{
				_effcetY = this.myHeight - 50 >> 1;
				_effect =  EffectPlayerManage.getMyInstance().playEffect("zhufuzhi/zhufuzhi_000", this, _effcetX, _effcetY, 1, true, SourceTypeEvent.SOURCE_EFFECT_E);
				if(_effect)
				{
					_rot = this.myWidth/248
					_effect.scaleX = _rot;
					if(this._isReverse)
					{
						_effect.rotation = 3.141;
						_effect.x = this.myWidth;
						_effect.y = 50 + _effcetY;
					} 	else {
						_effect.rotation = 0;
						_effect.x = 0;
						_effect.y = _effcetY;
					}
				}
			}
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
		}
		
		
	}
}