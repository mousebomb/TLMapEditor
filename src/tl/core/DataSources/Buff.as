package tl.core.DataSources
{
	import flash.events.EventDispatcher;

	import tl.frameworks.model.CSV.SGCsvManager;

	public class Buff extends EventDispatcher
	{
		public var id:String;//#状态编号
		public var name:String;//状态名称
		public var desc:String;//状态描述
		public var pack:String;//资源包
		public var className:String;//图标类名
		public var effectLyer:int;//特效图层
		public var effectAdd:int;//特效添加
		public var effectHold:int;//特效持续
		public var effectRemove:int;//特效移除
		public var level:int;//状态等级
		public var helpful:int;//有益标志
		public var overlapTimes:int;//最大叠加次数
		public var effectList:Array;//效果列表
		public var lastTime:int;//持续时间
		public var jumpInterval:int;//跳跃间隔
		public var auraRange:int;//光环范围
		public var friendAuraBuff:int;//友方光环BUFF
		public var enemyAuraBuff:int;//敌方光环BUFF
		public var mutexs:Array;//互斥
		public var endType:int;//取消方式
		public var privateData:Array;//私有数据

		
		public var nowTime:int;				//当前Buff剩余时间(秒)
		public var timeEndCallBack:Function;	//时间到执行回调
		public var refreshCallBack:Function;	//每秒刷新BUFF后执行的回调
		
		public function Buff()  {  }
		
		public function Refresh($id:String):void
		{
			var args:Array=SGCsvManager.getInstance().table_buff.FindRow($id);
			id=args[0];//#状态编号
			name=args[1];//状态名称
			desc=args[2];//状态描述
			pack=args[3];//资源包
			className=args[4];//图标类名
			effectLyer=int(args[5]);//特效图层
			effectAdd=int(args[6]);//特效添加
			effectHold=int(args[7]);//特效持续
			effectRemove=int(args[8]);//特效移除
			level=int(args[9]);//状态等级
			helpful=args[10];//有益标志
			overlapTimes=args[11];//最大叠加次数
			effectList=args[12].split("|");//效果列表
			lastTime=int(args[13]);//持续时间
			jumpInterval=int(args[14]);//跳跃间隔
			auraRange=int(args[15]);//光环范围
			friendAuraBuff=int(args[16]);//友方光环BUFF
			enemyAuraBuff=int(args[17]);//敌方光环BUFF
			mutexs=args[18].split("|");//互斥
			endType=args[19];//取消方式
			privateData=args[20].split("|");//私有数据
		}
		/** 刷新时间,每一秒执行一次 **/
		public function refreshTime():void
		{
			if(nowTime == 0)
			{
				if(timeEndCallBack != null) timeEndCallBack(this);
				return;
			}
			if(nowTime == -1) return;
			nowTime--;
			if(refreshCallBack != null) refreshCallBack(this);
		}
	}
}