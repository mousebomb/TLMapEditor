package tl.Net
{
	public class MsgKey
	{
		//----------------tokentype------------------------------------------------------------				
		public static const _unknown:String ="_unknown";		
		public static const _byte:String ="_byte";//字节-- 1字节
		public static const _String:String ="_String";	//字符串	-- 4字节
		public static const _int:String ="_int";//带符号的32位整数-- 4字节
		public static const _float:String ="_float";//单精度32位浮点数-- 4字节
		public static const _boolean:String ="_boolean";//boolean型用0或1表示-- 1字节
		public static const _short:String ="_short";//短整理-- 2字节	
		public static const _object:String ="_object";//AMF 序列化格式进行编码的对象。-- 自定义字节长度
		public static const _double:String ="_Number";//又精度浮点数-- 8字节
		public static const _binary:String ="_binary";//-- 自定义字节长度
		public static const _unit:String ="_uint";//不带符号的整数，也就是是正整数-- 4字节
		//---------------- 客户端状态常量--------------------------------------------------------------				
		public static const State_LoadingConfig:int = 0;//读取配置文件状态		
		public static const State_Login:int = 1;//登录状态
		public static const State_CreateRole:int = 2;//创建角色状态
		public static const State_ConnectStateType_Queue:int = 3;// 排队态	
		public static const State_ConnectStateType_Wait:int = 4;// 等待态，等待前一相同角色下线
		public static const State_ConnectStateType_Build:int = 5;/// 构建角色态，用于从数据库读取所有必须的角色数据
		public static const State_GameInIt:int = 6;//游戏状态
		public static const State_ConnectStateType_Logout:int = 7;// 退出态
		public static const State_ResourceLoading:int = 8;//读取数据表状态
		public static const State_ConnectServer:int = 9;//连接服务器状态
		//----------------服务端主动断开类型常量--------------------------------------------------------------
		public static const CCR_Unknow:int = 0;				/// 未知原因
		public static const CCR_Hack:int = 1	;			/// 黑客行为，用了恶意程序
		public static const CCR_Accelerate:int = 2;			/// 加速行为
		public static const CCR_NoPing:int = 3;				/// 未响应服务器的Ping指令
		public static const CCR_StopService:int = 4;		/// 服务器停止服务
		public static const CCR_Logined:int = 5	;		/// 已经在其他地方登录
		//----------------实体类型---------------------------------------------------------------------	
		public static const Type_Entity:int=0;					    /// 实体
		public static const Type_Item:int=1;							/// 物品
		public static const Type_Bag:int=2;							/// 包裹
		public static const Type_Leechdom:int=3;						/// 药品
		public static const Type_Equipment:int=4;						/// 装备
		public static const Type_WEntity:int=5;						/// 世界实体
		public static const Type_Creature:int=6;						/// 生物
		public static const Type_Player:int=7;						/// 玩家
		public static const Type_Monster:int=8;						/// 怪物
		public static const Type_Corpse:int=9;						/// 尸体
		public static const Type_GameObj:int=10;						/// 游戏对象，如陷阱，旗杆，标记，传送门等
		public static const Type_Portal:int=11;						/// 传送门
		public static const Type_Chest:int=12;					    /// 宝箱
		public static const Type_Buddy:int=13							/// 伙伴
		public static const Type_Npc:int=14;							/// NPC
		//----------------物品栏类型---------------------------------------------------------------------	
		public static const SkepType_Bag:int=0;			/// 背包栏
		public static const SkepType_Equip:int=1;			/// 装备栏
		public static const SkepType_BuddyEquip1:int=2;  /// 伙伴1装备栏
		public static const SkepType_BuddyEquip2:int=3;
		public static const SkepType_BuddyEquip3:int=4;
		public static const SkepType_BuddyEquip4:int=5;
		public static const SkepType_BuddyEquip5:int=6;
		public static const SkepType_BuddyEquip6:int=7;
		public static const SkepType_BuddyEquip7:int=8;
		public static const SkepType_BuddyEquip8:int=9;
		public static const SkepType_BuddyEquip9:int=10;
		public static const SkepType_BuddyEquip10:int=11;
		public static const SkepType_Stall:int=12;			/// 摊位栏
		public static const SkepType_Skill:int=13;			/// 技能快捷栏
		public static const SkepType_Smelt:int=14;			/// 精炼等打造栏，临时，不需要存储
		public static const SkepType_Shop:int=30;
		public static const SkepType_Max:int=31;
		//----------------战斗行为码---------------------------------------------------------------------	
		public static const BattleAction_Unknow:int=0;			    /// 未知行为码
		public static const BattleAction_Skill:int=1;				    /// 使用技能		(char src, char dst, int skillId)
		public static const BattleAction_Dodge:int=2;					/// 躲闪			(char who)
		public static const BattleAction_Damage:int=3;				/// 受到伤害		(char who, int hp, int flags)
		public static const BattleAction_Death:int=4;				    /// 死亡	        (char who)
		public static const BattleAction_Bout:int=5;				    /// 回合计数		(uchar cnt)
		public static const BattleAction_AddBuff:int=6;				/// 添加Buff		(char who, int buffId)
		public static const BattleAction_RemoveBuff:int=7;			/// 移除Buff		(char who, int buffId)	
		public static const BattleAction_Unreal:int=8;				/// 幻化Buff		(char who, int buffId)
		public static const BattleAction_Blood:int=9;				/// 吸血Buff		(char who, int hp)
		public static const BattleAction_Lower:int=10;				/// 减伤Buff		(char who)
		public static const BattleAction_Instance:int=11;			/// 无敌防护Buff	(char who)
		public static const BattleAction_RewardEx:int=12;			/// 额外掉落		(int itemId, int itemNum)
		public static const BattleAction_Bloodsucker:int=13;			/// 中毒掉血		(int itemId, int itemNum)
		//----------------点击NPC时的行为码---------------------------------------------------------------------		
		public static const Action_Unknow:int=0;							/// 未知行为
		public static const Action_Selected:int=1;						/// 选中对象			
		public static const Action_ViewEquipment:int=2;					/// 查看装备
		public static const Action_AddFans:int=3;	
		//----------------冷却队列类型码---------------------------------------------------------------------				
		public static const QueueType_Transform:int=0;	/// 打造冷却队列
		public static const QueueType_Research:int=1;		/// 科研队列，如阵型，被动技能，天赋
		public static const QueueType_Arena:int=2;		/// 竞技场队列
		public static const QueueType_Channel:int=3;		/// 经脉队列
		public static const QueueType_Recruit:int=4;		/// 招募队列
		public static const QueueType_Hotspring:int=5;	/// 温泉队列
		public static const QueueType_Slave:int=6;		/// 奴隶队列
		public static const QueueType_Soul:int=7;			/// 元婴队列
		public static const QueueType_Farm1:int=8;		/// 农场队列1
		public static const QueueType_Farm2:int=9;		/// 农场队列2
		public static const QueueType_Farm3:int=10;		/// 农场队列3
		public static const QueueType_Farm4:int=11;		/// 农场队列4
		public static const QueueType_Farm5:int=12;		/// 农场队列5
		public static const QueueType_Farm6:int=13;		/// 农场队列6
		public static const QueueType_Farm7:int=14;		/// 农场队列7
		public static const QueueType_Farm8:int=15;		/// 农场队列8
		public static const QueueType_Farm9:int=16;		/// 农场队列9		
		public static const QueueType_Max:int=50;
		//----------------战斗与场景枚举类型码-------------------------------------------------------------------
		public static const BattleResponse_OK:int=0;		/// 点了确定按钮
		public static const BattleResponse_Again:int=1;		/// 重新来过
		public static const BattleResponse_Back:int=2;		/// 回城
		public static const BattleResponse_Barrier:int=3;	/// 下一关		
		public static const BattleResponse_Max:int=10;
		
		public static const BattleResult_Unknow:int=0;		/// 未知结果
		public static const BattleResult_Win:int=1;		/// 单人赢
		public static const BattleResult_Lose:int=2;		/// 单人输
		public static const BattleResult_TeamWin:int=1;	/// 多人组队赢
		public static const BattleResult_TeamLose:int=2;	/// 多人组队输		
		public static const BattleResult_Max:int=10;
		//----------------消息类型---------------------------------------------------------------------		
		public static const MsgType_Unknow:int=0;		/// 未定义
		public static const MsgType_Gateway:int=0;		/// 网关消息
		public static const MsgType_Login:int=0;		/// 登录消息
		public static const MsgType_Client:int = 0;		/// 服务器与客户端的交互消息
		public static const MsgType_Cache:int = 0;		/// 前端服消息
		public static const MsgType_CommonServer:int = 0;	/// 公共服消息
		

		// 网关
		public static const MsgId_Gateway_Handshake:int=1;                        /// [GC] 网关发送一个握手信息给客户端  
		public static const MsgId_Gateway_Ping:int=2;                             /// [GC] 网关发送ping指令到客户端  
		public static const MsgId_Gateway_PingReply:int=3;                        /// [CG] 客户端响应ping指令  
		public static const MsgId_Gateway_NotifyDisconnect:int=4;                 /// [GC] 通知客户端服务器即将关闭该连接，不要重连 (ulong reason) reason参考枚举 CloseConnReason
		public static const MsgId_Gateway_DisconnectReply:int=5;                  /// [CG] 客户端响应服务器关闭连接 (ulong reason) reason直接使用服务器传入的原因即可
		public static const MsgId_Gateway_SendData:int=6;                         /// [LG] 逻辑服向网关上的客户发送数据  
		public static const MsgId_Gateway_Broadcast:int=7;                        /// [LG] 逻辑服向网关上的指定客户列表广播数据  
		public static const MsgId_Gateway_CloseConn:int=8;                        /// [LG] 逻辑服通知网关关闭指定的连接  
		public static const MsgId_Gateway_Ready:int=9;                            /// [LG] 逻辑服通知网关已经准备就绪  
		public static const MsgId_Gateway_Connected:int=10;                       /// [GL] 网关接收了一个客户端连接  
		public static const MsgId_Gateway_HandshakeResponse:int=11;               /// [GL] 网关发给逻辑服的握手信息  
		public static const MsgId_Gateway_RecvData:int=12;                        /// [GL] 网关收到客户端数据  
		public static const MsgId_Gateway_Disconnected:int=13;                    /// [GL] 网关发现客户端断开了连接  
		public static const MsgId_Common_Pulse:int=14;                            /// [[[GL/LG/LF/FL] ]] 心跳包 ()     

		// 世界服
		public static const MsgId_World_Handshake:int=51;                         /// [LW] 逻辑服发给世界服的握手信息 (ulong group, ulong type, const utf8* name) 
		public static const MsgId_World_PostData:int=52;                          /// [LW] 逻辑服通过世界服中转消息 (ulong svrId, ushort bufLen, Buffer buffer) 
		public static const MsgId_World_HandshakeResponse:int=53;                 /// [W*] 世界服响应各区服务器的握手信息 (ulong svrId) 
		public static const MsgId_World_StopService:int=54;                       /// [W*] 世界服通知所有客户停止服务 () 
		public static const MsgId_World_SendMessage:int=55;                       /// [W*] 世界服向其他客户端发送消息 () 
		public static const MsgId_World_SendCommand:int=56;                       /// [W*] 世界服向其他客户端发送命令 (const utf8* command) 
		public static const MsgId_World_UpdateLogin:int=57;                       /// [LW] 逻辑服向世界服更新玩家登陆状态 (int userIdCard, byte isAdult, byte isLogin) 
		public static const MsgId_World_SendHealthState:int=58;                   /// [WL] 世界服向逻辑服发送防沉迷状态 (int userIdCard, uint healthState, uint nCD) 
		public static const MsgId_World_AddMoney:int=59;                          /// [WL] 世界服向逻辑服发送冲值消息 (int userId, int nValue) 
		public static const MsgId_World_Kick:int=60;                              /// [WL] 世界服向逻辑服发送踢人命令 (int actorId) 
		public static const MsgId_World_BrocastInfo:int=61;                       /// [WL] 世界服向逻辑服发送公告消息 (const utf8* info) 
		public static const MsgId_Cache_SendData:int=62;                          /// [AL\LA] 前端向逻辑服推送玩家数据 AL:(int nActorId, [catchData: (rs)...(uint num, *rs)...]) LA:(int nActorId, int nCacheId, [catchData: (rs)]or[(uint num, *rs)...])) 
		public static const MsgId_Cache_Ping:int=63;                              /// [AL\LA] Ping  
		public static const MsgId_Cache_Reconnect:int=64;                         /// [LA] 逻辑服向前端重连玩家 LA:(int nActorId) 
		public static const MsgId_World_HttpRequest:int=65;                       /// [LW] 逻辑服发给世界服的http请求 (const char* url) 
		public static const MsgId_World_HttpResponse:int=66;                      /// [WL] 世界服发给逻辑服的http请求的反馈信息 (const char* result) 
		public static const MsgId_World_Mute:int=67;                              /// [WL] 世界服向逻辑服发送禁言 WL: ulong actorId, int times, int interval 
		public static const MsgId_World_SendMoneyToGM:int=68;                     /// [WL] 世界服向逻辑服发送充值消息 WL: ulong actorId, int pay, int money 
		public static const MsgId_World_ActionOpenOrClose:int=69;                 /// [WL] 世界服向逻辑服发送开/关活动消息 WL: int nAction, int nValue 

		// 登录逻辑
		public static const MsgId_Login_Login:int=101;                            /// [CL] 登录 (ulong loginMode, ...) 
		public static const MsgId_Login_CreateActor:int=102;                      /// [CL] 创建角色 (uchar vocation, uchar gender, ushort faceId, const utf8* actorName) 
		public static const MsgId_Login_SwitchState:int=103;                      /// [LC] 切换登录状态 (ulong state) 
		public static const MsgId_Login_LoginResponse:int=104;                    /// [LC] 登录反馈 (int retval, const char* desc) 
		public static const MsgId_Login_Timestamp:int=105;                        /// [CL\LC] 同步时间戳 CL(uint time)  LC(uint cliTime, uint svrTime) 
		public static const MsgId_Login_ResLoaded:int=106;                        /// [CL] 告诉服务器资源加载完毕 () 
		public static const MsgId_Network_Reconnect:int=107;                      /// [LC] 通知客户端跳转网关 LC: string szIP, uint nPort 

		// 公共消息
		public static const MsgId_Common_Timestamp:int=151;                       /// [LC] 向客户端同步时间戳 (uint time) 
		public static const MsgId_Common_SystemTips:int=152;                      /// [LC] 发送系统提示到客户端 uint nInfoPos, const utf8* text, ushort nMsgBoxVerifyType(默认0; nInfoPos=InfoPos_MsgBoxVerify时使用) 
		public static const MsgId_Common_MsgBoxVerifyResponse:int=153;            /// [CL] 客户端响应选择确认窗口 ushort nMsgBoxVerifyType, byte isOK(1:确定, 0:取消) 
		public static const MsgId_Common_Flags:int=154;                           /// [CL] 选择自动勾选确认窗口 (uint bit, uint isAuto) bit 位数   isAuto 是否自动弹窗 
		public static const MsgId_Common_SetAutoCheck:int=155;                    /// [CL] 选择自动勾选确认窗口 (uint bit) bit 位数 
		public static const MsgId_Common_ProgressBar:int=156;                     /// [CL\LC] 读条 (LC: const utf8* text, uint prograssBarFlag) CL: uint prograssBarFlag, byte isOK 
		public static const MsgId_Common_UpdateDeadList:int=157;                  /// [LC] 当前场景的死亡id LC: ulong id…… 
		public static const MsgId_Common_DestoryDead:int=158;                     /// [LC] 取消死亡状态 LC: ulong id 
		public static const MsgId_Common_AdultInfoBox:int=159;                    /// [LC] 完善未成年防沉迷信息窗口 () 

		// 场景
		public static const MsgId_Scene_EnterMap:int=201;                         /// [CL\LC] 玩家请求进入城镇 CL: ulong mapId（地图ID） LC: ulong mapId（地图ID）, const MapPos& playerPos（主角位置） 
		public static const MsgId_Scene_ChangeLine:int=202;                       /// [CL] 切换分线 CL: ulong lineId（分线ID）LC: ulong lineId（分线ID）, ulong maxNumPerLine（分线最大人数）, [ulong playerNum（分线人数）]*n isWin为BattleResult枚举值，0表示战胜，1为战败，2为组队战胜，3为组队战败
		public static const MsgId_Scene_BroadcastLine:int=203;                    /// [LC] 广播更新切线信息 (uint nMaxNumPerLine, uint nMaxId * [uint PlayerNum]) 

		// 实体行为
		public static const MsgId_Entity_Stand:int=251;                           /// [CL\LC] 实体站立 (UID creatureUID, const MapPos& pos) 
		public static const MsgId_Entity_Move:int=252;                            /// [CL\LC] 实体移动 UID creatureUID（生物UID）, bool needFindPath（是否需服务器寻路）, [const MapPos pos（路点坐标）] * n 
		public static const MsgId_Entity_TalkWithNpc:int=253;                     /// [CL] 玩家点击NPC (UID playerUID, UID npcUID) 
		public static const MsgId_Entity_VisitEntity:int=254;                     /// [CL] 访问指定的实体，可用于点击传送门，点击NPC、玩家、物品等 (UID entityUID, ulong action[, void* context, size_t len]) 
		public static const MsgId_Entity_TalkResponse:int=255;                    /// [CL] 客户端反馈对话结果 (const utf8* userdata) 
		public static const MsgId_Entity_CreatePlayer:int=256;                    /// [LC] 创建主角 (AttrList al) 
		public static const MsgId_Entity_DestroyPlayer:int=257;                   /// [LC] 销毁主角  
		public static const MsgId_Entity_CreateEntity:int=258;                    /// [LC] 创建实体对象 ulong entityType（实体类型）, ulong angle（角度）, ulong posx（位置X）, ulong posy（位置Y）,AttrList al（属性列表） 
		public static const MsgId_Entity_DestroyEntity:int=259;                   /// [LC] 销毁实体对象 (UID entityUID) 
		public static const MsgId_Entity_UpdateAttr:int=260;                      /// [LC] 更新实体某个属性 (ulong entityType, UID entityUID, ulong attrId, var value) 其中value的类型是由attrId决定的
		public static const MsgId_Entity_UpdateEntity:int=261;                    /// [LC] 更新实体属性 (ulong entityType, UID entityUID, AttrList al) 
		public static const MsgId_Entity_Dead:int=262;                            /// [LC] 实体死亡 (UID creatureUID) 
		public static const MsgId_Entity_AddItem:int=263;                         /// [LC] 通知客户端添加一个物品  
		public static const MsgId_Entity_RemoveItem:int=264;                      /// [LC] 通知客户端移除一个物品  
		public static const MsgId_Entity_Talk:int=265;                            /// [LC] 服务器通知客户端打开一个任务对话 (ulong npcId, byte menuType, ...) menuType为0表示任务菜单，紧接(ulong taskId, byte taskState, const utf8* userdata)，当为1时表示功能菜单，紧接(const utf8* menuName, const utf8* userdata)
		public static const MsgId_Entity_WatchPlayer:int=266;                     /// [CL\LC] 更新实体属性 CL: uint ActorId, UID entityUID  LC: uint nPlayerSkill, byte buddyNum * [uint skepID, AttrList al],byte skepNum*[uint skepID, ushort ItemNum*[ushort idx, uint dataSize, ITEM_DATA ] ] 
		public static const MsgId_Entity_GetFightPower:int=267;                   /// [CL\LC] 获取战斗力 CL: UID entityUID  LC: uint nFightPower 
		public static const MsgId_Entity_MoveStop:int=268;                        /// [LC] 实体移动停止 UID creatureUID, const MapPos& pos 

		// 物品栏行为
		public static const MsgId_Skep_UseItem:int=301;                           /// [CL] 客户端使用物品 (UID uidItem) 
		public static const MsgId_Skep_MoveSkepItem:int=302;                      /// [CL\LC] 移动物品栏中的物品，可跨物品栏移动，也可以用于增删 CS(int srcSkepId, int srcIdx, int dstSkepId, int dstIdx)  SC(byte srcSkepId, ushort srcIdx, byte dstSkepId, ushort dstIdx) 
		public static const MsgId_Skep_CreateItems:int=303;                       /// [LC] 创建单个物品或者物品列表到物品数据源中 (int buffSize, AttrList al) * n 个 
		public static const MsgId_Skep_UpdateItem:int=304;                        /// [LC] 更新数据源中的对象 (uint64 guid, AttrList al) 
		public static const MsgId_Skep_DestroyItems:int=305;                      /// [LC] 销毁物品数据源中的一个或者多个物品 (uint64 guid) * n 个 
		public static const MsgId_Skep_CreateSkeps:int=306;                       /// [LC] 创建单个或者多个物品栏 (int buffSize, Buffer buf) * n 个 Buffer: byte skepId,ushort maxSize, [ushort idx1, int64 guid1,...]
		public static const MsgId_Skep_AddSkepItem:int=307;                       /// [LC] 向指定的物品栏添加一个物品引用 (byte skepId, ushort idx, GUID guid) 
		public static const MsgId_Skep_RemoveSkepItem:int=308;                    /// [LC] 从指定的物品栏移除一个物品引用 (byte skepId, ushort idx) 
		public static const MsgId_Skep_Tidy:int=309;                              /// [CL] 整理包裹栏 (uint type) type:整理类型
		public static const MsgId_Skep_UpdateSkep:int=310;                        /// [LC] 更新一个物品栏（暂用于包裹整理） byte skepId,ushort maxSize, [ushort idx1, int64 guid1,...] 
		public static const MsgId_Skep_Buy:int=311;                               /// [CL] 购买包裹栏格子 (uint index) 
		public static const MsgId_Skep_SwepOneKey:int=312;                        /// [CL] 一键换装 int srcSkepId, int dstSkepId 
		public static const MsgId_Skep_AutoEquip:int=313;                         /// [CL] 自动装上装备 int dstSkepId, int dstIdx 

		// 任务
		public static const MsgId_Quest_AcceptQuest:int=351;                      /// [CL] 请求接受指定的任务(不通过NPC和剧情的通过该命令接) (ulong questId) 
		public static const MsgId_Quest_DiscardQuest:int=352;                     /// [CL] 请求放弃指定的任务 (ulong questId) 
		public static const MsgId_Quest_UpgradeQuest:int=353;                     /// [CL] 请求升星指定的任务 (ulong questId, ulong isFull) isFull为1表示直接升到最高级，为0表示升一级
		public static const MsgId_Quest_SubmitQuest:int=354;                      /// [CL] 请求完成指定的任务 (ulong questId, ulong useMoney) useMoney为1表示用元宝立即完成，否则填0
		public static const MsgId_Quest_FullStarLevel:int=355;                    /// [CL] 请求满星当天的所有日常任务 () 
		public static const MsgId_Quest_ResetDailyQuests:int=356;                 /// [CL] 重置日常任务 () 
		public static const MsgId_Quest_UpdateQuests:int=357;                     /// [LC] 更新整个已接任务列表 (int questNum[, Buffer buf1,…]) Buffer: ulong questId,byte questState,byte condNum[, int cond1Value,…]
		public static const MsgId_Quest_UpdateAcceptableQuests:int=358;           /// [LC] 更新整个可接任务列表 (int questNum[, ulong questId1,…]) 
		public static const MsgId_Quest_UpdateDailyQuests:int=359;                /// [LC] 更新整个日常任务信息 (short resetTimes, byte fullStarDays, int num[, ulong questId1,byte times1, byte starLevel1, …]) resetTimes表示重置次数，fullStarDays表示满星剩余天数
		public static const MsgId_Quest_UpdateKinQuests:int=360;                  /// [LC] 更新整个家族任务信息 (int num[, ulong questId1,byte times1, byte starLevel1, …]) 
		public static const MsgId_Quest_DirectFinish:int=361;                     /// [CL] 请求立即完成指定的任务 (ulong questId) 

		// 商店
		public static const MsgId_Shop_Buy:int=401;                               /// [CL] 在商店购买指定数量的物品 (ulong shopId, ulong itemId, int index, ulong num) 
		public static const MsgId_Shop_Sell:int=402;                              /// [CL] 在商店出售 (ulong shopId, UID uidItem) 
		public static const MsgId_Shop_Open:int=403;                              /// [LC] 打开商店 (ulong shopId) 
		public static const MsgId_Shop_CreateSecretShop:int=404;                  /// [LC] 服务器通知创建神秘商店 (ulong remainTicks, ulong itemIdList[9], byte isBuyed[9]) 
		public static const MsgId_Shop_BuyBySecretShop:int=405;                   /// [CL] 神秘商店购买 (ulong itemId, ulong index) 
		public static const MsgId_Shop_ResetSecretShop:int=406;                   /// [CL] 刷新神秘商店 (int useMoney) useMoney:表明是否使用元宝(0-不使用 1-使用)

		// 聊天
		public static const MsgId_Chat_Message:int=451;                           /// [CL\LC] 聊天消息 [CL]ushort channelType, const char* szMessage, ulong nRecvActorId; [LC]ushort channelType, ulong nKinId, ulong nActorId, const char* szActorName, byte nGender(0女 1男 2未知),ushort nFromWorldId, ushort nFromServerId(为0表示当前服), const char* szMessage 
		public static const MsgId_Chat_ShowItem:int=452;                          /// [CL\LC] 展示物品消息 [CL]ushort channelType, UID itemUID;[LC]ushort channelType, ulong nKinId, ulong nActorId, const char* szActorName, byte nGender(0女 1男 2未知),ushort nFromWorldId, ushort nFromServerId(为0表示当前服), const char* szMessage, [(a)byte nItemShowType(0),  ulong nItemID], [(b)byte nItemShowType(1),  [ulong dataSize, ITEM_DATA]] 
		public static const MsgId_Chat_SendCommand:int=453;                       /// [CL] 发送GM指令 (String cmd) 
		public static const MsgId_Chat_HandleCommand:int=454;                     /// [LC] 处理服务器委托的GM指令 (ulong cmdId, String cmd) 
		public static const MsgId_Chat_SendResult:int=455;                        /// [CL] 发送处理结果到服务器 (ulong cmdId, String cmd, String result) 
		public static const MsgId_Chat_HandleResult:int=456;                      /// [LC] 处理服务器返回的GM指令结果 (String result) 
		public static const MsgId_Chat_GMSuggestion:int=457;                      /// [CL\LC] GM建议 CL: byte type(1bug 2投诉 3建议 4其他)，string titile(主题）， string suggest(内容) LC: byte state(1表示成功，0表示失败) 

		// 打造
		public static const MsgId_Transform_Strong:int=501;                       /// [CL] 强化装备 (UID uidItem, byte onekey) onekey为0表示普通强化，为1表示一键强化
		public static const MsgId_Transform_StrongResponse:int=502;               /// [LC] 强化装备反馈 (UID uidItem, ulong deltaLevel) deltaLevel表示提升的等级，为0表示失败了，没提升
		public static const MsgId_Transform_Smelt:int=503;                        /// [CL\LC] 精炼装备 CL: (UID uidItem) LC: byte isSuccess 
		public static const MsgId_Transform_Upgrade:int=504;                      /// [CL\LC] 升级装备 CL: (UID uidItem) LC: byte isSuccess 
		public static const MsgId_Transform_DoRecoin:int=505;                     /// [CL\LC] 重铸装备 CL: (UID uidItem, byte recoinType: 0=银两 1=元宝) LC: UID uidItem, int ForceAttack武力攻击, int SpellAttack法术攻击, int ForceDefense武力防御, int SpellDefense法术防御, int Present命中, int Dodge闪避, int MaxHP生命值上限, int AttackFreq攻击速度, int ResistPct格挡百分比, int HitbackPct反击, int FatalAttackPct爆击, int MaxSP精气, 
		public static const MsgId_Transform_Choose:int=506;                       /// [CL\LC] 选择装备 CL: (UID uidItem, byte isChoose 是否选择属性) LC:(byte isSuccess, UID uidItem) 
		public static const MsgId_Transform_JewelEmbed:int=507;                   /// [CL\LC] 镶嵌宝石 CL: (UID uidItem装备, UID uidGem宝石, byte nSlotId镶孔位置)  LC: byte isSuccess 
		public static const MsgId_Transform_BreakOutJewel:int=508;                /// [CL\LC] 取回宝石 CL: (UID uidItem装备, byte nSlotId镶孔位置)  LC: byte isSuccess 
		public static const MsgId_Transform_OpenJewelNum:int=509;                 /// [CL\LC] 扩展凹巢数量 (UID uidItem装备) 
		public static const MsgId_Transform_CombineJewel:int=510;                 /// [CL\LC] 合成宝石 (UID uidItem1, UID uidItem2)   1向2发起合成 
		public static const MsgId_Transform_CombineJewelOneKey:int=511;           /// [CL\LC] 一键合成宝石  
		public static const MsgId_Transform_StrongTest:int=512;                   /// [CL] 强化装备测试 (UID uidItem) 
		public static const MsgId_Transform_StrongTestResponse:int=513;           /// [LC] 强化装备测试反馈 (ulong deltaLevel, String msg) deltaLevel表示提升的等级，为0表示失败了，没提升 msg表示客户端显示的描述信息
		public static const MsgId_Transform_DoRecoinReSet:int=514;                /// [CL\LC] 装备重铸重置 CL: UID uidItem LC: UID uidItem， byte isSuccess 

		// 冷却
		public static const MsgId_Queue_Activate:int=551;                         /// [CL] 客户端请求逻辑服激活指定的队列 (uint queueType, int index) 
		public static const MsgId_Queue_Reset:int=552;                            /// [CL] 客户端请求逻辑服重置队列 (uint queueType, int index) index是基于0的索引
		public static const MsgId_Queue_Update:int=553;                           /// [LC] 向客户端更新冷却队列 (ulong queueId, byte visible, byte activated, byte state, ushort times, ulong remainTime) * n个 remainTime为剩余的秒数, times为已经冷却的次数 state为队列状态：0-空闲 1-缓冲 2-冷却 3-结束  activated表明队列是否激活，没激活的话需要购买
		public static const MsgId_Queue_VisibleChanged:int=554;                   /// [LC] 通知客户端重新遍历不可见的队列是否已经满足可见条件 () 

		// 公告版系统
		public static const MsgId_CallBoard_Update:int=601;                       /// [CL\LC] 更新公告版数据 (CL: byte callBoardType LC: byte callBoardType, byte num * data(return) ) 
		public static const MsgId_CallBoard_IsDirty:int=602;                      /// [LC] 通知公告版数据需要更新 (byte callBoardType ) 
		public static const MsgId_PrizeOL_Update:int=603;                         /// [CL\LC] 校准信息(奖励和时间) CL:() LC:(uint nId, uint nTime) 
		public static const MsgId_PrizeOL_DoPrize:int=604;                        /// [CL\LC] 获取奖励 CL:() LC:(uint nId) 

		// 邮件系统
		public static const MsgId_Mail_Update:int=651;                            /// [CL\LC] 更新 CL:() LC:(uint size * [byte MailType, uint MailId, byte MailState, utf8* SenderName, utf8* strTitle, uint nTime, byte hasPrize]) 
		public static const MsgId_Mail_Send:int=652;                              /// [CL\LC] 写信 CL:uint nRecverId(收信人), utf8* strName, utf8* strTitle, utf8* strMail  LC:byte isSuccess(是否发送成功) 
		public static const MsgId_Mail_RecvPlayer:int=653;                        /// [LC] 收玩家信件 uint nMailId, uint nSenderId(发信人), utf8* SenderName, utf8* strTitle, uint nTime 
		public static const MsgId_Mail_RecvSys:int=654;                           /// [LC] 收系统信件 uint nMailId, utf8* strTitle, uint nTime, byte hasPrize 
		public static const MsgId_Mail_Open:int=655;                              /// [CL] 请求打开信件 uint nMailId 
		public static const MsgId_Mail_OpenPlayer:int=656;                        /// [LC] 打开玩家信件 uint nMailId, uint nSenderId(发信人), utf8* SenderName, utf8* strTitle, utf8* strMail, uint nTime 
		public static const MsgId_Mail_OpenSys:int=657;                           /// [LC] 打开系统信件 uint nMailId, utf8* strTitle, utf8* strMail, uint nTime, uint addMoney, uint addBindMoney, uint addExp, uint addSP, uint addCredit, uint itemNum * [uint nItemID, uint nItemNum] 
		public static const MsgId_Mail_Delete:int=658;                            /// [CL\LC] 删除信件 CL:(uint nMailId) LC:(uint nMailId) 
		public static const MsgId_Mail_GetPrize:int=659;                          /// [CL\LC] 获取系统信件附件奖励 uint nMailId, byte nOpenMail(0不打开,1打开) 

		// 活动公共接口
		public static const MsgId_Activities_Start:int=701;                       /// [CL\LC] 活动开始通知 CL: byte type(0为没有任何家族活动，1为家族仙城战，2为家族祭神，3为家族boss，4为世界boss， 5为怪物攻城，6为温泉捕鱼), LC: byte type(0为没有任何家族活动，1为家族仙城战，2为家族祭神，3为家族boss，4为世界boss， 5为怪物攻城，6为温泉捕鱼）, byte start(1表示活动是否开启，0表示活动没有开启) 
		public static const MsgId_Activities_CollectGame:int=702;                 /// [CL\LC] 收藏游戏 LC: byte collect(1为收藏过游戏，0表示没有) 
		public static const MsgId_Activitirs_Hp:int=703;                          /// [LC] 血量的更新 LC: UID uid, ulong curHp, ulong maxHp 
		public static const MsgId_Activitirs_TicketfetchSomeTime:int=704;         /// [LC] 某个时间段的充值元宝 LC: uint nMoney 

		// 公共服务器
		public static const MsgId_CommonServer_Chat:int=751;                      /// [PL\LP] 公共服转发跨服聊天内容  
		public static const MsgId_CommonServer_ShowItem:int=752;                  /// [PL\LP] 跨服展示物品  
		public static const MsgId_CommonServer_WatchPlayer_Ask:int=753;           /// [PL\LP] 跨服查看资料请求  
		public static const MsgId_CommonServer_WatchPlayer_Answer:int=754;        /// [PL\LP] 跨服查看资料答复  
		public static const MsgId_CommonServer_SendFlower_Ask:int=755;            /// [PL\LP] 跨服送花请求  
		public static const MsgId_CommonServer_SendFlower_Answer:int=756;         /// [PL\LP] 跨服送花答复  
		public static const MsgId_CommonServer_Request_CommonRest:int=757;        /// [LP\PL] 请求执行CommonRest存储过程 LP:(utf8 db_IP_Name,int nWorldID)  PL:(byte: 0等待;1执行) 
		public static const MsgId_CommonServer_Finish_CommonRest:int=758;         /// [LP\PL] 执行CommonRest存储过程成功 LP:(utf8 db_IP_Name,int nWorldID,byte:0失败, 1成功)  PL:() 
		public static const MsgId_CommonServer_RegLS:int=759;                     /// [LP\PL] 有新的LS连接到公共服 LP:(int nWorldID, byte nGameLevel, string szGSIP(LS对应的网关IP), uint16 nGSClientPort(LS对应的网关端口)  PL:(int nWorldID, byte nGameLevel, string szGSIP(LS对应的网关IP), uint16 nGSClientPort(LS对应的网关端口)  
		public static const MsgId_CommonServer_GetLSList:int=760;                 /// [LP\PL] 获取注册的LS列表 LP:  PL: uint nSize, [(int nWorldID, byte nGameLevel, string szGSIP(LS对应的网关IP), uint16 nGSClientPort(LS对应的网关端口)] * n 
		public static const MsgId_CommonServer_NewAddMoney:int=761;               /// [LP\PL] 通知另外一个LS的玩家充值信息 LP: uint nActorID, uint nWorldID  PL: uint nActorID 

		// DB服务器
		public static const MsgId_DB_RecvData:int=801;                            /// [DL] DB服务器收到逻辑服的数据  
		public static const MsgId_DB_Handshake:int=802;                           /// [LC] 逻辑服向DB服发送握手信息  

		// 节日
		public static const MsgId_Festival:int=851;                               /// [LC] 节日通知 LC: byte checkType（检查方式）, ushort startYear（开始年）, byte startMonth（开始月）, byte startDay（开始日）, byte startWeekDay（开始周日期）, byte startHour(开始时）, ushort endYear（结束年）, byte endMonth（结束月）, byte endDay（结束日）, byte endWeekDay（结束周日期）, byte endHour（结束时）, string name（活动描述）, byte state（活动状态）, byte festivalId（活动索引） 

		// 飞迁
		public static const MsgId_Flay_Info:int=901;                              /// [CL\LC] 飞迁信息 CL: LC:byte nState(0表示不可飞升,1表示可飞升), byte nOpenWindow(0表示默认, 1表示弹出窗体), uint nLimitTime(剩余飞升倒计时) 
		public static const MsgId_Flay_RequestFlay:int=902;                       /// [CL\LC] 请求飞升 CL: LC:byte succuess(0请求成功,飞升开始; 1请求失败) 

		// 战斗
		public static const MsgId_Battle_UseSkill:int=951;                        /// [CL\LC] 使用技能 CL: ulong skillId（技能ID）, UID targetUid（目标UID）, MapPos targetPos（目标位置） LC: UID casterUid（施法者UID), ulong skillId（技能ID）, UID targetUid（目标UID）, MapPos targetPos（目标位置） 
		public static const MsgId_Battle_CancelSkill:int=952;                     /// [LC] 中断技能（吟唱、引导等） LC: casterUid（施法者UID）, ulong skillId（被中断的技能ID） 
		public static const MsgId_Battle_SkillImpact:int=953;                     /// [LC] 技能生效 LC: UID casterUid（施法者UID）, ulong skillId（技能ID）, [UID targetUid（目标UID）, byte result（技能结果: 0-闪避 1-命中 2-暴击）, int value（数值，负值为扣血，正值为加血）, ulong buffId（添加的BUFF索引）, byte physicEffect（物理效果: 0-无 1-击退 2-击飞 3-击倒）, MapPos deltaPos（偏移位置，有击退击飞效果时才填充该值）] * n 
		public static const MsgId_Battle_AddBuff:int=954;                         /// [LC] 添加Buff LC: UID casterUid（施法者UID)，UID targetUid（目标UID）, ulong buffId（BUFFID）, ulong buffTime（BUFF时长） 
		public static const MsgId_Battle_RemoveBuff:int=955;                      /// [CL\LC] 移除（取消）Buff CL: ulong buffId, LC: UID uid（生物UID), ulong buffId 
		public static const MsgId_Battle_BuffImpact:int=956;                      /// [LC] BUFF生效 LC: ulong buffId, int value（数值，负值为扣血，正值为加血） 
		
	}
}