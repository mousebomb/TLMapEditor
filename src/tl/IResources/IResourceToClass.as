package tl.IResources
{
	import flash.display.LoaderInfo;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;

	public class IResourceToClass extends EventDispatcher
	{
		public function IResourceToClass():void
		{

		}
		/**
		 * @param 从一个LoaderInfok中获得一个Class对象
		 * @param 例如：IResourceGetClass(_LoaderInfo,_classname);
		 * @param 返回值为Class,可自已转化类型。
		 */
		public function IResourceGetClass(_LoaderInfo:LoaderInfo,classname:String):Class{
			//创建被加载swf的应用程序域
			var appDomain:ApplicationDomain=_LoaderInfo.applicationDomain as ApplicationDomain;
			//getDefinition方法从指定的应用程序域获取一个公共定义。 
			//该定义可以是一个类、一个命名空间或一个函数的定义。
			//其中"myClass"为被加载swf文件里影片剪辑链接属性里的类
			var MCClass:Class=appDomain.getDefinition(classname) as Class;
			//创建MCClass实例，并返回影片剪辑对象
			return MCClass;			
		}
	}
}