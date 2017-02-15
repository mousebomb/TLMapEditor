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
	
	import HLib.Event.ModuleEvent;
	import HLib.Event.ModuleEventDispatcher;
	import HLib.Pools.ResPool;
	import HLib.Tool.Tool;
	
	import Modules.Common.ComEventKey;
	import Modules.MainFace.MainInterfaceManage;
	
	import away3DExtend.MeshExtend;
	
	import away3d.arcane;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;
	import away3d.tools.utils.TextureUtils;

	import starling.events.Event;

	use namespace arcane;
	public class NameTextField3D extends MeshExtend
	{
		private static const GEO_1024:PlaneGeometry = new PlaneGeometry(1024, 32);
		private static const GEO_512:PlaneGeometry = new PlaneGeometry(512, 32);
		private static const GEO_256:PlaneGeometry = new PlaneGeometry(256, 32);
		private static const GEO_128:PlaneGeometry = new PlaneGeometry(128, 32);
		private static const GEO_64:PlaneGeometry = new PlaneGeometry(64, 32);
		private static const GEO_32:PlaneGeometry = new PlaneGeometry(32, 32);
		
		public var myWidth:Number;				//文本实际宽度
		public var myHeight:Number;			//文本实际高度
		
		private var _textField:HTextField2D;
		private var _text:String = "";
		private var _textureMaterial:TextureMaterial;	//贴图
		private var _texture:BitmapTexture;
		
		
		public function NameTextField3D()  
		{ 
			_texture = new BitmapTexture(ResPool.inst.getBlendBitmapData(1, 1), false);
			_textureMaterial = new TextureMaterial(_texture, true, false, false);
			_textureMaterial.alphaBlending = true;
			
			super(GEO_128, _textureMaterial); 
			
			_textField = new HTextField2D();
			Tool.setDisplayGlowFilter(_textField);
		}
		
		public function init():void
		{
			if(MainInterfaceManage.getInstance().fontName == null)
			{
				ModuleEventDispatcher.getInstance().addEventListener(ComEventKey.MAI_LOAD_COMPLETE, onMaiLoadComplete);
			}
		}
		
		private function refreshTexture(bmd:BitmapData):void
		{
			var tBmd:BitmapData = _texture.bitmapData;
			ResPool.inst.recycleBlendBitmapData(tBmd);
			
			_texture.bitmapData = bmd;
		}
		
		
		/** 当字体加载完时执行刷新 **/
		private function onMaiLoadComplete(e:starling.events.Event):void
		{
			ModuleEventDispatcher.getInstance().removeEventListener(ComEventKey.MAI_LOAD_COMPLETE, onMaiLoadComplete);
			
			updateTxt();
		}
		
		/**
		 * 7位颜色+2位字体大小+内容
		 * #f9f9f916这里要显示的内容 
		 * @param value
		 */		
		public function set label(value:String):void  
		{
			if (_textField.label != value)
			{
				_textField.label = value;  
				drawTextField();
			}
		}
		
		public function get label():String 
		{ 
			return _textField.label;
		}
		
		private var _color:uint = 0;
		/** 字体颜色 **/
		public function set color(value:uint):void 
		{ 
			_color = _textField.color = value;
		}
		public function get color():uint
		{
			return _color;
		}
		
		public function setTxtAndColor(txt:String, color:uint):void
		{
			if (_text != txt || _color != color)
			{
				_text = txt;
				_textField.color = _color = color;
				
				updateTxt();
			}
		}
		
		private function updateTxt():void
		{
			_textField.text = _text;
			
			drawTextField();
		}
		
		/** 字体大小 **/
		public function set size(value:int):void  
		{
			_textField.size = value;  
		}

		private var _algin:String = "left";
		/** 文本对齐样式 **/
		public function set algin(value:String):void
		{  
			_algin = value; 
		}
		public function get algin():String 
		{ 
			return _algin; 
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
			
			var tmpw:uint = TextureUtils.getBestPowerOf2(myWidth);
			var tmph:uint = 32;//TextureUtils.getBestPowerOf2(myHeight);
			var drawBmd:BitmapData;
			drawBmd = ResPool.inst.getBlendBitmapData(tmpw, tmph);
			drawBmd.fillRect(drawBmd.rect, 0);
			var matrix:Matrix = new Matrix();
			switch(_algin)
			{
				case "left":
					matrix.translate(0, (tmph - myHeight) / 2);
					break;
				case "center":
					matrix.translate((tmpw - myWidth) / 2, (tmph - myHeight) / 2);
					break;
				case "right":
					matrix.translate(drawBmd.width - _textField.width, (tmph - myHeight) / 2);
					break;
			}
			drawBmd.draw(_textField, matrix);
			refreshTexture(drawBmd);
			
			switch(tmpw)
			{
				case 1024:
				{
					geometry = GEO_1024;
					break;
				}
					
				case 512:
				{
					geometry = GEO_512;
					break;
				}
					
				case 256:
				{
					geometry = GEO_256;
					break;
				}
					
				case 128:
				{
					geometry = GEO_128;
					break;
				}
					
				case 64:
				{
					geometry = GEO_64;
					break;
				}
					
				default:
				{
					geometry = GEO_32;
					break;
				}
			}
		}
		
		public function get bmdSize():Number
		{
			return Math.max(myWidth, myHeight);
		}
		
		public function get alpha():Number
		{
			return _textureMaterial.alpha;
		}
		public function set alpha(val:Number):void
		{
			_textureMaterial.alpha = val;
		}
		
		/** 清理HTextField3D对象 **/
		public function clearHTF3D():void
		{
			ModuleEventDispatcher.getInstance().removeEventListener(ComEventKey.MAI_LOAD_COMPLETE, onMaiLoadComplete);			
			
			this.identity();
			
			_text = "";
			_color = -1;
			
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
			_textureMaterial.dispose();
			
			ResPool.inst.recycleBlendBitmapData(_texture.bitmapData);
			
			ModuleEventDispatcher.getInstance().removeEventListener(ComEventKey.MAI_LOAD_COMPLETE, onMaiLoadComplete);			
			_textField = null;
			
			_texture.dispose();
			
			super.dispose();
		}
	}
}