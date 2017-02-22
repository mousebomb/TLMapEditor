package tl.mapeditor.ui.controls {
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	
	public interface ISceneRepresentation {
		function get representation():Mesh;
		function get sceneObject():ObjectContainer3D;

		function get visible():Boolean;
		function set visible(value:Boolean):void;
		
		function updateRepresentation():void;
	}
}
