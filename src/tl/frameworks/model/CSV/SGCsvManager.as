package tl.frameworks.model.CSV
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.CompressionAlgorithm;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	import tl.IResources.IResourcePool;
	import tl.mapeditor.Config;
	import tl.utils.HashMap;
	import tl.utils.Tool;

	public class SGCsvManager extends EventDispatcher
	{
		private static var _sgCsvManager:SGCsvManager;
		
		private var _path:String;
		private var _urlLoader:URLLoader;
		private var _isComplete:Boolean = false;
		
		public var table_action:HCSV = new HCSV();			//精灵动作表
		public var table_wizard:HCSV = new HCSV();			//精灵表
		public var table_map:HCSV = new HCSV();			//地图表
		public var table_barrier:HCSV = new HCSV();		//
		public var table_coef:HCSV = new HCSV();			//
		public var table_skill:HCSV = new HCSV();			//技能表
		public var table_skillup:HCSV = new HCSV();		//
		public var table_buff:HCSV = new HCSV();			//buff表
		public var table_effect:HCSV = new HCSV();			//特效表
		public var table_quest:HCSV = new HCSV();			//
		public var table_item:HCSV = new HCSV();			//物品表
		public var table_keyword:HCSV = new HCSV();		//
		public var table_tipsitem:HCSV = new HCSV();		//文本提示
		public var table_player:HCSV = new HCSV();			//player表
		public var table_shop:HCSV  =  new HCSV();			//商店表
		public var table_bless:HCSV = new HCSV;			//强化数据
		public var table_title:HCSV = new HCSV;			//称号
		public var table_function:HCSV = new HCSV;			//功能开放
		public var table_camp:HCSV = new HCSV;				//功能开放
		public var table_freshen:HCSV = new HCSV;			//我要变强
		public var table_vip:HCSV = new HCSV;				//vip
		public var table_vipWelfare:HCSV = new HCSV;		//vip等级福利
		public var table_nameslib:HCSV = new HCSV();		//随机名字列表
		public var table_activity:HCSV = new HCSV();		//活动列表
		public var table_activitykey:HCSV = new HCSV();	//活动达标列表
		public var table_escort:HCSV = new HCSV();		    //镖车奖励列表
		public var table_info:HCSV = new HCSV();			//飘字提示语
		public var table_config:HCSV = new HCSV();		    //配置奖励列表
		public var table_promotions:HCSV = new HCSV();		//促销活动表
		public var table_spoken:HCSV = new HCSV();			//精灵聊天气泡表
		public var table_ai:HCSV = new HCSV();				//ai表
		public var table_activityIcon:HCSV = new HCSV();	//ai表
		public var table_equipSet:HCSV = new HCSV();		//套装属性
		public var table_indAthletics:HCSV = new HCSV();	//套装属性
		public var table_worldMap:HCSV = new HCSV();		//世界地图资源
		public var table_achieve:HCSV = new HCSV();		//英雄成就资源
		public var table_material:HCSV = new HCSV();		//材料获取路径
		
		public var skillObjDictionary:Dictionary = new Dictionary;
		public var wizardObjDictionary:Dictionary = new Dictionary;
		public var itemObjDictionary:Dictionary = new Dictionary;
		public var questObjDictionary:Dictionary = new Dictionary;
		public var actionObjDictionary:Dictionary = new Dictionary;
		
		private var _csvVec:Vector.<HCSV> = Vector.<HCSV>([
			table_action, table_wizard, table_map, table_barrier, table_coef, table_skill, table_skillup, 
			table_buff, table_effect, table_quest, table_item,table_keyword,table_tipsitem,table_player,
			table_shop, table_bless, table_title, table_function, table_freshen,table_camp,table_vip,table_vipWelfare,
			table_nameslib,table_activity,table_activitykey,table_escort,table_info,table_config, table_promotions,
			table_spoken,table_ai,table_activityIcon,table_equipSet,table_indAthletics, table_worldMap, table_achieve,
			table_material
		]);
		
		private var _csvNameVec:Vector.<String> = Vector.<String>([
			"action", "wizard", "map", "barrier", "coef", "skill", "skillup", 
			"buff", "effect", "quest", "item", "keyword", "tipsitem",  "player", 
			"shop", "bless",  "title",  "function",  "freshen", "camp", "vip", "vipwelfare", 
			"nameslib", "activity", "activitykey", "escort", "info", "config",  "promotions", 
			"spoken", "ai", "activityIcon", "equipset", "indAthletics",  "worldMap", "achieve", 
			"material"
		]);
		
		public function SGCsvManager()
		{
			if(_sgCsvManager) throw new Error("单例只能实例化一次,请用 getInstance() 取实例。");
			_sgCsvManager = this;
		}
		
		public static function getInstance():SGCsvManager
		{
			_sgCsvManager ||= new SGCsvManager();
			return _sgCsvManager;
		}
		
		
		public function InIt(path:String=""):void
		{
			if(_isComplete){
				this.dispatchEvent(new Event("SGCsvManagerComplete"));
				return;
			}
			
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlLoader.addEventListener(Event.COMPLETE, onComplete);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);	
			_urlLoader.addEventListener(ProgressEvent.PROGRESS,onPROGRESS);
			_urlLoader.load(new URLRequest(Config.PROJECT_URL+"csv.jpg"+"?v="+Config.VERSION_NUN));
			trace("Load "+Config.PROJECT_URL+"csv.jpg"+"?v="+Config.VERSION_NUN);
		}
		
		
		private function onComplete(e:Event):void
		{
			_analyzeByte = _urlLoader.data;
			_analyzeByte.uncompress(CompressionAlgorithm.LZMA);
			//执行解析
			analyzeCSV();
		}
		
		private var _analyzeByte:ByteArray;
		/** 执行解析 **/
		private function analyzeCSV():void
		{
			var lastFrameTime:Number = getTimer();
			var type:int;
			while(Tool.hasTime(lastFrameTime))
			{
				if(_analyzeByte.bytesAvailable)
				{
					//获得类型
					type = _analyzeByte.readByte();
					switch(type)
					{
						case 1:	//csv
							var name:String = _analyzeByte.readUTF();	//csv名字
							var len:int = _analyzeByte.readInt();		//csv总长度
							var dataLen:int = _analyzeByte.readInt();	//csv单行长度
							//执行截取
							var hashMap:HashMap = new HashMap();
							var colnameArr:Array = [];
							var arr:Array;
							for(var i:int = 0; i < len; i++)
							{
								arr = [];
								for(var j:int = 0; j < dataLen; j++)
								{
									arr[j] = _analyzeByte.readUTF();
								}
								hashMap.put(arr[0], arr);
								if(i == 0)
									colnameArr = arr;
							}
							//执行保存
							name = name.replace(".csv", "");
							//获得对应的csv索引
							var index:int = _csvNameVec.indexOf( name );
							if(index > -1)
							{
								var csv:HCSV = _csvVec[index];
								csv.hashMap = hashMap;			//保存数据hashmap
								csv.colnameArr = colnameArr;	//保存标题数组
							}
							break;
						case 2:	//xml
							var xmlNmae:String = _analyzeByte.readUTF();				//读取名字
							//							trace(xmlNmae);
							var xmlLen:int = _analyzeByte.readInt();					//读取长度
							var xmlByteStr:String = _analyzeByte.readUTFBytes(xmlLen);	//读取xml
							
							var xml:XML = XML( xmlByteStr );
							IResourcePool.getInstance().addResource(xmlNmae, xml);
							break;
					}
				}
				else
				{
					_analyzeByte.clear();
					_analyzeByte = null;
					
					_isComplete = true;
					this.dispatchEvent(new Event("SGCsvManagerComplete"));
					return;
				}
			}
			var timeout:uint = setTimeout(function():void
			{
				clearTimeout(timeout);
				analyzeCSV();
			}, 50);
		}
		/** 获取一个xml **/
		public function getXml(resName:String):XML
		{
			return IResourcePool.getInstance().getResource(resName+".xml");
		}
		
		private function onIOError(pEvt:IOErrorEvent):void
		{
			trace("读取数据表失败！")
		}
		private function onPROGRESS(e:ProgressEvent):void 
		{
//			trace("SGCsvManager/onPROGRESS" , int(e.bytesLoaded)+"/"+int(e.bytesTotal));
		}
		
		public function get IsComplete():Boolean{  return _isComplete;  }
		
		public function get Count():int  {  return _csvVec.length;  }
		
		
		
