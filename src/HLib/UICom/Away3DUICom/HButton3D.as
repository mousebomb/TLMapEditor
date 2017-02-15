package HLib.UICom.Away3DUICom
{
	/**
	 * 3D按钮类
	 * @author 李舒浩
	 */	
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import HLib.UICom.BaseClass.HTextField3D;
	import HLib.WizardBase.HObject3DPool;
	
	import away3DExtend.MeshExtend;
	
	import away3d.events.MouseEvent3D;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;
	
	public class HButton3D extends MeshExtend
	{
		public var myWidth:Number;
		public var myHeight:Number;
		//绘制按钮颜色值
		public var upColor:uint = 0xB47015;
		public var overColor:uint = 0xDBAC6D;
		public var downColor:uint = 0xA45D0E;
		public var disabledColor:uint = 0x8E908F;
		public var selectedColor:uint = 0xCB8F42;
		
		private var _isInit:Boolean = false;
		
		//鼠标移动样式文本显示颜色
		public var upTextColor:uint = 0xD8D288;
		public var overTextColor:uint = 0xD8D288;
		public var downTextColor:uint = 0xD8D288;
		public var disabledTextColor:uint = 0xD8D288;
		public var selecteTextColor:uint = 0xD8D288;
		public var isOpenTextColor:Boolean = false;	//是否开启鼠标移入按钮时文本变色功能
		public var isTextBold:Boolean = true;			//按钮内容文本是否加粗
		public var isDispose:Boolean = true;			//是否删除鼠标时调用dispose方法清除bitmapdata(一般用于外部自定义按钮皮肤后释放用)
		
		private var _textureMaterial:TextureMaterial;	//贴图
		private var _upTexture:BitmapTexture;			//按钮样式bitmapdata
		private var _overTexture:BitmapTexture;
		private var _downTexture:BitmapTexture;
		private var _disabledTexture:BitmapTexture;
		private var _selectedTexture:BitmapTexture;
		
		private var _isSelected:Boolean = false;	//当前是否选中状态
		private var _isDisabled:Boolean = false;	//是否失效状态
		
		private var _label:String = "";			//按钮文字
		private var _labelText:HTextField3D;		//文本内容
		private var _algin:String = "center";		//对齐方式
		
		public function HButton3D()  {  super(new PlaneGeometry(), null);  }
		/**
		 * 初始化
		 * @param $text			: 按钮文字
		 * @param $myWidth		: 按钮实际宽度(根据此宽度移动UV)
		 * @param $myHeight		: 按钮实际高度(根据此高度移动UV)
		 * @param $algin		: 文本对齐方式
		 */		
		public function init($text:String = "", $myWidth:int = 60, $myHeight:int = 26, $algin:String = "center"):void
		{
			if(_isInit) return;
			_algin = $algin;
			//设置按钮大小
			PlaneGeometry(this.geometry).width = myWidth = $myWidth;
			PlaneGeometry(this.geometry).height = myHeight = $myHeight;
			//判断是否有皮肤
			if(!_upTexture)
			{
				setSkin(
					 new BitmapData(1, 1, false, upColor)
					,new BitmapData(1, 1, false, overColor)
					,new BitmapData(1, 1, false, downColor)
					,new BitmapData(1, 1, false, disabledColor)
					,new BitmapData(1, 1, false, selectedColor)
				);
			}
			//设置UV点
			var u:Number = $myWidth/_upTexture.bitmapData.width;
			var v:Number = $myHeight/_upTexture.bitmapData.height;
			this.geometry.subGeometries[0].scaleUV(u, v);
			//文字
			_labelText = HObject3DPool.getInstance().getHTextField3D();
			_labelText.init(1);
//			Tool.setDisplayGlowFilter(_labelText.textField);
			this.addChild(_labelText);
			_labelText.text = $text;
			_labelText.mouseEnabled = _labelText.mouseChildren = false;
			//初始化默认为up
			_textureMaterial ||= new TextureMaterial(_upTexture);
			_textureMaterial.alphaBlending = true;
			_textureMaterial.mipmap = false;
			this.material = _textureMaterial;
			
			this.mouseEnabled = true;
			this.addEventListener(MouseEvent3D.MOUSE_OVER, onMouseEvent);
			this.addEventListener(MouseEvent3D.MOUSE_OUT, onMouseEvent);
			this.addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseEvent);
			this.addEventListener(MouseEvent3D.MOUSE_UP, onMouseEvent);
			
			_isInit = true;
		}
		/**
		 * 默认皮肤
		 * @param type	: 默认类型(0:)
		 */		
		public function setDefaultSkin(type:int = 0):void
		{
			isDispose = false;
			switch(type)
			{
				case 0:
					break;
			}
		}
		/**
		 * 自定义皮肤
		 * @param $upBtmd
		 * @param $overBtmd
		 * @param $downBtmd
		 * @param $disabledBtmd
		 * @param $selectedBtmd
		 */		
		public function setSkin( $upBtmd:BitmapData = null, $overBtmd:BitmapData = null, $downBtmd:BitmapData = null,
								$disabledBtmd:BitmapData = null, $selectedBtmd:BitmapData = null ):void
		{
			if($upBtmd)
			{
				if(!_upTexture)		_upTexture = new BitmapTexture($upBtmd, false);
				else				_upTexture.bitmapData = $upBtmd;
			}
			if($overBtmd)
			{
				if(!_overTexture)		_overTexture = new BitmapTexture($overBtmd, false);
				else					_overTexture.bitmapData = $overBtmd;
			}
			if($downBtmd)
			{
				if(!_downTexture)		_downTexture = new BitmapTexture($downBtmd, false);
				else					_downTexture.bitmapData = $downBtmd;
			}
			if($disabledBtmd)
			{
				if(!_disabledTexture)	_disabledTexture = new BitmapTexture($disabledBtmd, false);
				else					_disabledTexture.bitmapData = $disabledBtmd;
			}
			if($selectedBtmd)
			{
				if(!_selectedTexture)	_selectedTexture = new BitmapTexture($selectedBtmd, false);
				else					_selectedTexture.bitmapData = $selectedBtmd;
			}
		}
		/**
		 * 设置按钮文字 
		 * @param value	: 按钮显示文字样式,颜色格式为HTextField的colorLabel
		 */		
		public function set label(value:String):void
		{
			_label = value;
			_labelText.label = value;
			//设置位置
			algin = algin;
		}
		public function get label():String  {  return _label;  }
		/**
		 * 移除方法
		 */		
		public function disposeHBtn3D():void
		{
			if(_upTexture)
			{
				isDispose ? _upTexture.bitmapData.dispose() : _upTexture.bitmapData = null;
				_upTexture.dispose();
			}
			if(_overTexture)
			{
				isDispose ? _overTexture.bitmapData.dispose() : _overTexture.bitmapData = null;
				_overTexture.dispose();
			}
			if(_downTexture)
			{
				isDispose ? _downTexture.bitmapData.dispose() : _downTexture.bitmapData = null;
				_downTexture.dispose();
			}
			if(_disabledTexture)
			{
				isDispose ? _disabledTexture.bitmapData.dispose() : _disabledTexture.bitmapData = null;
				_disabledTexture.dispose();
			}
			if(_selectedTexture)
			{
				isDispose ? _selectedTexture.bitmapData.dispose() : _selectedTexture.bitmapData = null;
				_selectedTexture.dispose();
			}
			this.geometry.dispose();
			
			_upTexture = null;
			_overTexture = null;
			_downTexture = null;
			_disabledTexture = null;
			_selectedTexture = null;
		}
		/** 按钮点击事件 **/
		private function onMouseEvent(e:MouseEvent3D):void
		{
			if(_isSelected) return;
			if(_isDisabled) return;
			switch(e.type)
			{
				case MouseEvent3D.MOUSE_UP:		
					drawTheButton(_overTexture);	
					if(isOpenTextColor)
					{
						_labelText.color = upTextColor;
						label = label;
					}
					this.dispatchEvent(new Event("Mouse_Up"));
					break;
				case MouseEvent3D.MOUSE_DOWN:		
					drawTheButton(_downTexture);	
					if(isOpenTextColor)
					{
						_labelText.color = downTextColor;
						label = label;
					}
					this.dispatchEvent(new Event("Mouse_Down"));
					break;
				case MouseEvent3D.MOUSE_OVER:		
					drawTheButton(_overTexture);	
					if(isOpenTextColor)
					{
						_labelText.color = overTextColor;
						label = label;
					}
					this.dispatchEvent(new Event("Mouse_Over"));
					break;
				case MouseEvent3D.MOUSE_OUT:		
					drawTheButton(_upTexture);		
					if(isOpenTextColor)
					{
						_labelText.color = upTextColor;
						label = label;
					}
					this.dispatchEvent(new Event("Mouse_Out"));
					break;
			}
		}
		
		/**
		 * 绘制按钮样式
		 * @param texture	: 按钮材质
		 */		
		private function drawTheButton(texture:BitmapTexture):void
		{
			//设置皮肤
			_textureMaterial.texture = texture;
		}

		/**
		 * 文本对齐方式
		 * @param value
		 */
		public function set algin(value:String):void
		{
			_algin = value;
			//对齐位置
			switch(_algin)
			{
				case "left":		//左对齐
					_labelText.x = (_labelText.width >> 1);
					break;
				case "center":		//居中对齐
					_labelText.x = _labelText.completionWidthNum >> 1;
					break;
				case "right":		//右对齐
//					_labelText.x = (this.myWidth>>1) - (_labelText.width >> 1) - _labelText.completionWidthNum;
//					_labelText.x = completionXY(_labelText.x);
					break;
			}
			_labelText.y = _labelText.completionHeightNum>>1;
		}
		public function get algin():String  {  return _algin;  }
	}
}