package HLib.Net.Socket
{	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	import HLib.Event.ModuleEvent;
	import HLib.Tool.HLog;
	import HLib.UICom.BaseClass.HTopBaseView;
	import HLib.UICom.Component.HAlert;
	import HLib.UICom.Component.HAlertItem;

	import starling.events.Event;

	public class Connect extends EventDispatcher
	{
		private var _Stage:Stage;
		private var _Config:XML;
		private var _SocketRandom:SocketRandom=new SocketRandom();
		public var Version:String="1.0.0";	
		
		public var ipAddress:String;
		public var port:int = 9000;				
		private var _socket:Socket;
		
		private static var MyInstance :Connect;
		public function Connect()
		{
			if( MyInstance )
			{
				throw new Error ("单例只能实例化一次,请用 getInstance() 取实例。");
			}
			
			_tmpBytes = new ByteArray();
			_tmpBytes.endian = Endian.LITTLE_ENDIAN;
			MyInstance = this;			
		}		
		
		private var _tmpBytes:ByteArray;
		public function InIt(_xml:XML,stageRoot:Stage):void
		{
			if(_xml==null)
			{
				return;
			}
			_Stage = stageRoot;
			_Config = _xml;			
			_socket = new Socket();
			//连接c++的时候需要反转下顺序
			//if(serverType == CPP) 
			
			_socket.endian = Endian.LITTLE_ENDIAN;
			_socket.addEventListener(flash.events.Event.CONNECT, handleSocketConnection);
			_socket.addEventListener(flash.events.Event.CLOSE, handleSocketDisconnection);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			_socket.addEventListener(IOErrorEvent.NETWORK_ERROR, handleIOError);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			//			StageFrame.addGameFun(handleSocketData);
			ipAddress = String(_Config.LogicServer);
			port = int(_Config.LogicPort);
			
			HLog.getInstance().addPropertyCount("Set ip:"+ipAddress+"    port:"+port);
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
		
		public function setHoldRand(value:int):void
		{
			_SocketRandom.srand(value);
		}
		
		public function connect(ip:String = "", p:int = -1):void
		{
			if(ip != "") 
			{
				this.ipAddress = ip;
			}
			if(p != -1) 
			{
				this.port = p;
			}
			HLog.getInstance().addPropertyCount("开始 ----> connect ip:"+ipAddress+"    port:"+port);
			_socket.connect(ipAddress, port);
		}
		
		public function disconnect():void
		{
			if (_socket.connected)
			{
				_socket.close()
			}
		}
		
		public function sendServer(modlueKey:int, msgKey:int, msgArgs:Array = null):void
		{
			var order:Order = new Order(); 
			order.setMsgHead(_SocketRandom.rand(), msgKey);
			order.writeBody(msgArgs);
			
			writeToSocket(order);
		}	
		
		private var _SocketFlag:Boolean=false;//缓冲区是否挂起
		private var _length:int = 0;
		
		public var totalFlow:uint = 0;
		//		private var _ReadStartTime:Number=0;
		private function handleSocketData(evt:ProgressEvent):void
		{	
			//			if (_socket.connected)
			{
				//				_ReadStartTime =  getTimer();
				while(_socket.bytesAvailable)// && getTimer() - _ReadStartTime < 5
				{
					if(_SocketFlag)
					{
						if(_socket.bytesAvailable >= _length)
						{
							totalFlow += _length + 4;
							_tmpBytes.clear();
							_socket.readBytes(_tmpBytes, 0, _length);
							Resolve(_tmpBytes);
							_SocketFlag = false;
						}
						else
						{
							break;
						}
					}
					else
					{
						if(_socket.bytesAvailable < 2)
						{
							break;
						}
						_length = _socket.readUnsignedShort();
						_SocketFlag = true;
					}
				}
			}
		}
		
		
		private var _ResolveFlag:Boolean = false;//解析是否挂起
		private var _Order:Order;
		private function Resolve(buffer:ByteArray):void
		{
			if(_ResolveFlag)
			{
				if(buffer.bytesAvailable >= 16383)
				{
					buffer.readBytes(_Order, _Order.bytesAvailable, 0);
					return;
				}
				if(buffer.bytesAvailable != 4)
				{
					buffer.readBytes(_Order, _Order.bytesAvailable, 0);
				}
				OnRecv();
				_ResolveFlag = false;
			}
			else
			{
				_Order = new Order();
				_Order.endian =  Endian.LITTLE_ENDIAN;
				buffer.readBytes(_Order, 0, 0);
				if(_Order.bytesAvailable == 16383)
				{
					_ResolveFlag = true;
				}
				else
				{
					OnRecv();
				}
			}
		}
		
		private function OnRecv():void
		{
			_Order.getMsgHead();
			_Order.MsgType = 0;//强制设置Type为0
			_length = 0;
			
			var eventKeyStr:String = "" + _Order.MsgType + _Order.MsgId;
			if( _callBackDic[eventKeyStr] != null )
			{
				_callBackDic[eventKeyStr]( _Order );//执行回调
			}
		}	
		
		/**
		 * 添加回调方法
		 * @param $type
		 * @param $callBack
		 */		
		public function addOrderCallBack($type:String, $callBack:Function):void
		{
			_callBackDic[$type] = $callBack;
		}
		
		/**
		 * 移除回调方法
		 * @param $type	: 回调类型
		 */		
		public function removeOrderCallBack($type:String):void
		{
			if(_callBackDic[$type] == null) 
			{
				return;
			}
			delete _callBackDic[$type];
		}
		
		private var _callBackDic:Dictionary = new Dictionary();
		private var _HAlertItem:HAlertItem;
		
		private function handleSocketConnection(e:flash.events.Event):void
		{
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, handleSocketData);
			trace("连接成功");
			this.dispatchEvent( new ConnetEvent(ConnetEvent.ConnetSuccess));
		}
		
		private function writeToSocket(byte:ByteArray):void
		{
			if (_socket.connected)
			{
				_socket.writeBytes(byte);
				_socket.flush();
			}
		}
		
		private function onAlertYes(e:starling.events.Event):void
		{
			HTopBaseView.getInstance().removeClickChildWindow(_HAlertItem);
			if (ExternalInterface.available)
			{
				ExternalInterface.call('relogin')
				//ExternalInterface.call("function onRefreshSocket() {location.reload() ;}")
			}
		}
		
		private function handleSocketDisconnection(e:flash.events.Event):void
		{
			trace("连接断开...");
			var str:String = "socket已断开，点击刷新";
			if(_HAlertItem == null)
			{
				_HAlertItem = HAlert.show(str,"提示",HTopBaseView.getInstance(), "确定");
				_HAlertItem.addEventListener("HAlertYes", onAlertYes);	
			}
			else
			{
				HTopBaseView.getInstance().addClickChildWindow(_HAlertItem);
				_HAlertItem.visible = true;
			}var vx:int = HTopBaseView.getInstance().myWidth;
			if(vx < 1)
				vx = 400;
			var vy:int = HTopBaseView.getInstance().myHeight
			if(vy < 1)
				vy = 400;
			_HAlertItem.x = vx - _HAlertItem.myWidth >> 1;
			_HAlertItem.y = vy - _HAlertItem.myHeight >> 1;
		}
		
		private function handleIOError(err:IOErrorEvent):void
		{
			trace("连接出错...", err);
		}
		
		private function handleSecurityError(err:SecurityErrorEvent):void
		{
			trace("连接出错...", err);
			HLog.getInstance().addPropertyCount("handleSecurityError:" + err.text);
		}
		/**读取64整数*/
		public function readUint64(order:ByteArray):Number
		{
			var num1:Number = order.readUnsignedInt();
			var num2:Number = order.readUnsignedInt();
			return num1 + num2 * (1+uint.MAX_VALUE);
		}
		/**写入64整数*/
		public function writeUint64(num:Number):ByteArray
		{
			var byte:ByteArray = new ByteArray();
			byte.endian = Endian.LITTLE_ENDIAN;
			var num1:int = num/(1+uint.MAX_VALUE);
			var num2:int = num%(1+uint.MAX_VALUE);
			byte.writeUnsignedInt(num2);
			byte.writeUnsignedInt(num1);
			byte.position = 0;
			return byte
		}
	}
}