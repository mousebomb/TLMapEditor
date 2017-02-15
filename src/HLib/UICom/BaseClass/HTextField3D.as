package HLib.UICom.BaseClass
{
	/**
	 * 3D文字
	 * @author 李舒浩
	 * 
	 * 用法:
	 * 		var textField3D:HTextField3D = new HTextField3D();
	 *		textField3D.init(0);
	 *		textField3D.setDefaultSkin();
	 *		view3D.scene.addChild(textField3D);
	 *		textField3D.text = "+123456789";
	 * 
	 * 属性与方法:
	 * 		init()					: 初始化方法,传入类型(0:位图 1:文本), 如果设置为1,这调用text或label时会把文本draw成位图赋值
	 * 		setSkin()				: 添加图片方法,此方法一般用于如添加"暴击","必杀"...此类文字图片使用,或自定义图片使用
	 * 		setDefaultSkin()		: 默认数字图片
	 * 		text					: 内容(如果是加血,则传入字符串("+123456789"),减血("-123456789"))
	 * 		label					: 7位颜色+2位字体大小+内容, #f9f9f916这里要显示的内容 
	 * 		algin					: 文本对齐样式
	 * 		font					: 字体
	 * 		size					: 字体大小
	 * 		color					: 字体颜色
	 * 		bold					: 是否加粗
	 * 		leading					: 字体间距
	 * 		textDic					: 位图保存字典,一般用于自定义了位图后,获取字典dispose()用
	 * 		disposeWithChildren()	: 释放资源方法
	 */	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import HLib.Event.Event_F;
	import HLib.Event.ModuleEvent;
	import HLib.Event.ModuleEventDispatcher;
	import HLib.IResources.IResourceManager;
	import HLib.IResources.IResourcePool;
	import HLib.Pools.ObjectPools;
	import HLib.Pools.ResPool;
	import HLib.Tool.Tool;
	
	import Modules.Common.ComEventKey;
	import Modules.MainFace.MainInterfaceManage;
	import Modules.Wizard.WizardKey;
	import Modules.Wizard.Move.TweenObjectProxy;
	
	import away3DExtend.MeshExtend;
	
	import away3d.arcane;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;
	import away3d.tools.utils.TextureUtils;

	import starling.events.Event;

	use namespace arcane;
	public class HTextField3D extends MeshExtend
	{
		private static var _textDic:Dictionary = new Dictionary();	//资源
		
		public var maiLoadCallBack:Function;	//字体加载完毕执行回调(此方法只执行一次,执行完后会释放=null)
		
		/** 皮肤类型 **/
		public function get skinType():int
		{ 
			return _skinType;
		}
		private var _skinType:int;
		
		public var completionWidthNum:int;		//补全位图的宽度
		public var completionHeightNum:int;	//补全位图的高度
		public var myWidth:Number;				//文本实际宽度
		public var myHeight:Number;			//文本实际高度
		
		private var _drawBitmapdata:BitmapData;
		private var _textField:HTextField2D;
		private var _text:String = "";
		private var _textureMaterial:TextureMaterial;	//贴图
		private var _texture:BitmapTexture;
		private var _type:int = 0;	//文本类型 0:使用图片 1:使用文字
		
		private var _tweenProxy:TweenObjectProxy;
		
		public function HTextField3D()  
		{ 
			_texture = new BitmapTexture(ResPool.inst.getBlendBitmapData(1, 1), false);
			_textureMaterial = new TextureMaterial(_texture, true, false, true);
			_textureMaterial.alphaBlending = true;
			
			super(new PlaneGeometry(1,1), _textureMaterial); 
			
			_tweenProxy = ObjectPools.getTweenProxy(this);//new TweenObjectProxy(this);
		}
		
		public function setHasMip(val:Boolean):void
		{
			_texture.setHasMip(val);
		}
		
		private function refreshTexture(bmd:BitmapData):void
		{
			var tBmd:BitmapData = _texture.bitmapData;
			ResPool.inst.recycleBlendBitmapData(tBmd);
			
			_texture.bitmapData = bmd;
		}
		/**
		 * 初始化
		 * @param type	: 0:位图 1:文本
		 */		
		public function init(type:int = 0):void
		{
			_type = type;
			if(type!=1) 
			{
				return;
			}
			if(!_textField)
			{
				_textField = new HTextField2D();
				Tool.setDisplayGlowFilter(_textField);
			}
			if(MainInterfaceManage.getInstance().fontName == null)
			{
				ModuleEventDispatcher.getInstance().addEventListener(ComEventKey.MAI_LOAD_COMPLETE, onMaiLoadComplete);
			}
			else
			{
				maiLoadCallBack = null;
			}
		}
		/** 当字体加载完时执行刷新 **/
		private function onMaiLoadComplete(e:starling.events.Event):void
		{
			ModuleEventDispatcher.getInstance().removeEventListener(ComEventKey.MAI_LOAD_COMPLETE, onMaiLoadComplete);
			text = text;
			_isLoadTxt = true;
			if(maiLoadCallBack != null) maiLoadCallBack();
			maiLoadCallBack = null
		}
		
		//		/**
		//		 * 自定义添加皮肤
		//		 * @param obj	: 皮肤obj{key:value(图片对应的文字), key:value(bitmapdata)}
		//		 */		
		//		public function setSkin(obj:Object):void
		//		{
		//			_textDic ||= new Dictionary();
		//			for(var key:String in obj)
		//			{
		//				_textDic[key] = obj.key;
		//			}
		//		}
		/**
		 * 设置默认皮肤
		 * @param $type	: 类型(0:红字 1:加血 2:暴击 3:普通 4:闪避 5:吸血 6:卓越 7:防御成功)
		 */		
		public function setDefaultSkin($type:int = 0):void
		{
			_skinType = $type;
			//判断是否已经有此资源了
			if(_textDic[_skinType])
			{
				return;
			}
			_textDic[_skinType] = {};
			//获取位图
			var str:String;
			var classPackName:String = "HPNumberFont";
			var bitmapdata:BitmapData;
			switch(_skinType)
			{
				case 0:	//减血
					str = "HPNumberFont_NumA_";
					break;
				case 1:	//加血
					str = "HPNumberFont_NumB_";
					break;
				case 2:	//暴击
					bitmapdata = IResourcePool.getInstance().getResource("HPNumberFont_Crit");
					if(!bitmapdata)
					{
						/*var cBtmd:BitmapData = IResourceManager.getInstance().getBitmapData("HPNumberFont", "HPNumberFont_Crit_C");
						var riBtmd:BitmapData = IResourceManager.getInstance().getBitmapData("HPNumberFont", "HPNumberFont_Crit_Ri");
						var tBtmd:BitmapData = IResourceManager.getInstance().getBitmapData("HPNumberFont", "HPNumberFont_Crit_T");
						vec = Vector.<BitmapData>([cBtmd, riBtmd, tBtmd]);
						bitmapdata = Tool.groupBitmap(vec);*/
						bitmapdata = IResourceManager.getInstance().getBitmapData("HPNumberFont", "HPNumberFont_Block_Crit");
						IResourcePool.getInstance().addResource("HPNumberFont_Crit", bitmapdata);
					}
					_textDic[_skinType]["Crit"] = bitmapdata;
					str = "HPNumberFont_NumC_";
					break;
				case 3:	//普通
					str = "HPNumberFont_NumD_";
					break;
				case 4:	//闪避
					//Miss
					bitmapdata = IResourcePool.getInstance().getResource("HPNumberFont_Miss");
					if(!bitmapdata)
					{
						/*mBtmd = IResourceManager.getInstance().getBitmapData("HPNumberFont", "HPNumberFont_Miss_M");
						var iBtmd:BitmapData = IResourceManager.getInstance().getBitmapData("HPNumberFont", "HPNumberFont_Miss_I");
						var sBtmd:BitmapData = IResourceManager.getInstance().getBitmapData("HPNumberFont", "HPNumberFont_Miss_S");
						vec = Vector.<BitmapData>([mBtmd, iBtmd, sBtmd, sBtmd]);
						bitmapdata = groupBitmap(vec);*/
						bitmapdata = IResourceManager.getInstance().getBitmapData("HPNumberFont", "HPNumberFont_Block_Miss");
						IResourcePool.getInstance().addResource("HPNumberFont_Miss", bitmapdata);
					}
					_textDic[_skinType]["Miss"] = bitmapdata;
					return;
					break;
				case 5:	//吸血
					str = "HPNumberFont_NumE_";
					break;
				case 6:	//卓越
					bitmapdata = IResourcePool.getInstance().getResource("HPNumberFont_Boom");
					if(!bitmapdata)
					{
						/*bBtmd = IResourceManager.getInstance().getBitmapData("HPNumberFont", "HPNumberFont_Boom_B");
						var ooBtmd:BitmapData = IResourceManager.getInstance().getBitmapData("HPNumberFont", "HPNumberFont_Boom_Oo");
						mBtmd = IResourceManager.getInstance().getBitmapData("HPNumberFont", "HPNumberFont_Boom_M");
						vec = Vector.<BitmapData>([bBtmd, ooBtmd, mBtmd]);
						bitmapdata = groupBitmap(vec);*/
						
						bitmapdata = IResourceManager.getInstance().getBitmapData("HPNumberFont", "HPNumberFont_Block_Block");
						IResourcePool.getInstance().addResource("HPNumberFont_Boom", bitmapdata);
					}
					_textDic[_skinType]["Boom"] = bitmapdata;
					str = "HPNumberFont_NumF_";
					break;
				case 7:	//防御成功
					//block
					bitmapdata = IResourcePool.getInstance().getResource("HPNumberFont_Block");
					if(!bitmapdata)
					{
						/*bBtmd = IResourceManager.getInstance().getBitmapData("HPNumberFont", "HPNumberFont_Block_B");
						var loBtmd:BitmapData = IResourceManager.getInstance().getBitmapData("HPNumberFont", "HPNumberFont_Block_Lo");
						var ckBtmd:BitmapData = IResourceManager.getInstance().getBitmapData("HPNumberFont", "HPNumberFont_Block_Ck");
						vec = Vector.<BitmapData>([bBtmd, loBtmd, ckBtmd]);
						bitmapdata = groupBitmap(vec);*/
						bitmapdata = IResourceManager.getInstance().getBitmapData("HPNumberFont", "HPNumberFont_Block_Boom");
						IResourcePool.getInstance().addResource("HPNumberFont_Block", bitmapdata);
					}
					_textDic[_skinType]["Block"] = bitmapdata;
					return;
					break;
				case 8:	//竞技场战斗力
					bitmapdata = IResourcePool.getInstance().getResource("HPNumberFont_ArenaPower_Font");
					if(!bitmapdata)
					{
						bitmapdata = IResourceManager.getInstance().getBitmapData("HPNumberFont", "HPNumberFont_ArenaPower_Font");
						IResourcePool.getInstance().addResource("HPNumberFont_ArenaPower_Font", bitmapdata);
					}
					_textDic[_skinType]["ArenaPowerFont"] = bitmapdata;
					str = "HPNumberFont_ArenaPower_";
					break;
				case 9:	//竞技场排名
					bitmapdata = IResourcePool.getInstance().getResource("HPNumberFont_ArenaRank_Di");
					if(!bitmapdata)
					{
						bitmapdata = IResourceManager.getInstance().getBitmapData("HPNumberFont", "HPNumberFont_ArenaRank_Di");
						IResourcePool.getInstance().addResource("HPNumberFont_ArenaRank_Di", bitmapdata);
					}
					_textDic[_skinType]["ArenaRankDi"] = bitmapdata;
					
					bitmapdata = IResourcePool.getInstance().getResource("HPNumberFont_ArenaRank_Ming");
					if(!bitmapdata)
					{
						bitmapdata = IResourceManager.getInstance().getBitmapData("HPNumberFont", "HPNumberFont_ArenaRank_Ming");
						IResourcePool.getInstance().addResource("HPNumberFont_ArenaRank_Ming", bitmapdata);
					}
					_textDic[_skinType]["ArenaRankMing"] = bitmapdata;
					str = "HPNumberFont_ArenaRank_";
					break;
				case 10:	//伤害减免
					bitmapdata = IResourcePool.getInstance().getResource("HPNumberFont_hurt");
					if(!bitmapdata)
					{
						bitmapdata = IResourceManager.getInstance().getBitmapData("HPNumberFont", "HPNumberFont_Block_hurt");
						IResourcePool.getInstance().addResource("HPNumberFont_hurt", bitmapdata);
					}
					_textDic[_skinType]["hurt"] = bitmapdata;
					bitmapdata = IResourcePool.getInstance().getResource("HPNumberFont_hurt_%");
					if(!bitmapdata)
					{
						bitmapdata = IResourceManager.getInstance().getBitmapData("HPNumberFont", "HPNumberFont_NumH_%");
						IResourcePool.getInstance().addResource("HPNumberFont_hurt_%", bitmapdata);
					}
					_textDic[_skinType]["%"] = bitmapdata;
					str = "HPNumberFont_NumH_";
					break;
				case 11:	//器魂飘字特效
					str = "HPNumberFont_qiHun_140";
					break;
			}
			//循环获取资源
			for(var i:int = 0; i < 10; i++)
			{
				bitmapdata = IResourcePool.getInstance().getResource(str + i);
				if(!bitmapdata)
				{
					bitmapdata = IResourceManager.getInstance().getBitmapData(classPackName, str + i);
					IResourcePool.getInstance().addResource(str + i, bitmapdata);
				}
				_textDic[_skinType][String(i)] = bitmapdata;
			}
		}
		/**
		 * 文字显示
		 * @param value	: 内容(如果是加血,则传入字符串("+123456789"),减血("-123456789"))
		 */
		public function set text(value:String):void
		{
			if(_text == value && _isLoadTxt)
			{
				return;
			}
			
			_text = value;
			//判断处理类型
			updateTxt();
		}
		
		public function updateTxt():void
		{
			if(_type == 0)
			{
				drawBtmd();
			}
			else
			{
				if(!_textField)
				{
					_textField = new HTextField2D();
					if(MainInterfaceManage.getInstance().fontName == null)
					{
						ModuleEventDispatcher.getInstance().addEventListener(ComEventKey.MAI_LOAD_COMPLETE, onMaiLoadComplete);
					}
					else
					{
						_isLoadTxt = true;
					}
				}
				_textField.text = _text;
				drawTextField()
			}
		}
		
		public function set myScale(value:Number):void
		{
			this._myScale = value;
			this.scale(value);
		}
		
		public function get myScale():Number
		{
			return this._myScale
		}
		
		public function get text():String  
		{  
			return _text;
		}
		
		/**
		 * 7位颜色+2位字体大小+内容
		 * #f9f9f916这里要显示的内容 
		 * @param value
		 */		
		public function set label(value:String):void  
		{
			_type = 1;
			_textField ||= new HTextField2D();
			_textField.label = value;  
			drawTextField();
		}
		
		public function get label():String { return _textField.label; }
		/** 文本对齐样式 **/
		public function set algin(value:String):void  {  _algin = value; }//_textField.algin = value;  }
		public function get algin():String { return _algin; }
		private var _algin:String = "left";
		/** 文本字体样式(默认为统一字体,只有特殊需要设置的字体才使用设置) **/
		public function set font(value:String):void  {  _textField.font = value;  }
		/** 字体大小 **/
		public function set size(value:int):void  {  _textField.size = value;  }
		/** 字体颜色 **/
		public function set color(value:uint):void 
		{ 
			_textField.color = value;
		}
		/** 是否加粗 **/
		public function set bold(value:Boolean):void  {  _textField.bold = value;  }
		/** 文本间距 **/
		public function set leading(value:int):void  {  _textField.leading = value;  }
		/** 2D文本,用于给文本设置描边等 **/
		public function get textField():HTextField2D  {  return _textField;  }
		
		private var _isLoadTxt:Boolean;				//嵌入字体加载标志
		private var _myScale:Number = 1.0;
		
		/** 绘制图片 **/
		private function drawBtmd():void
		{
			var btmd:BitmapData;
			//特殊处理文字
			if(_text == "Miss")
			{
				btmd = _textDic[_skinType]["Miss"];
				var vecM:Vector.<BitmapData> = new Vector.<BitmapData>();
				vecM.push(btmd);
				_drawBitmapdata = groupBitmap(vecM)
				refreshTexture(_drawBitmapdata);
				PlaneGeometry(this.geometry).width = btmd.width;
				PlaneGeometry(this.geometry).height = btmd.height;
				return;
			}
			if(_text == "Block")
			{
				btmd = _textDic[_skinType]["Block"];
				var vecB:Vector.<BitmapData> = new Vector.<BitmapData>();
				vecB.push(btmd);
				_drawBitmapdata = groupBitmap(vecB)
				refreshTexture(_drawBitmapdata);
				PlaneGeometry(this.geometry).width = btmd.width;
				PlaneGeometry(this.geometry).height = btmd.height;
				return;
			}
			//处理暴击
			var isCrit:Boolean = false;
			if(_text.indexOf("Crit") > -1)
			{
				isCrit = true;
				_text = _text.replace("Crit", "");	//去掉暴击文字
			}
			var isBoom:Boolean = false;
			if(_text.indexOf("Boom") > -1)
			{
				isBoom = true;
				_text = _text.replace("Boom", "");	//去掉暴击文字
			}
			//去掉战斗力
			var isPower:Boolean = false;
			if(_text.indexOf("ArenaPower") > -1)
			{
				isPower = true;
				_text = _text.replace("ArenaPower", "");	//去掉战斗力文字
			}
			//去掉 "第"与"名"
			var isArenaRank:Boolean = false;
			if(_text.indexOf("Di") > -1 && _text.indexOf("Ming") > -1)
			{
				isArenaRank = true;
				_text = _text.replace("Di", "").replace("Ming", "");	//去掉战斗力文字
			}
			var isHurt:Boolean ;		//去掉伤害减免
			if(_text.indexOf("hurt") > -1)
			{
				isHurt = true;
				_text = _text.replace("hurt", "");
			}
			var isQi:Boolean;
			if(_text.indexOf("HPNumberFont_qiHun_") > -1)
			{
				isQi = true;
			}
			if(isQi)
			{
				_drawBitmapdata = _textDic[_skinType][_text];
			}	
			else 
			{
				var arr:Array = _text.split("");
				var len:int = arr.length;
				var vec:Vector.<BitmapData> = new Vector.<BitmapData>(len);
				for(var i:int = 0; i < len; i++)
				{
					vec[i] = _textDic[_skinType][arr[i]];
				}
				if(isCrit)	vec.unshift(_textDic[_skinType]["Crit"]);
				if(isBoom)	vec.unshift(_textDic[_skinType]["Boom"]);
				if(isHurt)	vec.unshift(_textDic[_skinType]["hurt"]);
				if(isPower)	vec.unshift(_textDic[_skinType]["ArenaPowerFont"]);
				if(isArenaRank)
				{
					vec.unshift(_textDic[_skinType]["ArenaRankDi"]);
					vec.push(_textDic[_skinType]["ArenaRankMing"]);
				}
				_drawBitmapdata = groupBitmap(vec);	
			}
			refreshTexture(_drawBitmapdata);
			PlaneGeometry(this.geometry).width = _drawBitmapdata.width;
			PlaneGeometry(this.geometry).height = _drawBitmapdata.height;
		}
		
		public function get width():Number
		{
			return PlaneGeometry(this.geometry).width;
		}
		
		public function get height():Number
		{
			return PlaneGeometry(this.geometry).height;
		}
		
		/** 绘制文本 **/
		public function drawTextField():void
		{
			_textField.width = _textField.textWidth + 4;
			_textField.height = _textField.textHeight + 4;
			//计算补全的大小
			myWidth = _textField.width;
			myHeight = _textField.height;
			//获得一个最接近的二次幂矩形
			
			var size:uint = TextureUtils.getBestPowerOf2(myWidth > myHeight ? myWidth : myHeight);
			var tmpw:uint = TextureUtils.getBestPowerOf2(myWidth);
			var tmph:uint = TextureUtils.getBestPowerOf2(myHeight);
			var drawBmd:BitmapData;
			drawBmd = ResPool.inst.getBlendBitmapData(tmpw, tmph);
			drawBmd.fillRect(drawBmd.rect, 0);
			
			var matrix:Matrix = new Matrix();
			switch(_algin)
			{
				case "left":
					//					Tool.drawAlginBtmd(btmd, _drawBitmapdata, 4);
					matrix.translate(0, (tmph - myHeight) / 2);
					break;
				case "center":
					matrix.translate((tmpw - myWidth) / 2, (tmph - myHeight) / 2);
					//					Tool.drawAlginBtmd(btmd, _drawBitmapdata, 5);
					break;
				case "right":
					matrix.translate(drawBmd.width - _textField.width, (tmph - myHeight) / 2);
					//					Tool.drawAlginBtmd(btmd, _drawBitmapdata, 6);
					break;
			}
			drawBmd.draw(_textField, matrix);
			refreshTexture(drawBmd);
			PlaneGeometry(this.geometry).width = drawBmd.width;
			PlaneGeometry(this.geometry).height = drawBmd.height;
		}
		
		public function get bmdSize():Number
		{
			return Math.max(myWidth, myHeight);
		}
		
		/** 组装位图 **/
		private function groupBitmap(bitmapDataArr:Vector.<BitmapData>):BitmapData
		{
			//获取组合位图的宽高值
			var w:Number = 0;
			var h:Number = bitmapDataArr[0].height;
			for each(var btmd:BitmapData in bitmapDataArr)
			{
				w += btmd.width;
				if(h < btmd.height) 
				{
					h = btmd.height;
				}
			}
			
			//计算补全的大小
			myWidth = w;
			myHeight = h;
			var size:uint = TextureUtils.getBestPowerOf2(w > h ? w : h);
			var tmpw:uint = TextureUtils.getBestPowerOf2(myWidth);
			var tmph:uint = TextureUtils.getBestPowerOf2(myHeight);
			
			var drawBmd:BitmapData;
			drawBmd = ResPool.inst.getBlendBitmapData(tmpw, tmph);
			drawBmd.fillRect(drawBmd.rect, 0);
			//对齐排列
			switch(_algin)
			{
				case "left":
					startX = 0;
					break;
				case "center":
					startX = (tmpw - w) / 2;
					break;
				case "right":
					startX = tmpw - w;
					break;
			}
			
			var startX:Number;
			var rectangle:Rectangle;	//绘制的矩形
			var startY:Number = (tmph - myHeight) / 2;
			var len:int = bitmapDataArr.length;
			for (var i:int = 0; i < len ; ++i)
			{
				rectangle = new Rectangle(0, 0, bitmapDataArr[i].width, bitmapDataArr[i].height);
				drawBmd.copyPixels(bitmapDataArr[i], rectangle, new Point(startX, startY + (h - rectangle.height) >> 1));
				startX += rectangle.width;
				startX = ( startX % 2 == 0 ? startX : startX + 1);
			}
			return drawBmd;
		}
		
		/*
		override public function set x(val:Number):void
		{
			super.x = (val % 2 == 0 ? val : val + 1);
		}
		
		override public function set y(val:Number):void
		{
			super.y = (val % 2 == 0 ? val : val + 1);
		}*/
		
		public function get alpha():Number
		{
			return _textureMaterial.alpha;
		}
		public function set alpha(val:Number):void
		{
			_textureMaterial.alpha = val;
		}
		//=---------------------------------------------------------------------------------------------------------------------------------------
		
		public function move(tx:Number, ty:Number, tz:Number, delay:Number, ease:*):void
		{
			scale(0.3);
			_tweenProxy.to(delay, {x:this.x + tx, y:this.y + ty, z:this.z + tz, scaleX:0.8, scaleY:0.8, scaleZ:0.8, 
				ease:ease, onComplete:move_in1});
		}
		private function move_in1():void
		{
			_tweenProxy.to(0.2, {alpha:0, onComplete:onMoveComplete});
		}
		
		public function move1(tx:Number, ty:Number, tz:Number, delay:Number, ease:*):void
		{
			scale(0.3);
			_tweenProxy.to(delay, {x:this.x + tx, y:this.y + ty, z:this.z + tz, scaleX:0.8, scaleY:0.8, scaleZ:0.8, 
				ease:ease, onComplete:move1_in1});
		}
		
		private var _move1In4TimeId:uint = 0;
		private function move1_in1():void
		{
			clearTimeout(_move1In4TimeId);
			_move1In4TimeId = setTimeout(move1_in4, 0.1);
//			TweenLite.delayedCall(0.1, move1_in4);
		}
		
		private function move1_in4():void
		{
			_tweenProxy.to(0.2, {y:this.y + 100, alpha:0, onComplete:onMoveComplete});
		}
		
		private function move1_in3():void
		{
			_tweenProxy.to(0.2, {alpha:0, onComplete:onMoveComplete});
		}
		
		public function move2(tx:Number, ty:Number, tz:Number, delay:Number, ease:*):void
		{
			scale(0.3);
			_tweenProxy.to(delay, {x:this.x + tx, y:this.y + ty, z:this.z + tz, scaleX:0.8, scaleY:0.8, scaleZ:0.8, 
				ease:ease, onComplete:move2_in1});
		}
		
		private function move2_in1():void
		{
			_tweenProxy.to(0.2, {onComplete:move2_in3});
		}
		
		private function move2_in3():void
		{
			_tweenProxy.to(0.2, {y:this.y + 100, alpha:0, onComplete:onMoveComplete});
		}
		
		//=---------------------------------------------------------------------------------------------------------------------------------------
		private function onMoveComplete():void
		{
			alpha = 1;
			
			_tweenProxy.stop();
			
			this.dispatchEvent(new Event_F(WizardKey.Action_Destination, this));
		}
		
		/** 清理HTextField3D对象 **/
		public function clearHTF3D():void
		{
			ModuleEventDispatcher.getInstance().removeEventListener(ComEventKey.MAI_LOAD_COMPLETE, onMaiLoadComplete);			
			maiLoadCallBack = null;
			
			_tweenProxy.stop();
			
			this.identity();
			
			clearTimeout(_move1In4TimeId);
			
			_texture.setHasMip(false);
			_texture.downTexture();
			
			visible = true;
			if (parent != null)
			{
				parent.removeChild(this);
			}
		}
		
		public var isDispose:Boolean;
		/** 释放资源 **/
		override public function dispose():void
		{
			if (isDispose)
			{
				return;
			}
			
			isDispose = true;
			
			clearTimeout(_move1In4TimeId);
			
			ObjectPools.recycleTweenProxy(_tweenProxy);
			_tweenProxy.dispose();
			_tweenProxy = null;
			
			_textureMaterial.dispose();
			
			ResPool.inst.recycleBlendBitmapData(_texture.bitmapData);
			
			ModuleEventDispatcher.getInstance().removeEventListener(ComEventKey.MAI_LOAD_COMPLETE, onMaiLoadComplete);			
			maiLoadCallBack = null;
			_textField = null;
			this.geometry.dispose();
			
			_texture.dispose();
			
			super.dispose();
		}
	}
}