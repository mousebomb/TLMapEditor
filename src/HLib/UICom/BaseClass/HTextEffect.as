package HLib.UICom.BaseClass
{
	
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	import Modules.SFeather.SFTextInput;
	
	import starling.filters.FragmentFilter;

	public class HTextEffect
	{	
		public function HTextEffect()
		{
		}
		public static function textFormat(_TextField:HTextField,
								   TextSize:uint=14,
								   TextColor:uint=0xFFffd7b0,
								   TextBold:Boolean=false,
								   TextAlign:String="center",
								   TextFace:String="Arial"								   
		):HTextField{
			
			//var _TextFormat:TextFormat=new TextFormat();
			_TextField.fontSize=TextSize;
			_TextField.color=TextColor;
			_TextField.bold=TextBold;
			_TextField.hAlign=TextAlign;

			return _TextField;
		}
		/**文字投影**/
		public static function textDropShadowFilter(_TextField:HTextField,
											 _distance:Number=0,//显示对象副本较原始对象的偏移量，以像素为单位
											 angel:Number=0,//投影的偏移角度
											 color:uint=0xFF000000,//投影颜色
											 alpha:Number=1,//投影的透明度
											 blurX:Number=2,//投影在x坐标轴方向的模糊量
											 blerY:Number=2,//投影再y坐标轴方向的模糊量
											 strength:Number=4,//设置投影的强度，值越大投影越暗，与背景产生的对比差异越大
											 quality:int=2,//模糊执行的次数，和BlurFilter里的quality一样(实际上它们的模糊原理是一样的)
											 inner:Boolean=false,//决定是投影是在绘制在对象内部还是外部
											 knockout:Boolean=false,//设置是否应用挖空效果
											 hideObject:Boolean=false
		):HTextField{
			_TextField.nativeFilters=[new DropShadowFilter(_distance,angel, color, alpha, blurX,blerY, strength, quality, inner, knockout,hideObject)];
			return _TextField;
		}

		public static function textFilters(_TextField:HTextField):HTextField{
			textFormat(_TextField);
			textDropShadowFilter(_TextField);
			return _TextField;
		}
		/**文字描边**/
		public static function textGlowFilter(_TextField:HTextField,
											  color:uint=0xFF000000,//边框颜色
											  alpha:Number=1,//边框的透明度
											  blurX:Number=2,//边框在x坐标轴方向的模糊量
											  blerY:Number=2,//边框在y坐标轴方向的模糊量
											  strength:Number=2,//设置边框的强度
											  quality:int=1,//模糊执行的次数，和BlurFilter里的quality一样(实际上它们的模糊原理是一样的)
											  inner:Boolean=false,//决定是投影是在绘制在对象内部还是外部
											  knockout:Boolean=false//设置是否应用挖空效果
		):HTextField{
			_TextField.nativeFilters=[new GlowFilter(color, alpha, blurX,blerY, strength, quality, inner, knockout)];
			return _TextField;
		}
		
		
		
		
		
		
		
		
		
		
	}
}