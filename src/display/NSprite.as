package display{
	import flash.display.Sprite;
	
	public class NSprite extends Sprite {
		private var _graphics:NGraphics = new NGraphics(graphics);
		
		public function get ngraphics():NGraphics {
			return _graphics;
		}
	}
}