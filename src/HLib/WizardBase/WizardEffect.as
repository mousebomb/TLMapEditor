package HLib.WizardBase
{
	/**
	 * 特效精灵
	 * @author 李舒浩
	 */	
	import com.greensock.easing.Linear;
	
	import flash.display3D.Context3DCompareMode;
	import flash.geom.Vector3D;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import HLib.Event.Event_F;
	import HLib.IResources.IResourceEvent;
	import tl.core.IResourceKey;
	import HLib.IResources.IResourcePool;
	import HLib.IResources.MyLoader3DManager;
	import HLib.IResources.load.LoaderParam;
	import HLib.Pools.ObjectPools;
	
	import Modules.Common.HKeyboardManager;
	import Modules.Wizard.WizardKey;
	import Modules.Wizard.Move.TweenObjectProxy;
	
	import away3d.animators.data.ParticleGroupEventProperty;
	import away3d.containers.ObjectContainer3D;
	import away3d.debug.Debug;
	import away3d.entities.ParticleGroup;
	import away3d.events.ParticleGroupEvent;
	
	public class WizardEffect extends ObjectContainer3D
	{
		public var isRecycle:Boolean = false;
		
		public var suid:Number = 0;
		public var wizardType:int = -1;
		public var wizardEffectType:int = 0;//0,绑定的特效，1BUFF特效，2选中特效，3技能区域特效，4技能特效
		
		public var bindSkeletonName:String = "";      //绑定的骨格名
		public var bindSkeletonIndex:int = -1;           //绑定的骨格索引值
		public var resName:String;                     //特效资源名
		
		/** 是否加载完执行播放 **/
		private var _isPlaying:Boolean = false;
		
		private var _isDisPatch:Boolean = true;			//是否每播放完一次都派发一次事件
		private var _particleGroup:ParticleGroup;			//特效控制器
		
		private var _tweenProxyObj:TweenObjectProxy;
		
		public var share:Boolean = false;
		
		public var offsetY:uint = 0;
		
		public function WizardEffect()  
		{ 
			super(); 
			
			this.mouseChildren = this.mouseEnabled = false;
			
			_tweenProxyObj = ObjectPools.getTweenProxy(this);//new TweenObjectProxy(this);
		}	
		
		private var _offTime:uint;
		private var _subPath:String;
		/**
		 * 初始化方法
		 * @param packName	: 特效文件名
		 * @param subPath	: 特效文件夹名
		 * @param wolrker	: 是否有移动
		 */		
		public function effectInIt(_packName:String, subPath:String):void
		{
			resName = _packName;
			_subPath = subPath;
			
			var tmpKey:String = LoaderParam.generatePathKey(resName, IResourceKey.Suffix_Effect, subPath);
			if(IResourcePool.getInstance().hasResourceByType(tmpKey, IResourceKey.resType_Effect))
			{
				playEff();
			}
			else
			{
				_offTime = getTimer();
				
				MyLoader3DManager.getInstance().addEventListener(IResourceEvent.ResourceTaskComplete + resName, onParticleGroupComplete);
				MyLoader3DManager.getInstance().addTask(resName, [[subPath, resName, IResourceKey.Suffix_Effect]])
			}
		}
		
		
		//---------------------------------------------------------------------------------------------------------
		private var _timeOutId:uint;
		public function setTimeOut(time:uint):void
		{
			_timeOutId = setTimeout(timeOutExec, time);
		}
		
		private function timeOutExec():void
		{
			_timeOutId = 0;
			this.dispatchEvent(new Event_F(WizardKey.Action_EffectOver));
			this.dispatchEvent(new Event_F(WizardKey.Action_Destination, this));
		}
		//---------------------------------------------------------------------------------------------------------
		
		/** 执行播放 **/
		public function play():void
		{
			/*if (resName == "ef_renlei1_xqiangji")
			{
			this;
			}*/
			if (_isPlaying == false)
			{
				if(_particleGroup)
				{
					_isPlaying = true;
					
					var tmpOff:uint = _offTime == 0 ? 0 : getTimer() - _offTime;
					_particleGroup.animator.start1(tmpOff);
					_offTime = 0;
				}
			}
			//			trace("--------------------------------------------->", resName, " ", tmpOff);
		}
		
		/** 停止播放 **/
		public function stop():void
		{
			/*if (resName == "ef_renlei1_xqiangji")
			{
			this;
			}*/
			if (_isPlaying)
			{
				_isPlaying = false;
				
				if(_particleGroup)
				{
					_particleGroup.animator.stop();
				}
			}
		}
		
		/** 重置 **/
		public function reset($time:uint = 0):void
		{
			if(_particleGroup)
			{
				_particleGroup.animator.resetTime($time);
			}
		}
		
		/** 获得最大的事件派发时间 **/
		public function get maxOccurTime():Number
		{
			if(!_particleGroup)
			{
				return 1000;
			}
			var vec:Vector.<ParticleGroupEventProperty> = _particleGroup.eventList;
			var len:int = vec.length;
			var timeNum:Number = -1;
			var particleGroupEventProperty:ParticleGroupEventProperty;
			for(var i:int = 0; i < len; i++)
			{
				particleGroupEventProperty = vec[i];
				if(timeNum < particleGroupEventProperty.occurTime * 1000)
				{
					timeNum = particleGroupEventProperty.occurTime * 1000;
				}
			}
			return Math.max(1000, timeNum);	
		}
		
		/**
		 * 是否每次播放完一次都派发一次事件
		 * @param value	: true:派发 false:不派发
		 */		
		public function set isDisPatch(value:Boolean):void
		{
			_isDisPatch = value;
			if(!_particleGroup)
			{
				return;
			}
			if(value)
			{
				_particleGroup.animator.addEventListener(ParticleGroupEvent.OCCUR, onCycleComplete);	//特效自定义事件
			}
			else
			{
				_particleGroup.animator.removeEventListener(ParticleGroupEvent.OCCUR, onCycleComplete);
			}
		}
		
		public function get isDisPatch():Boolean
		{ 
			return _isDisPatch; 
		}
		
		/** 派发当前特效播放完成事件 **/
		private function onCycleComplete(e:ParticleGroupEvent):void
		{
			this.dispatchEvent(new Event_F(WizardKey.Action_EffectOver));
		}
		
		/** 加载特效成功 **/
		private function onParticleGroupComplete(e:IResourceEvent = null):void
		{
			MyLoader3DManager.getInstance().removeEventListener(IResourceEvent.ResourceTaskComplete + resName, onParticleGroupComplete);
			//获取资源

			var tmpKey:String = LoaderParam.generatePathKey(resName, IResourceKey.Suffix_Effect, _subPath);
			if(!IResourcePool.getInstance().hasResourceByType(tmpKey, IResourceKey.resType_Effect))
			{
				return;
			}
			
			//			if (_isDisPatch)
			{
				playEff();
			}
		}
		
		private function playEff():void
		{
			if (_particleGroup)
			{
				
				if (HKeyboardManager.getInstance().isGM)
				{
					Debug.error("未知错误！");
				}
			}
			var tmpKey:String = LoaderParam.generatePathKey(resName, IResourceKey.Suffix_Effect, "effectall");
			var tmpParticleGroup:ParticleGroup = IResourcePool.getInstance().getResourceByType(tmpKey, IResourceKey.resType_Effect);
			//			if (share == false)
			{
				_particleGroup = tmpParticleGroup.clone() as ParticleGroup;
			}
			//			else
			//			{
			//				_particleGroup = tmpParticleGroup;
			//			}
			depthCompareMode = _depthCompareMode;
			this.addChild(_particleGroup);
			
			
			if (isRecycle)
			{
				stop();
			}
			else
			{
				isDisPatch = isDisPatch;
				
				_isPlaying = false;
				
				play();
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------
		private var _tarPaths:Array;
		private var _speed:Number;
		public function movePath(paths:Array, speed:Number):void
		{
			_tarPaths = paths;
			_speed = speed * 30;
			
			nextV3d();
		}
		
		private function moveTarget(tarV3d:Vector3D, speed:Number):void
		{
			tarV3d.z = -tarV3d.z;
			tarV3d.y = tarV3d.y == 0 ? this.y : tarV3d.y;
			
			var angle:Number = Math.atan2(this.z - tarV3d.z, this.x - tarV3d.x);
			rotationY = 180 - angle * 180 / Math.PI;
			
			var dist:Number = Vector3D.distance(new Vector3D(this.x, this.y, this.z), tarV3d);
			var needTime:Number = dist / speed;
			
			//			trace(position, tarV3d, needTime, _speed, dist);
			
			_tweenProxyObj.to(needTime, {x:tarV3d.x, y:tarV3d.y, z:tarV3d.z, ease:Linear.easeNone, onComplete:nextV3d});
		}
		
		private function nextV3d():void
		{
			if (_tarPaths && _tarPaths.length)
			{
				moveTarget(_tarPaths.shift(), _speed);
			}
			else
			{
				this.dispatchEvent(new Event_F(WizardKey.Action_Destination, this));
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------
		public function clearWizardEffect():void
		{
			/*if (resName == "ef_renlei1_xqiangji")
			{
			this;
			}*/
			if (isRecycle)
			{
				return;
			}
			isRecycle = true;
			
			this.identity();
			_depthCompareMode = Context3DCompareMode.LESS_EQUAL;
			
			clearTimeout(_timeOutId);
			_timeOutId = 0;
			
			_tarPaths = null;
			_speed = -1;
			
			_offTime = 0;
//			_subPath = null;
			
			this.stop();
			
			bindSkeletonName = null;
			bindSkeletonIndex = -1;
			suid = 0;
			offsetY = 0;
			
			visible = true;
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
		}
		
		private var _depthCompareMode:String;
		public function set depthCompareMode(value:String):void
		{
			if (_depthCompareMode != value)
			{
				_depthCompareMode = value;
				if (_particleGroup)
				{
					_particleGroup.depthCompareMode = value;
				}
			}
		}
		
		/** 清除方法 **/
		override public function dispose():void
		{
			ObjectPools.recycleTweenProxy(_tweenProxyObj);
			_tweenProxyObj = null;
			
			clearTimeout(_timeOutId);
			_timeOutId = 0;
			
			MyLoader3DManager.getInstance().removeEventListener(IResourceEvent.ResourceTaskComplete + resName, onParticleGroupComplete);
			if(_particleGroup)
			{
				_particleGroup.animator.removeEventListener(ParticleGroupEvent.OCCUR, onCycleComplete);	//特效自定义事件
				_particleGroup.dispose();
				//				if (share == false)
				//				{
				//					_particleGroup.dispose();
				//				}
				//				else
				//				{
				//					
				//				}
			}
			
			super.dispose();
		}
		//-----------------------------------------------------------------------------
	}
}