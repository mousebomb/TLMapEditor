package tl.core.Wizard.NameBar
{
	import HLib.Tool.WizardEffectPool;
	import HLib.WizardBase.WizardEffect;
	
	import away3d.containers.ObjectContainer3D;
	
	/**
	 * 称号 
	 * @author Administrator
	 * 
	 */
	public class WizardTitle extends ObjectContainer3D
	{
		private var _effL:Vector.<WizardEffect>;
		public function WizardTitle()
		{
			super();
			
			this.mouseChildren = this.mouseEnabled = false;
			_effL = new Vector.<WizardEffect>();
		}
		
		public function initData(data:String):void
		{
			var eff:WizardEffect;// = new WizardEffect();
			for each (eff in _effL)
			{
				eff.dispose();
			}
			
			_effL.length = 0;
			var arr:Array = data.split("|");
			for (var i:int = 0; i < arr.length; i += 2)
			{
				eff = WizardEffectPool.getInstance().getWizardEffect(arr[i], arr[i + 1], true);
				this.addChild(eff);
				_effL.push(eff);
			}
		}
		
		override public function dispose():void
		{
			for each (var eff:WizardEffect in _effL)
			{
				WizardEffectPool.getInstance().recoverWizardEffect(eff);
			}
			_effL = null;
			
			super.dispose();
		}
	}
}