package tl.core.Wizard
{
	/**
	 * 精灵特效配置表(用于程序写死的特效配置)
	 * @author 李舒浩
	 */	
	public class WizardEffectConfig
	{
		public function WizardEffectConfig()  {  }
		
		//选中光圈
		public static const Effect_SubPath_Select:String = "effectall";					//选中特效包名
		public static const Effect_PackName_SelectHero:String = "ef_cj_select01";		//选中玩家
		public static const Effect_PackName_SelectNPC:String = "ef_cj_select03";		//选中NPC
		public static const Effect_PackName_selectMonster:String = "ef_cj_select04";	//选中敌对者
		
		//释放技能显示范围特效
		public static const Effect_SubPath_Range:String = "effectall";						//特效包名
		public static const Effect_PackName_Monster_Range_1:String = "ef_cj_shifa01_gw_qy";			//怪物前方直线
		public static const Effect_PackName_Monster_Range_170_2:String = "ef_cj_shifa04_170_gw_qy";	//怪物前方170度扇形
		public static const Effect_PackName_Monster_Range_120_2:String = "ef_cj_shifa04_120_gw_qy";	//怪物前方120度扇形
		public static const Effect_PackName_Monster_Range_3:String = "ef_cj_shifa02_gw_qy";			//怪物自身周围
		public static const Effect_PackName_Monster_Range_4:String = "ef_cj_shifa02_gw_qy_a";			//怪物指定范围
		
		public static const Effect_PackName_Role_Range_1:String = "ef_cj_shifa01_qy";				//角色前方直线
		public static const Effect_PackName_Role_Range_170_2:String = "ef_cj_shifa04_170_qy";		//角色前方170度扇形
		public static const Effect_PackName_Role_Range_120_2:String = "ef_cj_shifa04_120_qy";		//角色前方120度扇形
		public static const Effect_PackName_Role_Range_3:String = "ef_cj_shifa02_qy";				//角色自身周围
		public static const Effect_PackName_Role_Range_4:String = "ef_cj_shifa02_qy_a";			//角色指定范围
		
		//范围特效大小数组,2个一组为一个特效的大小,当修改特效时需要修改此数组为对应的特效宽高大小,[0]:宽度, [1]:高度,顺序为上面顺序
		public static const Effect_RangeNumVec:Vector.<uint> = Vector.<uint>([
																					 120, 600
																					,600, 600
																					,600, 600
																					,600, 600
																					,600, 600
																				]);
		
		//死亡/复活特效
		public static const Effect_SubPath_DeathAndResurrection:String = "effectall";	//死亡与复活
		public static const Effect_PackName_Death:String = "ef_cj_siwang";				//死亡特效
		public static const Effect_PackName_Resurrection:String = "ef_cj_fuhuo";		//复活特效
		
		//指针特效
		public static const Effect_SubPath_Target:String = "effectall";					//指针目标包名
		public static const Effect_PackName_Targe:String = "ef_cj_zhizhengnew";		//指针特效
		
		//受击特效
		public static const Effect_SubPath_Injured:String = "effectall";				//受伤包名
		public static const Effect_PackName_Injured_1:String = "ef_attack_01";			//受伤特效1
		public static const Effect_PackName_Injured_2:String = "ef_attack_02";			//受伤特效2
		public static const Effect_PackName_Injured_3:String = "ef_attack_03";			//受伤特效3
		public static const Effect_PackName_Injured_4:String = "ef_skill_gw_langatt01";//受伤特效4
		public static const Effect_PackName_Injured_5:String = "ef_skill_gw_langatt02";//受伤特效5
		
		
		public static const EFFect__DengLuTa_One:String = 'ef_cj_denglutai_a';
		public static const EFFect__DengLuTa_Two:String = 'ef_cj_denglutai_smoke';
		public static const EFFect__DengLuTa_Three:String = 'ef_cj_denglutai_b';
		//武器强化等级特效acitonID
//		public static const ActionId_ArmsEffectIDVec:Vector.<String> = Vector.<String>([	 50201, 50202, 503, 50204
//																							,50211, 50212, 50213, 50214
//																							,50221, 50222, 50223, 50224
//																							,50231, 50232, 50233, 50234
//																						]);
		//坐骑脚印
		public static const RideFootprints_SubPath:String = "ride_footprints";
	}
}