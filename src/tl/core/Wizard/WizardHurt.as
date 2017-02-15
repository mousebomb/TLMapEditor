package tl.core.Wizard
{
	import flash.geom.Point;

	public class WizardHurt
	{
		public var type:int=0;
		public var direction:int=0;
		public var fps:int=0;
		public var fristFrame:int=0;
		public var secondFrame:int=0;
		public var fristSpeedX:int=0;
		public var fristSpeedY:int=0;
		public var fristSpeedZ:int=0;
		public var secondSpeedX:int=0;
		public var secondSpeedY:int=0;
		public var secondSpeedZ:int=0;
		public var scaleSpeed:Number=0;
		
		public function WizardHurt()
		{
			
		}
		
		public function refreshWizard(_fps:int, needframe:int, type:int, sP:Point=null, tP:Point=null):void
		{
			fps = _fps;
			var height:int = 500;
			var _prop:Number = 60 / fps;
			switch(type)
			{
				case 0:	//跳跃
					height=800;
					fristFrame=int(needframe/_prop);
					fristSpeedY=int(height/fristFrame);
					secondFrame=int(needframe/_prop);
					secondSpeedY=-int(height/secondFrame);
					break;
				case 1:	//技能跃起
					height=500;
					fristFrame=int(needframe/_prop);
					fristSpeedY=int(height/fristFrame);
					secondFrame=int(needframe/_prop);
					secondSpeedY=-int(height/secondFrame);
					break;
				case 2:	//击飞
					height=300;
					fristFrame=int(needframe/_prop);
					fristSpeedY=int(height/fristFrame);
					secondFrame=int(needframe/_prop);
					secondSpeedY=-int(height/secondFrame);
					break;
				case 4:	//弹起
					height=300;
					fristFrame=int(needframe/_prop);
					fristSpeedY=int(height/fristFrame);
					secondFrame=int(needframe/_prop);
					secondSpeedY=-int(height/secondFrame);
					break;
				case 95:	//死亡
					height=100;
					fristFrame=int(needframe/_prop);
					fristSpeedY=int(height/fristFrame);
					secondFrame=int(needframe/_prop);
					secondSpeedY=-int(height/secondFrame);
					break;
				case 96:	//物品拾取
					height=50;
					fristFrame=int(needframe/_prop);
					fristSpeedY=int(height/fristFrame);
					secondFrame=2;
					secondSpeedY=0;
					break;
				case 97:	//复活
					height = 200;
					fristFrame=int(needframe/_prop);
					fristSpeedY=int(height/fristFrame);
					secondFrame=2;
					secondSpeedY=0;
					break;
				case 98:	//坠落
					height=100;
					fristFrame=int(needframe/_prop);
					fristSpeedY=int(height/fristFrame);
					secondFrame=int(needframe/_prop);
					secondSpeedY=-int(height*2/secondFrame);
					scaleSpeed=0.6/needframe;
					break;
				case 99:	//物品掉落
					height = 200;
					fristFrame = int(needframe/_prop);
					fristSpeedY = int(height/fristFrame);
					secondFrame = int(needframe/_prop);
					secondSpeedY = -int(height/secondFrame);
					break;
			}
			if(sP==null)
			{
				return;
			}
			fristSpeedX=int((tP.x-sP.x)/fristFrame);
			fristSpeedZ=int((tP.y-sP.y)/fristFrame);

		}
	}
}