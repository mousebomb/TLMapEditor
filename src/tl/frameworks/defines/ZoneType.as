/**
 * Created by gaord on 2017/2/13.
 */
package tl.frameworks.defines
{
	public class ZoneType
	{

		/**无任何状态*/
		public static const ZONE_TYPE_0:uint  	= 0;
		/**不可行走区域*/
		public static const ZONE_TYPE_1:uint 	= 1;
		/**遮挡位置*/
		public static const ZONE_TYPE_2:uint 	= 2;
		/**跌落区域*/
		public static const ZONE_TYPE_3:uint 	= 3;
		/**PK区域*/
		public static const ZONE_TYPE_4:uint 	= 4;
		/**安全区域*/
		public static const ZONE_TYPE_5:uint 	= 5;
		/**区域A*/
		public static const ZONE_TYPE_6:uint 	= 6;
		/**区域B*/
		public static const ZONE_TYPE_7:uint 	= 7;
		/**区域C*/
		public static const ZONE_TYPE_8:uint 	= 8;
		/**区域D*/
		public static const ZONE_TYPE_9:uint 	= 9;
		/**区域E*/
		public static const ZONE_TYPE_10:uint 	= 10;
		/**PK透明区域*/
		public static const ZONE_TYPE_11:uint 	= 11;
		/**安全透明区域*/
		public static const ZONE_TYPE_12:uint 	= 12;


		// #pragma mark --  颜色  ------------------------------------------------------------

		/**无状态颜色(透明黑色)*/
		public static const COLOR_NULL:uint = 0x66000000;
		/**不可行走区域颜色(灰色)*/
		public static const COLOR_OBSTACLES:uint = 0x66CCCCCC;
		/**遮罩区域颜色(蓝色)*/
		public static const COLOR_MASK:uint = 0x6600FFFF;
		/**跌落区域颜色(黄色)*/
		public static const COLOR_WAYPOINT:uint = 0x66FFFF00;
		/**PK区域(红色)*/
		public static const COLOR_PK:uint = 0xAAFF0000;
		/**安全区域(绿色)*/
		public static const COLOR_SAFETY:uint = 0xAA00FF00;
		/**区域A*/
		public static const COLOR_AREA_A:uint = 0x66DD338B;
		/**区域B*/
		public static const COLOR_AREA_B:uint = 0x664545AA;
		/**区域C*/
		public static const COLOR_AREA_C:uint = 0x662C98D6;
		/**区域D*/
		public static const COLOR_AREA_D:uint = 0x66C2A643;
		/**区域E*/
		public static const COLOR_AREA_E:uint = 0x66CE6A3E;
		/**PK透明区域(红色)*/
		public static const COLOR_PK_MASK:uint = 0x33FF0000;
		/**安全透明区域(绿色)*/
		public static const COLOR_SAFETY_MASK:uint = 0x3300FF00;

// #pragma mark --  颜色对应关系  ------------------------------------------------------------

		public static const COLOR_BY_TYPE:Vector.<uint> = Vector.<uint>([ COLOR_NULL
			,COLOR_OBSTACLES
			,COLOR_MASK
			,COLOR_WAYPOINT
			,COLOR_PK
			,COLOR_SAFETY
			,COLOR_AREA_A
			,COLOR_AREA_B
			,COLOR_AREA_C
			,COLOR_AREA_D
			,COLOR_AREA_E
			,COLOR_PK_MASK
			,COLOR_SAFETY_MASK]);

	}
}
