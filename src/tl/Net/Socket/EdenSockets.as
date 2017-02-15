package tl.Net.Socket
{
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.XMLSocket;
	import flash.system.System; 
	
	public class EdenSockets extends Sprite{
		private var socket:XMLSocket; 
		public function EdenSockets() 
		{ 
			System.useCodePage = true; 
			socket = new XMLSocket(); 
			socket.addEventListener( Event.CONNECT, onConnect ); 
			socket.addEventListener( IOErrorEvent.IO_ERROR , failConnect ); 
			socket.addEventListener( DataEvent.DATA, onDatas ); 
			
			
		}
		public function EdenConnet(IP:String,Port:int):void{
			socket.connect(IP, Port);
		}
		public function onConnect(myStatus:Event):void 
		{ 
			trace("连接成功\n"); 
			//立即发送成功 信息到服务器 
			socket.send("<policy-file-request/>\n"); 
		} 
		public function failConnect(myStatus:IOErrorEvent):void 
		{ 
			trace("连接失败\n"); 
		} 
		public function onDatas(event:DataEvent):void 
		{ 
			if(event.data != null) 
			{ 
				trace(event.data + "\n"); 
			} 
		} 
	} 
	
}
