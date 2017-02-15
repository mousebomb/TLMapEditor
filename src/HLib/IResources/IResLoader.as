package HLib.IResources
{
	import HLib.IResources.load.LoaderParam;

	public interface IResLoader
	{
		function get param():LoaderParam;
		
		function startLoad(param:LoaderParam):void;
		
		function stop():void;
	}
}