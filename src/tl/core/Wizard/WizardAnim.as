package tl.core.Wizard
{
	/**
	 * 动作模型类(除了mesh之外,另外添加了加载完模型后添加动作赋值处理)
	 * @author 李舒浩
	 */

	import away3DExtend.SkeletonAnimatorExtend;

	import away3d.animators.nodes.SkeletonClipNode;
	import away3d.animators.transitions.CrossfadeTransition;
	import away3d.containers.ObjectContainer3D;
	import away3d.events.AnimationStateEvent;

	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import tl.IResources.IResourceEvent;
	import tl.IResources.IResourceKey;
	import tl.IResources.IResourceLoader3D;
	import tl.IResources.IResourcePool;
	import tl.core.old.WizardAction;

	public class WizardAnim extends WizardMesh
	{
		private var _SkeletonAnimator:SkeletonAnimatorExtend;//动作控制器
		private var _EffectObj:Object;			//绑定对象保存对象
		
		private var _NowAction:String;				//当前播放的动作
		private var _CrossfadeTransition:CrossfadeTransition = new CrossfadeTransition(0.2);
		private var _AnimLoader:IResourceLoader3D;
		
		public function WizardAnim()  {  
			super();  
		}
		
		public function animInIt():void
		{
			this.meshReset();
			this.addEventListener("SkeletonRefreshComplete",onSkeletonRefreshComplete);
		}
		public function loadRes():void{
			if(!this.wizardAction) return;
			this.loadMesh();
		}
		private function onSkeletonRefreshComplete(e:MyEvent):void
		{		
			if(!this.skeletonAnimationSet) return;
			if(!this.skeleton) return;
			if(!_SkeletonAnimator){
				_SkeletonAnimator = new SkeletonAnimatorExtend(this.skeletonAnimationSet, this.skeleton);
				//_SkeletonAnimator.playbackSpeed=1.5;
				this.dispatchEvent(new MyEvent("SkeletonAnimatorRefreshComplete"));
			}
		}
		override public function set wizardAction(value:WizardAction):void
		{
			super.wizardAction = value;
			//判断是否已经有动作文件了,先清除掉动作保存的文件
			
		}
		private var _loaderAnimKey:String;
		/** 加载anim动作完成 **/
		private function onSkeletonClipNodeComplete(e:IResourceEvent):void
		{
			if(!_SkeletonAnimator) return;
			//赋值动作
			var _SkeletonClipNode:SkeletonClipNode=IResourcePool.getInstance().getResource(String(e.data));
			if(!_SkeletonClipNode) return;
			if(!this.skeletonAnimationSet.hasAnimation(_SkeletonClipNode.name))	
			{
//				if(wizardAction.actionID == 4041)
//				{
//					trace(wizardAction.actionID,"WizardAnim/onSkeletonClipNodeComplete stand");
//				}
				this.skeletonAnimationSet.addAnimation(_SkeletonClipNode);
			}
			var _ActionArgs:Array=_SkeletonClipNode.name.split("_");
			this.nowAction=_ActionArgs[_ActionArgs.length-1];	
		}
		/** 攻击动作播放完一次执行 **/
		private function onPlayAttackComplete(e:AnimationStateEvent):void
		{
//			SkeletonClipNode(e.target).removeEventListener(AnimationStateEvent.PLAYBACK_COMPLETE, onPlayAttackComplete);
			if(!_SkeletonAnimator) return;
			if (_SkeletonAnimator.activeState != e.animationState) return;
			this.dispatchEvent(new MyEvent(WizardKey.Action_ActionPlayOver,this.nowAction));			
		}
		/**
		 * 设置当前播放动作
		 * @param value	: 动作播放
		 */		
		public function set nowAction(value:String):void
		{
			if(value == "0" || value == "") return;
			if(_NowAction==value) return;
			var _ActionName:String = this.wizardAction.getAnimName(value);
			if(_ActionName == "0") return;
			if(!_SkeletonAnimator) return;
			var _SkeletonClipNode:SkeletonClipNode=SkeletonClipNode(this.skeletonAnimationSet.getAnimation(_ActionName));
			if(_SkeletonClipNode)
			{
				_NowAction = value;
				if(isNotLooping(_NowAction)){	
						//清注要在释放的时候清除这个事件
						_SkeletonClipNode.looping=false;
						_SkeletonClipNode.addEventListener(AnimationStateEvent.PLAYBACK_COMPLETE, onPlayAttackComplete);	
				}else{
					if(!_SkeletonClipNode.looping){
						_SkeletonClipNode.looping=true;
					}
				}	
				if(!this.animator){
					this.animator = _SkeletonAnimator;
				}
//				if(wizardAction.actionID == 4041 && int(scenePosition.x)==8901 && int(-scenePosition.z) == 7521)
//				{
//					trace(wizardAction.actionID,"WizardAnim/nowAction stand" ,_SkeletonClipNode.looping);
//				}
				clearTimeout(bugFixAnimDelay);
				bugFixAnimDelay = setTimeout(_SkeletonAnimator.play ,500 ,_ActionName,   _CrossfadeTransition,0);
				_SkeletonAnimator.play(_ActionName, _CrossfadeTransition,0);
			}
			else
			{
				_AnimLoader = new IResourceLoader3D();
				_AnimLoader.addEventListener(IResourceEvent.SkeletonClipNodeComplete, onSkeletonClipNodeComplete);
				_AnimLoader.myLoad(_ActionName,this.wizardAction.anim_FileName,IResourceKey.Suffix_Anim);
			}
		}
		private var bugFixAnimDelay : uint;
		public function get nowAction():String  {  
			return _NowAction;  
		}
		public function isNotLooping(actionName:String):Boolean{
			if(actionName==ActionName.stand) return false;
			if(actionName==ActionName.move) return false;
			if(actionName==ActionName.run) return false;
			if(actionName==ActionName.confront) return false;
			return true;
		}
		public function getSkeletonVector3D(skeletonName:String):Vector3D{
			if(!this.skeleton) return null;
			if(!this.skeletonAnimator) return null;
			var _Vector3D:Vector3D;
			var _Index:int=this.skeleton.jointIndexFromName(skeletonName);
			if(_Index<0) return null;
			if(_SkeletonAnimator.globalPose.jointPoses.length==0) return null;
			return _SkeletonAnimator.globalPose.jointPoses[_Index].toMatrix3D().position;
		}
		/**
		 * 添加绑定对象
		 * @param key		: 对象名
		 * @param obj		: 绑定对象
		 * @param index		: 绑定骨骼下标位置
		 */		
		public function bindEffectToSkeleton(key:String, obj3D:ObjectContainer3D, name:String):void
		{
			var _Index:int=this.skeleton.jointIndexFromName(name);
			if(_Index<0) return;
			if(!_EffectObj) _EffectObj = {};
			if(_EffectObj[key+name])
			{
				removeEffectFromSkeleton(key+name);
			}
			this.addChild(obj3D);
			_EffectObj[key+name] = {obj3D:obj3D, index:_Index, name:name};
			refreshEffect();
		}
		/**
		 * 移除绑定对象
		 * @param key	: 对象key
		 */		
		public function removeEffectFromSkeleton(key:String):void
		{
			if(!_EffectObj) return;
			if(!_EffectObj[key]) return;
			this.removeChild(_EffectObj[key].obj3D);
			ObjectContainer3D(_EffectObj[key].obj3D).disposeWithChildren();
			ObjectContainer3D(_EffectObj[key].obj3D).disposeAsset();
			delete _EffectObj[key];
		}
		
		/** 帧事件执行方法,用于外部的enterFrame调用实时执行精灵对应的帧执行方法 **/
		public function refreshEffect():void 
		{ 
			//更新点位置
			if(!_SkeletonAnimator) return;
			if(!_SkeletonAnimator.globalPose) return;
			if(!_EffectObj) return;
			var obj:Object;
			if(_SkeletonAnimator.globalPose.jointPoses.length == 0) 
			{
				var pos:Matrix3D = new Matrix3D();
				for each(obj in _EffectObj)
				{
					pos.rawData = this.skeleton.jointFromName(obj.name).inverseBindPose;
					pos.invert();//因为inverseBindPose是反转矩阵数值，所以需要反转一下
					obj.obj3D.position = pos.position;
				}
				return;
			}
			if(!this.wizardAction) return;
			//获取骨骼
			var matrix3D:Matrix3D;
			var vec3D:Vector3D;
			var flag:Boolean = false;	//是否还有绑定对象标识
			for each(obj in _EffectObj)
			{
				flag = true;
				matrix3D = _SkeletonAnimator.globalPose.jointPoses[obj.index].toMatrix3D();
				vec3D = matrix3D.position;
				obj.obj3D.position = vec3D;
			}
			if(!flag) _EffectObj = null;
		}
		
		public function clearWizardAnim():void
		{
			this.clearWizardMesh();
			if(_AnimLoader){
				_AnimLoader.removeEventListener(IResourceEvent.SkeletonClipNodeComplete, onSkeletonClipNodeComplete);
				_AnimLoader=null;
			}
			for each(var obj:Object in _EffectObj)
			{
				obj.obj3D.stop();
			}
			_EffectObj=null;
			if(_SkeletonAnimator){
				_SkeletonAnimator.stop();
				_SkeletonAnimator = null;
			}
		}

		public function get wizardAnim():SkeletonAnimatorExtend
		{
			return _SkeletonAnimator;
		}
		public function set skeletonAnimator(value:SkeletonAnimatorExtend):void
		{
			_SkeletonAnimator = value;
			this.animator = value;
		}
		public function get skeletonAnimator():SkeletonAnimatorExtend
		{
			return _SkeletonAnimator;
		}

		public function get effectObj():Object
		{
			return _EffectObj;
		}
	}
}