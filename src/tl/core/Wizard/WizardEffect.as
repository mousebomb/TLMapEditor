package tl.core.Wizard
{
	/**
	 * 特效精灵
	 * @author 李舒浩
	 */

	import away3d.entities.ParticleGroup;
	import away3d.events.ParticleGroupEvent;

	import flash.geom.Point;

	import tl.IResources.IResourceEvent;
	import tl.IResources.IResourceKey;
	import tl.IResources.IResourceLoader3D;
	import tl.IResources.IResourcePool;
	import tl.core.old.NodeUnit;

	public class WizardEffect extends MySprite3D
	{
		public var effectName:String;						//特效名字,用于判断用,由于name属性被定义为awp名字,所以用此字符串替代name做判断标识
		
		private var _EffectLoader3D:IResourceLoader3D;		//加载类
		private var _isDisPatch:Boolean = false;			//是否每播放完一次都派发一次事件
		private var _IsPlaying:Boolean = true;//false;
		private var _ParticleGroup:ParticleGroup;			//特效控制器
		private var _Worker:WizardWalker;
		public function WizardEffect()  {  
			super();  
		}		
		/**
		 * 初始化方法
		 * @param packName	: 特效文件名
		 * @param subPath	: 特效包名
		 * @param wolrker	: 
		 */		
		public function effectInIt(packName:String, subPath:String, wolrker:Boolean=false):void
		{
			this.name=packName;
			_EffectLoader3D=new IResourceLoader3D();
			_EffectLoader3D.addEventListener(IResourceEvent.ParticleGroupComplete,onParticleGroupComplete);
			_EffectLoader3D.myLoad(packName, subPath, IResourceKey.Suffix_Effect);
			if(wolrker){
				_Worker=new WizardWalker();
				_Worker.addEventListener(WizardKey.Action_MoveStart,onMoveStart);
				_Worker.addEventListener(WizardKey.Action_Destination,onDestination);
			}
		}
		public function set targetPath(args:Array):void{
			if(!_Worker) return;
			_Worker.targetPath=args;
		}
		public function refreshPosition():void{
			if(!_Worker) return;
			_Worker.refreshMove();
			this.rotationY=_Worker.rotationX;
			this.position=NodeUnit.twoToThree(new Point(_Worker.x,_Worker.y));
		}
		public function onMoveStart(e:MyEvent):void{
			
		}
		public function onDestination(e:MyEvent):void{
			this.dispatchEvent(new MyEvent(WizardKey.Action_EffectOver,this));
		}
		
		/** 清除方法 **/
		public function clear():void
		{
			stop();
			_EffectLoader3D.removeEventListener(IResourceEvent.ParticleGroupComplete,onParticleGroupComplete);	//加载特效完成			
			if(_ParticleGroup)
			{
//				_ParticleGroup.animator.removeEventListener(AnimatorEvent.CYCLE_COMPLETE, onCycleComplete);
				_ParticleGroup.animator.removeEventListener(ParticleGroupEvent.OCCUR, onCycleComplete);	//特效自定义事件
				_ParticleGroup.disposeWithChildren();
				_ParticleGroup.disposeAsset();
				_ParticleGroup.dispose();
			}			
			_ParticleGroup = null;
			_EffectLoader3D = null;
		}
		/** 执行播放 **/
		public function play():void
		{
			_IsPlaying=true;
			if(_ParticleGroup)
				_ParticleGroup.animator.start();
		}
		/** 停止播放 **/
		public function stop():void
		{
			_IsPlaying=false;
			if(_ParticleGroup)
				_ParticleGroup.animator.stop();
		}
		/** 重置 **/
		public function reset($time:uint = 0):void
		{
			if(_ParticleGroup)
				_ParticleGroup.animator.resetTime($time);
		}
		
		/**
		 * 是否每次播放完一次都派发一次事件
		 * @param value	: true:派发 false:不派发
		 */		
		public function set isDisPatch(value:Boolean):void
		{
			_isDisPatch = value;
			if(!_ParticleGroup) return;
			if(value)
//				_ParticleGroup.addEventListener(ParticleGroupEvent.OCCUR, onCycleComplete);	//特效自定义事件
				_ParticleGroup.animator.addEventListener(ParticleGroupEvent.OCCUR, onCycleComplete);	//特效自定义事件
			else
				_ParticleGroup.animator.removeEventListener(ParticleGroupEvent.OCCUR, onCycleComplete);	//特效自定义事件
//				_ParticleGroup.animator.removeEventListener(AnimatorEvent.CYCLE_COMPLETE, onCycleComplete);
		}
		/** 派发当前特效播放完成事件 **/
		private function onCycleComplete(e:ParticleGroupEvent):void
		{
			this.dispatchEvent(new MyEvent(WizardKey.Action_EffectOver));
		}
		
		/** 加载特效成功 **/
		private function onParticleGroupComplete(e:IResourceEvent):void
		{
			//判断是否为当前加载的特效
			this.name = String(e.data);
			//获取资源
			_ParticleGroup =IResourcePool.getInstance().getResource(this.name).clone();
//			var _P:ParticleAnimationSet=IResourcePool.getInstance().getResource(_Name);
			this.addChild(_ParticleGroup);
			if(_isDisPatch){
//				_ParticleGroup.animator.addEventListener(ParticleGroupEvent.OCCUR, onCycleComplete);	//特效自定义事件
				_ParticleGroup.animator.addEventListener(ParticleGroupEvent.OCCUR, onCycleComplete);	//特效自定义事件
			}
			else{
//				_ParticleGroup.animator.removeEventListener(AnimatorEvent.CYCLE_COMPLETE, onCycleComplete);
				_ParticleGroup.animator.removeEventListener(ParticleGroupEvent.OCCUR, onCycleComplete);	//特效自定义事件
			}
			if(_IsPlaying)	play();
			else			stop();
//			play();
		}

		public function get isPlaying():Boolean
		{
			return _IsPlaying;
		}

		public function set isPlaying(value:Boolean):void
		{
			_IsPlaying = value;
		}

		public function get worker():WizardWalker
		{
			return _Worker;
		}


	}
}