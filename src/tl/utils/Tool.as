package tl.utils
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

	import fl.controls.Button;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	import tl.mapeditor.ui.common.MyButton;
	import tl.mapeditor.ui.common.MyTextButton;
	import tl.mapeditor.ui.common.MyTextField;

	public class Tool
	{
		/**  灰色滤镜  **/		
		private static const grayFilter:ColorMatrixFilter = new ColorMatrixFilter([
																						0.3086,   0.6094,   0.082,    0,
																						0,        0.3086,   0.6094,   0.082,
																						0,        0,        0.3086,   0.6094,
																						0.082,    0,        0,        0,
																						0,        0,        1,        0
																					]);
/****************************************************************************************************************/
/*******************************************          ***********************************************************/
/******************************************  对象获取  ***********************************************************/
/*******************************************          ***********************************************************/
/****************************************************************************************************************/	
		/**
		 * 获取HTextField 
		 * @param $width	: 文本宽度
		 * @param $height	: 文本高度
		 * @param size		: 字体大小
		 * @param color		: 字体颜色
		 * @param algin		: 字体对齐方式
		 * @param leading	: 字体间距
		 * @param bold		: 是否加粗
		 * @param font		: 文本字体
		 * @return 			: HTextField
		 */		
		public static function getMyTextField($width:int = 100, $height:int = -1, size:int = 12, color:uint = 0xFFFFFF
											 , algin:String = "left", leading:int = 0, bold:Boolean = false, font:String = ""):MyTextField
		{
			var textField:MyTextField = new MyTextField();
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
		
		/** 获取一个按钮 **/
		public static function getBtn($width:int = 45, $height:int = 24):Button
		{
			var btn:Button = new Button();
			btn.setSize($width, $height);
			return btn;
		}
		/** 获取标题文本 **/
		public static function getTitleText(txt:String):MyTextField
		{
			var textField:MyTextField = new MyTextField();
			textField.size = 12;
			textField.color = 0x999999;
			textField.text = txt;
			textField.width = textField.textWidth + 4;
			textField.height = textField.textHeight + 4;
			textField.mouseEnabled = false;
			return textField;
		}
		/** 获取一个输入文本 **/
		public static function getInputText($width:int = 60, $height:int = 18):MyTextField
		{
			var inputText:MyTextField = new MyTextField();
			inputText.size = 12;
			inputText.border = true;
			inputText.background = true;
			inputText.backgroundColor = 0x191818;
			inputText.border = true;
			inputText.borderColor = 0x3D3D3D;
			inputText.color = 0xFDFDFD;
			inputText.width = $width;
			inputText.height = $height;
			return inputText;
		}
		/** 获得一个文本按钮 **/
		public static function getTextButton($width:int = 14, $height:int = 14):MyTextButton
		{
			var selectBtn:MyTextButton = new MyTextButton();
			selectBtn.size = 12;
			selectBtn.color = 0xFDFDFD;
			selectBtn.width = $width;
			selectBtn.height = $height;
			selectBtn.background = true;
			selectBtn.backgroundColor = 0x191818;
			selectBtn.bold = true;
			selectBtn.border = true;
			selectBtn.selectable = false;
			
			return selectBtn;
		}
		/**
		 * 获取一个自定义皮肤按钮
		 * @param str
		 * @param upBtmd
		 * @param overBtmd
		 * @param downBtmd
		 * @param disabledBtmd
		 * @param selectBtmd
		 * @return 
		 * 
		 */		
		public static function getMyBtn(str:String, $width:int = 60, $height:int = 22, 
			upBtmd:BitmapData = null, overBtmd:BitmapData = null, downBtmd:BitmapData = null, disabledBtmd:BitmapData = null, selectBtmd:BitmapData = null):MyButton
		{
			var btn:MyButton = new MyButton();
			if(!upBtmd && !overBtmd && !downBtmd && !disabledBtmd && !selectBtmd)	
				btn.setDefaultSkin();
			else	
				btn.setSkin(upBtmd, overBtmd, downBtmd, disabledBtmd, selectBtmd);
			btn.isTextBold = false;
			btn.init(str, $width, $height);
			return btn;
		}
		
		
/****************************************************************************************************************/
/*******************************************          ***********************************************************/
/******************************************  对象绘制  ***********************************************************/
/*******************************************          ***********************************************************/
/****************************************************************************************************************/	
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
				width = bitmapdata.width;
				height = bitmapdata.height;
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
		 */		
		public static function drawSectorByGraphics(graphics:Graphics, bitmapdata:BitmapData = null, x:Number = 200, y:Number = 200, r:Number = 100, angle:Number = 27,color:Number = 0x0
													,alp:Number = 1, startFrom:Number = 270, lineSize:int = 1, lineColor:uint = 0x0, lineAlpha:Number = 1, isClear:Boolean = true):void 
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
				startFrom += angleA;
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
		public static function groupBitmap(bitmapDataArr:Array):BitmapData
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
		 * 灰化可视对象 
		 * @param displayObj	: 需要灰化的可视对象
		 */		
		public static function grayDisplayObject(displayObj:DisplayObject):void
		{
			displayObj.filters = [grayFilter];
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
			displayObj.filters = [new GlowFilter(color, alpha, blurX,blerY, strength, quality, inner, knockout)];
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
					if(callBack != null) callBack();
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
			return (num ^ (num >> 31)) - (num >> 31);
		}
		/**
		 * 获取数值的上限值(向上取整)(类似Math.ceil())
		 * @param value	: 需要转换的数值
		 */		
		public static function ceil(value:Number):int
		{
			return int( value+0.9 );
		}
		/**
		 * 四舍五入类似Math.round())
		 * @param value	: 需要转换的数值
		 */		
		public static function round(value:Number):int
		{
			return int(value+0.5);
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
			return ( Math.sqrt(Math.pow(point1.x - point2.x, 2) + Math.pow(point1.y - point2.y, 2)) );
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
			return ( Math.random()*color );
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
			if(len < 9)	return int(num/10000)+"万";
			if(len > 8)	return int(num/100000000)+"亿";
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
			return type.replace('h', hour).replace('m', minute).replace('s', second);
		}
		/**
		 * 把秒数转换成时间格式
		 * @param num		: 需要转换的数字
		 * @param timerType	: 需要转换的时间格式
		 * 					  默认(yy:mm:dd h:m:s => 年:月:日 时:分:秒, 日期与时间需要用空格隔开,格式可自行组合,可用中文替代-,但对应的字母不能改)
		 * @return 			: 转换后返回的时间字符串
		 */		
		public static function conversionTime(num:uint, timerType:String = "yy-mm-dd h:m:s"):String
		{
			if(num <= 0) return timerType.replace("yy", "00").replace("mm", "00").replace("dd", "00")
				.replace("h", "00").replace("m", "00").replace("s", "00");
			
			var date:Date = new Date();
			var year:uint = date.fullYear;
			var month:uint = date.month+1;
			var day:uint = date.date;
			var hour:uint = num/3600;
			var minute:uint = num%3600/60;
			var second:uint = num%3600%60;
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
			function callback(item:Object, idx:uint, arr:Array):Boolean{
				if (keys.hasOwnProperty(String(item))) {
					return false;   
					
				} else {
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
		/**
		 * 获得最接近的2次幂数字
		 * @param value
		 * @return 
		 */		
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
		public static function stringStrict(str:String):Boolean
		{ 
			var ret:Boolean = true; 
			var len:int = str.length;
			var arr:Array = ["'", '"', '　', " ", ",", ":", "|", "~", "!", "@", "#", "$", "%", "^", "&", "*", "=", ";", "?", "\\", "//", "/", "\/", "/\/", "."];
			for (var i:int = 0; i < len; i++)
			{ 
				//判断是否为中文字符/英文子母
				//				((str.charCodeAt(i)>=0x4E00&&str.charCodeAt(i)<=0x9FA5)||((str.charCodeAt(i)>=97&&str.charCodeAt(i)<=122)))?ret=true:ret=false; 
				//屏蔽名字中有双引号或单引号的问题
				if(arr.indexOf(str.charAt(i)) > -1)
				{
					ret = false;
					break;
				}
			} 
			return ret;
		}
		/**
		 * 获取当前帧是否还有空余时间
		 * @param lastFrameTime	: 刚开始执行此方法时所getTimer()的值
		 * @param num			: 判断时间(毫秒数)
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
		public static function hasTime(lastFrameTime:Number, num:int = 100):Boolean
		{
			return ((getTimer() - lastFrameTime) < num);
		}
		/**
		 * 获得距离目标指定距离点(与出发点相同方向点)
		 * @param sPoint	: 出发点
		 * @param tPoint	: 目标点
		 * @param dis		: 指定距离
		 * @return 			: 指定距离点
		 */		
		public static function getDistanceTargetPoint(sPoint:Point, tPoint:Point, dis:int):Point
		{
			var a:Number = sPoint.x - tPoint.x;
			var b:Number = sPoint.y - tPoint.y;
			var c:Number = Math.sqrt(a*a + b*b);
			//计算b1
			var b1:Number = b / c * dis;
			var a1:Number = a / c * dis;
			return new Point(tPoint.x + a1, tPoint.y + b1);
		}
	}
}