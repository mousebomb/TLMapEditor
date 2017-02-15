/**
 * Created by gaord on 2017/2/7.
 */
package tl.frameworks
{
	import flash.display.DisplayObjectContainer;

	import org.robotlegs.mvcs.Context;

	import tl.frameworks.command.StartupCmd;

	public class TLMapEditorContext extends Context
	{

		public function TLMapEditorContext(contextView:DisplayObjectContainer = null )
		{
			super(contextView,false);
		}

		override public function startup():void
		{
			commandMap.execute(StartupCmd);
			super.startup();
		}
	}
}
