package display {
	import flash.display.Shape;
	
	public class NShape extends Shape {
		private var _graphics:NGraphics = new NGraphics(graphics);
		
		public function get ngraphics():NGraphics {
			return _graphics;
		}
	}
}