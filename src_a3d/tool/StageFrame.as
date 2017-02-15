package tool
{
	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DProxy;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;

	import away3d.loaders.parsers.ParserBase;

	public class StageFrame
	{
		public static var stage:Stage;
		private static var _broadEvt:Sprite = new Sprite();

		public static var mainFun:Function;
		public static var cameraAt:Function;
		public static var mainActorMove:Function;

		private static var _gameFuns:Vector.<Function>;
		private static var _parserFuns:Vector.<Function>;

		private static var _frameWorkers:Vector.<FrameWorkerBase>;

		private static var _anims:Vector.<Function>;
		private static var _animDirty:Boolean;

		private static var _actors:Vector.<Function>;
		private static var _actorDirty:Boolean;

		private static var _oldFrameFuns:Vector.<Function> = new Vector.<Function>();
		private static var _nextFrameFuns:Vector.<Function> = new Vector.<Function>();
		/**
		 * 存下来 有提前异步上传贴图的地方要用
		 * @see ATFTexture/prepareUpload()
		 * @see TextureProxyBase/getTextureForStage3D()
		 * */
		public static var stage3DProxy:Stage3DProxy;

		public static function setup(sta:Stage):void
		{
			stage = sta;

			_broadEvt.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_broadEvt.addEventListener(Event.EXIT_FRAME, onExitFrame);

			_gameFuns = new Vector.<Function>();
			_parserFuns = new Vector.<Function>();
			_frameWorkers = new Vector.<FrameWorkerBase>();
			_anims = new Vector.<Function>();

			_actors = new Vector.<Function>();

			_oldFrameFuns = new Vector.<Function>();
			_nextFrameFuns = new Vector.<Function>();
		}

		public static function addNextFrameFun(fun:Function):void
		{
			_oldFrameFuns.push(fun);
		}

		/*private static function delVec(vecs:Vector.<Function>, idxs:Dictionary):void
		{
		var count:int = 0;
		var lastIdx:int = vecs.length;
		for each (var idx:int in idxs)
		{
		vecs[idx] = vecs[lastIdx];
		--lastIdx;
		++count;
		}
		vecs.length -= count;
		}*/

		private static var _gameFunDity:Boolean;
		public static function addGameFun(fun:Function):void
		{
			var idx:int = _gameFuns.indexOf(fun);
			if (idx == -1)
			{
				_gameFuns.push(fun);
				_gameFunDity = true;
			}
		}

		public static function removeGameFun(fun:Function):void
		{
			var idx:int = _gameFuns.indexOf(fun);
			if (idx != -1)
			{
				_gameFuns[idx] = _gameFuns[_gameFuns.length - 1];
				var tmpFun:Function = _gameFuns.pop();
				if (idx <= _tmpGameIdx && idx != _gameFuns.length)
				{
					tmpFun();
				}
				_gameFunDity = true;
			}
		}

		private static var _parserFunDity:Boolean;
		public static function addParserFun(fun:Function):void
		{
			var idx:int = _parserFuns.indexOf(fun);
			if (idx == -1)
			{
				_parserFuns.push(fun);
				_parserFunDity = true;
			}
		}

		public static function removeParserFun(fun:Function):void
		{
			var idx:int = _parserFuns.indexOf(fun);
			if (idx != -1)
			{
				_parserFuns[idx] = _parserFuns[_parserFuns.length - 1];
				var tmpFun:Function = _parserFuns.pop();
				if (idx <= _tmpParserIdx && idx != _parserFuns.length)
				{
					tmpFun();
				}
				_parserFunDity = true;
			}
		}

		private static var _frameWorkerDirty:Boolean;
		public static function addFrameWorker(frameWorker:FrameWorkerBase):void
		{
			var idx:int = _frameWorkers.indexOf(frameWorker);
			if (idx == -1)
			{
				_frameWorkers.push(frameWorker);
				_frameWorkerDirty = true;
			}
		}

		public static function removeFrameWorker(frameWorker:FrameWorkerBase):void
		{
			var idx:int = _frameWorkers.indexOf(frameWorker);
			if (idx != -1)
			{
				_frameWorkers[idx] = _frameWorkers[_frameWorkers.length - 1];
				_frameWorkers.pop();
				_frameWorkerDirty = true;
			}
		}

		public static function addAnimFun(fun:Function):void
		{
			var idx:int = _anims.indexOf(fun);
			if (idx == -1)
			{
				_anims.push(fun);
				_animDirty = true;
			}
		}

		public static function removeAnimFun(fun:Function):void
		{
			var idx:int = _anims.indexOf(fun);
			if (idx != -1)
			{
				_anims[idx] = _anims[_anims.length - 1];
				var tmpFun:Function = _anims.pop();
				if (idx < _tmpAnimIdx && idx != _anims.length)
				{
					tmpFun();
				}
				_animDirty = true;
			}
		}

		public static function addActorFun(fun:Function):void
		{
			var idx:int = _actors.indexOf(fun);
			if (idx == -1)
			{
				_actors.push(fun);
				_actorDirty = true;
			}
		}

		public static function removeActorFun(fun:Function):void
		{
			var idx:int = _actors.indexOf(fun);
			if (idx != -1)
			{
				_actors[idx] = _actors[_actors.length - 1];
				var tmpFun:Function = _actors.pop();
				if (idx < _tmpActorIdx && idx != _actors.length)
				{
					tmpFun();
				}
				_actorDirty = true;
			}
		}

		public static function get funLen():uint
		{
			var resLen:uint;
			var len:uint = _frameWorkers.length;
			for (var i:int = 0; i < len; ++i)
			{
				resLen += _frameWorkers[i].length;
			}
			resLen += _anims.length;
			resLen += _actors.length;
			resLen += _gameFuns.length;
			return resLen;
		}

		public static var curTime:uint;

		private static var _tmpGameIdx:int;
		private static var _tmpParserIdx:int;
		private static var _tmpAnimIdx:int;
		private static var _tmpActorIdx:int;
		private static var _gameLastIdx:int;
		private static var _parserLastIdx:int;
		private static var _workerLastIdx:int;
		private static var _animLastIdx:int;
		private static var _actorLastIdx:int;
		private static var _lastTime:uint;

		public static var deltaTime:uint=0;

		public static var gameEnterFrameFun:Function;
		public static var gameExitFrameFun:Function;

		public static var renderIdx:int = 0;

		private static function onEnterFrame(evt:Event):void
		{
			++renderIdx;
			deltaTime = getTimer() - curTime;
			curTime = getTimer();


			if (gameEnterFrameFun)
			{
				gameEnterFrameFun();
			}

			var len:uint;
			var i:int;
			var tarIdx:int;
			var tmpFun:Function;
			var tmpTime:uint;

			tmpTime = getTimer();
			len = _anims.length;
			for (_tmpAnimIdx = 0; _tmpAnimIdx < len; ++_tmpAnimIdx)
			{
				//				tarIdx = (_animLastIdx + _tmpAnimIdx) % len;
				_anims[_tmpAnimIdx]();
				if (_animDirty)
				{
					len = _anims.length;//Math.min(len, _anims.length);
					_animDirty = false;
				}
			}
			//			_animLastIdx = _tmpAnimIdx;
			_tmpAnimIdx = 0;

			tmpTime = _lastTime = getTimer();
			len = _gameFuns.length;
			for (_tmpGameIdx = 0; _tmpGameIdx < len && getTimer() - tmpTime < 3; ++_tmpGameIdx)
			{
				tarIdx = (_gameLastIdx + _tmpGameIdx) % len;
				tmpFun = _gameFuns[tarIdx];
				tmpFun();

				if (_gameFunDity)
				{
					len = _gameFuns.length;//Math.min(len, _gameFuns.length);
					_gameFunDity = false;
				}
			}
			_gameLastIdx = _tmpGameIdx;
			_tmpGameIdx = 0;

			tmpTime = getTimer();
			len = _parserFuns.length;
			for (_tmpParserIdx = 0; _tmpParserIdx < len && getTimer() - tmpTime < 3; ++_tmpParserIdx)
			{
				tarIdx = (_parserLastIdx + _tmpParserIdx) % len;
				tmpFun = _parserFuns[tarIdx];
				tmpFun();

				if (_parserFunDity)
				{
					len = _parserFuns.length;//Math.min(len, _gameFuns.length);
					_parserFunDity = false;
				}
			}
			_parserLastIdx = _tmpParserIdx;
			_tmpParserIdx = 0;

			len = _frameWorkers.length;
			tmpTime = getTimer();
			for (i = 0; i < len && getTimer() - tmpTime < 3; ++i)
			{
				tarIdx = (_workerLastIdx + i) % len;
				_frameWorkers[tarIdx].update();
				if (_frameWorkerDirty)
				{
					len = _frameWorkers.length;//Math.min(len, _frameWorkers.length);
					_frameWorkerDirty = false;
				}
			}
			_workerLastIdx = i;

			tmpTime = getTimer();
			len = _actors.length;
			for (_tmpActorIdx = 0; _tmpActorIdx < len; ++_tmpActorIdx)
			{
				//				tarIdx = (_actorLastIdx + _tmpActorIdx) % len;
				_actors[_tmpActorIdx]();
				if (_actorDirty)
				{
					len = _actors.length;//Math.min(len, _anims.length);
					_actorDirty = false;
				}
			}
			//			_actorLastIdx = _tmpActorIdx;
			_tmpActorIdx = 0;

			if (mainActorMove)
			{
				mainActorMove();
			}

			if (cameraAt)
			{
				cameraAt();
			}

			if (mainFun)
			{
				mainFun();
			}

			len = _nextFrameFuns.length;
			if (len)
			{
				for (i = 0; i < len; ++i)
				{
					_nextFrameFuns[i]();
				}
				_nextFrameFuns.length = 0;
			}
			var tmpFuns:Vector.<Function> = _nextFrameFuns;
			_nextFrameFuns = _oldFrameFuns;
			_oldFrameFuns = tmpFuns;

			ParserBase.execParse();
		}

		public static var tmpCount:int;
		private static function onExitFrame(evt:Event):void
		{
//			trace("----------------------------------------------->", inEyeCount);
			tmpCount = 0;

			if (gameExitFrameFun)
			{
				gameExitFrameFun();
			}
		}
	}
}