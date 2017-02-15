/**
 * Created by gaord on 2016/12/17.
 */
package tool
{
	import away3d.containers.View3D;
	import away3d.core.managers.AGALProgram3DCache;
	import away3d.debug.AwayStats;
	import away3d.debug.Debug;

	import com.adobe.utils.AGALMiniAssembler;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filters.GlowFilter;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.setInterval;

	public class DebugHelper
	{
		private static var tf:TextField;
		private static var debugPrefixStr:String;
		private static var debugObj:Object = {};
		private static var a3dStats:AwayStats;

		private static var stage :Stage;
		public function DebugHelper( stage_ :Stage )
		{
			super();

			stage = stage_;
			debugPrefixStr       = "";
			debugPrefixStr += "playerType=" + Capabilities.playerType;
			debugPrefixStr += "\nversion=" + Capabilities.version;
			debugPrefixStr += "\nvmVersion=" + System.vmVersion;
			tf                   = new TextField();
			tf.autoSize          = TextFieldAutoSize.LEFT;
			tf.text              = debugPrefixStr;
			var tfm:TextFormat   = tf.defaultTextFormat;
			tfm.font             = "Arial";
			tfm.size             = 18;
			tfm.letterSpacing    = 2;
			tfm.bold             = true;
			tfm.color            = 0xffffff;
			tf.defaultTextFormat = tfm;
			tf.filters           = [new GlowFilter(0x0, 1.0, 2, 2, 400)];
			//
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			setInterval(debugTrace, 500);

		}

		public static function setView3D(view3D :View3D):void
		{
			a3dStats = new AwayStats(view3D, true, true);
			a3dStats.x = stage.stageWidth - a3dStats.width;
			stage.addChild(a3dStats);
		}

		public static function debugVal(field:String, val:*):void
		{
			debugObj[field] = val;
		}
		private function debugTrace():void
		{
			if (tf == null)return;
			debugVal("当前Texture数", Debug.texturesNum);
			debugVal("当前VertexBuffer3D数", Debug.vertexBufferNum);
			debugVal("AGALProgram3DCache上传次数", AGALProgram3DCache.statUploadProgramTimes);
			debugVal("AGALMiniAssembler组装次数", AGALMiniAssembler.statAssembleTimes);

			var debugStr:String = debugPrefixStr;
			for (var key:* in debugObj)
			{
				debugStr += "\n" + key + ": " + debugObj[key];
			}
			tf.text = debugStr;
		}
		protected function onKeyDown(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.NUMPAD_MULTIPLY)
			{
				if (tf == null)return;
				if (tf.parent)
				{
					tf.parent.removeChild(tf);
					if (a3dStats) a3dStats.parent.removeChild(a3dStats);
				}
				else
				{
					stage.addChild(tf);
					if (a3dStats) stage.addChild(a3dStats);
				}
			}
		}

	}
}
