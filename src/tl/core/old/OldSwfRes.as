/**
 * Created by gaord on 2016/12/15.
 */
package tl.core.old
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	import org.mousebomb.framework.GlobalFacade;

	import tl.frameworks.NotifyConst;

	import tl.mapeditor.ResourcePool;

	public class OldSwfRes
	{
		private var _nowLoader:Array;
		private var _loaderContext:LoaderContext;
		private var _isInit:Boolean = false;	//是否初始化完成

		private var _loaderVec:Vector.<Array>;
		public function OldSwfRes()
		{

			/** 加载skin资源包 **/
			_loaderVec = Vector.<Array>([["Skin", new Skin()], ["MainUI", new MainUI()]]);
			_nowLoader = _loaderVec.shift();
			_loaderContext = new LoaderContext();
			_loaderContext.applicationDomain = ApplicationDomain.currentDomain;
			_loaderContext.allowCodeImport = true;
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete, false, 0, true);
			loader.loadBytes(_nowLoader[1], _loaderContext);
		}

		//皮肤swf
		[Embed(source="/../Res/Skin.swf", mimeType="application/octet-stream")]
		public var Skin:Class;
		//主界面swf
		[Embed(source="/../Res/MainUI.swf", mimeType="application/octet-stream")]
		public var MainUI:Class;


		/** 加载完成 **/
		private function onLoaderComplete(e:Event):void
		{
			var loaderInfo:LoaderInfo = LoaderInfo(e.currentTarget);
			loaderInfo.removeEventListener(Event.COMPLETE, onLoaderComplete);
			//添加skin资源
			ResourcePool.getInstance().addRes(_nowLoader[0], loaderInfo);
			if(_loaderVec.length > 0)
			{
				_nowLoader = _loaderVec.shift();
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete, false, 0, true);
				loader.loadBytes(_nowLoader[1], _loaderContext);
				return;
			}
			_nowLoader = null;

//			GlobalFacade.sendNotify(NotifyConst.SWFRES_LOADED,this);

		}


	}
}
