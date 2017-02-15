package HLib.UICom.Component.Icons
{
	/**
	 * 物品拖动显示类可用于技能和 物品
	 * @author郑利本
	 */	
	import HLib.UICom.BaseClass.HSprite;
	import HLib.UICom.BaseClass.HTopBaseView;
	
	import Modules.Common.SourceTypeEvent;
	import Modules.DataSources.Item;
	import Modules.DataSources.Skill;
	import Modules.MainFace.MouseCursorManage;
	
	public class DragIcon extends HSprite
	{
		private static var _dragIcon:DragIcon; 
		
		private var icon:HItemIcon;
		private var _item:Item;		//物品图标数据
		private var _skill:Skill;		//技能图标数据
		private var _itemName:String;	//物品名字　
		public function DragIcon()
		{
			if(_dragIcon)
				throw new Error("单例模式不可重复实例化,请调用getInstance()");
			_dragIcon = this;
			icon = new HItemIcon;
			this.addChild(icon);
			icon.init();
			icon.scaleX = icon.scaleY = 1.1;
			this.pivotX = icon.myWidth >> 1;
			this.pivotY = icon.myHeight >> 1;
			this.touchable = false;
			this.touchGroup = true;
		}
		
		public static function getInstance():DragIcon
		{
			if(!_dragIcon)
			{
				_dragIcon = new DragIcon();
				_dragIcon.touchable = false;
			}
			return _dragIcon;
		}
		/** 显示Icon **/
		public function showItemIcon(item:Item,vx:Number,vy:Number):void
		{
			MouseCursorManage.getInstance().showCursor(5);
			_item = item;
			var str:String = item.Item_IconPack + "_" + item.Item_IconName
			if(_itemName != str)
			{
				_itemName = str
				icon.item = item;
				icon.isShowText = item.Item_OverlapCount > 1 ? true : false;
				HTopBaseView.getInstance().addChild(this);
			}
			movePonsition(vx,vy);
		}
		
		public function movePonsition(vx:Number,vy:Number):void
		{
			this.x = vx;
			this.y = vy;
		}
		public function showSkillIcon(skill:Skill,vx:Number,vy:Number):void
		{
			MouseCursorManage.getInstance().showCursor(5);
			_skill = skill;
			if(skill)
			{
				//skill.iconPack
				icon.data = { Item_IconPack:SourceTypeEvent.MAIN_INTERFACE_SOURCE, Item_IconName:skill.iconName };
				HTopBaseView.getInstance().addChild(this);
			}
			this.x = vx;
			this.y = vy;
		}
		
		/** 隐藏Icon **/
		public function hideItemIcon():void
		{
			MouseCursorManage.getInstance().showCursor();
			if(this.parent)
				this.parent.removeChild(this);
			_itemName = "";
			_item = null
			icon.item = null;
		}

		public function get item():Item
		{
			return _item;
		}

		public function set item(value:Item):void
		{
			_item = value;
		}

		public function get skill():Skill
		{
			return _skill;
		}

		public function set skill(value:Skill):void
		{
			_skill = value;
		}


	}
}