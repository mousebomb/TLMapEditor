package tl.core.Wizard
{
	import tl.core.old.WizardObject;

	public class DestinationManage
	{
		private static var _destinationManage:DestinationManage;
		
		public var moveType:int = -1;					//移动状态(-1:点击地图移动 0:传送阵1:移动到NPC面前)
		
		public var mutualWizardObject:WizardObject;	//需要交互用的精灵数据
		public var mutualObject:Object;				//需要交互用的保存数据对象
		
		public function DestinationManage()
		{
			if(_destinationManage) throw new Error("Singleton");
			_destinationManage = this;
		}
		
		public static function getInstance():DestinationManage
		{
			_destinationManage ||= new DestinationManage();
			return _destinationManage;
		}
		
		/** 移动到目的地执行 **/
		public function destination():void
		{
			if(moveType == 0) return;
			switch(moveType)
			{
//				case 0:		//移动到传送阵
//					trace("走到了传送阵");
//					HMapSources.getInstance().changeMap();
//					break;
				case 1:		//移动到NPC面前
					trace("走到了NPC面前");
					break;
				case 2:		//使用自动释放技能
					break;
			}
			mutualWizardObject = null;
			mutualObject = null;
			moveType = -1;
		}
		
	}
}