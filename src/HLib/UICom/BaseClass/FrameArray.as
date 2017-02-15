package HLib.UICom.BaseClass
{
	/**
	 * 序列帧转换类 
	 * 
	 */
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class FrameArray
	{		
		/**
		 * 按行将 BitmapData 转换为 由_BitmapData组成的序列帧数组
		 * 
		 * @param _BitmapData	: 原图
		 * @param RNum			: 帧数
		 * @param _args			: 需要存入的数组
		 * @return 返回
		 */
		public static function GetFarmeArrayRow(_BitmapData:BitmapData,RNum:int,_IsornotFlip:int=0):Array{
			var _args:Array=[];
			var sw:Number=_BitmapData.width/RNum;
			var sh:Number=_BitmapData.height;
			var _Rectangle:Rectangle=new Rectangle(0,0,sw,sh);
			//var _Tempbmd:BitmapData=new BitmapData(sw,_NameHeight,true,0);
			var _bmd:BitmapData;
			for(var i:int=0;i<RNum;i++){
				_bmd=new BitmapData(sw,sh);//+_NameHeight
				_Rectangle.x=sw*i;
				_Rectangle.y=0;
				//_bmd.copyPixels(_Tempbmd,new Rectangle(0,0,sw,_NameHeight),new Point(0,0));//写入一个30像素高的透明区域，用与写角色名字
				_bmd.copyPixels(_BitmapData,_Rectangle, new Point(0,0));//_NameHeight
				if(_IsornotFlip==0){
					_args[i]=_bmd;
				}
				else{
					_args[i]=LevelFlip(_bmd);
				}
				
			}
			_Rectangle.x=0;
			_Rectangle.y=0;
			return _args;
		}
		/**
		 * 将 BitmapData 转换为 由_BitmapData组成的序列帧数组距阵
		 * 
		 * @param _BitmapData	: 原图
		 * @param RNum			: 行数
		 * @param VRum			: 列数
		 * @param _args			: 需要存入的数组
		 * @return 返回
		 */
		public static function GetFarmeArray(_BitmapData:BitmapData,RNum:int,VRum:int):Array{
			var _args:Array=[];
			var _Matrix:Matrix=new Matrix();
			var sw:Number=_BitmapData.width/RNum;
			var sh:Number=_BitmapData.height;
			var _bmd:BitmapData=new BitmapData(sw,sh);			
			for(var i:int=0;i<RNum;i++){
				_args[i]=[];
				for(var j:int=0;j<VRum;j++){
					_bmd=_bmd.clone();
					_Matrix.tx=-1*sw*j;
					_Matrix.ty=-1*sh*i;
					_bmd.draw(_BitmapData,_Matrix);
					_args[i][j]=_bmd;
				}
			}
			return _args;
		}
		public static function AngleFlip(bt:BitmapData,angle:Number):BitmapData {
			if(bt==null) return null;
			var bmd:BitmapData = new BitmapData(500,500,true,0);
			var mc:Matrix = new Matrix();
			mc.rotate(angle);			
			bmd.draw(bt,mc);
			return bmd;
		}
		/** 左右翻转 **/
		public static function LevelFlip(bt:BitmapData):BitmapData {
			if(bt==null) return null;
			var bmd:BitmapData=new BitmapData(bt.width,bt.height,true, 0x00000000);
			var _Matrix : Matrix = new Matrix(-1, 0, 0, 1,bt.width, 0 ); 
			bmd.draw(bt,_Matrix);
			return bmd;
		}
		/**  上下翻转  **/
		public static function VerticalFlip(bt:BitmapData):BitmapData {
			var bmd:BitmapData = new BitmapData(bt.width, bt.height, true, 0x00000000);
			for (var xx:int=0; xx<bt.width; xx++) {
				for (var yy:int=0; yy<bt.height; yy++) {
					bmd.setPixel32(xx, bt.height-yy-1, bt.getPixel32(xx,yy));
				}
			}
			return bmd;
		}
	}
}