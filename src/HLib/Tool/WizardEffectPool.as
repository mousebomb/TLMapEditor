package HLib.Tool
{
	/**
	 * 特效资源池
	 * @author 李舒浩
	 */	
	import flash.utils.Dictionary;
	
	import HLib.Pools.WizardEffectPoolObject;
	import HLib.WizardBase.WizardEffect;
	
	public class WizardEffectPool
	{
		private static var _wizardEffectPool:WizardEffectPool;
		
		private var _isInit:Boolean;
		/** 特效保存hashmap **/
		private var _effectDict:Dictionary;	//特效保存hashmap
		private var _maxEffectNum:int = 10;	//单种特效限制数量
		private var _count:int = 0;
		
		public function WizardEffectPool()
		{
			if(_wizardEffectPool) 
			{
				throw new MyError();
			}
			_wizardEffectPool = this;
			
			_effectDict = new Dictionary();
			
			HFrameWorkerManager.getInstance().addFunc(this, onCheckPool);
		}
		
		public static function getInstance():WizardEffectPool
		{
			if(!_wizardEffectPool)
			{
				_wizardEffectPool = new WizardEffectPool();
				_wizardEffectPool.init();
			}
			return _wizardEffectPool;
		}
		
		public function init():void
		{
			if(_isInit)
			{
				return;			
			}
			_isInit = true;
		}
		
		//-------------------------------------------------------------------------------------------------------
		private function onCheckPool():void
		{
			if (++_checkKeep > 60)
			{
				_checkKeep = 0;
				
				checkPoolObject();
			}
		}
		
		private var _checkKeep:uint;
		private function checkPoolObject():void
		{
			var eff:WizardEffectPoolObject;
			var vecLen:uint;
			var effVec:Vector.<WizardEffectPoolObject>;
			for (var effKey:* in _effectDict)
			{
				effVec = _effectDict[effKey];
				vecLen = effVec.length;
				for (var i:int = 0; i < vecLen; ++i)
				{
					eff = effVec[i];
					if (eff.isPassDue)
					{
						effVec[i] = effVec[--vecLen];
						effVec.length = vecLen;
						eff.dispose();
					}
				}
				if (vecLen == 0)
				{
					delete _effectDict[effKey];
				}
			}
		}
		
		/*************************************************  获得特效  *****************************************************/
		/**
		 * 获得一个特效
		 * @param packName	: 特效文件名
		 * @param subPath	: 特效文件夹名
		 * @param wolrker	: 是否有移动
		 * @return 
		 */		
		public function getWizardEffect(packName:String, subPath:String, share:Boolean = false):WizardEffect
		{
			var key:String = packName;
			var wizardEffect:WizardEffect;
			var effectVec:Vector.<WizardEffectPoolObject> = _effectDict[key];
			if(!effectVec)
			{
				effectVec = new Vector.<WizardEffectPoolObject>();
				_effectDict[key] = effectVec;
			}
			//获得特效
			if(effectVec.length > 0)
			{
				var tmpEff:WizardEffect;
				for (var i:int = effectVec.length - 1; i >= 0; --i)
				{
					tmpEff = effectVec[i].data;
					if (tmpEff.share == share)
					{
						wizardEffect = tmpEff;
						effectVec[i] = effectVec[effectVec.length - 1];
						effectVec.pop();
						break;
					}
				}
//				wizardEffect = effectVec.pop().data;
			}
			
			if (wizardEffect)
			{
				wizardEffect.play();
			}
			else
			{
				wizardEffect = new WizardEffect();
				wizardEffect.effectInIt(packName, subPath);
			}
			wizardEffect.share = share;
			
			_count++;
			wizardEffect.isRecycle = false;
			return wizardEffect;
		}
		
		/**
		 * 回收一个特效
		 * @param wizardEffect	: 要回收的特效
		 */		
		public function recoverWizardEffect(wizardEffect:WizardEffect):void
		{
			if (wizardEffect.isRecycle)
			{
				return;
			}
			_count--;
			var key:String = wizardEffect.resName;
			var effectVec:Vector.<WizardEffectPoolObject> = _effectDict[key];
			if(!effectVec)
			{
				effectVec = new Vector.<WizardEffectPoolObject>();
				_effectDict[key] = effectVec;
			}
			//判断是否超出了存储容量,如果超出了执行释放处理
			if(effectVec.length > _maxEffectNum)
			{
				wizardEffect.dispose();
				return;
			}
			wizardEffect.clearWizardEffect();
			effectVec.push(new WizardEffectPoolObject(wizardEffect));
		}
	}
}