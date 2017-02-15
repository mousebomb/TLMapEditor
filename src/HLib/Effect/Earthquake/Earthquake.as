package HLib.Effect.Earthquake
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import away3d.cameras.Camera3D;
	import away3d.entities.Mesh;
	
	import starling.display.DisplayObject;
	
	public class Earthquake {
		private static const FRAME_RATE:int = 20;	
		
		private static var _timer:Timer;
		private static var _displayObject:*;//Entity;
		private static var _originalX:int;
		private static var _originalY:int;
		private static var _intensity:int;
		private static var _intensityOffset:int;
		/**
		 * 地震效果 作者黄栋
		 * @param displayObject 对象
		 * @param intensity 幅度
		 * @param seconds 时间
		 * 
		 */
		public static function go( displayObject:Mesh, intensity:Number = 10, seconds:Number = 1, completeCallBack:Function = null):void {
			_completeCallBack = completeCallBack;
			if ( _timer ) {
				_timer.stop();
				_displayObject.x = _originalX;
				_displayObject.y = _originalY;				
				cleanup();
			}
			
			_displayObject = displayObject;
			_originalX = displayObject.x;
			_originalY = displayObject.y;
			
			_intensity = intensity;
			_intensityOffset = intensity / 2;
			
			var msPerUpdate:int = int(1000 / FRAME_RATE);
			var totalUpdates:int = int(seconds * 1000 / msPerUpdate);
			
			_timer = new Timer(msPerUpdate, totalUpdates);
			_timer.addEventListener(TimerEvent.TIMER, quake, false, 0, true);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, resetImage, false, 0, true);
			
			_timer.start();
		}
		/**
		 * 地震效果(摄像机版)
		 * @param displayObject	: 摄像机
		 * @param intensity		: 幅度
		 * @param seconds		: 震动时间
		 */		
		public static function cameraGo( displayObject:Camera3D, intensity:Number = 10, seconds:Number = 1, completeCallBack:Function = null):void {
			_completeCallBack = completeCallBack;
			if ( _timer ) {
				_timer.stop();
				_displayObject.x = _originalX;
				_displayObject.y = _originalY;				
				cleanup();
			}
			
			_displayObject = displayObject;
			_originalX = displayObject.x;
			_originalY = displayObject.y;
			
			_intensity = intensity;
			_intensityOffset = intensity / 2;
			
			var msPerUpdate:int = int(1000 / FRAME_RATE);
			var totalUpdates:int = int(seconds * 1000 / msPerUpdate);
			
			_timer = new Timer(msPerUpdate, totalUpdates);
			_timer.addEventListener(TimerEvent.TIMER, quake, false, 0, true);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, resetImage, false, 0, true);
			
			_timer.start();
		}
		private static var _completeCallBack:Function;
		/**
		 * starling sprite震动
		 * @param displayObject
		 * @param intensity
		 * @param seconds
		 */		
		public static function spriteGo( displayObject:DisplayObject, intensity:Number = 10, seconds:Number = 1, completeCallBack:Function = null):void {
			_completeCallBack = completeCallBack;
			if ( _timer ) {
				_timer.stop();
				_displayObject.x = _originalX;
				_displayObject.y = _originalY;				
				cleanup();
			}
			
			_displayObject = displayObject;
			_originalX = displayObject.x;
			_originalY = displayObject.y;
			
			_intensity = intensity;
			_intensityOffset = intensity / 2;
			
			var msPerUpdate:int = int(1000 / FRAME_RATE);
			var totalUpdates:int = int(seconds * 1000 / msPerUpdate);
			
			_timer = new Timer(msPerUpdate, totalUpdates);
			_timer.addEventListener(TimerEvent.TIMER, quake, false, 0, true);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, resetImage, false, 0, true);
			
			_timer.start();
		}
		private static function quake( event:TimerEvent ):void {
			var newX:int = _originalX + Math.random() * _intensity - _intensityOffset;
			var newY:int = _originalY - Math.random() * _intensity;// - _intensityOffset;
			
			//_displayObject.x = newX;
			_displayObject.y = newY;
		}
		
		private static function resetImage( event:TimerEvent = null ):void {
			//_displayObject.x = _originalX;
			_displayObject.y = _originalY;
			
			cleanup();
		}
		private static function cleanup():void {
			_timer.removeEventListener(TimerEvent.TIMER, quake);
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, resetImage);
			_timer = null;
			if(_completeCallBack != null) _completeCallBack();
			_completeCallBack = null;
		}
		
		
		/**
		 * starling sprite放大效果
		 * @param displayObject
		 * @param intensity
		 * @param seconds
		 */		
		public static function spriteScaleGo( displayObject:DisplayObject, intensity:Number = 0.5, seconds:Number = 1, completeCallBack:Function = null):void {
			_scaleCompleteCallBack = completeCallBack;
			if ( _scaleTimer ) {
				_scaleTimer.stop();
				_scaleDisplayObject.scaleX = _scaleDisplayObject.scaleY = _originalScaleX;
				clearScaleTimer();
			}
			
			_scaleDisplayObject = displayObject;
			_originalScaleX = _scaleDisplayObject.scaleX;
			
			_scaleIntensity = intensity;
			
			var msPerUpdate:int = int(1000 / FRAME_RATE);
			var totalUpdates:int = int(seconds * 1000 / msPerUpdate);
			
			_scaleTimer = new Timer(msPerUpdate, totalUpdates);
			_scaleTimer.addEventListener(TimerEvent.TIMER, onScaleTimer, false, 0, true);
			_scaleTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onScaleTimerComplete, false, 0, true);
			_scaleTimer.start();
		}
		private static var _scaleDisplayObject:DisplayObject;
		private static var _originalScaleX:Number;
		private static var _scaleIntensity:Number;
		private static var _scaleTimer:Timer;
		private static var _scaleCompleteCallBack:Function;
		
		private static function onScaleTimer(e:TimerEvent):void
		{
			var newX:Number = _originalScaleX + Math.random() * _scaleIntensity;
			
			_scaleDisplayObject.scaleX = _scaleDisplayObject.scaleY =newX;
		}
		
		private static function onScaleTimerComplete(e:TimerEvent):void
		{
			_scaleDisplayObject.scaleX = _scaleDisplayObject.scaleY = _originalScaleX;
			clearScaleTimer();
		}
		
		private static function clearScaleTimer():void 
		{
			_scaleTimer.removeEventListener(TimerEvent.TIMER, onScaleTimer);
			_scaleTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onScaleTimerComplete);
			_scaleTimer = null;
			_scaleDisplayObject = null;
			if(_scaleCompleteCallBack != null) _scaleCompleteCallBack();
			_scaleCompleteCallBack = null;
		}
		
		
	}
}