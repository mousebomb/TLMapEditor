package HLib.UICom.Component
{
	import HLib.Tool.EffectPlayerManage;
	import HLib.UICom.BaseClass.HMovieClip;
	import HLib.UICom.BaseClass.HTopBaseView;
	
	import Modules.Common.HAssetsManager;
	import Modules.Common.SourceTypeEvent;
	import Modules.Map.HMapSources;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	/**
	 * 带特效,播放音乐按钮 
	 * @author Administrator
	 * 郑利本
	 */	
	public class HEffectSimpleButton extends HSimpleButton
	{
		public var musicStr:String;						//音乐路径
		public var isPlayerMoveEffect:Boolean = true;		//播放移动特效
		public var isPlayerMusic:Boolean = true;			//播放移动音乐
		private var _isPlayerEffect:Boolean;
		private var _effect:HMovieClip;
		private var _vector:Vector.<Texture>;
		private var _isPlayMusic:Boolean;
		public function HEffectSimpleButton()
		{
			super();
		}
		
		override protected function onTouch(e:TouchEvent):void
		{
			super.onTouch(e);
			if(!EffectPlayerManage.getMyInstance().isInit) return;
			if(HTopBaseView.getInstance().hasEvent && !isPierce)  return;
			var touch:Touch = e.getTouch(this, TouchPhase.HOVER);
			if(touch)
			{
				if(isPlayerMoveEffect)
				{
					if(!_isPlayerEffect)
					{
						if(!_effect)
						{
							_effect = new HMovieClip;
							_effect.touchable = false;
							_effect.touchGroup = true;
							_effect.setTextureList(vector);
							this.parent.addChild(_effect);
							_effect.x = this.x + (this.myWidth - _effect.myWidth >> 1);
							_effect.y = this.y + (this.myHeight  - _effect.myHeight >> 1);	
						}
					}
					_effect.visible = true;
					_effect.Play();
					_isPlayerEffect = true;
				}
				if(isPlayerMusic)
				{
					if(!_isPlayMusic && musicStr)
					{
						HMapSources.getInstance().playASound(musicStr, 0);
					}
					_isPlayMusic = true;
				}
			}	else {
				if(isPlayerMoveEffect && _isPlayerEffect)
				{
					_isPlayerEffect = false;
					_effect.Stop();
					_effect.visible = false;
				}
				_isPlayMusic = false;
			}
		}

		public function get vector():Vector.<Texture>
		{
			_vector ||= HAssetsManager.getInstance().getMyTextures(SourceTypeEvent.ICON_EFFECT_SOURCE, "bagEffect/par_up_skill_000");
			return _vector;
		}

		public function set vector(value:Vector.<Texture>):void
		{
			_vector = value;
		}

		
	}
}