package tl.core.old
{
	import tl.frameworks.model.CSV.SGCsvManager;

	/**
	 * 精灵对象数据
	 * @author 李舒浩
	 */	
	public class WizardAction
	{
		public var args:Array;
		public var actionID:int;              //精灵ID
		public var headImage:String;          //头像资源名
		public var bodyImage:String;          //半身像资源名
		public var meshResFileName:String;    //模型文件夹名(与md5mesh文件对应)
		public var meshResName:String;		   //模型文件名(与md5mesh文件对应)
		public var materialResFlieName:String;//贴图文件夹名
		public var materialResName:String;	   //贴图文件名
		public var appActionId:String;        //附加精灵ID
		public var appNodeName:String;        //附加精灵绑定点名
		public var anim_FileName:String;      //动作文件夹名
		public var anim_Stand:String;         //站立动作文件名
		public var anim_Run:String ;          //跑步动作文件名
		public var anim_Struck:String;        //受击动作文件名
		public var anim_StruckFall:String;    //击倒地动作文件名
		public var anim_StruckBack:String;    //击退动作文件名
		public var anim_StruckPly:String;     //击飞动作文件名
		public var anim_Dead:String;          //死亡动作文件名
		public var anim_Cast:String;			//施法动作文件名
		public var anim_Attack1:String;       //攻击1动作文件名
		public var anim_Attack2:String;       //攻击2动作文件名
		public var anim_Attack3:String;       //攻击3动作文件名
		public var anim_Attack4:String;       //攻击4动作文件名
		public var anim_Attack5:String;       //攻击5动作文件名
		public var anim_Attack6:String;       //攻击6动作文件名
		public var anim_Attack7:String;       //攻击7动作文件名
		public var anim_Attack8:String;       //攻击8动作文件名
		public var anim_Attack9:String;       //攻击9动作文件名
		public var anim_Attack10:String;      //攻击10动作文件名
		public var anim_Attack11:String;      //攻击10动作文件名
		public var anim_Attack12:String;      //攻击10动作文件名
		public var anim_Attack13:String;      //攻击10动作文件名
		public var anim_Attack14:String;      //攻击10动作文件名
		public var anim_Attack15:String;      //攻击10动作文件名
		public var anim_Attack16:String;      //攻击10动作文件名
		public var anim_RideStand:String;     //乘骑站立动作文件名
		public var anim_RideRun:String;       //乘骑跑步动作文件名
		public var anim_Ply:String;           //飞行动作文件名
		public var anim_Sit:String;           //坐下动作文件名
		public var anim_Roll:String;			//翻滚动作
		public var anim_Jump:String;			//跳跃动作
		public var anim_Character:String;     //个性动作文件名
		public var effect_Args:Array;         //绑定特效信息数组
		public var effect_Struck:Array;       //受击特效信息数组
		public var soundFileName:String;		//音效包
		public var struckSoundName:String;		//受击音效
		public var deadSoundName:String;		//死亡音效
		public var actionBindWizard:Array;	//动作播放时
		
		public var _ActionNameArgs:Array=
			[   "stand"
				,"run"
				,"struck"
				,"struckFall"
				,"struckBack"
				,"struckPly"
				,"dead"
				,"cast"
				,"attack1"
				,"attack2"
				,"attack3"
				,"attack4"
				,"attack5"
				,"attack6"
				,"attack7"
				,"attack8"
				,"attack9"
				,"attack10"
				,"attack11"
				,"attack12"
				,"attack13"
				,"attack14"
				,"attack15"
				,"attack16"
				,"ridestand"
				,"riderun"
				,"ply"
				,"sit"
				,"roll"
				,"jump"
				,"character"
			];
		
		public function WizardAction()  {  }
		
		public function refresh(value:String):void
		{
			args=SGCsvManager.getInstance().table_action.FindRow(value);
			if(!args) return;
			actionID                   =  args[0];
			headImage                  =  args[1];
			bodyImage                  =  args[2];
			meshResFileName            =  args[3];
			meshResName                =  args[4];
			materialResFlieName        =  args[5];
			materialResName            =  args[6];
			appActionId                =  args[7];
			appNodeName                =  args[8];			
			anim_FileName              =  args[9];
			anim_Stand                 =  args[10];
			anim_Run                   =  args[11];
			anim_Struck                =  args[12];
			anim_StruckFall            =  args[13];
			anim_StruckBack            =  args[14];
			anim_StruckPly             =  args[15];
			anim_Dead                  =  args[16];
			anim_Cast				   =  args[17];
			anim_Attack1               =  args[18];
			anim_Attack2               =  args[19];
			anim_Attack3               =  args[20];
			anim_Attack4               =  args[21];
			anim_Attack5               =  args[22];
			anim_Attack6               =  args[23];
			anim_Attack7               =  args[24];
			anim_Attack8               =  args[25];
			anim_Attack9               =  args[26];
			anim_Attack10              =  args[27];
			anim_Attack11              =  args[28];
			anim_Attack12              =  args[29];
			anim_Attack13              =  args[30];
			anim_Attack14              =  args[31];
			anim_Attack15              =  args[32];
			anim_Attack16              =  args[33];
			anim_RideStand             =  args[34];
			anim_RideRun               =  args[35];
			anim_Ply                   =  args[36];
			anim_Sit                   =  args[37];
			anim_Roll				   =  args[38];
			anim_Jump				   =  args[39];
			anim_Character             =  args[40];
			if(args[41] != "0"){
				effect_Args            =  args[41].split("|");
			}
			else
				effect_Args = null;
			if(args[42] != "0"){
				effect_Struck            =  args[42].split("|");
			}
			else
				effect_Struck = null;
			soundFileName              =  args[43];
			struckSoundName            =  args[44];
			deadSoundName              =  args[45];
			actionBindWizard			= args[46].split("|");
		}
		/**
		 * 获取动作名
		 * @param value	: 动作key(ActionName类常量)
		 */		
		public function getAnimName(value:String):String
		{
			var _Index:int=_ActionNameArgs.indexOf(value);
			return args[_Index+10];
		}
		/**
		 * 获得动作key
		 * @param $value	: 动作文件名
		 * @return 
		 */		
		public function getAnimKey($value:String):String
		{
			var str:String = "";
			var len:int = _ActionNameArgs.length;
			for(var i:int = 0; i < len; i++)
			{
				if( args[i+10] == $value)
				{
					str = _ActionNameArgs[i];
					break;
				}
			}
			return str;
		}
	}
}


