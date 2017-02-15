package HLib.Tool
{
	/**
	 * 常用处理工具类
	 * @author 李舒浩
	 * 
	 * 类别:
	 * 		1、对象获取
	 * 		2、对象绘制 
	 * 		3、对象处理
	 * 		4、数据获取
	 * 		5、数据转换
	 * 		6、数据处理
	 */	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.IBitmapDrawable;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import HLib.MapBase.Node;
	import HLib.Net.Socket.Order;
	import HLib.UICom.BaseClass.HBaseView;
	import HLib.UICom.BaseClass.HTextField2D;
	
	import Modules.Map.HMap3D;
	import Modules.Map.HMapSources;
	import Modules.Wizard.WizardObject;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	
	import starling.display.Sprite;
	import starling.filters.ColorMatrixFilter;

	public class Tool
	{
		/**  灰色滤镜  **/		
		private static const grayFilter:flash.filters.ColorMatrixFilter = new flash.filters.ColorMatrixFilter([
																						0.3086,   0.6094,   0.082,    0,
																						0,        0.3086,   0.6094,   0.082,
																						0,        0,        0.3086,   0.6094,
																						0.082,    0,        0,        0,
																						0,        0,        1,        0
																					]);
		/**
		 * 获取HTextField 
		 * @param $width	: 文本宽度
		 * @param $height	: 文本高度(-1为自动计算最小高度,一般单行文本用-1即可)
		 * @param size		: 字体大小
		 * @param color		: 字体颜色
		 * @param algin		: 字体对齐方式
		 * @param leading	: 字体间距
		 * @param bold		: 是否加粗
		 * @param font		: 文本字体
		 * @return 			: HTextField
		 */		
		public static function getHTextField($width:int = 100, $height:int = 18, size:int = 12, color:uint = 0xFFFFFF
											 , algin:String = "left", leading:int = 0, bold:Boolean = false, font:String = ""):HTextField2D
		{
			var textField:HTextField2D = new HTextField2D();
			textField.size = size;
			textField.color = color;
			textField.algin = algin;
			textField.leading = leading;
			textField.bold = bold;
			if(font!="") textField.font = font;
			textField.text = "0";
			if($width == -1)
				textField.width = textField.textWidth+4;
			else
				textField.width = $width;
			if($height == -1)
				textField.height = textField.textHeight+4;
			else
				textField.height = $height;
			textField.text = "";
			return textField;
		}
			
			
		/**
		 * 绘制矩形 
		 * @param graphics		: 绘制图形的graphics
		 * @param bitmapdata	: 绘制图形填充的位图，如果为空，则用矢量图绘制
		 * @param width  		: 绘制图形的宽
		 * @param height 		: 绘制图形的高
		 * @param color   		: 绘制图形的背景颜色，位图填充为空时使用
		 * @param alpha     	: 绘制图形的背景色透明度
		 * @param X      		: 绘制图形的x坐标开始位置
		 * @param Y      		: 绘制图形的y坐标开始位置
		 * @param lineSize 		: 绘制图形的边框大小
		 * @param linecolor 	: 绘制图形的边框颜色，位图填充为空时使用
		 * @param lineAlpha 	: 绘制图形的边框透明度
		 * @param isClear 		: 是否先清空
		 */	
		public static function drawRectByGraphics(graphics:Graphics, bitmapdata:BitmapData = null, width:Number = 100, height:Number = 100, color:uint = 0
			, alpha:Number = 1, X:Number = 0, Y:Number = 0, lineSize:uint = 0, linecolor:uint = 0x0, lineAlpha:Number = 1, isClear:Boolean = true):void
		{
			//清空绘制
			if(isClear) graphics.clear();
			//判断是用位图填充还是直接绘制
			if(bitmapdata)
			{
				graphics.beginBitmapFill(bitmapdata, null, false);
				width = bitmapdata.width>>1;
				height = bitmapdata.height>>1;
			}
			else
			{
				graphics.lineStyle(lineSize, linecolor, lineAlpha);
				graphics.beginFill(color, alpha);
			}
			
			graphics.drawRect(X, Y, width, height);
			graphics.endFill();
		}
		/**
		 * 绘制矩形线
		 * @param graphics		: 绘制图形的graphics
		 * @param bitmapdata	: 位图填充
		 * @param width			: 线区域宽度
		 * @param height		: 线区域高度
		 * @param alpha			: 线条透明值
		 * @param lineSize		: 线粗度
		 * @param lineColor		: 线颜色
		 * @param actionX		: 绘制线起始X坐标
		 * @param actionY		: 绘制线起始Y坐标
		 * @param isClear 		: 是否先清空
		 */		
		public static function drawReacLineByGraphics( graphics:Graphics, bitmapdata:BitmapData = null, width:Number = 100, height:Number = 100
				, alpha:Number = 1, lineSize:int = 1, lineColor:uint = 0x0, actionX:Number = 0, actionY:Number = 0, isClear:Boolean = true):void
		{
			if(isClear) graphics.clear();
			if(bitmapdata)
				graphics.lineBitmapStyle(bitmapdata); 
			graphics.lineStyle(lineSize, lineColor, alpha);
			graphics.moveTo(actionX, actionY);
			graphics.lineTo((actionX+width), actionY);
			graphics.lineTo((actionX+width), (actionY+height));
			graphics.lineTo(actionX, (actionY+height));
			graphics.lineTo(actionX, actionY);
			graphics.endFill();
		}
		
		/**
		 * 绘制60度角菱形格子线
		 * @param graphics		: 绘制图形的graphics
		 * @param bitmapdata	: 位图填充
		 * @param size			: 菱形大小
		 * @param alpha			: 线条透明值
		 * @param lineSize		: 线粗度
		 * @param lineColor		: 线颜色
		 * @param actionX		: 绘制线起始X坐标
		 * @param actionY		: 绘制线起始Y坐标
		 * @param isClear 		: 是否先清空
		 * 排列大菱形公式
		 * 		X = (initLocationX+( int(i/rowNum)*(size/2) )) + (i%rowNum)*(size/2)
		 *		Y = (initLocationY+( int(i/lineNum)*(size/3) )) + (i%lineNum)*(-size/3)
		 */		
		public static function drawDiamondLineByGraphics( graphics:Graphics, bitmapdata:BitmapData = null, size:int = 100, alpha:Number = 1
												   , lineSize:int = 1, lineColor:uint = 0x0, actionX:Number = 0, actionY:Number = 0, isClear:Boolean = true):void
		{
			if(isClear) graphics.clear();
			if(bitmapdata)
				graphics.lineBitmapStyle(bitmapdata); 
			graphics.lineStyle(lineSize, lineColor, alpha);
			
			graphics.moveTo( actionX, actionY);
			graphics.lineTo( actionX+(size/2), actionY-(size/3) );
			graphics.lineTo( actionX+size, actionY );
			graphics.lineTo( actionX+(size/2), actionY+(size/3) );
			graphics.lineTo( actionX, actionY );
			graphics.endFill();
		}
		
		/**
		 * 绘制圆形 
		 * @param graphics		: 绘制图形的graphics
		 * @param bitmapdata	: 位图填充
		 * @param radius		: 圆形半径
		 * @param alpha			: 圆形透明值
		 * @param actionX		: 起始点X
		 * @param actionY		: 起始点Y
		 * @param lineSize		: 先粗度
		 * @param lineColor		: 线颜色
		 * @param lineAlpha		: 线透明度
		 * @param isClear 		: 是否先清空
		 */		
		public static function drawCircleByGraphics(graphics:Graphics, bitmapdata:BitmapData = null, radius:int = 20, color:uint = 0x0, alpha:Number = 1
				, actionX:Number = 0, actionY:Number = 0, lineSize:int = 1, lineColor:uint = 0x0, lineAlpha:Number = 1, isClear:Boolean = true):void
		{
			if(isClear) graphics.clear();
			graphics.lineStyle(lineSize, lineColor, lineAlpha);
			graphics.beginFill(color, alpha);
			graphics.drawCircle(actionX, actionY, radius);
			graphics.endFill();
		}
		
		/**
		 * 绘制扇形
		 * @param graphics	: 绘制图形的graphics
		 * @param bitmapdata: 绘制图形的位图填充
		 * @param x			: 圆点X坐标
		 * @param y			: 圆点Y坐标
		 * @param r			: 绘制半径
		 * @param angle		: 扇形角度
		 * @param color		: 扇形颜色
		 * @param alp		: 扇形透明值
		 * @param startFrom	: 扇形起始角度(默认270,12点方向)
		 * @param lineSize	: 线粗度
		 * @param lineColor	: 线颜色
		 * @param lineAlpha	: 线透明值
		 * @param isClear	: 绘制前是否先清空
		 * @param isReverse	: 是否顺时针旋转
		 */		
		public static function drawSectorByGraphics(graphics:Graphics, bitmapdata:BitmapData = null, x:Number = 200, y:Number = 200, r:Number = 100, angle:Number = 27,color:Number = 0x0
													,alp:Number = 1, startFrom:Number = 270, lineSize:int = 1, lineColor:uint = 0x0, lineAlpha:Number = 1, isClear:Boolean = true,isReverse:Boolean=false):void 
		{
			if(isClear) graphics.clear();
			
			if(bitmapdata)
				graphics.beginBitmapFill(bitmapdata, null, false);
			graphics.beginFill(color, alp);
			graphics.lineStyle(lineSize,lineColor, lineAlpha);
			graphics.moveTo(x, y);
			angle = (abs(angle)>360) ? 360 : angle;
			
			var n:Number = Math.ceil(abs(angle)/45);
			var angleA:Number = angle/n;
			angleA = angleA*Math.PI/180;
			startFrom = startFrom*Math.PI/180;
			graphics.lineTo(x+r*Math.cos(startFrom), y+r*Math.sin(startFrom));
			
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
				bx = x+r/Math.cos(angleA/2)*Math.cos(angleMid);
				by = y+r/Math.cos(angleA/2)*Math.sin(angleMid);
				cx = x+r*Math.cos(startFrom);
				cy = y+r*Math.sin(startFrom);
				graphics.curveTo(bx,by,cx,cy);
			}
			if (angle != 360)
				graphics.lineTo(x, y);
			graphics.endFill();
		}
/****************************************************************************************************************/
/*******************************************          ***********************************************************/
/******************************************  对象处理  ***********************************************************/
/*******************************************          ***********************************************************/
/****************************************************************************************************************/
		/**
		 * 组合位图
		 * @param bitmapDataArr	: 需要组合的bitmapdata数组(组合顺序由左到右,数组须自行排序)
		 */		
		public static function groupBitmap(bitmapDataArr:Vector.<BitmapData>):BitmapData
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
			//拼装位图
			var bitmapdata:BitmapData = new BitmapData(w, h, true, 0);
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
		/**
		 * bitmapdata绘制,与copyPixels用法一样,增加多放大倍数
		 * @param target			: 绘制目标bitmapdata
		 * @param source			: 绘制原图
		 * @param rect				: 绘制区域
		 * @param pt				: 绘制点
		 * @param colorTransform	: 
		 * @param scaleW			: 宽放大比例
		 * @param scaleH			: 高放大比例
		 */		
		public static function draw(target:BitmapData, source:IBitmapDrawable, rect:Rectangle, pt:Point, colorTransform:ColorTransform = null, scaleW:Number = 1, scaleH:Number = 1):void
		{
			var clipRect:Rectangle = new Rectangle();
			clipRect.x = pt.x;
			clipRect.y = pt.y;
			clipRect.width = rect.width * scaleW;
			clipRect.height = rect.height * scaleW;
			
			var matrix:Matrix = new Matrix();
			matrix.tx = pt.x - rect.x;
			matrix.ty = pt.y - rect.y;
			matrix.a = scaleW;	//x缩放
			matrix.d = scaleH; //y分别缩放
			target.draw(source, matrix, colorTransform, null, clipRect, false);
		}
		
		/**
		 * 获取灰色滤镜
		 */		
		public static function getGrayColorMatrixFilter():starling.filters.ColorMatrixFilter
		{
			/*if(_colorMatrixFilter == null)
			{*/
				_colorMatrixFilter = new starling.filters.ColorMatrixFilter();
				_colorMatrixFilter.adjustSaturation(-1);	
			/*}*/
			return _colorMatrixFilter
		}
		
		/**
		 * 灰化可视对象 
		 * @param displayObj	: 需要灰化的可视对象
		 */		
		public static function grayDisplayObject(displayObj:DisplayObject):void
		{
			displayObj.filters = [grayFilter];
		}
		
		/**
		 * 设置starling sprite对象滤镜效果
		 * @param sprite
		 */		
		public static function grayStaringSprite(sprite:Sprite):void
		{
			var colorMatrixFilter:starling.filters.ColorMatrixFilter = new starling.filters.ColorMatrixFilter();
			colorMatrixFilter.adjustSaturation(-1);
			sprite.filter = colorMatrixFilter;
		}
		/**
		 * 移除starling sprite对象滤镜效果
		 * @param sprite
		 */		
		public static function removeFilterStarlingSprite(sprite:Sprite):void
		{
			if(sprite.filter)
				sprite.filter.dispose();
			sprite.filter = null;
		}
		
		/**
		 * 设置可视对象显示滤镜效果 
		 * @param displayObj	: 需要设置的显示对象
		 * @param color			: 边框颜色
		 * @param alpha			: 边框的透明度
		 * @param blurX			: 边框在x坐标轴方向的模糊量
		 * @param blerY			: 边框在y坐标轴方向的模糊量
		 * @param strength		: 设置边框的强度
		 * @param quality		: 模糊执行的次数，和BlurFilter里的quality一样(实际上它们的模糊原理是一样的)
		 * @param inner			: 决定是投影是在绘制在对象内部还是外部
		 * @param knockout		: 设置是否应用挖空效果
		 */		
		public static function setDisplayGlowFilter(displayObj:DisplayObject, color:uint=0x0, alpha:Number=1, blurX:Number=2, blerY:Number=2,
													strength:Number=3, quality:int=1, inner:Boolean=false, knockout:Boolean=false):void
		{
			_glowFilter = [new GlowFilter(color, alpha, blurX,blerY, strength, quality, inner, knockout)]
			displayObj.filters = _glowFilter;
		}
		
		/**
		 * 设置显示对象投影
		 * @param displayObj	: 需要设置的显示对象
		 * @param _distance		: 显示对象副本较原始对象的偏移量，以像素为单位
		 * @param angel			: 投影的偏移角度
		 * @param color			: 投影颜色
		 * @param alpha			: 投影的透明度
		 * @param blurX			: 投影在x坐标轴方向的模糊量
		 * @param blerY			: 投影再y坐标轴方向的模糊量
		 * @param strength		: 设置投影的强度，值越大投影越暗，与背景产生的对比差异越大
		 * @param quality		: 模糊执行的次数，和BlurFilter里的quality一样(实际上它们的模糊原理是一样的)
		 * @param inner			: 决定是投影是在绘制在对象内部还是外部
		 * @param knockout		: 设置是否应用挖空效果
		 * @param hideObject
		 */		
		public static function setDisplayDropShadowFilter(displayObj:DisplayObject, distance:Number=0, angel:Number=0, color:uint=0x0, alpha:Number=1
														  ,blurX:Number=2, blerY:Number=2, strength:Number=4, quality:int=2, inner:Boolean=false, knockout:Boolean=false,
														   hideObject:Boolean=false ):void
		{
			displayObj.filters = [new DropShadowFilter(distance, angel, color, alpha, blurX,blerY, strength, quality, inner, knockout, hideObject)];
		}
		
		/**
		 * 设置显示对象内向外发光效果 
		 * @param displayObj	: 显示对象
		 * @param callBack		: 发光结束后执行回调
		 * @param time			: 发光执行时间
		 * @param color			: 发光颜色
		 * @param alp			: 发光透明度
		 * @param blurX			: 发光X范围
		 * @param blurY			: 发光Y范围
		 * @param strength		: 发光强度
		 */		
		public static function setTweenMaxOutGlow(displayObj:DisplayObject, callBack:Function = null, time:Number = 0.5, color:uint = 0x3CBFF5
												  ,alp:Number = 1 , blurX:int = 10, blurY:int = 10, strength:Number = 2):void
		{
			var tweenMax:TweenMax = TweenMax.to(displayObj, time, { glowFilter:{ color:color,alpha:alp,blurX:blurX,blurY:blurY,strength:strength }
				,onComplete:function():void
				{
					tweenMax.kill();
					if(callBack != null)
					{
						callBack();
					}
				}
			});
		}
		
		/**
		 * 设置显示对象内向内发光效果 
		 * @param displayObj	: 显示对象
		 * @param callBack		: 发光结束后执行回调
		 * @param time			: 发光执行时间
		 * @param color			: 发光颜色
		 * @param alp			: 发光透明度
		 * @param blurX			: 发光X范围
		 * @param blurY			: 发光Y范围
		 * @param strength		: 发光强度
		 */		
		public static function setTweenMaxOverGlow(displayObj:DisplayObject, callBack:Function = null, time:Number = 0.5, color:uint = 0x3CBFF5
												   ,alp:Number = 1 , blurX:int = 1, blurY:int = 1, strength:Number = 2):void
		{
			var tweenMax:TweenMax = TweenMax.to(displayObj, time, {glowFilter:{color:color, alpha:alp, blurX:blurX, blurY:blurY, strength:strength},
				onComplete:function(obj:DisplayObject):void
				{
					tweenMax.kill();
					obj.filters = [];
					if(callBack != null) callBack();
				}, onCompleteParams:[displayObj]
			})
		}
		
		/**
		 * 清除可视对象效果 
		 * @param displayObj	: 需清除的可是对象
		 */		
		public static function removeFilterObject(displayObj:DisplayObject):void
		{
			displayObj.filters = [];
		}
		/**
		 * 设置显示对象淡 || 隐淡出效果 
		 * @param displayObject	: 需要设置的显示对象
		 * @param t				: 淡隐 || 淡现消耗时间
		 * @param alp			: 透明值
		 * @param callBack		: 回调方法
		 * @param isVisible		: 淡隐 || 淡现后显示对象的visible值设置
		 */		
		public static function setTweenAlphaByDisplayObject(displayObject:DisplayObject, t:Number, alp:Number, callBack:Function = null, isUseVisible:Boolean = false, isVisible:Boolean = true):void
		{
			var tweenLite:TweenLite = TweenLite.to(displayObject, t, {alpha:alp, onComplete:
				function():void
				{
					tweenLite.kill();
					tweenLite = null;
					if(isUseVisible)
						displayObject.visible = isVisible;
					if(callBack != null) callBack();
				}
			});
		}
		
		/**
		 * 批量移除子对象
		 * @param childArr	: 子对象数组(如[sprite1, sprite2...],此对象需要是显示对象)
		 * @param isNull	: 移除后是否制空
		 */		
		public static function removeChilds(childArr:Array, isNull:Boolean = true):void
		{
			for each(var child:DisplayObject in childArr)
			{
				if(child.parent) child.parent.removeChild(child);
				if(isNull) child = null;
			}
		}
		
		/**
		 * 根据显示区域大小自动设置对象位置显示(一般用于tips位置控制)
		 * @param setDisplayerObject	: 需要设置的对象
		 */		
		public static function autoSetLocation(setDisplayerObject:DisplayObject):void
		{
			//判断所提示的位置是否在显示区域内,控制显示位置
			var mouseX:int = HBaseView.getInstance().mouseX;
			var mouseY:int = HBaseView.getInstance().mouseY;
			var mouseAndObjW:int = mouseX + setDisplayerObject.width;
			var mouseAndObjH:int = mouseY + setDisplayerObject.height;
			
			if(mouseAndObjW > HBaseView.getInstance().myWidth)
				setDisplayerObject.x = mouseX - (mouseAndObjW-HBaseView.getInstance().myWidth);//mouseX - setDisplayerObject.width - 10;
			else
				setDisplayerObject.x = mouseX + 20;
			
			if(mouseAndObjH > HBaseView.getInstance().myHeight)
				setDisplayerObject.y = mouseY - (mouseAndObjH-HBaseView.getInstance().myHeight);//mouseY - setDisplayerObject.height - 10;
			else
				setDisplayerObject.y = mouseY;
		}
		
/****************************************************************************************************************/
/*******************************************          ***********************************************************/
/******************************************  数据获取  ***********************************************************/
/*******************************************          ***********************************************************/
/****************************************************************************************************************/
		/**
		 * 判断时间是否在时间段内 
		 * @param startDate	: 时间段开始时间
		 * @param endDate	: 时间段结束时间
		 * @param judgeDate	: 需要判断的时间
		 * @return 			: 返回时间段标识(-1:在时间段开始前 0:在时间段之内 1:在时间段之外)
		 */		
		public static function judgeTimeStyle(startDate:Date, endDate:Date, judgeDate:Date):int
		{
			var endNumber:Number = endDate.time;
			var n:Number = (endNumber - startDate.time);
			var m:Number = (endNumber - judgeDate.time);
			if(m < 0) return 1;//判断是否在时间段后
			if(n < m) return -1//判断是否在时间段前
			return 0;
		}
		/**
		 * 获取一个从min到max的随机数 
		 * @param min	: 最小数
		 * @param max	: 最大值
		 * @return 
		 */		
		public static function randomNum(min:int, max:int):int 
		{ 
			return Math.floor(Math.random() * (max - min + 1)) + min; 
		}
		/**
		 * 获取数值的绝对值(类似Math.abs())
		 * @param num	: 需要转换的数值
		 */		
		public static function abs(num:Number):Number
		{
//			return (num > 0 ? num : -num);
			return (num ^ (num >> 31)) - (num >> 31);
		}
		/**
		 * 获取数值的上限值(向上取整)(类似Math.ceil())
		 * @param num	: 需要转换的数值
		 */		
		public static function ceil(num:Number):int
		{
			return ( num>int(num)?(int(num)+1):int(num) );
		}
		
		/**
		 * 获取最接近的倍数值 
		 * @param num			: 需要获取的数字
		 * @param timesValue	: 倍数值
		 */		
		public static function getMostCloseNum(num:Number, timesValue:int):int
		{
			return ( Math.round(num/timesValue)*timesValue );
		}
		
		/**
		 * 获取对象两点之间的距离 
		 * @param point1	: 对象1
		 * @param point2	: 对象2
		 */		
		public static function getTwoPointsRange(point1:Point, point2:Point):Number
		{
//			var dx:Number = point1.x - point2.x; 
//			var dy:Number = point1.y - point2.y; 
//			return ( Math.sqrt(dx*dx + dy*dy) );
			return Point.distance(point1, point2);
		}
		
		/**
		 * 获取精灵是否在指定点的范围内
		 * @param wizard	: 精灵对象
		 * @param $rX		: 圆心点X
		 * @param $rY		: 圆心点Y
		 * @param $scope	: 范围值
		 */		
		public static function getWizardPointRange(wizard:WizardObject, $rX:Number, $rY:Number, $scope:Number = 10):Boolean
		{
			var dx:Number = wizard.x - $rX; 
			var dy:Number = wizard.z - $rY; 
			var num:Number = dx * dx + dy * dy;
			
//			var num:Number = ( Math.sqrt(Math.pow(wizard.myX - $rX, 2) + Math.pow(wizard.myY - $rY, 2)) );
			return (num > ($scope * $scope) ? false : true); 
		}
		
		/**
		 * 获取圆周运动某角度X,Y点
		 * @param rX		: 圆心点x
		 * @param rY		: 圆心点y
		 * @param r			: 圆半径
		 * @param angle		: 需要获取的角度
		 */		
		public static function getRoundPoint(rX:Number, rY:Number, r:int, angle:Number):Point
		{
			var point:Point = new Point();
			point.x = rX + (Math.cos(angle) * r); 
			point.y = rY + (Math.sin(angle) * r);
			return point;
		}
		
		/**
		 * 获取椭圆运动某角度X,Y点 
		 * @param rX		: 圆心点x
		 * @param rY		: 圆心点y
		 * @param a			: 长轴
		 * @param b			: 短轴
		 * @param angle		: 需要获取的角度
		 */		
		public static function getEllipsePoint(rX:Number, rY:Number, a:int, b:int, angle:Number):Point
		{
			var point:Point = new Point();
			point.x = rX + (Math.cos(angle) * a); 
			point.y = rY + (Math.sin(angle) * b);
			return point;
		}
		
		/**
		 * 获取随机颜色值
		 * @param color	: 颜色范围
		 */		
		public static function getRandomColor(color:uint = 0xFFFFFF):uint
		{
			return ( Math.random() *  color );
		}
		
		/**
		 * 通过角度获得弧度
		 * @param value	: 角度值
		 * @return 
		 */		
		public static function getRadiansByAndle(value:uint):Number
		{
			return value / 180 * Math.PI;
		}
		/**
		 * 通过弧度获得角度
		 * @param value	: 弧度值
		 * @return 
		 */		
		public static function getAndleByRadians(value:uint):Number
		{
			return value / Math.PI * 180;
		}
		
/****************************************************************************************************************/
/*******************************************          ***********************************************************/
/******************************************  数据转换  ***********************************************************/
/*******************************************          ***********************************************************/
/****************************************************************************************************************/
		/**
		 * 把字符转成HTML格式
		 * @param string	: 需要改变的字符串
		 * @return 			: 转换后的字符串
		 */		
		public static function changeHtmlColor(string:String):String
		{
			if(string=="") return "";
			return string.replace(new RegExp("\{#(.+?)\}(.+?)\{/\}","ig"), "<font color='$1'>$2</font>");
		}
		
		/**
		 * 将数字转换成文字 
		 * @param num	: 需要转换的数字
		 */			
		public static function changeNumber(num:int):String
		{
			var str:String = "";
			switch(num)
			{
				case 1:		str = "一";	break;
				case 2:		str = "二";	break;
				case 3:		str = "三";	break;
				case 4:		str = "四";	break;
				case 5:		str = "五";	break;
				case 6:		str = "六";	break;
				case 7:		str = "七";	break;
				case 8:		str = "八";	break;
				case 9:		str = "九";	break;
				case 10:	str = "十";	break;
				default :	str = "零";	break;
			}
			return str;
		}
		
		/**
		 * 转换数字,小于10的显示前面+0
		 * @param num	: 数字
		 */		
		public static function convertNum(num:int):String
		{
			return ( num < 10 ? "0"+num : String(num) );
		}
		
		/**
		 * 把数字转换成带有逗号分隔的字符
		 * @param num	: 数字
		 * return		: 返回带逗号字符,如(传入10000000,返回10,000,000)
		 */		
		public static function getWithPunctuationNum(num:Number):String
		{
			var arr:Array = String(num).split(".");
			var a1:String = arr[0];
			var a2:String = arr.length>1?"."+arr[1]:'';
			var rgx:RegExp = new RegExp(/(\d+)(\d{3})/);
			while( rgx.test(a1) ) 
			{
				a1 = a1.replace(rgx, '$1'+','+'$2');
			}
			return (a1+a2);
		}
		/**
		 * 获取数值的格式 
		 * @param num	: 需要转换的数字
		 */		
		public static function getNumberFormat(num:Number):String
		{
			var str:String =  String(num);
			var len:int = str.length;
			if(len < 5)	return str;
			if(len < 9)	
			{
				var value:Number = Math.floor(num/10000)
				return value+"万";
			}
			if(len > 8)	
			{
				value = Math.floor(num/100000000)
				return value+"亿";
			}
			return str;
		}
		/**
		 * 设置文本样式 
		 * @param textield	: 需要设置的文本
		 * @param textSize	: 文本大小
		 * @param textColor	: 文本颜色
		 * @param textBold	: 是否加粗
		 * @param textAlign	: 文本对齐样式
		 * @param textFont	: 文本字体
		 */		
		public static function setTextFormat(textField:TextField, textSize:uint=12, textColor:uint=0xFFFFFF, textBold:Boolean=false,
											 textAlign:String="left", textFont:String = "Arial"):void
		{
			var textFormat:TextFormat = new TextFormat();
			textFormat.size = textSize;
			textFormat.color = textColor;
			textFormat.bold = textBold;
			textFormat.align = textAlign;
			textFormat.font = textFont;
			textField.defaultTextFormat = textFormat;
		}
		/**
		 * 获取n位数小数
		 * @param num	: 需要获取的小数
		 * @param n		: 小数位
		 */		
		public static function toFixed(num:Number, n:int = 2):Number
		{
			if(n > 4) return 0;
			var str:String = "0.";
			var i:int = n;
			while( i-- > 1 )
			{
				str += "0";
			}
			str += "1";
			var ratio:Number = Number(str);
			return ( Math.round(num/ratio)*ratio );
		}
		
		/**
		 * 把秒数转为相关时间字符输出
		 * @param num	: 秒数
		 * @param type	: 类型(h小时m分s秒,需要显示多少小时子母用对应的子母,后面跟的中文需要什么样的自己添加,
		 * 					字符固定为 h:小时,m:分钟,s:秒 )
		 */		
		public static function convertTimeToStr(num:int, type:String):String
		{
			if(num <= 0) return '0秒';
			var hour:uint = num/3600;
			var minute:uint = num%3600/60;
			var second:uint = num%3600%60;
			type = type.replace('h',hour<10?'0'+hour:hour)
				.replace('m',minute<10?'0'+minute:minute)
				.replace('s',second<10?'0'+second:second);
			return type.replace('h', hour).replace('m', minute).replace('s', second);
		}
		
		
		/**
		 * 把秒数转为相关时间字符输出
		 * @param num	: 秒数
		 * @param type	: 类型(h小时m分s秒,需要显示多少小时子母用对应的子母,后面跟的中文需要什么样的自己添加,
		 * 					字符固定为 ,m:分钟,s:秒 )
		 */		
		public static function convertTimeToMinStr(num:int, type:String):String
		{
			if(num <= 0) return '0秒';
			var minute:uint = num%3600/60;
			var second:uint = num%3600%60;
			type = type.replace('m',minute<10?'0'+minute:minute)
				.replace('s',second<10?'0'+second:second);
			return type.replace('m', minute).replace('s', second);
		}
		
		/**
		 * 把秒数转换成时间格式(年月日去的是服务器的时间)
		 * @param num		: 需要转换的数字
		 * @param timerType	: 需要转换的时间格式
		 * 					  默认(yy:mm:dd h:m:s => 年:月:日 时:分:秒, 日期与时间需要用空格隔开,格式可自行组合,可用中文替代-,但对应的字母不能改)
		 * @return 			: 转换后返回的时间字符串
		 */		
		public static function conversionTime(num:uint, timerType:String = "yy-mm-dd h:m:s"):String
		{
			if(num <= 0) return timerType.replace("yy", "00").replace("mm", "00").replace("dd", "00")
				.replace("h", "00").replace("m", "00").replace("s", "00");
			
			var date:Date = HSysClock.getInstance().getSysDate();
			var year:uint = date.fullYear;
			var month:uint = date.month+1;
			var day:uint = date.date;
			var hour:uint = date.hours;//num/3600;
			var minute:uint = date.minutes;//num%3600/60;
			var second:uint = date.seconds; //num%3600%60;
			timerType = timerType.replace("yy", year)
				.replace("mm",month<10?'0'+month:month)
				.replace("dd",day<10?'0'+day:day)
				.replace('h',hour<10?'0'+hour:hour)
				.replace('m',minute<10?'0'+minute:minute)
				.replace('s',second<10?'0'+second:second);
			date = null;
			return timerType;
		}
		
		/**
		 * 把秒数转换成时间格式
		 * @param num		: 需要转换的数字
		 * @param timerType	: 需要转换的时间格式
		 * 					  默认(yy:mm:dd h:m:s => 年:月:日 时:分:秒, 日期与时间需要用空格隔开,格式可自行组合,可用中文替代-,但对应的字母不能改)
		 * @return 			: 转换后返回的时间字符串
		 */		
		public static function secondToYear(num:uint, timerType:String = "yy-mm-dd h:m:s"):String
		{
			if(num <= 0) return timerType.replace("yy", "00").replace("mm", "00").replace("dd", "00")
				.replace("h", "00").replace("m", "00").replace("s", "00");
			
			var date:Date = new Date(num * 1000);
			var year:uint = date.fullYear;
			var month:uint = date.month+1;
			var day:uint = date.date;
			var hour:uint =date.hours;
			var minute:uint = date.minutes;
			var second:uint =  date.seconds;
			timerType = timerType.replace("yy", year)
				.replace("mm",month<10?'0'+month:month)
				.replace("dd",day<10?'0'+day:day)
				.replace('h',hour<10?'0'+hour:hour)
				.replace('m',minute<10?'0'+minute:minute)
				.replace('s',second<10?'0'+second:second);
			date = null;
			return timerType;
		}
		
		/**
		 * 把秒数转换成天数、小时、分钟
		 * @param num		: 需要转换的数字
		 * @param timerType	: 需要转换的时间格式
		 * 					  默认(yy:mm:dd h:m:s => 年:月:日 时:分:秒, 日期与时间需要用空格隔开,格式可自行组合,可用中文替代-,但对应的字母不能改)
		 * @return 			: 转换后返回的时间字符串
		 */		
		public static function secondToDay(num:uint, timerType:String = "dd天h时m分"):String
		{
			if(num <= 0) return timerType.replace("dd", "00").replace("h", "00").replace("m", "00");
			
			var day:uint = num/(3600*24);
			var hour:uint = num%(3600*24)/3600;
			var minute:uint = num%(3600*24)%3600/60;
			timerType = timerType
				.replace("dd",day<10?'0'+day:day)
				.replace('h',hour<10?'0'+hour:hour)
				.replace('m',minute<10?'0'+minute:minute);
			return timerType;
		}
		/**
		 * 把秒数转换成最简洁的显示格式，
		 * @param num　需要转换的秒数
		 * @return 　有天的返回天数，有小时的反回小时数，
		 */		
		public static function convertTimeToConciseStr(num:uint):String
		{
			if(num <= 0) return '';
			var day:uint = num/(3600*24);
			if(day > 0)
				return day + "天";
			var hour:uint = num%(3600*24)/3600;
			if(hour > 0)
				return hour + "小时"
			var minute:uint = num%(3600*24)%3600/60;
			if(minute > 0)
				return minute + "分钟";
			return num + '秒'
		}
		
		/**
		 * 两数字交换
		 * @param a	: 数字A
		 * @param b	: 数字B
		 */		
		public static function exchangeNum(a:Number, b:Number):void
		{
			a ^= b;
			b ^= a;
			a ^= b;
		}
		/**
		 * 根据type数值截取order指定段返回(如未知数组下标数值获取对应的截取长度值可用此方法)
		 * @param type		: 位置数值
		 * @param order		: 需要截取的order
		 * @return 			: 截取后的数值(如果无对应类型数值则返回null)
		 */		
		public static function getOrderValue(type:*, order:Order):*
		{
			if(type is int)	
			{
				return order.readInt();
			}
			if(type is Number)
			{
				return order.readDouble();
			}
			if(type is String)
			{
				return order.readUTF();
			}
			if(type is uint)
			{
				return order.readInt();
			}
			if(type is Boolean)	
			{
				return order.readByte();
			}
			return null;
		}
		/**
		 * 根据类型字符截取对应的类型返回
		 * @param type		: 类型字符("int", "String", "Number", "String", "uint", "Boolean")
		 * @param order		: 需要截取的order
		 * @return 			: 截取后的数值(如果无对应类型数值则返回null)
		 */		
		public static function getOrderValueByType(type:String, order:Order):*
		{
			switch(type)
			{
				case "int":		return order.readInt();		break;
				case "Number":		return order.readDouble();	break;
				case "String":		return order.readUTF();		break;
				case "uint":		return order.readInt();		break;
				case "Boolean":	return order.readByte();	break;
			}
			return null;
		}
		
/****************************************************************************************************************/
/*******************************************          ***********************************************************/
/******************************************  数据处理  ***********************************************************/
/*******************************************          ***********************************************************/
/****************************************************************************************************************/
		/**
		 * 去除数组重复数据 
		 * @param targetArr 要去除重复的数据源数组
		 * @return 
		 */		
		public static function removedDuplicates(targetArr:Array):Array 
		{
			var keys:Object = {};
			return targetArr.filter(callback);
			function callback(item:Object, idx:uint, arr:Array):Boolean
			{
				if (keys.hasOwnProperty(item))
				{
					return false;   
				}
				else 
				{
					keys[item] = item;
					return true;
				}
			}
		}
		/**
		 * 根据限制进行过滤
		 * @param data 		: 数据源
		 * @param restrict	: 限制的条件数组
		 * @return 
		 */
		public static function filterByRestrict(data:Array,restrict:Array=null):Array
		{
			return data.filter(
				function(item:Object, idx:uint, arr:Array):Boolean
				{
					for each(var obj:* in restrict)
					{
						if(item[0] == obj)
						{
							return true;
						}
					}
					return false;
				});
		}
		/**
		 * 深度克隆对象 
		 * @param obj	: 需要克隆的对象
		 * @return 		: 克隆完成的对象
		 */		
		public static function cloneObject(source:Object):*
		{
			var myBA:ByteArray = new ByteArray(); 
			myBA.writeObject(source); 
			myBA.position = 0; 
			
			var obj:Object = myBA.readObject();
			//把对象中回调引用方法赋值到复制出来的对象中,否则如果对象中有回调方法则会报错
			for(var key:* in source)
			{
				if(source[key] is Function) 
				{
					obj[key] = source[key];
				}
			}
			return obj;
		}
		/**
		 * 复制bitmapdata 
		 * @param bitmapdata	: 需要赋值的bitmapdata
		 */		
		public static function cloneBitmapdata(bitmapdata:BitmapData):BitmapData
		{
			if(!bitmapdata) return null;
			return bitmapdata.clone();
		}
		
		/**
		 * 获取空格距离
		 * @param property	: 数值
		 * @return 			: 空格距离
		 */		
		public static  function getSpace(property:int):String
		{
			var str:String = "";
			if(property >= 10000)		str = "   ";
			else if(property >= 1000)	str = "    ";
			else if(property >= 100)	str = "     ";
			else if(property >= 10)		str = "      ";
			else						str = "       "; 
			return str ;
		}
		/**
		 * 根据宽高获取一个两边边长都是2幂的矩形
		 * @param width		原始宽度
		 * @param height	原始高度
		 */				
		public static function getPowerOf2Rect(width:int, height:int):Rectangle
		{
			
			width = getSize(width);
			height = getSize(height);
			return new Rectangle(0, 0, width, height);
		}
		
		public static function getSize(value:int):int
		{
			var len:int = _sizes.length;
			for (var i:int = 0; i < len; i++) 
			{
				if(value == _sizes[i]){
					return value;
				}
				if(value > _sizes[i] && value < _sizes[i+1]){
					return _sizes[i+1];
				}
			}
			return value;
		}
		private static var _sizes:Array = [2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192];
		private static var _colorMatrixFilter:starling.filters.ColorMatrixFilter;
		private static var _glowFilter:Array;
		/**
		 * 检测是否是邮箱地址
		 * 
		 * @param text
		 * @return 
		 * 
		 */
		public static function isEmail(text:String):Boolean
		{
			return (/^[\D]([\w-]+)?@[\w-]+\.[\w-]+(\.[\w-]{2,4})?$/).test(text);
		}
		/** 字符过滤判断 **/
		public static function stringStrict(str:String):String
		{ 
			var resStr:String = '';
			var len:int = str.length;
			var arr:Array = ["'", '"', '　', " ", ",", ":", "|", "~", "!", "@", "#", "$", "%", "^", "&", "*", "=", ";", "?", "\\", "//", "/", "\/", "/\/", "."];
			for (var i:int = 0; i < len; i++)
			{ 
				//判断是否为中文字符/英文子母
//				((str.charCodeAt(i)>=0x4E00&&str.charCodeAt(i)<=0x9FA5)||((str.charCodeAt(i)>=97&&str.charCodeAt(i)<=122)))?ret=true:ret=false; 
				//屏蔽名字中有双引号或单引号的问题
				if(arr.indexOf(str.charAt(i)) > -1)
				{
					resStr += str.charAt(i)
				}
			} 
			return resStr;
		}
		/**
		 * 获取当前帧是否还有空余时间
		 * @param lastFrameTime	: 刚开始执行此方法时所getTimer()的值
		 * @return				: true 有空余时间 false无空余时间,继续执行内容有可能出现15秒错误
		 * 
		 * 用法：
		 * 		
		 * No1:
		 * 		var lastFrameTime:Number = getTimer();
		 * 		while(Tool.hasTime(lastFrameTime))
		 * 		{
		 * 			//有时间做的循环处理
		 * 		}
		 * No2:
		 * 		var lastFrameTime:Number = getTimer();
		 * 		if(Tool.hasTime(lastFrameTime))
		 * 		{
		 * 			//有时间做的循环处理
		 * 		}
		 */		
		public static function hasTime(lastFrameTime:Number, time:int = 100):Boolean
		{
			return ((getTimer() - lastFrameTime) < time);
		}
		
		/**
		 * 获得VIP卡对应的index
		 * @param playerVipCard	: vip卡标记
		 * @param vip			: vip等级
		 * @return 				: (0:无VIP, 1:普通VIP 2:黄金VIP 3:白金VIP 4:钻石VIP)
		 */		
		public static function getVipCardIndexByVipCard(playerVipCard:int, vip:int):int
		{
			//解析VIP数据
			var vipStr:String = playerVipCard.toString(2);
			var len:int = 3 - vipStr.length;
			var s:String = "";
			while(len--)
				s += "0";
			vipStr = s + vipStr;
			var index:int = vipStr.indexOf("1");
			if(index > -1)
				index = 4 - index;
			else
			{
				//判断VIP等级是否>0,>0显示普通VIP
				if(vip > 0)	index = 1;
				else							index = 0;
			}
			
			return index;
		}
		
		/**
		 * 获得VIP卡对应的index
		 * @param value	: wizardObject
		 * @return 		: (0:无VIP, 1:普通VIP 2:黄金VIP 3:白金VIP 4:钻石VIP)
		 */		
		public static function getVipCardIndex(wizardObject:WizardObject):int
		{
			//解析VIP数据
			var vipStr:String = wizardObject.Player_VipCard.toString(2);
			var len:int = 3 - vipStr.length;
			var s:String = "";
			while(len--)
			{
				s += "0";
			}
			vipStr = s + vipStr;
			var index:int = vipStr.indexOf("1");
			if(index > -1)
			{
				index = 4 - index;
			}
			else
			{
				//判断VIP等级是否>0,>0显示普通VIP
				if(wizardObject.Player_Vip > 0)	
				{
					index = 1;
				}
				else						
				{
					index = 0;
				}
			}
			
			return index;
		}
		
		//-------------------------------------------------------------------------------------------------
		/**
		 * 获得距离目标指定距离点(与出发点相同方向点)
		 * @param sPoint	: 出发点a
		 * @param tPoint	: 目标点b
		 * @param dis		: 指定距离
		 * @return 			: 指定距离点
		 */		
		public static function getDistanceTargetPoint(sPoint:Point, tPoint:Point, dis:int):Point
		{
			//c:总距离 a:出发点 b:目标点 p:指定距离点 a1:a到p距离 b1:b到p距离
			//公式: p = a*(b1/c) + b*(a1/c);
			var tmpPos:Point = tPoint.subtract(sPoint);
			tmpPos.normalize(dis);
			return tmpPos;
		}
		
		/**
		 * 获得距离目标指定距离行走路径数组
		 * @param sPoint	: 出发点
		 * @param tPoint	: 目标点
		 * @param dis		: 指定距离
		 * @return 			: 二维数组,[0]:发给服务端数组 [1]:客户端寻路数组
		 */		
		public static function getDistanceTargetArr(sPoint:Point, tPoint:Point, dis:int):Array
		{
			var pathArgs:Array;
			
			var node:Node = HMap3D.getInstance().mapData.getNodeByPoint(tPoint);
			if(!node.walkable) 
			{
				HSuspendTips.ShowTips("获取攻击路径错误,当前点击精灵所摆放的位置在不可行走区域中,请调整地图配置");
				return null;
			}
			pathArgs = HMap3D.getInstance().getCompletePath( sPoint, tPoint );
			if(!pathArgs)
			{
				return pathArgs;
			}
			//筛选攻击范围路径
			var p:Point = new Point();
			var maxPoint:Point = new Point();	//最远攻击距离点
			var n:Node;
			var nowRange:int = 0;
			var maxRange:int = -1;
			var flag:Boolean = false;
			var len:int = pathArgs.length;
			for(var i:int = len - 1; i > 0; i--)
			{
				n = pathArgs[i];
				p.x = n.pointX;
				p.y = n.pointY;
				nowRange = Tool.getTwoPointsRange(sPoint, p);
				if( nowRange <= dis )
				{
//					flag = true;
//					break;
					flag = true;
					//获得最远攻击路经点
					if(maxRange < nowRange)
					{
						maxRange = nowRange;
						maxPoint.x = p.x;
						maxPoint.y = p.y;
					}
				}
			}
			if(flag)
			{
				pathArgs = HMap3D.getInstance().getServerPathArgs( maxPoint );//p );
			}
			else
			{
				var serverPathArgs:Array = [HMapSources.getInstance().mainWizardObject.Entity_UID, false];
				len = pathArgs.length;
				for(i = 0; i < len; i++)
				{
					serverPathArgs.push(pathArgs[i].pointX);
					serverPathArgs.push(pathArgs[i].pointY);
				}
				
				return [ serverPathArgs, pathArgs];
			}
			
			return pathArgs;
			
			/*var targetPoint:Point = getDistanceTargetPoint(sPoint, tPoint, dis);
			var pathArgs:Array;
			//获取一下目标点是否为不可行走区域,如果是不可行走区域寻找可行走的点
			var node:Node = HMap3D.getInstance().mapData.getNodeByPoint(targetPoint);
			if(!node.walkable)
			{
				//获得指定目标点的路径
				targetPoint.x = tPoint.x;
				targetPoint.y = tPoint.y;
				node = HMap3D.getInstance().mapData.getNodeByPoint(targetPoint);
				if(!node.walkable) 
				{
					throw new Error("获取攻击路径错误,当前点击精灵所摆放的位置在不可行走区域中,请调整地图配置");
					return null;
				}
				
				pathArgs = HMap3D.getInstance().getServerPathArgs( targetPoint );
				//筛选攻击范围路径
				var p:Point = new Point();
				var n:Node;
				var flag:Boolean = false;
				var len:int = pathArgs[1].length;
				for(var i:int = len-1; i > 0; i--)
				{
					n = pathArgs[1][i];
					p.x = n.pointX;
					p.y = n.pointY;
					if( Tool.getTwoPointsRange(sPoint, p) <= dis )
					{
						flag = true;
						break;
					}
				}
				if(flag)
					pathArgs = HMap3D.getInstance().getServerPathArgs( p );
			}
			else
			{
				//走到范围点
				pathArgs = HMap3D.getInstance().getServerPathArgs( targetPoint );
			}
			return pathArgs;*/
		}
		
		/**
		 * 把图片转换成2次幂位图
		 * @param $btmd			: 需要转换的位图
		 * @param $drawBtmd		: 绘制的位图,如果为null,则自动使用需要绘制图片的2次幂宽高位图做绘制渲染处理
		 * @param $algin		: 对齐方式下面参数(int)↓
		 * </br>1:↖ 2:↑ 3:↗ 
		 * </br>4:← 5:口 6:→ 
		 * </br>7:↙ 8:↓ 9:↘
		 * @param $offsetX		: 绘制偏移X坐标
		 * @param $offsetY		: 绘制偏移Y坐标
		 * @return 
		 */		
		public static function drawAlginBtmd($btmd:BitmapData, $drawBtmd:BitmapData = null, $algin:int = 1, $offsetX:int = 0, $offsetY:int = 0):BitmapData
		{
			$drawBtmd ||= new BitmapData(Tool.getSize($btmd.width), Tool.getSize($btmd.height), true, 0);
			var matrix:Matrix;
			switch($algin)
			{
				case 1:		//左上
					matrix = new Matrix(1, 0, 0, 1, $offsetX, $offsetY );
					break;
				case 2:		//中上
					matrix = new Matrix(1, 0, 0, 1, (($drawBtmd.width - $btmd.width) >> 1) + $offsetX, $offsetY );
					break;
				case 3:		//右上
					matrix = new Matrix(1, 0, 0, 1, $drawBtmd.width - $btmd.width + $offsetX, $offsetY );
					break;
				case 4:		//左中
					matrix = new Matrix(1, 0, 0, 1, $offsetX, (($drawBtmd.height - $btmd.height) >> 1) + $offsetY );
					break;
				case 5:		//正中
					matrix = new Matrix(1, 0, 0, 1, (($drawBtmd.width - $btmd.width) >> 1) + $offsetX, (($drawBtmd.height - $btmd.height) >> 1) + $offsetY );
					break;
				case 6:		//右中
					matrix = new Matrix(1, 0, 0, 1, $drawBtmd.width - $btmd.width + $offsetX, (($drawBtmd.height - $btmd.height) >> 1) + $offsetY );
					break;
				case 7:		//左下
					matrix = new Matrix(1, 0, 0, 1, $offsetX, $drawBtmd.height - $btmd.height + $offsetY );
					break;
				case 8:		//中下
					matrix = new Matrix(1, 0, 0, 1, (($drawBtmd.width - $btmd.width) >> 1), $drawBtmd.height - $btmd.height + $offsetY );
					break;
				case 9:		//右下
					matrix = new Matrix(1, 0, 0, 1, $drawBtmd.width - $btmd.width + $offsetX, $drawBtmd.height - $btmd.height + $offsetY );
					break;
			}
			$drawBtmd.draw($btmd, matrix);
			return $drawBtmd;
		}
		
		/**
		 * 用于数据交互，只要与被交换的数据有相同命名的变量，被交换对象的数据都会传过去给交互的
		 * 
		 */
		public static function dataExchange(beExcObj:Object,excObj:Object):void
		{
			for(var name:String in beExcObj)
			{
				excObj[name] = beExcObj[name];
			}
		}
		
		/** away3d坐标 转 屏幕2D坐标: **/
		public static function get2DPoint(view:View3D, vec:Vector3D):Point
		{
			var markPosition:Vector3D = view .project(vec);
			var screenPosition:Point = new Point(markPosition.x, markPosition.y);
			return screenPosition;
		}
		
		/** 2D坐标转3D坐标 **/
		public static function getScreenTo3DPosition(view:View3D, point:Point, screenZ:int = 2500):Vector3D
		{
			var vec:Vector3D = view.unproject(point.x, point.y, screenZ);
			return vec;
		}
		
		/**
		 * 获得3D对象在2D中的坐标
		 * @param view
		 * @param obj
		 * @return 
		 */		
		public static function getStagePosition(view:View3D,obj:ObjectContainer3D):Vector3D 
		{
			var camT:Matrix3D = view.camera.viewProjection.clone();
			var planT:Matrix3D = obj.sceneTransform.clone();
			camT.prepend(planT);
			
			var pv:Vector3D = Utils3D.projectVector(camT, new Vector3D());
			pv.x = (pv.x * view.width / 2) + view.width / 2;
			pv.y = (pv.y * -1*view.height / 2) + view.height / 2;
			pv.z = 0;
			return pv;
		}
	}
}