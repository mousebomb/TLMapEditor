package HLib.UICom.Component.Icons
{
	/**
	 * Icon基础类(只有自动加载技能图标与显示)
	 * @author 李舒浩 @author 郑利本
	 * 
	 * 用法：
	 * 		var icon:HIcon = new HIcon();
	 *		this.addChild(icon);
	 *		icon.init();
	 *      修改背景图片
	 * 		//设置内容对象即可显示对应的图片
	 *		icon.data = {
	 *			 IconPack:"Skill"	//资源报名
	 *			,IconName:"Skill_0"	//资源连接名
	 *		};
	 * 
	 * 属性与方法:
	 * 		init()			: 初始化方法,	参数 ( 背景图Texture, 没有设置背景时自定义宽度, 没有设置背景时自定义高度 );
	 * 		setBackground()	: 设置背景图片,	参数 ( Texture, 没有设置背景时自定义宽度, 没有设置背景时自定义高度 );
	 * 		data			: 设置|获取内容对象,	参数 ( { IconPack:资源包名, IconName:资源连接名 } );
	 * 		dispose()		: 释放内存
	 * 		iconBtm			: 物品位图
	 * 事件:
	 * 		ClearComponent	: 清除该按钮时派发,一般用于清除内部样式后在外部移除相关事件,从父对象中移除,清空索引等
	 */	
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	
	import HLib.Tool.Tool;
	import HLib.UICom.BaseClass.HSprite;
	
	import Modules.Common.HAssetsManager;
	import Modules.Common.SourceTypeEvent;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.textures.Texture;

	public class HIcon extends HSprite
	{
		private var _myBackTexture:Texture;	//自定义背景图
		private var _backTexture:Texture;		//背景bitmapData
		private var _iconTexture:Texture;		//icon图片数据
		private var _flagTexture:Texture;		//鼠标背景
		private var _data:Object;				//数据对象
		private var _nowBtmdStr:String = "";	//当前显示的是什么图片(IconPack+"_"+IconName);
		private var _iconImage:Image;			//icon位图
		protected var _flagIcon:Image;			//鼠标效果图
		
		protected var _isDispose:Boolean = false;	//是否释放
		protected var _itemType:int;					//当前itemIcon是什么哪里的Icon
		protected var _isLock:Boolean = false;	//是否锁上了
		public var skinWidth:Number = 48;	 	//默认宽
		public var skinHeight:Number = 48;		//默认高
		public var isReverse:Boolean;			//是否逆时针显示
		
		public var reviseX:int = 0;			//icon X修正值
		public var reviseY:int = 0;			//icon Y修正值
		
		public function HIcon()  {  super();  }
		
		/**
		 * 初始化
		 * @param backBtmd	: 背景图
		 * @param $myWidth	: 没有设置背景时自定义宽度
		 * @param $myHeight	: 没有设置背景时自定义高度
		 */		
		public function init():void
		{
			this.touchGroup = true;
			if(_myBackTexture)
			{
				_backTexture = _myBackTexture;
			}	else {
				if(_isLock)
				{
					if(_itemType == HIconData.IconGemInfoType)
						_backTexture =  HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_4,"equiptStrong/icon_lock");
					else
						_backTexture = HAssetsManager.getInstance().getMyTexture("itemIconSoruce","Icon_Lock");
				} 	else {
					if(_itemType == HIconData.IconGemInfoType)
						_backTexture =  HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_TOOLBAR_4,"equiptStrong/icon_open");
					else
						_backTexture = HAssetsManager.getInstance().getMyTexture("itemIconSoruce","Icon_Open");
				}
			}
			if(!_backTexture)
				_backTexture = Texture.fromColor(skinWidth,skinHeight);
			this.myDrawByTexture(_backTexture);
			_iconImage = new Image(_backTexture);
			_iconImage.x = (this.myWidth - _backTexture.width >> 1) + reviseX;
			_iconImage.y = (this.myHeight - _backTexture.height >> 1) + reviseY;
			this.addChild(_iconImage);
			_iconImage.visible = false;
			//设置一下失效状态
			isDisabled = isDisabled;
			
			this.addEventListener(TouchEvent.TOUCH,onMouseEvent)
		}
		
		protected function onMouseEvent(e:TouchEvent):void
		{
			
		}
		/**
		 * 设置技能数据 
		 * @param obj	: 对象数据{ IconPack:资源包名, IconName:资源连接名 }
		 */		
		public function set data(obj:Object):void
		{
			_data = obj;
			//判断要显示的图片是否为现在所显示的图片
			if(!this.isInit || _data == null || _data.Item_IconPack == null || _data.Item_IconName==null || ( _nowBtmdStr == (_data.Item_IconPack+"_"+_data.Item_IconName)))
			{
				if(_data == null)
					clearIcon();
				return;
			}
			//设置物品图片
			_nowBtmdStr = _data.Item_IconPack+"_"+_data.Item_IconName;
			if(_data.Item_IconPack == "icon1")
				_data.Item_IconPack = "itemIconSoruce"
			_iconTexture = HAssetsManager.getInstance().getMyTexture(_data.Item_IconPack, _data.Item_IconName);
			if(_iconImage)
				updateIconImage();
		}
		
		/** 清除内容 **/
		public function clearIcon():void
		{
			if(_isDispose) return;
			_nowBtmdStr = "";
			if(_iconTexture)	
			{
				_iconTexture.dispose();
				_iconTexture = null;
			}
			_iconImage.visible = false;
			this.flagIconTexture = null;
		}
		
		private function updateIconImage():void
		{
			//设置位置
			if(_iconTexture && _iconImage.texture != _iconTexture)
			{
				_iconImage.texture.dispose();
				_iconImage.texture = _iconTexture;
				_iconImage.readjustSize();
				_iconImage.x = (this.myWidth - _iconTexture.width >> 1) + reviseX;
				_iconImage.y = (this.myHeight - _iconTexture.height >> 1) + reviseY;
			}
			_iconImage.visible = _iconTexture == null ? false : true;
		}
		
		public function get data():Object  {  return _data;  }
		
		/**  清除数据 **/		
		public override function dispose():void
		{
			if(_isDispose) return;
			if(_backTexture)	
			{
				_backTexture.dispose();
				_backTexture = null;
			}
			if(_myBackTexture)
			{
				_myBackTexture.dispose();
				_myBackTexture = null;
			}
			if(_iconTexture)	
			{
				_iconTexture.dispose();
				_iconTexture = null;
			} 
			_nowBtmdStr = "";
			_data = null;
			_isDispose = true;
			if(_iconImage)	
			{
				_iconImage.texture.dispose();
				_iconImage.dispose();
				_iconImage = null;
			}
			if(_flagTexture)
			{
				_flagTexture.dispose();
				_flagTexture = null
			}
			if(_flagIcon)
			{
				_flagIcon.texture.dispose();
				_flagIcon.dispose();
				_flagIcon = null;
			}
			super.dispose();
			this.dispatchEvent(new Event("ClearComponent"));
		}
		

		/** 获取物品icon位图 **/
		public function get iconImage():Image  {  return _iconImage;  }
		public function get iconTexture():Texture { return _iconTexture; }

		public function get flagTexture():Texture
		{
			if(_flagTexture == null)
				_flagTexture = HAssetsManager.getInstance().getMyTexture("itemIconSoruce","Icon_Up")
			return _flagTexture;
		}

		public function set flagTexture(value:Texture):void
		{
			_flagTexture = value;
		}
		/**
		 * 设置鼠标效果 
		 * @param value
		 * 
		 */
		public function set flagIconTexture(value:Texture):void
		{
			if(value == null || !_data)
			{
				if(_flagIcon)
					_flagIcon.visible = false;
			}	else {
	 			if(_flagIcon == null)
				{
					_flagIcon = new Image(value);
					_flagIcon.touchable = false;
					this.addChild(_flagIcon);
					_flagIcon.x = (this.myWidth - value.width >> 1) + reviseX;
					_flagIcon.y = (this.myHeight - value.height >> 1) + reviseY;
				}	else if(_flagIcon.texture != value){
					_flagIcon.texture = value;
					_flagIcon.readjustSize();
					_flagIcon.x = (this.myWidth - value.width >> 1) + reviseX;
					_flagIcon.y = (this.myHeight - value.height >> 1) + reviseY;
				}
				if(!_flagIcon.visible)
					_flagIcon.visible = true;
			}
		}

		public function get backTexture():Texture
		{
			return _backTexture;
		}

		public function set backTexture(value:Texture):void
		{
			_backTexture = value;
		}

		public function get myBackTexture():Texture
		{
			return _myBackTexture;
		}
		/**
		 * 自定义背景
		 * @param backBtmd	: 背景图
		 */		
		public function set myBackTexture(value:Texture):void
		{
			_myBackTexture = value;
		}
		
		/**
		 * 设置失效状态
		 * @param value
		 */
		public function set isDisabled(value:Boolean):void
		{
			_isDisabled = value;
			if(_isDisabled)
			{
				if(!this.filter)
				{
					this.filter = Tool.getGrayColorMatrixFilter();
				}
			}
			else
			{
				if(this.filter)
				{
					this.filter.dispose();
					this.filter = null;
				}
			}
		}
		public function get isDisabled():Boolean  {  return _isDisabled;  }
		private var _isDisabled:Boolean = false;

		public function drawSectorByGraphics(graphics:Graphics, bitmapdata:BitmapData = null, mx:Number = 200, my:Number = 200, r:Number = 100, angle:Number = 27,color:Number = 0x332527
											 ,alp:Number = .7, startFrom:Number = 270, lineSize:int = 1, lineColor:uint = 0xffD0EDFF, lineAlpha:Number = 1, isClear:Boolean = true):void 
		{
			if(isClear) graphics.clear();
			if(angle == 0) return;
			graphics.beginFill(color, alp);
			graphics.lineStyle(lineSize,lineColor, lineAlpha);
			graphics.moveTo(mx, my);
			angle = (Math.abs(angle)>360) ? 360 : angle;
			
			var n:Number = Math.ceil(Math.abs(angle)/30);
			var angleA:Number = angle/n;
			angleA = angleA*Math.PI/180;
			startFrom = startFrom*Math.PI/180;
			var tx:Number = mx+r*Math.cos(startFrom);
			var ty:Number = my+r*Math.sin(startFrom)
			graphics.lineTo(tx, ty);
			
			var angleMid:Number;
			var bx:Number;
			var by:Number;
			var cx:Number;
			var cy:Number;
			for (var i:int = 0; i < n; i++) 
			{
				if(isReverse)
					startFrom += angleA;
				else
					startFrom -= angleA;
				angleMid = startFrom-angleA/2;
				bx = mx+r/Math.cos(angleA/2)*Math.cos(angleMid);
				by = my+r/Math.cos(angleA/2)*Math.sin(angleMid);
				cx = mx+r*Math.cos(startFrom);
				cy = my+r*Math.sin(startFrom);
				graphics.curveTo(bx,by,cx,cy);
			}
			if (angle != 360)
				graphics.lineTo(mx, my);
			graphics.endFill();
		}
		public function drawReacLineByGraphics( graphics:Graphics, bitmapdata:BitmapData = null, width:Number = 100, height:Number = 100
												, alpha:Number = 1, lineSize:int = 1, lineColor:uint = 0x0, actionX:Number = 0, actionY:Number = 0, isClear:Boolean = true):void
		{
			if(isClear) graphics.clear();
			graphics.lineStyle(lineSize, lineColor, alpha);
			graphics.moveTo(actionX, actionY);
			graphics.lineTo((actionX+width), actionY);
			graphics.lineTo((actionX+width), (actionY+height));
			graphics.lineTo(actionX, (actionY+height));
			graphics.lineTo(actionX, actionY);
			graphics.endFill();
		}

	}
}