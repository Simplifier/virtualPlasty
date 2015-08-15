package slider {
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	public class View extends Sprite implements ISliderView {
		private var _slider:Sprite = new Sprite;
		private var line:Shape = new Shape;
		private var thumb:Sprite = new Sprite;
		
		private var labelField:TextField = new TextField;
		private var valueField:TextField = new TextField;
		private var tFormat:TextFormat = new TextFormat;
		
		private var gradientMatrix:Matrix = new Matrix;
		
		private var _width:Number;
		private var _label:String;
		
		private var thumbSize:int = 10;
		
		private var controller:Controller;
		private var model:Model;
		private var _stage:Stage;
		public function View(controller:Controller, model:Model, label:String, width:int = 200) {
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
			
			create(label, width, controller, model);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_stage = stage;
		}
		
		private function create(label:String, width:int, controller:Controller, model:Model):void {
			this.model = model;
			this.controller = controller;
			_width = width;
			_label = label;
			
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
			valueField.y = thumbSize / 2 - labelField.textHeight;
			
			addChild(_slider);
			_slider.addChild(line);
			_slider.addChild(thumb);
			thumb.addChild(circle);
			thumb.addChild(topCircle);
			addChild(labelField);
			addChild(valueField);
			
			_slider.addEventListener(MouseEvent.MOUSE_DOWN, slider_mouseDownHandler);
			model.addEventListener(SliderEvent.X_CHANGED, model_xChangedHandler);
		}
		
		private function model_xChangedHandler(e:SliderEvent):void {
			thumb.x = e.position * _width;
			valueField.text = String(Math.round(e.relatingValue));
		}
		
		private function slider_mouseDownHandler(e:MouseEvent):void {
			controller.changePosHandler(_slider.mouseX / _width);
			
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			_stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		}
		
		private function stage_mouseMoveHandler(e:MouseEvent):void {
			controller.changePosHandler(_slider.mouseX / _width);
			e.updateAfterEvent();
		}
		
		private function stage_mouseUpHandler(e:MouseEvent):void {
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		}
	}
}