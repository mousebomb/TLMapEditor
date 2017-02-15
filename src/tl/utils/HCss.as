package tl.utils
{
	/**
	 * 样式配置表 
	 */	
	import flash.text.TextField;

	public final class HCss
	{
		/**通用色1　灰*/
		public static const GeneralColor1:String ="#9ab2c0";		 
		/**通用色2　兰*/
		public static const GeneralColor2:String ="#3988b7"; 	 
		/**通用色3  橙黄*/
		public static const GeneralColor3:String ="#cb7300"; 	 		
		/**白装*/
		public static const QualityColor0:String ="#b8b7b7";	
		/**绿装*/
		public static const QualityColor1:String ="#5dd100";	
		/**蓝装*/
		public static const QualityColor2:String ="#0178d5";	
		/**紫装*/
		public static const QualityColor3:String ="#a634c7";	
		/**橙装*/
		public static const QualityColor4:String ="#ffd200";	
		/**品质颜色数组*/
		public static const QualityColorArray:Array=[QualityColor0,QualityColor1,QualityColor2,QualityColor3,QualityColor4];
		/**文本专用通用色１　灰*/
		public static const HGeneralColor1:String ="#9ab2c012";		
		/**文本专用通用色２　兰*/
		public static const HGeneralColor2:String ="#3988b712"; 	
		/**文本专用通用色3  橙*/
		public static const HGeneralColor3:String ="#cb730012"; 		
		/**白装*/
		public static const HQualityColor0:String ="#b8b7b712";	
		/**绿装*/
		public static const HQualityColor1:String ="#5dd10012";	
		/**蓝装*/
		public static const HQualityColor2:String ="#0178d512";	
		/**紫装*/
		public static const HQualityColor3:String ="#a634c712";	
		/**橙装*/
		public static const HQualityColor4:String ="#ffd20012";	
		/**品质颜色数组*/
		public static const HQualityColorArray:Array=[HQualityColor0,HQualityColor1,HQualityColor2,HQualityColor3,HQualityColor4];
		/**灰色*/
		public static const TipsColor1:String ="#b4b4b4";		//
		/**土黄色*/
		public static const TipsColor2:String ="#dcc094";		//
		/**绿色*/
		public static const TipsColor3:String ="#5ac71e";		//
		/**兰色*/
		public static const TipsColor4:String ="#3983ae";		//
		/**紫色*/
		public static const TipsColor5:String ="#bb1edd";		//
		/**橙黄色*/
		public static const TipsColor6:String ="#e5a428";		//
		/**黄色*/
		public static const TipsColor7:String ="#d2c74c";		//
		/**白色*/
		public static const TipsColor8:String ="#d8d8d8";		//
		/**红色*/
		public static const TipsColor9:String ="#901b1b";		//
		/**标题色*/
		public static const TitleColor:String ="#FEFF89";		//
		
		/**草绿色*/
		public static const Questcolr1:String = "#b1ba68";
		/**金黄色*/
		public static const Questcolr2:String = "#fbb715";
		/**深蓝*/
		public static const Questcolr3:String = "#4ca4ff";
		/**浅灰色*/
		public static const Questcolr4:String = "#b0d9f1";
		/**绿色*/
		public static const Questcolr5:String = "#06e506";
		
		/**浅蓝*/
		public static const Questcolr6:String = "#164775";
		
		/**黄色*/
		public static const Questcolr7:String = "#FFff00";
		/**烫金色*/
		public static const Questcolr8:String = "#bca782";
		/**浅绿*/
		public static const Questcolr9:String = "#92d836";
		
		public static const GrayColor:String ="#BBBBBB";		//灰色
		public static const PropTxtColor:String ="#e8ff3d";	//属性类型颜色，黄色
		public static const DescColor:String ="#d3d3d3";		//物品说明文字颜色，浅白
		public static const IsUpColor:String ="#D0EA16";		//提升属性的颜色 绿色
		public static const RedColor:String ="#EA0000";		//达不到要求的颜色，红色
		public static const TextBlueColor:String ="#0474ff";	//浅蓝色
		public static const WhiteColor:String = "#FFFFFF";	//白色
		
		public static const YellowColor:String="#FFFF00";	//黄色
		public static const KhakiColor:String="#FFCC00";	//土黄色
		
		
		public static const ColorArray:Array=[PropTxtColor,DescColor,IsUpColor,RedColor,GrayColor];
		//伙伴品质颜色值,按品质区分,主角为白色
		public static const BuddyColorArray:Array = [WhiteColor, QualityColor1, QualityColor2, QualityColor3, QualityColor4];
		//装备品质颜色值
		public static const ItemColorArray:Array = [GrayColor, WhiteColor, QualityColor1, QualityColor2, QualityColor3, QualityColor4];
		public static const QualityStringArray:Array = ["普通", "优秀", "精良", "传奇", "史诗"];
		
		public static const Color_Line:String = "#656363";	//分割线颜色
		public static const Color_1:String = "#FFEC6A";		//金色
		public static const Color_2:String = "#2189FD";		//深蓝色
		public static const Color_3:String = "#04AC00";		//绿色
		public static const Color_4:String = "#3CBFF5";		//浅蓝色
		
		public static const Prop_Color0:uint =0xFF8c8d8e;
		public static const Prop_Color1:uint =0xFFffffff;
		public static const Prop_Color2:uint =0xFF00ff2a;
		public static const Prop_Color3:uint =0xFF3366f6;
		public static const Prop_Color4:uint =0xFFd7c834;
		public static const Prop_Color5:uint =0xFFff6f20;
		public static const Prop_Color6:uint =0xFFc71ed2;
		
		public static const Prop_TextColor:uint =0xFFe2e1dd;
		public static const Prop_NameColor:uint =0xFFffe49b;

		public static const HButton_UpColor:uint =0xFFffffff;
		public static const HButton_OverColor:uint =0xFFffffff;
		public static const HButton_DownColor:uint =0xFFaaaaaa;
		public static const HButton_DisabledColor:uint =0xFFaaaaaa;
		public static const HButton_SelectedColor:uint =0xFFffffff;
		
		public static const HSimpleButton_UpColor:uint =0xFFb47015;
		public static const HSimpleButton_OverColor:uint =0xFFdbac6d;
		public static const HSimpleButton_DownColor:uint =0xFFa45d0e;
		public static const HSimpleButton_DisabledColor:uint =0xFF8e908f;
		public static const HSimpleButton_SelectedColor:uint =0xFFcb8f42;
		
		
		public static const HTabBar_UpColor:uint =0xFFb47015;
		public static const HTabBar_OverColor:uint =0xFFdbac6d;
		public static const HTabBar_DownColor:uint =0xFFa45d0e;
		public static const HTabBar_DisabledColor:uint =0xFF8e908f;
		public static const HTabBar_SelectedColor:uint =0xFFcb8f42;
		public static const HTabBar_PanelColor:uint =0xFFe4c08b;
		
		public static const HScrollBar_UpColor:uint =0xFFb47015;
		public static const HScrollBar_OverColor:uint =0xFFdbac6d;
		public static const HScrollBar_DownColor:uint =0xFFa45d0e;
		public static const HScrollBar_DisabledColor:uint =0xFF8e908f;
		public static const HScrollBar_SelectedColor:uint =0xFFcb8f42;
		public static const HScrollBar_PanelColor:uint =0xFFa45d0e;
		
		public static const HItmeTips_LineColor:uint =0xFFcb8f42;
		public static const HItmeTips_PanelColor:uint =0xFFa45d0e;
					
		
		public static const HAccordionCell_PanelColor:uint =0;
		
		public static const HProgressBar_UpColor:uint =0xFFb47015;
		public static const HProgressBar_UpLineColor:uint =0xFFa45d0e;
		public static const HProgressBar_DownColor:uint =0xFF0d9b8c;
		public static const HProgressBar_DownLineColor:uint =0xFF007987;
		
		public static const HDataGrid_LineColor:uint =0xFFb47015;
		public static const HDataGrid_TileColor:uint =0xFFcb8f42;
		public static const HDataGrid_PointerColor:uint =0xFFdbac6d;
		
		public static const HTextEffect_TextSize:uint=16;
		public static const HTextEffect_TextFace:String="微软雅黑";
		public static const HTextEffect_TextAlign:String="center";
		public static const HTextEffect_TextColor:uint=0xFFf7fcff;
		public static const HTextEffect_TextShadowColor:uint=0xFF3b869e;
		
		public static const HTextField_Font:String = "宋体";	//游戏中所有显示文本都要定义此字体(除了标题文本)


		public function HCss()  {  }
//		//------------------------------------------------------------------------------------------------------------
//		/**
//		 *  Button皮肤类
//		 */		
//		[Embed(source="css/HDGSkin.swf", symbol="Button_disabledSkin")]
//		public var Button_disabledSkin:Class;
//		[Embed(source="css/HDGSkin.swf", symbol="Button_downSkin")]
//		public var Button_downSkin:Class;
//		[Embed(source="css/HDGSkin.swf", symbol="Button_overSkin")]
//		public var Button_overSkin:Class;
//		[Embed(source="css/HDGSkin.swf", symbol="Button_upSkin")]
//		public var Button_upSkin:Class;		
//		/**
//		 *  Button获得皮肤方法
//		 */	
//		public function HButton(object:Button):void{
//			object.setStyle("disabledSkin",Button_disabledSkin);
//			object.setStyle("downSkin",Button_downSkin);
//			object.setStyle("overSkin",Button_overSkin);
//			object.setStyle("upSkin",Button_upSkin);
//			object.setStyle("fontSize",18);
//			object.setStyle("color",0x0B333C);
//			object.setStyle("fontWeight","bold");
//		}
		//------------------------------------------------------------------------------------------------------------
//		//------------------------------------------------------------------------------------------------------------
//		/**
//		 *  ComboBox皮肤类
//		 */	
//		[Embed(source="css/HDGSkin.swf", symbol="ComboBoxArrow_disabledSkin")]
//		public var ComboBoxArrow_disabledSkin:Class;
//		[Embed(source="css/HDGSkin.swf", symbol="ComboBoxArrow_downSkin")]
//		public var ComboBoxArrow_downSkin:Class;
//		[Embed(source="css/HDGSkin.swf", symbol="ComboBoxArrow_overSkin")]
//		public var ComboBoxArrow_overSkin:Class;
//		[Embed(source="css/HDGSkin.swf", symbol="ComboBoxArrow_upSkin")]
//		public var ComboBoxArrow_upSkin:Class;		
//		/**
//		 *  ComboBox获得皮肤方法
//		 */			
//		public function HComboBox(object:ComboBox):void{
//			object.setStyle("disabledSkin",ComboBoxArrow_disabledSkin);
//			object.setStyle("downSkin",ComboBoxArrow_downSkin);
//			object.setStyle("overSkin",ComboBoxArrow_overSkin);
//			object.setStyle("upSkin",ComboBoxArrow_upSkin);
//			dropDownStyleName: "myComboBoxDropDowns";
//			//backgroundAlpha: 0;
//		}
		//------------------------------------------------------------------------------------------------------------
//		/**
//		 *  textinput获得皮肤方法
//		 */			
//		public function HTextInput(object:TextInput):void{
//			object.setStyle("contentBackgroundAlpha",0);
//			object.setStyle("borderVisible",false);			
//		}
		//------------------------------------------------------------------------------------------------------------
		/**
		 *  TextField获得皮肤方法
		 */			
		public function HTextField(object:TextField,text:String):void{
			object.htmlText="<font color='#0b333c' size='16' face='微软雅黑'>"+text+"</font>\n";
			object.selectable=false;
			object.wordWrap=true;
				
		}
		//------------------------------------------------------------------------------------------------------------
		/**
		 *  TextFieldDiy获得皮肤方法
		 */			
		public function HTextFieldDiy(object:TextField,coler1:String="",size1:String="",text1:String="",coler2:String="",size2:String="",text2:String="",coler3:String="",size3:String="",text3:String="",coler4:String="",size4:String="",text4:String="",coler5:String="",size5:String="",text5:String=""):void{
			object.htmlText="<font color='"+coler1+"' size='"+size1+"' face='微软雅黑'>"+text1+"</font><font color='"+coler2+"' size='"+size2+"' face='微软雅黑'>"+text2+"</font><font color='"+coler3+"' size='"+size3+"' face='微软雅黑'>"+text3+"</font><font color='"+coler4+"' size='"+size4+"' face='微软雅黑'>"+text4+"</font><font color='"+coler5+"' size='"+size5+"' face='微软雅黑'>"+text5+"</font>";
			object.selectable=false;
			object.wordWrap=true;
			
		}
		
		public static function getQualityColor(quality:int):String{
			var color:String = QualityColor0;
			switch( quality ){
				case 0:
					color = QualityColor0;
					break;
				case 1:
					color = QualityColor1;
					break;
				case 2:
					color = QualityColor2;
					break;
				case 3:
					color = QualityColor3;
					break;
				case 4:
					color = QualityColor4;
					break;
			}
			return color;
		} 
		//------------------------------------------------------------------------------------------------------------
//		/**
//		 *  Label获得皮肤方法
//		 */			
//		public function HLabel(object:Label,text:String):void{
//			object.htmlText="<font color='#0b333c' size='16' face='微软雅黑'>"+text+"</font>\n";
//			//object.selectable=false;
//			
//			
//		}
	}
}