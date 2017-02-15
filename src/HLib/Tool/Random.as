package HLib.Tool
{
	public class Random
	{
		public static function RandRange(min:Number, max:Number):Number{
			return Math.floor(Math.random() * (max - min + 1)) + min;		
		}
		
		//获取一个随机的布尔值
		public static function get boolean():Boolean
		{
			return Boolean(integer(2));
		}
		
		//获取一个正负波动值
		public static function get wave():int
		{
			return integer(2) * 2 - 1;
		}
		
		//获取一个随机的范围整数值
		public static function integer(num:Number):int
		{
			return Math.floor(number(num));
		}
		
		//获取一个随机的范围Number值
		public static function number(num:Number):Number
		{
			return Math.random() * num;
		}
		
		//在一个范围内获取一个随机值，返回结果范围：num1 >= num > num2
		public static function range(num1:Number,num2:Number,isInt:Boolean = true):Number
		{
			var num:Number = number(num2 - num1) + num1;
			if (isInt)
			{
				num = Math.floor(num);
			}
			return num;
		}
		
		//在多个范围获取随机值
		public static function ranges(...args):Number
		{
			var isInt:Boolean = args[args.length - 1] is Boolean ? args.pop():true;
			var num:Number = randomRange(args);
			if (! isInt)
			{
				num +=  Math.random();
			}
			return num;
		}
		
		//获取一个随机字符，默认随机范围为数字+大小写字母，也可以指定范围，格式：a-z,A-H,5-9
		public static function string(str:String = "0-9,A-Z,a-z"):String
		{
			return String.fromCharCode(randomRange(explain(str)));
		}
		
		//生成指定位数的随机字符串
		public static function bit(num:int,str:String = "0-9,A-Z,a-z"):String
		{
			var reStr:String = "";
			for (var i:int = 0; i < num; i ++)
			{
				reStr +=  string(str);
			}
			return reStr;
		}
		
		//获取一个随机的颜色值
		public static function color(red:String = "0-255",green:String = "0-255",blue:String = "0-255"):uint
		{
			return Number("0x" + transform(randomRange(explain(red,false))) +
				transform(randomRange(explain(green,false))) +
				transform(randomRange(explain(blue,false))));
		}
		
		//将10进制的RGB色转换为2位的16进制
		private static function transform(num:uint):String
		{
			var reStr:String = num.toString(16);
			if (reStr.length != 2)
			{
				reStr = "0" + reStr;
			}
			return reStr;
		}
		
		//字符串解析
		private static function explain(str:String,isCodeAt:Boolean = true):Array
		{
			var argAr:Array = new Array  ;
			var tmpAr:Array = str.split(",");
			for (var i:int = 0; i < tmpAr.length; i ++)
			{
				var ar:Array = tmpAr[i].split("-");
				if (ar.length == 2)
				{
					var arPush0:String = ar[0];
					var arPush1:String = ar[1];
					if (isCodeAt)
					{
						arPush0 = arPush0.charCodeAt().toString();
						arPush1 = arPush1.charCodeAt().toString();
					}
					//此处如果不加1，将不会随机ar[1]所表示字符，因此需要加上1，随机范围才是对的
					argAr.push(Number(arPush0),Number(arPush1) + 1);
				}
				else if (ar.length == 1)
				{
					var arPush:String = ar[0];
					if (isCodeAt)
					{
						arPush = arPush.charCodeAt().toString();
					}//如果范围是1-2，那么整型随机必定是1，因此拿出第一个参数后，把范围定在参数+1，则就是让该参数参加随机
					argAr.push(Number(arPush),Number(arPush) + 1);
				}
				ar = null;
			}
			tmpAr = null;
			return argAr;
		}
		
		//获取随机范围
		private static function randomRange(ar:Array):Number
		{
			var tmpAr:Array = new Array  ;
			var length:int = ar.length;
			if (length % 2 != 0 || length == 0)
			{
				throw new Error("参数错误！无法获取指定范围！");
			}//将所有可能出现的随机数存入数组，然后进行随机
			for (var i:int = 0; i < length / 2; i ++)
			{
				var i1:int = ar[i * 2];
				var i2:int = ar[i * 2 + 1];
				if (i1 > i2)
				{
					var tmp:Number = i1;
					i1 = i2;
					i2 = tmp;
				}
				for (i1; i1 < i2; i1 ++)
				{
					tmpAr.push(i1);
				}
			}
			var num:Number = tmpAr[integer(tmpAr.length)];
			tmpAr = null;
			ar = null;
			return num;
		}

	}
}