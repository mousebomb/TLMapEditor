package tl.frameworks.service.bombloader
{
    import away3d.loaders.AssetLoader;
    import away3d.loaders.parsers.AWDParser;

    import flash.utils.Dictionary;

    /**
     *

     * 3种资源
     *	ByteArray zip包  ,atf 等等
     * Class 完成 new
     * png。。。图片 BitmapData
     *
     * 加一个group，每个group有优先级。

     * 速度统计

     * 暂停／结束*
     *
     * @author rhett
     */
    public class JYLoader
    {
        private static var _instance:JYLoader;

        public static function getInstance():JYLoader
        {
            if (_instance == null)
            {
                _instance = new JYLoader();
            }
            return _instance;
        }

        public function JYLoader()
        {
            if (_instance != null)
            {
                throw new Error('singleton');
            }

            init();
        }

        private var loaderUnitDic:Dictionary;
        private var loaderUnit3DDic:Dictionary;

        private function init():void
        {
            AssetLoader.enableParser(AWDParser);
            loaderUnitDic   = new Dictionary();
            loaderUnit3DDic = new Dictionary();
        }

        /**  */
        public static const GROUP_UI:int       = 1;

        /**  */
        public static const GROUP_SCENE:int    = 2;

        public static const GROUP_LOGIN:int    = 3;

        public static const GROUP_CHARA:int    = 4;

        public static const GROUP_BUILDING:int = 5;

        public static const GROUP_EFFECT:int   = 5;

        /**
         * 加载运行时共享类。如UI，动画序列帧。
         * 此类资源加载完成后可以直接new出来用。 cb(url,true,...args);
         */
        public static const RES_RSL:int        = 1;

        /**
         * 加载位图资源 png等等，如地图瓦片。
         * 会异步decode，完成后回调 cb(url,BitmapData,...args);
         */
        public static const RES_BITMAP:int     = 2;

        /**
         * 加载二进制数据，配置等。
         * 完成后会回调并带原始数据 cb(url,ByteArray,...args);
         */
        public static const RES_BYTEARRAY:int  = 3;

        /** mesh数据
         * 完成后 cb(url, Vector.<IAsset> ,...args) */
        public static const RES_MESH :int = 4;

        /** ATF贴图 away3D用 */
        public static const RES_ATF_A3D :int = 5;
        /** ATF贴图 skybox用 */
        public static const RES_ATF_CUBE_A3D :int = 8;
		/** 骨骼动画 */
        public static const RES_ANIM :int = 6;

        /** AWD模型包 */
        public static const RES_AWD:int = 7;

        /**
         * 加载资源
         * @param type  类型常量在 BombLoader.RES_RSL ,RES_BITMAP ,RES_BYTEARRAY
         * @see BombLoader
         */
        public function reqResource(url:String, type:int, priority:int, group:int, cb:Function, progCb:Function = null, mark:* = null):void
        {
            if (type == RES_AWD)
            {
                var unit3D:JYLoad3DUnit = loaderUnit3DDic[group];
                if (unit3D == null)
                {
                    unit3D               = new JYLoad3DUnit();
                    loaderUnit3DDic[group] = unit3D;
                }
                unit3D.getResource(url, type, priority, cb, progCb, mark);
            } else
            {
                var unit:JYLoadUnit = loaderUnitDic[group];

                if (unit == null)
                {
                    unit                 = new JYLoadUnit();
                    loaderUnitDic[group] = unit;
                }
                unit.getResource(url, type, priority, cb, progCb, mark);
            }
            //
        }

        private var _topSpeed:Number           = 0.0;

        private var _loadSpeed:Number          = 0.0;

        private var _totalLoaded:Number        = 0.0;

        /**
         * 准备统计数据
         */
        public function updateStats():void
        {
            _loadSpeed = 0.0;
            _totalLoaded = 0.0;

            for each (var loadUnit:JYLoadUnit in loaderUnitDic)
            {
                _loadSpeed += loadUnit.currentSpeed;
                _totalLoaded += (loadUnit.totalLoaded) / 1000;
            }

            if (_loadSpeed > _topSpeed)
            {
                _topSpeed = _loadSpeed;
            }
        }

        /**
         * 当前的加载速度
         */
        final public function get loadSpeed():Number
        {
            return _loadSpeed;
        }

        /**
         * 总下载流量
         */
        final public function get totalLoaded():Number
        {
            return _totalLoaded;
        }

        /**
         * 下载速度峰值
         */
        final public function get topSpeed():Number
        {
            return _topSpeed;
        }

        public function reset(group:int):void
        {
            var unit:JYLoadUnit = loaderUnitDic[group];

            if (unit)
            {
                unit.reset();
            }
        }

        public function pause(group:int):void
        {
            var unit:JYLoadUnit = loaderUnitDic[group];

            if (unit)
            {
                unit.pause();
            }
        }

        public function resume(group:int):void
        {
            var unit:JYLoadUnit = loaderUnitDic[group];

            if (unit)
            {
                unit.resume();
            }
        }

        /**
         * 某组资源全部加载完成时回调(只生效一次)
         */
        public function addAllLoadCompleteCallback(group:int, onAllLoaderComplete:Function):void
        {
            var unit:JYLoadUnit = loaderUnitDic[group];

            if (unit)
            {
                unit.addAllLoadCompleteCallback(onAllLoaderComplete);
            }
        }

        /**
         * 某些情况下，下载来的东西会被外部释放（BitmapData被dispose），必须标记为缓存不在了，下次再需要的时候要重新下载。
         */
        public function markAsNocache(url:String):void
        {
            delete JYLoadUnit.imageCache[url];
        }
    }
}
