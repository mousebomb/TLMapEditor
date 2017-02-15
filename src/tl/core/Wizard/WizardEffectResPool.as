package tl.core.Wizard
{
	/**
	 * 特效资源池
	 * @author 李舒浩
	 */

	import tl.utils.HashMap;

	import tool.MyError;

	public class WizardEffectResPool
	{
		private static var _wizardEffectResPool:WizardEffectResPool;
		
		private var _isInit:Boolean;
		/** 特效保存hashmap **/
		public function get effectHashMap():HashMap  {  return _effectHashMap;  }
		private var _effectHashMap:HashMap;	//特效保存hashmap
		
		/** 精灵保存hashmap **/
		public function get wizardHashMap():HashMap  {  return _wizardHashMap;  }
		private var _wizardHashMap:HashMap;	//精灵保存hashmap
		
		private var _maxEffectNum:int = 50;	//单种特效限制数量
		private var _maxWizardNum:int = 50;	//单种精灵限制数量
		
		public function WizardEffectResPool()
		{
			if(_wizardEffectResPool) throw new MyError();
			_wizardEffectResPool = this;
		}
		
		public static function getInstance():WizardEffectResPool
		{
			if(!_wizardEffectResPool)
			{
				_wizardEffectResPool = new WizardEffectResPool();
				_wizardEffectResPool.init();
			}
			return _wizardEffectResPool;
		}
		
		public function init():void
		{
			if(_isInit) return;
			
			_effectHashMap = new HashMap();
			_wizardHashMap = new HashMap();
			
			_isInit = true;
		}
		
/*************************************************  获得特效  *****************************************************/
		/**
		 * 获得一个特效
		 * @param packName	: 特效文件名
		 * @param subPath	: 特效文件夹名
		 * @param wolrker	: 是否有移动
		 * @return 
		 */		
		public function getEffect(packName:String, subPath:String, wolrker:Boolean = false):WizardEffect
		{
			var wizardEffect:WizardEffect;
			var key:String = packName + "/" + subPath;
			var effectVec:Vector.<WizardEffect> = _effectHashMap.get(key);
			if(!effectVec)
			{
				effectVec = new Vector.<WizardEffect>();
				_effectHashMap.put(key, effectVec);
			}
			//获得特效
			if(effectVec.length > 0)
			{
				wizardEffect = effectVec.shift();
				trace(">>>>>>>>>  Get Effect From WizardEffectResPool   >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  Get");
			}
			else
			{
				trace(">>>>>>>>>  New Effect From WizardEffectResPool   >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  New");
				wizardEffect = new WizardEffect();
				wizardEffect.effectName = key;
				wizardEffect.effectInIt(packName, subPath, wolrker);	
			}
			wizardEffect.visible = true;
			wizardEffect.play();
			return wizardEffect;
		}
		/**
		 * 回收一个特效
		 * @param wizardEffect	: 要回收的特效
		 */		
		public function addEffect(wizardEffect:WizardEffect):void
		{
			var key:String = wizardEffect.effectName;
			var effectVec:Vector.<WizardEffect> = _effectHashMap.get(key);
			if(!effectVec)
			{
				effectVec = new Vector.<WizardEffect>();
				_effectHashMap.put(key, effectVec);
			}
			//判断是否超出了存储容量,如果超出了执行释放处理
			if(effectVec.length > _maxEffectNum)
			{
				deleteEffect(wizardEffect);
				return;
			}
			
			if(effectVec.indexOf(wizardEffect) < 0) effectVec.push(wizardEffect);
			wizardEffect.visible = false;
			wizardEffect.stop();
			wizardEffect.reset(0);
		}
		/**
		 * 删除指定的一个特效
		 * @param wizardEffect	: 需要删除的特效
		 */		
		public function deleteEffect(wizardEffect:WizardEffect):void
		{
			var key:String = wizardEffect.effectName;
			var effectVec:Vector.<WizardEffect> = _effectHashMap.get(key);
			var index:int = effectVec.indexOf(wizardEffect);
//			if(index < 0) return;
			if(index > -1)
				effectVec.splice(index, 1);
			if(wizardEffect.parent)
				wizardEffect.parent.removeChild(wizardEffect);
			wizardEffect.stop();
			wizardEffect.dispose();
			wizardEffect = null;
		}
		/**
		 * 删除指定的所有特效
		 * @param packName	: 特效文件名
		 * @param subPath	: 特效包名
		 */		
		public function deleteEffectVec(packName:String, subPath:String):void
		{
			var key:String = packName + "/" + subPath;
			var effectVec:Vector.<WizardEffect> = _effectHashMap.get(key);
			if(!effectVec) return;
			
			var wizardEffect:WizardEffect;
			while(effectVec.length)
			{
//				wizardEffect = effectVec.shift();
				deleteEffect( effectVec[effectVec.length-1] );//wizardEffect );
//				wizardEffect = null;
			}
//			effectVec = null;
			_effectHashMap.remove(key);
		}
		/** 删除所有特效 **/
		public function clearAllEffect():void
		{
			var keys:Array = _effectHashMap.keys;
			var len:int = keys.length;
			var keyArr:Array;
			for(var i:int = 0; i < len; i++)
			{
				keyArr = String( keys[i] ).split("/");
				deleteEffectVec( keyArr[0], keyArr[1] );
			}
			_effectHashMap.clear();
		}
		
		
/*************************************************  获得精灵  *****************************************************/
		/**
		 * 获得一个精灵
		 * @param wizardId	: actionID
		 * @return 
		 */			
		public function getWizard(wizardId:String):WizardUnit
		{
			var wizardUnit:WizardUnit;
			var wizardVec:Vector.<WizardUnit> = _wizardHashMap.get(wizardId);
			if(!wizardVec)
			{
				wizardVec = new Vector.<WizardUnit>();
				_wizardHashMap.put(wizardId, wizardVec);
			}
			//获得特效
			if(wizardVec.length > 0)
			{
				wizardUnit = wizardVec.shift();
				trace(">>>>>>>>>  Get Wizard From WizardEffectResPool   >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  Get");
			}
			else
			{
				trace(">>>>>>>>>  New Wizard From WizardEffectResPool   >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  New");
				wizardUnit = new WizardUnit();
				wizardUnit.wizardUnitInIt( wizardId );
			}
			return wizardUnit;
		}
		/**
		 * 回收一个精灵
		 * @param wizardUnit	: 需要回收的精灵
		 */		
		public function addWizard(wizardUnit:WizardUnit):void
		{
			var key:String = String( wizardUnit.wizardAction.actionID );
			var wizardVec:Vector.<WizardUnit> = _wizardHashMap.get(key);
			if(!wizardVec)
			{
				wizardVec = new Vector.<WizardUnit>();
				_wizardHashMap.put(key, wizardVec);
			}
			if(wizardVec.length > _maxWizardNum)
			{
				deleteWizard(wizardUnit);
				return;
			}
			
			if(wizardVec.indexOf(wizardUnit) < 0) wizardVec.push(wizardUnit);
			if(wizardUnit.parent)
				wizardUnit.parent.removeChild(wizardUnit);
			wizardUnit.playAction( ActionName.stand );
		}
		/**
		 * 删除指定的精灵
		 * @param wizardUnit	: 需要删除的精灵
		 */		
		public function deleteWizard(wizardUnit:WizardUnit):void
		{
			var key:String = String( wizardUnit.wizardAction.actionID );
			var wizardVec:Vector.<WizardUnit> = _wizardHashMap.get(key);
			var index:int = wizardVec.indexOf(wizardUnit);
//			if(index < 0) return;
			if(index > -1)
				wizardVec.splice(index, 1);
			if(wizardUnit.parent)
				wizardUnit.parent.removeChild(wizardUnit);
			wizardUnit.clearWizardUnit();
			wizardUnit = null;
		}
		/**
		 * 删除指定的所有特效
		 * @param packName	: 特效文件名
		 * @param subPath	: 特效包名
		 */		
		public function deleteWizardVec(wizardId:String):void
		{
			var wizardVec:Vector.<WizardUnit> = _wizardHashMap.get(wizardId);
			if(!wizardVec) return;
			
//			var wizardUnit:WizardUnit;
			while(wizardVec.length)
			{
//				wizardUnit = wizardVec.shift();
				deleteWizard( wizardVec[wizardVec.length-1] );//wizardUnit );
//				wizardUnit = null;
			}
//			wizardUnit = null;
			_wizardHashMap.remove(wizardId);
		}
		/** 删除所有特效 **/
		public function clearAllWizard():void
		{
			var keys:Array = _wizardHashMap.keys;
			var len:int = keys.length;
			for(var i:int = 0; i < len; i++)
			{
				deleteWizardVec( keys[i] );
			}
			_wizardHashMap.clear();
		}
		
	}
}