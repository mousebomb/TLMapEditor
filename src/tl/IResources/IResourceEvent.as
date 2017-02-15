package tl.IResources
{
	import flash.events.Event;

	public class IResourceEvent extends Event
	{
		public var data:Object;
		
		public static const AddAsk:String="AddAsk";
		public static const AddTemp:String="AddTemp";
		public static const Complete:String="Complete";
		public static const Error:String="Error";
		public static const GetResourceComplete:String="GetResourceComplete";
		
		public static const MeshComplete:String="MeshComplete";
		public static const MaterialComplete:String="MaterialComplete";
		public static const SkeletonClipNodeComplete:String="SkeletonClipNodeComplete";
		public static const SkeletonAnimationSetComplete:String="SkeletonAnimationSetComplete";
		public static const SkeletonComplete:String="SkeletonComplete";
		public static const ParticleGroupComplete:String="ParticleGroupComplete";
		public static const RegisterComplete:String="RegisterComplete";
		
		public function IResourceEvent(type:String, object:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data=object;
			super(type,bubbles,cancelable);			
		}
	}
}