package HLib.MapBase
{
	/**
	 * 灯光类
	 * @author 黄栋 && 李舒浩
	 */	
	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
	
	import flash.geom.Vector3D;
	
	import HLib.Event.Dispatcher_F;
	import HLib.Event.Event_F;
	
	import Modules.Map.HMap3D;
	import Modules.Setting.Configuration;
	import Modules.Setting.SettingSources;
	import Modules.Wizard.WizardKey;
	
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.lights.PointLight;
	import away3d.lights.shadowmaps.NearDirectionalShadowMapper;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.FilteredShadowMapMethod;
	
	public class HLightManager
	{
		private static var _lightManager:HLightManager;
		
		/** 阳光光线 **/
		private var _sunLight:DirectionalLight;
		
		/** 阴影光源 **/
		public function get shadowMapMethod():FilteredShadowMapMethod
		{ 
			return _shadowMapMethod;
		}
		
		private var _shadowMapMethod:FilteredShadowMapMethod;
		
		/** 阳光 **/
		public function get lightPicker():StaticLightPicker 
		{  
			return _lightPicker;
		}
		private var _lightPicker:StaticLightPicker;
		
		/** 点光源 **/
		private var _pointLight:PointLight;
		
	
		public function HLightManager()
		{
			init();
		}
		
		public static function getInstance():HLightManager
		{
			_lightManager ||= new HLightManager();
			return _lightManager;
		}
		
		private function init():void
		{
			var baseShadowMethod:NearDirectionalShadowMapper = new NearDirectionalShadowMapper();
			baseShadowMethod.depthMapSize = 2048;	//深度贴图尺寸
//			baseShadowMethod.lightOffset = 5000;
			
			//点光源
			_pointLight = new PointLight();
			//平行光
			_sunLight = new DirectionalLight(-1, -1, -1);
			_sunLight.shadowMapper = baseShadowMethod;				//阴影映射
			_sunLight.direction = new Vector3D(-0.2, -0.78, -0.2);      //光源角度
//			var softShadowMapMethod:SoftShadowMapMethod = new SoftShadowMapMethod(_sunLight);
//			softShadowMapMethod.alpha = 0.1;
			//动态阴影
			_lightPicker = new StaticLightPicker([_pointLight, _sunLight]);
			_shadowMapMethod = new FilteredShadowMapMethod( _sunLight );
			_shadowMapMethod.alpha = 0.5;
			
			Dispatcher_F.getInstance().addEventListener(WizardKey.FirAction_FlashLight, onFlashLight);
		}
		
		/** 执行闪光 **/
		private function onFlashLight(e:Event_F):void
		{
			//判断是否设置了开启技能光影,如果是true为开启,执行处理
			if( SettingSources.getInstance().getFlagsByType(Configuration.TYPE_31) )
			{
				return;
			}
			
			HMap3D.getInstance().addChild( _pointLight );
			//设置光照
			var _Args:Array = e.data as Array;
			flashLight(_pointLight, _Args[0], _Args[1], _Args[2]);
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
		/**
		 * 执行闪光效果
		 * @param light		: 光源类型
		 * @param color		: 颜色值
		 * @param time		: 效果时间
		 * @param ambient	: 排放强度
		 */		
		public function flashLight(light:LightBase, color:uint = 0, time:Number = 0.5, ambient:Number=0):void
		{
			//开启动态阴影这个功能才有效果，共享灯光渲染数组
			if(!_isOpenSunLight) 
			{
				return;
			}
			
			if (_debug)
			{
				color = _dColor;
				time = _dTime;
				ambient = _dAmbient;
			}
			
			if(color != 0)
			{
				light.ambientColor = color;
			}
			
			TweenMax.killTweensOf(light);
			
			var tweenMax:TweenMax = TweenMax.to(light, time, {ambient:ambient, ease:Bounce.easeInOut
				,onComplete:function(light:LightBase):void
				{
					light.color = 0xffffff;
					light.ambientColor = 0xffffff;
					light.ambient = 0;
					
					if (_pointLight.parent)
					{
						_pointLight.parent.removeChild(_pointLight);
					}
				}
				, onCompleteParams:[light]
			});
		}
		/**
		 * 是否开启阳光
		 * @param value
		 */		
		public function set isOpenSunLight(value:Boolean):void
		{
			_isOpenSunLight = value;
			
			if(_isOpenSunLight)
			{
				HMap3D.getInstance().addChild( _sunLight );
			}
			else
			{
				if(_sunLight.parent)
				{
					_sunLight.parent.removeChild( _sunLight );
				}
			}
			//设置地面受光
			MapFloor3D.getInstance().isOpenSunLight = _isOpenSunLight;
		}
		public function get isOpenSunLight():Boolean
		{
			return _isOpenSunLight;
		}
		private var _isOpenSunLight:Boolean = false;
	}
}