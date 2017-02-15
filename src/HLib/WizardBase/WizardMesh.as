package HLib.WizardBase
{
	/**
	 * 静态精灵类(只实现了精灵的加载显示mesh,无动作,动作类请调用WizardAnim.as)
	 * @author 李舒浩
	 */		
	import flash.display.BlendMode;
	
	import HLib.IResources.IResourceEvent;
	import tl.core.IResourceKey;
	import HLib.IResources.IResourcePool;
	import HLib.IResources.LoaderManager;
	import HLib.IResources.MyLoader3DManager;
	import HLib.IResources.load.LoaderParam;
	
	import Modules.Common.HKeyboardManager;
	
	import away3DExtend.MeshExtend;
	
	import away3d.core.base.Geometry;
	import away3d.debug.Debug;
	import away3d.materials.TextureMaterial;
	import away3d.materials.utils.DefaultMaterialManager;
	
	public class WizardMesh extends MeshExtend
	{ 
		public var isMainActor:Boolean = false;
		
		/** action数据 **/
		/*public function set wizardAction(value:WizardAction):void  
		{  
		if (_wizardAction)
		{
		MyLoader3DManager.getInstance().removeEventListener(IResourceEvent.ResourceTaskComplete + _wizardAction.actionID, onFristResComplete);
		}
		_wizardAction = value;
		}*/
		
		public function get wizardAction():WizardAction  
		{
			return _wizardAction;  
		}
		
		protected var _wizardAction:WizardAction;				//精灵动作数据对象
		
		/** 模型贴图 **/
		public function get textureMaterial():TextureMaterial 
		{ 
			return _textureMaterial
		}
		private var _textureMaterial:TextureMaterial;
		
		public var isCastsShadows:Boolean = true;				//是否显示阴影
		public var useFormalRes:Boolean = false;				//是否正在使用正式资源
		
		public function WizardMesh()  
		{  
			material = _textureMaterial = new TextureMaterial(DefaultMaterialManager.defTexture, true, false, true);
			_textureMaterial.alphaPremultiplied = false;
			
			super(Geometry.DEF_GEO, _textureMaterial); 
			
			this.castsShadows = isCastsShadows;
		}
		
		/**设置灰影人动作*/
		public function UnitInitHuiYing():void
		{
			var tmpKey:String = LoaderParam.generatePathKey(IResourceKey.huiyingren_role, IResourceKey.Suffix_MD5Mesh, IResourceKey.huiyingren_file);
			//设置几何数据
			this.geometry = IResourcePool.getInstance().getResourceByType(tmpKey, IResourceKey.resType_MD5Mesh );
			
			tmpKey = LoaderParam.generatePathKey(IResourceKey.huiyingren_m, IResourceKey.Suffix_ATF, IResourceKey.huiyingren_file);
			_textureMaterial.texture = IResourcePool.getInstance().getResourceByType(tmpKey ,IResourceKey.resType_Texture );
		}
		
		/** 执行加载模型 **/
		protected function loadMesh():void
		{
			var fristResArgs:Array = new Array();
			fristResArgs.push([_wizardAction.meshResFileName, _wizardAction.meshResName, IResourceKey.Suffix_MD5Mesh]);
			fristResArgs.push([_wizardAction.materialResFlieName, _wizardAction.materialResName, IResourceKey.Suffix_ATF]);
			if(_wizardAction.anim_Stand != "0")
			{
				fristResArgs.push([ _wizardAction.anim_FileName, _wizardAction.anim_Stand, IResourceKey.Suffix_MD5Anim]);
			}
			if(_wizardAction.anim_Run != "0")
			{
				fristResArgs.push([ _wizardAction.anim_FileName, _wizardAction.anim_Run, IResourceKey.Suffix_MD5Anim]);
			}
			if(_wizardAction.anim_RideStand != "0")
			{
				fristResArgs.push([_wizardAction.anim_FileName, _wizardAction.anim_RideStand,  IResourceKey.Suffix_MD5Anim]);
			}
			if(_wizardAction.anim_RideRun != "0")
			{
				fristResArgs.push([_wizardAction.anim_FileName, _wizardAction.anim_RideRun,  IResourceKey.Suffix_MD5Anim]);
			}
			MyLoader3DManager.getInstance().addEventListener(IResourceEvent.ResourceTaskComplete + _wizardAction.actionID, onFristResComplete);
			MyLoader3DManager.getInstance().addTask("" + _wizardAction.actionID, fristResArgs, null, null, null, 
				isMainActor ? LoaderManager.MUST: LoaderManager.NORMAL);
		}
		
		/** 贴图加载完成 **/
		protected function onFristResComplete(e:IResourceEvent = null):void
		{
			MyLoader3DManager.getInstance().removeEventListener(IResourceEvent.ResourceTaskComplete + _wizardAction.actionID, onFristResComplete);
			//设置几何数据
			var tmpKey:String = LoaderParam.generatePathKey(_wizardAction.meshResName, IResourceKey.Suffix_MD5Mesh, _wizardAction.meshResFileName);
			var tmpGeo:Geometry = IResourcePool.getInstance().getResourceByType(tmpKey, IResourceKey.resType_MD5Mesh );
			if (tmpGeo)
			{
				geometry = tmpGeo;
				tmpKey = LoaderParam.generatePathKey(_wizardAction.materialResName, IResourceKey.Suffix_ATF, _wizardAction.materialResFlieName);
				_textureMaterial.texture = IResourcePool.getInstance().getResourceByType(tmpKey, IResourceKey.resType_Texture);
				
				if (_wizardAction.alphaBlend)
				{
					_textureMaterial.blendMode = "WizardLayer";//"WizardLayer";//BlendMode.LAYER;
					_textureMaterial.alphaBlending = true;
					_textureMaterial.alphaThreshold = 0.01;
				}
				else
				{
					_textureMaterial.alphaThreshold = 0.6;
					_textureMaterial.blendMode = BlendMode.NORMAL;
					_textureMaterial.alphaBlending = false;
				}
				
			}
			else
			{
				if (HKeyboardManager.getInstance().isGM)
				{
					Debug.error("Geometry为空了！---->" + _wizardAction.meshResName);
				}
			}
			
			useFormalRes = true;
		}
		
		private var _isInit:Boolean = false;
		public function initObj():void
		{
			_isInit = true;
			
			if (geometry == null)
			{
				geometry = Geometry.DEF_GEO;
			}
		}
		
		public function resetWizard():void
		{
			if (_isInit)
			{
				_isInit = false;
				
				resetWizardInternal();
			}
		}
		
		protected function resetWizardInternal():void
		{
			isMainActor = false;
			
			MyLoader3DManager.getInstance().removeEventListener(IResourceEvent.ResourceTaskComplete + _wizardAction.actionID, onFristResComplete);
			
			_wizardAction = null;
			useFormalRes = false;

			geometry.disposeForStage3D();
			geometry = null;//Geometry.DEF_GEO;
			_textureMaterial.texture = DefaultMaterialManager.defTexture;
			
			this.visible = true;
			this.identity();
			if (parent)
			{
				parent.removeChild(this);
			}
		}
		
		protected var _isDispose:Boolean = false;
		override public function dispose():void
		{
			_isDispose = true;
			
			if (_wizardAction)
			{
				MyLoader3DManager.getInstance().removeEventListener(IResourceEvent.ResourceTaskComplete + _wizardAction.actionID, onFristResComplete);
			}
			
			_textureMaterial.dispose();
			_textureMaterial = null;
			
			_wizardAction = null;			
			useFormalRes = false;
			
			this.dispose();
		}
	}
}