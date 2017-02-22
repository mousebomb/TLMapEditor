/**
 * Created by gaord on 2017/2/20.
 */
package tl.mapeditor.ui3d
{
	import away3d.bounds.AxisAlignedBoundingBox;
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Entity;
	import away3d.entities.Mesh;
	import away3d.entities.SegmentSet;
	import away3d.events.MouseEvent3D;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.LineSegment;
	import away3d.primitives.SphereGeometry;
	import away3d.primitives.WireframeCube;

	import flash.geom.Vector3D;

	import tl.core.terrain.TileView;
	import tl.mapeditor.ui.controls.Gizmo3DBase;

	public class MousePointTrack extends ObjectContainer3D
	{
		private var _locationTracer:Mesh;
		private var _normalTracer:SegmentSet;

		// 显示对象外框aabb
		private var _aabb:WireframeCube;
		public function MousePointTrack()
		{
			super();

			// To trace picking positions.
			_locationTracer = new Mesh( new SphereGeometry( 5 ), new ColorMaterial( 0x00FF00 ) );
			_locationTracer.mouseEnabled = _locationTracer.mouseChildren = false;
//			_locationTracer.visible = false;
			addChild( _locationTracer );

			// To trace picking normals.
			_normalTracer = new SegmentSet();
			_normalTracer.mouseEnabled = _normalTracer.mouseChildren = false;
			var lineSegment:LineSegment = new LineSegment( new Vector3D(), new Vector3D(), 0xFFFFFF, 0xFFFFFF, 3 );
			_normalTracer.addSegment( lineSegment );
//			_normalTracer.visible = false;
			addChild( _normalTracer );

			//
			_aabb = new WireframeCube(1,1,1,0x0000FF,2);
			addChild(_aabb);
		}

		/** 鼠标移动时更新指针位置 */
		public function update(event:MouseEvent3D):void
		{
			// Update tracers.
			_locationTracer.position = event.scenePosition;
			_normalTracer.position = _locationTracer.position;
			var normal:Vector3D = event.sceneNormal.clone();
			normal.scaleBy( 25 );
			var lineSegment:LineSegment = _normalTracer.getSegment( 0 ) as LineSegment;
			lineSegment.end = normal.clone();
		}
		/** 鼠标移动和移出实体时更新AABB框 */
		public function updateAABB(event:MouseEvent3D):void
		{
			if(event == null)
			{
				_aabb.visible = false;
				return;
			}
			//
			var obj:Entity = event.object as Entity;
			if(obj && obj.mouseEnabled && !(obj is TileView) && (obj.parent.name!="gizmoContent"))
			{
				var objAABB:AxisAlignedBoundingBox=obj.worldBounds as AxisAlignedBoundingBox;

				_aabb.scaleX = Math.max(objAABB.halfExtentsX*2, 0.001);
				_aabb.scaleY = Math.max(objAABB.halfExtentsY*2, 0.001);
				_aabb.scaleZ = Math.max(objAABB.halfExtentsZ*2, 0.001);
				_aabb.x = (objAABB.max.x + objAABB.min.x) * .5;
				_aabb.y = (objAABB.max.y + objAABB.min.y) * .5;
				_aabb.z = (objAABB.max.z + objAABB.min.z) * .5;
				_aabb.visible = true;
			}else{
				_aabb.visible = false;
			}
		}
	}
}
