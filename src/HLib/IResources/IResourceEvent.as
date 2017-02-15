package HLib.IResources
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
		public static const ResourceComplete:String = "ResourceComplete";	//资源全部加载完成
		public static const UIResourceComplete:String = "UIResourceComplete";	//UI资源加载完成
		public static const ResourceTaskComplete:String = "ResourceTaskComplete";	//批量资源下载任务全部加载完成
		
		public var isFinish:Boolean;
		public function IResourceEvent(type:String, object:Object = null, finish:Boolean = true, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = object;
			isFinish = finish;
			super(type,bubbles,cancelable);			
		}
	}
}