package HLib.UICom.Component.Icons
{
	
	import HLib.UICom.BaseClass.HSprite;
	
	import Modules.Common.HAssetsManager;
	import Modules.Common.HCss;
	import Modules.DataSources.Item;
	import Modules.DataSources.ItemSources;
	import Modules.SFeather.SFTextField;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	/**
	 * 镶嵌宝石显示栏 
	 * @author Administrator
	 * 郑利本
	 */	
	public class InlayProperty extends HSprite
	{
		private var _text:SFTextField;
		private var _inlaySpr:Sprite;
		private var _item:Item;
		private var _inlayID:int = 1;
		private var _isMy:Boolean;
		private var _inlayLabel:String;
		private var _skepId:int;
		private var _imageArr:Array = [];
		public function InlayProperty()
		{
			super();
		}
		public function init():void
		{
			this.touchable = false;
			_text = new SFTextField;
			_text.leading = 6;
			_text.myWidth = this.myWidth;
			this.addChild(_text);
			
			_inlaySpr = new Sprite;
			this.addChild(_inlaySpr);
			_inlaySpr.x = 15;
			_inlaySpr.y = 23;
		}
		
		public function updateItem(item:Item,isMy:Boolean=true, skepId:int=-1):void
		{
			_item = item;
			_isMy = isMy
			_skepId = skepId;
			clearItem();
			_inlayLabel = HCss.TipsColor2 + "14nn00镶嵌属性\n";
			for(var i:int=0; i<5; i++)
			{
				getInlayItem("Item_Slot" + i, i);
			}
			_text.eventLabel = _inlayLabel;		
			this.myHeight = _text.textHeight;
		}
		
		private function getInlayItem(str:String, id:int):void
		{
			if(_item.hasOwnProperty(str))
			{
				var image:Image, texture:Texture
				if(_item[str] != 100 && _item[str] > 0)
				{
					var item:Item = ItemSources.getInstance().getGemItem(_item, id);
					if(item)
					{
						image = _imageArr[id];
						texture = HAssetsManager.getInstance().getMyTexture("mainFaceSource","gem_icon_"+item.Item_Quality)
						if(image == null)
						{
							image = new Image(texture);
							_imageArr[id] = image;
						}
						if(image.texture != texture)
						{
							image.texture = texture;
							image.readjustSize();
						}
						_inlaySpr.addChild(image);
						image.y = 22 * _inlayID ;
						_inlayID ++;
						_inlayLabel += HCss.QualityColorArray[item.Item_Quality] + "13nn00            "  + getActted(item) + "\n";/*+ item.Item_Name*/
					}
				}
			}
		}
		
		private function getActted(item:Item):String
		{
			var str:String = '　';
			if(item.CurHp > 0)//生命
			{
				str +="生命 +" + item.CurHp ;
			}
			if(item.Attack > 0)//攻击
			{
				str += "攻击 +" + item.Attack ;
			}
			if(item.Defense > 0)//防御
			{
				str += "防御 +" + item.Defense ;
			}
			if(item.Crit > 0) //暴击
			{
				str += "暴击 +" + item.Crit ;
			}
			if(item.Tenacity > 0)//韧性
			{
				str += "韧性 +" + item.Tenacity ;
			}
			
			if(item.Vampire[0] != "0")
			{
				str += "吸 血 值 +" + item.Vampire[0] ;
			}
			if(item.OutHurtPerc[0] != "0")
			{
				
				str += "减 伤 值 +" + item.OutHurtPerc[0] ;
			}
			if(item.OutAttack[0] != "0")
			{
				
				str += "卓越攻击 +" + item.OutAttack[0] ;
			}
			if(item.AttackPerc[0] != "0")
			{
				
				str += "攻击加成 +" + item.AttackPerc[0] ;
			}
			if(item.AppendHurt[0] != "0")
			{
				
				str += "附加伤害 +" + item.AppendHurt[0] ;
			}
			if(item.LgnoreDefense[0] != "0")
			{
				
				str += "无视防御 +" + item.LgnoreDefense[0] ;
			}
			if(item.AbsorbHurt[0] != "0")
			{
				
				str += "吸收伤害 +" + item.AbsorbHurt[0] ;
			}
			if(item.DefensePerc[0] != "0")
			{
				
				str += "防御加成 +" + item.DefensePerc[0]  ;
			}
			if(item.DefenseSuccess[0] != "0")
			{
				
				str += "防御成功率 +" + item.DefenseSuccess[0] ;
			}
			return str;
		}
		
		private function clearItem():void
		{
			_inlayID = 0;
			while(_inlaySpr.numChildren)
			{
				_inlaySpr.removeChildAt(0)
			}
		}
	}
}