package HLib.Tool
{
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class HTextEffect extends Object
	{
		private static var _textFormat:TextFormat = new TextFormat;
		public function HTextEffect()
		{
			super();
		}
		
		public static function textFormat(param1:TextField, size:uint=14, color:uint=4.29496e+009, bold:Boolean=false, align:String='center', font:String='Arial'):TextField
		{
			_textFormat.size = size;
			_textFormat.font = font;
			_textFormat.align = align;
			_textFormat.bold = bold;
			_textFormat.color = color;
			param1.setTextFormat(_textFormat);
			return param1;
		}
		
		public static function defaultTextFormat(param1:TextField, size:uint=14, color:uint=4.29496e+009, bold:Boolean=false, align:String='center', font:String='Arial'):TextField
		{
			_textFormat.size = size;
			_textFormat.font = font;
			_textFormat.align = align;
			_textFormat.bold = bold;
			_textFormat.color = color;
			param1.defaultTextFormat = _textFormat;
			return param1;
		}
		
		public static function textDropShadowFilter(text:*, distance:Number=0, angle:Number=0, color:uint=0, alpha:Number=1, blurx:Number=2, blury:Number=2, strength:Number=4, quality:Number=2, inner:Boolean=false, knockout:Boolean=false, hideObject:Boolean=false):*
		{
			text.filters = [new DropShadowFilter(distance, angle, color, alpha, blurx, blury, strength, quality, inner, knockout, hideObject)];
			return text;
		}
		
		public static function textFilters(param1:TextField):TextField
		{
			textFormat(param1);
			textDropShadowFilter(param1);
			return param1;
		}
		
		public static function textGoldFilter(text:TextField, color:Number=1973790, alpha:Number=0.8, blurx:uint=2, blury:Number=2, strength:Number=10, quality:Number=1, inner:Boolean=false, knockout:Boolean=false):TextField
		{
			text.filters = [new GlowFilter(color, alpha, blurx, blury, strength, quality, inner, knockout)];
			return text;
		}
	}
}