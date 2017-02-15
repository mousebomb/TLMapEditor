package tl.core.Wizard.NameBar
{
	/**
	 * 下张地图名字条
	 * @author 李舒浩
	 */	
	import HLib.MapBase.HMapData;
	import HLib.Tool.Tool;
	import HLib.UICom.BaseClass.HSprite3D;
	import HLib.UICom.BaseClass.HTextField3D;
	
	public class NextMapNameBar extends HSprite3D
	{
		/** 名字文本 **/
		public function get nameTF3D():HTextField3D 
		{ 
			return _nameTF3D; 
		}
		private var _nameTF3D:HTextField3D;//名字
		
		private var _mapData:HMapData = new HMapData();	//地图数据
		private var _mapId:String = "";
		
		public function NextMapNameBar() 
		{
			super();
		}
		
		public function init():void
		{
			_nameTF3D = new HTextField3D();
			_nameTF3D.init(1);
			_nameTF3D.size = 30;
			_nameTF3D.algin = "center";
			_nameTF3D.color = 0xFFFD64;
			_nameTF3D.textField.filters = [];
			Tool.setDisplayGlowFilter(_nameTF3D.textField, 0xE94F2D, 1, 6, 6);
			this.addChild(_nameTF3D);
		}
		/**
		 * 设置地图ID
		 * @param value	: 地图ID
		 */		
		public function set mapId(value:String):void
		{
			if(_mapId == value) 
			{
				return;
			}
			_mapId = value;
			if(_mapId == "")
			{
				this.visible = false;
				return;
			}
			_mapData.refresh( _mapId );
			//设置名字显示
			_nameTF3D.text = _mapData.name;
		}
		
	}
}