package slider {
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class Slider extends Sprite {
		private var _slider:Sprite = new Sprite;
		private var line:Shape = new Shape;
		private var thumb:Sprite = new Sprite;
		private var valueField:TextField = new TextField;
		private var labelField:TextField = new TextField;
		private var tFormat:TextFormat = new TextFormat;
		private var gradientMatrix:Matrix = new Matrix;
		private const changeEvent:Event = new Event(Event.CHANGE);
		
		private var _width:Number;
		private var _min:Number;
		private var _max:Number;
		private var _value:Number;
		private var _scaleMode:String;
		private var _label:String;
		
		private var thumbSize:int = 10;
		private var thumbIsPressed:Boolean;
		
		private var _position:Number;
		
		private var inverseExp:Number = Math.pow(Math.E, -1);
		
		public static const LINEAR:String = 'linear';
		public static const EXPONENTIAL:String = 'exponential';
		
		public function Slider(label:String, width:int = 200, min:Number = 0, max:Number = 1, initialValue:Number = 0, scaleMode:String = LINEAR) {
			if (min >= max)
				throw new Error('максимум должен быть больше минимума');
			_width = width;
			_min = min;
			_max = max;
			_scaleMode = scaleMode;
			_label = label;
			value = initialValue;
			
			line.graphics.lineStyle(2, 0x99CCFF);
			line.graphics.lineTo(_width, 0);
			
			var circle:Shape = new Shape;
			gradientMatrix.createGradientBox(3.5 * thumbSize, 3.5 * thumbSize, 0, -2.3 * thumbSize, -2 * thumbSize);
			circle.graphics.beginGradientFill(GradientType.RADIAL, [0x99CC66, 0xCBFF3F], [1, 1], [0, 255], gradientMatrix);//99CC66 || FF5F23
			circle.graphics.drawCircle(0, 0, thumbSize / 2);
			
			var topCircle:Shape = new Shape;
			topCircle.graphics.lineStyle(2, 0xffffff);
			topCircle.graphics.drawCircle(0, 0, thumbSize / 2);
			topCircle.filters = [new DropShadowFilter(1, 45, 0, .4, 2, 2, 1, BitmapFilterQuality.HIGH)];
			
			thumb.buttonMode = true;
			
			tFormat.font = 'Arial';
			tFormat.size = 12;
			labelField.defaultTextFormat = tFormat;
			labelField.mouseEnabled = false;
			labelField.autoSize = TextFieldAutoSize.LEFT;
			labelField.text = label;
			labelField.y = thumbSize / 2 - labelField.textHeight;
			
			_slider.graphics.beginFill(0, 0);
			_slider.graphics.drawRect(0, -thumbSize / 2, _width, thumbSize);
			_slider.x = labelField.width + thumbSize / 2 + 3;
			
			valueField.defaultTextFormat = tFormat;
			valueField.autoSize = TextFieldAutoSize.LEFT;
			valueField.mouseEnabled = false;
			valueField.x = _slider.x + _width + thumbSize / 2 + 5;
			valueField.y = thumbSize / 2 - valueField.textHeight;
			
			addChild(_slider);
			_slider.addChild(line);
			_slider.addChild(thumb);
			thumb.addChild(circle);
			thumb.addChild(topCircle);
			addChild(labelField);
			addChild(valueField);
			
			_slider.addEventListener(MouseEvent.MOUSE_DOWN, onSliderDown);
		}
		
		private function onSliderDown(e:MouseEvent):void {
			thumb.x = checkPosition(_slider.mouseX);
			_position = thumb.x;
			calcValue();
			valueField.text = String(Math.round(_value));
			
			dispatchEvent(changeEvent);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onThumbMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onThumbUp);
			
			e.updateAfterEvent();
			thumbIsPressed = true;
		}
		
		private function onThumbMouseMove(e:MouseEvent):void {
			thumb.x = checkPosition(_slider.mouseX);
			_position = thumb.x;
			calcValue();
			valueField.text = String(Math.round(_value));
			
			dispatchEvent(changeEvent);
			
			e.updateAfterEvent();
		}
		
		private function calcValue():void {
			if (_scaleMode == LINEAR) {
				_value = _position * (_max - _min) / _width + _min;
			} else if (_scaleMode == EXPONENTIAL) {
				//Exponent is used for argument from -1 to .75
				var deg:Number = _position / _width * 1.75 - 1;
				_value = (Math.pow(Math.E, deg) - inverseExp) * (_max - _min) / (Math.pow(Math.E, .75) - inverseExp) + _min;
			}
		}
		
		private function calcPosition():void {
			if (_scaleMode == LINEAR) {
				_position = (_value - _min) * _width / (_max - _min);
			} else if (_scaleMode == EXPONENTIAL) {
				var exponent:Number = (_value-_min) * (Math.pow(Math.E, .75) - inverseExp) / (_max - _min) + inverseExp;//equals pow(e, arg)
				var arg:Number = Math.log(exponent);//from -1 to .75
				_position = (arg + 1) * _width / 1.75;
			}
		}
		
		private function onThumbUp(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onThumbMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onThumbUp);
			
			thumbIsPressed = false;
		}
		
		private function checkPosition(xPos:Number):Number {
			if (xPos < 0)
				xPos = 0;
			else if (xPos > _width)
				xPos = _width;
			return xPos;
		}
		
		override public function get width():Number {
			return _width;
		}
		
		override public function set width(value:Number):void {
			_width = value;
			
			line.graphics.clear();
			line.graphics.lineStyle(2, 0x99CCFF);
			line.graphics.lineTo(_width, 0);
		}
		
		public function get overallWidth():Number {
			return super.width;
		}
		
		public function get min():Number {
			return _min;
		}
		
		public function set min(value:Number):void {
			_min = value;
		}
		
		public function get max():Number {
			return _max;
		}
		
		public function set max(value:Number):void {
			_max = value;
		}
		
		public function get value():Number {
			return _value;
		}
		
		public function set value(value:Number):void {
			_value = value;
			valueField.text = String(Math.round(_value));
			
			calcPosition();
			thumb.x = _position;
		}
		
		public function get scaleMode():String {
			return _scaleMode;
		}
		
		public function set scaleMode(value:String):void {
			_scaleMode = value;
		}
		
		public function get label():String {
			return _label;
		}
		
		public function set label(value:String):void {
			_label = value;
		}
	}
}