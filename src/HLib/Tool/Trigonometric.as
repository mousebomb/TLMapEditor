package HLib.Tool
{
	/**
	 * 三角行数工具类
	 * @author 李舒浩
	 * 
	 * sin＝对边/斜边
	 * cos＝邻边/斜边
	 * tan＝对边/邻边
	 * 
	 * 斜边＝2.2/cos31° ≈ 2.567
	 * 对边＝2.2·tan31° ≈ 1.328
	 */	
	import flash.geom.Point;

	public class Trigonometric
	{
		public function Trigonometric()  {  }
		
		/**
		 * 获得指定掉
		 * @param point1	: 点1
		 * @param point2	: 点2
		 * @return 			: 
		 */		
		public static function getAngle(point1:Point, point2:Point):Number
		{
			var a:Number = point1.x - point2.x;
			var b:Number = point1.y - point2.y;
			return Math.atan2(b, a);
		}
		/**
		 * 获得三角形对边
		 * @param point1	: 点1,获得对边点
		 * @param point2	: 点2
		 * @return 			: 
		 */	
		public static function getSubtense(point1:Point, point2:Point):Number
		{
			return (point1.y - point2.y);
		}
		/**
		 * 获得三角形邻边
		 * @param point1	: 点1,获得邻边点
		 * @param point2	: 点2
		 * @return 			: 
		 */		
		public static function getAdjacentSide(point1:Point, point2:Point):Number
		{
			return (point1.x - point2.x);
		}
		/**
		 * 获得邻边
		 * </br>cos＝邻边/斜边
		 * @param point1	: 斜边
		 * @param angle		: cos角度
		 * @return 			: 邻边值
		 */		
		public static function getAdjacentSide1(c:int, angle:int):Number
		{
			return c * Math.cos(angle);
		}
		/**
		 * 获得对边
		 * </br>sin＝对边/斜边
		 * @param point1	: 斜边
		 * @param angle		: sin角度
		 * @return 			: 邻边值
		 */		
		public static function getSubtense1(c:int, angle:int):Number
		{
			return c * Math.sin(angle);
		}
		
		/**
		 * 获得三角形斜边
		 * @param point1	: 点1
		 * @param point2	: 点2
		 * @return 			: 三角形斜边值(两点距离)
		 */		
		public static function getHypotenuse(point1:Point, point2:Point):Number
		{
			var dx:Number = point1.x - point2.x; 
			var dy:Number = point1.y - point2.y; 
			return Math.sqrt(dx*dx + dy*dy);
		}
		/**
		 * 获得三角形面积
		 * </br>使用海伦公式计算面积
		 * </br>假设三边长为a, b, c
		 * </br>p = (a + b + c) / 2; 
		 * </br>则面积的平方 s^2 = p * (p - a) * (p - b) * (p-c); 
		 * 
		 * @param $a	: 三角形a边
		 * @param $b	: 三角形b边
		 * @param $c	: 三角形c边
		 * @return 		: 三角形面积
		 */	
		public static function getArea($a:Number, $b:Number, $c:Number):Number
		{
			var p:Number = ($a + $b + $c) * 0.5; 
			var s:Number = p * (p - $a) * (p - $b) * (p - $c);
			return Math.sqrt(s);
		}
		
	}
}