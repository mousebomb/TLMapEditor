package tl.core.Wizard
{
	import com.greensock.TweenLite;

	public class WizardMove
	{
		public function WizardMove()
		{
			
		}
		
		/** 击飞 */
		public static function hitFly(tarObj:WizardAI, tarX:Number, tarY:Number, duration:Number, backfun:Function):void
		{
			TweenLite.to(tarObj, duration, {x:tarX, y:tarY, onComplete:backfun});
		}
	}
}