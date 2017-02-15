package tl.mapeditor.ui3d
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

	import away3DExtend.MeshExtend;

	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;

	import com.greensock.TweenMax;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	import tl.IResources.IResourcePool;
	import tl.mapeditor.ResourcePool;
	import tl.mapeditor.ui.common.MyTextField;
	import tl.utils.Tool;

	public class HTextField3D extends MeshExtend
	{
		public var completionWidthNum:int;		//补全位图的宽度
		public var completionHeightNum:int;	//补全位图的高度
		public var myWidth:Number;				//文本实际宽度
		public var myHeight:Number;			//文本实际高度
		
		private var _self:HTextField3D;
		
		private var _textDic:Dictionary;
		private var _drawBitmapdata:BitmapData;
		private var _textField:MyTextField;
		
		private var _text:String;
		private var _textureMaterial:TextureMaterial;	//贴图
		private var _texture:BitmapTexture;
		
		private var _type:int = 0;	//文本类型 0:使用图片 1:使用文字
		
		public function HTextField3D()  { super(new PlaneGeometry()); _self = this;}//super(null, 1, 1); _self = this; }
		/**
		 * 初始化
		 * @param type	: 0:位图 1:文本
		 */		
		public function init(type:int = 0):void
		{
			_type = type;
			if(type == 1)
				_textField = new MyTextField();
			
			_texture = new BitmapTexture(new BitmapData(2, 2, false, 0));
			_textureMaterial = new TextureMaterial(_texture);
//			_textureMaterial.mipmap = false;
			_textureMaterial.alphaBlending = true;
			this.material = _textureMaterial;
		}
		
		/**
		 * 自定义添加皮肤
		 * @param obj	: 皮肤obj{key:value(bitmapdata), key:value}
		 */		
		public function setSkin(obj:Object):void
		{
			_textDic ||= new Dictionary();
			for(var key:String in obj)
			{
				_textDic[key] = obj.key;
			}
		}
		/**
		 * 设置默认皮肤
		 * @param type	: 类型(0:绿色 1:红色)
		 */		
		public function setDefaultSkin(type:int = 0):void
		{
			_textDic ||= new Dictionary();
			//获取位图
			var str:String;
			var symbol:String;
			var symbolStr:String;
			switch(type)
			{
				case 0:	//绿色
					str = "MainUI_NumB_";
					symbol = "+";
					symbolStr = "MainUI_NumB_Add";
					break;
				case 1:	//红色
					str = "MainUI_NumA_";
					symbol = "-";
					symbolStr = "MainUI_NumA_deduct";
					break;
			}
			//添加符号资源
			var bitmapdata:BitmapData = IResourcePool.getInstance().getResource(symbolStr);
			if(!bitmapdata)
			{
				bitmapdata = ResourcePool.getInstance().getBtmdBySwf("MainUI", symbolStr);
				IResourcePool.getInstance().addResource(symbolStr, bitmapdata);
			}
			_textDic[symbol] = bitmapdata;
			//循环获取资源
			for(var i:int = 0; i < 10; i++)
			{
				bitmapdata = IResourcePool.getInstance().getResource(str + i);
				if(!bitmapdata)
				{
					bitmapdata = ResourcePool.getInstance().getBtmdBySwf("MainUI", str + i);
					IResourcePool.getInstance().addResource(str + i, bitmapdata);
				}
				_textDic[String(i)] = bitmapdata;
			}
		}
		
		/**
		 * 文字显示
		 * @param value	: 内容(如果是加血,则传入字符串("+123456789"),减血("-123456789"))
		 */
		public function set text(value:String):void
		{
			_text = value;
			//判断处理类型
			if(_type == 0) drawBtmd();
			else
			{
				if(!_textField)
					_textField = new MyTextField();
				_textField.text = _text;
				drawTextField()
			}
		}
		public function get text():String  {  return _text;  }
		
		/**
		 * 7位颜色+2位字体大小+内容
		 * #f9f9f916这里要显示的内容 
		 * @param value
		 */		
		public function set label(value:String):void  
		{
			_type = 1;
			_textField ||= new MyTextField();
			_textField.label = value;  
			drawTextField();
		}
		public function get label():String { return _textField.label; }
		/** 文本对齐样式 **/
		public function set algin(value:String):void  {  _textField.algin = value;  }
		/** 文本字体样式(默认为统一字体,只有特殊需要设置的字体才使用设置) **/
		public function set font(value:String):void  {  _textField.font = value;  }
		/** 字体大小 **/
		public function set size(value:int):void  {  _textField.size = value;  }
		/** 字体颜色 **/
		public function set color(value:uint):void  {  _textField.color = value;  }
		/** 是否加粗 **/
		public function set bold(value:Boolean):void  {  _textField.bold = value;  }
		/** 文本间距 **/
		public function set leading(value:int):void  {  _textField.leading = value;  }
		/** 位图保存字典,一般用于自定义了位图后,获取字典dispose()用 **/
		public function get textDic():Dictionary  {  return _textDic;  }
		/** 2D文本,用于给文本设置描边等 **/
		public function get textField():MyTextField  {  return _textField;  }
		/** 释放资源 **/
		override public function disposeWithChildren():void
		{
			_textureMaterial.alphaBlending = false;
			
			for(var key:String in _textDic)
				delete this._textDic[key];  
			
			if(_drawBitmapdata)		_drawBitmapdata.dispose();
			if(_textureMaterial)	_textureMaterial.dispose();
			if(_texture)			_texture.dispose();
			
			this.geometry.dispose();
			super.disposeWithChildren();
			
			_textField = null;
			_textDic = null;
			_drawBitmapdata = null;
			_textureMaterial = null;
			_texture = null;
			_self = null;
		}
		/**
		 * 抛物线效果
		 * @param direction		: 抛物线方向
		 * @param widthNum		: 每帧移动的方向距离
		 * @param heightNum		: 抛物线的总高度
		 */		
		public function parabolic(direction:int, widthNum:uint, heightNum:uint):void
		{
			var tweenMax:TweenMax = TweenMax.to(_self, 1, {
				bezierThrough:[
					{
						x:_self.x + direction * 50
						,y:_self.y + 50
					}
					,{
						x:_self.x + (direction * 100)
						,y:_self.y - 100
					}
				]
				,onComplete:function():void
				{
					tweenMax.kill();
					_self.visible = false;
					_self.disposeWithChildren();
				}
			});
		}
		
		/** 绘制图片 **/
		private function drawBtmd():void
		{
			if(_drawBitmapdata) _drawBitmapdata.dispose();
			var arr:Array = _text.split("");
			var len:int = arr.length;
			var vec:Vector.<BitmapData> = new Vector.<BitmapData>(len, true);
			for(var i:int = 0; i < len; i++)
			{
				vec[i] = _textDic[arr[i]];
			}
			_drawBitmapdata = groupBitmap(vec);
			_texture.bitmapData = _drawBitmapdata;
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
		private function drawTextField():void
		{
			_textField.width = _textField.textWidth+4;
			_textField.height = _textField.textHeight+4;
			//获得一个最接近的二次幂矩形
			var rect:Rectangle = Tool.getPowerOf2Rect(_textField.width, _textField.height);
			//计算补全的大小
			myWidth = _textField.width;
			myHeight = _textField.height;
			completionWidthNum = rect.width - _textField.width;
			completionHeightNum = rect.height - _textField.height;
			
			if(_drawBitmapdata) _drawBitmapdata.dispose();
			_drawBitmapdata = new BitmapData(rect.width, rect.height, true, 0);
			_drawBitmapdata.lock();
			_drawBitmapdata.draw(_textField);
			_drawBitmapdata.unlock();
			_texture.bitmapData = _drawBitmapdata;
			PlaneGeometry(this.geometry).width = _drawBitmapdata.width;
			PlaneGeometry(this.geometry).height = _drawBitmapdata.height;
			
			rect = null;
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
					h = btmd.height;
			}
			//获得一个最接近的二次幂矩形
			var rect:Rectangle = Tool.getPowerOf2Rect(w, h);
			//计算补全的大小
			myWidth = w;
			myHeight = h;
			completionWidthNum = rect.width - w;
			completionHeightNum = rect.height - h;
			//拼装位图
			var bitmapdata:BitmapData = new BitmapData(rect.width, rect.height, true, 0);
			var nowX:Number = 0;		//当前移动指标位置
			var rectangle:Rectangle;	//绘制的矩形
			var len:int = bitmapDataArr.length;
			for(var i:int = 0; i < len; i++)
			{
				rectangle = new Rectangle(0, 0, bitmapDataArr[i].width, bitmapDataArr[i].height);
				bitmapdata.copyPixels(bitmapDataArr[i], rectangle, new Point(nowX, (h - rectangle.height)/2));
				nowX += rectangle.width;
			}
			return bitmapdata;
		}
		
		override public function set x(val:Number):void
		{
			super.x = (val%2==0 ? val : val+1);
		}
		
		override public function set y(val:Number):void
		{
			super.y = (val%2==0 ? val : val+1);
		}
		
	}
}


