package HLib.Pools
{
	import HLib.WizardBase.WizardEffect;

	public class WizardEffectPoolObject extends PoolObject
	{
		private var _eff:WizardEffect;
		
		public function WizardEffectPoolObject(data:*=null)
		{
			super(data, 300000);
			
			_eff = data;
		}
		
		override protected function disposeData():void
		{
			_eff.dispose();
			_eff = null;
			
			super.disposeData();
		}
	}
}