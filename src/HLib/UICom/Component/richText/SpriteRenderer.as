package HLib.UICom.Component.richText
{
	import flash.geom.Rectangle;
	import flash.text.TextLineMetrics;
	import flash.utils.Dictionary;
	
	import HLib.Tool.HObjectPool;
	import HLib.UICom.BaseClass.HSprite;
	import HLib.UICom.Component.HItemText;
	
	import Modules.view.task.HTaskLinkText;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	public class SpriteRenderer
	{
		private var _rtf:RichTextField;
		private var _numSprites:int;
		private var _spriteContainer:Sprite;
		private var _spriteIndices:Dictionary;		
		private var _isShowQQvip:Boolean;
		
		public function SpriteRenderer(rtf:RichTextField)
		{			
			_rtf = rtf;
			_numSprites = 0;
			_spriteContainer = new Sprite();
			/*_spriteContainer.touchable = false;*/
			_spriteIndices = new Dictionary();
		}
		
		internal function render():void
		{
			if (_numSprites > 0) 
			{
				_spriteContainer.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		/**
		 * prevent executing rendering code more than one time during a frame
		 * @param	e ENTER_FRAME evnet
		 */
		private function onEnterFrame(e:Event):void 
		{
			_spriteContainer.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			doRender();
		}
		
		/**
		 * the real rendering function
		 */
		private function doRender():void
		{
			_spriteContainer.y = -textRenderer.scrollHeight;
			renderVisibleSprites();
		}
		
		private function renderVisibleSprites():void
		{
			//all visible sprites are between lines scrollV and bottomScrollV
			var startLine:int = textRenderer.scrollV - 1;
			var endLine:int = textRenderer.bottomScrollV - 1;
			var startIndex:int = textRenderer.getLineOffset(startLine);
			var endIndex:int = textRenderer.getLineOffset(endLine) + textRenderer.getLineLength(endLine) - 1;
			var sprite:DisplayObject
			//clear all rendered sprites
			while (_spriteContainer.numChildren > 0) 
			{
				sprite = _spriteContainer.removeChildAt(0);
				if(sprite is TextMovieClip)
				{
					TextMovieClip(sprite).stop();
					HObjectPool.getInstance().pushObj(sprite);
				}	else if(sprite is TextPlayerName) {
					TextPlayerName(sprite).playerName = '';
					HObjectPool.getInstance().pushObj(sprite);
				}	else if(sprite is HItemText) {
					HItemText(sprite).myDispose();
				}	else if(sprite is HTaskLinkText) {
					HTaskLinkText(sprite).myDispose();
				}
				else if(sprite is Image)
					Image(sprite).dispose();
				
			}
			_isShowQQvip = false;
			//render sprites which between sdtartIndex and endIndex
			while (startIndex <= endIndex)
			{
				if (_rtf.isSpriteAt(startIndex)) 
				{
					sprite = getSprite(startIndex);
					if (sprite != null) 
					{
						if(sprite is TextPlayerName && TextPlayerName(sprite).isShowQQVip)
							_isShowQQvip = TextPlayerName(sprite).isShowQQVip;
						renderSprite(sprite, startIndex);
					}
				}
				startIndex++;
			}
		}
		
		private function renderSprite(sprite:DisplayObject, index:int):void
		{			
			var rect:Rectangle = textRenderer.getCharBoundaries(index);	
			if (rect != null)
			{
				if(sprite is TextPlayerName)
					sprite.x = (rect.x + (rect.width - TextPlayerName(sprite).myWidth) * 0.5 + 0.5)
				else
					sprite.x = (rect.x + (rect.width - sprite.width) * 0.5 + 0.5)
				var vy:Number;
				if(sprite is TextPlayerName || sprite is HItemText)
					vy = (rect.height - HSprite(sprite).myHeight) >> 1;
				else if(sprite is HTaskLinkText)
					vy = (rect.height - HTaskLinkText(sprite).textHeight) >> 1;
				else
					vy = (rect.height - sprite.height) >> 1;
				var lineMetrics:TextLineMetrics = textRenderer.getLineMetrics(textRenderer.getLineIndexOfChar(index));
				//make sure the sprite's y is not smaller than the ascent of line metrics
				if (vy + sprite.height < lineMetrics.ascent) vy = lineMetrics.ascent - sprite.height;
				sprite.y = (rect.y + vy + 0.5) 
				//fb4.6以上加上这句
				sprite.y += -_spriteContainer.y;
				//文本图片位置修正
				if(sprite is HTaskLinkText)
				{
					sprite.y += 3;
				}
				if(sprite is TextPlayerName || sprite is HItemText)
				{
					if(sprite is HItemText && rect.height == 28)
						sprite.y += 7;
					else
						sprite.y += 4;
				}
				if(sprite.y % 2 != 0)
					sprite.y = sprite.y - sprite.y % 2;
				if(sprite.x % 2 != 0)
					sprite.x = sprite.x - sprite.x % 2;
				//仅在未渲染此表情时才addChild
				if( !_spriteContainer.contains(sprite) )
				{
					_spriteContainer.addChild(sprite);
					if(sprite is TextMovieClip)
						TextMovieClip(sprite).play();
				}
			}
		}
		
		internal function adjustSpritesIndex(changeIndex:int, changeLength:int):Boolean
		{		
			var adjusted:Boolean = false;
			for (var s:* in _spriteIndices)
			{
				var index:int = int(s.name);
				if (index > changeIndex - changeLength)
				{
					s.name = index + changeLength;
					adjusted = true;
				}
			}
			return adjusted;
		}
		
		internal function insertSprite(sprite:DisplayObject, index:int):void
		{			
			if (_spriteIndices[sprite] == null)
			{
				sprite.name = String(index);
				_spriteIndices[sprite] = true;
				_numSprites++;
			}
		}
		
		internal function removeSprite(index:int):void
		{
			var sprite:DisplayObject = getSprite(index);
			if (sprite != null)
			{
				if (_spriteContainer.contains(sprite)) _spriteContainer.removeChild(sprite);
				if(sprite is TextMovieClip)
				{
					TextMovieClip(sprite).stop();
					HObjectPool.getInstance().pushObj(sprite);
				}	else if(sprite is TextPlayerName) {
					TextPlayerName(sprite).playerName = '';
					HObjectPool.getInstance().pushObj(sprite);
				}	else if(sprite is HItemText) {
					HItemText(sprite).myDispose();
				}	else if(sprite is HTaskLinkText) {
					HTaskLinkText(sprite).myDispose();
				}
				else if(sprite is Image)
					Image(sprite).dispose();
				delete _spriteIndices[sprite];
				_numSprites--;
			}
		}
		
		internal function getSprite(index:int):DisplayObject
		{
			for (var s:* in _spriteIndices)
			{
				if (index == int(s.name)) return s;
			}
			return null;
		}
		
		internal function getSpriteIndex(sprite:DisplayObject):int
		{
			if (_spriteIndices[sprite] == true) return int(sprite.name);
			return -1;
		}
		
		internal function clear():void
		{
			while (_spriteContainer.numChildren > 0)
			{
				var sprite:DisplayObject= _spriteContainer.removeChildAt(0);	
				if(sprite is TextMovieClip)
				{
					TextMovieClip(sprite).stop();
					HObjectPool.getInstance().pushObj(sprite);
				}	else if(sprite is TextPlayerName) {
					TextPlayerName(sprite).playerName = '';
					HObjectPool.getInstance().pushObj(sprite);
				}	else if(sprite is HItemText) {
					HItemText(sprite).myDispose();
				}	else if(sprite is HTaskLinkText) {
					HTaskLinkText(sprite).myDispose();
				} 	else if(sprite is Image) {
					Image(sprite).dispose();
				}
				
			}
			for (var p:* in _spriteIndices) delete _spriteIndices[p];
			_numSprites = 0;
		}
		
		private function get textRenderer():TextRenderer
		{
			return _rtf.textfield as TextRenderer;
		}
		
		internal function get container():Sprite 
		{ 
			return _spriteContainer;
		}
		
		internal function get numSprites():int 
		{ 
			return _numSprites; 
		}
		
		internal function exportXML():XML
		{
			var arr:Array = [];
			for (var s:* in _spriteIndices)
			{
				/*var info:Object = { src:getQualifiedClassName(s), index:s.name };*/
				var info:Object = { src:s.src, index:s.name };
				arr.push(info);
			}
			if (arr.length > 1) arr.sortOn("index", Array.NUMERIC);
			
			var xml:XML =<sprites/>;
			for (var i:int = 0; i < arr.length; i++)
			{
				var node:XML = <sprite src={arr[i].src} index={arr[i].index - i} />;
				xml.appendChild(node);
			}
			return xml;
		}
		/**开始动画播放*/
		public function play():void
		{
			var len:int = _spriteContainer.numChildren;
			for(var i:int=0; i<len; i++)
			{
				var sprite:DisplayObject= _spriteContainer.getChildAt(i);
				if(sprite is TextMovieClip)
				{
					TextMovieClip(sprite).play();
				}
			}
		}
		/**停止动画播放*/
		public function stop():void
		{
			var len:int = _spriteContainer.numChildren;
			for(var i:int=0; i<len; i++)
			{
				var sprite:DisplayObject= _spriteContainer.getChildAt(i);
				if(sprite is TextMovieClip)
				{
					TextMovieClip(sprite).stop()
				}
			}
		}
		
		public function myDispose():void
		{
			_rtf = null;
			if(_spriteContainer)
			{
				clear();
				if(_spriteContainer.parent)
				{
					_spriteContainer.parent.removeChild(_spriteContainer);
					_spriteContainer.dispose();
					_spriteContainer = null;
				}
			}
			_spriteIndices = null;
		}
	}
}