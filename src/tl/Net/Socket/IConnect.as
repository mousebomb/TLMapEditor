package tl.Net.Socket
{	
	import flash.events.IEventDispatcher;

	public interface IConnect extends IEventDispatcher
	{				
		function connect(ipAdr:String = "", port:int = -1):void;
		function send(o:Order,showLoading:Boolean=false):void;
		//function sendZoneServer(_modlueKey:int,_msgKey:int,_msgArgs:Array = null):void
		function sendServer(_modlueKey:int,_msgKey:int,_msgArgs:Array = null):void
	}
}