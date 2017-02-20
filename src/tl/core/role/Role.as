/**
 * Created by gaord on 2016/12/27.
 */
package tl.core.role
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.pick.PickingColliderType;

	import tl.core.old.WizardAction;

	import tl.core.old.WizardObject;

	import tl.core.role.model.RoleVO;

	import tool.StageFrame;

	/**
	 * 角色
	 * 多个角色模型 各个部分组合
	 * 代替原来的WizardActor3D
	 * */
	public class Role extends ObjectContainer3D
	{
		public static var statsNumInstance:int = 0;


		/**初始显示倍数*/
		private var _scaleInIt:Number;

		private var _bodyUnit:RoleMesh;//主体部件
		private var _wingUnit:RoleMesh;//翅膀部件
		private var _mountUnit:RoleMesh;//坐骑部件
		private var _leftArmsUnit:RoleMesh;//左手武器部件
		private var _rightArmsUnit:RoleMesh;//右手武器部件
		private var _wizardUnitVec:Vector.<RoleMesh> = new Vector.<RoleMesh>();			//模型管理数组Vec

		public function Role()
		{
			super();
			++statsNumInstance;
			track("Role/Role 创建角色", statsNumInstance);
		}

		// TODO 换成RoleVO
		protected var _vo:WizardObject;

		public function get vo():WizardObject
		{
			return _vo;
		}

		/** 从数据初始化 */
		public function actor3DInIt(vo:WizardObject):void
		{
			if (_vo)
			{
				throw new Error("不可重复actor3DInIt");
			}
			// 存入数据
			_vo = vo;
			track("Role/actor3DInIt");
			// 初始化body ，加入信息，开始加载，但并不一定显示
			_bodyUnit = new RoleMesh();
			addChild(_bodyUnit);
			_bodyUnit.init(vo.resId);
		}

		/** 释放资源 清空所有状态以便回收 */
		public function clearRole():void
		{
			_vo = null;
			// body 总归需要 只释放
			_bodyUnit.clear();
			// 翅膀啥的释放 并置空
			track("Role/clearRole");
			disposeWithChildren();
		}

		/** 主体部件 **/
		public function get bodyUnit():RoleMesh
		{
			return _bodyUnit;
		}

		/** 翅膀部件 **/
		public function get wingUnit():RoleMesh
		{
			return _wingUnit;
		}

		/** 坐骑部件 **/
		public function get mountUnit():RoleMesh
		{
			return _mountUnit;
		}

		/** 左手武器部件 **/
		public function get leftArmsUnit():RoleMesh
		{
			return _leftArmsUnit;
		}

		/** 右手武器部件 **/
		public function get rightArmsUnit():RoleMesh
		{
			return _rightArmsUnit;
		}


		private var _mouseInteractive:Boolean =false;


		public function get mouseInteractive():Boolean
		{
			return _mouseInteractive;
		}

		public function set mouseInteractive(value:Boolean):void
		{
			_mouseInteractive = value;
			_bodyUnit.mouseEnabled = this.mouseEnabled = value;
		}
	}
}
