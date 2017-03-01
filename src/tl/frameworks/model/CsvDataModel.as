/**
 * Created by gaord on 2017/2/27.
 */
package tl.frameworks.model
{
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	import flash.utils.CompressionAlgorithm;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import org.robotlegs.mvcs.Actor;

	import tl.core.role.model.CsvRoleVO;
	import tl.frameworks.NotifyConst;
	import tl.frameworks.service.bombloader.JYLoader;
	import tl.mapeditor.Config;
	import tl.utils.HashMap;
	import tl.utils.Tool;

	import tool.StageFrame;

	/** 所有配置数据 静态数据 存取
	 * 框架内使用
	 *  封装并分析数据*/
	public class CsvDataModel extends Actor
	{

		public function CsvDataModel()
		{
			super();
		}

		public function init():void
		{
			if (_isComplete)
			{
				dispatchWith(NotifyConst.CSV_LOADED, false);
				return;
			}
			// 配置
			_csvConfigList               = new Dictionary();
			_csvConfigList["wizard.csv"] = new CsvNameConfig(CsvRoleVO, table_wizard);
			//加载
			JYLoader.getInstance().reqResource(Config.PROJECT_URL + "csv.jpg" + "?v=" + Config.VERSION_NUN, JYLoader.RES_BYTEARRAY, 0, JYLoader.GROUP_LOGIN, onComplete, onPROGRESS);
		}


		private var _isComplete:Boolean = false;

		public var table_action:HashMap       = new HashMap();			//精灵动作表
		public var table_wizard:HashMap       = new HashMap();			//精灵表
		public var table_map:HashMap          = new HashMap();			//地图表
		public var table_barrier:HashMap      = new HashMap();		//
		public var table_coef:HashMap         = new HashMap();			//
		public var table_skill:HashMap        = new HashMap();			//技能表
		public var table_skillup:HashMap      = new HashMap();		//
		public var table_buff:HashMap         = new HashMap();			//buff表
		public var table_effect:HashMap       = new HashMap();			//特效表
		public var table_quest:HashMap        = new HashMap();			//
		public var table_item:HashMap         = new HashMap();			//物品表
		public var table_keyword:HashMap      = new HashMap();		//
		public var table_tipsitem:HashMap     = new HashMap();		//文本提示
		public var table_player:HashMap       = new HashMap();			//player表
		public var table_shop:HashMap         = new HashMap();			//商店表
		public var table_bless:HashMap        = new HashMap();			//强化数据
		public var table_title:HashMap        = new HashMap();			//称号
		public var table_function:HashMap     = new HashMap();			//功能开放
		public var table_camp:HashMap         = new HashMap();				//功能开放
		public var table_freshen:HashMap      = new HashMap();			//我要变强
		public var table_vip:HashMap          = new HashMap();				//vip
		public var table_vipWelfare:HashMap   = new HashMap();		//vip等级福利
		public var table_nameslib:HashMap     = new HashMap();		//随机名字列表
		public var table_activity:HashMap     = new HashMap();		//活动列表
		public var table_activitykey:HashMap  = new HashMap();	//活动达标列表
		public var table_escort:HashMap       = new HashMap();		    //镖车奖励列表
		public var table_info:HashMap         = new HashMap();			//飘字提示语
		public var table_config:HashMap       = new HashMap();		    //配置奖励列表
		public var table_promotions:HashMap   = new HashMap();		//促销活动表
		public var table_spoken:HashMap       = new HashMap();			//精灵聊天气泡表
		public var table_ai:HashMap           = new HashMap();				//ai表
		public var table_activityIcon:HashMap = new HashMap();	//ai表
		public var table_equipSet:HashMap     = new HashMap();		//套装属性
		public var table_indAthletics:HashMap = new HashMap();	//套装属性
		public var table_worldMap:HashMap     = new HashMap();		//世界地图资源
		public var table_achieve:HashMap      = new HashMap();		//英雄成就资源
		public var table_material:HashMap     = new HashMap();		//材料获取路径


		private var xmlPool:Dictionary = new Dictionary();

		/**配置csv[表名] 的信息 {} */
		private var _csvConfigList:Dictionary;

//		private var _csvVec:Vector.<HCSV> = Vector.<HCSV>([
//			table_action, table_wizard, table_map, table_barrier, table_coef, table_skill, table_skillup,
//			table_buff, table_effect, table_quest, table_item, table_keyword, table_tipsitem, table_player,
//			table_shop, table_bless, table_title, table_function, table_freshen, table_camp, table_vip, table_vipWelfare,
//			table_nameslib, table_activity, table_activitykey, table_escort, table_info, table_config, table_promotions,
//			table_spoken, table_ai, table_activityIcon, table_equipSet, table_indAthletics, table_worldMap, table_achieve,
//			table_material
//		]);
//
//		private var _csvNameVec:Vector.<String> = Vector.<String>([
//			"action", "wizard", "map", "barrier", "coef", "skill", "skillup",
//			"buff", "effect", "quest", "item", "keyword", "tipsitem", "player",
//			"shop", "bless", "title", "function", "freshen", "camp", "vip", "vipwelfare",
//			"nameslib", "activity", "activitykey", "escort", "info", "config", "promotions",
//			"spoken", "ai", "activityIcon", "equipset", "indAthletics", "worldMap", "achieve",
//			"material"
//		]);


		private function onComplete(url:String, data:ByteArray, mark:*):void
		{
			_analyzeByte = data;
			_analyzeByte.uncompress(CompressionAlgorithm.LZMA);
			//执行解析
			analyzeCSV();
		}

		private var _analyzeByte:ByteArray;

		/** 执行解析 **/
		private function analyzeCSV():void
		{
			var lastFrameTime:Number = StageFrame.curTime;
			var type:int;
			while (Tool.hasTime(lastFrameTime))
			{
				if (_analyzeByte.bytesAvailable)
				{
					//获得类型
					type = _analyzeByte.readByte();
					switch (type)
					{
						case 1:	//csv
							var name:String = _analyzeByte.readUTF();	//csv名字
							var rows:int    = _analyzeByte.readInt();		//csv总长度
							var cols:int    = _analyzeByte.readInt();	//csv单行长度
							if (_csvConfigList[name] == null)
							{
								trace(StageFrame.renderIdx, "[CsvDataModel]/analyzeCSV 缺少csv表绑定:" + name);
								// 跳过
								var escapeLen:int = cols * rows;
								for (var i:int = 0; i < escapeLen; i++)
								{
									_analyzeByte.readUTF();
								}
							} else
							{
								var saveToDic:HashMap = _csvConfigList[name].saveToDic;
								var bindVOClass:Class    = _csvConfigList[name].bindVOClass;
								//执行截取
								var colFieldArr:Array    = [];
								var colTypeArr:Array     = [];
								// 分析字段 前2行是字段描述
								// 字段名
								for (var i:int = 0; i < cols; i++)
									colFieldArr[i] = _analyzeByte.readUTF();
								// 字段类型
								for (i = 0; i < cols; i++)
									colTypeArr[i] = _analyzeByte.readUTF().toLowerCase();
								// 遍历行
								for (i = 2; i < rows; i++)
								{
									// 真正的数据
									var voId:int;
									var voForRow = new bindVOClass();
									for (var j:int = 0; j < cols; j++)
									{
										var colField:String = colFieldArr[j];
										var colType:String  = colTypeArr[j];
										var colVal:String   = _analyzeByte.readUTF();
										if (voForRow.hasOwnProperty(colField))
										{
											// 客户端需要此字段的
											switch (colType)
											{
												case "key":
												case "index":
													voId = voForRow[colField] = int(colVal);
													break;
												case "int":
													voForRow[colField] = int(colVal);
													break;
												case "int[]":
													voForRow[colField] = colVal.split("|");
													break;
												case "remark":
													// 程序忽略
													break;
												case "string":
												case "nstring":
													voForRow[colField] = colVal;
													break;
												default:
													trace(StageFrame.renderIdx, "[CsvDataModel]/analyzeCSV 未定义的类型");
													break;
											}
										}
									}
									saveToDic.put(voId, voForRow);
								}
							}
							break;
						case 2:	//xml
							var xmlName:String    = _analyzeByte.readUTF();				//读取名字
							var xmlLen:int        = _analyzeByte.readInt();					//读取长度
							var xmlByteStr:String = _analyzeByte.readUTFBytes(xmlLen);	//读取xml

							var xml:XML      = XML(xmlByteStr);
							xmlPool[xmlName] = xml;
							break;
					}
				}
				else
				{
					_analyzeByte.clear();
					_analyzeByte = null;

					_isComplete = true;
					dispatchWith(NotifyConst.CSV_LOADED, false);

					return;
				}
			}
			var timeout:uint = setTimeout(function ():void
			{
				clearTimeout(timeout);
				analyzeCSV();
			}, 50);
		}

		/** 获取一个xml **/
		public function getXml(resName:String):XML
		{
			return xmlPool[resName + ".xml"];
		}


		private function onPROGRESS(e:ProgressEvent, target:*):void
		{
			trace(StageFrame.renderIdx, "[CsvDataModel]/onPROGRESS", e.bytesLoaded / e.bytesTotal);
		}

		public function get isComplete():Boolean { return _isComplete; }


	}
}

import flash.utils.Dictionary;

import tl.utils.HashMap;

class CsvNameConfig
{
	public var bindVOClass:Class;
	public var saveToDic:HashMap;

	public function CsvNameConfig(bindVOClass_:Class, saveToDic_:HashMap):void
	{
		bindVOClass = bindVOClass_;
		saveToDic   = saveToDic_;
	}
}
