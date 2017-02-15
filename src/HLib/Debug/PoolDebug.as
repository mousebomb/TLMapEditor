package HLib.Debug
{
	import HLib.IResources.IResourcePool;
	import HLib.IResources.LoaderManager;
	import HLib.Pools.ResPool;
	import HLib.Tool.EffectPlayerManage;
	import HLib.Tool.HFrameWorkerManager;
	import HLib.Tool.HObjectPool;
	import HLib.Tool.HSysClock;
	import HLib.Tool.WizardEffectPool;
	import HLib.WizardBase.HObject3DPool;
	
	import Modules.Map.HMap3D;
	import Modules.Wizard.WizardActor3D;

	public class PoolDebug
	{
		public static function testUpdate():void
		{
			return;
			var objectPool:HObjectPool = HObjectPool.getInstance();
			
			var resPool:IResourcePool = IResourcePool.getInstance();
			
			var object3dPool:HObject3DPool = HObject3DPool.getInstance();
			
			var effPlay:EffectPlayerManage = EffectPlayerManage.getMyInstance();
			
			var mianActor:WizardActor3D = HMap3D.getInstance().mainWizardActor3D;
			
			var sysClock:HSysClock = HSysClock.getInstance();
			
			var frameWorker:HFrameWorkerManager = HFrameWorkerManager.getInstance();
			
			var actorVec:Vector.<WizardActor3D> = HMap3D.getInstance().actorVec;
			
			var bmpDict:ResPool = ResPool.inst;
			
			var effPool:WizardEffectPool = WizardEffectPool.getInstance();
			
			var loader:LoaderManager = LoaderManager.inst;
			
			//VertexBufferCount.update();
			
			var a:int = 0;
		}
	}
}