package tl.core
{
import away3d.lights.DirectionalLight;
import away3d.lights.PointLight;
import away3d.lights.shadowmaps.NearDirectionalShadowMapper;
import away3d.materials.lightpickers.StaticLightPicker;
import away3d.materials.methods.FilteredShadowMapMethod;
	import away3d.primitives.SkyBox;
	import away3d.textures.BitmapCubeTexture;

	import flash.geom.Vector3D;

public class LightProvider
	{
		private static var _lightManager:LightProvider;
		
		/** 阳光光线 **/
		private var _sunLight:DirectionalLight;
		
		/** 阴影光源 **/
		public function get shadowMapMethod():FilteredShadowMapMethod
		{ 
			return _shadowMapMethod;
		}
		
		private var _shadowMapMethod:FilteredShadowMapMethod;

	private var _skybox :SkyBox;

	/** 阳光 **/
		public function get lightPicker():StaticLightPicker 
		{  
			return _lightPicker;
		}
		private var _lightPicker:StaticLightPicker;
		
		/** 点光源 **/
		private var _pointLight:PointLight;
		
	
		public function LightProvider()
		{
			init();
		}
		
		public static function getInstance():LightProvider
		{
			_lightManager ||= new LightProvider();
			return _lightManager;
		}


		private function init():void
		{
			var baseShadowMethod:NearDirectionalShadowMapper = new NearDirectionalShadowMapper();
			baseShadowMethod.depthMapSize = 2048;	//深度贴图尺寸
			baseShadowMethod.lightOffset = 5000;
			
			//点光源
			_pointLight = new PointLight();
			//平行光
			_sunLight = new DirectionalLight(-1, -1, -1);
			_sunLight.shadowMapper = baseShadowMethod;				//阴影映射
			_sunLight.direction = new Vector3D(-0.2, -0.78, -0.2);      //光源角度
//			var softShadowMapMethod:SoftShadowMapMethod = new SoftShadowMapMethod(_sunLight);
//			softShadowMapMethod.alpha = 0.1;
			//动态阴影
			_lightPicker = new StaticLightPicker([ _sunLight]);
			_shadowMapMethod = new FilteredShadowMapMethod( _sunLight );
			_shadowMapMethod.alpha = 0.5;
			//
			_skybox=new SkyBox(new BitmapCubeTexture(new Embeds.EnvPosX().bitmapData,new Embeds.EnvNegX().bitmapData,new Embeds.EnvPosY().bitmapData,new Embeds.EnvNegY().bitmapData,new Embeds.EnvPosZ().bitmapData ,new Embeds.EnvNegZ().bitmapData));

		}
		

		private var _debug:Boolean = false;
		private var _dColor:uint;
		private var _dTime:Number;
		private var _dAmbient:Number;
		/**
		 * 
		 * @param txt  ;//color:uint, time:Number, ambient:Number
		 * 
		 */
		public function openDebug(txt:String):void
		{
			_debug = true;
			
			var tmpArr:Array = txt.split(",");
			_dColor = uint(tmpArr[0]);
			_dTime = Number(tmpArr[1] / 1000);
			_dAmbient = Number(tmpArr[2] / 1000);
		}
		public function closeDebug():void
		{
			_debug = false;
		}

	public function get sunLight():DirectionalLight {
		return _sunLight;
	}

	public function get skybox():SkyBox
	{
		return _skybox;
	}
}
}