/**
 * Created by gaord on 2016/12/26.
 */
package tl.core.role
{
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.data.JointPose;
	import away3d.animators.transitions.CrossfadeTransition;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Object3D;
	import away3d.core.pick.PickingColliderType;
	import away3d.entities.Entity;
	import away3d.entities.Mesh;
	import away3d.library.assets.IAsset;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.CubeGeometry;

	import flash.geom.Matrix3D;
	import flash.utils.Dictionary;

	import tl.core.GPUResProvider;
	import tl.core.LightProvider;
	import tl.core.Wizard.ActionName;

	import tool.StageFrame;

	/**
	 * 角色模型 部件
	 * 基础模型显示和动画
	 * 对应原来 WizardUnit
	 * */
	public class RoleMesh extends ObjectContainer3D
	{
		/** 统计实例数量 */
		public static var statsNumInstance:int                      = 0;
		/** 过渡 */
		private static var _crossfadeTransition:CrossfadeTransition = new CrossfadeTransition(0.2);

		public function RoleMesh()
		{
			super();
			++statsNumInstance;
			track("RoleMesh/RoleMesh 当前实例数：", statsNumInstance);
		}

		private var _resId:String;

		/** 初始化入口 */
		public function init(resId:String):void
		{
			_resId = resId;
			GPUResProvider.getInstance().getAWD(_resId, onAWDLoadedCb);
			StageFrame.addActorFun(validatePoses);
		}

		/** 释放资源和状态 以便回收 */
		public function clear():void
		{
			_resId  = null;
			_curAct = "";
			bindIndexByUnit = new Dictionary();
			StageFrame.removeActorFun(validatePoses);
		}


		private function onAWDLoadedCb(resId:String, assets:Vector.<IAsset>):void
		{
			// 防止请求多次回调(回收再用等），只关心当前我的resId
			if (resId == _resId)
			{
				for (var i:int = 0; i < assets.length; i++)
				{
					var asset:IAsset = assets[i];
					if (asset is Entity)
					{

						var cloned:Entity = (asset as Entity).clone()  as Entity;
						this.addChild( cloned );
						if(cloned is Mesh)
						{
							skeletonAnimator = (cloned as Mesh).animator as SkeletonAnimator;
						}
					}

				}
				// // TODO del debug only
//				playAction("run");
				var sward :Mesh = new Mesh(new CubeGeometry(10,10,50));
				bindToJoint(sward , "lefthand");
				parent.addChild(sward);
				// TODO ENDOF debug only
				// 恢复要进行的动作
				validateAction();
				//
				mouseEnabled = _mouseEnabled;
				showBounds = _showBounds;
			}
		}


		// #pragma mark --  动作相关		  ------------------------------------------------------------

		public var skeletonAnimator:SkeletonAnimator;

		/** 当前动作 */
		private var _curAct:String = ActionName.stand;

		public function playAction(newAct:String, fade:Boolean = true):void
		{
			if (_curAct == newAct)
				return;
			_curAct = newAct;
			validateAction(fade);
		}

		private function validateAction(fade:Boolean = true):void
		{
			if (skeletonAnimator==null || skeletonAnimator.animationSet == null)
			{
				// MESH 尚未获得时，只提前要求加载，不回调
//				GPUResProvider.getInstance().getWizardAnim(nowActioName, _vo.anim_FileName, _curAct, null);
				return;
			}
			if (skeletonAnimator.animationSet.hasAnimation(_curAct))
			{
				// 动作存在，播放
				skeletonAnimator.play(_curAct, fade ? _crossfadeTransition : null);
			} else
			{
			}
		}

		// #pragma mark --  绑定相关  ------------------------------------------------------------
		private static var tmpMatrix:Matrix3D = new Matrix3D();

		/** 绑定对象到骨骼动画 */
		public function bindToJoint( unit :Object3D , jointName:String ):void
		{
			var bindJointIndex :int = skeletonAnimator.skeleton.jointIndexFromName(jointName);
			if(bindJointIndex>-1)
			{// 只有绑定得到，才记录绑定
				bindIndexByUnit[unit] = bindJointIndex;
			}
		}

		public function unbindToJoint(unit:Object3D):void
		{
			delete bindIndexByUnit[unit];
		}
		/** 所有绑定关节的对象   */
		protected var bindIndexByUnit :Dictionary = new Dictionary();

		/** 定时更正角度显示 */
		private function validatePoses():void
		{
			if( skeletonAnimator && skeletonAnimator.globalPose.jointPoses.length)
			{
				for(var unit : Object3D in bindIndexByUnit)
				{
					var bindJointIndex:int = bindIndexByUnit[unit];
					var jointPose :JointPose = skeletonAnimator.globalPose.jointPoses[bindJointIndex];
					jointPose.toMatrix3D(tmpMatrix);
					unit.transform = tmpMatrix;
				}
			}
		}


		// #pragma mark --  选中  ------------------------------------------------------------
		private var _showBounds:Boolean = false;
		public function set showBounds(showBounds:Boolean):void
		{
			_showBounds = showBounds;
			for (var i:int = 0; i < numChildren; i++)
			{
				(getChildAt(i) as Entity).showBounds = _showBounds;
			}
		}

		public function get showBounds():Boolean
		{
			return _showBounds;
		}


		override public function set mouseEnabled(value:Boolean):void
		{
			super.mouseEnabled = value;
			for (var i:int = 0; i < numChildren; i++)
			{
				var mesh :Mesh = getChildAt(i) as Mesh;
				if(mesh )
					mesh.mouseEnabled = value;
			}
		}
	}
}
