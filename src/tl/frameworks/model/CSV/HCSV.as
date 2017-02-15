package tl.frameworks.model.CSV
{
	import flash.events.EventDispatcher;

	import tl.utils.HashMap;

	public class HCSV extends EventDispatcher
	{
		public var hashMap:HashMap;
		public var colnameArr:Array;
		
		private var _dataArr:Array;
		
		/** 获取一行数据数组 **/
		public function FindRow(rowid:String):Array
		{
			return hashMap.get( rowid );
		}
		/**  **/
		public function GetColumnIndex(colname:String):int
		{
			return colnameArr.indexOf(colname);
		}
		/**  **/
		public function FindCell(rowid:String, colname:String):String
		{
			var arr:Array = FindRow(rowid);
			if(!arr) return "";
			return arr[ GetColumnIndex(colname) ];
		}
		/** 获取指定类型数据 **/
		public function FindList(Key:String,colname:String):Array
		{
			var arr:Array = [];
			var col:int = GetColumnIndex(colname);
			_dataArr ||= hashMap.values;
			var len:int = _dataArr.length;
			for(var i:int = 0; i < len; i++) 
			{
				if(Key == _dataArr[i][col])
				{
					arr.push( _dataArr[i] );
				}
			}
			return arr;
		}
		
		public function FindColumn(colname:String):Array
		{
			var args:Array = [];
			var col:int = GetColumnIndex(colname);
			_dataArr ||= hashMap.values;
			var len:int = _dataArr.length;
			
			for(var i:int = 0; i < len; i++)
			{
				args.push( _dataArr[i][col] );
			}
			return args;
		}
		/**
		 * 查找并返回Object
		 * @param $rowid	: 主键名
		 * @param $obj		: 对象，为空时返回一个由表格属性组成的Object,如果第二个参数不为空，则会将传进去的Object赋值,只是这个对象必需要跟表是配对的才会数据完全正确
		 * @return 
		 */
		public function FindToObject($rowid:String, $obj:Object = null):Object
		{
			var arr:Array = FindRow( $rowid )
			if(!arr) return null;
			
			$obj ||= {};
			var len:int = colnameArr.length;
			for(var i:int = 0; i < len; i++)
			{
				$obj[ colnameArr[i] ] = arr[i];
			}
			return $obj;
		}
		/**  获得数据数组**/
		public function get DataArray():Array
		{
			_dataArr ||= hashMap.values;
			return _dataArr.concat();
		}
		/** 克隆数组 **/
		public function get quoteDataArray():Array
		{
			_dataArr ||= hashMap.values;
			return _dataArr;
		}
		
//*************************************************  old time: 2015-02-27    author: 李舒浩
//*************************************************  如果用二进制转换的csv.jpg出问题的话可以还原以下代码,恢复原来的处理方式
//		private var _DataString:String
//		private var _DataArray:Array=new Array();
//		private var _TextField:TextField=new TextField();
//		
//		public function HCSV(s:String="") {
//			
//		}
//		public function OnSetSrc():void {
//			if(_DataArray.length>0) return;
//			_TextField.text = _DataString.replace(/\n/g,"");//把换行符去掉
//			var ss:String;
//			for(var i:int=0;i<_TextField.numLines;i++) {
//				ss = _TextField.getLineText(i);
//				//if (ss.length<2) continue;
//				_DataString=ss.substr(0,1);
//				if (_DataString=="#") continue;				
//				ss = ss.substr(0, ss.length-1);
//				_DataArray.push(ss.split(","));
//			}
//			//释放掉
//			_DataString="";
//			_DataString=null;
//			_TextField.text="";
//			_TextField=null;
//		}
//		private function onIOError(pEvt:IOErrorEvent):void {
//			trace("读取数据表失败！")
//		}
//		public function FindRow(rowid:String):Array{
//			OnSetSrc();
//			var _args:Array;
//			for(var i:int=0;i<_DataArray.length;i++) {
//				if(rowid==_DataArray[i][0]){
//					_args=_DataArray[i];
//					break;
//				}
//			}
//			return _args;
//		}
//		public function GetColumnIndex(colname:String):int{
//			OnSetSrc();
//			return _DataArray[0].indexOf(colname);
//		}
//		public function FindCell(rowid:String,colname:String):String{
//			if(FindRow(rowid)==null)return "";
//			return FindRow(rowid)[GetColumnIndex(colname)];
//		}
//		public function FindList(Key:String,colname:String):Array{
//			var args:Array=new Array();
//			var col:int=GetColumnIndex(colname);
//			for(var i:int=0;i<_DataArray.length;i++) {
//				if(Key==_DataArray[i][col]){
//					args.push(_DataArray[i]);
//				}
//			}
//			return args;
//		}
//		public function FindColumn(colname:String):Array{
//			var args:Array=new Array();
//			var col:int=GetColumnIndex(colname);
//			for(var i:int=0;i<_DataArray.length;i++) {
//					args.push(_DataArray[i][col]);
//			}
//			return args;
//		}
//		/**
//		 * 查找并返回Object
//		 * @param rowid 主键名
//		 * @param o　对象，为空时返回一个由表格属性组成的Object,如果第二个参数不为空，则会将传进去的Object赋值,只是这个对象必需要跟表是配对的才会数据完全正确
//		 * @return 
//		 * 
//		 */
//		public function FindToObject(rowid:String,o:Object=null):Object{
//			OnSetSrc();
//			var _Object:Object;
//			if(o!=null){
//				_Object=o;
//			}
//			else{
//				_Object=new Object();
//			}	
//			var _Args:Array=FindRow(rowid);
//			if(!_Args)return null;
//			for(var i:int=0;i<_DataArray[0].length;i++) {
//					_Object[_DataArray[0][i]]=_Args[i];
//			}
//			return _Object;
//		}	
//		public function set DataArray(value:Array):void{
//			_DataArray=value;
//		}
//		public function get DataArray():Array{
//			OnSetSrc();
//			return _DataArray.slice(0,_DataArray.length-1);
//		}
//		public function set dataString(value:String):void{
//			_DataString=value;  
//		}
//		public function get dataString():String{
//			return _DataString;
//		}
	}
}