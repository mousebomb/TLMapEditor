package tl.core.Wizard.NameBar
{
	import HLib.Tool.HObjectPool;
	import HLib.UICom.Away3DUICom.HIcon3D;
	import HLib.UICom.BaseClass.HSprite3D;
	import HLib.UICom.BaseClass.HTextField3D;
	
	public class StalNickNmaeIcon extends HSprite3D
	{
		private var _nameTF3D:HTextField3D;
		private var _stallNick:HIcon3D;
		public function StalNickNmaeIcon()
		{
			init();
		}
		
		private function init():void
		{
			if(this.isInit) return;
			_stallNick = HObjectPool.getInstance().popObj(HIcon3D) as HIcon3D;
			this.addChild(_stallNick);
			_stallNick.mouseEnabled = true;
			_stallNick.type = "MainUI_StallNickTitle_Up";
			_stallNick.visible = true;
			
			_nameTF3D = new HTextField3D();
			_nameTF3D.mouseEnabled = false;
			_nameTF3D.init(1);
			_nameTF3D.algin = "center";
			_nameTF3D.size = 20;
			_nameTF3D.color = 0xFFB22E;
			_nameTF3D.y = 1;
			this.addChild(_nameTF3D);
			this.isInit = true;
		}
		public function set stallNickName(labe:String):void
		{
			_nameTF3D.text = labe;
		}
			
		public function set type(value:String):void
		{
			_stallNick.type = value;
		}
	}
}