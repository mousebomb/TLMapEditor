//package HLib.Tool
//{
//	public class DataCompare
//	{
//		public static function DataDiff(dataA:String,dataB:String):String{
//			//计算两个时差
//			var date1:Date = new Date(dataA.replace("-","/"));
//			var date2:Date = new Date(dataB.replace("-","/"));
//			var num:uint = date2.getTime() - date1.getTime();
//			var aday:uint = 1000 * 60 * 60;
//			var dd:uint = 1000 * 60;
//			//日间隔
//			var nday:uint = num / aday / 24;
//			//小时间隔
//			var nhour:uint = num / aday - nday * 24;
//			//分钟间隔
//			var min:uint = num / dd % 60;
//			
//			return nday+" "+nhour+":"+min;
//		}
//		public static function DataComparisons(dataA:String,dataB:String):int{
//			//计算两个时差
//			var date1:Date = new Date(dataA.replace("-","/"));
//			var date2:Date = new Date(dataB.replace("-","/"));
//			var num:uint = date2.getTime() - date1.getTime();
//			var aday:uint = 1000 * 60 * 60;
//			var dd:uint = 1000 * 60;
//			//日间隔
//			var nday:uint = num / aday / 24;
//			//小时间隔
//			var nhour:uint = num / aday - nday * 24;
//			//分钟间隔
//			var min:uint = num / dd % 60;
//			
//			return num;
//		}
//		public static function TimeString(_TimerLength:int):String{
//			if(_TimerLength>0){
//				var date:Date = new Date(_TimerLength*1000);
//				var year:String = ""+date.fullYear;
//				var month:String =Number(date.month+1)<10?"0"+String(date.month+1):String(date.getMonth()+1);
//				var day:String = Number(date.date)<10?"0"+String(date.date):String(date.date);
//				var hour:String = Number(date.hours)<10?"0"+String(date.hours):String(date.hours);
//				var minute:String = Number(date.minutes)<10?"0"+String(date.minutes):String(date.minutes);
//				var second:String = Number(date.seconds)<10?"0"+String(date.seconds):String(date.seconds);
//				return hour + ":" + minute + ":" + second;
//			}else{
//				return "";
//			}
//		}
//		public static function TimeString2(_TimerLength:int):String{
//			if(_TimerLength>0){
//				var date:Date = new Date(_TimerLength*1000);
//				var year:String = ""+date.fullYear;
//				var month:String =Number(date.month+1)<10?"0"+String(date.month+1):String(date.getMonth()+1);
//				var day:String = Number(date.date)<10?"0"+String(date.date):String(date.date);
//				var hour:String = Number(date.hours)<10?"0"+String(date.hours):String(date.hours);
//				var minute:String = Number(date.minutes)<10?"0"+String(date.minutes):String(date.minutes);
//				var second:String = Number(date.seconds)<10?"0"+String(date.seconds):String(date.seconds);
//				return year+"-"+month + "-" + day + "  " + hour + ":" + minute + ":" + second;
//			}else{
//				return "";
//			}
//		}
//	}
//}