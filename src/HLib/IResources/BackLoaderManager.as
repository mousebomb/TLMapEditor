package HLib.IResources
{
	import flash.utils.Dictionary;
	
	import HLib.IResources.load.LoaderParam;
	import HLib.IResources.load.LoaderTaskParam;
	import HLib.MapBase.HMapData;
	import HLib.Tool.MyError;
	import HLib.WizardBase.WizardAction;

	import tl.core.IResourceKey;

	public class BackLoaderManager 
	{
		private static var _inst:BackLoaderManager;
		private static var _caches:Dictionary = new Dictionary();
		
		private static var _backCaches:Dictionary = new Dictionary();
		
		public function addCache(key:String):void
		{
			_caches[key] = true;
		}
		
		public function hasCache(key:String):Boolean
		{
			return _caches[key];
		}
		
		public function addBackCache(key:String):void
		{
			_backCaches[key] = true;
		}
		
		public function hasBackCache(key:String):Boolean
		{
			return _backCaches[key];
		}
		
		private var _loader:LoaderManager;
		
		public function BackLoaderManager()
		{
			if(_inst)
			{
				throw new MyError();
			}
			
			_loader = LoaderManager.inst;
			_inst = this;
		}
		
		public static function get inst():BackLoaderManager
		{
			return _inst ||= new BackLoaderManager();
		}
		
		public function addTask(params:Vector.<LoaderParam>):void
		{
			var taskParam:LoaderTaskParam = new LoaderTaskParam();
			taskParam.key = "";
			for each (var param1:LoaderParam in params)
			{
				if (hasBackCache(param1.resKey) == false)
				{
					taskParam.params.push(param1);
				}
			}
			if (taskParam.params.length)
			{
				_loader.addTask(taskParam, LoaderManager.BACK);
			}
		}
		
		private var _wizardAction:WizardAction = new WizardAction();
		public function addActorVec(actionId:int):void
		{
			return;
			_wizardAction.refresh(actionId.toString());
			
			_tmpParams.length = 0;
			var param:LoaderParam = new LoaderParam();
			param.state = LoaderParam.NOT_LOADED;
			param.filePath = _wizardAction.meshResFileName;
			param.filename = _wizardAction.meshResName;
			param.fileExt = IResourceKey.Suffix_MD5Mesh;
			param.loadCls = BackLoader;
			_tmpParams.push(param);
			
			param = new LoaderParam();
			param.state = LoaderParam.NOT_LOADED;
			param.filePath = _wizardAction.materialResFlieName;
			param.filename = _wizardAction.materialResName;
			param.fileExt = IResourceKey.Suffix_ATF;
			param.loadCls = BackLoader;
			_tmpParams.push(param);
			
			if(_wizardAction.anim_Stand != "0")
			{
				param = new LoaderParam();
				param.state = LoaderParam.NOT_LOADED;
				param.filePath = _wizardAction.anim_FileName;
				param.filename = _wizardAction.anim_Stand;
				param.fileExt = IResourceKey.Suffix_MD5Anim;
				param.loadCls = BackLoader;
				_tmpParams.push(param);
			}
			if(_wizardAction.anim_Run != "0")
			{
				param = new LoaderParam();
				param.state = LoaderParam.NOT_LOADED;
				param.filePath = _wizardAction.anim_FileName;
				param.filename = _wizardAction.anim_Run;
				param.fileExt = IResourceKey.Suffix_MD5Anim;
				param.loadCls = BackLoader;
				_tmpParams.push(param);
			}
			if(_wizardAction.anim_RideStand != "0")
			{
				param = new LoaderParam();
				param.state = LoaderParam.NOT_LOADED;
				param.filePath = _wizardAction.anim_FileName;
				param.filename = _wizardAction.anim_RideStand;
				param.fileExt = IResourceKey.Suffix_MD5Anim;
				param.loadCls = BackLoader;
				_tmpParams.push(param);
			}
			if(_wizardAction.anim_RideRun != "0")
			{
				param = new LoaderParam();
				param.state = LoaderParam.NOT_LOADED;
				param.filePath = _wizardAction.anim_FileName;
				param.filename = _wizardAction.anim_RideRun;
				param.fileExt = IResourceKey.Suffix_MD5Anim;
				param.loadCls = BackLoader;
				_tmpParams.push(param);
			}
			addTask(_tmpParams);
			_tmpParams.length = 0;
		}
		
		public function addUI(filePath:String, fileName:String, fileExt:String):void
		{
			var tmpParam:LoaderParam;
			tmpParam = new LoaderParam();
			tmpParam.state = LoaderParam.NOT_LOADED;
			tmpParam.filePath = filePath;
			tmpParam.filename = fileName;
			tmpParam.fileExt = fileExt;
			tmpParam.loadCls = BackLoader;
			_tmpParams.push(tmpParam);
			
			addTask(_tmpParams);
			_tmpParams.length = 0;
		}
		/**开启界面后台加载*/
		public function addBackgroundUILoader():void
		{
			var isExist:Boolean;
			var fileName:String;
			var sourceName:String;
			var vector:Vector.<String> = new <String>['source_toolBar_1_0', 'source_toolBar_1_1', 'source_toolBar_16', 'source_toolBar_12', 'source_toolBar_3', 
				'source_toolBar_4', 'source_toolBar_5_0', 'source_toolBar_5_1', 'source_toolBar_7', 'source_toolBar_8', 'source_toolBar_9', 'source_toolBar_10',
				'source_activityIcon_4', 'source_toolBar_11', 'source_toolBar_14'];
			var leng:int = vector.length;
			var tmpParam:LoaderParam;
			for(var i:int=0; i<leng; i++)
			{
				fileName = vector[i];
				tmpParam = new LoaderParam();
				tmpParam.state = LoaderParam.NOT_LOADED;
				tmpParam.filePath = 'Bitmap';
				tmpParam.filename = fileName;
				tmpParam.fileExt = '.atf';
				tmpParam.loadCls = BackLoader;
				_tmpParams.push(tmpParam);
			}
			addTask(_tmpParams);
			_tmpParams.length = 0;
		}
		
		private var _tmpParams:Vector.<LoaderParam> = new Vector.<LoaderParam>();
		public function addMap(mapData:HMapData):void
		{
			return;
			var col:int = mapData.mapCols;
			var row:int = mapData.mapRows;
			var mapName:String = mapData.mapResPathName;
			var tmpParam:LoaderParam;
			
			var tmpName:String;
			var tmpUrl:String;
			for (var i:int = 0; i < row; ++i)
			{
				for (var j:int = 0; j < col; ++j)
				{
					tmpName = mapName + "_" + (i.toString().length == 1? "0" + i: i.toString()) + "_" + (j.toString().length == 1? "0" + j: j.toString());
					
					tmpParam = new LoaderParam();
					tmpParam.state = LoaderParam.NOT_LOADED;
					tmpParam.filePath = mapName;
					tmpParam.filename = tmpName;
					tmpParam.fileExt = IResourceKey.Suffix_ATF;
					tmpParam.loadCls = BackLoader;
					
					if (hasBackCache(tmpParam.resKey) == false)
					{
						_tmpParams.push(tmpParam);
					}
				}
			}
			
			addTask(_tmpParams);
			_tmpParams.length = 0;
		}
	}
}