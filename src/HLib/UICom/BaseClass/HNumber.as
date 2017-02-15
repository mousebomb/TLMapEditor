package HLib.UICom.BaseClass
{
	/**
	 * 数字组合(中文字只能从0~99)
	 * @author 李舒浩
	 * 
	 * 中文字用法:
	 * 		var num:HNumber = new HNumber();
	 * 		num.setNumArr(Vector.<BitmapData>([零~十的bitmapdata]))
	 *		num.isChinese = true;
	 *		num.num = 0;
	 *		this.addChild(num);
	 * 
	 * @see Modules.Mount.ViewControls.MountControlVC
	 */	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import HLib.Event.Dispatcher_F;
	import HLib.Tool.Tg;
	import HLib.Tool.Tool;
	
	import Modules.Common.ComEventKey;
	import Modules.DataSources.ChatDataSource;
	
	import starling.core.Starling;
	import starling.textures.Texture;
	
	public class HNumber extends HSprite
	{
		public var type:int = 0;				//类型(0:横排 1:竖排)
		public var isChinese:Boolean = false;	//是否为中文
		public var isDispost:Boolean = true;	//clear时时候dispost掉位图
		
		private var texture:Texture;			//显示贴图材质
		private var _num:uint;					//当前数字
		private var _numVec:Vector.<BitmapData>;
		private var _drawBitmapdata:BitmapData;
		
		public function HNumber()  {  super();  }
		/**
		 * 数字数组
		 * @param numVec	: BitmapData数组, 排列规则 数字:0~9, 中文: 零~十
		 */		
		public function setNumArr(numVec:Vector.<BitmapData>):void
		{
			_numVec = numVec;
		}
		
		/**数据找回时刷新*/
		private function onRestore(event:flash.events.Event):void
		{
			Dispatcher_F.getInstance().removeEventListener(ComEventKey.CONTEXT_CREATED, onRestore);  
			num = _num
		}
		/**
		 * 设置显示number 
		 * @param value	: 显示number
		 */		
		public function set num(value:uint):void
		{
			_num = value;
			if(ChatDataSource.getMyInstance().isDisposed || Starling.context.driverInfo == "Disposed") 
			{ 
				Dispatcher_F.getInstance().addEventListener(ComEventKey.CONTEXT_CREATED, onRestore);  
				return; 
			}
			var numStr:String;
			if(isChinese)
			{
				if(_num >= 100)
					numStr = String(_num);
				else if(_num < 10)//0~9
					numStr = String(_num);
				else if(_num == 10)		numStr = Tg.T("十");
				else if(_num > 10 && _num < 20)		//11~19
					numStr = Tg.T("十") + Tool.changeNumber(_num%10);
				else if(_num%10==0)		// 20, 30, 40...
					numStr = String(_num).replace(/0/, Tg.T("十"));
				else					//21~29,31~39...
				{
					var t:int = int(_num/10);	//十位
					var o:int = _num%10;		//个位
					numStr = Tool.changeNumber(t) + Tg.T("十") + Tool.changeNumber(o);
				}
			}
			else
				numStr = String(_num);
			
			//解析传入的数字
			var arr:Array = numStr.split("");
			var btmdVec:Vector.<BitmapData> = new Vector.<BitmapData>();
			var len:int = arr.length;
			var index:int = -1;
			for(var i:int = 0; i < len; i++)
			{
				index = getIndex(arr[i]);
				btmdVec.push( _numVec[ index ] );
			}
			if(_drawBitmapdata) _drawBitmapdata.dispose();
			_drawBitmapdata = groupBitmap(btmdVec);
			
			if(texture)
				texture.dispose();
			texture = Texture.fromBitmapData(_drawBitmapdata, false);
			//texture.root.onRestore = texture_onRestore;			
			this.myDrawByTexture(texture);
			
			arr.length = 0;
			arr = null;
			btmdVec.length = 0;
			btmdVec = null;
			
			this.myWidth = _drawBitmapdata.width;
			this.myHeight = _drawBitmapdata.height;
		}
		private function texture_onRestore():void
		{
			if(_drawBitmapdata)
				this.myImage.texture.root.uploadBitmapData(_drawBitmapdata)
		}
		public function get num():uint  {  return _num;  }
		/**
		 * 根据字符获得index索引
		 * @param value
		 * @return 
		 */		
		private function getIndex(value:String):int
		{
			var index:int = 0;
			switch(value)
			{
				case "0":
				case "1":
				case "2":
				case "3":
				case "4":
				case "5":
				case "6":
				case "7":
				case "8":
				case "9":
					index = int(value);
					break;
				case Tg.T("零"):
					index = 0;
					break;
				case Tg.T("一"):
					index = 1;
					break;
				case Tg.T("二"):
					index = 2;
					break;
				case Tg.T("三"):
					index = 3;
					break;
				case Tg.T("四"):
					index = 4;
					break;
				case Tg.T("五"):
					index = 5;
					break;
				case Tg.T("六"):
					index = 6;
					break;
				case Tg.T("七"):
					index = 7;
					break;
				case Tg.T("八"):
					index = 8;
					break;
				case Tg.T("九"):
					index = 9;
					break;
				case Tg.T("十"):
					index = 10;
					break;
			}
			return index;
		}
		
		/**
		 * 组合位图
		 * @param bitmapDataArr	: 需要组合的bitmapdata数组(组合顺序由左到右,数组须自行排序)
		 */		
		private function groupBitmap(btmdVec:Vector.<BitmapData>):BitmapData
		{
			//获取组合位图的宽高值
			var w:Number = (type == 0 ? 0 : btmdVec[0].width);
			var h:Number = (type == 0 ? btmdVec[0].height : 0);
			for each(var btmd:BitmapData in btmdVec)
			{
				//判断横列类型
				if(type == 0)
				{
					w += btmd.width;
					if(h < btmd.height) h = btmd.height;
				}
				else
				{
					h += btmd.height;
					if(w < btmd.width) w = btmd.width;
				}
			}
			//拼装位图
			var bitmapdata:BitmapData = new BitmapData(w, h, true, 0);
			var nowX:Number = (type == 0 ? 0 : ((w - btmdVec[0].width)/2));		//当前移动指标X位置
			var nowY:Number = (type == 0 ? ((h - btmdVec[0].height)/2) : 0);		//当前移动指标Y位置
			var rectangle:Rectangle;	//绘制的矩形
			var len:int = btmdVec.length;
			for(var i:int = 0; i < len; i++)
			{
				rectangle = new Rectangle(0, 0, btmdVec[i].width, btmdVec[i].height);
				bitmapdata.copyPixels(btmdVec[i], rectangle, new Point(nowX, nowY));//(h - rectangle.height)/2));
				if(type == 0)
				{
					nowX += rectangle.width;
					nowY = (h - rectangle.height)/2;
				}
				else
				{
					nowX = (w - rectangle.width)/2;
					nowY += rectangle.height;
				}
			}
			return bitmapdata;
		}
		
		/** 释放内存清除 **/
		override public function dispose():void
		{
			super.dispose();
			if(_drawBitmapdata)
				_drawBitmapdata.dispose();
			_drawBitmapdata = null;
			
			if(texture) texture.dispose();
			if(!_numVec) return;
			if(isDispost)
			{
				var len:int = _numVec.length;
				for(var i:int = 0; i < len; i++)
				{
					_numVec[i].dispose();
				}
			}
			_numVec.length = 0;
			_numVec = null;
		}
	}
}