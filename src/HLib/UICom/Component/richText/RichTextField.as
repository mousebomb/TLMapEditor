package HLib.UICom.Component.richText
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	
	import HLib.Event.Dispatcher_F;
	import HLib.Tool.HObjectPool;
	import HLib.Tool.Tool;
	import HLib.UICom.Component.HItemText;
	import HLib.UICom.Component.richText.plugins.ShortcutPlugin;
	
	import Modules.Common.ComEventKey;
	import Modules.Common.HAssetsManager;
	import Modules.DataSources.ChatDataSource;
	import Modules.HpopMenu.HpopMenuVo;
	import Modules.Map.HMapSources;
	import Modules.view.task.HTaskLinkText;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * <p>RichTextField是一个基于TextField的图文混编的组件。</p>
	 * <p>RichTextField有如下特性：
	 * <br><ul>
	 * <li>在文本末尾追加文本和显示元素。</li>
	 * <li>在文本任何位置替换(删除)文本和显示元素。</li>
	 * <li>支持HTML文本和显示元素的混排。</li>
	 * <li>可动态设置RichTextField的尺寸大小。</li>
	 * <li>可导入和导出XML格式的文本框内容。</li>
	 * </ul></p>
	 * @example 下面的例子演示了RichTextField基本使用方法：
	 * <listing>
	 var rtf:RichTextField = new RichTextField();			
	 rtf.x = 10;
	 rtf.y = 10;
	 addChild(rtf);
	 //设置rtf的尺寸大小
	 rtf.setSize(500, 400);
	 //设置rtf的类型
	 rtf.type = RichTextField.INPUT;
	 //设置rtf的默认文本格式
	 rtf.defaultTextFormat = new TextFormat("Arial", 12, 0x000000);
	 
	 //追加文本和显示元素到rtf中
	 rtf.append("Hello, World!", [ { index:5, src:SpriteClassA }, { index:13, src:SpriteClassB } ]);
	 //替换指定位置的内容为新的文本和显示元素
	 rtf.replace(8, 13, "世界", [ { src:SpriteClassC } ]);</listing>
	 * @example 下面是一个RichTextField的内容的XML例子，你可以使用importXML()来导入具有这样格式的XML内容，或用exportXML()导出这样的XML内容方便保存和传输：
	 * <listing>
	 &lt;rtf&gt;
	 &lt;text&gt;Hello, World!&lt;/text&gt;
	 &lt;sprites&gt;
	 &lt;sprite src="SpriteClassA" index="5"/&gt;
	 &lt;sprite src="SpriteClassB" index="13"/&gt;
	 &lt;/sprites&gt;
	 &lt;/rtf&gt;</listing>
	 */
	public class RichTextField extends Sprite
	{
		public static const ELEM_CLICKED_EVENT:String = "elem clicked event";
		private var _width:Number;
		private var _height:Number;
		private var _TextRenderer:TextRenderer;		
		private var _spriteRenderer:SpriteRenderer;	
		private var _formatCalculator:TextField;
		private var _plugins:Array;
		
		private var _placeholder:String;
		private var _placeholderColor:uint;
		private var _placeholderMarginH:int;	
		private var _placeholderMarginV:int;
		
		/**
		 * 一个布尔值，指示文本字段是否以HTML形式插入文本。
		 * @default false
		 */
		public var html:Boolean;
		/**
		 * 指示文本字段的显示元素的行高（最大高度）。
		 * @default 0
		 */
		public var lineHeight:int;
		/**
		 * 一个布尔值，指示当追加内容到RichTextField后是否自动滚动到最底部。
		 * @default true
		 */
		public var autoScroll:Boolean;		
		/**
		 * 用于指定动态类型的RichTextField。
		 */
		public static const DYNAMIC:String = "dynamic";
		/**
		 * 用于指定输入类型的RichTextField。
		 */
		public static const INPUT:String = "input";		
		/**
		 * RichTextField的版本号。
		 */
		public static const version:String = "2.0.2";
		
		private var _textImage:Image;			//文本图片
		private var _isOutput:Boolean;
		public var dataXMl:XML;				//当前显示的文本源
		/**
		 * 构造函数。
		 */
		public function RichTextField()
		{
			this.isNotDispatch = true;
			_TextRenderer = new TextRenderer();
			_spriteRenderer = new SpriteRenderer(this);
			addChild(_spriteRenderer.container);
			
			setSize(100, 100);
			type = DYNAMIC;
			lineHeight = 0;
			html = false;
			autoScroll = false;
			
			_placeholder = String.fromCharCode(12288);
			_placeholderColor = 0x000000;
			_placeholderMarginH = 1;
			_placeholderMarginV = 1;
			
			_formatCalculator = new TextField();			
			_formatCalculator.text = _placeholder;
			
			_TextRenderer.restrict = "^" + _placeholder;
		}
		
		/**
		 * 追加newText参数指定的文本和newSprites参数指定的显示元素到文本字段的末尾。
		 * @param	newText 要追加的新文本。
		 * @param	newSprites 要追加的显示元素数组，每个元素包含src和index两个属性，如：{src:sprite, index:1}。
		 * @param	autoWordWrap 指示是否自动换行。
		 * @param	format 应用于追加的新文本的格式。
		 */
		public function append(newText:String, newSprites:Array = null, autoWordWrap:Boolean = false, format:TextFormat = null):void
		{			
			//append text
			var scrollV:int = _TextRenderer.scrollV;
			var oldLength:int = _TextRenderer.length;
			var textLength:int = 0;
			
			if (!newText) newText = "";
			if (newText || autoWordWrap)
			{
				if(newText) newText = newText.split("\r").join("\n");
				//plus a newline(\n) only if append as normal text 
				if (autoWordWrap && !html) newText += "\n";
				_TextRenderer.recoverDefaultFormat();
				if (html)
				{
					//make sure the new text have the default text format
					_TextRenderer.htmlText += "<p>" + newText + "</p>";	
				}else
				{
					_TextRenderer.appendText(newText);
					if (format == null) format = _TextRenderer.defaultTextFormat;
					_TextRenderer.setTextFormat(format, oldLength, _TextRenderer.length);
				}
				//record text length added
				if (html || (autoWordWrap && !html)) textLength = _TextRenderer.length - oldLength - 1;
				else textLength = _TextRenderer.length - oldLength;
			}			
			
			//append sprites
			var newline:Boolean = html && (oldLength != 0);
			insertSprites(newSprites, oldLength, oldLength + textLength, newline);
			
			//auto scroll			
			if (autoScroll && _TextRenderer.scrollV != _TextRenderer.maxScrollV) 
			{
				_TextRenderer.scrollV = _TextRenderer.maxScrollV;
			}else if(!autoScroll && _TextRenderer.scrollV != scrollV)
			{
				_TextRenderer.scrollV = scrollV;
			}
			if(_isOutput)
			{
				_TextRenderer.height = _TextRenderer.textHeight + 5;
				Tool.setDisplayGlowFilter(_TextRenderer);
				if(_textBmd)
					_textBmd.dispose();
				_textBmd = new BitmapData(_TextRenderer.width, _TextRenderer.height,true, 0x0);
				_textBmd.draw(_TextRenderer);
				
				/*var flg:Boolean = isBitmapData(_textBmd);
				if(!flg) return;*/
				var texture:Texture = Texture.fromBitmapData(_textBmd, false);
				//texture.root.onRestore = texture_onRestore;
				if(!_textImage)
				{
					_textImage = new Image(texture);
					addChildAt(_textImage,0);
				}	else {
					_textImage.texture.dispose();
					_textImage.texture = texture;
					_textImage.readjustSize();		
				}
			}
			
			if(texture.height > this.height)
				this.height = texture.height
			//if doesn't scroll but have sprites to render, do it
			if (newSprites != null) _spriteRenderer.render();
		}
		/**防止无效bitmapdata处理*/
		/*private function isBitmapData(bmd:BitmapData):Boolean
		{
			try {
				var bm:Bitmap = new Bitmap(bmd);
			} 	catch (e:Error){
				trace('无效的bitmapdata');
				return false
			}
			return true;
		}*/
		private function texture_onRestore():void
		{
			if(!this.parent) return;
			if(_textBmd)
				_textBmd.dispose();
			_textBmd= new BitmapData(_TextRenderer.width, _TextRenderer.height,true, 0x0);
			_textBmd.draw(_TextRenderer);
			/*var flg:Boolean = isBitmapData(_textBmd);
			if(!flg) return;*/
			_textImage.texture.root.uploadBitmapData(_textBmd)
		}
		/**
		 * 使用newText和newSprites参数的内容替换startIndex和endIndex参数指定的位置之间的内容。
		 * @param	startIndex 要替换的起始位置。
		 * @param	endIndex 要替换的末位位置。
		 * @param	newText 要替换的新文本。
		 * @param	newSprites 要替换的显示元素数组，每个元素包含src和index两个属性，如：{src:sprite, index:1}。
		 */
		public function replace(startIndex:int, endIndex:int, newText:String, newSprites:Array = null):void
		{
			//replace text			
			var oldLength:int = _TextRenderer.length;
			var textLength:int = 0;
			if (endIndex > oldLength) endIndex = oldLength;
			newText = newText.split(_placeholder).join("");
			_TextRenderer.replaceText(startIndex, endIndex, newText);
			textLength = _TextRenderer.length - oldLength + (endIndex - startIndex);
			
			if (textLength > 0)
			{
				_TextRenderer.setTextFormat(_TextRenderer.defaultTextFormat, startIndex, startIndex + textLength);
			}
			
			//remove sprites which be replaced
			for (var i:int = startIndex; i < endIndex; i++)
			{
				_spriteRenderer.removeSprite(i);
			}
			
			//adjust sprites after startIndex
			var adjusted:Boolean = _spriteRenderer.adjustSpritesIndex(startIndex - 1, _TextRenderer.length - oldLength);
			
			//insert sprites
			insertSprites(newSprites, startIndex, startIndex + textLength);
			
			_TextRenderer.height = _TextRenderer.textHeight + 5;
			if(_textBmd)
				_textBmd.dispose() ;
			_textBmd = new BitmapData(_TextRenderer.width, _TextRenderer.height,true, 0x0);
			_textBmd.draw(_TextRenderer,null,null,null,null,true);
			/*var flg:Boolean = isBitmapData(_textBmd);
			if(!flg) return;*/
			var texture:Texture = Texture.fromBitmapData(_textBmd, false);
			//texture.root.onRestore = texture_onRestore;
			if(!_textImage)
			{
				_textImage = new Image(texture);
				addChildAt(_textImage,0);
			}	else {
				_textImage.texture.dispose();
				_textImage.texture = texture;
				_textImage.readjustSize();		
			}
			//if adjusted or have sprites inserted, do render
			if (adjusted || (newSprites && newSprites.length > 0)) _spriteRenderer.render();
		}
		
		/**
		 * 从参数startIndex指定的索引位置开始，插入若干个由参数newSprites指定的显示元素。
		 * @param	newSprites 要插入的显示元素数组，每个元素包含src和index两个属性，如：{src:sprite, index:1}。
		 * @param	startIndex 要插入显示元素的起始位置。
		 * @param	maxIndex 要插入显示元素的最大索引位置。	
		 * @param	newline 指示是否为文本的新行。	
		 */
		private function insertSprites(newSprites:Array, startIndex:int, maxIndex:int, newline:Boolean = false):void
		{
			if (newSprites == null) return;
			newSprites.sortOn(["index","faceid"], [Array.NUMERIC,Array.NUMERIC]);
			
			for (var i:int = 0; i < newSprites.length; i++)
			{
				var obj:Object = newSprites[i];
				var index:int = obj.index;
				if (obj.index == undefined || index < 0 || index > maxIndex - startIndex) 
				{
					obj.index = maxIndex - startIndex;
					newSprites.splice(i, 1);
					newSprites.push(obj);
					i--;
					continue;
				}
				
				if (newline && index > 0 && index < maxIndex - startIndex) index += startIndex + i - 1;
				else index += startIndex + i;		
				insertSprite(obj, index, false, obj.cache);
			}
		}
		
		/**
		 * 在参数index指定的索引位置（从零开始）插入由newSprite参数指定的显示元素。
		 * @param	newSprite 要插入的显示元素。其格式包含src和index两个属性，如：{src:sprite, index:1}。
		 * @param	index 要插入的显示元素的索引位置。
		 * @param	autoRender 指示是否自动渲染插入的显示元素。
		 * @param	cache 指示是否对显示元素使用缓存。
		 */
		public function insertSprite(newSprite:Object, index:int = -1, autoRender:Boolean = true, cache:Boolean = false):void
		{
			//create a instance of sprite
			var spriteObj:DisplayObject = getSpriteFromObject(newSprite);
			if (spriteObj == null) throw Error("Specific sprite:" + newSprite.src + " is not a valid display object!");
			
			//if (cache) spriteObj.cacheAsBitmap = true;
			//resize spriteObj if lineHeight is specified
			if (lineHeight > 0 && spriteObj.height > lineHeight)
			{
				var scaleRate:Number = lineHeight / spriteObj.height;
				spriteObj.height = lineHeight;
				spriteObj.width = spriteObj.width * scaleRate;
			}
			
			//verify the index to insert
			if (index < 0 || index > _TextRenderer.length) index = _TextRenderer.length;			
			//insert a placeholder into textfield by using replaceText method
			_TextRenderer.replaceText(index, index, _placeholder);			
			//calculate a special textFormat for spriteObj's placeholder
			var format:TextFormat;
			if(spriteObj is TextMovieClip)
				format = calcPlaceholderFormat(spriteObj.width, spriteObj.height - 2);
			else if(spriteObj is TextPlayerName)
				format = calcPlaceholderFormat(TextPlayerName(spriteObj).myWidth, spriteObj.height - 2);
			else 
				format = calcPlaceholderFormat(spriteObj.width - 5, spriteObj.height - 4);
			//apply the textFormat to placeholder to make it as same size as the spriteObj
			_TextRenderer.setTextFormat(format, index, index + 1);	
			
			//adjust sprites index which come after this sprite
			_spriteRenderer.adjustSpritesIndex(index, 1);
			//insert spriteObj to specific index and render it if it's visible
			_spriteRenderer.insertSprite(spriteObj, index);
			
			//if autoRender, just do it
			if (autoRender) _spriteRenderer.render();
		}
		
		private function getSpriteFromObject(sprite:Object):DisplayObject
		{
			var obj:Object = sprite.src;
			if (obj is String) 
			{
				switch(sprite.type)
				{
					case 'movieclip' :
						var algs:Vector.<Texture> = HAssetsManager.getInstance().getMyTextures("mainFaceSource",String(obj));
						var tmc:TextMovieClip = HObjectPool.getInstance().popObj(TextMovieClip) as TextMovieClip;
						tmc.setTextureList(algs);
						tmc.PlaySpeed = 2;
						return tmc;
						break;
					case 'HLinkText' :
						var link:HTaskLinkText = new  HTaskLinkText;
						link.isFangZhengCuYuan = false;
						link.needPose = false;
						link.eventLabel = sprite.color + ChatDataSource.getMyInstance().textSize + "nu00" + String(obj);
						var vo:HpopMenuVo = new HpopMenuVo();
						var index:int = _mapTypeArr.indexOf(HMapSources.getInstance().mapData.type)
						if(index > -1)
						{
							vo.nameIdArr = [3,25];
						}	else {
							if(sprite. worldID == HMapSources.getInstance().mainWizardObject.Player_CurWorldId && sprite.actorID != HMapSources.getInstance().mainWizardObject.Player_ActorId)
								vo.nameIdArr = [5,24,3,25];
							else
								vo.nameIdArr = [3,25];
							if(sprite.kindID > 0 && sprite.kindID != HMapSources.getInstance().mainWizardObject.Player_Camp)
								vo.nameIdArr.push(23);
						}
						vo.name = String(obj);
						vo.worldId = sprite. worldID;
						vo.actorID = sprite.actorID;
						vo.playerName = sprite.color + ChatDataSource.getMyInstance().textSize + "nu00" + String(obj);
						vo.vipIconStr = sprite.vipIconStr;
						vo.campIconStr = sprite.campIconStr;
						link.data = vo;
						return link;
						break;
					case 'ActiveLink' :
						var active:HTaskLinkText = new  HTaskLinkText;
						active.needPose = false;
						active.isFangZhengCuYuan = false;
						active.eventLabel = sprite.color + ChatDataSource.getMyInstance().textSize + "nu00" + String(obj);
						active.data = {linkListSource:sprite.linkListSource, playerName:sprite.src};
						return active;
						break;
					case 'showItemIcon' :
						var icon:HItemText = new  HItemText;
						icon.isDis = false;
						icon.textSize = ChatDataSource.getMyInstance().textSize + '';
						icon.isFangZhengCuYuan = false;
						icon.data = sprite;
						return icon;
						break;
					case 'SFtext' :
						icon = new  HItemText;
						icon.isDis = false;
						icon.textSize = ChatDataSource.getMyInstance().textSize + '';
						icon.isFangZhengCuYuan = false;
						icon.data = sprite;
						return icon;
						break;
					case 'TextPlayerName' :
						vo = new HpopMenuVo();
						index = _mapTypeArr.indexOf(HMapSources.getInstance().mapData.type)
						if(index > -1)
						{
							vo.nameIdArr = [3,25];
						}	else {
							if(sprite. worldID == HMapSources.getInstance().mainWizardObject.Player_CurWorldId && sprite.actorID != HMapSources.getInstance().mainWizardObject.Player_ActorId)
								vo.nameIdArr = [5,24,3,25];
							else
								vo.nameIdArr = [3,25];
							if(sprite.kindID > 0 && sprite.kindID != HMapSources.getInstance().mainWizardObject.Player_Camp && sprite.worldID == HMapSources.getInstance().mainWizardObject.Player_CurWorldId)
								vo.nameIdArr.push(23);
						}
						vo.name = String(obj);
						vo.worldId = sprite. worldID;
						vo.lineID = sprite.lineID;
						vo.actorID = sprite.actorID;
						vo.playerName = sprite.color + ChatDataSource.getMyInstance().textSize + "nu00" + String(obj);
						vo.vipIconStr = sprite.vipIconStr;
						vo.campIconStr = sprite.campIconStr;
						var playerName:TextPlayerName = HObjectPool.getInstance().popObj(TextPlayerName) as  TextPlayerName;
						playerName.data = vo;
						return playerName
						break;
				}			
			}	else if (obj is Class) {
				return new obj() as DisplayObject;
			}
			return obj as DisplayObject;
		}
		
		/**
		 * 计算显示元素的占位符的文本格式（若使用不同的占位符，可重写此方法）。
		 * @param	width 宽度。
		 * @param	height 高度。
		 * @return
		 */
		private function calcPlaceholderFormat(width:Number, height:Number):TextFormat
		{
			var format:TextFormat = new TextFormat();
			format.color = _placeholderColor;
			format.size = height + 2 * _placeholderMarginV;		
			
			//calculate placeholder text metrics with certain size to get actual letterSpacing
			_formatCalculator.setTextFormat(format);
			var metrics:TextLineMetrics = _formatCalculator.getLineMetrics(0);
			
			//letterSpacing is the key value for placeholder
			format.letterSpacing = width - metrics.width + 2 * _placeholderMarginH;
			format.underline = format.italic = format.bold = false;
			return format;
		}
		
		/**
		 * 设置RichTextField的尺寸大小（长和宽）。
		 * @param	width 宽度。
		 * @param	height 高度。
		 */
		public function setSize(width:Number, height:Number):void
		{
			if (_width == width && _height == height) return;
			_width = width;
			_height = height;
			_TextRenderer.width = _width;
			_TextRenderer.height = _height;
			_spriteRenderer.render();
		}
		
		/**
		 * 指示index参数指定的索引位置上是否为显示元素。
		 * @param	index 指定的索引位置。
		 * @return
		 */
		public function isSpriteAt(index:int):Boolean
		{
			if (index < 0 || index >= _TextRenderer.length) return false;
			return _TextRenderer.text.charAt(index) == _placeholder;
		}
		
		private function scrollHandler(e:Event):void 
		{
			_spriteRenderer.render();
		}
		
		private function changeHandler(e:Event):void 
		{
			var index:int = _TextRenderer.caretIndex;
			var offset:int = _TextRenderer.length - _TextRenderer.oldLength;
			if (offset > 0)
			{
				_spriteRenderer.adjustSpritesIndex(index - 1, offset);
			}else
			{
				//remove sprites
				for (var i:int = index; i < index - offset; i++)
				{
					_spriteRenderer.removeSprite(i);
				}
				_spriteRenderer.adjustSpritesIndex(index + offset, offset);
			}
			_spriteRenderer.render();
		}
		
		/**
		 * 清除所有文本和显示元素,并显示一个空白区域。
		 */
		public function clear():void
		{
			_spriteRenderer.clear();
			_TextRenderer.clear();
			if(_textBmd)
				_textBmd.dispose();
			_textBmd = new BitmapData(_TextRenderer.width, _TextRenderer.height,true, 0x0);
			_textBmd.draw(_TextRenderer);
			/*var flg:Boolean = isBitmapData(_textBmd);
			if(!flg) return;*/
			var texture:Texture = Texture.fromBitmapData(_textBmd, false);
			//texture.root.onRestore = texture_onRestore;
			if(_textImage)
			{
				_textImage.texture = texture;
				_textImage.readjustSize();
			}
		}
		/**
		 * 清除所有文本和显示元素。
		 */
		public function clearData():void
		{
			_spriteRenderer.clear();
			_TextRenderer.clear();
			dataXMl = null;
		}
		
		/**
		 * 指示RichTextField的类型。
		 * @default RichTextField.DYNAMIC
		 */
		public function get type():String 
		{ 
			return _TextRenderer.type;
		}
		
		public function set type(value:String):void 
		{
			_TextRenderer.type = value;
			_TextRenderer.addEventListener(Event.SCROLL, scrollHandler);
			if (value == INPUT)
			{
				_isOutput = false;
				_TextRenderer.addEventListener(Event.CHANGE, changeHandler);
				Starling.current.nativeStage.addChild(_TextRenderer);
			}	else {
				_isOutput = true;
			}
		}
		
		/**
		 * TextField实例。
		 */
		public function get textfield():TextField 
		{ 
			return _TextRenderer;
		}
		
		/**
		 * 指示显示元素占位符的水平边距。
		 * @default 1
		 */
		public function set placeholderMarginH(value:int):void 
		{
			_placeholderMarginH = value;
		}
		
		/**
		 * 指示显示元素占位符的垂直边距。
		 * @default 0
		 */
		public function set placeholderMarginV(value:int):void 
		{
			_placeholderMarginV = value;
		}
		
		/**
		 * 返回RichTextField对象的可见宽度。
		 */
		public function get viewWidth():Number
		{
			return _width;
		}
		
		/**
		 * 返回RichTextField对象的可见高度。
		 */
		public function get viewHeight():Number
		{
			return _height
		}
		
		/**
		 * 返回文本字段中的内容（包括显示元素的占位符）。
		 */
		public function get content():String
		{
			return _TextRenderer.text;
		}
		
		/**
		 * 返回文字字段中的内容长度（包括显示元素的占位符）。
		 */
		public function get contentLength():int
		{
			return _TextRenderer.length;
		}
		
		/**
		 * 返回文本字段中的文本（不包括显示元素的占位符）。
		 */
		public function get text():String
		{
			return _TextRenderer.text.split(_placeholder).join("");
		}
		
		/**
		 * 返回文字字段中的文本长度（不包括显示元素的占位符）。
		 */
		public function get textLength():int
		{
			return _TextRenderer.length - _spriteRenderer.numSprites;
		}
		
		/**
		 * 返回由参数index指定的索引位置的显示元素。
		 * @param	index
		 * @return
		 */
		public function getSprite(index:int):DisplayObject
		{
			return _spriteRenderer.getSprite(index);
		}
		
		/**
		 * 返回RichTextField中显示元素的数量。
		 */
		public function get numSprites():int
		{
			return _spriteRenderer.numSprites;
		}
		
		/**
		 * 指定鼠标指针的位置。
		 */
		public function get caretIndex():int
		{
			return _TextRenderer.caretIndex;
		}		
		
		public function set caretIndex(index:int):void
		{
			_TextRenderer.setSelection(index, index);
		}
		
		/**
		 * 指定文本字段的默认文本格式。
		 */
		public function get defaultTextFormat():TextFormat
		{
			return _TextRenderer.defaultTextFormat;
		}		
		
		public function set defaultTextFormat(format:TextFormat):void
		{
			if (format.color != null) _placeholderColor = uint(format.color);
			_TextRenderer.defaultTextFormat = format;
		}
		
		/**
		 * 导出XML格式的RichTextField的文本和显示元素内容。
		 * @return
		 */
		public function exportXML():XML
		{
			var xml:XML =<rtf/>;
			if (html) 
			{
				xml.htmlText = _TextRenderer.htmlText.split(_placeholder).join("");
			}else
			{
				xml.text = _TextRenderer.text.split(_placeholder).join("");
			}
			
			xml.sprites = _spriteRenderer.exportXML();
			return xml;
		}
		
		private var _startIndex:int = -1;
		private var _textBmd:BitmapData;
		private var _mapTypeArr:Array = [10, 11, 12, 19, 20, 21, 25, 26, 27];	//多人整本地图类型
		
		/**
		 * 设置字体颜色 
		 * @param newColor
		 * 
		 */		
		public function setTextColor( newColor:uint ):void{
			_TextRenderer.defaultTextFormat.color = newColor;
			_startIndex = -1;
			LoopFunction();
		}
		
		/**
		 * 设置字体大小 
		 * @param newSize
		 * 
		 */		
		public function setTextSize( newSize:uint ):void{
			_TextRenderer.defaultTextFormat.size = newSize;
			_startIndex = -1;
			LoopFunction();
		}
		
		//递归寻找占位符所在索引，把除占位符以外字符全部更新字体格式
		private function LoopFunction( ):void{
			var index:int = _TextRenderer.text.indexOf( _placeholder, _startIndex );
			if( index > -1 ){
				_TextRenderer.setTextFormat( _TextRenderer.defaultTextFormat, _startIndex, index );
				_startIndex = index+1;
				LoopFunction();
			}else{
				_TextRenderer.setTextFormat( _TextRenderer.defaultTextFormat, _startIndex, _TextRenderer.length );
				
				_TextRenderer.height = _TextRenderer.textHeight + 5;
				Tool.setDisplayGlowFilter(_TextRenderer);
				if(_textBmd)
					_textBmd.dispose();
				_textBmd = new BitmapData(_TextRenderer.width, _TextRenderer.height,true, 0x0);
				_textBmd.draw(_TextRenderer);
				/*var flg:Boolean = isBitmapData(_textBmd);
				if(!flg) return;*/
				var texture:Texture = Texture.fromBitmapData(_textBmd, false);
				//texture.root.onRestore = texture_onRestore;
				if(!_textImage)
				{
					_textImage = new Image(texture);
					addChildAt(_textImage,0);
				}	else {
					_textImage.texture.dispose();
					_textImage.texture = texture;
					_textImage.readjustSize();		
				}
				_spriteRenderer.render();//刷新表情坐标
			}
		}
		
		/**
		 * 嵌入特殊元素，特殊元素在被点击时会显示出其详细信息 
		 * @param type	元素类别
		 * @param text	元素文本
		 * @param info	元素实例
		 * 
		 */		
		/*public function insertSpecialElem(type:int, text:String, info:ItemVO):void{
			//注意在</a>末尾加一个空格，不然在超链接文本之后编辑的任何文字都会带有超链接
			_textRenderer.htmlText += "<a href='event:" + type + "_" + info.id + "'><font color='#9681b6'><u>" + text + "</u></font></a> ";
			GameModel.getInstance().itemList.push( info );
		}
		
		private function onLink(event:TextEvent):void{
			var ary:Array = event.text.split("_");
			dispatchEvent( new ElemClickedEvent(ELEM_CLICKED_EVENT, ary[0], ary[1]) );
		}*/
		
		/**
		 * 导入指定XML格式的文本和显示元素内容。
		 * @param	data 具有指定格式的XML内容。
		 * xml格式
		 * <sprite src={codeStr} index={inster} kindID={kinID} actorID={actorID} faceid={faceid} item={null} type={"HLinkText"} />
		 * <sprite src={codeStr} index={inster} kindID={kinID} actorID={actorID} faceid={faceid} item={item}  type={"showItemIcon"} />
		 * <sprite src={"face/face_" + codeStr + "_0"} index={inster} kindID={0} actorID={0} faceid={faceid} item={null} type={"image"} />
		 * <sprite src={"face/face_" + codeStr + "_0"} index={inster} kindID={0} actorID={0} faceid={faceid} item={null} type={"movieclip"} />;
		 */
		public function importXML(data:XML):void
		{
			var content:String = "";		
			if (data.hasOwnProperty("htmlText")) content += data.htmlText;
			if (data.hasOwnProperty("text")) content += data.text;						
			
			var sprites:Array = [];
			for (var i:int = 0; i < data.sprites.sprite.length(); i++)
			{
				var node:XML = data.sprites.sprite[i];
				var sprite:Object = { };
				sprite.src = String(node.@src);
				sprite.faceid = String(node.@faceid);
				//correct the index if import as html
				if (html) sprite.index = int(node.@index) + 1;
				else sprite.index = int(node.@index);
				sprites.push(sprite);
			}			
			
			append(content, sprites);
		}
		
		/**
		 * 清除旧的文本添加新文本
		 * 导入指定XML格式的文本和显示元素内容。
		 * @param	data 具有指定格式的XML内容。
		 * xml格式
		 * <sprite src={codeStr} index={inster} kindID={kinID} actorID={actorID} faceid={faceid} item={null} type={"HLinkText"} />
		 * <sprite src={codeStr} index={inster} kindID={kinID} actorID={actorID} faceid={faceid} item={item}  type={"showItemIcon"} />
		 * <sprite src={"face/face_" + codeStr + "_0"} index={inster} kindID={0} actorID={0} faceid={faceid} item={null} type={"image"} />
		 * <sprite src={"face/face_" + codeStr + "_0"} index={inster} kindID={0} actorID={0} faceid={faceid} item={null} type={"movieclip"} />;
		 */
		public function importXMLAfterClear(data:XML):void
		{
			dataXMl = data;
			if(ChatDataSource.getMyInstance().isDisposed || Starling.context.driverInfo == "Disposed") 
			{ 
				Dispatcher_F.getInstance().addEventListener(ComEventKey.CONTEXT_CREATED, onRestore);  
				return; 
			}
			var content:String = "";		
			if (data.hasOwnProperty("htmlText")) content += data.htmlText;
			if (data.hasOwnProperty("text")) content += data.text;						
			var len:int = data.sprites.sprite.length()
			var sprites:Array = [];
			var needAdd:Boolean = true;;
			for (var i:int = 0; i < len; i++)
			{
				var node:XML = data.sprites.sprite[i];
				var sprite:Object = { };
				sprite.src = String(node.@src);
				sprite.faceid = String(node.@faceid);
				sprite.type = String(node.@type);
				sprite.actorID = Number(node.@actorID);
				sprite.itemIndex = int(node.@itemIndex);
				sprite.color = String(node.@color);
				sprite.worldID = int(node.@worldID);
				sprite.lineID = int(node.@lineID);
				sprite.linkListSource = String(node.@linkListSource);
				sprite.kindID = int(node.@kindID);
				sprite.qqviptype = int(node.@qqviptype)
				sprite.qqviplv = int(node.@qqviplv)
				sprite.vipIconStr = String(node.@vipIconStr);
				sprite.campIconStr = String(node.@campIconStr);
				if(i == 0 && int(node.@index) == 0)
					needAdd = false;
				if (html && needAdd) sprite.index = int(node.@index) + 1;
				else sprite.index = int(node.@index);
				sprites.push(sprite);
			}			
			_spriteRenderer.clear();
			_TextRenderer.clear();
			append(content, sprites);
		}
		
		/**数据找回时刷新*/
		private function onRestore(event:flash.events.Event):void
		{
			Dispatcher_F.getInstance().removeEventListener(ComEventKey.CONTEXT_CREATED, onRestore);  
			importXMLAfterClear(dataXMl)
		}
		/**
		 * 为RichTextField增加插件。
		 * @param	plugin 要增加的插件。
		 */
		public function addPlugin(plugin:ShortcutPlugin):void
		{			
			plugin.setup(this);
			if (_plugins == null) _plugins = [];	
			_plugins.push(plugin);
		}
		public function myDispose():void
		{
			if(_textImage)
			{
				if(_textImage.parent)
					_textImage.parent.removeChild(_textImage);
				_textImage.texture.dispose();
				_textImage.dispose();
				_textImage = null;
			}
			if(_textBmd)
			{
				_textBmd.dispose();
				_textBmd = null;
			}
			if(_TextRenderer)
			{
				_TextRenderer.removeEventListener(Event.SCROLL, scrollHandler);
				_TextRenderer = null;
			}
			if(_spriteRenderer)
			{
				_spriteRenderer.myDispose();
				_spriteRenderer = null;
			}
			this.dispose();
		}
		
		public function setRendererPonsition(point:Point):void
		{
			_TextRenderer.x = point.x;
			_TextRenderer.y = point.y;
		}
		/**
		 * 文本高度 
		 * @return 
		 * 
		 */		
		public function get textRendererHeight():Number
		{
			if(_TextRenderer.textHeight < 25)
				return 22;
			else if(_TextRenderer.textHeight < 30)
				return 26;
			else
				return _TextRenderer.textHeight + 8;
		}
		/**
		 * 文本宽度 
		 * @return 
		 * 
		 */		
		public function get textRendererWight():Number
		{
			return _TextRenderer.textWidth + 8;
		}
		/**停止播放*/
		public function spriteRendererStop():void
		{
			_spriteRenderer.stop();
			
		}
		/**动画播放*/
		public function spriteRendererPlay():void
		{
			_spriteRenderer.play()
			
		}
	}
}