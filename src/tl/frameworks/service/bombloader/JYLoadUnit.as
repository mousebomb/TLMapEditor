package tl.frameworks.service.bombloader
{
    import away3d.textures.ATFCubeTexture;

    import tl.core.IResourceKey;

	import away3DExtend.E_MD5AnimParser;
	import away3DExtend.E_MD5MeshParser;

	import away3d.events.LoaderEvent;
	import away3d.loaders.AssetLoader;
	import away3d.loaders.parsers.ParserBase;
	import away3d.loaders.parsers.ParticleGroupParser;
	import away3d.textures.ATFTexture;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
     * @author rhett
     */
    public class JYLoadUnit
    {
        /**
         * 回调函数字典 ； key是资源;val是数组of FunctionVO。
         *  一个资源加载完成要超前把排队的同一个资源的回调也调用。所以这里回调是按资源来的。
         */
        private var _callLaterDic:Dictionary;

        /**
         * 加载器
         */
        private var _urlLoader:URLLoader;

        private var _currentRequest:URLRequest;

        private var _currentReqObj:LoadQueueItemVO;

        // 有优先级排序
        private var _downloadQueue:Vector.<LoadQueueItemVO>;

        private var _pause:Boolean;

        /**
         * 当前下载速度
         */
        public var currentSpeed:Number              = 0;

        /**
         * 累计下载流量 Bytes
         */
        public var totalLoaded:Number               = 0.0;

        /**
         * 累计已下载完成流量 Bytes
         */
        public var totalCompleteBytes:Number        = 0.0;

        public var currentBytesLoaded:Number;

        public var currentBytesTotal:Number;

        private var startTime:uint;

        private var startDecodeTime:uint;

        /** 已经下载的缓存
         *
         * */
        public static var imageCache:Dictionary     = new Dictionary();

        /**
         * class和bitmap在已经urlloader加载完毕但没有Loader完的时候的状态，为避免重复启动urlloader用
         */
        private static var cacheDecoding:Dictionary = new Dictionary();

        private var _onAllLoaderComplete:Function;

        public function JYLoadUnit()
        {
            init();
        }

        public function init():void
        {
			trace("创建新LoadUnit");
            _callLaterDic = new Dictionary();
            _downloadQueue = new Vector.<LoadQueueItemVO>();
            _urlLoader = new URLLoader();
            _currentRequest = new URLRequest();
            _urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
            _urlLoader.addEventListener(Event.COMPLETE, onDataLoadComplete);
            _urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
            _urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            _urlLoader.addEventListener(Event.OPEN, onOpen);
        }

        private function onOpen(event:Event):void
        {
            currentBytesLoaded = 0;
            currentBytesTotal = 0;
            startTime = getTimer();
        }

        private function onProgress(event:ProgressEvent):void
        {
            currentBytesLoaded = event.bytesLoaded;
            currentBytesTotal = event.bytesTotal;
            totalLoaded = totalCompleteBytes + currentBytesLoaded;
            var elapsedTime:uint = getTimer() - startTime;

            if (elapsedTime != 0)
            {
                currentSpeed = event.bytesLoaded / elapsedTime;
            }
            else
            {
                currentSpeed = event.bytesLoaded;
            }

            //
            if (_currentReqObj.progressCb != null)
            {
                _currentReqObj.progressCb(event, _currentReqObj);
            }
        }

        private function onIOError(event:IOErrorEvent):void
        {
			trace("[LoadUnit]  加载资源失败：" + event.text);
            // 删掉回调
            delete _callLaterDic[_currentRequest.url];
            _currentRequest.url = null;
            dealNext();
        }

        /**
         * 请求加载资源并回调
         * @param cb 回调函数 null就不回调
         */
        public function getResource(url:String, type:int, priority:int, cb:Function, progCb:Function, mark:*):void
        {
             trace("请求资源", url, "优先级",priority);
            if (imageCache[url] != null)
            {
                 trace("有缓存 直接返回", url);
                executeCb(cb, url, imageCache[url], mark);
                return;
            }
            // 无缓存，需要做以下步骤：
            // 加回调
            addToCallLater(url, cb, mark);

            // 加到加载队列 (当已经在异步解码就不用加了)
            if (!_currentReqObj || !cacheDecoding[_currentReqObj.url])
            {
                // 没有正在异步解码的情况 需要urlloader加载
                _downloadQueue.push(new LoadQueueItemVO(url, type, priority, progCb, mark));
            }
            // 开始下载队列中下一个
            dealNext();
        }

        /**
         * 直接回调
         */
        private function executeCb(fun:Function, url:String, data:*, mark:*):void
        {
            if (fun != null)
            {
                fun(url, data, mark);
            }
        }

        /**
         * 为资源设置回调
         */
        private function addToCallLater(url:String, cb:Function, mark:*):void
        {
            if (cb == null)
            {
                return;
            }
            var cbVO:CallbackVO = new CallbackVO(cb, mark);

            if (_callLaterDic[url] == null)
            {
                _callLaterDic[url] = [];
            }
            _callLaterDic[url].push(cbVO);
        }

        /**
         * 为资源调用记录过的需要的回调
         */
        private function executeCallLater(url:String):void
        {
            if (_callLaterDic[url] == null)
            {
                return;
            }
            // trace("[LoadUnit]  为url回调", url);
            var funcs:Array = _callLaterDic[url];
            var data:*      = imageCache[url];

            for each (var cb:CallbackVO in funcs)
            {
                executeCb(cb.fun, url, data, cb.mark);
            }
            delete _callLaterDic[url];
        }

        /**
         * 资源原始资源加载完成
         */
        private function onDataLoadComplete(event:Event):void
        {
            // 分析数据存入缓存，并回调
            var url:String      = _currentReqObj.url;
            var type:int        = _currentReqObj.type;
            var bytes:ByteArray = event.target.data;
            totalCompleteBytes += currentBytesTotal;
            totalLoaded = totalCompleteBytes;

            if (bytes)
            {
                var elapsedTime:uint = getTimer() - startTime;
				trace("[LoadUnit]  数据加载完成: url=", url, "数据大小=", bytes.length, "耗时=", elapsedTime + "ms", "平均速度=", currentSpeed + "KB/s");
            }
            _currentRequest.url = null;

            if (type == JYLoader.RES_BYTEARRAY)
            {
                imageCache[url] = bytes;
                // bytearray直接回调
                executeCallLater(url);
            }else if (type == JYLoader.RES_MESH  || type == JYLoader.RES_ANIM){
                asyncDecodeA3D(url , bytes );
            }else if (type == JYLoader.RES_ATF_A3D)
			{
				imageCache[url] =  new ATFTexture(bytes);
				executeCallLater(url);
			}else if (type == JYLoader.RES_ATF_CUBE_A3D)
            {
                imageCache[url] =  new ATFCubeTexture(bytes);
                executeCallLater(url);
            }
            else
            {
                // class和bmd 需要loader加载一次并尝试异步decode
                // 标记
                cacheDecoding[url] = true;
                startDecodeTime = getTimer();
                var loader:Loader = new Loader();
                loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent):void
                {
                    // ResLoader 加载到当前域失败
                });
                loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):void
                {
//					trace( "[LoadUnit]  Decode消耗时间" ,(getTimer()-startDecodeTime)+"ms");
                    // 异步解码加载完成
                    if (type == JYLoader.RES_BITMAP)
                    {
                        var bmd:BitmapData = Bitmap(loader.content).bitmapData;
                        imageCache[url] = bmd;
                        executeCallLater(url);
                    }
                    else
                    {
                        // Class自行调用
                        imageCache[url] = loader.content;
                        executeCallLater(url);
                    }
                    delete cacheDecoding[url];
                });
                // 异步Decode
                var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);

                if ("imageDecodingPolicy" in loaderContext)
                {
                    loaderContext["imageDecodingPolicy"] = "onLoad";
                }
                loader.loadBytes(bytes, loaderContext);
                    // loader 结束
            }
            dealNext();
        }

        private function asyncDecodeA3D( url :String , bytes : ByteArray ):void
        {
            // mesh
            cacheDecoding[url] = true;
            startDecodeTime = getTimer();
            var loader : AssetLoader = new AssetLoader();

            var parser:ParserBase;
            var ext :String = url.substr(url.lastIndexOf("."));
            switch(ext)
            {
                case IResourceKey.Suffix_MD5Mesh:			//判断是否为网格(模型)
                    parser = new E_MD5MeshParser();
                    break;
                case IResourceKey.Suffix_MD5Anim:	      	//判断是否为动作
                    parser = new E_MD5AnimParser();
                    break;
                case IResourceKey.Suffix_Effect:	      //判断是否为特效
                    parser = new ParticleGroupParser();
                    break;
                default:
                    break;
            }
            loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, function (event:LoaderEvent):void
            {
                var loader : AssetLoader  = event.target as AssetLoader;
                imageCache[url] = loader.baseDependency.assets;
                executeCallLater(url);
                delete cacheDecoding[url];
            });
