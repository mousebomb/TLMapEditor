package away3DExtend
{
	/**
	 * SkeletonAnimator扩展类
	 * @author 李舒浩
	 */	
	import away3d.arcane;
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.data.Skeleton;
	import away3d.animators.nodes.SkeletonClipNode;
	
	import tool.event.Away3DEvent;
	
	use namespace arcane;
	
	public class SkeletonAnimatorExtend extends SkeletonAnimator
	{
		/** 每一帧执行派发的事件,事件类型 Away3DEvent **/
		////		public static const UPDATEBYFRAME:String = "updateByFrame";
		/** 到达指定时间后执行的派发事件,事件类型 Away3DEvent **/
		public static const OCCUR:String = "occur";
		
		private var _animationSetId:String;
		private var _eventPropertyIndex:int = -1;
		
		private var _eventPropertyVec:Vector.<SkeletonAnimEventProperty> = new Vector.<SkeletonAnimEventProperty>();
		private var _eventPropertyNameVec:Vector.<String> = new Vector.<String>();
		
		public function SkeletonAnimatorExtend(animationSet:SkeletonAnimationSet, skeleton:Skeleton, forceCPU:Boolean=false)
		{
			super(animationSet, skeleton, forceCPU);
			//_animationSetId=MyAway3DClock.instance.addCallBack(animationSet.name,this.clearAnimationStates);
		}
		override protected function updateDeltaTime(dt:Number):void
		{
			super.updateDeltaTime(dt);
			
			if(!this.hasEventListener(SkeletonAnimatorExtend.OCCUR))
			{
				return;
			}
			if(_eventPropertyVec.length == 0)
			{
				return;
			}
			
			if (_eventPropertyIndex < 0)
			{
				_startTime = _playTime;
				_eventPropertyIndex = this.getSkeletonAnimEventPropertyIndex(_activeAnimationName);
			}
			if(_eventPropertyIndex < 0)
			{
				return;
			}
			
			//********判断时间是否要在指定
			var total:uint= SkeletonClipNode(_animationSet.getAnimation(_activeAnimationName)).totalDuration;	//动作的总时间
			var nowTime:uint = _playTime - _startTime;		//当前动作播放到的时间
			//循环计算执行派发事件
			if(_eventPropertyVec[_eventPropertyIndex].occurTime - nowTime <= 0)
			{
				this.dispatchEvent(new Away3DEvent(SkeletonAnimatorExtend.OCCUR, _eventPropertyVec[_eventPropertyIndex]));
				_eventPropertyIndex = -1;
			}
		}
		
		private var _startTime:uint;
		
		/** 添加时间回调 **/
		public function addTimeCallBack(property:SkeletonAnimEventProperty):void
		{
			if(hasCallBack(property))
			{
				return;
			}
			_eventPropertyVec.push(property);
			_eventPropertyNameVec.push(property.animName);
		}
		
		/** 移除时间回调 **/
		public function removeFrameCallBack(property:SkeletonAnimEventProperty):void
		{
			if(_eventPropertyVec.length == 0) 
			{
				return;
			}
			var _index:int=_eventPropertyVec.indexOf(property);
			if(_index < 0) 
			{
				return;
			}
			_eventPropertyVec.splice(_index, 1);
			_eventPropertyNameVec.splice(_index, 1);
		}
		
		/** 判断是否有时间回调 **/
		public function hasCallBack(property:SkeletonAnimEventProperty):Boolean
		{
			if(_eventPropertyVec.length == 0) 
			{
				return false;
			}
			var _index:int = _eventPropertyNameVec.indexOf(property.animName);
			if(_index < 0)
			{
				return false;
			}
			return true;
		}
		
		/** 判断是否有时间回调 **/
		public function hasTimeCallBack(animName:String):Boolean
		{
			if(_eventPropertyVec.length == 0) 
			{
				return false;
			}
			var _index:int = _eventPropertyNameVec.indexOf(animName);
			if(_index < 0)
			{
				return false;
			}
			return true;
		}
		
		/** 获得回调的事件对象 **/
		public function getSkeletonAnimEventPropertyIndex(animName:String):int
		{
			if(_eventPropertyVec.length == 0)
			{
				return -1;
			}
			var _index:int = _eventPropertyNameVec.indexOf(animName);
			return _index;
		}
		
		override public function dispose():void
		{
			_eventPropertyVec = null;
			_eventPropertyNameVec = null;
			
			super.dispose();
		}
	}
}