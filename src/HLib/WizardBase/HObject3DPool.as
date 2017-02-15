package HLib.WizardBase
{
	import flash.events.EventDispatcher;
	
	import HLib.UICom.Away3DUICom.HIcon3D;
	import HLib.UICom.Away3DUICom.HProgressBar3D;
	import HLib.UICom.BaseClass.HTextField3D;
	import HLib.UICom.BaseClass.NameTextField3D;
	
	import Modules.Wizard.WizardActor3D;
	import Modules.Wizard.WizardObject;
	import Modules.Wizard.WizardUnit;

	import tool.StageFrame;


	public class HObject3DPool extends EventDispatcher
	{
		private static var _inst:HObject3DPool;		//单例模式	
		
		private const OBJECT_MAX:int = 400;
		
		private var count_HIcon3D:int = 0;
		private var count_Shadow:int = 0;
		private var count_HTextField3D:int = 0;
		public var count_WizardUnit:int = 0;
		private var count_HProgressBar3D:int = 0;
		private var count_WizardActor3D:int = 0;
		private var count_Bmd:int = 0;
		
		private var _shadowVec:Vector.<HIcon3D> = new Vector.<HIcon3D>;
		private var _icon3dVec:Vector.<HIcon3D> = new Vector.<HIcon3D>;
		private var _txt3dVec:Vector.<HTextField3D> = new Vector.<HTextField3D>;
		private var _name3dVec:Vector.<NameTextField3D> = new Vector.<NameTextField3D>;
		private var _hp3dVec:Vector.<HProgressBar3D> = new Vector.<HProgressBar3D>;
		public var _wizardUnitVec:Vector.<WizardUnit> = new Vector.<WizardUnit>;
		private var _actor3dVec:Vector.<WizardActor3D> = new Vector.<WizardActor3D>;
		
		public static function getInstance():HObject3DPool
		{
			return _inst ||= new HObject3DPool();
		}
		
		
		public function getShadow():HIcon3D
		{
			var hIcon3d:HIcon3D;
			if(_icon3dVec.length > 0)
			{
				hIcon3d = _icon3dVec.pop();
			}
			else
			{
				hIcon3d = new HIcon3D();
			}
			count_HIcon3D++;
			return hIcon3d;
		}
		
		public function recoverShadow(hIcon3D:HIcon3D):void
		{
			var _Index:int = _icon3dVec.indexOf(hIcon3D);
			if(_Index > -1)
			{
				return;
			}
			if(_icon3dVec.length > OBJECT_MAX)
			{
				hIcon3D.dispose();
			}
			else
			{
				_icon3dVec.push(hIcon3D);
			}
			count_HIcon3D--;
		}
		
		public function getHIcon3D():HIcon3D
		{
			var hIcon3d:HIcon3D;
			if(_icon3dVec.length > 0)
			{
				hIcon3d = _icon3dVec.pop();
			}
			else
			{
				hIcon3d = new HIcon3D();
			}
			count_HIcon3D++;
			return hIcon3d;
		}
		
		public function recoverHIcon3D(hIcon3D:HIcon3D):void
		{
			var _Index:int=_icon3dVec.indexOf(hIcon3D);
			if(_Index > -1)
			{
				return;
			}
			if(_icon3dVec.length > OBJECT_MAX)
			{
				hIcon3D.dispose();
			}
			else
			{
				_icon3dVec.push(hIcon3D);
			}
			count_HIcon3D--;
		}
		
		public function getNameTxt3D():NameTextField3D
		{
			var text3D:NameTextField3D;
			if(_name3dVec.length > 0)
			{
				text3D = _name3dVec.pop();
			}
			else
			{
				text3D = new NameTextField3D();
			}
			return text3D;
		}
		
		public function recoverNameTxt3D(nameTxt:NameTextField3D):void
		{
			if(nameTxt.isDispose) 
			{
				return;
			}
			var idx:int = _name3dVec.indexOf(nameTxt);
			if (idx > -1)
			{
				return;
			}
			if(_name3dVec.length > OBJECT_MAX)
			{
				nameTxt.dispose();
			}
			else
			{
				_name3dVec.push(nameTxt);
			}
		}
		
		public function getHTextField3D():HTextField3D
		{
			var text3D:HTextField3D;
			if(_txt3dVec.length > 0)
			{
				text3D = _txt3dVec.pop();
			}
			else
			{
				text3D = new HTextField3D();
			}
			count_HTextField3D++;
			return text3D;
		}
		
		public function recoverHTextField3D(hTextField3D:HTextField3D):void
		{
			if(hTextField3D.isDispose) 
			{
				return;
			}
			var idx:int = _txt3dVec.indexOf(hTextField3D);
			if (idx > -1)
			{
				return;
			}
			if(_txt3dVec.length > 100)
			{
				hTextField3D.dispose();
			}
			else
			{
				_txt3dVec.push(hTextField3D);
			}
			count_HTextField3D--;
//			PropertyCount.getInstance().keyCount("HObject3DPool.HTextField3D.Number",_HTextField3DVec.length);
		}
		
		public function getWizardUnit():WizardUnit
		{
			var _WizardUnit:WizardUnit;
			if(_wizardUnitVec.length > 0)
			{
				_WizardUnit = _wizardUnitVec.pop();
			}
			else
			{
				_WizardUnit = new WizardUnit();
			}
			_WizardUnit.initObj();
			count_WizardUnit++;
			return _WizardUnit;
		}
		
		public function recoverWizardUnit(wizardUnit:WizardUnit):void
		{
			var _Index:int = _wizardUnitVec.indexOf(wizardUnit);
			if(_Index > -1)
			{
				return;
			}
			if(_wizardUnitVec.length > OBJECT_MAX)
			{
				wizardUnit.dispose();
			}
			else
			{
				_wizardUnitVec.push(wizardUnit);
			}
			count_WizardUnit--;
//			PropertyCount.getInstance().keyCount("HObject3DPool.WizardUnit.Number",_WizardUnitVec.length);
		}
		
		public function getHProgressBar3D(wizardObj:WizardObject):HProgressBar3D
		{
			var _HProgressBar3D:HProgressBar3D;
			if(_hp3dVec.length > 0)
			{
				_HProgressBar3D = _hp3dVec.pop();
			}
			else
			{
				_HProgressBar3D = new HProgressBar3D();
				_HProgressBar3D.init();
			}
			_HProgressBar3D.setDefaultSkin(wizardObj);
			count_HProgressBar3D++;
			return _HProgressBar3D;
		}
		
		public function recoverHProgressBar3D(hProgressBar3D:HProgressBar3D):void
		{
			var _Index:int = _hp3dVec.indexOf(hProgressBar3D);
			if(_Index > -1) 
			{
				return;
			}
				
			if(_hp3dVec.length > OBJECT_MAX)
			{
				hProgressBar3D.disposeHPBar3D();
			}
			else
			{
				_hp3dVec.push(hProgressBar3D);
			}
			count_HProgressBar3D--;
//			PropertyCount.getInstance().keyCount("HObject3DPool.HProgressBar3D.Number",_HProgressBar3DVec.length);
		}
			
		public function getWizardActor3D():WizardActor3D
		{
			var actor3d:WizardActor3D;
			if(_actor3dVec.length > 0)
			{
				actor3d = _actor3dVec.pop();
			}
			else
			{
				actor3d = new WizardActor3D();
			}
			count_WizardActor3D++;
			actor3d.isDispose = false;
			return actor3d;
		}
		
		public function recoverWizardActor3D(wizardActor3D:WizardActor3D):void
		{
			wizardActor3D.dispose();
			return;
			var _Index:int = _actor3dVec.indexOf(wizardActor3D);
			if(_Index > -1) 
			{
				return;
			}
			if(_actor3dVec.length < OBJECT_MAX)
			{
				_actor3dVec.push(wizardActor3D);
			}
			else
			{
				wizardActor3D.dispose();
			}
			count_WizardActor3D--;
//			PropertyCount.getInstance().keyCount("HObject3DPool.WizardActor3D.Number",_actor3dVec.length);
		}
	}
}