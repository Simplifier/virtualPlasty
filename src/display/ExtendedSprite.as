package display{
	import flash.display.*;
	
	public class ExtendedSprite extends Sprite {
		private var _graphics:ExtendedGraphics = new ExtendedGraphics(graphics);
		
		public function get extendedGraphics():ExtendedGraphics {
			return _graphics;
		}
	}
}