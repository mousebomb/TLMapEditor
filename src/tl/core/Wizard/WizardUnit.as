package tl.core.Wizard
{
	/**
	 * 精灵单元
	 */

	import away3DExtend.BindingTag;
	import away3DExtend.SkeletonAnimEventProperty;
	import away3DExtend.SkeletonAnimatorExtend;

	import away3d.materials.TextureMaterial;

	import flash.display.BlendMode;

	import tl.core.old.MyDispatcher;
	import tl.utils.HashMap;

	import tool.event.Away3DEvent;

	public class WizardUnit extends WizardAnim
	{
		public var wizardID:String;	//精灵ID
		public var wizardType:int;		//精灵类型
		public var angle:int;			//旋转角度

		private var _BingAegs:Array=new Array();
		private var _Alpha:Number=1;
//		private var _LightPicker:StaticLightPicker;
		private var _Transparent:Boolean=false;

		public var owner:WizardActor3D;		//父容器

		public function WizardUnit()
		{
			super();
		}
		/**初始化*/
		public function wizardUnitInIt(actionId:String):void{
			this.wizardAction=new WizardAction();
			this.wizardAction.refresh(actionId);
			this.initEvent();
			this.animInIt();
			this.loadRes();
		}
		/**初始化-事件侦听*/
		private function initEvent():void{
			this.addEventListener("MaterialRefreshComplete",onMaterialRefreshComplete);
			this.addEventListener("SkeletonAnimatorRefreshComplete",onSkeletonAnimatorRefreshComplete);
		}
		/**贴图刷新完毕以后发出事件处理贴图灯光效果*/
		private function onMaterialRefreshComplete(e:MyEvent):void{
			MyDispatcher.getInstance().dispatch("MaterialRefreshComplete",this);
			this.dispatchEvent(new MyEvent("WizardLoadComplete"));
			this.bindTableEffect();
		}
		/**动作控制器刷新完毕*/
		private function onSkeletonAnimatorRefreshComplete(e:MyEvent):void{
			if(!this.skeletonAnimator.hasEventListener(SkeletonAnimatorExtend.OCCUR)){
				this.skeletonAnimator.addEventListener(SkeletonAnimatorExtend.OCCUR,onOCCUR);
			}
//			if(wizardAction.actionID == 4041 && int(scenePosition.x)==8901 && int(-scenePosition.z) == 7521)
//			{
//				trace(wizardAction.actionID,"WizardUnit/onSkeletonAnimatorRefreshComplete stand");
//			}
			this.playAction(ActionName.stand);
			if(this.hasEventListener("AnimPlayComplete"))
				this.dispatchEvent(new MyEvent("AnimPlayComplete"));
		}
		/**动作播到爆点以后处理*/
		private function onOCCUR(e:Away3DEvent):void{
			if(!this.skeletonAnimator) return;
			this.skeletonAnimator.removeFrameCallBack(e.data as SkeletonAnimEventProperty);
			this.dispatchEvent(new MyEvent("ActionOccurComplete"));
		}
		/**播放指定动作*/
		public function playAction(actionName:String,timeLength:Number=0):void{
			if(!this.skeletonAnimator) return;
			if(timeLength>0){
				this.skeletonAnimator.addTimeCallBack(new SkeletonAnimEventProperty(this.wizardAction.getAnimName(actionName),timeLength,""));
			}
			this.nowAction=actionName;
		}
		/**
		 * 绑定指定的部件到骨骼
		 * @param skeletonName	: 骨骼名
		 * @param wizardUnit	: 绑定的模型部件
		 */
		public function bindWizardUnitToSkeleton(skeletonName:String, wizardUnit:WizardUnit):void{
			var _Index:int=-1;
			for(var i:int=0;i<_BingAegs.length;i++){
				if(_BingAegs[i][0]==skeletonName&&_BingAegs[i][1]==wizardUnit){
					_Index=1;
				}
			}
			if(_Index>-1) return;
			_BingAegs.push([skeletonName,wizardUnit]);
		}
		/**移除指定的部件*/
		public function removeWizardUnitFromSkeleton(skeletonName:String):WizardUnit{
			var _WizardUnit:WizardUnit
			for(var i:int=0;i<_BingAegs.length;i++){
				if(_BingAegs[i][0]==skeletonName){
					_WizardUnit=_BingAegs[i][1];
					_BingAegs.splice(i,1);
					break
				}
			}
			return _WizardUnit;
		}
		/**让部件随绑定的骨骼动动*/
		public function refreshBindWizardUnit():void{
//			if(_BingAegs.length<1) return;
//			if(!this.skeleton) return;
//			if(!this.skeletonAnimator) return;
//			for(var i:int=0;i<_BingAegs.length;i++){
//				var index:int = this.skeleton.jointIndexFromName(_BingAegs[i][0]);	//获取骨骼位置
//				if(index<0) continue;
//				var bindingTag:BindingTag = this.skeletonAnimator.addBindingTagByIndex(index);
//				if(bindingTag)
//				{
//					bindingTag.addChild(_BingAegs[i][1]);
//				}
//			}
		}
		/**绑定表格配置的特效*/
		private function bindTableEffect():void
		{
			if(!wizardAction) return;

			var effectArr:Array = this.wizardAction.effect_Args;
			if(!effectArr) return;

			var len:int = effectArr.length;
			if(len%3 != 0)
				throw new Error("action表中绑定特效字段为3个一组,当前格式不正确,请检查action表,ID:"+this.wizardAction.actionID);
			if(len < 2) return;
			var wizardEffect:WizardEffect;
			for(var i:int = 0; i < len; i+=3)
			{
				if(effectArr[i]=="0" && effectArr[i+1]=="0") continue;

				wizardEffect = getEffect( effectArr[i+1], effectArr[i] );
				this.bindEffectToSkeleton( effectArr[i+1], wizardEffect, effectArr[i+2] );
			}
		}
		/**
		 * 获得一个特效
		 *  @param packName	: 特效文件名
		 * @param subPath	: 特效包名
		 * @param wolrker	: 是否有移动
		 * @return
		 */
		private function getEffect(packName:String, subPath:String, wolrker:Boolean = false):WizardEffect
		{
			var wizardEffect:WizardEffect;
			var key:String = packName + "/" + subPath;
			wizardEffect = _effectHashMap.get(key);
			if(!wizardEffect)
			{
				wizardEffect = WizardEffectResPool.getInstance().getEffect(packName, subPath);
				this.addChild(wizardEffect);
				if( _addEffectVec.indexOf(wizardEffect) < 0 )
					_addEffectVec.push(wizardEffect);
			}
			wizardEffect.visible = true;
			wizardEffect.play();
			return wizardEffect;
		}
		private var _effectHashMap:HashMap = new HashMap();	//特效保存资源
		private var _addEffectVec:Vector.<WizardEffect> = new Vector.<WizardEffect>();
		/**
		 * 回收一个特效
		 * @param wizardEffect	: 特效精灵
		 */
		private function addEffect(wizardEffect:WizardEffect):void
		{
			var key:String = wizardEffect.effectName;
			if(_isClearWizardUnit)
			{
				//如果_isClearWizardUnit为true说明是被回收掉了,直接回收到对象池中
				if(wizardEffect.parent)
					wizardEffect.parent.removeChild(wizardEffect);
				WizardEffectResPool.getInstance().addEffect( wizardEffect );
				return;
			}
			_effectHashMap.put(key, wizardEffect);
			wizardEffect.visible = false;
			wizardEffect.stop();
			wizardEffect.reset(0);
		}
		/** 回收所有特效资源 **/
		private function removeEffectAll():void
		{
			for each(var wizardEffect:WizardEffect in _addEffectVec)
			{
				if(wizardEffect.parent)
					wizardEffect.parent.removeChild(wizardEffect);
				WizardEffectResPool.getInstance().addEffect( wizardEffect );
			}
			_addEffectVec.length = 0;
		}
		public function clearWizardUnit():void{
			owner = null;
//			this.lightPicker=null;
			_BingAegs.length=0;
			this.clearWizardAnim();
			//回收特效
			removeEffectAll();
		}
		/**贴图是否混合*/
		public function get transparent():Boolean
		{
			return _Transparent;
		}
		/**贴图是否混合*/
		public function set transparent(value:Boolean):void
		{
			if(!this.material) return;
			_Transparent = value;
			if(_Transparent){
				TextureMaterial(this.material).alphaBlending=true;
				this.material.blendMode = BlendMode.ADD;
			}else{
				TextureMaterial(this.material).alphaBlending=false;
				this.material.blendMode = BlendMode.NORMAL;
			}
		}
		/**贴图的透明度*/
		public function get alpha():Number
		{
			return _Alpha;
		}
		/**贴图的透明度*/
		public function set alpha(value:Number):void
		{
			_Alpha = value;
			if(this.material){
				TextureMaterial(this.material).alphaBlending=true;
				TextureMaterial(this.material).alpha=_Alpha;
			}
		}
		/**贴图及部件贴图的灯光渲染器*/
//		public function get lightPicker():StaticLightPicker
//		{
//			return _LightPicker;
//		}
		/**贴图及部件贴图的灯光渲染器*/
//		public function set lightPicker(value:StaticLightPicker):void
//		{
//			_LightPicker = value;
//			if(this.material){
//				this.material.lightPicker=_LightPicker;
//			}
//		}

		override public function set rotationY(val:Number):void
		{
			angle = val;
			super.rotationY = val;
		}
	}
}