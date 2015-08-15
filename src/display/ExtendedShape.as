package display{
	import flash.display.*;
	
	public class ExtendedShape extends Shape {
		private var _graphics:ExtendedGraphics = new ExtendedGraphics(graphics);
		
		public function get extendedGraphics():ExtendedGraphics {
			return _graphics;
		}
	}
}