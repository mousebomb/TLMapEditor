package HLib.Tool
{
	import flash.geom.Point;

	public class HPointUtil
	{
		public function HPointUtil()
		{
		}
		/**获得两点间距*/
		public static function getTowPointDisTance(sPoint:Point,tPoint:Point):Number{
			return Point.distance(sPoint,tPoint);
		}
		/**获得两点之间的角度,反回值为 -180~180*/
		public static function getTowPointAngle(sPoint:Point,tPoint:Point):Number{  
			var tmpx:Number=tPoint.x - sPoint.x;  
			var tmpy:Number=tPoint.y - sPoint.y;  
			var angle:Number= Math.atan2(tmpy,tmpx)*(180/Math.PI);  
			return angle;  
		}
		/**两点间距是否小于指定值*/
		public static function compareDistance(sPoint:Point,tPoint:Point,distance:Number):Boolean{
			return Point.distance(sPoint,tPoint)<distance?true:false;
		}
		/**获得两点之间指定距离的点坐标*/
		public static function getDisTancePoint(sPoint:Point,tPoint:Point,distance:Number):Point{
			var st:Number=getTowPointDisTance(sPoint,tPoint);
			if(int(st-5)<=distance) return null;
			var _Prop:Number=distance/st;
			return Point.interpolate(sPoint,tPoint,_Prop);
		}
		/**获得目标点的方向值*/
		public static function getTowPointDirec(sPoint:Point,tPoint:Point):int{  
			var direcArgs:Array=[22.5,67.5,112.5,157.5,202.5,247.5,292.5,337.5];
			var angle:Number=getTowPointAngle(sPoint,tPoint);
			if(angle<0){
				angle=360+angle;
			}	
			var direc:int=0;
			for(var i:int=0;i<direcArgs.length;i++){
				if(angle<direcArgs[i]){
					direc=i;
					break;
				}
			}
			return direc;  
		}
		/**取区域内随机点*/
		public static function getAreaPoint(sPoint:Point,tPoint:Point,num:int):Array{
			return new Array();
		}
		/** 
		 *判断一个点是否在某个矩形(rectangular)区域内   
		 *  
		 */  
		public static function pointInRect(point_x:Number,point_y:Number,rect_x1:Number,rect_y1:Number,rect_x2:Number,rect_y2:Number):Boolean{   
			var x_in:Boolean=((point_x>rect_x1)&&(point_x<rect_x2)) || ((point_x>rect_x2)&&(point_x<rect_x1));   
			var y_in:Boolean=((point_y>rect_y1)&&(point_y<rect_y2)) || ((point_y>rect_y2)&&(point_y<rect_y1));   
			if (x_in && y_in){   
				return true;   
			}else{   
				return false;   
			}   
		} 
		/** 
		 *判断一个点是否在某个圆形(rectangular)区域内   
		 *  
		 */  
		public static function pointInSector(oPointX:Number,oPointY:Number,radius:Number,angle:int,tPointX:Number,tPointY:Number):Boolean{   
			return true;
		} 
	}
}