//*************************************************  old time: 2015-02-27    author: 李舒浩
//*************************************************  如果用二进制转换的csv.jpg出问题的话可以还原以下代码,恢复原来的处理方式
//		private static var MyInstance:SGCsvManager;
//		private var _CsvNameArray:Array=[
//			  "wizard"			//角色表
//			 ,"coef"			//配置表
//			 ,"action"			//精灵动作表
//			 ,"skill"			//技能
//			 ,"item"			//物品
//			 ,"buff"			//buff
//		];
//		private var _FZip:FZip=new FZip();
//		private var _IsComplete:Boolean=false;
//		private var _key:int=0;
//		
//		public var table_wizard:HCSV = new HCSV();			//角色表
//		public var table_coef:HCSV = new HCSV();			//配置表
//		public var table_action:HCSV = new HCSV();			//精灵动作表
//		public var table_skill:HCSV = new HCSV();			//技能
//		public var table_item:HCSV = new HCSV();			//物品
//		public var table_buff:HCSV = new HCSV();			//Buff
//		
//		private var _CsvArray:Array=[
//			table_wizard
//			,table_coef
//			,table_action
//			,table_skill
//			,table_item
//			,table_buff
//		];
//		
//		public function SGCsvManager()
//		{
//			if( MyInstance ){
//				throw new Error ("单例只能实例化一次,请用 getInstance() 取实例。");
//			}
//			MyInstance=this;
//		}
//		public static function getInstance():SGCsvManager{
//			if(!MyInstance){
//				MyInstance=new SGCsvManager();	
//			}
//			return MyInstance;
//		}
//		public function InIt(path:String=""):void{
//			if(_IsComplete){
//				this.dispatchEvent(new Event("SGCsvManagerComplete"));
//				return;
//			}
//			_FZip.addEventListener(IOErrorEvent.IO_ERROR, onIOError);	
//			_FZip.addEventListener(ProgressEvent.PROGRESS,onPROGRESS);
//			_FZip.addEventListener(Event.COMPLETE,onComplete);
//			_FZip.load(new URLRequest(Config.PROJECT_URL+"csv.jpg"+"?v="+Config.VERSION_NUN));
//		}
//		private function onComplete(pEvt:Event):void {
//			//----------------解析zip-----------------------
//			try{
//				var _Count:int =_FZip.getFileCount();
//				var len:int = _CsvNameArray.length;
//				for(var i:int = 0;i<len; i++)
//				{
//					var zipfile:FZipFile = _FZip.getFileByName(_CsvNameArray[i]+".csv");
//					_CsvArray[i].dataString = zipfile.content.readUTFBytes(zipfile.content.bytesAvailable);
//					//_CsvArray[i].OnSetSrc(str);
//				}
//				_FZip.close();
//			}
//			catch(e:Error){
//				trace(e.message);
//			}
//			_IsComplete=true;
//			this.dispatchEvent(new Event("SGCsvManagerComplete"));
//		}
//		private function onIOError(pEvt:IOErrorEvent):void {
//			trace("读取数据表失败！");
//			this.dispatchEvent(new Event("SGCsvManagerError"));
//		}
//		private function onPROGRESS(e:ProgressEvent):void {
//			trace(int(e.bytesLoaded)+"/"+int(e.bytesTotal));
//		}
//		public function get Count():int{
//			return _CsvArray.length;
//		}
//		public function get IsComplete():Boolean{
//			return _IsComplete;
//		}
	}
}