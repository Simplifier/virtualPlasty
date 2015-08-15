package slider {
	import flash.events.Event;
	public class SliderEvent extends Event {
		public static const X_CHANGED:String = 'xChanged';
		
		internal var _position:Number;
		internal var _relatingValue:Number;
		
		public function SliderEvent(type:String) {
			super(type);
		}
		
		public function get position():Number {
			return _position;
		}
		
		public function get relatingValue():Number {
			return _relatingValue;
		}
	}
}