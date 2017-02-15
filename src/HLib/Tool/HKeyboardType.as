package HLib.Tool
{
	/**
	 * 键盘事件Type值枚举
	 * @author 李舒浩 
	 */	
	
	
	public class HKeyboardType
	{
		public static function getKeyType(keyCode:int):String
		{
			//			trace(keyCode);
			switch(keyCode)
			{
				case 8: 	return "BackSpace"; break;//回退
				case 9: 	return "Tab"; 	break;
				case 13: 	return "Enter"; break;	//回车
				case 16: 	return "Shift"; 	break;
				case 17: 	return "Ctrl"; 	break;
				case 27:	return "Esc"; 	break;
				case 32: 	return "Space"; 	break;	//空格
				case 37: 	return "←";break;
				case 38: 	return "↑";break;
				case 39: 	return "→";break;
				case 40: 	return "↓";break;
				case 48: 	return "0"; 	break;
				case 49: 	return "1"; 	break;
				case 50: 	return "2"; 	break;
				case 51: 	return "3"; 	break;
				case 52: 	return "4"; 	break;
				case 53: 	return "5"; 	break;
				case 54: 	return "6"; 	break;
				case 55: 	return "7"; 	break;
				case 56: 	return "8"; 	break;
				case 57: 	return "9"; 	break;
				case 65: 	return "A"; break;
				case 66: 	return "B"; break;
				case 67: 	return "C"; break;
				case 68: 	return "D"; break;
				case 69: 	return "E"; break;
				case 70: 	return "F"; break;
				case 71: 	return "G"; break;
				case 72: 	return "H"; break;
				case 74: 	return "J"; break;
				case 75: 	return "K"; break;
				case 76: 	return "L"; break;
				case 73: 	return "I"; break;
				case 77: 	return "M"; break;
				case 78: 	return "N"; break;
				case 79: 	return "O"; break;
				case 80: 	return "P"; break;
				case 81: 	return "Q"; break;
				case 82: 	return "R"; break;
				case 83: 	return "S"; break;
				case 84: 	return "T"; break;
				case 85: 	return "U"; break;
				case 86: 	return "V"; break;
				case 87: 	return "W"; break;
				case 88: 	return "X"; break;
				case 89: 	return "Y"; break;
				case 90: 	return "Z"; break;
				case 186: 	return ";"; 	break;
				case 187: 	return "="; 	break;
				case 188: 	return ","; 	break;
				case 189: 	return "-"; 	break;
				case 187: 	return "."; 	break;
				case 191: 	return "/"; break;
				case 192:	return "~"; 	break;
				case 222: 	return "'"; 	break;
				case 220: 	return "?"; 	break;
				case 96: 	return "Num0"; break;//以下都是数字键盘中按键
				case 97: 	return "Num1"; break;
				case 98: 	return "Num2"; break;
				case 99: 	return "Num3"; break;
				case 100: 	return "Num4"; break;
				case 101: 	return "Num5"; break;
				case 102: 	return "Num6"; break;
				case 103: 	return "Num7"; break;
				case 104: 	return "Num8"; break;
				case 105: 	return "Num9"; break;
				case 107:	return "Num+"; break;
				case 109:	return "Num-"; break; 
				case 110: 	return "Num."; 	break;
			}
			return "";
		}
		public static function getKeyCode(key:String):int
		{
			//			trace(keyCode);
			switch(key)
			{
				case "Esc":	return 27; 	break;
				case "~":	return 192; 	break;
				case "1": 	return 49; 	break;
				case "2": 	return 50; 	break;
				case "3": 	return 51; 	break;
				case "4": 	return 52; 	break;
				case "5": 	return 53; 	break;
				case "6": 	return 54; 	break;
				case "7": 	return 55; 	break;
				case "8": 	return 56; 	break;
				case "9": 	return 57; 	break;
				case "0": 	return 48; 	break;
				case "-": 	return 189; 	break;
				case "BackSpace": 	return 8; break;//回退
				case "Tab": 	return 9; 	break;
				case "Shift": 	return 16; 	break;
				case "Ctrl": 	return 17; 	break;
				case "Space": 	return 32; 	break;	//空格
				case "Q": 	return 81; break;
				case "W": 	return 87; break;
				case "E": 	return 69; break;
				case "R": 	return 82; break;
				case "T": 	return 84; break;
				case "Y": 	return 89; break;
				case "U": 	return 85; break;
				case "I": 	return 73; break;
				case "O": 	return 79; break;
				case "P": 	return 80; break;
				case "Enter": 	return 13; break;	//回车
				case "A": 	return 65; break;
				case "S": 	return 83; break;
				case "D": 	return 68; break;
				case "F": 	return 70; break;
				case "G": 	return 71; break;
				case "H": 	return 72; break;
				case "J": 	return 74; break;
				case "K": 	return 75; break;
				case "L": 	return 76; break;
				case "Z": 	return 90; break;
				case "X": 	return 88; break;
				case "C": 	return 67; break;
				case "V": 	return 86; break;
				case "B": 	return 66; break;
				case "N": 	return 78; break;
				case "M": 	return 77; break;
				case "/": 	return 191; break;
				case "←": 	return 37;break;
				case "↑": 	return 38;break;
				case "→": 	return 39;break;
				case "↓": 	return 40;break;
				case "Num0": 	return 96; break;//以下都是数字键盘中按键
				case "Num1": 	return 97; break;
				case "Num2": 	return 98; break;
				case "Num3": 	return 99; break;
				case "Num4": 	return 100; break;
				case "Num5": 	return 101; break;
				case "Num6": 	return 102; break;
				case "Num7": 	return 103; break;
				case "Num8": 	return 104; break;
				case "Num9": 	return 105; break;
				case "Num+":	return 107; break;
				case "Num-":	return 109; break;
			}
			return -1;
		}
		
		public static function getSkillKeyType(keyCode:int):String
		{
			switch(keyCode)
			{
				case 48: 	return "0"; 	break;
				case 49: 	return "1"; 	break;
				case 50: 	return "2"; 	break;
				case 51: 	return "3"; 	break;
				case 52: 	return "4"; 	break;
				case 53: 	return "5"; 	break;
				case 54: 	return "6"; 	break;
				case 55: 	return "7"; 	break;
				case 56: 	return "8"; 	break;
				case 57: 	return "9"; 	break;
				case 65: 	return "A"; break;
				case 66: 	return "B"; break;
				case 67: 	return "C"; break;
				case 68: 	return "D"; break;
				case 69: 	return "E"; break;
				case 70: 	return "F"; break;
				case 71: 	return "G"; break;
				case 72: 	return "H"; break;
				case 74: 	return "J"; break;
				case 75: 	return "K"; break;
				case 76: 	return "L"; break;
				case 73: 	return "I"; break;
				case 77: 	return "M"; break;
				case 78: 	return "N"; break;
				case 79: 	return "O"; break;
				case 80: 	return "P"; break;
				case 81: 	return "Q"; break;
				case 82: 	return "R"; break;
				case 83: 	return "S"; break;
				case 84: 	return "T"; break;
				case 85: 	return "U"; break;
				case 86: 	return "V"; break;
				case 87: 	return "W"; break;
				case 88: 	return "X"; break;
				case 89: 	return "Y"; break;
				case 90: 	return "Z"; break;
				case 186: 	return ";"; 	break;
				case 187: 	return "="; 	break;
				case 188: 	return ","; 	break;
				case 189: 	return "-"; 	break;
				case 187: 	return "."; 	break;
				case 191: 	return "/"; break;
				case 192:	return "~"; 	break;
				case 222: 	return "'"; 	break;
				case 220: 	return "|"; 	break;
			}
			return "";
		}
	}
}