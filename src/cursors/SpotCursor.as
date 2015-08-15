package cursors{
	import flash.display.*;
	
	public class SpotCursor extends Sprite {
		private var _radius:Number;
		
		public function SpotCursor() {
			graphics.lineStyle(0, 0x808080);
			graphics.drawCircle(0, 0, 100);
			width = 0;
			height = 0;
			blendMode = BlendMode.INVERT;
		
		}
		
		public function get radius():Number {
			return _radius;
		}
		
		public function set radius(value:Number):void {
			_radius = value;
			width = 2 * radius;
			height = 2 * radius;
		}
	}
}