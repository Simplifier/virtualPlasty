package slider {
	import flash.events.EventDispatcher;
	[Event(name = "xChanged", type = "slider.SliderEvent")]
	public class Model extends EventDispatcher {
		private var progressCalculator:IProgressCalculator;
		private var linearCalculator:IProgressCalculator;
		private var exponentialCalculator:IProgressCalculator;
		
		private var _position:Number;
		private var _relatingValue:Number;
		private var min:Number;
		private var max:Number;
		
		public function Model(min:Number = 0, max:Number = 1, scaleMode:String = SliderConstructor.LINEAR) {
			if (min >= max) {
				throw new Error('максимум должен быть больше минимума');
			}
			
			this.max = max;
			this.min = min;
			linearCalculator = new LinearCalculator(min, max);
			exponentialCalculator = new ExponentialCalculator(min, max);
			
			switch(scaleMode) {
				case SliderConstructor.LINEAR:
					progressCalculator = linearCalculator;
					break;
				case SliderConstructor.EXPONENTIAL:
					progressCalculator = exponentialCalculator;
					break;
				default:
					throw new ArgumentError('an unsupported scale mode: ' + scaleMode);
			}
		}
		
		public function get position():Number {
			return _position;
		}
		
		public function set position(value:Number):void {
			_position = verifyPosition(value);
			_relatingValue = progressCalculator.calcValue(position);
			dispatchXChanged();
		}
		
		public function get relatingValue():Number {
			return _relatingValue;
		}
		
		public function set relatingValue(value:Number):void {
			_relatingValue = verifyValue(value);
			_position = progressCalculator.calcPosition(relatingValue);
			dispatchXChanged();
		}
		
		private function dispatchXChanged():void {
			var evt:SliderEvent = new SliderEvent(SliderEvent.X_CHANGED);
			evt._position = position;
			evt._relatingValue = relatingValue;
			dispatchEvent(evt);
		}
		
		private function verifyPosition(pos:Number):Number {
			if (pos < 0) {
				pos = 0;
			} else if (pos > 1) {
				pos = 1;
			}
			
			return pos;
		}
		
		private function verifyValue(value:Number):Number {
			if (value < min) {
				value = min;
			} else if (value > max) {
				value = max;
			}
			
			return value;
		}
	}
}

interface IProgressCalculator {
	function calcValue(pos:Number):Number;
	function calcPosition(value:Number):Number;
}

class LinearCalculator implements IProgressCalculator {
	private var min:Number;
	private var max:Number;
	public function LinearCalculator(min:Number, max:Number) {
		this.max = max;
		this.min = min;
	}
	
	public function calcValue(pos:Number):Number {
		return pos * (max - min) + min;
	}
	
	public function calcPosition(value:Number):Number {
		return (value - min) / (max - min);
	}
}

class ExponentialCalculator implements IProgressCalculator {
	private static const INVERSE_EXP:Number = Math.pow(Math.E, -1);
	
	private var min:Number;
	private var max:Number;
	public function ExponentialCalculator(min:Number, max:Number) {
		this.max = max;
		this.min = min;
	}
	
	public function calcValue(pos:Number):Number {
		//An exponent is calculated for range from -1 to .75
		var deg:Number = pos * 1.75 - 1;
		return (Math.pow(Math.E, deg) - INVERSE_EXP) * (max - min) / (Math.pow(Math.E, .75) - INVERSE_EXP) + min;
	}
	
	public function calcPosition(value:Number):Number {
		var exponent:Number = (value-min) * (Math.pow(Math.E, .75) - INVERSE_EXP) / (max - min) + INVERSE_EXP;//equals pow(e, arg)
		var arg:Number = Math.log(exponent);//from -1 to .75
		return (arg + 1) / 1.75;
	}
}