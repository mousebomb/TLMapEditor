package HLib.Csv 
{			
	import flash.events.EventDispatcher;
	
	import HLib.DataUtil.HashMap;

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
//		public var _DS:String
//		private var _DataArray:Array=new Array();
//		private var _ObjectArray:Array=new Array();
//		private var _TextField:TextField=new TextField();
//		private var _Ready:Boolean=false;
//		private var loader:URLLoader=new URLLoader();
//		
//		public function HCSV(s:String="") {
//			if (s==null) return;
//			if (s=="") return;			
//			loader.load(new URLRequest(s));
//			loader.addEventListener(Event.COMPLETE, onComplete);
//			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
//		}
//		private function onComplete(pEvt:Event):void {
//			var p:URLLoader = pEvt.target as URLLoader;
//			if (p==null) {
//				return;
//			}
//			_DS=p.data;
//			OnSetSrc();
//			_Ready = true;
//		}
//		public function OnSetSrc1():void {
//			if(_DataArray.length>0) return;
//			_TextField.text = _DS.replace(/\n/g,"");//把换行符去掉
//			var recordsetDelimiter:String 	= '\r'
//			var _TempArgs:Array=_DS.split(recordsetDelimiter);
//			var ss:String;
//			for(var i:int=0;i<_TextField.numLines;i++) {
//				ss = _TextField.getLineText(i);
//				//if (ss.length<2) continue;
//				_DS=ss.substr(0,1);
//				if (_DS=="#") continue;				
//				ss = ss.substr(0, ss.length-1);
//				_DataArray.push(ss.split(","));
//			}
//			//释放掉
//			_DS="";
//			_DS=null;
//			_TextField.text="";
//			_TextField=null;
//		}
//		public function OnSetSrc():void {
//			if(_DataArray.length>0) return;
//			var recordsetDelimiter:String 	= '\r\n';
//			var _TempArgs:Array=_DS.split(recordsetDelimiter);
//			var _MyFun:Function=function(item:Object,index:int,args:Array):Object{
//				return item.split(",");
//			};
//			_DataArray=_TempArgs.map(_MyFun);
//			_DataArray.shift();
//			if(_DataArray[0][0].substr(0,1)=="#"){
//				_DataArray.shift();
//			}
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
//			var args:Array = FindRow(rowid)
//			if(args==null)return "";
//			return args[GetColumnIndex(colname)];
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
//		 * 通过列名称、列id号获取行id号 
//		 * @param colname
//		 * @param colid
//		 * @return 
//		 * 
//		 */		
//		public function getRowidByColname(colname:String,colid:String):String{
//			var rowid:String
//			var col:int=GetColumnIndex(colname);
//			for(var i:int=0;i<_DataArray.length;i++) {
//				if(_DataArray[i][col] == colid)
//				{
//					rowid = _DataArray[i][0];
//					break;
//				}
//			}
//			return rowid;
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
//		public function isComplete():Boolean {
//			return _Ready;
//		}	
//		public function set DataArray(value:Array):void{
//			_DataArray=value;
//		}
//		public function get DataArray():Array{
//			OnSetSrc();
//			return _DataArray.slice(0,_DataArray.length-1);
//		}
		
	}
}