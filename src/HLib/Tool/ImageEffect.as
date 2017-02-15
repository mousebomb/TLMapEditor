package HLib.Tool
{	
	/**
	 * 位图处理类 
	 */	
	import flash.display.*;
	import flash.filters.*;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class ImageEffect {
		private static var sourceBitmap:Bitmap;
		private static var returnBitmapData:BitmapData;
		private static var tempMovieClip:MovieClip;
		public function ImageEffect() {
		}
		public static function invert(source:BitmapData) {
			sourceBitmap=new Bitmap(source);
			tempMovieClip=new MovieClip();
			tempMovieClip.addChild(sourceBitmap);
			var mytmpmc:Sprite=new Sprite();
			mytmpmc.graphics.lineStyle(0,0x000000, 100);
			mytmpmc.graphics.moveTo(0,0);
			mytmpmc.graphics.beginFill(0x000000);
			mytmpmc.graphics.lineTo(sourceBitmap.width, 0);
			mytmpmc.graphics.lineTo(sourceBitmap.width, sourceBitmap.height);
			mytmpmc.graphics.lineTo(0, sourceBitmap.height);
			mytmpmc.graphics.lineTo(0,0);
			mytmpmc.graphics.endFill();
			mytmpmc.blendMode = "invert";
			tempMovieClip.addChild(mytmpmc);
			returnBitmapData=new BitmapData(tempMovieClip.width,tempMovieClip.height,true, 0x00FFFFFF);
			returnBitmapData.draw(tempMovieClip);
			tempMovieClip.removeChild(mytmpmc);
			tempMovieClip.removeChild(sourceBitmap);
			mytmpmc=null;
			return returnBitmapData;
		/**
		 *灰色过滤 
		 */
		}
		public static function grayFilter(source:BitmapData) {
			sourceBitmap=new Bitmap(source);
			sourceBitmap.filters=[getGrayFilter()];
			returnBitmapData=new BitmapData(sourceBitmap.width,sourceBitmap.height,true, 0x00FFFFFF);
			returnBitmapData.draw(sourceBitmap);
			return returnBitmapData;
		}
		/**
		 *获得灰色滤波器
		 * @return 
		 * 
		 */
		public static function getGrayFilter() {
			var myElements_array:Array = [0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0];
			var myColorMatrix_filter:ColorMatrixFilter = new ColorMatrixFilter(myElements_array);
			return myColorMatrix_filter;
		}
		/**
		 *浮雕过滤 
		 * @param source
		 * @param angle
		 * @return 
		 * 
		 */
		public static function embossFilter(source:BitmapData,angle:uint=315) {
			//var angle=315;
			var radian=angle*Math.PI/180;
			var pi4=Math.PI/4;
			var clamp:Boolean = false;
			var clampColor:Number = 0xFF0000;
			var clampAlpha:Number = 256;
			var bias:Number = 128;
			var preserveAlpha:Boolean = false;
			var matrix:Array = [ Math.cos(radian+pi4)*256,Math.cos(radian+2*pi4)*256,Math.cos(radian+3*pi4)*256,
				Math.cos(radian)*256,0,Math.cos(radian+4*pi4)*256,
				Math.cos(radian-pi4)*256,Math.cos(radian-2*pi4)*256,Math.cos(radian-3*pi4)*256 ];
			var matrixCols:Number = 3;
			var matrixRows:Number = 3;
			var filter:ConvolutionFilter = new ConvolutionFilter(matrixCols, matrixRows, matrix, matrix.length, bias, preserveAlpha, clamp, clampColor, clampAlpha);
			var myFilters:Array = new Array();
			myFilters.push(filter);
			myFilters.push(getGrayFilter());
			sourceBitmap=new Bitmap(source);
			sourceBitmap.filters=myFilters;
			returnBitmapData=new BitmapData(sourceBitmap.width,sourceBitmap.height,true, 0x00FFFFFF);
			returnBitmapData.draw(sourceBitmap);
			return returnBitmapData;
		}
		public static function blurFilter(source:BitmapData,blurX:Number=5,blurY:Number=5) {
			var filter:BlurFilter=new BlurFilter(blurX, blurY, BitmapFilterQuality.HIGH);
			sourceBitmap=new Bitmap(source);
			sourceBitmap.filters=[filter];
			returnBitmapData=new BitmapData(sourceBitmap.width,sourceBitmap.height,true, 0x00FFFFFF);
			returnBitmapData.draw(sourceBitmap);
			return returnBitmapData;
		}
		/**
		 *锐化滤镜 
		 * @param source
		 * @param sharp
		 * @return 
		 * 
		 */
		public static function sharpenFilter(source:BitmapData,sharp:Number=0.7) {
			var matrix: Array = [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ];
			matrix[1] = matrix[3] = matrix[5] = matrix[7] = -sharp;
			matrix[4] = 1 + sharp * 4;
			var filter: ConvolutionFilter = new ConvolutionFilter( 3, 3, matrix );
			sourceBitmap=new Bitmap(source);
			sourceBitmap.filters=[filter];
			returnBitmapData=new BitmapData(sourceBitmap.width,sourceBitmap.height,true, 0x00FFFFFF);
			returnBitmapData.draw(sourceBitmap);
			return returnBitmapData;
		}
		/**
		 *提高过滤 
		 * @param source
		 * @param distance
		 * @param angleInDegrees
		 * @return 
		 * 
		 */
		public static function raiseFilter(source:BitmapData,distance=5,angleInDegrees=45) {
			//var distance:Number       = 5;
			//var angleInDegrees:Number = 45;
			var highlightColor:Number = 0xCCCCCC;
			var highlightAlpha:Number = 0.8;
			var shadowColor:Number    = 0x808080;
			var shadowAlpha:Number    = 0.8;
			var blurX:Number          = 5;
			var blurY:Number          = 5;
			var strength:Number       = 5;
			var quality:Number        = BitmapFilterQuality.HIGH;
			var type:String           = BitmapFilterType.INNER;
			var knockout:Boolean      = false;
			var filter: BevelFilter =new BevelFilter(distance,
				angleInDegrees,
				highlightColor,
				highlightAlpha,
				shadowColor,
				shadowAlpha,
				blurX,
				blurY,
				strength,
				quality,
				type,
				knockout);
			sourceBitmap=new Bitmap(source);
			sourceBitmap.filters=[filter];
			returnBitmapData=new BitmapData(sourceBitmap.width,sourceBitmap.height,true, 0x00FFFFFF);
			returnBitmapData.draw(sourceBitmap);
			return returnBitmapData;
		}
		/**
		 *旧画过滤 
		 * @param source
		 * @return 
		 * 
		 */
		public static function oldPictureFilter(source:BitmapData) {
			var filter=getGrayFilter();
			sourceBitmap=new Bitmap(source);
			sourceBitmap.filters=[filter];
			source=new BitmapData(sourceBitmap.width,sourceBitmap.height,true, 0x00FFFFFF);
			source.draw(sourceBitmap);
			var matrix:Array = new Array();
			matrix = matrix.concat([0.94, 0, 0, 0, 0]);
			matrix = matrix.concat([0, 0.9, 0, 0, 0]);
			matrix = matrix.concat([0, 0, 0.8, 0, 0]);
			matrix = matrix.concat([0, 0, 0, 0.8, 0]);
			filter= new ColorMatrixFilter(matrix);
			sourceBitmap=new Bitmap(source);
			sourceBitmap.filters=[filter];
			returnBitmapData=new BitmapData(sourceBitmap.width,sourceBitmap.height,true, 0x00FFFFFF);
			returnBitmapData.draw(sourceBitmap);
			return returnBitmapData;
		}
		/**
		 *噪声滤波器 
		 * @param source
		 * @param degree
		 * @return 
		 * 
		 */
		public static function noiseFilter(source:BitmapData,degree:Number=128) {
			//degree 0-255
			var noise,color,r,g,b;
			returnBitmapData=source.clone();
			for (var i=0; i<source.height; i++) {
				for (var j=0; j<source.width; j++) {
					noise=int(Math.random()*degree*2)-degree;
					color=source.getPixel(j, i);
					r = (color & 0xff0000) >> 16;
					g = (color & 0x00ff00) >> 8;
					b = color & 0x0000ff;
					r=r+noise<0?0:r+noise>255?255:r+noise;
					g=g+noise<0?0:g+noise>255?255:g+noise;
					b=b+noise<0?0:b+noise>255?255:b+noise;
					returnBitmapData.setPixel(j,i,r*65536+g*256+b);
				}
			}
			return returnBitmapData;
		}
		/**
		 *素描过滤 
		 * @param source
		 * @param threshold
		 * @return 
		 * 
		 */
		public static function sketchFilter(source:BitmapData,threshold:Number=30) {
			//threshold 0-100
			var filter=getGrayFilter();
			sourceBitmap=new Bitmap(source);
			sourceBitmap.filters=[filter];
			returnBitmapData=new BitmapData(sourceBitmap.width,sourceBitmap.height,true, 0x00FFFFFF);
			returnBitmapData.draw(sourceBitmap);
			var color,gray1,gray2;
			for (var i=0; i<source.height-1; i++) {
				for (var j=0; j<source.width-1; j++) {
					color=source.getPixel(j, i);
					gray1 = (color & 0xff0000) >> 16;
					color=source.getPixel(j+1, i+1);
					gray2 = (color & 0xff0000) >> 16;
					if (Math.abs(gray1-gray2)>=threshold) {
						returnBitmapData.setPixel(j,i,0x222222);
					} else {
						returnBitmapData.setPixel(j,i,0xFFFFFF);
					}
				}
			}
			for (i=0; i<source.height; i++) {
				returnBitmapData.setPixel(source.width-1,i,0xFFFFFF);
			}
			for (i=0; i<source.width; i++) {
				returnBitmapData.setPixel(i,source.height-1,0xFFFFFF);
			}
			return returnBitmapData;
		}
		/**
		 *水波处理 
		 * @param source
		 * @param scaleX
		 * @param scaleY
		 * @return 
		 * 
		 */
		public static function waterColorFilter(source:BitmapData,scaleX:Number=5,scaleY:Number=5) {
			var componentX:Number = 1;
			var componentY:Number = 1;
			var color:Number = 0x000000;
			var alpha:Number = 0x000000;
			var tempBitmap=new BitmapData(source.width,source.height,true,0x00FFFFFF);
			tempBitmap.perlinNoise(3, 3, 1, 1, false, true, 1, false);
			sourceBitmap=new Bitmap(source);
			var filter:DisplacementMapFilter = new DisplacementMapFilter(tempBitmap, new Point(0, 0),componentX, componentY, scaleX, scaleY, DisplacementMapFilterMode.COLOR, color, alpha);
			sourceBitmap.filters=[filter];
			returnBitmapData=new BitmapData(sourceBitmap.width,sourceBitmap.height,true, 0x00FFFFFF);
			returnBitmapData.draw(sourceBitmap);
			return returnBitmapData;
		}
		/**
		 *扩散滤波 
		 * @param source
		 * @param scaleX
		 * @param scaleY
		 * @return 
		 * 
		 */
		public static function diffuseFilter(source:BitmapData,scaleX:Number=5,scaleY:Number=5) {
			var componentX:Number = 1;
			var componentY:Number = 1;
			var color:Number = 0x000000;
			var alpha:Number = 0x000000;
			var tempBitmap=new BitmapData(source.width,source.height,true,0x00FFFFFF);
			tempBitmap.noise(888888);
			sourceBitmap=new Bitmap(source);
			var filter:DisplacementMapFilter = new DisplacementMapFilter(tempBitmap, new Point(0, 0),componentX, componentY, scaleX, scaleY, DisplacementMapFilterMode.COLOR, color, alpha);
			sourceBitmap.filters=[filter];
			returnBitmapData=new BitmapData(sourceBitmap.width,sourceBitmap.height,true, 0x00FFFFFF);
			returnBitmapData.draw(sourceBitmap);
			return returnBitmapData;
		}
		/**
		 *球面化过滤 
		 * @param source
		 * @return 
		 * 
		 */
		public static function spherizeFilter(source:BitmapData) {
			var midx=int(source.width/2);
			var midy=int(source.height/2);
			var maxmidxy=midx>midy?midx:midy;
			var radian,radius,offsetX,offsetY,color,r,g,b;
			returnBitmapData=source.clone();
			for (var i=0; i<source.height-1; i++) {
				for (var j=0; j<source.width-1; j++) {
					
					offsetX=j-midx;
					offsetY=i-midy;
					radian=Math.atan2(offsetY,offsetX);
					radius=(offsetX*offsetX+offsetY*offsetY)/maxmidxy;
					var x=int(radius*Math.cos(radian))+midx;
					var y=int(radius*Math.sin(radian))+midy;
					if (x<0) {
						x=0;
					}
					if (x>=source.width) {
						x=source.width-1;
					}
					if (y<0) {
						y=0;
					}
					if (y>=source.height) {
						y=source.height-1;
					}
					color=source.getPixel(x, y);
					r = (color & 0xff0000) >> 16;
					g = (color & 0x00ff00) >> 8;
					b = color & 0x0000ff;
					returnBitmapData.setPixel(j,i,r*65536+g*256+b);
					
				}
			}
			return returnBitmapData;
		}
		/**
		 *捏过滤 
		 * @param source
		 * @param degree
		 * @return 
		 * 
		 */
		public static function pinchFilter(source:BitmapData,degree:Number=16) {
			var midx=int(source.width/2);
			var midy=int(source.height/2);
			var radian,radius,offsetX,offsetY,color,r,g,b;
			returnBitmapData=source.clone();
			for (var i=0; i<source.height-1; i++) {
				for (var j=0; j<source.width-1; j++) {
					offsetX=j-midx;
					offsetY=i-midy;
					radian=Math.atan2(offsetY,offsetX);
					radius=Math.sqrt(offsetX*offsetX+offsetY*offsetY);
					radius=Math.sqrt(radius)*degree;
					var x=int(radius*Math.cos(radian))+midx;
					var y=int(radius*Math.sin(radian))+midy;
					if (x<0) {
						x=0;
					}
					if (x>=source.width) {
						x=source.width-1;
					}
					if (y<0) {
						y=0;
					}
					if (y>=source.height) {
						y=source.height-1;
					}
					color=source.getPixel(x, y);
					r = (color & 0xff0000) >> 16;
					g = (color & 0x00ff00) >> 8;
					b = color & 0x0000ff;
					returnBitmapData.setPixel(j,i,r*65536+g*256+b);
				}
			}
			return returnBitmapData;
		}
		/**
		 *照明过滤 
		 * @param source
		 * @param power
		 * @param posx
		 * @param posy
		 * @param r
		 * @return 
		 * 
		 */
		public static function lightingFilter(source:BitmapData,power:Number=128,posx:Number=0.5,posy:Number=0.5,r:Number=0) {
			//power 0-255
			var midx=int(source.width*posx);
			var midy=int(source.height*posy);
			if (r==0) {
				r=Math.sqrt(midx*midx+midy*midy);
			}
			if (r==0) {
				r=Math.sqrt(source.width*source.width/4+source.height*source.height/4);
			}
			var radius=int(r);
			var sr=r*r;
			returnBitmapData=source.clone();
			var sd,color,r,g,b,distance,brightness;
			for (var y=0; y<source.height; y++) {
				for (var x=0; x < source.width; x++) {
					sd=(x-midx)*(x-midx)+(y-midy)*(y-midy);
					if (sd<sr) {
						color=source.getPixel(x, y);
						r = (color & 0xff0000) >> 16;
						g = (color & 0x00ff00) >> 8;
						b = color & 0x0000ff;
						distance=Math.sqrt(sd);
						brightness=int(power*(radius-distance)/radius);
						r=r+brightness>255?255:r+brightness;
						g=g+brightness>255?255:g+brightness;
						b=b+brightness>255?255:b+brightness;
						returnBitmapData.setPixel(x,y,r*65536+g*256+b);
					}
				}
			}
			return returnBitmapData;
		}
		/**
		 *马赛克过滤 
		 * @param source
		 * @param block
		 * @return 
		 * 
		 */
		public static function mosaicFilter(source:BitmapData,block:Number=6) {
			//block 1-32
			returnBitmapData=source.clone();
			var sumr,sumg,sumb,product,color,r,g,b,br,bg,bb;
			for (var y=0; y<source.height; y+=block) {
				for (var x=0; x < source.width; x+=block) {
					sumr=0;
					sumg=0;
					sumb=0;
					product=0;
					for (var j=0; j<block; j++) {
						for (var i=0; i<block; i++) {
							if (x+i<source.width&&y+j<source.height) {
								color=source.getPixel(x+i, y+j);
								r = (color & 0xff0000) >> 16;
								g = (color & 0x00ff00) >> 8;
								b = color & 0x0000ff;
								sumr+=r;
								sumg+=g;
								sumb+=b;
								product++;
							}
						}
					}
					br=int(sumr/product);
					bg=int(sumg/product);
					bb=int(sumb/product);
					for (j=0; j<block; j++) {
						for (i=0; i<block; i++) {
							if (x+i<source.width&&y+j<source.height) {
								returnBitmapData.setPixel(x+i, y+j,br * 65536 + bg * 256 + bb);
							}
						}
					}
				}
			}
			return returnBitmapData;
		}
		/**
		 *油画过滤 
		 * @param source
		 * @param brushSize
		 * @param coarseness
		 * @return 
		 * 
		 */
		public static function oilPaintingFilter(source:BitmapData,brushSize:Number=1,coarseness:Number=32) {
			//brushSize 1-8
			//coarseness 1-255
			var color,gray,r,g,b,a;
			var arraylen=coarseness+1;
			var CountIntensity:Array=new Array();
			var RedAverage:Array=new Array();
			var GreenAverage:Array=new Array();
			var BlueAverage:Array=new Array();
			var AlphaAverage:Array=new Array();
			
			var filter=getGrayFilter();
			sourceBitmap=new Bitmap(source);
			sourceBitmap.filters=[filter];
			var tempData:BitmapData;
			tempData=new BitmapData(sourceBitmap.width,sourceBitmap.height,true, 0x00FFFFFF);
			tempData.draw(sourceBitmap);
			returnBitmapData=tempData.clone();
			var top,bottom,left,right;
			
			for (var y=0; y<source.height; y++) {
				top=y-brushSize;
				bottom=y+brushSize+1;
				if (top<0) {
					top=0;
				}
				if (bottom>=source.height) {
					bottom=source.height-1;
				}
				for (var x=0; x<source.width; x++) {
					left=x-brushSize;
					right=x+brushSize+1;
					if (left<0) {
						left=0;
					}
					if (right>=source.width) {
						right=source.width;
					}
					for (var i=0; i<arraylen; i++) {
						CountIntensity[i]=0;
						RedAverage[i]=0;
						GreenAverage[i]=0;
						BlueAverage[i]=0;
						AlphaAverage[i]=0;
					}
					for (var j=top; j<bottom; j++) {
						for (i=left; i<right; i++) {
							color=tempData.getPixel(i, j);
							gray = (color & 0xff0000) >> 16;
							color=source.getPixel32(i, j);
							a = color >> 24 & 0xFF;
							r = color >> 16 & 0xFF;
							g = color >> 8 & 0xFF;
							b = color & 0xFF;
							var intensity=int(coarseness*gray/255);
							CountIntensity[intensity]++;
							RedAverage[intensity]+=r;
							GreenAverage[intensity]+=g;
							BlueAverage[intensity]+=b;
							AlphaAverage[intensity]+=a;
						}
					}
					var closenIntensity=0;
					var maxInstance=CountIntensity[0];
					for (i=1; i<arraylen; i++) {
						if (CountIntensity[i]>maxInstance) {
							closenIntensity=i;
							maxInstance=CountIntensity[i];
						}
					}
					a=int(AlphaAverage[closenIntensity]/maxInstance);
					r=int(RedAverage[closenIntensity]/maxInstance);
					g=int(GreenAverage[closenIntensity]/maxInstance);
					b=int(BlueAverage[closenIntensity]/maxInstance);
					returnBitmapData.setPixel32(x,y,a*16777216+r*65536+g*256+b);
				}
			}
			return returnBitmapData;
		}
		public static function thresholdFilter(source:BitmapData,threshold:uint=128) {
			var returnBitmapData:BitmapData = new BitmapData(source.width, source.height,true,0xFF000000);
			var pt:Point = new Point(0, 0);
			var rect:Rectangle = new Rectangle(0, 0,source.width,source.height);
			threshold=threshold<0?0:threshold>255?255:threshold;
			var thre:uint =  255*0xFFFFFF+threshold*0xFFFF+threshold*0xFF+threshold;
			var color:uint = 0x00FFFFFF;
			var maskColor:uint = 0xFFFFFFFF;
			returnBitmapData.threshold(source, rect, pt, ">", thre, color, maskColor, false);
			return returnBitmapData;
		}
		/**
		 *阈值滤波 
		 * @param source
		 * @param rp
		 * @param gp
		 * @param bp
		 * @return 
		 * 
		 */
		public static function saturation(source:BitmapData,rp:Number=1,gp:Number=1,bp:Number=1) {
			var matrix:Array = new Array();
			matrix = matrix.concat([rp, 0, 0, 0, 0]);// red
			matrix = matrix.concat([0, gp, 0, 0, 0]);// green
			matrix = matrix.concat([0, 0, bp, 0, 0]);// blue
			matrix = matrix.concat([0, 0, 0, 1, 0]);// alpha
			var filter:BitmapFilter = new ColorMatrixFilter(matrix);
			sourceBitmap=new Bitmap(source);
			sourceBitmap.filters=[filter];
			returnBitmapData=new BitmapData(sourceBitmap.width,sourceBitmap.height,true, 0x00FFFFFF);
			returnBitmapData.draw(sourceBitmap);
			return returnBitmapData;
		}
		/**
		 *颜色反式 
		 * @param source
		 * @param ro
		 * @param go
		 * @param bo
		 * @return 
		 * 
		 */
		public static function colorTrans(source:BitmapData,ro:Number=0,go:Number=0,bo:Number=0){
			var resultColorTransform = new ColorTransform();
			resultColorTransform.redOffset = ro;
			resultColorTransform.greenOffset = go;
			resultColorTransform.blueOffset = bo;
			sourceBitmap=new Bitmap(source);
			var sp1=new Sprite();
			var sp2=new Sprite();
			sp1.addChild(sourceBitmap);
			var sp2=new Sprite();
			sp2.addChild(sp1);
			sp2.transform.colorTransform = resultColorTransform;
			returnBitmapData=new BitmapData(sourceBitmap.width,sourceBitmap.height,true, 0x00FFFFFF);
			returnBitmapData.draw(sp2);
			sp2=null;
			sp1=null;
			sourceBitmap=null;
			return returnBitmapData;
		}
		/**
		 * BitmapData缩放 
		 * @param source
		 * @param ro
		 * @param go
		 * @param bo
		 * @return 
		 * 
		 */
		public static function scaleBitmapData(source:BitmapData,scaleX:Number=1,scaleY:Number=1){
			var _Bmd:BitmapData=new BitmapData(source.width*scaleX,source.height*scaleY);
			var _Matrix:Matrix=new Matrix();
			_Matrix.scale(scaleX,scaleY);
			_Bmd.draw(source,_Matrix);
			return _Bmd;
		}
		/**
		 *Sprite对象阴影渲染
		 * 
		 */
		public static function spriteDropShadow(source:Sprite,
													_distance:Number=0,//显示对象副本较原始对象的偏移量，以像素为单位
													angel:Number=0,//投影的偏移角度
													color:uint=0x000000,//投影颜色
													alpha:Number=1,//投影的透明度
													blurX:Number=2,//投影在x坐标轴方向的模糊量
													blerY:Number=2,//投影再y坐标轴方向的模糊量
													strength:Number=4,//设置投影的强度，值越大投影越暗，与背景产生的对比差异越大
													quality:int=2,//模糊执行的次数，和BlurFilter里的quality一样(实际上它们的模糊原理是一样的)
													inner:Boolean=false,//决定是投影是在绘制在对象内部还是外部
													knockout:Boolean=false,//设置是否应用挖空效果
													hideObject:Boolean=false
		):Sprite{
			source.filters=[new DropShadowFilter(_distance,angel, color, alpha, blurX,blerY, strength, quality, inner, knockout,hideObject)];
			return source;
		}
		/**
		 *Sprite对象变灰
		 * 
		 */
		public static function spriteGray(source:Sprite):void{
			source.filters=[getGrayFilter()];
		}
		/**
		 *Sprite对象变亮
		 * 
		 */
		public static function spriteLight(source:Sprite,value:Number=2):void{
			source.filters = [new ColorMatrixFilter([value, 0, 0, 0, 0, 0, value, 0, 0, 0, 0, 0, value, 0, 0, 0, 0, 0, 1, 0])];		
		}
		/**
		 *Sprite颜色反制
		 * 
		 */
		public static function backWard(source:Sprite,value:Number=2):void{
			source.filters = [new ColorMatrixFilter([value, 0, 0, 0, 0, 0, value, 0, 0, 0, 0, 0, value, 0, 0, 0, 0, 0, 1, 0])];		
		}
	}
}