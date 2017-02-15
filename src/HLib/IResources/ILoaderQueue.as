package HLib.IResources
{
	import HLib.IResources.load.LoaderParam;
	import HLib.IResources.load.LoaderTaskParam;

	public interface ILoaderQueue
	{
		function addTask(taskParam:LoaderTaskParam):String;
		function get nextParam():LoaderParam;
		function finishParam(param:LoaderParam):void;
		function clear():void;
		function removeTask(key:String):void;
	}
}