package HLib.UICom.Component
{
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import HLib.UICom.BaseClass.HXYSprite;
	
	import Modules.Common.AttributeCalculation;
	import Modules.Common.SGCsvManager;
	import Modules.Common.Tool.FightPowerTool;
	import Modules.Common.Tool.TipsInterface;
	import Modules.DataSources.Item;
	import Modules.MainFace.MainInterfaceManage;
	import Modules.SFeather.SFTextField;
	
	import feathers.display.Scale9Image;
	
	import starling.display.Image;
	
	/**
	 *黄文涛 
	 * @author Administrator
	 * 战力预览提示
	 */	
	public class PowerPreviewTip extends HXYSprite implements TipsInterface
	{
		private var _twidth:int = 160;
		private var _theight:int = 80;
		private var _offsetx:int = 5;
		private var _offsety:int = 5;
		private var nameTxt:SFTextField;
		private var contentTxt:SFTextField;
		private var needConditionTxt:SFTextField;
		public var bg:Scale9Image;
		public var line0:Image;
		public var line1:Image;
		private var _isInit:Boolean;
		private static var _instance:PowerPreviewTip;
		
		public function PowerPreviewTip()
		{
			if(_instance){
				throw new Error("单例模式，请使用myInstance获取");
			}
			myWidth = _twidth;
			myHeight = _theight;
			init();
		}
		
		public static function getInstance():PowerPreviewTip{
			if(!_instance){
				_instance = new PowerPreviewTip();
			}
			return _instance;
		}
		
		private function init():void
		{
			bg = new Scale9Image(MainInterfaceManage.getInstance().tips_scale9Textures);
			bg.touchable = true;
			bg.width = 160;
			bg.height = 80;
			this.addChild(bg);
			
			var format:TextFormat = new TextFormat();
			format.letterSpacing = 3;
			format.leading = 4;
			nameTxt = new SFTextField();
			addChild(nameTxt);
			nameTxt.format = format;
			nameTxt.bold = true;
			nameTxt.y = 10;
		}
		/**
		 * _obj {label:自定义文本,lvFull:Boolean,arr:Array }
		 * arr [[blessid1,blessid2],[blessid3,blessid4],[blessid5,blessid6]...]
		 * @param vo
		 * 
		 */		
		public function updateTips(value:*):void
		{
			var _obj:Object = value as Object;
			var _label:String = _obj.label;
			var _lvFull:Boolean = _obj.lvFull;//是否满级
			var _arr:Array = _obj.arr;
			if(_lvFull){
				_label = "#fff21b14已满级 ";
			}else{
				var _power:int = getPower(_arr);
				if(_power >= 0){
					_label += "#fff21b14战斗力 : + " + _power;
				}else{
					_label += "#fff21b14战斗力 : - " + Math.abs(_power);
				}
			}
			
			nameTxt.label = "#fff21b14" + _label;
			
			bg.width = nameTxt.textWidth + _offsetx * 2;
			bg.height = nameTxt.textHeight + _offsety * 2;
			nameTxt.x = _offsetx;
			nameTxt.y = _offsety;
		}
		
		public function getPower(_arr:Array):int{
			var _power:int;
			var arr:Array = [
				"Attack",
				"Defense",
				"CurHp",
				"Crit",
				"Tenacity",
				"AppendHurt",
				"OutAttack",
				"AttackPerc",
				"LgnoreDefense",
				"AbsorbHurt",
				"DefenseSuccess",
				"DefensePerc",
				"OutHurtPerc",
				"Vampire",
			];
			
			var myProterty:Array = [
				"Attack",     // 10 16 Item_Attack                    (基本)攻击
				"Defense",     // 11 17 Item_Defense                   (基本)防御
				"CurHp",     // 12 18 Item_CurHp                     (基本)生命值
				"Crit",     // 13 19 Item_Crit                      (基本)暴击
				"Tenacity",     // 14 20 Item_Tenacity                  (基本)韧性
				"AppendHurt",     // 15 21 Item_AppendHurt                (基本)附加伤害
				"OutAttack",     // 16 22 Item_OutAttack                 (基本)卓越攻击
				"AttackPerc",     // 17 23 Item_AttackPerc                (基本)攻击加成
				"LgnoreDefense",     // 18 24 Item_LgnoreDefense             (基本)无视防御
				"AbsorbHurt",     // 19 25 Item_AbsorbHurt                (基本)吸收伤害
				"DefenseSuccess",     // 20 26 Item_DefenseSuccess            (基本)防御成功率
				"DefensePerc",     // 21 27 Item_DefensePerc               (基本)防御加成
				"OutHurtPerc",     // 22 28 Item_OutHurtPerc               (基本)减伤比例
				"Vampire"     // 23 29 Item_Vampire                   (基本)吸血     
			];
			
			//基础属性
			var index:int;
			var diction:Dictionary = new Dictionary;
			var item:Item;
			var len:int = _arr.length;
			var len2:int = arr.length;
			var obj:Object;
			var obj2:Object;
			var _item:Item;
			for(var i:int = 0;i < len;i++){
				if(_arr[i].length == 3){//装备强化处理[blessId1,blessId2,itemId]
					if(int(_arr[i][0]) == 0){
						if(!obj){
							obj = new Object();
						}
						for(var j:int = 0;j < len2;j++){
							obj[myProterty[j]] = 0;	
						}
					}else{
						obj = SGCsvManager.getInstance().table_bless.FindToObject(String(_arr[i][0]));
					}
					obj2 = SGCsvManager.getInstance().table_bless.FindToObject(String(_arr[i][1]));
					if(!_item){
						_item = new Item();
					}
					_item.RefreshItemById(String(_arr[i][2]));
					if(obj && obj2){
						for(j = 0;j < 5;j++){
							if(_item["Item_" + myProterty[j]] > 0){
								index = int(obj2[myProterty[j]]) - int(obj[myProterty[j]]);
								if(diction[arr[j]]){
									index += diction[arr[j]];
								}
								diction[arr[j]] = index;
							}
						}
					}
				}else if(_arr[i].length == 1){
					//技能符文处理
					obj = SGCsvManager.getInstance().table_bless.FindToObject(String(_arr[i][0]));
					if(obj){
						for(j = 0;j < len2;j++){
							index = int(obj[myProterty[j]]);
							if(diction[arr[j]]){
								index += diction[arr[j]];
							}
							diction[arr[j]] = index;
						}
					}
				}else if(_arr[i].length == 2){
					if(String(_arr[i][0]).indexOf("power") > -1){
						_power = int(_arr[i][1]);
						return _power;
					}else if(String(_arr[i][0]).indexOf("identification") > -1 || String(_arr[i][0]).indexOf("title") > -1){//鉴定处理和称号处理
						obj = _arr[i][1] as Object;
						if(obj){
							for(j = 0;j < len2;j++){
								index = int(obj[myProterty[j]]);
								if(diction[arr[j]]){
									index += diction[arr[j]];
								}
								diction[arr[j]] = index;
							}
						}
					}else if(String(_arr[i][0]).indexOf("mountequip") > -1){//骑具处理
						//obj = _arr[i][1] as Object;
						obj = AttributeCalculation.getInstance().getcultivateAtt2(_arr[i][1]);
						if(obj){
							for(j = 0;j < len2;j++){
								index = int(obj[myProterty[j]]);
								if(diction[arr[j]]){
									index += diction[arr[j]];
								}
								diction[arr[j]] = index;
							}
						}
					}else{
						if(_arr[i][0] == 0){//未激活处理
							if(!obj){
								obj = new Object();
								for(j = 0;j < len2;j++){
									obj[myProterty[j]] = 0;
								}
							}
						}else{
							obj = SGCsvManager.getInstance().table_bless.FindToObject(String(_arr[i][0]));
						}
						obj2 = SGCsvManager.getInstance().table_bless.FindToObject(String(_arr[i][1]));
						if(obj && obj2){
							for(j = 0;j < len2;j++){
								index = int(obj2[myProterty[j]]) - int(obj[myProterty[j]]);
								if(diction[arr[j]]){
									index += diction[arr[j]];
								}
								diction[arr[j]] = index;
							}
						}
					}
				}else if(_arr[i].length == 4){
					
				}
			}
			_power = FightPowerTool.getInstance().getComprehensivePower(diction);
			return _power;
		}
	}
}


