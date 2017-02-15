package tl.Net.Socket
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	import tl.utils.HashMap;

	public class Connect extends EventDispatcher implements IConnect
	{
		private var _Config:XML;
		private var _SocketRandom:SocketRandom=new SocketRandom();
		private var _HashMap:HashMap=new HashMap();
		private var _AaronEncoding:Encoding=new Encoding();	
		public var Version:String="1.0.0";	
		public var NetKey:int=0;
		public var AllLength:int=0;
		public var ipAddress:String;
		public var port:int = 9000;				
		private var _IsReConnect:Boolean=true;	
		private var _Connected:Boolean=false;	
		private var socketConnection:Socket;
		private var byteBuffer:ByteArray;		
		
		public var benchStartTime:int;
		public var benchTime:int;
		private var _benchTimer:Timer;
		
		private static var MyInstance :Connect;
		public function Connect(){
			if( MyInstance ){
				throw new Error ("单例只能实例化一次,请用 getInstance() 取实例。");
			}
			MyInstance=this;			
		}		
		public function InIt(_xml:XML):void
		{
			if(_xml==null) return;
			_Config=_xml;			
			initialize();	
			//Security.allowDomain("*");
			//Security.loadPolicyFile("xmlsocket://"+ipAddress+":843");text
			socketConnection = new Socket();
			//连接c++的时候需要反转下顺序
			//if(serverType == CPP) 
			
			socketConnection.endian = Endian.LITTLE_ENDIAN;
			socketConnection.addEventListener(Event.CONNECT, handleSocketConnection);
			socketConnection.addEventListener(Event.CLOSE, handleSocketDisconnection);
			socketConnection.addEventListener(ProgressEvent.SOCKET_DATA, handleSocketData);
			socketConnection.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			socketConnection.addEventListener(IOErrorEvent.NETWORK_ERROR, handleIOError);
			socketConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);

			ipAddress = String(_Config.LogicServer);
			port = int(_Config.LogicPort);
			trace("Set ip and port:",ipAddress, port);
//			HLog.getInstance().appMsg("Set ip:"+ipAddress+"    port:"+port);
			//连接服务端
			connect(ipAddress,port);
		}
		
		public static function getInstance() :Connect 
		{
			if ( MyInstance == null ) 
			{				
				MyInstance = new Connect();
			}
			return MyInstance;
		}			
		
		private function initialize(isLogOut:Boolean = false):void
		{
			Version = "0.0.1";
			//if(serverType == CPP) byteBuffer.endian =  Endian.LITTLE_ENDIAN;
			
			//serverType = CPP;
			
			_benchTimer = new Timer(1000);
			_benchTimer.addEventListener(TimerEvent.TIMER, benchTimerHandler);
		}
		public function setHoldRand(value:int):void{
			_SocketRandom.srand(value);
		}
		public function connect(ip:String = "", p:int = -1):void
		{
			
			if (!_Connected)
			{
				if(ip != "") this.ipAddress = ip;
				if(p != -1) this.port = p;
				trace("connect", ipAddress, port)
//				HLog.getInstance().appMsg("connect ip:"+ipAddress+"    port:"+port);
				socketConnection.connect(ipAddress, port);
				
			}
			else
				debugMessage("*** ALREADY CONNECTED ***");
		}
		
		public function disconnect():void
		{
			_Connected = false
			socketConnection.close()
			
			// dispatch event
			//sysHandler.dispatchDisconnection()
		}

		public function send(o:Order,showLoading:Boolean=false):void
		{
			trace("send",o.length,o.ItoString());
			writeToSocket(o);
		}
		public function sendServer(modlueKey:int,msgKey:int,msgArgs:Array = null):void
		{
			
			var _Order:Order = new Order(); 
			_Order.setMsgHead(_SocketRandom.rand(),msgKey);
			//_Order.setMsgHead(modlueKey,msgKey);
			_Order.writeBody(msgArgs);
			send(_Order);
		}	
		public function Call(handlerFunction:Function,modlueKey:int,msgKey:int,msgArgs:Array = null):void{
			var _handlerFunction:Function=handlerFunction;
			var _Order:Order = new Order(); 
			_Order.setMsgHead(_SocketRandom.rand(),msgKey);
			//_Order.setMsgHead(modlueKey,msgKey);
			_Order.writeBody(msgArgs);
			send(_Order);
			this.addEventListener(""+modlueKey+""+msgKey,_handlerFunction);
		}
		public function startRoundTripBench():void
		{
			//trace("startRoundTripBench", _benchTimer)
			_benchTimer.start();
		}
		public function stopRoundTripBench():void
		{
			_benchTimer.stop();
		}
		
		public function roundTripBench():void
		{
			//trace("roundTripBench");
			this.benchStartTime = getTimer();
			//sendSYS(Order.ROUNDTRIPBENCH, [benchTime]);
		}

		private function benchTimerHandler(e:TimerEvent):void
		{
			roundTripBench();
		}
		
		private var _SocketFlag:Boolean=false;//缓冲区是否挂起
		private var _Buffer:ByteArray;
		private var _length:int = 0;
		private function handleSocketData(e:ProgressEvent):void
		{	
//			try{
				while(socketConnection.bytesAvailable){
					if(_SocketFlag){
						if(socketConnection.bytesAvailable>=_length-_Buffer.bytesAvailable){
							socketConnection.readBytes(_Buffer,_Buffer.bytesAvailable,_length-_Buffer.bytesAvailable);
							Resolve(_Buffer);
							_SocketFlag=false;
						}else{
							socketConnection.readBytes(_Buffer,_Buffer.bytesAvailable,0);
							_SocketFlag=true;
						}
					}
					else{
						_length=socketConnection.readShort();
						_Buffer=new ByteArray();
						_Buffer.endian =  Endian.LITTLE_ENDIAN;
						if(socketConnection.bytesAvailable>=_length){
							socketConnection.readBytes(_Buffer,0,_length);
							Resolve(_Buffer);
						}else{
							socketConnection.readBytes(_Buffer,0,0);
							_SocketFlag=true;
						}
					}
				}
//			}catch(e:Error){
//				
//			}
		}
		private var _ResolveFlag:Boolean=false;//解析是否挂起
		private var _Order:Order;
		private function Resolve(buffer:ByteArray):void{
			if(_ResolveFlag){
				if(buffer.bytesAvailable>=16383){
					buffer.readBytes(_Order,_Order.bytesAvailable,0);
					return;
				}
				//var _Flag:int=buffer.readUnsignedInt();
				//if(_Flag!=3135093469){
				if(buffer.bytesAvailable!=4){
					//_Order.writeInt(_Flag);
					buffer.readBytes(_Order,_Order.bytesAvailable,0);
				}
				OnRecv();
				_ResolveFlag=false;
				return;
			}
			if(!_ResolveFlag){
				_Order=new Order();
				_Order.endian =  Endian.LITTLE_ENDIAN;
				buffer.readBytes(_Order,0,0);
				if(_Order.bytesAvailable==16383){
					_ResolveFlag=true;
				}else{
					OnRecv();
				}
				return;
			}
		}
		private function OnRecv():void{
			_Order.getMsgHead();
			_Order.MsgType=0;//强制设置Type为0
			NetKey++;
			_length=0;
			trace("Receive:"+NetKey+"    ReceiveLength:"+_length+"    "+_Order.ItoString());
//			HLog.getInstance().appMsg("Receive:"+NetKey+"    ReceiveLength:"+_length+"    "+_Order.ItoString());
//			ModuleEventDispatcher.getInstance().Count(""+_Order.MsgType+""+_Order.MsgId);
			this.dispatchEvent(new ConnetEvent(""+_Order.MsgType+""+_Order.MsgId,_Order));	
			Count("MsgId"+_Order.MsgId);
		}	
		private function Count(EventKey:String):void{
			//统计事件分发的次数
			if(_HashMap.get(EventKey)){
				var _Num:int=_HashMap.get(EventKey);
				_Num+=1;
				_HashMap.put(EventKey,_Num);
			}else{
				_HashMap.put(EventKey,1);
			}
		}
		private function handleSocketConnection(e:Event):void
		{
			trace("连接成功");
//			HLog.getInstance().appMsg("连接成功");
			this.dispatchEvent( new ConnetEvent(ConnetEvent.ConnetSuccess));
		}
		
		private function writeToSocket(byte:ByteArray):void
		{
			//trace("writeToSocket", socketConnection);
			
			try
			{
				//socketConnection.writeInt(byte.length);
				socketConnection.writeBytes(byte);
				socketConnection.flush();
			}catch(e:Error)
			{
				trace("socket没有连接..."); 
//				HLog.getInstance().appMsg("socket没有连接...");
				//this.stopRoundTripBench();	  
			}
		}
		
		private function handleSocketDisconnection(e:Event):void
		{
			trace("连接断开...");
//			HLog.getInstance().appMsg("连接断开...");
			if(_IsReConnect){
				trace("尝试重新连接...");
//				HLog.getInstance().appMsg("尝试重新连接...");
				socketConnection.connect(ipAddress, port);
			}
		}
		
		private function handleIOError(e:IOErrorEvent):void
		{
			trace("连接出错...");
//			HLog.getInstance().appMsg("连接出错...");
			if(_IsReConnect){
				trace("尝试重新连接...");
//				HLog.getInstance().appMsg("尝试重新连接...");
				socketConnection.connect(ipAddress, port);
			}
		}
		
		private function handleSecurityError(e:SecurityErrorEvent):void
		{
			trace("handleSecurityError:"+e.text);
//			HLog.getInstance().appMsg("handleSecurityError:"+e.text);
		}
		
		
		private function debugMessage(message:String):void
		{
			/*
			if (this.debug)
			{
				trace(message)
				
				var evt:SFSEvent = new SFSEvent(SFSEvent.onDebugMessage, {message:message})
				dispatchEvent(evt)
			}
			*/
		}

		public function get IsReConnect():Boolean
		{
			return _IsReConnect;
		}
		
		public function set IsReConnect(value:Boolean):void
		{
			_IsReConnect = value
		}
		public function get myHashMap():HashMap{
			return _HashMap;
		}
	}
}