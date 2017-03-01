/**
 * Created by gaord on 2016/12/15.
 */
package tl.frameworks.command
{
	import flash.events.Event;

	import org.robotlegs.mvcs.Command;

	import tl.frameworks.NotifyConst;
	import tl.frameworks.model.CSV.SGCsvManager;
	import tl.frameworks.model.CsvDataModel;

	import tool.StageFrame;

	public class LoadCsvCmd extends Command
	{
		public function LoadCsvCmd()
		{
		}

		[Inject]
		public var csvModel:CsvDataModel;
		override public function execute():void
		{
			/** 加载csv **/
			trace(StageFrame.renderIdx, "LoadCsvCmd/exec 开始加载csv文件");
			dispatchWith(NotifyConst.STATUS, false, "开始加载csv文件");


			csvModel.init();
		}

		private function onSGCsvManagerError(event:Event):void
		{
			trace(StageFrame.renderIdx, "LoadCsvCmd/onSGCsvManagerError");
		}

	}
}
