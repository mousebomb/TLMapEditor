package tl.core.Wizard.NameBar
{
	/**
	 * 竞技场名字条
	 * @author 李舒浩
	 */	
	import HLib.UICom.Away3DUICom.HIcon3D;
	import HLib.UICom.BaseClass.HSprite3D;
	import HLib.UICom.BaseClass.HTextField3D;
	import HLib.WizardBase.HObject3DPool;
	
	import Modules.Wizard.WizardObject;
	
	public class ArenaWizardNameBar extends HSprite3D
	{
		private var _wizardObject:WizardObject;		//精灵数据对象
		
		/** 名字文本 **/
		public function get nameTF3D():HTextField3D  {  return _nameTF3D;  }
		private var _nameTF3D:HTextField3D;	//名字
		
		/** 战斗力 **/
		public function get poserTF3D():HTextField3D  {  return _poserTF3D;  }
		private var _poserTF3D:HTextField3D;	//战斗力
		
		/** 排名文本 **/
		public function get rankTF3D():HTextField3D { return _rankTF3D; }
		private var _rankTF3D:HTextField3D;	//排名文本
		
		/** 军阶图标 **/
		public function get rankIcon():HIcon3D  {  return _rankIcon;  }
		private var _rankIcon:HIcon3D;		//军阶标识Icon
		
		public function ArenaWizardNameBar()  {  super();  }
		
		public function init():void
		{
			if(this.isInit)
				return;
			//军阶
			_rankIcon = HObject3DPool.getInstance().getHIcon3D();//new HIcon3D();
			this.addChild(_rankIcon);
			//名字
			_nameTF3D = new HTextField3D();
			_poserTF3D = new HTextField3D();
			_rankTF3D = new HTextField3D();
			var tfVec:Vector.<HTextField3D> = Vector.<HTextField3D>([_nameTF3D, _poserTF3D, _rankTF3D]);
			var colorVec:Vector.<uint> = Vector.<uint>([0xD6DCE1, 0x00FF00, 0xE3B824]);
			var len:int = tfVec.length;
			for(var i:int = 0; i < len; i++)
			{
				if(i == 0)
				{
					tfVec[i].init(1);
					tfVec[i].size = 14;
					tfVec[i].color = colorVec[i];
				}
				else
				{
					tfVec[i].setDefaultSkin( 7 + i );	
					tfVec[i].init();
				}
				tfVec[i].algin = "center";
				this.addChild(tfVec[i]);
			}
			this.isInit = true;
		}
		public function set wizardObject(value:WizardObject):void
		{
			_wizardObject = value;
			if(!_wizardObject) return;
			
			_nameTF3D.text = _wizardObject.Player_Name + "（Lv" + _wizardObject.Creature_Level + "）";
			_poserTF3D.text = "ArenaPower" + _wizardObject.Creature_FightPower;
			_rankTF3D.text = "Di" + _wizardObject.arenaRank + "Ming";
			//设置军阶
			rankLv = _wizardObject.Player_ArmyLevel;
			//更新位置
			updatePosition();
		}
		/**
		 * 军衔等级(Camp表对应ID) 
		 * @param value
		 */
		public function set rankLv(value:int):void
		{
			_rankLv = value;
			if(!_rankIcon||_wizardObject.Player_Camp == 0) return;
			if(_rankLv == 0)
			{
				_rankIcon.visible = false;
				return;
			}
			_rankIcon.type = "MainUI_Rank_" + _wizardObject.Player_Camp + "_" + _rankLv;
			_rankIcon.visible = true;
		}
		public function get rankLv():int  {  return _rankLv;  }
		private var _rankLv:int;
		/** 更新坐直排版 **/
		private function updatePosition():void
		{
			_nameTF3D.z = 0;
			_rankIcon.z = _nameTF3D.z + (_rankIcon.visible ? 26 : 0);
			_poserTF3D.z = _rankIcon.z + 20;
			_rankTF3D.z = _rankIcon.z + 48;
		}
		
	}
}