//            addErrorHandler(loadError);
//            addParseErrorHandler(loadError);
            loader.loadData(bytes, null, null, null, parser );
        }

        private function dealNext():void
        {
            if (_pause)
            {
                // 当前暂停 ，拒绝执行
                return;
            }

            if (_currentRequest.url != null)
            {
                // 正在下载， 拒绝执行
                // trace("正在下载，延后");
                return;
            }

            if (_downloadQueue.length <= 0)
            {
                // 没有需要加载的了
                currentSpeed = 0;
                _currentReqObj = null;
                _currentRequest.url = null;

                if (_onAllLoaderComplete != null)
                {
                    _onAllLoaderComplete();
                    _onAllLoaderComplete = null;
                }
                return;
            }
            // 排序
            _downloadQueue.sort(sortFun);
            // trace(_downloadQueue.length ,"paixu ",_downloadQueue);
            // 寻找新下载项
            _currentReqObj = _downloadQueue.shift();

            // 检查缓存
            if (imageCache[_currentReqObj.url] != null)
            {
                // 已下载且已处理有缓存
                executeCallLater(_currentReqObj.url);
                dealNext();
                return;
            }
            else if (cacheDecoding[_currentReqObj.url])
            {
                // 已下载但未处理完，不要回调，但开始下一个
                dealNext();
                return;
            }
//			trace("[LoadUnit] 开始启动下载", _currentReqObj.url);
            _currentRequest.url = _currentReqObj.url;
            _urlLoader.load(_currentRequest);
        }

        private function sortFun(a:LoadQueueItemVO, b:LoadQueueItemVO):int
        {
            var priR:int = (b.priority - a.priority);

            if (priR != 0)
            {
                return priR;
            }
            else
            {
                return a.order - b.order;
            }
        }

        public function get paused():Boolean
        {
            return _pause;
        }

        public function pause():void
        {
            if (_pause)
            {
                return;
            }
            // if(_currentReqObj) trace("[LoadUnit] 暂停下载",_currentReqObj.url);
            _pause = true;

            try
            {
                _urlLoader.close();
            }
            catch (e:*)
            {
            }
            // pause
        }

        public function resume():void
        {
            if (_pause == false)
            {
                return;
            }
            _pause = false;

            // goOn
            if (_currentRequest.url)
            {
                _urlLoader.load(_currentRequest);
            }
        }

        /**
         * 停止一切下载并重置
         */
        public function reset():void
        {
            // 停止一切下载并重置
            _callLaterDic = new Dictionary();
            _currentReqObj = null;
            _currentRequest.url = null;

            try
            {
                _urlLoader.close();
            }
            catch (e:*)
            {
            }
            _downloadQueue = new Vector.<LoadQueueItemVO>();
        }

        /**
         * 所有资源全部加载完毕后的回调（只生效一次）
         */
        public function addAllLoadCompleteCallback(onAllLoaderComplete:Function):void
        {
            _onAllLoaderComplete = onAllLoaderComplete;
        }


    }
}
