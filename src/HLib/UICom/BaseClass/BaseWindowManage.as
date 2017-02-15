package HLib.UICom.BaseClass
{
	import com.greensock.TweenLite;
	
	import HLib.Net.Socket.DataType;
	import HLib.Tool.HSysClock;
	import HLib.Tool.Tool;
	
	import Modules.Common.HAssetsManager;
	import Modules.Common.OpenUIEventManage;
	import Modules.Common.SourceTypeEvent;
	import Modules.Common.UIeventType;
	import Modules.DataSources.ItemSources;
	import Modules.DataSources.Quest;
	import Modules.DataSources.QuestSources;
	import Modules.Map.HMapSources;
	import Modules.view.task.CampCammandWindow;
	import Modules.view.task.CampOffensiveWindow;
	
	import starling.textures.Texture;

	public class BaseWindowManage
	{
		private static var instance:BaseWindowManage;
		private var _guideWindow:GuideWindow;
		private var _baseResult:BaseResultWindow;
		private var _tween:TweenLite;
		private var _campOffensive:CampOffensiveWindow;
		private var _campCammand:CampCammandWindow;
		private var _allTime:int;
		private var _isHide:Boolean;
		public static function get myInstance():BaseWindowManage
		{
			instance ||= new BaseWindowManage;
			return instance;
		}
		public function BaseWindowManage()
		{
			
		}
		/**显示引导界面*/
		public function showCampWarGuide():void
		{
			OpenUIEventManage.myInstance.openUIEvent(UIeventType.UI_ACTIVITYICON_0_4);
		}
		public function addCampWarGuide():void
		{
			if(!_guideWindow)
			{
				_guideWindow = new GuideWindow;
				var texture:Texture  = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_ACTIVITYICON_0, 'guide_bg');
				_guideWindow.showBg(texture);
				_guideWindow.init();
				_guideWindow.delayCall = delayCall;
			}
			_allTime = 16;
			updateTime();
			HSysClock.getInstance().addCallBack('GuideWindowUpdateTime', updateTime);
			HBaseView.getInstance().addChild(_guideWindow);
			_guideWindow.x = HBaseView.getInstance().myWidth - _guideWindow.myWidth >> 1;
			_guideWindow.y = HBaseView.getInstance().myHeight - _guideWindow.myHeight >> 1;
		}
		/**刷新时间*/
		private function updateTime():void
		{
			if(_allTime < 1)
			{
				delayCall(true);
				return;
			}
			_allTime--
			_guideWindow.updateTimeText(_allTime);
		}
		/**关闭界面、自动寻路*/
		private function delayCall(isSend:Boolean):void
		{
			if(_guideWindow.parent)
				_guideWindow.parent.removeChild(_guideWindow);
			HSysClock.getInstance().removeCallBack('GuideWindowUpdateTime');
			if(!isSend) return;
			var quest:Quest = QuestSources.getInstance().getCampQuest();
			if(quest)
			{
				if(ItemSources.getInstance().getBagItemNum("110816") < 1)
					QuestSources.getInstance().sendFindPathToSever([int(quest.QuestId), DataType.Byte(0)]);
				else
					QuestSources.getInstance().sendFindPathToSever([int(quest.QuestId), DataType.Byte(1)]);
			}
		}
		
		/**显示阵营输赢界面*/
		public function showWarResult(winSide:int):void
		{
			_baseResult ||= new BaseResultWindow;
			_baseResult.alpha = 1;
			HBaseView.getInstance().addChild(_baseResult);
			var isShow:Boolean;
			var texture:Texture;
			var vector:Vector.<Texture> = HAssetsManager.getInstance().getMyTextures(SourceTypeEvent.SOURCE_ACTIVITYICON_30, 'warEffect/cb_0000');
			if(winSide == HMapSources.getInstance().mainWizardObject.Player_Camp)
			{
				texture  = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_ACTIVITYICON_30, 'warEffect/winBg')
			}	else {
				isShow = true;
				texture  = HAssetsManager.getInstance().getMyTexture(SourceTypeEvent.SOURCE_ACTIVITYICON_30, 'warEffect/failBg')
			}
			_baseResult.showBg(texture);
			_baseResult.showResultEffect(vector, isShow);
			_baseResult.x = HBaseView.getInstance().myWidth - _baseResult.myWidth >> 1;
			_baseResult.y = HBaseView.getInstance().myHeight - _baseResult.myHeight >> 1;
			if(_tween)
				_tween.kill();
			_tween = TweenLite.to(_baseResult, 1, {alpha:0, delay:5,
				onComplete:function():void  
				{ 
					if(_baseResult.parent)
						_baseResult.parent.removeChild(_baseResult);
				}  
			}); 
		}
		/**显示阵营战界面*/
		public function showWarProgress():void
		{
			_isHide = false;
			OpenUIEventManage.myInstance.openUIEvent(UIeventType.UI_ACTIVITYICON_30);
			
		}
		/**显示界面*/
		public function addWarProgress():void
		{
			if(_isHide) return;
			if(!_campCammand)
			{
				_campOffensive = new CampOffensiveWindow;
				_campOffensive.y = 210
				_campOffensive.init();
				
				_campCammand = new CampCammandWindow;
				_campCammand.y = 220 + _campOffensive.myHeight;	;	
				_campCammand.init();
				_campCammand.x = HBaseView.getInstance().myWidth - 206 - _campCammand.myWidth - 5;
				_campOffensive.x = _campCammand.x;
				
			}
			HBaseView.getInstance().addChild(_campOffensive);
			HBaseView.getInstance().addChild(_campCammand);
		}
		/**隐藏阵营战界面*/
		public function hideWarProgress():void
		{
			_isHide = true;
			if(_campOffensive && _campOffensive.parent)
			{
				_campCammand.parent.removeChild( _campCammand)
				_campOffensive.parent.removeChild(_campOffensive);
			}
		}
		/**更新阵营时间*/
		public function updateCampWarTime(time:int, type:int):void
		{	if(_campOffensive && _campOffensive.parent)
				_campOffensive.updateWarTime("#42ff0013" + Tool.convertTimeToStr(time, 'm:s'), type)
		}
		/**浏览器改变大小时更新阵营战界面位置*/
		public function updatePosition():void
		{
			if(_campOffensive && _campOffensive.parent)
			{
				_campCammand.x = HBaseView.getInstance().myWidth - 206 - _campCammand.myWidth - 5;
				_campOffensive.x = _campCammand.x;
				_campOffensive.y = 210;
				_campCammand.y = 220 + _campOffensive.myHeight;	
			}
		}

		public function get campCammand():CampCammandWindow
		{
			return _campCammand;
		}

	}
}