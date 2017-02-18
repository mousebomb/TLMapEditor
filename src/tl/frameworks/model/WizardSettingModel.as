/**
 * Created by Administrator on 2017/2/17.
 */
package tl.frameworks.model
{
	import org.robotlegs.mvcs.Actor;

	import tl.frameworks.NotifyConst;

	public class WizardSettingModel extends Actor
	{
		private var _showObj:*;
		public function WizardSettingModel()
		{
			super ();
		}

		public function get showObj():*
		{
			return _showObj;
		}

		public function set showObj(value:*):void
		{
			_showObj = value;
			dispatchWith(NotifyConst.SELECT_WIZARDOBJECT_SETTING)
		}
	}
}
