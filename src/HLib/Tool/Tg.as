package HLib.Tool
{
	/**
	 * ...
	 * @author yoyo
	 */
	public class Tg 
	{
		/**
		 * 多语言处理 
		 * 错误做法：tf.htmlText = _T('<a href="event:a">中文</a>');对于此类文字只处理中文,正确做法：tf.htmlText = '<a href="event:a">'+_T('中文')+'</a>';
		 * 错误做法：tf.htmlText = _T('你打败了') + player.name+_T(',恭喜你！') ;不要拆分一句完整的话，正确做法：tf.htmlText = _T('你打败了$name,恭喜你！').replace('$name',player.name);
		 * @param key
		 * @return 
		 * 
		 */			
		public static function T(key:String):String
		{
			return LangManager.getValue(key);
		}
		
		
	}

}