package tl.core.Wizard
{
	/**
	 * 精灵血条块(包括血条与名字)
	 * @author 李舒浩
	 */

	import tl.core.old.WizardObject;
	import tl.mapeditor.ui3d.HTextField3D;
	import tl.utils.HCss;
	import tl.utils.Tool;

	public class WizardNameBar extends MySprite3D
	{
		private var _wizardObject:WizardObject;		//精灵数据对象
		
		private var _nameTF3D:HTextField3D;			//名字
		
		private var _nameText:String;					//名字内容
		
		/** 称号偏差值 **/
		public function set titleDeviationY(value:int):void
		{
			_titleDeviationY = value;
		}
		public function get titleDeviationY():int  {  return _titleDeviationY;  }
		private var _titleDeviationY:int = 0;//名字偏差值

		public function WizardNameBar()  {  super();  }
		
		public function init():void
		{
			//名字
			_nameTF3D = new HTextField3D();
			_nameTF3D.init(1);
			_nameTF3D.size = 14;
			_nameTF3D.color = 0xD6DCE1;
			Tool.setDisplayGlowFilter(_nameTF3D.textField);
			this.addChild(_nameTF3D);
			_nameTF3D.y = 20;
		}
		
		
		/**
		 * 设置精灵数据
		 * @param value	: 精灵数据
		 */		
		public function set wizardObject(value:WizardObject):void
		{
			_wizardObject = value;
			//判断精灵类型,设置名字颜色
			switch(_wizardObject.type)
			{
				case 0:		//玩家类型
					//判断是否为同阵营
					_nameTF3D.color = 0xD6DCE1;		//白色
					break;
				case 1:		//NPC类型
					_nameTF3D.color = 0x2FEC1B;			//绿色
					break;
				case 4:		//怪物
					//判断是主动怪物还是被动怪物
					if(_wizardObject.aiList.indexOf(1) > -1)		_nameTF3D.color = 0xE3B824;		//被动攻击 黄色
					else if(_wizardObject.aiList.indexOf(2) > -1)	_nameTF3D.color = 0xC41B12;		//主动攻击 红色
					break;
				case 5:		//BOSS怪物
					if(_wizardObject.aiList.indexOf(1) > -1)		_nameTF3D.color = 0xE3B824;		//被动攻击 黄色
					else if(_wizardObject.aiList.indexOf(2) > -1)	_nameTF3D.color = 0xC41B12;		//主动攻击 红色
					break;
				case 99:	//掉落物品
					//根据品质设置颜色
					var lv:int = int(_wizardObject.level);
					lv = (lv >= HCss.QualityColorArray.length ? HCss.QualityColorArray.length-1 : lv);
					var color:String = HCss.QualityColorArray[lv].replace("#", "");
					_nameTF3D.color = parseInt(color, 16);
					break;
			}
			//设置名字
			this.nameText = this._wizardObject.name;
		}
		
		/**
		 * 设置名字
		 * @param value
		 */		
		public function set nameText(value:String):void
		{
			_nameText = value;
			_nameTF3D.text = value;
		}
		public function get nameText():String  {  return _nameText;  }
		/**
		 * 设置名字颜色
		 * @param value
		 */		
		public function set nameColor(value:uint):void
		{
			_nameTF3D.color = value;
		}
		
		override public function disposeWithChildren():void
		{
			if(_nameTF3D)
				_nameTF3D.disposeWithChildren();
			
			super.disposeWithChildren();
			
			_nameTF3D = null;
			_wizardObject = null;
			_nameText = null;
		}
		
	}
}