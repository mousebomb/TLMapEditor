package away3d.animators.transitions
{
	import away3d.animators.IAnimator;
	import away3d.animators.states.SkeletonBinaryLERPState;
	import away3d.events.AnimationStateEvent;

	/**
	 *
	 */
	public class CrossfadeTransitionState extends SkeletonBinaryLERPState
	{
		private var _skeletonAnimationNode:CrossfadeTransitionNode;
		private var _animationStateTransitionComplete:AnimationStateEvent;

		function CrossfadeTransitionState(animator:IAnimator, skeletonAnimationNode:CrossfadeTransitionNode)
		{
			super(animator, skeletonAnimationNode);

			_skeletonAnimationNode = skeletonAnimationNode;
		}

		private var _isOver:Boolean;

		override public function init():void
		{
			_isOver = false;
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateTime(time:int):void
		{
			if (_isOver)
			{
				return;
			}

			blendWeight = Math.abs(time - _skeletonAnimationNode.startBlend) / (1000 * _skeletonAnimationNode.blendSpeed);
			if (blendWeight >= 1)
			{
				_isOver = true;
				blendWeight = 1;
				_skeletonAnimationNode.dispatchEvent(_animationStateTransitionComplete ||= new AnimationStateEvent(AnimationStateEvent.TRANSITION_COMPLETE, _animator, this, _skeletonAnimationNode));
			}
			else
			{

				super.updateTime(time);
			}
		}
	}
}
