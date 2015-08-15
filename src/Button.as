package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class Button extends Sprite {
		private var tField:TextField = new TextField;
		private var tFormat:TextFormat = new TextFormat;
		private var overSkin:Shape = new Shape;
		
		public function Button(label:String):void {
			buttonMode = true;
			
			tFormat.font = 'Arial';
			tFormat.size = 12;
			tField.defaultTextFormat = tFormat;
			tField.mouseEnabled = false;
			tField.autoSize = TextFieldAutoSize.LEFT;
			tField.text = label;
			tField.x = 10;
			tField.y = 1;
			
			var matrix:Matrix = new Matrix;
			matrix.createGradientBox(tField.width + 20, tField.height + 2, Math.PI / 2);
			graphics.beginGradientFill(GradientType.LINEAR, [0xDBDBDB, 0xFbFbFb, 0xededed, 0xffffff], [1, 1, 1, 1], [0, 128, 128, 255], matrix);
			graphics.lineStyle(1, 0xCCCCCC, 1, true);
			graphics.drawRoundRect(0, 0, tField.width + 20, tField.height + 2, 7);
			graphics.endFill();
			
			//overSkin.graphics.beginGradientFill(GradientType.LINEAR, [0xDBDBDB, 0xffffff], [1, 1], [0, 255], matrix);
			overSkin.graphics.beginGradientFill(GradientType.LINEAR, [0xDBDBDB, 0xFbFbFb, 0xededed, 0xffffff], [1, 1, 1, 1], [0, 128, 128, 255], matrix);
			overSkin.graphics.lineStyle(1, 0xFF9933, 1, true);
			overSkin.graphics.drawRoundRect(0, 0, tField.width + 20, tField.height + 2, 7);
			overSkin.graphics.endFill();
			overSkin.visible = false;
			
			addChild(overSkin);
			addChild(tField);
			
			filters = [new DropShadowFilter(2, 45, 0, .5, 2, 2, 1, BitmapFilterQuality.HIGH)];
			
			addEventListener(MouseEvent.ROLL_OVER, onOver);
			addEventListener(MouseEvent.ROLL_OUT, onOut);
		}
		
		private function onOver(e:MouseEvent):void {
			overSkin.visible = true;
		}
		
		private function onOut(e:MouseEvent):void {
			overSkin.visible = false;
		}
	}
}