package away3d.animators.nodes
{
	import away3d.animators.AnimatorBase;
	import away3d.animators.states.AnimationStateBase;
	import away3d.library.assets.AssetType;
	import away3d.library.assets.IAsset;
	import away3d.library.assets.NamedAssetBase;

	/**
	 * Provides an abstract base class for nodes in an animation blend tree.
	 */
	public class AnimationNodeBase extends NamedAssetBase implements IAsset
	{
		protected var _stateClass:Class;
		private var _stateObj:AnimationStateBase;

		public function get stateClass():Class
		{
			return _stateClass;
		}

		public function getState(animator:AnimatorBase, node:AnimationNodeBase):AnimationStateBase
		{
			_stateObj ||= new stateClass(animator, node);
			_stateObj.init();
			return _stateObj;
		}

		/**
		 * Creates a new <code>AnimationNodeBase</code> object.
		 */
		public function AnimationNodeBase()
		{
		}

		/**
		 * @inheritDoc
		 */
		public function dispose():void
		{
			this._stateClass = null;
			this.name = null;
		}

		/**
		 * @inheritDoc
		 */
		public function get assetType():String
		{
			return AssetType.ANIMATION_NODE;
		}
	}
}
