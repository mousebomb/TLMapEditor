package HLib.Csv
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	public class RightClickManage
	{
		static private var rightClickTarget:DisplayObject;
		static public const RIGHT_CLICK:String = "rightClick";
		static private const javascript:XML = 
			<script>
			 <![CDATA[
			  /**
		 * 
		 * Copyright 2007
		 * 
		 * Paulius Uza
		 * http://www.uza.lt
		 * 
		 * Dan Florio
		 * http://www.polygeek.com
		 * 
		 * Project website:
		 * http://code.google.com/p/custom-context-menu/
		 * 
		 * --
		 * RightClick for Flash Player. 
		 * Version 0.6.2
		 * 
		 */
		function(flashObjectId)
		{    
		 var RightClick = {
		  /**
		   *  Constructor
		   */ 
		  init: function (flashObjectId) {
		   this.FlashObjectID = flashObjectId;
		   this.Cache = this.FlashObjectID;
		   if(window.addEventListener){
			 window.addEventListener("mousedown", this.onGeckoMouse(), true);
		   } else {
			document.getElementById(this.FlashObjectID).parentNode.onmouseup = function() { document.getElementById(RightClick.FlashObjectID).parentNode.releaseCapture(); }
			document.oncontextmenu = function(){ if(window.event.srcElement.id == RightClick.FlashObjectID) { return false; } else { RightClick.Cache = "nan"; }}
			document.getElementById(this.FlashObjectID).parentNode.onmousedown = RightClick.onIEMouse;
		   }
		  },
		  /**
		   * GECKO / WEBKIT event overkill
		   * @param {Object} eventObject
		   */
		  killEvents: function(eventObject) {
		   if(eventObject) {
			if (eventObject.stopPropagation) eventObject.stopPropagation();
			if (eventObject.preventDefault) eventObject.preventDefault();
			if (eventObject.preventCapture) eventObject.preventCapture();
			   if (eventObject.preventBubble) eventObject.preventBubble();
		   }
		  },
		  /**
		   * GECKO / WEBKIT call right click
		   * @param {Object} ev
		   */
		  onGeckoMouse: function(ev) {
			 return function(ev) {
			  if (ev.button != 0) {
			RightClick.killEvents(ev);
			if(ev.target.id == RightClick.FlashObjectID && RightClick.Cache == RightClick.FlashObjectID) {
				RightClick.call();
			}
			RightClick.Cache = ev.target.id;
		   }
			}
		  },
		  /**
		   * IE call right click
		   * @param {Object} ev
		   */
		  onIEMouse: function() {
			 if (event.button > 1) {
			if(window.event.srcElement.id == RightClick.FlashObjectID && RightClick.Cache == RightClick.FlashObjectID) {
			 RightClick.call(); 
			}
			document.getElementById(RightClick.FlashObjectID).parentNode.setCapture();
			if(window.event.srcElement.id)
			RightClick.Cache = window.event.srcElement.id;
		   }
		  },
	
		  /**
		   * Main call to Flash External Interface
		   */
		  call: function() {
		   var movieName = this.FlashObjectID;
		   var e;
		   if (window.document[movieName]) {
			e = window.document[movieName];
		   }
		   if (navigator.appName.indexOf("Microsoft Internet") == -1) {
			if (document.embeds && document.embeds[movieName])
			 e = document.embeds[movieName];
		   }else{
			e = document.getElementById(movieName);
		   }
		   if(e!=null){
			e.rightClick();
		   }
		   
		  }
		 }
		 
		 RightClick.init(flashObjectId);
		}
			 ]]>
			</script>;
		
		public function RightClickManage()
		{
			return;
		}
		
		static public function regist() : Boolean
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.call(javascript, ExternalInterface.objectID);
				ExternalInterface.addCallback("rightClick", dispatchRightClickEvent);
				//FlexGlobals.topLevelApplication.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			}// end if
			return true;
		}
		
		static private function mouseOverHandler(event:MouseEvent) : void
		{
			rightClickTarget = DisplayObject(event.target);
			return;
		}
		
		static private function dispatchRightClickEvent() : void
		{
			var event:MouseEvent;
			if (rightClickTarget != null)
			{
				event = new MouseEvent(RIGHT_CLICK, true, false, rightClickTarget.mouseX, rightClickTarget.mouseY);
				rightClickTarget.dispatchEvent(event);
			}// end if
			return;
		}
		
	}
}