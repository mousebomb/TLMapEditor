/**
 * Created by gaord on 2016/12/27.
 */
package tl.frameworks.model
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;

	import org.mousebomb.Math.MousebombMath;
	import org.mousebomb.framework.GlobalFacade;

	import tl.core.funcpoint.FuncPointVO;
	import tl.core.rigidbody.RigidBodyVO;
	import tl.core.role.Role;
	import tl.core.role.RolePlaceVO;
	import tl.core.terrain.*;
	import tl.frameworks.NotifyConst;
	import tl.frameworks.defines.FunctionPointType;
	import tl.frameworks.defines.WizardLayer;

	import tool.StageFrame;

	/** 编辑环境使用的mapmodel  多出一些编辑方法 */
	public class TLEditorMapModel extends TLMapModel
	{

		/** 鼠标指向坐标点(单位是格) */
		public var mouseTilePos : Point =new Point();

		// 鼠标flash显示坐标输入，转换记录格子坐标
		public function setCurMousePos(mousePos:Vector3D):void
		{
			transToTerrainPos(mousePos.x,mousePos.z , mouseTilePos);
			dispatchWith(NotifyConst.MOUSE_POS_CHANGED);
//			trace(StageFrame.renderIdx,"[TLEditorMapModel]/setCurMousePos tilePOS:",mouseTilePos);
		}


		/** 需同步锁定操作 */
		public var busyLoading:Boolean = false;


		// #pragma mark --  addWizard  ------------------------------------------------------------
		/** 加入模型 */
		public function addWizard(role:Role):RolePlaceVO
		{
			if(selectedGroupName)
				return addWizardToGroup(role ,selectedGroupName);
			else
				return addWizardToGroup(role ,WizardLayer.LABEL[role.vo.csvVO.Layer]);
		}

		private function addWizardToGroup(role:Role, wizardType:String):RolePlaceVO
		{
			var group :Vector.<RolePlaceVO> = _curMapVO.entityGroups[wizardType];
			if(group == null)
			{
				_curMapVO.entityGroups[wizardType] = group = new <RolePlaceVO>[];
				_curMapVO.entityGroupNames.push(wizardType);
				dispatchWith(NotifyConst.GROUP_ADDED,false,wizardType);
			}
			var placeData :RolePlaceVO = new RolePlaceVO();
			placeData.wizardId = role.vo.csvVO.Id;
			placeData.x = role.x;
			placeData.y =role.y;
			placeData.z = role.z;
			placeData.rotationY = role.rotationY;
			group.push(placeData);
			placeData.wizard = role;
			dispatchWith(NotifyConst.GROUP_WIZARD_LIST_CHANGED,false,wizardType);
			return placeData;
		}

		public function commitWizard(role:Role,placeData:RolePlaceVO):void
		{
			if(placeData)
			{
				placeData.x = role.x;
				placeData.y = role.y;
				placeData.z = role.z;
				placeData.rotationY = role.rotationY;
				placeData.scale = role.scaleX;
				trace(StageFrame.renderIdx,"[TLEditorMapModel]/commitWizard placeData.scale" ,placeData.scale);
				dispatchWith(NotifyConst.GROUP_WIZARD_LI_CHANGED,false,placeData);
			}else{
				GlobalFacade.sendNotify(NotifyConst.STATUS,this,"精灵放置数据不存在");
			}
		}

		public function delWizard(place:RolePlaceVO):void
		{
			for (var key :* in _curMapVO.entityGroups)
			{
				var group :Vector.<RolePlaceVO> = _curMapVO.entityGroups[key];
				var index : int = group.indexOf(place);
				if(index >-1)
				{
					group.splice(index, 1);
					dispatchWith(NotifyConst.GROUP_WIZARD_LIST_CHANGED,false,key);
					return;
				}
			}
			GlobalFacade.sendNotify(NotifyConst.STATUS,this,"要删的精灵放置数据不存在");
		}

		/** 当前选中的层 默认为""或null时 则自动加入层 */
		public var selectedGroupName : String ;
		/** 新建一个层 */
		public function addEntityGroup(groupName:String):void
		{
			if(_curMapVO.entityGroupNames.indexOf(groupName)>-1)
			{
				GlobalFacade.sendNotify(NotifyConst.STATUS,this,"名称已存在，忽略");
				return;
			}
			_curMapVO.entityGroupNames.push(groupName);
			_curMapVO.entityGroups[groupName] = new Vector.<RolePlaceVO>();
			// 通知：新建一个层成功
			dispatchWith(NotifyConst.GROUP_ADDED,false,groupName);
		}

		/** 层 改名 */
		public function renameEntityGroup(groupName:String, toName:String):Boolean
		{
			var index : int = _curMapVO.entityGroupNames.indexOf(groupName);
			if(index ==-1)
				return false;
			_curMapVO.entityGroupNames[index] = toName;
			return true;
		}

		/** 将一个精灵 从层组移动到另一个层组 */
		public function moveIntoGroup(placeData:RolePlaceVO,fromGroupName:String,toGroupName:String):void
		{
			var group :  Vector.<RolePlaceVO>= _curMapVO.entityGroups[fromGroupName];
			var oldIndex : int = group.indexOf(placeData);
			group.splice(oldIndex,1);
			dispatchWith(NotifyConst.GROUP_WIZARD_LIST_CHANGED,false,fromGroupName);
			_curMapVO.entityGroups[toGroupName].push(placeData);
			dispatchWith(NotifyConst.GROUP_WIZARD_LIST_CHANGED,false,toGroupName);
		}


		// #pragma mark --  设置区域  ------------------------------------------------------------
		/**操作状态 当前设置区域 */
		public var curZoneType:int = -1;

		/** 设置某个坐标的区域类型 */
		public function setZoneType(pxX:Number, pxZ:Number, type : int,pxRadius:Number ):void
		{
			// 像素坐标换算成顶点坐标
			var centerX:int = pxX / TLMapVO.TERRAIN_SCALE;
			var centerY:int = -pxZ / TLMapVO.TERRAIN_SCALE;
			var size:int    = pxRadius / TLMapVO.TERRAIN_SCALE;
			if (size < 1)size = 1;
			var curX:int;
			var curY:int;
			var curRadius:Number;
			var centerP:Point    = new Point(centerX, centerY);
			var tmpP:Point       = new Point();
			// 圆形区域内 向周围辐射
			var cornerExpand:int = size - 1;
			// 先求出圆形区域
			for (curX = centerX - cornerExpand; curX <= centerX + cornerExpand; curX++)
			{
				for (curY = centerY - cornerExpand; curY <= centerY + cornerExpand; curY++)
				{
					tmpP.x    = curX;
					tmpP.y    = curY;
					curRadius = MousebombMath.distanceOf2Point(centerP, tmpP);
					if (curRadius >= size) continue;
					if (curX < 0) continue;
					if (curY < 0) continue;
					if (curX > _curMapVO.terrainVerticlesX) continue;
					if (curY > _curMapVO.terrainVerticlesY) continue;
					mapVO.setNodeVal(curX,curY,type);
					// 派发事件
					dispatchWith(NotifyConst.MAP_NODE_VAL_CHANGED,false,{tileX:curX,tileY:curY,type:type});
				}
			}
		}

		// #pragma mark --  地形和刷		  ------------------------------------------------------------

		/** 地形刷/纹理刷大小 */
		public var brushSize:int          = 100;
		/** 地形刷强度 (一笔最高高度) */
		public var brushStrong:int        = 50;
		/** 纹理刷强度 0.01~1.00 */
		public var brushSplatPower:Number = 0.5;
		/** 柔和 (暂未实现) */
		public var brushSoftness:Number = 1.0;
		/** 地形刷 最高高度值 */
		public var brushHeightMax:Number  = TLMapVO.TERRAIN_HEIGHT_MAX;
		/** 地形刷 最低高度值 */
		public var brushHeightMin:Number  = TLMapVO.TERRAIN_HEIGHT_MIN;

		/** 新建地形 编辑器创建 用*/
		public function setupNewTerrain(terrainVerticlesX:int, terrainVerticlesY:int ,name:String ,heightMap:BitmapData =null):void
		{
			newMapVO();
			_curMapVO.name = name;
			if(heightMap)
			{
				// 有高度图
				_curMapVO.fromTerrainHeightBitmap(heightMap);
				_curMapVO.initSplatAlpha();
				_curMapVO.initEmptyZone();
			}else{
				// 无高度图 生成平坦的
				_curMapVO.terrainVerticlesX = terrainVerticlesX;
				_curMapVO.terrainVerticlesY = terrainVerticlesY;
				_curMapVO.initFlat();
			}
			dispatchWith(NotifyConst.MAP_VO_INITED);
		}

		/**高度刷抹匀
		 * 几个参数全是显示单位
		 * @param pxX 像素单位坐标
		 * @param pxZ 像素单位坐标
		 * @param pxRadius 半径
		 * */
		public function useHeightAvgBrush(pxX:Number, pxZ:Number, pxRadius:Number):void
		{
			// 像素坐标换算成顶点坐标
			var centerX:int = pxX / TLMapVO.TERRAIN_SCALE;
			var centerY:int = -pxZ / TLMapVO.TERRAIN_SCALE;
			var size:int    = pxRadius / TLMapVO.TERRAIN_SCALE;
			if (size < 1)size = 1;
			var curHeightAdd:Number;
			var curX:int;
			var curY:int;
			var curRadius:Number;
			var centerP:Point    = new Point(centerX, centerY);
			var tmpP:Point       = new Point();
			// 圆形区域内 向周围辐射均匀
			var cornerExpand:int = size - 1;
			// 先求出圆形区域
			// 求出平均值
			var avgHeight: Number = 0.0;
			var numHeight :uint = 0;
			for (curX = centerX - cornerExpand; curX <= centerX + cornerExpand; curX++)
			{
				for (curY = centerY - cornerExpand; curY <= centerY + cornerExpand; curY++)
				{
					tmpP.x    = curX;
					tmpP.y    = curY;
					curRadius = MousebombMath.distanceOf2Point(centerP, tmpP);
					if (curRadius >= size) continue;
					if (curX < 0) continue;
					if (curY < 0) continue;
					if (curX > _curMapVO.terrainVerticlesX) continue;
					if (curY > _curMapVO.terrainVerticlesY) continue;
					numHeight++;
					avgHeight+=_curMapVO.getHeight(curX, curY);
				}
			}
			if(numHeight==0) return;
			avgHeight = avgHeight / numHeight;
			// 采用平均值 对圆形区域遍历再次处理
			for (curX = centerX - cornerExpand; curX <= centerX + cornerExpand; curX++)
			{
				for (curY = centerY - cornerExpand; curY <= centerY + cornerExpand; curY++)
				{
					tmpP.x    = curX;
					tmpP.y    = curY;
					curRadius = MousebombMath.distanceOf2Point(centerP, tmpP);
					if (curRadius >= size) continue;
					if (curX < 0) continue;
					if (curY < 0) continue;
					if (curX > _curMapVO.terrainVerticlesX) continue;
					if (curY > _curMapVO.terrainVerticlesY) continue;
					var oldHeight : Number = _curMapVO.getHeight(curX, curY);
					var heightAdd :Number = avgHeight - oldHeight;
					curHeightAdd        = heightAdd * calcPower(curRadius, size);
					var toHeight:Number = oldHeight + curHeightAdd;
					if (toHeight > brushHeightMax)toHeight = brushHeightMax;
					if (toHeight < brushHeightMin)toHeight = brushHeightMin;
					_curMapVO.setHeight(curX, curY, toHeight);
				}
			}

			// 让对应tile处理变化
			_curMapVO.validateTileHeight();
		}

		/**
		 * 高度刷子刷一下
		 * 几个参数全是显示单位
		 * @param pxX 像素单位坐标
		 * @param pxZ 像素单位坐标
		 * @param heightAdd 像素高度 (+-2047.0)
		 * @param pxRadius 半径
		 * */
		public function useHeightBrush(pxX:Number, pxZ:Number, heightAdd:Number, pxRadius:Number):void
		{
			// 像素坐标换算成顶点坐标
			var centerX:int = pxX / TLMapVO.TERRAIN_SCALE;
			var centerY:int = -pxZ / TLMapVO.TERRAIN_SCALE;
			var size:int    = pxRadius / TLMapVO.TERRAIN_SCALE;
			if (size < 1)size = 1;
			var curHeightAdd:Number;
			var curX:int;
			var curY:int;
			var curRadius:Number;
			var centerP:Point    = new Point(centerX, centerY);
			var tmpP:Point       = new Point();
			// 圆形区域内 向周围辐射增高
			var cornerExpand:int = size - 1;
			// 先求出圆形区域
			for (curX = centerX - cornerExpand; curX <= centerX + cornerExpand; curX++)
			{
				for (curY = centerY - cornerExpand; curY <= centerY + cornerExpand; curY++)
				{
					tmpP.x    = curX;
					tmpP.y    = curY;
					curRadius = MousebombMath.distanceOf2Point(centerP, tmpP);
					if (curRadius >= size) continue;
					if (curX < 0) continue;
					if (curY < 0) continue;
					if (curX > _curMapVO.terrainVerticlesX) continue;
					if (curY > _curMapVO.terrainVerticlesY) continue;
					curHeightAdd        = heightAdd * calcPower(curRadius, size);
					var toHeight:Number = _curMapVO.getHeight(curX, curY) + curHeightAdd;
					if (toHeight > brushHeightMax)toHeight = brushHeightMax;
					if (toHeight < brushHeightMin)toHeight = brushHeightMin;
					_curMapVO.setHeight(curX, curY, toHeight);
					trace(StageFrame.renderIdx, "TLMapModel/useHeightBrush", curX, curY, curRadius, "+" + curHeightAdd);
				}
			}

			// 让对应tile处理变化
			_curMapVO.validateTileHeight();
		}

		/** 计算力度衰减 */
		[Inline]
		public static function calcPower(distance:Number, maxDistance:Number):Number
		{
			// distance越小 权重越接近1，否则越接近0
			return (maxDistance - distance) / maxDistance;
		}

		/**** 材质 ****/

		/** 当前刷子(选中)刷材质的层 低层的画的时候会同时抹掉高层的 */
		public var curTextureBrushLayerIndex:int = 1;

		/** 设置图层材质 */
		public function setLayerTexture(textureFile:String, layerIndex:int):void
		{
			if(textureFile==null || textureFile=="")
			{
				// 取消贴图 后面的往前排
				_curMapVO.textureFiles.splice(layerIndex,1);
			}else{
				// 设置贴图 不可以大于目前最大
				if(layerIndex > _curMapVO.textureFiles.length)
					layerIndex = _curMapVO.textureFiles.length;
				_curMapVO.textureFiles[layerIndex] = textureFile;
			}
			dispatchWith(NotifyConst.MAP_TERRAIN_TEXTURE_CHANGED, false);
		}

		/** 交换图层顺序  withAlpha带着alphamask走 */
		public function setLayerIndex(fromIndex:int, toIndex:int, withAlpha:Boolean):void
		{
			var tmp:String                    = _curMapVO.textureFiles[fromIndex];
			_curMapVO.textureFiles[fromIndex] = _curMapVO.textureFiles[toIndex];
			_curMapVO.textureFiles[toIndex]   = tmp;
			if (withAlpha && fromIndex>0 && toIndex>0)
				_curMapVO.splatAlphaTexture.switchRGBA(TLMapVO.layerIndexToSplatIndex(fromIndex), TLMapVO.layerIndexToSplatIndex(toIndex));
			dispatchWith(NotifyConst.MAP_TERRAIN_TEXTURE_CHANGED, false);
		}


		/**
		 * 使用纹理刷子刷一下
		 * @param layerIndex 图层 0~4 低层的绘制进去 高层的要抹掉
		 * @param pxX 像素单位坐标
		 * @param pxZ 像素单位坐标
		 * @param power 强度  0.0~1.0
		 * @param pxRadius 半径
		 * @param pxFRadius 羽化半径
		 * */
		public function useTextureBrush(layerIndex:int, pxX:Number, pxZ:Number, power:Number, pxRadius:Number, pxFRadius:Number):void
		{
			// 像素坐标换算成纹理坐标
			// 纹理splat采用的是最接近顶点阵列以上的2次幂阵列
			var pxX2TxtPosX:Number = _curMapVO.splatAlphaW / TLMapVO.TERRAIN_SCALE / _curMapVO.terrainVerticlesX;
			var pxY2TxtPosY:Number = _curMapVO.splatAlphaH / TLMapVO.TERRAIN_SCALE / _curMapVO.terrainVerticlesY;
			var centerX:int        = pxX * pxX2TxtPosX;
			var centerY:int        = -pxZ * pxY2TxtPosY;
			var radiusX:int        = pxRadius * pxX2TxtPosX;
			var radiusY:int        = pxRadius * pxY2TxtPosY;
			var fRadiusX:int       = pxFRadius * pxX2TxtPosX;
			var fRadiusY:int       = pxFRadius * pxY2TxtPosY;
			if (radiusX < 1)radiusX = 1;
			if (radiusY < 1)radiusY = 1;
			var curAlphaAdd:Number;
			var curX:int;
			var curY:int;
			var curRadius:Number;
			var curFRadius:Number;
			var centerP:Point     = new Point(centerX, centerY);
			var tmpP:Point        = new Point();
			// 圆形区域内 向周围辐射增高
			var cornerExpandX:int = radiusX - 1;
			var cornerExpandY:int = radiusY - 1;
			// 先求出圆形区域
			for (curX = centerX - cornerExpandX; curX <= centerX + cornerExpandX; curX++)
			{
				for (curY = centerY - cornerExpandY; curY <= centerY + cornerExpandY; curY++)
				{
					tmpP.x    = curX;
					tmpP.y    = curY;
					curRadius = MousebombMath.distanceOf2Point(centerP, tmpP);
					// 当前绘画半径 跟pxRadius +pxFRadius 比，超出的就不画
					// 超出pxRadius的部分， 和pxFRadius比，超出的就不画
					if (curRadius > radiusX) continue;
					if (curX < 0) continue;
					if (curY < 0) continue;
					if (curX > _curMapVO.splatAlphaW) continue;
					if (curY > _curMapVO.splatAlphaH) continue;
					curFRadius = curRadius - (radiusX - fRadiusX);
					if (curFRadius > 0)
					{
						// 外圈 羽化
						curAlphaAdd = (power * calcPower(curFRadius, fRadiusX));
//						trace(StageFrame.renderIdx,"TLMapModel/useTextureBrush",curFRadius , curAlphaAdd);
					}
					else
					{
						// 内圈 无羽化
						curAlphaAdd = power;
					}
					var newAlpha:Number;
					if(layerIndex>0)
					{
						// 对当前层 add ， 注意 地表层没有alpha
						newAlpha = _curMapVO.getAlpha(curX, curY, layerIndex) + curAlphaAdd;
						_curMapVO.setAlpha(curX, curY, layerIndex, newAlpha);
					}
					// 对更高层 sub
					 for (var i:int = layerIndex+1; i < TLMapVO.TEXTURES_MAX_LAYER; i++)
					 {
						 var oldAlpha :Number = _curMapVO.getAlpha(curX,curY , i);
						 if(oldAlpha==0.0)
							 continue;
						 newAlpha = oldAlpha - curAlphaAdd;
						 if(newAlpha<0.0) newAlpha = 0.0;
						 _curMapVO.setAlpha(curX,curY,i,newAlpha);
					 }
//					trace(StageFrame.renderIdx,"TLMapModel/useTextureBrush",curX,curY,layerIndex, "+"+curAlphaAdd , newAlpha);
				}
			}
			_curMapVO.splatAlphaTexture.commitChange();
		}



		// #pragma mark --  刚体  ------------------------------------------------------------
		/**[编辑用] 刚体对象添加 */
		public function addRigidBody( r : RigidBodyVO ):void
		{
			_curMapVO.rigidBodies.push(r);
		}

		/**[编辑用] 刚体对象删除 */
		public function delRigidBody(r:RigidBodyVO):void
		{
			var index : int = _curMapVO.rigidBodies.indexOf(r);
			if(index > -1 )
			{
				_curMapVO.rigidBodies.splice(index,1);
			}
		}


		// #pragma mark --  功能点  ------------------------------------------------------------
		public function addFuncPoint(vo:FuncPointVO):void
		{
			_curMapVO.funcPoints.push(vo);
		}

		public function delFuncPoint(vo:FuncPointVO):void
		{
			var index : int = _curMapVO.funcPoints.indexOf(vo);
			if(index>-1)
			{
				_curMapVO.funcPoints.splice(index,1);
			}
		}

		// #pragma mark --  保存  ------------------------------------------------------------
		public function saveMapData():ByteArray
		{
			var end :ByteArray = new ByteArray();
			// 版本号
			end.writeUnsignedInt( TLMapVO.SAVE_VERSION );
			// 写入地图名
			end.writeUTF(_curMapVO.name);
			//写入高度图
			end.writeShort(_curMapVO.terrainVerticlesX);
			end.writeShort(_curMapVO.terrainVerticlesY);
			for (var i:int = 0; i < _curMapVO.terrainHeightMapInt.length; i++)
			{
				var i1:int = _curMapVO.terrainHeightMapInt[i];
				end.writeShort( i1 );
			}
			//写入纹理
			trace(StageFrame.renderIdx,"[TLEditorMapModel]/saveMapData writeUnsignedInt",_curMapVO.splatAlphaTexture.exportByteArray().length , end.position);//1048576 206086
			end.writeUnsignedInt( _curMapVO.splatAlphaTexture.exportByteArray().length );
			end.writeBytes(_curMapVO.splatAlphaTexture.exportByteArray());
			 for (var i:int = 0; i < 5; i++)
			 {
				 end.writeUTF(_curMapVO.textureFiles[i])
			 }
			//写入刚体
			end.writeShort(_curMapVO.rigidBodies.length);
			for (var i:int = 0; i < _curMapVO.rigidBodies.length; i++)
			{
				var vo:RigidBodyVO = _curMapVO.rigidBodies[i];
				vo.exportToByteArray(end);
			}
			//写入模型
			end.writeShort(_curMapVO.entityGroupNames.length);
			for each (var groupName:String in _curMapVO.entityGroupNames)
			{
				var group:Vector.<RolePlaceVO> = _curMapVO.entityGroups[groupName];
				end.writeUTF(groupName);
				end.writeShort(group.length);
				trace(StageFrame.renderIdx,"[TLEditorMapModel]/saveMapData groupName:"+groupName+" num:"+group.length);
				for (var i:int = 0; i < group.length; i++)
				{
					group[i].exportToByteArray(end);
				}
			}
			// 区域
			for (var y:int = 0; y < _curMapVO.terrainVerticlesY; y++)
			{
				for (var x:int = 0; x < _curMapVO.terrainVerticlesX; x++)
				{
					end.writeByte( _curMapVO.getNodeVal(x,y));
				}
			}

			// 光照角度
			end.writeFloat(_curMapVO.sunLightDirection.x);
			end.writeFloat(_curMapVO.sunLightDirection.y);
			end.writeFloat(_curMapVO.sunLightDirection.z);
			// 写入功能点
			end.writeShort(_curMapVO.funcPoints.length);
			for (var i:int = 0; i < _curMapVO.funcPoints.length; i++)
			{
				var funcPointVO:FuncPointVO = _curMapVO.funcPoints[i];
				end.writeShort(funcPointVO.tileX);
				end.writeShort(funcPointVO.tileY);
				end.writeByte(funcPointVO.type);
			}
			// 写入天空盒
			end.writeUTF(_curMapVO.skyboxTextureName);

			// 压缩
			end.compress();
			return end;
		}

		public function saveMapXMLData():ByteArray
		{
			/*<?xml version='1.0' encoding='UTF-8' ?>
			 <setting>
			 <width>6656</width>
			 <height>7168</height>
			 <startpoint>5447,5203</startpoint>
			 <point></point>
			 <wizard></wizard>
			 </setting>*/
			var xmlStr:String     = "<?xml version='1.0' encoding='UTF-8' ?>\n<setting>";
			xmlStr += "\n			 <width>" + _curMapVO.terrainVerticlesX * TLMapVO.TERRAIN_SCALE + "</width>";
			xmlStr += "\n			 <height>" + _curMapVO.terrainVerticlesY * TLMapVO.TERRAIN_SCALE + "</height>";
			//功能点
			var startpoint:String = "";
			for (var i:int = 0; i < _curMapVO.funcPoints.length; i++)
			{
				var vo:FuncPointVO = _curMapVO.funcPoints[i];
				if (vo.type == FunctionPointType.START)
				{
					startpoint = (vo.tileX+.5) * TLMapVO.TERRAIN_SCALE + "," + (vo.tileY+.5) * TLMapVO.TERRAIN_SCALE;
				}
			}
			xmlStr += "\n			 <startpoint>"+startpoint+"</startpoint>";
			// 区域
			xmlStr += "\n			 <point>";
			var nodes :Vector.<int> = new <int>[];
			for (var y:int = 0; y < _curMapVO.terrainVerticlesY; y++)
			{
				for (var x:int = 0; x < _curMapVO.terrainVerticlesX; x++)
				{
					nodes .push( _curMapVO.getNodeVal(x,y) );
				}
			}
			xmlStr+= nodes.join(",");
			xmlStr += "\n			 </point>";

			xmlStr += "\n			 <wizard>";
			var entities :Vector.<String> = new Vector.<String>();
			for each (var groupName:String in _curMapVO.entityGroupNames)
			{
				var group:Vector.<RolePlaceVO> = _curMapVO.entityGroups[groupName];
				for (var i:int = 0; i < group.length; i++)
				{
					entities.push(
							group[i].wizardId+","+group[i].x+","+(0-group[i].z)+"," +group[i].y+"," +group[i].rotationY
					);
				}
			}
			xmlStr+= entities.join(",");
			xmlStr += "\n			 </wizard>";

			xmlStr += "\n</setting>";

			var end:ByteArray = new ByteArray();
			end.writeUTFBytes(xmlStr);
			return end;

		}

	}
}
