/**
 * Created by gaord on 2016/12/13.
 */
package tl.frameworks
{
	public class NotifyConst
	{

		/**鼠标坐标变化 查看：model.mouseTilePos */
		public static const MOUSE_POS_CHANGED :String = "MOUSE_POS_CHANGED";
		/** 地图数据VO初始化完毕 */
		public static const MAP_VO_INITED :String = "MAP_VO_INITED";
		/** 需要锁定操作 */
		public static const LOCKED :String = "LOCKED";
		/** 可以解除锁定操作 */
		public static const UNLOCKED :String = "UNLOCKED";
		/** 确定新建地图 @data: CreateMapVO */
		public static const NEW_MAP:String             = "NEW_MAP";
		/** 添加新建地图UI */
		public static const NEW_MAP_UI:String          = "NEW_MAP_UI";
		/**开始使用地形刷 @data : int ToolBrushType */
		public static const TOOL_BRUSH:String          = "TOOL_BRUSH";
		/**设置地形刷的强度 @data : Number  */
		public static const TOOL_BRUSH_QIANGDU:String     = "TOOL_BRUSH_QIANGDU";
		/** 设置纹理刷的强度 @data:Number (0.01~1.00) */
		public static const TOOL_BRUSH_SPLATPOWER:String     = "TOOL_BRUSH_SPLATPOWER";
		/**设置地形刷/纹理刷的尺寸 @data : Number */
		public static const TOOL_BRUSH_SIZE:String     = "TOOL_BRUSH_SIZE";
		/**增加地形刷/纹理刷的尺寸 @data :Number */
		public static const TOOL_BRUSH_SIZE_ADD:String = "TOOL_BRUSH_SIZE_ADD";
		/**设置地形刷的柔和 @data : Number */
		public static const TOOL_BRUSH_ROUHE:String     = "TOOL_BRUSH_ROUHE";
		/**设置地形刷的最大高度 @data : Number */
		public static const TOOL_BRUSH_H_MAX :String = "TOOL_BRUSH_H_MAX";
		/**设置地形刷的最小高度 @data : Number */
		public static const TOOL_BRUSH_H_MIN :String = "TOOL_BRUSH_H_MIN";
		/** 使用选择工具 */
		public static const TOOL_SELECT:String         = "TOOL_SELECT";
		/** 选择3D对象后旋转 @data = 旋转角度 (+-1~360) */
		public static const TOOL_TARGET_ROTATE :String = "TOOL_TARGET_ROTATE";
		/** 选择3D对象后上下调整 @data = y轴向上增加像素 负数表示下降 */
		public static const TOOL_TARGET_UP :String = "TOOL_TARGET_UP";
		/** 新建刚体 */
		public static const TOOL_NEW_RIGIDBODY:String  = "TOOL_NEW_RIGIDBODY";
		/** 选中刚体的尺寸 @data:Number */
		public static const TOOL_RIGIDBODY_SIZE_ADD:String  = "TOOL_RIGIDBODY_SIZE_ADD";
		/** 选中刚体的旋转 @data:Number */
		public static const TOOL_RIGIDBODY_ROTATION_ADD:String  = "TOOL_RIGIDBODY_ROTATION_ADD";

		/**设置天空盒 @data:String 天空和Cube纹理 */
		public static const TOOL_SKYBOX_SET :String = "TOOL_SKYBOX_SET";
		/** 天空盒纹理列表就绪 */
		public static const SKYBOX_TEXTURES_LIST_LOADED :String = "SKYBOX_TEXTURES_LIST_LOADED";

		/**设置天光 光照角度 @data= Vector3D */
		public static const LIGHT_DIRECTION_SET :String = "LIGHT_DIRECTION_SET";

		/** 切换工具栏类型 @data = int @see ToolBoxType */
		public static const SWITCH_TOOLBOX:String = "SWITCH_TOOLBOX";
		/** 选择模型类型 */
		public static const SELECT_WIZARDOBJECT_TYPE:String = "select_wizardObject_type";
		/** CSV加载完毕 */
		public static const CSV_LOADED:String     = "CSV_LOADED";

		/** 层组增加了一层 @data = String 新层组的名字 */
		public static const GROUP_ADDED :String = "GROUP_ADDED";

		/** 某个层组内 精灵列表变化 @data = String 层组的名字 */
		public static const GROUP_WIZARD_LIST_CHANGED :String = "GROUP_WIZARD_LIST_CHANGED";
		/** 某个层组内 某个精灵放置变化 @data = RolePlaceVO  */
		public static const GROUP_WIZARD_LI_CHANGED :String = "GROUP_WIZARD_LI_CHANGED";

		/** 预览3D界面显示 @data={x,y} */
		public static const UI_PREVIEW_SHOW :String = "UI_PREVIEW_SHOW";
		/** 预览3D界面隐藏 */
		public static const UI_PREVIEW_HIDE :String = "UI_PREVIEW_HIDE";
		/** 选中的预览精灵 @data = WizardObject */
		public static const SELECT_WIZARD_PREVIEW:String          = "SELECT_WIZARD_PREVIEW";
		/** 选中地形贴图预览 @data=Material */
		public static const SELECT_TERRAIN_TEXTURE_PREVIEW:String = "SELECT_TERRAIN_TEXTURE_PREVIEW";
		/**设置选中模型*/
		public static const SELECT_WIZARDOBJECT_SETTING:String = 'SELECT_WIZARDOBJECT_SETTING';
		/** 让模型旋转 @data : int  +-1  */
		public static const WIZARD_PREVIEW_ROTATE :String = "WIZARD_PREVIEW_ROTATE";

		/** 开始按下拖拽，准备在场景内放置精灵 @data=WizardObject */
		public static const UI_START_ADD_WIZARD:String = "UI_START_ADD_WIZARD";
		/** UI点选已放置的模型精灵 @data=RolePlaceVO */
		public static const UI_SELECT_WIZARD :String = "UI_SELECT_WIZARD";

		/** UI发起删除当前选中项 3D层自动判定 */
		public static const UI_DELETE_SELECTED :String = "UI_DELETE_SELECTED";

		/** 添加功能点  @data 点类型 */
		public static const UI_ADD_FUNCPOINT :String = "UI_ADD_FUNCPOINT";

		/** 编辑器要求移动镜头 @data=Point( 0.0~1.0,0.0~1.0 ) */
		public static const UI_EDITOR_MOVE_CAM :String = "UI_EDITOR_MOVE_CAM";
		/** 镜头被按快捷键移动了 ui需要更新  @data=Point( 0.0~1.0,0.0~1.0 ) */
		public static const SCENE_CAM_MOVED :String = "SCENE_CAM_MOVED";

		/**通知状态 @data =String */
		public static const STATUS:String      = "STATUS";
		public static const LOG:String         = "LOG";

		/** 地形纹理素材列表已加载 */
		public static const TERRAIN_TEXTURES_LIST_LOADED:String = "TERRAIN_TEXTURES_LIST_LOADED";
		/** 地形纹理层 纹理改动 */
		public static const MAP_TERRAIN_TEXTURE_CHANGED:String  = "MAP_TERRAIN_TEXTURE_CHANGED";
		/** 地图区域已发生变化 @data = {tileX:centerX,tileY:centerY,type:type} */
		public static const MAP_NODE_VAL_CHANGED :String = "MAP_NODE_VAL_CHANGED";

		/** 保存 */
		public static const SAVE_MAP :String = "SAVE_MAP";
		/** 加载已存在的地图文件 @data :File */
		public static const LOAD_MAP :String = "LOAD_MAP";

		/** 开关网格 @data 不需要  */
		public static const TOGGLE_GRID :String = "TOGGLE_GRID";
		/**开关区域显示 @data 不需要 */
		public static const TOGGLE_ZONE :String = "TOGGLE_ZONE";
		/**包围盒显示与否 */
		public static const TOGGLE_BOUNDS :String = "TOGGLE_BOUNDS";
		/**打开图层面板*/
		public static const NEW_COVERAGEPANEL_UI:String = 'new_coveragePanel_ui';
		/**地形笔刷设置*/
		public static const NEW_BRUSHSETTING_UI:String  = 'new_brushSetting_ui';
		/**区域设置*/
		public static const NEW_ZONESETTING_UI:String = 'new_zoneSetting_ui';
		/**地表贴图设置*/
		public static const NEW_SURFACECHARTLET_UI:String = 'new_surfaceChartlet_ui';
		/**日志*/
		public static const NEW_LONG_UI:String = 'new_long_ui';
		/**快捷键显示*/
		public static const NEW_HELP_UI:String = 'new_help_ui';
		/**下拉菜单弹出*/
		public static const NEW_POPMENUBAR_UI:String = 'new_popmenuBar_ui';
		/**统计界面*/
		public static const NEW_STATISTICS_UI:String = 'new_statistics_ui';
		/**显示模型设置界面*/
		public static const NEW_WIZARD_UI:String = 'new_wizard_ui';
		/**关闭ui界面*/
		public static const CLOSE_UI:String = 'CLOSE_UI';
		/**关闭所有ui界面*/
		public static const CLOSE_ALL_UI:String = 'CLOSE_ALL_UI';

		public function NotifyConst()
		{
		}
	}
}
