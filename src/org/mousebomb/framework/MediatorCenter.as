/**
 * Created by gaord on 2016/12/14.
 */
package org.mousebomb.framework
{
	import away3d.containers.Scene3D;

	import flash.display.DisplayObject;
	import flash.events.Event;

	import flash.utils.Dictionary;

	import org.mousebomb.framework.MediatorBase;

	import tool.StageFrame;

	public class MediatorCenter
	{

		private static var instance:MediatorCenter;

		/** */
		public function MediatorCenter()
		{
			if (instance) throw new Error("单例只能实例化一次,请用 getInstance() 取实例。");
			instance = this;
		}

		public static function getInstance():MediatorCenter
		{
			instance ||= new MediatorCenter();
			return instance;
		}

		/** [ view ] => mediator */
		private var map:Dictionary = new Dictionary();

		/** 手动map view和mediator ，此时view刚addChild过了 */
		public function mapMediator(view:*, mediatorClass:Class):*
		{
			var mediator:* = new mediatorClass();
			mediator.view  = view;
			map[view]      = mediator;
			mediator.onAdd();
			if (view is DisplayObject)
			{
				view.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFlashView);
			}else{
				trace(StageFrame.renderIdx,"MediatorCenter/mapMediator 目前尚未支持 View:" + view +"将不会自动移除mediator");
			}
			return mediator;
		}

		private function onRemoveFlashView(event:Event):void
		{
			var view:*                = event.target;
			var mediator:MediatorBase = map[view];
			mediator.onRemove();
			delete map[view];
		}

	}
}
