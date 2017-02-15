package HLib.UICom.Away3DUICom
{
	/**
	 * Away3D进度条类
	 * @author 李舒浩
	 * 
	 * </br>用法：
	 * </br>	var progressBar3D:HProgressBar3D = new HProgressBar3D();
	 * </br>	progressBar3D.setDefaultSkin();
	 * </br>	progressBar3D.init(100, 100, 7);
	 * </br>	this.addChild(progressBar3D);
	 * </br>PS:添加到模型或某容器后,如果需要一直面向这镜头,类似sprite3D那种效果,需要通过摄像机的旋转角度做计算,如:
	 * </br>
	 * </br>progressBar3D.rotationY = HMap3D.getInstance().myCamera3D.rotationY - 父容器.rotationY;
	 * </br>
	 * @see Modules.Wizard.NameBar.WizardNameBar
	 */	
	import tl.core.IResourceKey;
	import HLib.IResources.IResourcePool;
	import HLib.IResources.load.LoaderParam;
	import HLib.UICom.BaseClass.HSprite3D;
	
	import Modules.Map.HMap3D;
	import Modules.Map.HMapSources;
	import Modules.Wizard.WizardKey;
	import Modules.Wizard.WizardObject;
	
	import away3DExtend.MeshExtend;
	
	import away3d.materials.TextureMaterial;
	import away3d.materials.utils.DefaultMaterialManager;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.Texture2DBase;
	
	public class HProgressBar3D extends HSprite3D
	{
		private var _downMesh:MeshExtend;	//背景图
		private var _upMesh:MeshExtend;	//血条mesh
		
		private var _downMaterial:TextureMaterial;
		private var _upMaterial:TextureMaterial;
		
		private var _max:Number = 100;	//进度条最大值
		private var _now:Number = 100;	//进度条当前值
		
		private var _offX:int = 3;	//进度条X偏移值
		
		private var _wizardObj:WizardObject;
		
		public function HProgressBar3D() 
		{  
			super();  
		}
		
		/**
		 * 初始化
		 * @param $max			: 进度条最大值
		 * @param $now			: 进度条当前值
		 * @param $excursionX	: 进度条X偏移值
		 * @param $excursionY	: 进度条Y偏移值
		 */		
		public function init():void
		{
			_downMaterial = new TextureMaterial(DefaultMaterialManager.defTexture, true, false, false);
			_upMaterial = new TextureMaterial(DefaultMaterialManager.defTexture, false, false, false);
			_downMaterial.alphaBlending = true;
			_downMaterial.alphaPremultiplied = false;
			_upMaterial.alphaPremultiplied = false;
			_upMaterial.alphaThreshold = 0.5;
			
			_downMesh = new MeshExtend(DEF_DOWN_GEO, _downMaterial);
			_upMesh = new MeshExtend(DEF_UP_GEO, _upMaterial);
			
			_upMesh.y = 0.01;
			_offX = 2;
			
			this.addChild(_downMesh);
			this.addChild(_upMesh);
			
			this.myWidth = 84;
			
			updateProgressBar();
		}
		
		/**
		 * 设置默认皮肤
		 */		
		public function setDefaultSkin(wizardObj:WizardObject):void
		{
			if (_wizardObj)
			{
				_wizardObj.propMonitor.removeMonitor(updateSkin);
			}
			
			_wizardObj = wizardObj;
			_wizardObj.propMonitor.addMonitor("Player_Camp", updateSkin);
			_wizardObj.propMonitor.addMonitor("Player_PKModle", updateSkin);
			
			updateSkin();
		}
		
		private function updateSkin():void
		{
			var tmpKey:String = LoaderParam.generatePathKey(hpUpName, IResourceKey.Suffix_ATF, "mainUI");
			var upTexture:Texture2DBase = IResourcePool.getInstance().getResourceByType(tmpKey, IResourceKey.resType_Texture);
			
			tmpKey = LoaderParam.generatePathKey(hpDownName, IResourceKey.Suffix_ATF, "mainUI");
			var downTexture:Texture2DBase = IResourcePool.getInstance().getResourceByType(tmpKey, IResourceKey.resType_Texture);
			
			setSkin(downTexture, upTexture);
		}
		
		private function get hpDownName():String
		{
			if (_wizardObj.type == WizardKey.TYPE_5)
			{
				return "small_boss_hp_down";
			}
			else if (_wizardObj.type == WizardKey.TYPE_16)
			{
				return "bag_boss_hp_down";
			}
			return "MainUI_Hp_Down";
		}
		
		private function get hpUpName():String
		{
			var mainActorObj:WizardObject = HMapSources.getInstance().mainWizardObject;
			if (_wizardObj.type == WizardKey.TYPE_16)
			{
				return "bag_boss_hp_up";
			}
			else if ( _wizardObj.type == WizardKey.TYPE_5)
			{
				return "hero_hp_up_4";
			}
			else if (_wizardObj.isMainActor)
			{
				return "hero_hp_up_1";
			}
			else if (HMap3D.getInstance().isMeleeScene && _wizardObj.type == WizardKey.TYPE_0)
			{
				return "hero_hp_up_4";
			}
			else if (!_wizardObj.Player_Camp)
			{
				return "hero_hp_up_4";
			}
			else if (_wizardObj.Player_Camp == mainActorObj.Player_Camp)
			{
				return "hero_hp_up_2";
			}
			else 
			{
				if (_wizardObj.type == WizardKey.TYPE_0)
				{
					if (_wizardObj.Player_PKModle || mainActorObj.Player_PKModle)
					{
						return "hero_hp_up_4";
					}
					else
					{
						return "hero_hp_up_3";
					}
				}
				else
				{
					return "hero_hp_up_4";
				}
			}
			return "hero_hp_up_4";
		}
		
		private static const DEF_DOWN_GEO:PlaneGeometry = new PlaneGeometry(90, 10);
		private static const DEF_UP_GEO:PlaneGeometry = new PlaneGeometry(88, 9);
		
		private static const NORMAL_DOWN_GEO:PlaneGeometry = new PlaneGeometry(90, 18);
		private static const NORMAL_UP_GEO:PlaneGeometry = new PlaneGeometry(86, 18);
		
		private static const SMALL_BOSS_DOWN_GEO:PlaneGeometry = new PlaneGeometry(128, 30);
		private static const SMALL_BOSS_UP_GEO:PlaneGeometry = new PlaneGeometry(88, 14);
		
		private static const BIG_BOSS_DOWN_GEO:PlaneGeometry = new PlaneGeometry(256, 55);
		private static const BIG_BOSS_UP_GEO:PlaneGeometry = new PlaneGeometry(225, 12);
		
		/**
		 * 设置皮肤
		 * @param downBtmd	: 血条背景
		 * @param upBtmd	: 血条
		 */		
		public function setSkin(downTexture:Texture2DBase, upTexture:Texture2DBase):void
		{
			_downMaterial.texture = downTexture;
			_upMaterial.texture = upTexture;
			
			if (_wizardObj.type == WizardKey.TYPE_5)
			{
				_offX = 4;
				_upMesh.z = -1;
				
				_downMesh.geometry = SMALL_BOSS_DOWN_GEO;
				_upMesh.geometry = SMALL_BOSS_UP_GEO;
				
				this.myWidth = 88;
			}
			else if (_wizardObj.type == WizardKey.TYPE_16)
			{
				_offX = 0;
				_upMesh.z = -1;
				
				_downMesh.geometry = BIG_BOSS_DOWN_GEO;
				_upMesh.geometry = BIG_BOSS_UP_GEO;
				
				this.myWidth = 220;
			}
			else
			{
				_offX = 0;
				_upMesh.z = 0;
				/*
				_downGeo.width = 88;
				_upGeo.width = 84;
				*/
				
				_downMesh.geometry = NORMAL_DOWN_GEO;
				_upMesh.geometry = NORMAL_UP_GEO;
				
				this.myWidth = 84;
			}
			
			updateProgressBar();
		}
		
		/**
		 * 设置最大值
		 * @param value	: 
		 */
		public function set max(value:Number):void
		{
			if(_max == value)
			{
				return;
			}
			if(value < 0) 
			{
				value = 0;
			}
			_max = value;
			updateProgressBar();
		}
		
		public function get max():Number  
		{ 
			return _max;  
		}
		
		/**
		 * 设置当前值
		 * @param value
		 */		
		public function set now(value:Number):void
		{
			if(_now == value)
			{
				return;
			}
			if(value < 0)
			{
				value = 0;
			}
			else if(value > _max) 
			{
				value = _max;
			}
			_now = value;
			
			updateProgressBar();
		}
		public function get now():Number 
		{ 
			return _now; 
		}
		
		/** 更新进度条显示 **/
		private function updateProgressBar():void
		{
			//计算出要缩短的值
			var u:Number = _max == 0 ? 0 : _now / _max;
			if(u == 0) 
			{
				_upMesh.visible = false;
				return;
			}
			u = Math.max(Math.min(u, 1), 0);
			_upMesh.visible = true;
			_upMesh.scaleX = u;
			
			_upMesh.x = _offX - (this.myWidth - this.myWidth * u) / 2;
		}
		
		/**
		 * 设置透明值
		 * @param value	: 透明值
		 */		
		public function set alpha(value:Number):void
		{
			_alpha = value;
			if(_downMaterial)
			{
				_downMaterial.alpha = value;
			}
			if(_upMaterial)
			{
				_upMaterial.alpha = value;
			}
		}
		
		public function get alpha():Number
		{
			return _alpha;
		}
		
		private var _alpha:Number = 1;
		
		public function clearHPBar3D():void
		{
			this.identity();
			
			alpha = 1;
			_max = 100;
			_now = 100;
			//			_excursionX = 4;
			//			_excursionY = 0;
			_upMesh.scaleX = 1;
			if (_wizardObj)
			{
				_wizardObj.propMonitor.removeMonitor(updateSkin);
			}
			_wizardObj = null;
			
			updateProgressBar();
			
			this.visible = true;
			if (parent)
			{
				parent.removeChild(this);
			}
		}
		
		public function disposeHPBar3D():void
		{
			_downMesh.dispose();
			_upMesh.dispose();
			
			if (_wizardObj)
			{
				_wizardObj.propMonitor.removeMonitor(updateSkin);
			}
			_wizardObj = null;
			
			_downMaterial.dispose();
			_upMaterial.dispose();
			
			_downMesh = null;
			_upMesh = null;
			_downMaterial = null;
			_upMaterial = null;
			
			dispose();
		}
	}
}