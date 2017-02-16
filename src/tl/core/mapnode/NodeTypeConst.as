/**
 * Created by gaord on 2017/2/14.
 */
package tl.core.mapnode
{
	/** 区域存储数据掩码定义  并未使用，目前用的 tl.frameworks.defines.ZoneType */
	public class NodeTypeConst
	{
		/** 障碍区域 */
		public static const ND_BLOCK :int = 1;
		/** 遮挡区域"*/
		public static const ND_COVER :int = 2;
		/** 跌落区域 */
		public static const ND_SINK:int = 3;
		/** PK区域 */
		public static const ND_PK :int = 4;
		/** 安全区域 */
		public static const ND_SAFE :int = 5;
		/** 区域A */
		public static const ND_ZONE_A :int = 6;
		/** 区域B */
		public static const ND_ZONE_B :int = 7;
		/** 区域C */
		public static const ND_ZONE_C :int = 8;
		/** 区域D */
		public static const ND_ZONE_D :int = 9;
		/** 区域E */
		public static const ND_ZONE_E :int = 10;
		/** PK透明区域 */
		public static const ND_PK_TRANSPARENT :int = 11;
		/** 安全透明区域" */
		public static const ND_SAFE_TRANSPARENT :int = 12;
	}
}
