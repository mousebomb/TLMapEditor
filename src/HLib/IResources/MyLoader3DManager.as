package HLib.IResources
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import HLib.IResources.load.LoaderParam;
	import HLib.IResources.load.LoaderTaskParam;
	import HLib.Tool.MyError;

	import tl.core.IResourceKey;

	import tool.StageFrame;
	
	/**
	 * 3D加载管理类
	 * @author 李舒浩
	 */	
	public class MyLoader3DManager extends EventDispatcher
	{
		private static var _myLoader3DManager:MyLoader3DManager;
		
		private var _loader:LoaderManager;
		
		private var _typeToExt:Dictionary = new Dictionary();
		
		public function MyLoader3DManager()
		{
			if(_myLoader3DManager)
			{
				throw new MyError();
			}
		
			_typeToExt[IResourceKey.Suffix_MD5Mesh] = IResourceKey.resType_MD5Mesh;
			_typeToExt[IResourceKey.Suffix_ATF] = IResourceKey.resType_Texture;
			_typeToExt[IResourceKey.Suffix_MD5Anim] = IResourceKey.resType_AnimNode;
			_typeToExt[IResourceKey.Suffix_Effect] = IResourceKey.resType_Effect;
			/*
			_typeToExt[IResourceKey.Suffix_SkeletonClipNode] = IResourceKey.resType_AnimNode;
			_typeToExt[IResourceKey.Suffix_SkeletonAnimationSet] = IResourceKey.resType_AnimNode;
			_typeToExt[IResourceKey.Suffix_Skeleton] = IResourceKey.resType_AnimNode;
			*/
			_loader = LoaderManager.inst;
			_myLoader3DManager = this;
		}
		
		public static function getInstance():MyLoader3DManager
		{
			return _myLoader3DManager ||= new MyLoader3DManager();
		}
		
		public function addTask(taskKey:String, taskArgs:Array, finishFun:Function = null, errFun:Function = null, progressFun:Function = null, priority:uint = LoaderManager.NORMAL):void
		{
			var taskParam:LoaderTaskParam = new LoaderTaskParam();
			taskParam.key = taskKey;
			taskParam.finishFun.addFun(finishFun);
			taskParam.errFun.addFun(errFun);
			taskParam.progressFun.addFun(progressFun);
			
			var isCache:Boolean = true;
			var isExist:Boolean;
			var tmpKey:String;
			for each (var paramL:Array in taskArgs)
			{
				tmpKey = LoaderParam.generatePathKey(paramL[1], paramL[2], paramL[0]);
				
				if (paramL[2] == IResourceKey.Suffix_MD5Mesh)
				{
					isExist = IResourcePool.getInstance().hasResourceByType(tmpKey, IResourceKey.resType_MD5Mesh);
					if (isExist)
					{
						isExist = IResourcePool.getInstance().hasResourceByType(tmpKey, IResourceKey.resType_AnimSet);
						if (isExist)
						{
							isExist = IResourcePool.getInstance().hasResourceByType(tmpKey, IResourceKey.resType_Skeleton);
						}
					}
				}
				else
				{
					isExist = IResourcePool.getInstance().hasResourceByType(tmpKey, _typeToExt[paramL[2]]);
				}
				
				if (isExist == false)
				{
					var param:LoaderParam = new LoaderParam();//ObjectPools.getLoaderParam();
					param.state = LoaderParam.NOT_LOADED;
					param.filePath = paramL[0];
					param.filename = paramL[1];
					param.fileExt = paramL[2];
					param.loadCls = MyLoader3D;
					//					param.taskParam = taskParam;
					isCache = false;
					
					taskParam.params.push(param);
				}
			}
			
			if (isCache)
			{
				_taskKeys.push(taskParam);
				StageFrame.addNextFrameFun(dispatchComplete);
			}
			else
			{
				_loader.addTask(taskParam, priority);
			}
		}
		
		private var _taskKeys:Vector.<LoaderTaskParam> = new Vector.<LoaderTaskParam>();
		
		private function dispatchComplete():void
		{
			for each (var taskParam:LoaderTaskParam in _taskKeys)
			{
				taskParam.finishFun.exec();
				dispatchEvent(new IResourceEvent(IResourceEvent.ResourceTaskComplete + taskParam.key, taskParam.key));
			}
			_taskKeys.length = 0;
		}
		
		
		public override function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			_loader.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public override function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			_loader.removeEventListener(type, listener, useCapture);
		}
		
		override public function dispatchEvent(event:Event):Boolean
		{
			return _loader.dispatchEvent(event);
		}
		
		public override function hasEventListener(type:String):Boolean
		{
			return _loader.hasEventListener(type);
		}
		
		public override function willTrigger(type:String):Boolean
		{
			return _loader.willTrigger(type);
		}
	}
}