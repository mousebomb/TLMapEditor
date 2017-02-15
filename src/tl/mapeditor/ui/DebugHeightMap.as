/**
 * Created by gaord on 2016/11/25.
 */
package tl.mapeditor.ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	import tool.StageFrame;

	public class DebugHeightMap extends Sprite
	{

		private static var instance:DebugHeightMap;

		/** */
		public function DebugHeightMap()
		{
			if (instance) throw new Error("单例只能实例化一次,请用 getInstance() 取实例。");
			instance = this;
			StageFrame.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			visible=false;
		}

		private function onKeyDown(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.F8)
			{
				this.visible = !this.visible;
			}
		}

		public static function getInstance():DebugHeightMap
		{
			instance ||= new DebugHeightMap();
			return instance;
		}

		public var bitmap1:Bitmap;
		public var bitmap2:Bitmap;

		public function showBitmapData(bmd:BitmapData):void
		{
			bitmap1 = new Bitmap(bmd);
			bitmap1.x =800;
			addChild(bitmap1);
		}

		public function showBitmapData2(bmd:BitmapData):void
		{
			bitmap2 = new Bitmap(bmd);
			addChild(bitmap2);
			bitmap2.x = 1200;
		}
	}
}
