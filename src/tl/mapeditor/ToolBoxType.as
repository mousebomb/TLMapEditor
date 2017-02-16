/**
 * Created by gaord on 2016/12/15.
 */
package tl.mapeditor
{
	public class ToolBoxType
	{
		/**文件*/
		public static const BAR_NAME_1:String 	= '文件';
		/**工具*/
		public static const BAR_NAME_2:String	= '工具';
		/**视图*/
		public static const BAR_NAME_3:String	= '视图';
		/**运行*/
		public static const BAR_NAME_4:String	= '运行';
		/**帮助*/
		public static const BAR_NAME_5:String	= '帮助';
		/**地图测试*/
		public static const BAR_NAME_6:String	= '地图测试';
		/**显示网格*/
		public static const BAR_NAME_7:String	= '显示网格';
		/**显示区域*/
		public static const BAR_NAME_8:String	= '显示区域';
		/**区域设置*/
		public static const BAR_NAME_9:String	= '区域设置';
		/**设置功能点*/
		public static const BAR_NAME_10:String	= '设置功能点';
		/**显示包围盒*/
		public static const BAR_NAME_11:String	= '显示包围盒';
		/**设置天空盒*/
		public static const BAR_NAME_12:String	= '设置天空盒';
		/**新建刚体*/
		public static const BAR_NAME_13:String	= '新建刚体';
		/**显示灯光*/
		public static const BAR_NAME_14:String	= '显示灯光';
		/**刷新阴影*/
		public static const BAR_NAME_15:String	= '刷新阴影';
		/**地表贴图*/
		public static const BAR_NAME_16:String	= '地表贴图';
		/**属性面板*/
		public static const BAR_NAME_30:String	= '属性面板';
		/**缩略图*/
		public static const BAR_NAME_28:String	= '缩略图';

		/**********************下拉列表弹出选择界面***************************************/
		public static const BAR_NAME_17:String	= '新建(Ctrl+N)';
		public static const BAR_NAME_18:String	= '打开(Ctrl+O)';
		public static const BAR_NAME_19:String	= '保存(Ctrl+S)';
		public static const BAR_NAME_21:String	= '模型编辑';
		public static const BAR_NAME_22:String	= '切图工具';
		public static const BAR_NAME_23:String	= '贴图转换';
		public static const BAR_NAME_24:String	= '性能测试';
		public static const BAR_NAME_25:String	= '工具栏';
		public static const BAR_NAME_26:String	= '图层面板';
		public static const BAR_NAME_27:String	= '模型列表';
		public static const BAR_NAME_29:String	= '性能控制';
		public static const BAR_NAME_31:String	= '日志LOG';
		public static const BAR_NAME_32:String	= '统计面板';
		public static const BAR_NAME_33:String 	= '快捷键';
		public static const BAR_NAME_34:String 	= '关于';
		/** 地形纹理刷 */
		public static const TERRAIN_TEXTURE:String 	= '地形纹理';
		/** 模型列表 */
		public static const WIZARD_LIBRARY:String  	= '模型列表';
		/** 地形高度图工具 */
		public static const TERRAIN_HEIGHT:String  	= '地形高度';
		/**创建新地图*/
		public static const CREATE_FILE:String		= '创建地图';

		public static const fillVector:Vector.<String> = new <String>[BAR_NAME_17, BAR_NAME_18, BAR_NAME_19];
		public static const toolVector:Vector.<String> = new <String>[BAR_NAME_21, BAR_NAME_22, BAR_NAME_23, BAR_NAME_24];
		public static const uiVector:Vector.<String> = new <String>[BAR_NAME_25, BAR_NAME_26, BAR_NAME_29, BAR_NAME_31, BAR_NAME_32];
		public static const ranVector:Vector.<String> = new <String>[];
		public static const helpVector:Vector.<String> = new <String>[BAR_NAME_33, BAR_NAME_34];
		public static var popmenuX:int;
		public static var popmenuY:int;
		public function ToolBoxType()
		{
		}
	}
}
