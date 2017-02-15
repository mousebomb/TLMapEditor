/**
 * Created by Administrator on 2017/2/10.
 */
package tl.mapeditor.ui.window
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import tl.frameworks.defines.ZoneType;

	import tl.frameworks.model.TLEditorMapModel;

	import tl.mapeditor.ui.common.MyButton;
	import tl.mapeditor.ui.common.MySprite;
	import tl.utils.HCss;
	import tl.utils.Tool;

	/**区域设置*/
	public class ZoneSettingUI extends MySprite
	{
		public var upSelectBtn:MyButton;
		public function ZoneSettingUI()
		{
			super ();
		}

		public function init():void
		{
			if(this.isInit) return;
			this.isInit = true;
			var btnVec:Vector.<String> = Vector.<String>([ "取消设置", "删除设置", "跌落区域", "障碍区域", "遮挡区域",  "PK区域", "安全区域", "区域A", "区域B", "区域C", "区域D", "区域E", "PK透明区域", "安全透明区域"]);
			var btnNameVec:Vector.<String> = Vector.<String>([ "NotSetting", "ClearSetting", "FallArea", "Obstacles", "Mask",  "PKArea", "SafetyArea", "AreaA", "AreaB", "AreaC", "AreaD", "AreaE", "PKMask", "SafetyMask"]);
			var colorVec:Vector.<uint> = Vector.<uint>([0x0, ZoneType.COLOR_NULL, ZoneType.COLOR_WAYPOINT, ZoneType.COLOR_OBSTACLES, ZoneType.COLOR_MASK, ZoneType.COLOR_PK,
				ZoneType.COLOR_SAFETY, ZoneType.COLOR_AREA_A, ZoneType.COLOR_AREA_B, ZoneType.COLOR_AREA_C, ZoneType.COLOR_AREA_D, ZoneType.COLOR_AREA_E, ZoneType.COLOR_PK_MASK, ZoneType.COLOR_SAFETY_MASK]);
			var len:int = btnVec.length;
			var btn:MyButton;
			var bitmap:Bitmap;
			for(var i:int = 0; i < len; i++)
			{
				bitmap = new Bitmap(new BitmapData(22, 22, true, colorVec[i]));
				this.addChild(bitmap);
				bitmap.x = 5;
				bitmap.y = 5 + i * (bitmap.height + 5);

				btn = Tool.getMyBtn(btnVec[i], 70);
				btn.name = btnNameVec[i];
				this.addChild(btn);
				btn.x = bitmap.x + bitmap.width + 5;
				btn.y = bitmap.y;//5 + i * (btn.myHeight + 5);
			}
			upSelectBtn = MyButton(this.getChildByName("NotSetting"));
			upSelectBtn.selected = true;

			this.myWidth = 110;
			this.drawRect(this.myWidth, (btn.height+5)*i+10, 0x424242);

		}
	}
}
