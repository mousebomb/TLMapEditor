package away3DExtend
{
	/**
	 * 自定义Mesh类
	 * @author 李舒浩
	 */	
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	
	import away3d.arcane;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.core.base.Object3D;
	import away3d.entities.Mesh;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.materials.methods.ColorTransformMethod;
	import away3d.textures.BitmapTexture;
	import away3d.utils.Cast;
	
	use namespace arcane;
	
	public class MeshExtend extends Mesh
	{
		private var _textureMaterial:TextureMaterialExtend;
		private var _repeat:Boolean = false;
		private var _myTextureMaterial:TextureMaterialExtend;
		
		public function MeshExtend(geometry:Geometry, material:MaterialBase=null)
		{
			super(geometry, material);
			
//			_outlineMethod = new OutlineMethod(0xff0000, 2, false);
			
			_colorTransform = new ColorTransform(1, 0.7, 0.7, 1, 100);
			_colorMethod = new ColorTransformMethod();
			_colorMethod.colorTransform = _colorTransform;
			
			castsShadows = false;
		}
		
		private var _colorTransform:ColorTransform;
		
		/**
		 * 设置贴图
		 * @param value
		 */		
		public function set meshMaterial(value:BitmapData):void
		{
			_textureMaterial ||= new TextureMaterialExtend(Cast.bitmapTexture(value));
			BitmapTexture(_textureMaterial.texture).bitmapData = value;
			this.material = _textureMaterial;
			//设置是否平铺
			repeat = _repeat;
		}
		/**
		 * 设置法线贴图
		 * @param value
		 */		
		public function set normalMap(value:BitmapData):void
		{
			_textureMaterial ||= new TextureMaterialExtend();
			_textureMaterial.normalMap = Cast.bitmapTexture(normalMap);
			this.material = _textureMaterial;
		}
		/**
		 * 是否平铺
		 * @param value	: 是否平铺
		 */		
		public function set repeat(value:Boolean):void	
		{  
			_repeat = value;
			if(!_textureMaterial)
			{
				return;
			}
			_textureMaterial.repeat = value;  
		}
		public function get repeat():Boolean			
		{
			return _repeat; 
		}
		/**
		 * 设置边线样式
		 * @param $color	: 边线颜色
		 * @param $size		: 边线大小
		 */		
		public function setLineStyle($color:uint):void//, $size:Number = 1	
		{
			var tmpVal:int;
			tmpVal = ($color >> 16) && 0xFF;
			_colorTransform.redOffset = (255 - tmpVal); 
			tmpVal = ($color && 0xff00) >> 8; 
			_colorTransform.greenOffset = (255 - tmpVal); 
			tmpVal = $color && 0xff; 
			_colorTransform.blueOffset = (255 - tmpVal); 
//			_outlineMethod.outlineColor = $color;
//			_outlineMethod.outlineSize = $size;
		}
		
		
		/**
		 * 是否显示边线
		 * @param value	: true:显示 false:不显示
		 */		
		public function set isShowlineMethod(value:Boolean):void
		{
			return;
			_isShowlineMethod = value;
			if(!this.material)
			{
				return;
			}
			if( !(this.material is TextureMaterial) ) 
			{
				return;
			}
			
			if(_isShowlineMethod)
			{
				if(!TextureMaterial(this.material).hasMethod(_colorMethod))
				{
					TextureMaterial(this.material).addMethod(_colorMethod);
				}
			}
			else
			{
				if(TextureMaterial(this.material).hasMethod(_colorMethod))
				{
					TextureMaterial(this.material).removeMethod(_colorMethod);
				}
			}
		}
		
		public function get isShowlineMethod():Boolean 
		{ 
			return _isShowlineMethod; 
		}
		private var _isShowlineMethod:Boolean = false;
//		private var _outlineMethod:OutlineMethod;
		private var _colorMethod:ColorTransformMethod;
		
		/**
		 * 重写设置贴图,除了贴图外再设置边线
		 * @param value	: 贴图
		 */		
		override public function set material(value:MaterialBase):void
		{
			super.material = value;
			
			isShowlineMethod = isShowlineMethod;
		}
		/**
		 * 重写dispose()
		 */		
		override public function dispose():void
		{
			super.dispose();
			/*
			if(_outlineMethod) 
			{
				_outlineMethod.dispose();
			}
			_outlineMethod = null;
			*/
			if(_colorMethod) 
			{
				_colorMethod.dispose();
			}
			_colorMethod = null;
			
			
			if (_textureMaterial)
			{
				_textureMaterial.dispose();
				_textureMaterial = null;
			}
		}
		/**
		 * 克隆一个MeshExtend对象
		 */
		override public function clone():Object3D
		{
			var clone:MeshExtend = new MeshExtend(_geometry, _material);
			clone.transform = transform;
			clone.pivotPoint = pivotPoint;
			clone.bounds = _bounds.clone();
			clone.name = name;
			clone.castsShadows = castsShadows;
			clone.shareAnimationGeometry = shareAnimationGeometry;
			clone.mouseEnabled = this.mouseEnabled;
			clone.mouseChildren = this.mouseChildren;
			//this is of course no proper cloning
			//maybe use this instead?: http://blog.another-d-mention.ro/programming/how-to-clone-duplicate-an-object-in-actionscript-3/
			clone.extra = this.extra;
			
			var len:int = _subMeshes.length;
			for (var i:int = 0; i < len; ++i)
				clone._subMeshes[i]._material = _subMeshes[i]._material;
			
			len = numChildren;
			for (i = 0; i < len; ++i)
				clone.addChild(ObjectContainer3D(getChildAt(i).clone()));
			
			if (_animator)
				clone.animator = _animator.clone();
			
			return clone;
		}
		
//		/**
//		 * 初始化拖尾(A点到B点获得拖尾距离)
//		 * @param $skeleton	: 模型骨骼
//		 * @param $startTag	: 拖尾起始骨骼点名(骨骼A点)
//		 * @param $endTag	: 拖尾结束骨骼点名(骨骼B点)
//		 * @param $texture	: 拖尾光材质
//		 */		
//		public function initTaril($skeleton:SkeletonExtend, $startTag:String, $endTag:String, $texture:BitmapTexture):void
//		{
//			if(_isInitTaril) return;
//			_isInitTaril = true;
//			
//			_skeleton = $skeleton;
//			_startTag = $startTag;
//			_endTag = $endTag;
//			_tarilTextureMaterial = new TextureMaterial($texture);
//			
//			_startPoseMat3D = _skeleton.jointMatrix3DFromName(_startTag);
//			_endPoseMat3D = _skeleton.jointMatrix3DFromName(_endTag);
//			_startPosition = _startPoseMat3D.position;
//			_endPosition = _endPoseMat3D.position;
//		}
//		private var _isInitTaril:Boolean = false;
//		private var _skeleton:SkeletonExtend;
//		private var _startTag:String;
//		private var _endTag:String;
//		private var _tarilTextureMaterial:TextureMaterial;	//拖尾光贴图
//		private var _maxSamples:int = 60;					//最大显示mesh数量
//		
//		/** 开启拖尾 **/
//		public function startTaril():void  {  _isTaril = true;  }
//		/** 停止拖尾 **/
//		public function stopTaril():void
//		{
//			if(!_isTaril)return;
//			_isTaril = false;
//			if(_samplingMeshV)
//			{
//				for(var i:int = 0; i < _samplingMeshV.length; i++)
//				{
//					var mesh:Mesh = _samplingMeshV[i];
//					if(mesh && mesh.parent)
//					{
//						mesh.parent.removeChild(mesh);
//						mesh.dispose();
//					}
//				}
//			}
//		}
//		override public function onEnterFrame():void
//		{
//			super.onEnterFrame();
//			//执行拖尾上传点操作
//			samplingMesh();
//		}
//		
//		private var _upStartVec3D:Vector3D;
//		private var _upEndVec3D:Vector3D;
//		
//		private var _startPoseMat3D:Matrix3D;
//		private var _endPoseMat3D:Matrix3D;
//		private var _startPosition:Vector3D;
//		private var _endPosition:Vector3D;
//		
//		private function samplingMesh():void
//		{
//			if(!_isInitTaril) return;
//			
//			//获得当前mesh所谓舞台的位置
//			var startVec3D:Vector3D = this.sceneTransform.transformVector(_startPosition);
//			var endVec3D:Vector3D = this.sceneTransform.transformVector(_endPosition);
//			//判断上一个点位置,做相减处理,获得位移值
//			var vec3D:Vector3D
//			if(_upStartVec3D)
//			{
//				vec3D = startVec3D.subtract(_upStartVec3D);
//				_upEndVec3D = startVec3D;
//				startVec3D = _startPoseMat3D.position.add(vec3D);
//			}
//			else
//			{
//				_upStartVec3D = startVec3D;
//				startVec3D = _startPoseMat3D.position;
//			}
//			if(_upEndVec3D)
//			{
//				vec3D = endVec3D.subtract(_upEndVec3D);
//				_upEndVec3D = endVec3D;
//				endVec3D = _endPoseMat3D.position.add(vec3D);
//			}
//			else
//			{
//				_upEndVec3D = endVec3D;
//				endVec3D = _endPoseMat3D.position;
//			}
//			_tempV.push(startVec3D);
//			_tempV.push(endVec3D);
//			if(_tempV.length >= 4 && _tempV.length % 2 == 0)
//			{
//				interpolation();
//				_tempV.shift();
//				_tempV.shift();
//			}
//			var i:int;
//			var j:int;
//			var len:int;
//			if(_posV.length > 0)
//			{
//				len = _posV.length/2 - 1;
//				for( i = 0; i < len; i++)
//				{
//					var vData:Vector.<Number> = new Vector.<Number>();
//					for(j = 0; j < 4; j++)
//					{
//						vData.push(_posV[i*2 + j].x, _posV[i*2 +j].y, _posV[i*2 + j].z); 
//					}
//					
//					var geometry:SubGeometry = new SubGeometry();
//					geometry.updateVertexData(vData);
//					geometry.updateIndexData(Vector.<uint>([0,1,3,0,2,3]));
//					var geo:Geometry = new Geometry();
//					geo.addSubGeometry(geometry);
//					var tempmesh:MeshExtend = new MeshExtend(geo, _tarilTextureMaterial);
//					this.addChild(tempmesh);
//					_samplingMeshV.push(tempmesh);
//				}
//			}
//			
//			len = _samplingMeshV.length;
//			for (i = 0; i < len; i++) 
//			{
//				var uvData:Vector.<Number> = Vector.<Number>([
//																1-i/_maxSamples, 0
//																,1-i/_maxSamples, 1 
//																,1-(i+1)/_maxSamples, 0 
//																,1-(i+1)/_maxSamples, 1
//															]);
//				SubGeometry(_samplingMeshV[i].geometry.subGeometries[0]).updateUVData(uvData);
//			}
//			
//			if(len > _maxSamples)
//			{
//				var loop:int = _samplingMeshV.length - _maxSamples;
//				while(loop--)
//				{
//					var clearMesh:Mesh = _samplingMeshV.shift();
//					this.removeChild(clearMesh);
//					clearMesh.geometry.dispose();
//					clearMesh.dispose();
//				}
//			}
//			
//			len = _posV.length;
//			if(len)
//			{
//				_tempV[0] = _posV[len - 2];
//				_tempV[1] = _posV[len - 1];
//				_posV.length = 0;
//			}   
//		}
//		/**
//		 * 插值 
//		 */    
//		private function interpolation():void
//		{
//			var s1:Vector3D = _tempV[0];
//			var e1:Vector3D = _tempV[1];
//			var s2:Vector3D = _tempV[2];
//			var e2:Vector3D = _tempV[3];
//			
//			if(isNaN(_weaponDis))
//				_weaponDis = Vector3D.distance(s1, e1);
//			
////			if(s1.nearEquals(s2, 10) || e1.nearEquals(e2, 10))
////			{
////				_posV = _tempV.concat();
////				return;
////			}
//			
//			var v1:Vector.<Vector3D> = Vector3DUtils.divide(s1, s2, _divide);
//			var v2:Vector.<Vector3D> = Vector3DUtils.divide(e1, e2, _divide);
//			for(var i:int = 0; i < _divide + 1; i++)
//			{
//				_posV.push(v1[i]);
//				_posV.push(getEndVector3D(v1[i], v2[i], _weaponDis));
//			}
//		}
//		private function getEndVector3D(p1:Vector3D, p2:Vector3D, mDistance:Number ):Vector3D
//		{
//			var v:Vector3D = new Vector3D();
//			var distance:Number = Vector3D.distance(p1, p2);
//			var theta:Number = Math.asin((p2.z-p1.z)/distance);
//			
//			v.x = p1.x+ ((mDistance/Math.cos(theta))/distance)*(p2.x-p1.x);
//			v.y = p1.y+ ((mDistance/Math.cos(theta))/distance)*(p2.y-p1.y);
//			//TODO: z轴变化 会导致过度变形 
//			v.z = p2.z;//p1.z+ ((mDistance/Math.cos(theta))/distance)*(p2.z-p1.z);
//			return v;
//		}
//		
//		private var _tempV:Vector.<Vector3D> = new Vector.<Vector3D>();
//		private var _posV:Vector.<Vector3D> = new Vector.<Vector3D>();
//		private var _samplingMeshV:Vector.<MeshExtend> = new Vector.<MeshExtend>();// 采样
//		private var _weaponDis:Number;
//		private var _divide:int = 8;
//		private var _isTaril:Boolean = false;							//是否开始拖尾效果
	}
}