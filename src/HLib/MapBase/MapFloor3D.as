package HLib.MapBase
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import HLib.DataUtil.HashMap;
	import HLib.MapBase.MapLoader.MyMapResTool;
	import HLib.UICom.BaseClass.HSprite3D;
	
	import Modules.Map.HMapSources;
	
	import away3d.entities.SegmentSet;
	import away3d.primitives.data.Segment;
	
	/**
	 * 主场景地图控制类 
	 * @author Administrator
	 * 
	 */	
	public class MapFloor3D extends EventDispatcher
	{	
		private static var _MyInstance:MapFloor3D;
		private var _isInIt:Boolean = false;				//是否初始化 
		private var _mapData:HMapData;
		private var _cols:int = 5;							//地图分块总列数
		private var _rows:int = 5;							//地图分块总横数
		private var _tileWidth:int = 512;				    //小块地图宽
		private var _tileHeight:int = 512;				    //小块地图高
		private var _mapWidth:int;							//地图宽
		private var _mapHeight:int;					 	//地图高
		private var _viewWidth:Number = 0;                	//摄像机视图宽度
		private var _viewHeight:Number = 0;                  //摄像机视图高度
		
		private var _mapTileIdArr:Array = [];
		private var _mapTileVector:Vector.<TileView3D> = new Vector.<TileView3D>();
		
		private var _startX:int = -1;						//上次起始位置
		private var _startY:int = -1;						//上次起始位置
		
		private var _mapURL:String = "";		            //资源路径
		private var _colorArgs:Array = [0xFFff0000, 0xFF999999, 0xFF00ff00, 0, 0xFFffff00, 0xFF0000ff];
		private var _keyArgs:Array = [1, 0, 2, 0, 4, 5];
		private var _tileView3DParent:HSprite3D;
		
		public function MapFloor3D()
		{
			if( _MyInstance )
			{
				throw new Error ("单例只能实例化一次,请用 getInstance() 取实例。");
			}
			_MyInstance=this;
		}
		
		public static function getInstance():MapFloor3D 
		{
			if ( _MyInstance == null ) 
			{				
				_MyInstance = new MapFloor3D();
			}
			return _MyInstance;
		}
		
		public function get mapHeight():int
		{
			return _mapHeight;
		}
		
		public function get mapWidth():int
		{
			return _mapWidth;
		}
		/**
		 * 添加小地图数据 
		 * 
		 */		
		public function InIt():void
		{
			if(_isInIt)
			{
				return;
			}
			var str:String;
			var title:TileView3D;
			for(var i:int = 0; i < 20; i++)
			{
				for(var j:int = 0; j < 20; j++)
				{
					str =  "smesh_" + i + "_" + j
					title = new TileView3D(j, i, 512, 512, tileViewHash.get(str));
					title.isOpenSunLight = _isOpenSunLight;
					_mapTileIdArr.push(str);
					_mapTileVector.push(title);
				}
			}
			_isInIt = true;
		}
		
		private function getMosaicsBmd(x:int, y:int):BitmapData
		{
			var _bmdSmall:BitmapData
			var tw:Number = _mosaicsBitmapData.width / _cols;
			var th:Number = _mosaicsBitmapData.height / _rows;
			
			if (_bmdSmall == null || _bmdSmall.width != tw || _bmdSmall.height != th)
			{
				if (_bmdSmall)
				{
					_bmdSmall.dispose();
				}
				_bmdSmall = new BitmapData(tw, th);
			}
			_bmdSmall.copyPixels(_mosaicsBitmapData, new Rectangle(x * tw, y * th, tw, th), new Point());
			const BMD_W_H:uint = 64;
			var retBmd:BitmapData = new BitmapData(BMD_W_H, BMD_W_H);
			var matrix:Matrix = new Matrix();
			matrix.scale(BMD_W_H / _bmdSmall.width, BMD_W_H / _bmdSmall.height);
			retBmd.draw(_bmdSmall, matrix);
			_bmdSmall.dispose();
			return retBmd;
		}
		
		private var lines:SegmentSet = new SegmentSet();
		private var lines1:SegmentSet = new SegmentSet();
		/**绘制网络*/
		public function drawGrid():void{
			//线的两端点，粗细，起始端颜色，结束端颜色
			//----计算行列数--------------------------------
			var _GridCols:int=_mapData._GridCols;
			var _GridRows:int=_mapData._GridRows;
			//----开始绘制行列--------------------------------
			var _NowPoint:Point=new Point(0,0);
			//----绘制列-------------------------------------------
			var line:Segment
			for(var i:int=0;i<_GridCols;i++)
			{
				line = new Segment(new Vector3D(_NowPoint.x,0,_NowPoint.y),new Vector3D(_NowPoint.x,0,_NowPoint.y+_mapData.myHeight),new Vector3D(0,0,0),0xFFb5b7b4,0xFFff0000);
				lines.addSegment(line);
				_NowPoint.x-=_mapData.GRID_WIDTH;
			}
			//----绘制行-------------------------------------------
			_NowPoint=new Point(0,0);
			for(i=0;i<_GridRows;i++)
			{
				line = new Segment(new Vector3D(_NowPoint.x,0,_NowPoint.y),new Vector3D(_NowPoint.x-_mapData.myWidth,0,_NowPoint.y),new Vector3D(0,0,0),0xFFb5b7b4,0xFFff0000);
				lines.addSegment(line);
				_NowPoint.y+=_mapData.GRID_HEIGHT;
			}
			_tileView3DParent.addChild(lines);
			_tileView3DParent.addChild(lines1);
		}
		
		/**刷新点*/
		public function drawPoint():void
		{
			for(var i:int=0;i<_mapData._NodeArgs.length;i++){
				for(var j:int=0;j<_mapData._NodeArgs[i].length;j++){
					if(_mapData._NodeArgs[i][j].value>0){						
						var line:Segment = new Segment(
							new Vector3D(-_mapData._NodeArgs[i][j].pointX+10,0,_mapData._NodeArgs[i][j].pointY),
							new Vector3D(-_mapData._NodeArgs[i][j].pointX-10,0,_mapData._NodeArgs[i][j].pointY),
							new Vector3D(0,0,0),_colorArgs[_keyArgs[_mapData._NodeArgs[i][j].value]],
							_colorArgs[_keyArgs[_mapData._NodeArgs[i][j].value]],3
						);
						lines.addSegment(line);
					}					
				}
			}
		}
		
		/**刷新点*/
		public function drawByPoint(point:Point):void
		{
			var _PointX:int=int(point.x/_mapData.GRID_WIDTH);
			var _PointY:int=int(point.y/_mapData.GRID_HEIGHT);
			if(_PointY>=_mapData._NodeArgs.length) return;
			if(_PointX>=_mapData._NodeArgs[_PointY].length) return;
			var line:Segment = new Segment(
				new Vector3D(-_mapData._NodeArgs[_PointY][_PointX].pointX+10,0,_mapData._NodeArgs[_PointY][_PointX].pointY),
				new Vector3D(-_mapData._NodeArgs[_PointY][_PointX].pointX-10,0,_mapData._NodeArgs[_PointY][_PointX].pointY),
				new Vector3D(0,0,0),0xFFffffff,
				_colorArgs[_keyArgs[_mapData._NodeArgs[_PointY][_PointX].value]],2
			);
			lines1.addSegment(line);
		}
		
		/**
		 * 按数据源刷新地图
		 * 
		 */		
		public function refreshMapFloor3D(mapData:HMapData = null):void
		{
			if(mapData == null)
			{
				mapData = HMapSources.getInstance().mapData;
			}
			//刷新数据
			_mapData = mapData;
			_cols = _mapData.mapCols;
			_rows = _mapData.mapRows;
			_mapWidth = _mapData.myWidth; 
			_mapHeight =_mapData.myHeight; 
			if(!_isInIt)
			{
				InIt();
			}
			else
			{
				_mosaicsBitmapData = null;
				disposeResAll();
			}
			//初始化地图显示
			refreshMapUrl(_mapData.mapResPathName);
			onMosaicsMapComplete();
		}
		
		/** 释放所有资源 **/
		private function disposeResAll():void
		{
			var len:uint = _mapTileVector.length;
			for(var i:int = 0; i < len; i++)
			{
				if(_mapTileVector[i].status != TileView3D.status_NoTexture)
				{
					_mapTileVector[i].clear();
				}
			}
			
			//释放地图所有资源
			MyMapResTool.instance.clear();
		}
		
		private function refreshMapUrl(url:String):void
		{
			_mapURL=url;
			var title:TileView3D;
			for each(title in _mapTileVector)
			{
				title.seturl(_mapData.mapResPathName, _mapData.mapResName);
			}
		}
		
		/**
		 * 马赛克小地图加载完成
		 * @param bmd
		 * 
		 */		
		private function onMosaicsMapComplete():void
		{
			_startX = -1;
			_startY = -1;
		}
		
		/**
		 * 是否开启阳光
		 * @param value	: true:开启 false:关闭
		 */		
		public function set isOpenSunLight(value:Boolean):void
		{
			_isOpenSunLight = value;
			if(!_isInIt)
			{
				return;
			}
			var str:String
			var index:int;
			var title:TileView3D;
			for(var i:int = 0; i < 20; i++)
			{
				for(var j:int = 0; j < 20; j++)
				{
					str =  "smesh_" + i + "_" + j
					index = _mapTileIdArr.indexOf(str);
					if(index > -1)
					{
						title = _mapTileVector[index];
						title.isOpenSunLight = value;
					}
				}
			}
		}
		
		public function get isOpenSunLight():Boolean 
		{ 
			return _isOpenSunLight;
		}
		
		private var _isOpenSunLight:Boolean = false;
		
		/**
		 * 设置地图显示加载
		 * @param $x	: 角色的x
		 * @param $Y	: 角色的y
		 */		
		public function aimAt($x:Number = 0, $y:Number = 0, forceUpdate:Boolean = false):void
		{
			if(!_isInIt)
			{
				return;
			}
			if(!_mosaicsBitmapData)
			{
				return;
			}
			//把自身的坐标转成所引致
			var ux:int = $x / _tileWidth;
			var uy:int = $y / _tileHeight;
			//设置加载地图
			if(_startX == ux && _startY == uy && forceUpdate == false) 
			{
				return
			}
			_startX = ux;
			_startY = uy;
			var tileView3D:TileView3D
			
			var tmpXIdx:int = Math.ceil(_viewWidth / _tileWidth) + 1;
			var tmpYIdx:int = Math.ceil(_viewHeight / _tileHeight) + 1;
			var tmpMinX:int = Math.max(0, _startX - tmpXIdx);
			var tmpMinY:int = Math.max(0, _startY - tmpYIdx);
			var tmpMaxX:int = Math.min(_mapData.mapCols, _startX + tmpXIdx);
			var tmpMaxY:int = Math.min(_mapData.mapRows, _startY + tmpYIdx);
			
			for (var i:int = tmpMinX; i < tmpMaxX; ++i)
			{
				for (var j:int = tmpMinY; j < tmpMaxY; ++j)
				{
					tileView3D = getSmallMap(i, j);
					if(tileView3D.status == TileView3D.status_NoTexture)
					{
						tileView3D.loadMap(getMosaicsBmd(i, j));
					}
					/*
					else
					{
					tileView3D.loadMap();	
					}*/
				}
			}
		}
		
		private var _openLightMap:Vector.<TileView3D> = new Vector.<TileView3D>();
		
		/**地图模块数据*/
		public var tileViewHash:HashMap;
		
		private var _mosaicsBitmapData:BitmapData;
		/**马赛克bitmapdata对象*/
		public function set mosaicsBitmapData(value:BitmapData):void
		{
			_mosaicsBitmapData = value;
		}
		
		//背景图片bitmapdata数据
		public var mapResName:String;				//地图文件名
		
		/**
		 * 取分块
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */		
		public function getSmallMap(x:int=0,y:int=0):TileView3D
		{
			var str:String =  "smesh_" + y + "_" + x
			var index:int = _mapTileIdArr.indexOf(str);
			if(index > -1)
			{
				return _mapTileVector[index];
			}
			return  null;
		}
		
		public function get ViewWidth():Number
		{
			return _viewWidth;
		}
		
		public function set ViewWidth(value:Number):void
		{
			_viewWidth = value;
		}
		
		public function get viewHeight():Number
		{
			return _viewHeight;
		}
		
		public function set viewHeight(value:Number):void
		{
			_viewHeight = value;
		}
		
		public function get tileView3DParent():HSprite3D
		{
			return _tileView3DParent;
		}
		
		public function set tileView3DParent(value:HSprite3D):void
		{
			_tileView3DParent = value;
		}
	}
}

