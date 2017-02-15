package tl.core.old
{
	/**
	 * 地图模型类(地表模型)
	 * @author 李舒浩
	 */	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import Lib.Tool.Config;
	import Lib.Tool.MyError;
	import Lib.Tool.Tool;
	
	import Module.Controls.TipsControl;
	import Module.Wizard.WizardUnit;
	
	import away3DExtend.RayDetectTool;
	
	import away3d.core.base.ISubGeometry;
	
	import tool.HitTestExtend;
	
	public class MapMeshManage
	{
		private static var _mapMeshManage:MapMeshManage;
		
		private var _isInit:Boolean = false;
		
		/** 地图地表模型数组 **/
		public function get mapMeshVec():Vector.<WizardUnit>  {  return _mapMeshVec;  }
		private var _mapMeshVec:Vector.<WizardUnit> = new Vector.<WizardUnit>();//地标模型保存数组
		
		private var _nodeVec:Vector.<Vector.<Node>>;

		public function MapMeshManage()  
		{  
			if(_mapMeshManage)
				throw new MyError();
			_mapMeshManage = this;
		}
		
		public static function getInstance():MapMeshManage
		{
			_mapMeshManage ||= new MapMeshManage();
			return _mapMeshManage;
		}
		/**
		 * 初始化
		 */		
		public function init():void
		{
			if(_isInit) return;
			
			
			_isInit = true;
		}
		/**
		 * 更新node格子索引数组
		 * @param $nodeVec
		 */		
		public function updateNodeVec($nodeVec:Vector.<Vector.<Node>>):void
		{
			_nodeVec = $nodeVec;
		}
		/**
		 * 批量添加地表模型
		 * @param $mapMeshWizardObjects	: 地表模型Vector数组
		 */		
		public function addMapMeshs($mapMeshWizardObjects:Vector.<WizardUnit>):void
		{
			var len:int = $mapMeshWizardObjects.length;
			for(var i:int = 0; i < len; i++)
			{
				addMapMesh($mapMeshWizardObjects[i]);
			}
			//分隔模型数据
			segmentationMapMesh();
		}
		
		/**
		 * 添加地表模型
		 * @param $mapMeshWizard	: 地标模型
		 */		
		public function addMapMesh($mapMeshWizard:WizardUnit):void
		{
			$mapMeshWizard.showBounds = true;
			_mapMeshVec.push($mapMeshWizard);
		}
		/**
		 * 移除地表模型
		 * @param $mapMesh	: 地表模型
		 * @return 
		 */		
		public function removeMapMesh($mapMesh:WizardUnit):void
		{
			if($mapMesh.parent) 
				$mapMesh.parent.removeChild($mapMesh);
			var index:int = _mapMeshVec.indexOf($mapMesh);
			_mapMeshVec.splice(index, 1);
		}
		/**
		 * 移除地表模型
		 * @param $mapMesh	: 地表模型
		 * @return 
		 */	
		public function updateMapMeshShowBounds():void
		{
			var len:int = _mapMeshVec.length;
			for(var i:int=0; i<len; i++)
				_mapMeshVec[i].showBounds = Config.IS_SHOW_BOUNDS
		}
		/**
		 * 清除所有的地表模型
		 */		
		public function clearAllMapMesh():void
		{
			_mapMeshVec.length = 0;
		}
		/**
		 * 根据点坐标位置获得对应的顶点坐标
		 * @param $vec3D	: 精灵当前坐标position
		 * @return 
		 */		
		public function getVector3DFormPosition($vec3D:Vector3D):Vector3D
		{
			if(_mapMeshVec.length == 0) 
			{
				$vec3D.y = 0;
				return $vec3D;
			}
			
			var dirVec3D:Vector3D = new Vector3D(0, 1, 0);
			var returnVec3D:Vector3D;
			var maxH:uint = 0;
			var maxVec3D:Vector3D;
			for each(var vec:Vector.<Vector3D> in _triPlaneVec)
			{
				returnVec3D = RayDetectTool.getHitTestPlanePosition($vec3D, dirVec3D, vec[0], vec[1], vec[2]);
				if(returnVec3D) 
				{
					if(maxH < returnVec3D.y)
					{
						maxH = returnVec3D.y;
						maxVec3D = returnVec3D;
					}
				}
			}
			if(!maxVec3D)//returnVec3D) 
			{
				$vec3D.y = 0;
				return $vec3D;
			}
			return maxVec3D;//returnVec3D;
		}
		/**
		 * 根据点坐标位置获得对应的格子高度
		 * @param $point
		 * @return 
		 */		
		public function getPointHFomrPosition($point:Point):int
		{
			if(!_nodeVec) return 0;
			var node:Node;
			var pointX:int = int($point.x / Config.GRID_WIDTH);
			var pointY:int = int($point.y / Config.GRID_HEIGHT);
			if(pointX < 0 || pointY < 0)			return 0;
			if(pointY >= _nodeVec.length)			return 0;
			if(pointX >= _nodeVec[pointY].length)	return 0;
			node = _nodeVec[pointY][pointX];
			return node.pointH;
		}
		
		
		/** 获得地图所有三角面 **/
		public function segmentationMapMesh():void
		{
			if(_mapMeshVec.length == 0) return;
			
			TipsControl.getInstance().showTips("开始地表模型计算模型三角面,请稍后...");
			
			_triPlaneVec.length = 0;
			var geometries:Vector.<ISubGeometry>;
			//顶点数据集, 顶点数据总数量, 顶点当前所在位置
			var vertex:Vector.<Number>, len:uint, indexData:Vector.<uint>;
			var vertexVec3D:Vector3D = new Vector3D();
			for each(var wizardUnit:WizardUnit in _mapMeshVec)
			{
				//获得所有三角面
				RayDetectTool.getTriPlaneVec(wizardUnit, _triPlaneVec);
			}
			
			//计算三角面所在区域
			setTimeout(function():void
			{
				_updateNode.length = 0;
				for each(var nodeVec:Vector.<Node> in _nodeVec)
				{
					for each(var node:Node in nodeVec)
					{
						node.pointH = 0;
					}
				}
				updateNodePointH();
			},1000);
		}
		private var _triPlaneVec:Vector.< Vector.<Vector3D> > = new Vector.< Vector.<Vector3D> >();	//模型中每个三角面保存数组,[[三角面点1,点2,点3]....]
		private var _mapMeshPositionVec:Vector.<Vector3D> = new Vector.<Vector3D>();
		private var _updateNode:Vector.<Node> = new Vector.<Node>();
		private var _updateIndex:int = 0;
		
		private function updateNodePointH():void
		{
			if(_updateNode.length == 0)
			{
				TipsControl.getInstance().showTips("获取需要检测的格子");
				var node:Node;
				for each(var nodeVec:Vector.<Node> in _nodeVec)
				{
					for each(node in nodeVec)
					{
						//判断格子点是否在模型上
						_updateNode.push(node);
					}
				}
				TipsControl.getInstance().showTips("获取完成,需要检测的格子数："+_updateNode.length+"，开始执行碰撞检测,碰撞期间会有一定的卡顿,请等待");
				setTimeout(function():void
				{
					updateNodePointH();
				},1000);
			}
			else
			{
				TipsControl.getInstance().showTips("正在执行射线检测格子高度,当前剩余检测格子数量为："+_updateNode.length);
				
				var nodeV3D:Vector3D = new Vector3D();
				var lastFrameTime:Number = getTimer();
				while(Tool.hasTime(lastFrameTime))
				{
					if(_updateNode.length == 0) 
					{
						if(updateNodePointHComplete != null) updateNodePointHComplete();
						_updateIndex = 0;
						return;
					}
					node = _updateNode.shift();
					
					nodeV3D.x = node.pointX;
					nodeV3D.y = 0
					nodeV3D.z = node.pointY;
					var vec3D:Vector3D = MapMeshManage.getInstance().getVector3DFormPosition(nodeV3D);
					node.pointH = vec3D.y;
				}
				
				if(_updateNode.length == 0) 
				{
					if(updateNodePointHComplete != null) updateNodePointHComplete();
					_updateIndex = 0;
					return;
				}
				else
				{
					setTimeout(function():void
					{
						updateNodePointH();
					},100);
				}
				return;
			}
			
		}
		
		public var updateNodePointHComplete:Function;	//更新node数据后执行回调方法
		
		
	}
}