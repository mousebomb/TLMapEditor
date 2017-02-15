package tl.core
{
	public class IResourceKey
	{
		public static var isCanUseATF:Boolean = false;										//是否可以使用ATF
		public static var starlingCanUseATF:Boolean = false;									//是否使用atf格式标志
		public static var Suffix_MD5Mesh:String = ".e_md5mesh";									//模型文件后缀
		public static var Suffix_ATF:String = ".atf";									//模型贴图文件后缀
		public static var Suffix_PNG:String = ".png";	
		public static var Suffix_MD5Anim:String = ".e_md5anim";									//模型动作		
		public static var Suffix_Effect:String = ".awp";										//特效后缀名
		
//		public static var Suffix_TextureMaterial:String = ".TextureMaterial";				//贴图后缀名
//		public static var Suffix_SkeletonClipNode:String = ".SkeletonClipNode";				//动作后缀名
//		public static var Suffix_SkeletonAnimationSet:String = ".SkeletonAnimationSet";	//动作数据集后缀名
//		public static var Suffix_Skeleton:String = ".Skeleton";								//骨骼后缀名
//		public static var Url_Effect:String = "assets/SpecialEfficacy/";						//特效文件URL地址
		
		public static var resType_MD5Mesh:int = 0;
		public static var resType_Texture:int = 1;
		public static var resType_AnimNode:int = 2;
		public static var resType_Effect:int = 3;
		public static var resType_AnimSet:int = 4;
		public static var resType_Skeleton:int = 5;
											//地图贴图后缀名
		
		public static var huiyingren_file:String = "role_huiying"						//灰影文件夹
		public static var huiyingren_role:String = "role_huiying"						//模型文件
		public static var huiyingren_m:String = "role_huiying_m"							//贴图资源
		public static var huiyingren_stand:String = "role_huiying_stand"					//灰影站立动作
		public static var huiyingren_run:String = "role_huiying_run"						//灰影跑动作
		public static var huiyingren_attack1:String = "role_huiying_attack1"				//灰影攻击
		public static var huiyingren_attack2:String = "role_huiying_attack2"				//灰影攻击
		public static var huiyingren_attack3:String = "role_huiying_attack3"				//灰影攻击
		public static var huiyingren_attack4:String = "role_huiying_attack4"				//灰影攻击
		public static var huiyingren_ridestand:String = "role_huiying_ridestand"			//灰影骑马
		public static var huiyingren_walk:String = "role_huiying_walk"					//灰影巡城
		public static var huiyingren_dead:String = "role_huiying_dead";
		public static var huiyingren_struckply:String = "role_huiying_struckply";
		public static var huiyingren_struckback:String = "role_huiying_struckback";
		public static var huiyingren_struckfall:String = "role_huiying_struckfall";
		public static var huiyingren_struck:String = "role_huiying_struck";
		
	}
}