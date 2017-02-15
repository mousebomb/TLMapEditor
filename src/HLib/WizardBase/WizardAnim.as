package HLib.WizardBase
{
	/**
	 * 动作模型类(除了mesh之外,另外添加了加载完模型后添加动作赋值处理)
	 * @author 李舒浩
	 */	
	import HLib.Event.Event_F;
	import HLib.IResources.IResourceEvent;
	import tl.core.IResourceKey;
	import HLib.IResources.IResourcePool;
	import HLib.IResources.LoaderManager;
	import HLib.IResources.MyLoader3DManager;
	import HLib.IResources.load.LoaderParam;
	
	import Modules.Common.HKeyboardManager;
	import Modules.Wizard.WizardKey;
	
	import away3DExtend.SkeletonAnimEventProperty;
	import away3DExtend.SkeletonAnimatorExtend;
	import away3DExtend.SkeletonExtend;
	
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.nodes.SkeletonClipNode;
	import away3d.animators.transitions.CrossfadeTransition;
	import away3d.debug.Debug;
	import away3d.events.AnimationStateEvent;
	
	import tool.event.Away3DEvent;
	
	public class WizardAnim extends WizardMesh
	{
		private static var _crossfadeTransition:CrossfadeTransition = new CrossfadeTransition(0.2);
		
		/** 骨骼动作控制器 **/
		public function get skeletonAnimator():SkeletonAnimatorExtend 
		{ 
			return _skeletonAnimator;
		}
		protected var _skeletonAnimator:SkeletonAnimatorExtend;
		private var _animationSet:SkeletonAnimationSet;
		private var _skeleton:SkeletonExtend;
		
		public function get skeleton():SkeletonExtend
		{
			return _skeleton;
		}
		
		protected var _nowAction:String;		//当前正在播放的动作
		public function WizardAnim() 
		{  
			super();  
		}
		
		/** 灰影模型贴图完成以后执行 **/
		override public function UnitInitHuiYing():void
		{
			super.UnitInitHuiYing();
			
			clearSkeletonAnimator();//清理动作管理器，去除所有动作对象也本类的索引		

			var tmpKey:String = LoaderParam.generatePathKey(IResourceKey.huiyingren_role, IResourceKey.Suffix_MD5Mesh, IResourceKey.huiyingren_file);
			//设置骨骼
			_skeleton = IResourcePool.getInstance().getResourceByType(tmpKey, IResourceKey.resType_Skeleton);
			//设置动作数据集
			tmpKey= LoaderParam.generatePathKey(IResourceKey.huiyingren_role, IResourceKey.Suffix_MD5Mesh, IResourceKey.huiyingren_file);
			_animationSet = IResourcePool.getInstance().getResourceByType(tmpKey, IResourceKey.resType_AnimSet);
			
			this.animator = _skeletonAnimator = new SkeletonAnimatorExtend(_animationSet, _skeleton);	
			_skeletonAnimator.addEventListener(SkeletonAnimatorExtend.OCCUR, onOCCUR);
			
			playAction1(_nowAction ? _nowAction: ActionName.stand);
		}
		
		/** 正式贴图加载完成执行 **/
		override protected function onFristResComplete(e:IResourceEvent = null):void
		{
			super.onFristResComplete(e);
			
			var tmpKey:String = LoaderParam.generatePathKey(wizardAction.meshResName, IResourceKey.Suffix_MD5Mesh, _wizardAction.meshResFileName);
			//设置骨骼
			var tmpSkeleton:SkeletonExtend = IResourcePool.getInstance().getResourceByType(tmpKey, IResourceKey.resType_Skeleton);
			
			tmpKey= LoaderParam.generatePathKey(wizardAction.meshResName, IResourceKey.Suffix_MD5Mesh, _wizardAction.meshResFileName);
			//设置动作数据集
			var tmpAnimationSet:SkeletonAnimationSet = IResourcePool.getInstance().getResourceByType(tmpKey, IResourceKey.resType_AnimSet);
			
			clearSkeletonAnimator();//清理动作管理器，去除所有动作对象也本类的索引	
			if(tmpSkeleton && tmpAnimationSet)
			{
				_skeleton = tmpSkeleton;
				_animationSet = tmpAnimationSet;
			}
			else
			{
				if (HKeyboardManager.getInstance().isGM)
				{
					Debug.error("未找到Skeleton或AnimationSet---->ActionId:" + wizardAction.actionID);
				}
			}
			
			this.animator = _skeletonAnimator = new SkeletonAnimatorExtend(_animationSet, _skeleton);	
			_skeletonAnimator.addEventListener(SkeletonAnimatorExtend.OCCUR, onOCCUR);
			
			var tmpA:String = _nowAction;
			_nowAction = "";
			playAction1(tmpA);
			//正式资源加载完成，回头要考虑是不是要再预加载几个动作文件
		}
		
		/** 动作播到爆点以后处理 **/
		private function onOCCUR(e:Away3DEvent):void
		{
			var skeletonAnimEventProperty:SkeletonAnimEventProperty = SkeletonAnimEventProperty(e.data);
			this.dispatchEvent(new Event_F(WizardKey.Action_OccurComplete, skeletonAnimEventProperty.animName)); 
		}
		
		/** 动作加载完成 **/
		private function onSkeletonClipNodeComplete(e:IResourceEvent):void
		{
			//加载完成以后移除事件
			MyLoader3DManager.getInstance().removeEventListener(IResourceEvent.ResourceTaskComplete + nodeName, onSkeletonClipNodeComplete);
			
			var nodeName:String = String(e.data);
			if (e.isFinish)
			{
				//播放当前设定的动作
				var actionArr:Array = nodeName.split("_");
				var str:String = actionArr[ actionArr.length - 1 ];
				
				var tmpNowAction:String = _nowAction;
				_nowAction = "";
				playAction1(tmpNowAction);
			}
		}
		
		private function get nowActioName():String
		{
			if (useFormalRes)
			{
				return _wizardAction.getAnimName(_nowAction);
			}
			return IResourceKey.huiyingren_file + "_" + _nowAction;
		}
		
		private var _curClipNode:SkeletonClipNode;
		/**
		 * 设置当前播放动作
		 * @param value	: 动作播放
		 */		
		protected function playAction1(value:String, isEasing:Boolean = true):void
		{
			if(!value || value == "0" || value == "") 
			{
				value = ActionName.stand;
			}
			if (_nowAction == value)
			{
				return;
			}
			/*
			if (isMainActor)
			{
			this;
			}
			*/
			_nowAction = value;
			
			if (_animationSet == null)
			{
				return;
			}
			
			var tmpActionName:String = nowActioName;
			if(tmpActionName == "0" || !tmpActionName) 
			{
				return;
			}
			
			if (_curClipNode)
			{
				_curClipNode.removeEventListener(AnimationStateEvent.PLAYBACK_COMPLETE, onPlayAttackComplete);	
			}
			_curClipNode = SkeletonClipNode( _animationSet.getAnimation(tmpActionName) );
			if(!_curClipNode)
			{
				var tmpKey:String = LoaderParam.generatePathKey(tmpActionName, IResourceKey.Suffix_MD5Anim, animPath);
				_curClipNode = IResourcePool.getInstance().getResourceByType(tmpKey, IResourceKey.resType_AnimNode );	//从资源池获取一下看看是否已经加载到了
			}
			if(_curClipNode)
			{
				//判断动作资源是否有此动作,把动作添加进去
				if( !_animationSet.hasAnimation(tmpActionName) )
				{
					_animationSet.addAnimation(_curClipNode);
				}
				if(isNotLooping(_nowAction))
				{	
					//清注要在释放的时候清除这个事件
					_curClipNode.looping = false;
					_curClipNode.addEventListener(AnimationStateEvent.PLAYBACK_COMPLETE, onPlayAttackComplete);	
				}
				else
				{
					_curClipNode.looping = true;
				}
				/*
				if( isNotLooping(_nowAction) )
				{
				_crossfadeTransition.blendSpeed = 0.01;
				}
				else
				{
				_crossfadeTransition.blendSpeed = 0.2;
				}
				*/
				/*if (ActionName.walk == tmpActionName || _nowAction == ActionName.walk)
				{
				this;
				}*/
				if (isEasing)
				{
					_skeletonAnimator.play(tmpActionName, _crossfadeTransition, 0); 
				}
				else
				{
					_skeletonAnimator.play(tmpActionName, null, 0); 
				}
			}
			else
			{
				if(!useFormalRes) 
				{
					return;
				}
				
				addLoaderAnimClipNode(tmpActionName);
			}
		}
		
		private function get animPath():String
		{
			return wizardAction ? wizardAction.anim_FileName : IResourceKey.huiyingren_file;_crossfadeTransition;
		}
		
		private var _nowLoaderEvtName:String;
		private function addLoaderAnimClipNode(clipName:String):void
		{
			if (_nowLoaderEvtName)
			{
				MyLoader3DManager.getInstance().removeEventListener(IResourceEvent.ResourceTaskComplete + _nowLoaderEvtName, onSkeletonClipNodeComplete);
			}
			
			_nowLoaderEvtName = clipName;
			MyLoader3DManager.getInstance().addEventListener(IResourceEvent.ResourceTaskComplete + _nowLoaderEvtName, onSkeletonClipNodeComplete);
			MyLoader3DManager.getInstance().addTask(_nowLoaderEvtName, [[wizardAction.anim_FileName, _nowLoaderEvtName, IResourceKey.Suffix_MD5Anim]], 
				null, null, null, isMainActor ? LoaderManager.MUST: LoaderManager.NORMAL);
		}
		
		
		public function stopAction():void
		{
			if (_skeletonAnimator)
			{
				_skeletonAnimator.stop();
			}
		}
		
		/** 动作播放完一次执行 **/
		private function onPlayAttackComplete(e:AnimationStateEvent):void
		{
			if (_skeletonAnimator == null || _skeletonAnimator.activeState != e.animationState) 
			{
				return;
			}
			e.currentTarget.removeEventListener(AnimationStateEvent.PLAYBACK_COMPLETE, onPlayAttackComplete);	
			
			this.dispatchEvent(new Event_F(WizardKey.Action_ActionPlayOver, _nowAction));			
		}
		
		/** 该动作是否重复播放 **/
		private function isNotLooping($actionName:String):Boolean
		{
			if($actionName == ActionName.stand)	
			{
				return false;
			}
			if($actionName == ActionName.run)	
			{
				return false;
			}
			if($actionName == ActionName.ridestand)
			{
				return false;
			}
			if($actionName == ActionName.riderun)
			{
				return false;
			}
			if($actionName == ActionName.walk)	
			{  
				return false;
			}
			
			return true;
		}
		
		private function clearSkeletonAnimator():void
		{
			if (_curClipNode)
			{
				_curClipNode.removeEventListener(AnimationStateEvent.PLAYBACK_COMPLETE, onPlayAttackComplete);	
				_curClipNode = null;
			}
			if(_skeletonAnimator)
			{
				_skeletonAnimator.removeEventListener(SkeletonAnimatorExtend.OCCUR, onOCCUR);
				_skeletonAnimator.dispose();
				_skeletonAnimator = null;
			}
		}
		
		override protected function resetWizardInternal():void
		{
			_nowAction = null;
			useFormalRes = false;
			
			clearSkeletonAnimator();
			animator = null;
			_animationSet = null;
			_skeleton = null;
			if (_nowLoaderEvtName)
			{
				MyLoader3DManager.getInstance().removeEventListener(IResourceEvent.ResourceTaskComplete + _nowLoaderEvtName, onSkeletonClipNodeComplete);
				_nowLoaderEvtName = null;
			}
			
			super.resetWizardInternal();
		}
		
		/** 释放精灵对象 **/
		override public function dispose():void
		{
			_nowAction = null;
			useFormalRes = false;
			
			clearSkeletonAnimator();
			animator = null;
			
			if (_nowLoaderEvtName)
			{
				MyLoader3DManager.getInstance().removeEventListener(IResourceEvent.ResourceTaskComplete + _nowLoaderEvtName, onSkeletonClipNodeComplete);
				_nowLoaderEvtName = null;
			}
			
			super.dispose();
		}
	}
}