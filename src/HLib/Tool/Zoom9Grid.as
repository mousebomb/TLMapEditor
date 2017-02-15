package HLib.Tool
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * 利用九宫格缩放算法对BitmapData或DisplayObject进行缩放.
	 * 
	 * <p>IBitmapDrawable是flash.display中的一个接口,实现它的具体类有BitmapData和DisplayObject.</p>
	 * 
	 * <p>九宫格缩放指的是将目标对象分割到9个矩形区域的网格中,
	 * 在缩放时对中间的网格进行宽高变更操作,对上下两块矩形进行宽度变更操作,
	 * 对左右两块矩形进行高度变更操作,对四角的四块矩形不进行任何缩放,
	 * 只是将它移至四个角落,从而形成不破坏图片原型的缩放算法.</p>
	 * 
	 * @author sunbright
	 */
	public class Zoom9Grid
	{
		private var _width:int;
		private var _height:int;
		private var _scaleX:Number = 1;
		private var _scaleY:Number = 1;
		private var _grid:Rectangle;
		private var data:BitmapData;
		
		private var needUpdate:Boolean = true;
		private var image:BitmapData;
		
		/**
		 * 创建九宫格缩放实例.
		 * 
		 * @param source 实现过IBitmapDrawable的对象,其中包括BitmapData和DisplayObject.
		 * @param rect 缩放的九个格子中,最中间格子的矩形框.
		 */
		public function Zoom9Grid(source:BitmapData, rect:Rectangle = null)
		{
			data = source;
			_grid = rect;
			_width = data.width;
			_height = data.height;
			
//			update();
		}
		/**
		 * 更新图像,该方法一般情况下是自动调用.
		 */
		public function update():void
		{
			needUpdate = false;
			
			var width:int = _width * _scaleX;
			var height:int = _height * _scaleY;
			image = new BitmapData(width, height, true, 0);
			if(data.width == width && data.height == height) image.draw(data);
			else{
				var rows:Array = [0, _grid.top , _grid.bottom, data.height];
				var cols:Array = [0, _grid.left, _grid.right , data.width ];
				
				var toRows:Array = [0, _grid.top , height - data.height + _grid.bottom, height];
				var toCols:Array = [0, _grid.left, width - data.width + _grid.right , width ];
				
				var clipRect:Rectangle, matrix:Matrix, r:int, c:int, a:Number, d:Number;
				var r1:int, r2:int, c1:int, c2:int, tr1:int, tr2:int, tc1:int, tc2:int;
				
				for(c = 0; c < 3; c ++){
					for(r = 0; r < 3; r ++){
						r1 = rows [r]; r2 = rows [r + 1];
						c1 = cols [c]; c2 = cols [c + 1];
						tr1 = toRows[r]; tr2 = toRows[r + 1];
						tc1 = toCols[c]; tc2 = toCols[c + 1];
						clipRect = new Rectangle(tc1,tr1,tc2 - tc1,tr2 - tr1);
						a = c == 1 ? clipRect.width / (c2 - c1) : 1;
						d = r == 1 ? clipRect.height / (r2 - r1) : 1;
						matrix = new Matrix(a, 0, 0, d, tc1 - c1 * a, tr1 - r1 * d);
						
						image.draw(data, matrix, null, null, clipRect, true);
					}
				}
			}
		}
		/**
		 * 获取最新的图像,如果需要更新,会自动启动更新图像.
		 * 
		 * @return 返回进行过九宫格缩放操作过的图像.
		 */
		public function get bitmap():Bitmap{
			if(needUpdate) update();
			return new Bitmap(image);
		}
		/**
		 * 获取最新的图像数据,如果需要更新,会自动启动更新图像数据.
		 * 
		 * @return 返回进行过九宫格缩放操作过的图像数据.
		 */
		public function get bitmapData():BitmapData{
			if(needUpdate) update();
			return image;
		}
		/**
		 * 设置最中心的区域的有效缩放矩形框.
		 * 
		 * @param value 有效缩放矩形框.
		 */
		public function set grid(value:Rectangle):void{
			needUpdate = true;
			if(!value) value = new Rectangle;
			_grid = value;
		}
		/**
		 * 获取当前有效缩放矩形框.
		 * 
		 * @return 返回当前有效缩放矩形框.
		 */
		public function get grid():Rectangle{
			return _grid;
		}
		/**
		 * 设置宽度.
		 * 
		 * @param value 宽度.
		 */
		public function set width(value:int):void{
			if(value == _width) return;
			needUpdate = true;
			_width = value;
		}
		/**
		 * 获取宽度.
		 * 
		 * @return 返回宽度.
		 */
		public function get width():int{
			return _width;
		}
		/**
		 * 设置高度.
		 * 
		 * @param value 高度.
		 */
		public function set height(value:int):void{
			if(value == _height) return;
			needUpdate = true;
			_height = value;
		}
		/**
		 * 获取高度.
		 * 
		 * @return 返回高度.
		 */
		public function get height():int{
			return _height;
		}
		/**
		 * 设置相对于对象的横向缩放比例.
		 * 
		 * @param value (0-1)的缩放比例.
		 */
		public function set scaleX(value:Number):void{
			if(value == _scaleX) return;
			needUpdate = true;
			_scaleX = value;
		}
		/**
		 * 获取相对于对象的横向缩放比例.
		 * 
		 * @return 返回缩放比例.
		 */
		public function get scaleX():Number{
			return _scaleX;
		}
		/**
		 * 设置相对于对象的纵向缩放比例.
		 * 
		 * @param value (0-1)的缩放比例.
		 */
		public function set scaleY(value:Number):void{
			if(value == _scaleY) return;
			needUpdate = true;
			_scaleY = value;
		}
		/**
		 * 获取相对于对象的纵向缩放比例.
		 * 
		 * @return 返回缩放比例.
		 */
		public function get scaleY():Number{
			return _scaleY;
		}
		
		public function dispose():void
		{
			data = null;
			image.dispose();
		}
	}
}