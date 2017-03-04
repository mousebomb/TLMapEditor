/**
 * Created by gaord on 2017/3/4.
 */
package tl.frameworks.defines
{
	import flash.utils.Dictionary;

	public class WizardLayer
	{
		public static const LABEL:Dictionary= new Dictionary();

		static function init():void
		{
			/* :
			 0,通用图层
			 1，植被
			 2，建筑
			 3，功能部件
			 4，刚体
			 5，怪物
			 6，场景特效

			 11, 野外怪物
			 12，野外BOSS
			 13，材料副本1怪物
			 14，材料副本3怪物


			 */
			WizardLayer.LABEL[0]="通用图层";
			WizardLayer.LABEL[1]="植被";
			WizardLayer.LABEL[2]="建筑";
			WizardLayer.LABEL[3]="功能部件";
			WizardLayer.LABEL[4]="刚体";
			WizardLayer.LABEL[5]="怪物";
			WizardLayer.LABEL[6]="场景特效";
		}

		init();

	}
}
