package HLib.MapBase
{
	/**
	 * map数据类
	 * @author 李舒浩 
	 */	
	import flash.geom.Point;
	
	import HLib.Tool.ConvertArray;
	
	import Modules.Common.SGCsvManager;
	
	public class HMapData
	{		
		/** //地图ID */
		public var mapId:String;				//地图ID
		/** 地图名称 */
		public var name:String;				//地图名称
		/**  地图对应配置XML名 */
		public var xmlName:String;				//地图对应配置XML名
		/** 图片名 */
		public var imageName:String;			//图片名
		/** 场景音乐 */
		public var music:String;				//场景音乐
		/** 跳转点序列(5个一组,[[当前传送点x,当前传送点y,目标地图x,目标地图y,目标地图id],[]...]) */
		public var jumpPoints:Array;			//跳转点序列(5个一组,[[当前传送点x,当前传送点y,目标地图x,目标地图y,目标地图id],[]...])
		/** 复活点序列(4个一组,[两个阵营都可以阵营类型|x|y|可复活次数]) */
		public var revivePoints:Array;			//复活点序列(4个一组,[两个阵营都可以阵营类型|x|y|可复活次数])
		/** 所属章节(副本章节,0为城镇地图) */
		public var section:int;				//所属章节(副本章节,0为城镇地图)
		/** 章节名 */
		public var sectionName:String;			//章节名
		/**
		 0，城镇场景
		 1，不允许PK野外场景
		 2，允许PK野外场景
		 3，单人副本
		 4，多人副本
		 5，跨服多人
		 6，vip多人
		 7，深渊单人副本
		 8，阵营战场(伊苏克斯攻城战)
		 9，鲜血地宫
		 10，封印之地
		 11，末日战场
		 12，守卫女神
		 13，个人竞技场场景
		 14，个人竞技场战斗场景
		 15，新手村【命运之路】
		 16，要塞
		 17，要塞黑暗侵袭
		 18，怪物攻城【日常活动】
		 19，跨服战场-蒸汽之桥
		 20，跨服战场-暴风山谷
		 21，跨服战场-魔幻庄园
		 22，捕鱼活动
		 23，大乐斗活动
		 24，要塞精英试炼
		 25，要塞掠夺副本
		 26，要塞对抗副本
		 27，多人副本-魔幻棋局
		 28，虚空遗迹
		 29，答题活动地图
		 30，灵魂BOSS地图
		 31，天坛宝藏
		 32, 新捕鱼
		 33, 阵营领地
		 @see Modules.Map.MapTypeConsts
		 */
		public var type:int;					//场景类型
		/** 难度等级 */
		public var difflevel:int;				//难度等级
		/** 等级限制 */
		public var mapLevel:int;				//等级限制
		/** 前置条件 */
		public var preCondition:Array;			//前置条件
		/** 体力消耗值 */
		public var needSp:int;					//体力消耗值
		/** 进入需要消耗的魔晶值 */
		public var needRmb:int;				//进入需要消耗的魔晶值
		/** 次数限制 */
		public var count:int;					//次数限制
		/** 购买次数 */
		public var buyTimes:int;				//购买次数
		/** 活动结束时间 */
		public var closeTime:int;				//活动结束时间
		/** 副本目标 */
		public var killTarget:Array;			//副本目标
		/** 副本产出([物品id,物品id...]) */
		public var output:Array;				//副本产出([物品id,物品id...])
		/** 通关奖励(物品id,物品数量) */
		public var reward:Array;				//通关奖励(物品id,物品数量)
		/** 首次通关奖励(物品id,物品数量) */
		public var firstReward:Array;			//首次通关奖励(物品id,物品数量)
		/** 场景介绍 */
		public var desc:String;				//场景介绍
		/** 副本人数 */
		public var personNum:Array;			//副本人数
		/** 定时刷怪 */
		public var createMonster:Array;		//定时刷怪
		/** 最低战斗力 */
		public var fightPowerMin:int;			//最低战斗力
		/** 系列副本 */
		public var series:Array;				//系列副本
		/** 关卡怪物 */
		public var stageMonster:Array;			//关卡怪物
		/** 动态跳转点 */
		public var dynamicJumpPoints:Array;	//动态跳转点
		/** 复活道具 */
		public var revive:int;					//复活道具
		/** 主角光照参数 */
		public var lightProp:Array;			//主角光照参数
		/** 加载描述 */
		public var loadDesc:String;			//加载描述
		/** 副本提示 */
		public var prompt:String;				//副本提示
		/** 挂机标志。０可挂机，１、通关后可挂机，２、不可挂机 */
		public var AllowAutomatic:Array;			//挂机标志。０可挂机，１、通关后可挂机，２、不可挂机
		
		/** 最大玩家数 */
		public var maxPlayers:int;				//最大玩家数
		/** 出生点坐标	*/
		public var birthPos:String;			//出生点坐标	
		/** 英雄初始坐标 */
		public var roleInitPos:String;			//英雄初始坐标
		/** 英雄目标位置坐标 */
		public var roleTargetPos:String;		//英雄目标位置坐标
		/** 剧情ID */
		public var storyId:int;				//剧情ID
		/** 副本罕见掉落物品数组 */
		public var outputItemsArr:Array;		//副本罕见掉落物品数组
		/** 副本等级	 */
		public var instanceLv:int;				//副本等级	
		/** 副本难度 */
		public var instanceDifficulty:String;	//副本难度
		/** 下个个副本跳转的ID */
		public var jumpID:String;				//下个个副本跳转的ID
		/** 地图宽度 */
		public var myWidth:int;				//地图宽度
		/** 地图长度 */
		public var myLength:int;				//地图长度
		/** 地图高度 */
		public var myHeight:int;				//地图高度
		/** 地图宽度 */
		public var mapRows:int;				//地图宽度
		/** 地图长度 */
		public var mapCols:int;				//地图长度
		/** 地图长度 */
		public var smallWidth:int;				//地图宽度
		/** 地图长度 */
		public var smallHeight:int;			//地图长度
		public var mapResPathName:String;		//地图资源名
		public var mapResName:String;			//地图资源名
		public var startPoint:Point;
		/** //调转点数组([0]:point() [1]:point ...) */
		public var jumpPointArr:Array;			//调转点数组([0]:point() [1]:point ...)
		public var pointMatrix:String;			//格子状态
		public var pointH:String;				//格子高度
		/** //精灵数据 */
		public var wizard:String;				//精灵数据
		public var usePackageSkill:Boolean;			//是否可以使用构装技能
		public var isShowResurgence:Boolean = true;	//是否显示复活界面
		public var isShowFarMap:Boolean;			//是否显示远景地图
		/** //是否不区分阵营  0、区分 1、不区分 */
		public var noShowArmy:Boolean;				//是否不区分阵营  0、区分 1、不区分
		public var Ticket:String;					//入场券
		public var CanRide:Boolean;					//是否可以上坐骑
		/** //是否限制使用宠物(血脉宠物/战姬宠物/技能宠物) */
		public var LimitPet:String;					//是否限制使用宠物(血脉宠物/战姬宠物/技能宠物)
		/** //场景预加载资源 */
		public var mapResList:Array;				//场景预加载资源
		/** 	//是否可寻路、使用飞鞋，arr[0]是否可寻路，arr[1]是否可使用飞鞋，0可以，1不可以; */
		public var Pathfinding:Array;				//是否可寻路、使用飞鞋，arr[0]是否可寻路，arr[1]是否可使用飞鞋，0可以，1不可以;
		public var _GridRows:int;
		public var _GridCols:int;
		public var isAutoCleanPackage:Boolean;		//自动 清理背包标志
		public var isAutoResolved:Boolean;			//自动 分解标志
		public var autoWarOrPatrol:Boolean;			//退出场景时自动战斗或者巡城标志
		public var upAutoWarOrPatrol:Boolean;		//上一场景自动战斗或者巡城标志
		
		public const GRID_WIDTH:int = 56;
		public const GRID_WIDTH_CB:Number = 1 / 56;
		public const GRID_HEIGHT:int = 42;
		public const GRID_HEIGHT_CB:Number = 1 / 42;
		public var _NodeArgs:Vector.<Vector.<Node>>;
		
		private const STRAIGHT_COST:Number = 1.0;
		private const DIAG_COST:Number = Math.SQRT2;
		
		public function HMapData()  
		{  
			
		}
		
		public function refresh(id:String):void
		{
			if(id == "0") 
			{
				return;
			}
			var arr:Array = SGCsvManager.getInstance().table_map.FindRow(id);
			if(!arr) return;
			mapId						= arr[0];						//地图ID
			name						= arr[1];						//地图名称
			xmlName						= arr[2];						//地图对应配置XML名
			imageName					= arr[3];						//图片名
			music						= arr[4];						//场景音乐
			var splitArr:Array = String(arr[5]).split("|");
			var len:int = splitArr.length;
			jumpPoints = [];											//跳转点序列(5个一组,[[当前传送点x,当前传送点y,目标地图x,目标地图y,目标地图id],[]...])
			if(len > 1)
			{
				for(var i:int = 0; i < len; i += 5)
				{
					jumpPoints[int(i/5)] = [ splitArr[i], splitArr[i+1], splitArr[i+2], splitArr[i+3], splitArr[i+4] ];
				}	
			}
			splitArr = String(arr[6]).split("|");
			len = splitArr.length;
			revivePoints = [];											//复活点序列(4个一组,[两个阵营都可以阵营类型|x|y|可复活次数])
			for(i = 0; i < len; i += 4)
			{
				revivePoints[int(i/4)] = [ splitArr[i], splitArr[i+1], splitArr[i+2], splitArr[i+3] ];
			}
			section						= int(arr[7]);					//所属章节(副本章节,0为城镇地图)
			sectionName					= String(arr[8]);				//章节名
			type						= arr[9];						//场景类型
			difflevel					= arr[10];						//难度等级
			mapLevel					= arr[11];						//开放等级
			preCondition				= String(arr[12]).split("|");	//前置条件
			needSp						= arr[13];						//体力消耗值
			needRmb						= arr[14];						//进入需要消耗的魔晶值
			count						= arr[15];						//次数限制
			buyTimes					= arr[16]
			closeTime					= int(arr[17]);					//活动结束时间
			killTarget					= String(arr[18]).split("|");	//副本目标
			output						= String(arr[19]).split("|");	//副本产出([物品id,物品id...])
			reward						= String(arr[20]).split("|");	//通关奖励(物品id,物品数量)
			firstReward					= String(arr[21]).split("|");	//首次通关奖励(物品id,物品数量)
			desc						= arr[22];						//场景介绍
			personNum					= String(arr[23]).split("|");	//副本人数
			createMonster				= String(arr[24]).split("|");	//定时刷怪
			fightPowerMin				= int(arr[25]);					//最低战斗力
			series						= String(arr[26]).split("|");	//系列副本
			stageMonster				= String(arr[27]).split("|");	//关卡怪物
			dynamicJumpPoints			= String(arr[28]).split("|");	//动态跳转点
			revive						= int(arr[29]);					//复活道具
			lightProp					= String(arr[30]).split("|");	//主角光照参数
			loadDesc					= String(arr[31]);				//加载描述
			usePackageSkill				= Boolean(int(arr[33]));		//可否使用构装技能标志
			isShowResurgence            = Boolean(int(arr[34]));		//是否显示复活界面
			AllowAutomatic				= String(arr[37]).split("|");	//挂机标志
			prompt           			= String(arr[38]);		        //加载描述
			noShowArmy					= Boolean(int(arr[40]));		//是否不区分阵营
			CanRide 					= Boolean(int(arr[42]));	//是否能上坐骑
			mapResList 					= String(arr[44]).split("|");	//预加载资源
			if(arr[45] == "0")
			{
				Pathfinding 			= [0, 0];
			}
			else
			{
				Pathfinding 			= String(arr[45]).split("|");
			}
			isAutoCleanPackage       	= Boolean(int(arr[46]));
			isAutoResolved       		= Boolean(int(arr[47]));
			autoWarOrPatrol				= Boolean(int(arr[50]));
		}
		public function refreshXml(xml:XML, isRefreshNode:Boolean = true):void
		{
			myWidth                   = int(xml.width);
			myLength                  = 0;
			myHeight                  = int(xml.height);
			mapRows                   = int(xml.maprows);
			mapCols                   = int(xml.mapcols);
			smallWidth                = int(xml.smallwidth);
			smallHeight               = int(xml.smallheight);
			mapResPathName            = xml.maprespath;
			mapResName                = xml.mapresname;
			startPoint                = new Point(xml.startpoint.split(",")[0],xml.startpoint.split(",")[1]);
			//			jumpPoint                 = new Point(xml.jumppoint.split(",")[0],xml.jumppoint.split(",")[1]);
			jumpPointArr = [];
			var arr:Array = xml.jumppoint.split(",");
			var len:int = arr.length;
			for(var i:int = 0; i < len; i+=2)
			{
				jumpPointArr[int(i/2)] = new Point(arr[0], arr[1]);
			}
			pointMatrix               = xml.point;
			pointH					  = xml.pointh;
			wizard                    = xml.wizard;
			
			if(isRefreshNode)
			{
				refreshNodeArgs();
			}
		}
		//----------------------------------------------------------------------------------------------
		private static var _nodePools:Vector.<Node> = new Vector.<Node>();	
		
		private static function getNodeByPool(x:int, y:int):Node
		{
			var tmpNode:Node;
			if (_nodePools.length)
			{
				tmpNode = _nodePools.pop();
			}
			else
			{
				tmpNode = new Node();
			}
			tmpNode.init(x, y);
			return tmpNode;
		}
		
		private static function recycleNode(node:Node):void
		{
			node.reset();
			if (_nodePools.length < 10000)
			{
				_nodePools.push(node);
			}
		}
		//----------------------------------------------------------------------------------------------
		
		/**按地图文件创建Node矩阵*/
		public function refreshNodeArgs():void
		{
			var tmpNode:Node;
			
			var tmpL:Vector.<Node>;
			for each (tmpL in _NodeArgs)
			{
				for each (tmpNode in tmpL)
				{
					recycleNode(tmpNode);
				}
			}
			
			_NodeArgs = new Vector.<Vector.<Node>>();
			_GridCols = int((this.myWidth * GRID_WIDTH_CB) + 0.5);
			_GridRows = int((this.myHeight * GRID_HEIGHT_CB) + 0.5);
			var valArgs:Array = ConvertArray.StringTwoArray(pointMatrix, ",", _GridCols);	//格子信息
			var row:int = valArgs.length;
			var cols:int = valArgs[0].length;
			var tmpVals:Array;
			var tmpw:int = GRID_WIDTH / 2;
			var tmph:int = GRID_HEIGHT / 2;
			for(var i:int = 0; i < _GridRows; i++)
			{
				tmpL = new Vector.<Node>();
				tmpVals = valArgs[i];
				for(var j:int = 0; j < _GridCols; j++)
				{
					tmpNode = getNodeByPool(i, j);//new Node(i, j);
					tmpNode.pointX = j * GRID_WIDTH + tmpw;
					tmpNode.pointY = i * GRID_HEIGHT + tmph;
					if(i < row && j < cols)
					{
						tmpNode.value = int(tmpVals[j]);	//刷新格子类型
						tmpNode.pointH = 0;
					}
					tmpL.push(tmpNode);
				}
				_NodeArgs.push(tmpL);
			}
			
			if (mapId == "30100")
			{
				for each(tmpL in _NodeArgs)
				{
					for each (tmpNode in tmpL)
					{
						if (tmpNode.value == 7)
						{
							tmpNode.walkable = false;
						}
					}
				}
			}
			
			/*_tmpCostVec = new Vector.<Vector.<Number>>();
			for (i = 0; i < _GridRows; i++)
			{
				_tmpCostVec[i] = new Vector.<Number>();
				for (j = 0; j < _GridCols; j++)
				{
					tmpNode = getNode(i, j);
					if (tmpNode)
					{
						_tmpCostVec[i][j] = getNodeCost(tmpNode);
					}
				}
			}
			*/
			calculateLinks();
		}
		
		
//		private var _tmpCostVec:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>(20);
		/**
		 * @param type判断类型
		 */
		public function calculateLinks():void
		{
			var i:int, j:int;
			var tmpNode:Node;
			for (i = 0; i < _GridRows; i++)
			{
				for (j = 0; j < _GridCols; j++)
				{
					initNodeLink(_NodeArgs[i][j], type);
				}
			}
		}
		/**
		 *
		 * @param node
		 * @param type启发参数类型
		 */
		public function initNodeLink(node:Node, type:int):void
		{
			var startX:int = Math.max(0, node.x - 1);
			var endX:int = Math.min(_GridRows - 1, node.x + 1);
			var startY:int = Math.max(0, node.y - 1);
			var endY:int = Math.min(_GridCols - 1, node.y + 1);
			//			node.links = new Vector.<Link>();
			for (var i:int = startX; i <= endX; i++)
			{
				for (var j:int = startY; j <= endY; j++)
				{
					var test:Node = getNode(i, j);
					if (test == null || test == node || !test.walkable)
					{
						continue;
					}
					if (i == node.x || j == node.y)
					{
						node.addLinkNode(test, STRAIGHT_COST);//links.push(new Link(test, STRAIGHT_COST + _tmpCostVec[i][j]));//getNodeCost(test)  + _tmpCostVec[i][j]
					}
					else
					{
						node.addLinkNode(test, DIAG_COST);//node.links.push(new Link(test, DIAG_COST + _tmpCostVec[i][j]));//getNodeCost(test)	 + _tmpCostVec[i][j]
					}
				}
			}
		}
		/*
		private function getNodeCost(node:Node):Number
		{
			var tmpCost:Number = 0;
			
			var tmpNode:Node;
			var half:uint = 1;
			var maxDist:uint = 3;//half * half;
			for (var j:int = -half; j <= half; ++j)
			{
				for (var k:int = -half; k <= half; ++k)
				{
					tmpNode = getNode(node.x + j, node.y + k);
					if (tmpNode && tmpNode != node && tmpNode.walkable == false)
					{
						tmpCost += (maxDist - (Math.abs(j) + Math.abs(k))) * 0.3;
					}
				}
			}
			return tmpCost;
		}*/

		/**判断指定的坐标点区域是否遮挡点 用于要塞盖建筑 */
		public function isBlockInArea( fromX:Number , toX:Number , fromY:Number , toY:Number):Boolean
		{
			var txFrom:int = int(fromX * GRID_WIDTH_CB);
			var txTo:int = int(toX * GRID_WIDTH_CB);
			var tyFrom:int = int(fromY * GRID_HEIGHT_CB);
			var tyTo:int = int(toY * GRID_HEIGHT_CB);
			 for (var i:int = txFrom; i <= txTo; i++)
			 {
				  for (var j:int = tyFrom; j<= tyTo ; j++)
				  {
					  var tmpNode:Node = getNode(j, i);
					  if (tmpNode)
					  {
//					  trace( "isBlockInArea" , j,i ,tmpNode.value);
						  if (!tmpNode.walkable || (NodeTypeConsts.GP_LimitAreaStart <= tmpNode.value && tmpNode.value<=NodeTypeConsts.GP_LimitAreaEnd))
						  {
							  return true;
						  }
					  }
				  }
			 }
			return false;
		}

		/**判断指定的坐标点是否遮挡点*/
		public function isBlock(tmpX:Number, tmpY:Number):Boolean
		{
			var tx:int = int(tmpX * GRID_WIDTH_CB);
			var ty:int = int(tmpY * GRID_HEIGHT_CB);
			var tmpNode:Node = getNode(ty, tx);
			if (tmpNode)
			{
				if (tmpNode.value == 2 || tmpNode.value == 12 || tmpNode.value == 13)
				{
					return true;
				}
			}
			return false;
		}
		
		/** 按指定的坐标点返回此点对应的Node对象 */
		public function getNodeByPoint(point:Point):Node
		{
			return getNode(point.y * GRID_HEIGHT_CB, point.x * GRID_WIDTH_CB);
		}
		
		/** 获取距离终点最近的可行走点 */
		public function getEndNearest(startPoint:Point, endPoint:Point):Node
		{
			var tx1:int = int(startPoint.x * GRID_WIDTH_CB);
			var ty1:int = int(startPoint.y * GRID_HEIGHT_CB);
			var tx2:int = int(endPoint.x * GRID_WIDTH_CB);
			var ty2:int = int(endPoint.y * GRID_HEIGHT_CB);
			
			var retNode:Node;
			
			retNode = getNode(ty2, tx2);
			if (retNode && retNode.walkable)
			{
				return retNode;
			}
			
			if (tx1 == tx2 && ty1 == ty2)
			{
				return getNode(ty1, tx1);
			}
			
			var stepX:int = tx2 - tx1 > 0 ? 1 : -1;
			var stepY:int = ty2 - ty1 > 0 ? 1 : -1;
			var tmpx:int = tx2;
			var tmpy:int = ty2;
			var i:int, j:int;
			var tmpMaxIncr:int = Math.max(Math.abs(tx2 - tx1), Math.abs(ty2 - ty1));
			var tmpIncr:int = 1;
			var tmpNode:Node;
			
			while (tmpIncr < tmpMaxIncr)
			{
				for (i = -tmpIncr; i <= tmpIncr; ++i)
				{
					for (j = -tmpIncr; j <= tmpIncr; ++j)
					{
						if (Math.max(Math.abs(i), Math.abs(j)) == tmpIncr)
						{
							tmpNode = getNode(ty2 + i, tx2 + j);
							if (tmpNode && tmpNode.walkable)
							{
								return tmpNode;
							}
						}
					}
				}
				tmpIncr++;
			}
			
			return null;
		}
		
		/**按指定的索引返回对应的Node对象*/
		public function getNode(r:int, c:int):Node
		{
			if (r < 0 || c < 0 || r >= _GridRows || c >= _GridCols)
			{
				return null;
			}
			return _NodeArgs[r][c];
		}

	}
}