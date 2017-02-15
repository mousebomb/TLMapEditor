package HLib.UICom.Component.Icons
{
	import flash.utils.Dictionary;
	
	import HLib.UICom.BaseClass.HSprite;
	
	import Modules.Common.HAssetsManager;
	import Modules.Common.HCss;
	import Modules.Common.SourceTypeEvent;
	import Modules.Common.Tool.FightPowerTool;
	import Modules.DataSources.Item;
	import Modules.DataSources.ItemSources;
	import Modules.DataSources.Skill;
	import Modules.SFeather.SFTextField;
	import Modules.view.roleEquip.PowerItem;
	
	import starling.display.Image;
	import starling.textures.Texture;

	/**
	 * 装备战斗力值 
	 * @author Administrator
	 * 郑利本
	 */	
	public class EquiptPower extends HSprite
	{
		private var _markImage:Image;			//问号图片
		private var _power:PowerItem;           //战斗力图片
		private var _upTexture:Texture;			//上升
		private var _downTexture:Texture;		//下降
		private var _compareImage:Image;		//图片
		private var _txtRest:SFTextField;
		public function EquiptPower()
		{
			init();
		}
		
		private function init():void
		{	
			this.myHeight = 40;
			var image:Image = HAssetsManager.getInstance().getMyImage(SourceTypeEvent.MAIN_INTERFACE_SOURCE, "number/power_new_bg");
			this.addChild(image);
			image.y = this.myHeight - image.height >> 1;
			var vw:int = image.width;
			_markImage = HAssetsManager.getInstance().getMyImage(SourceTypeEvent.MAIN_INTERFACE_SOURCE, "number/power_new_");
			this.addChild(_markImage);
			_markImage.x = vw
			_markImage.y = this.myHeight - _markImage.height >> 1;
			
			_power = new PowerItem;
			this.addChild(_power);
			_power.x = vw;
			_power.y = this.myHeight - 32 >> 1;
			_power.setSourceName("role/power", "number/power_new_", SourceTypeEvent.MAIN_INTERFACE_SOURCE, SourceTypeEvent.MAIN_INTERFACE_SOURCE, 20);
		
		}
		public function showSkillPower(skill:Skill):void
		{
			_markImage.visible = false;
			_power.visible = true;
			var diction:Dictionary = getPowerDiction(skill);
			_power.power = 112//FightPowerTool.getInstance().getComprehensivePower(diction);
			if(_compareImage)
				_compareImage.visible = false;
			if(_txtRest)
				_txtRest.visible = false;
			this.myHeight = 50
		}
		
		private function getPowerDiction(skill:Skill):Dictionary
		{
			var diction:Dictionary = new Dictionary;
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
			return diction;
		
		}
		/**显示战斗力*/
		public function showPower(item:Item):void
		{
			if(item.isItemIdentification)
			{
				_markImage.visible = true;
				_power.visible = false;
			}	else {
				_markImage.visible = false;
				_power.visible = true;
				_power.power = ItemSources.getInstance().getItemPower(item)
			}
			if(_compareImage)
				_compareImage.visible = false;
			if(_txtRest)
				_txtRest.visible = false;
		}
		/**显示比较战斗力*/
		public function showComparePower(myItem:Item, otherItem:Item):void
		{
			var power1:int = ItemSources.getInstance().getItemPower(myItem);
			var power2:int = ItemSources.getInstance().getItemPower(otherItem);
			_markImage.visible = false;
			_power.visible = true;
			_power.power = power1;
			if(power1 != power2)
			{
				if(!_txtRest)
				{
					_txtRest = new SFTextField;
					_txtRest.myWidth = 60;
					this.addChild(_txtRest);	
					_txtRest.y = this.myHeight - 14 >> 1;
				}	else {
					_txtRest.visible = true;
				}
				var texture:Texture;
				var color:String;
				if(power1 > power2)
				{
					color =  HCss.TipsColor3 + '14';
					_upTexture ||= HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, "number/power_new_up");
					texture = _upTexture
				}	else {
					color =  HCss.TipsColor9 + '14';
					_downTexture ||= HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.MAIN_INTERFACE_SOURCE, "number/power_new_down");
					texture = _downTexture
				}
				_txtRest.label = color + (power1 - power2);
				if(!_compareImage)
				{
					_compareImage = new Image(texture);
					this.addChild(_compareImage);
					_compareImage.y = this.myHeight - texture.height >> 1;
				}	else {
					if(_compareImage.texture != texture)
					{
						_compareImage.texture = texture;
						_compareImage.readjustSize();
					}
					_compareImage.visible = true;
				}
				var vx:Number = _power.x + _power.myWidth + 6;
				_compareImage.x = vx ; 
				vx += 20;
				_txtRest.x = vx;
				
			}	else {
				if(_compareImage)
					_compareImage.visible = false;
				if(_txtRest)
					_txtRest.visible = false;
			}
		}
	}
}