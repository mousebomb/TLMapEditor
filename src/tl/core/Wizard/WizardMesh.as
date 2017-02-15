package tl.core.Wizard
{
	/**
	 * 静态精灵类(只实现了精灵的加载显示mesh,无动作,动作类请调用WizardAnim.as)
	 * @author 李舒浩
	 */

	import away3DExtend.MeshExtend;
	import away3DExtend.SkeletonExtend;

	import away3d.animators.SkeletonAnimationSet;
	import away3d.core.base.Geometry;
	import away3d.materials.TextureMaterial;

	import tl.IResources.IResourceEvent;
	import tl.IResources.IResourceKey;
	import tl.IResources.IResourceLoader3D;
	import tl.IResources.IResourcePool;
	import tl.core.GPUResProvider;
	import tl.core.old.WizardAction;

	import tool.Away3DConfig;

	public class WizardMesh extends MeshExtend
	{ 
		private var _SkeletonAnimationSet:SkeletonAnimationSet;//动作数据集
		private var _Skeleton:SkeletonExtend;			//骨骼
		private var _WizardAction:WizardAction;		//精灵动作数据对象
		private var _Loader3D:IResourceLoader3D;
		
		private var _textureMaterial:TextureMaterial;	//模型贴图
		
		protected var _isClearWizardUnit:Boolean = false;
		
		public function WizardMesh()  
		{  
			_textureMaterial = new TextureMaterial(Away3DConfig.initTexture_1x1, true, false, false);
			super(new Geometry(), _textureMaterial); 
		}
		
		/** 初始化方法 **/
		public function meshReset():void
		{			
			_Loader3D=new IResourceLoader3D();
			_Loader3D.addEventListener(IResourceEvent.MeshComplete,onMeshComplete);
			_Loader3D.addEventListener(IResourceEvent.SkeletonAnimationSetComplete, onSkeletonAnimationSetComplete);
			_Loader3D.addEventListener(IResourceEvent.SkeletonComplete, onSkeletonComplete);
		}
		public function loadMesh():void{
			if(!_WizardAction) return;
			if(this.wizardAction.meshResName!="0"){
				GPUResProvider.getInstance().getWizardMesh(_WizardAction.meshResName,_WizardAction.meshResFileName,onMeshCompleteCb);
				_Loader3D.myLoad(_WizardAction.meshResName,_WizardAction.meshResFileName,IResourceKey.Suffix_Mesh);	
			}
		}

		private function onMeshCompleteCb():void
		{
			this;
		}
		/**
		 * 设置数据
		 * @param value	: 模型数据
		 */		
		public function set wizardAction(value:WizardAction):void
		{
			_WizardAction = value;

		}
		public function get wizardAction():WizardAction  {  
			return _WizardAction;  
		}
		
		/** 
		 * 清除方法
		 * 当不需要用此模型释放时需要调用此方法
		 **/
		public function clearWizardMesh():void
		{
			if(_Loader3D){
				_Loader3D.removeEventListener(IResourceEvent.MeshComplete,onMeshComplete);
				_Loader3D=null;
			}
//			if(this.material)
//				this.material.lightPicker=null;
			_WizardAction = null;
			_SkeletonAnimationSet=null;
			_Skeleton=null;
		}
		
		/**
		 * 加载贴图完成
		 * @return 	: 是否当前所需加载完成
		 */	
		protected function onMaterialComplete(e:IResourceEvent):void
		{	
			if(_Loader3D){
				_Loader3D.removeEventListener(IResourceEvent.Error,onError);
				_Loader3D.removeEventListener(IResourceEvent.MaterialComplete,onMaterialComplete);
			}
			if(!_WizardAction) return;
			//获取位图资源
//			var _TextureMaterial:TextureMaterial = new TextureMaterial(IResourcePool.getInstance().getResource(_WizardAction.materialResName+IResourceKey.Suffix_TextureMaterial));
//			_TextureMaterial.alphaBlending=false;
//			_TextureMaterial.alphaThreshold = 0.6;
//			this.material = _TextureMaterial;
			_textureMaterial.texture = IResourcePool.getInstance().getResource(_WizardAction.materialResName+IResourceKey.Suffix_TextureMaterial);
			_textureMaterial.alphaBlending = false;
			_textureMaterial.alphaThreshold = 0.6;
			this.material = _textureMaterial;

			this.dispatchEvent(new MyEvent("MaterialRefreshComplete"));
		}
		/**
		 * 加载mesh完成
		 * @return 	: 是否当前所需加载完成
		 */		
		protected function onMeshComplete(e:IResourceEvent):void
		{	
			if(_Loader3D){
				_Loader3D.removeEventListener(IResourceEvent.MeshComplete,onMeshComplete);
			}
			this.geometry =IResourcePool.getInstance().getResource(_WizardAction.meshResName+IResourceKey.Suffix_Mesh).geometry;
//			_textureMaterial = new TextureMaterial(Away3DConfig.initTexture_32x32);
//			_textureMaterial.alphaBlending = true;
			this.material = _textureMaterial;
//			this.material = new TextureMaterial(new BitmapTexture(new BitmapData(32,32,true,0x0)));
			//_WizardMesh=IResourcePool.getInstance().getResource(_WizardAction.meshResName+ResKey.Suffix_Mesh).clone()			

			_Skeleton=IResourcePool.getInstance().getResource(_WizardAction.meshResName+IResourceKey.Suffix_Skeleton);
			_SkeletonAnimationSet=IResourcePool.getInstance().getResource(_WizardAction.meshResName+IResourceKey.Suffix_SkeletonAnimationSet);
			if(_SkeletonAnimationSet){
				this.dispatchEvent(new MyEvent("SkeletonRefreshComplete"));
			}
			//加载贴图
			if(this.wizardAction.materialResName!="0"){
				_Loader3D=new IResourceLoader3D();
				_Loader3D.addEventListener(IResourceEvent.Error,onError);
				_Loader3D.addEventListener(IResourceEvent.MaterialComplete,onMaterialComplete);
				_Loader3D.myLoad(_WizardAction.materialResName,_WizardAction.materialResFlieName,IResourceKey.Suffix_Material);
			}
		}
		
		private function onError(e:IResourceEvent):void
		{
			this.dispatchEvent(new MyEvent("MaterialRefreshComplete"));
		}
		
		private function onSkeletonComplete(e:IResourceEvent):void{
			if(_Loader3D){
				_Loader3D.removeEventListener(IResourceEvent.SkeletonComplete, onSkeletonComplete);
			}
			if(!_WizardAction) return;
			_Skeleton=IResourcePool.getInstance().getResource(_WizardAction.meshResName+IResourceKey.Suffix_Skeleton);
		}
		private function onSkeletonAnimationSetComplete(e:IResourceEvent):void{
			if(_Loader3D){
				_Loader3D.removeEventListener(IResourceEvent.SkeletonAnimationSetComplete, onSkeletonAnimationSetComplete);
			}
			if(!_WizardAction) return;
			_SkeletonAnimationSet=IResourcePool.getInstance().getResource(_WizardAction.meshResName+IResourceKey.Suffix_SkeletonAnimationSet);
			this.dispatchEvent(new MyEvent("SkeletonRefreshComplete"));
		}
		public function getIResourceLoader3D():IResourceLoader3D
		{
			return new IResourceLoader3D();
		}

		public function get skeletonAnimationSet():SkeletonAnimationSet
		{
			return _SkeletonAnimationSet;
		}

		public function get skeleton():SkeletonExtend
		{
			return _Skeleton;
		}
		public function get loader3D():IResourceLoader3D
		{
			return _Loader3D;
		}

		public function set loader3D(value:IResourceLoader3D):void
		{
			_Loader3D = value;
		}
	}
}