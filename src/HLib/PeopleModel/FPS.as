package HLib.PeopleModel
{
    import HLib.Event.ModuleEvent;
    import HLib.Event.ModuleEventDispatcher;
    
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.text.*;
    import flash.utils.*;

    public class FPS extends Sprite
    {
        private var currentY:int;
        private var diagramTimer:int;
        private var tfTimer:int;
        private var mem:TextField;
        private var diagram:BitmapData;
        private var skins:int = -1;
        private var fps:TextField;
        private var tfDelay:int = 0;
        private var skinsChanged:int = 0;
		private var _Timer:Timer=new Timer(60000);
		private var _IsSendEvent:Boolean=true;
		private var _Fps:Number=24;
        static private const maxMemory:uint = 4.1943e+007;
        static private const diagramWidth:uint = 60;
        static private const tfDelayMax:int = 10;
        static private var instance:FPS;
        static private const diagramHeight:uint = 40;

        public function FPS()
        {
            this.addEventListener(Event.ADDED_TO_STAGE,run);
        }

		private function run(e:Event):void{
			stage.addEventListener(Event.DEACTIVATE,onDeactivate);//失去焦点
			stage.addEventListener(Event.ACTIVATE,onActivate);//获得焦点
			var _loc_2:Bitmap;
            fps = new TextField();
            mem = new TextField();
            if (instance == null)
            {
                mouseEnabled = false;
                mouseChildren = false;
                fps.defaultTextFormat = new TextFormat("Tahoma", 10, 13421772);
                fps.autoSize = TextFieldAutoSize.LEFT;
                fps.text = "FPS: " + Number(stage.frameRate).toFixed(2);
                fps.selectable = false;
                fps.x = -diagramWidth - 2;
                addChild(fps);
                mem.defaultTextFormat = new TextFormat("Tahoma", 10, 13421568);
                mem.autoSize = TextFieldAutoSize.LEFT;
                mem.text = "MEM: " + bytesToString(System.totalMemory);
                mem.selectable = false;
                mem.x = -diagramWidth - 2;
                mem.y = 10;
                addChild(mem);
                currentY = 20;
                diagram = new BitmapData(diagramWidth, diagramHeight, true, 553648127);
                _loc_2 = new Bitmap(diagram);
                _loc_2.y = currentY + 4;
                _loc_2.x = -diagramWidth;
                addChildAt(_loc_2, 0);
                addEventListener(Event.ENTER_FRAME, onEnterFrame);
//                this.stage.addEventListener(Event.RESIZE, onResize);
//                onResize();
                diagramTimer = getTimer();
                tfTimer = getTimer();
//				_Timer.addEventListener(TimerEvent.TIMER,onTimer);
				ModuleEventDispatcher.getInstance().addEventListener("FpsNo",onFpsNo);
				ModuleEventDispatcher.getInstance().addEventListener("GameFpsShow",onGameFpsShow);
//				this.addEventListener(MouseEvent.CLICK,onClick);
            }
            else
            {
            }// end else if
            return;
		}
		private function onTimer(e:TimerEvent):void{
			if(_IsSendEvent&&_Fps<12){
				ModuleEventDispatcher.getInstance().ModuleCommunication("GameReload");
			}
			_Timer.reset();
			_Timer.stop();
		}
        private function bytesToString(param1:uint) : String
        {
            var _loc_2:String;
            if (param1 < 1024)
            {
                _loc_2 = String(param1) + "b";
            }
            else if (param1 < 10240)
            {
                _loc_2 = Number(param1 / 1024).toFixed(2) + "kb";
            }
            else if (param1 < 102400)
            {
                _loc_2 = Number(param1 / 1024).toFixed(1) + "kb";
            }
            else if (param1 < 1048576)
            {
                _loc_2 = Math.round(param1 / 1024) + "kb";
            }
            else if (param1 < 10485760)
            {
                _loc_2 = Number(param1 / 1048576).toFixed(2) + "mb";
            }
            else if (param1 < 104857600)
            {
                _loc_2 = Number(param1 / 1048576).toFixed(1) + "mb";
            }
            else
            {
                _loc_2 = Math.round(param1 / 1048576) + "mb";
            }// end else if
            return _loc_2;
        }

        private function onEnterFrame(param1:Event) : void
        {
            tfDelay++;
            if (tfDelay >= tfDelayMax)
            {
                tfDelay = 0;

				_Fps=Number(1000 * tfDelayMax / (getTimer() - tfTimer));
//				if(_IsSendEvent&&_Fps<12&&!_Timer.running){
//					_Timer.start();
//				}
				fps.text = "FPS: " + _Fps.toFixed(2)
                tfTimer = getTimer();
            }// end if
            var _loc_2:* = 1000 / (getTimer() - diagramTimer);
            var _loc_3:* = _loc_2 > stage.frameRate ? (1) : (_loc_2 / stage.frameRate);
            diagramTimer = getTimer();
            diagram.scroll(1, 0);
            diagram.fillRect(new Rectangle(0, 0, 1, diagram.height), 553648127);
            diagram.setPixel32(0, diagramHeight * (1 - _loc_3), 4291611852);
            mem.text = "MEM: " + bytesToString(System.totalMemory);
            var _loc_4:* = skins == 0 ? (0) : (skinsChanged / skins);
            diagram.setPixel32(0, diagramHeight * (1 - _loc_4), 4294927872);
            var _loc_5:* = System.totalMemory / maxMemory;
            diagram.setPixel32(0, diagramHeight * (1 - _loc_5), 4291611648);
            return;
        }

        private function onResize(param1:Event = null) : void
        {
            var _loc_2:* = parent.globalToLocal(new Point(stage.stageWidth - 2, -3));
            x = _loc_2.x;
            y = _loc_2.y;
            return;
        }
		private function onFpsNo(e:starling.events.Event):void{
			_IsSendEvent=false;
		}
		private function onClick(e:MouseEvent):void{
			ModuleEventDispatcher.getInstance().ModuleCommunication("GameReload");
		}
		private function onGameFpsShow(e:starling.events.Event):void{
			if(this.visible){
				this.visible=false;
			}
			else{
				this.visible=true;
			}
		}
		private function onDeactivate(e:Event):void{
			_IsSendEvent=false;
			trace("stage:Deactivate");
		}
		private function onActivate(e:Event):void{
			_IsSendEvent=true;
			ModuleEventDispatcher.getInstance().ModuleCommunication("StageActivate");
			trace("stage:Activate");
		}
    }
}
