package progressBar {
	import display.NShape;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class CircleProgressIndicator extends Sprite {
		private var inactiveCircle:NShape = new NShape;
		private var activeCircle:NShape = new NShape;
		
		private var format:TextFormat = new TextFormat("_sans", 11, 0x000000, true, false, false, null, null, TextFormatAlign.LEFT);
		private var tf:TextField = new TextField;
		
		private var _width:int = 290;
		private var _height:int = 54;
		
		public function CircleProgressIndicator() {
			create();
		}
		
		private function create():void{
			mouseChildren = false;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.defaultTextFormat = format;
			
			inactiveCircle.ngraphics.beginFill(0xcccccc);
			inactiveCircle.ngraphics.drawSegment(0, 0, 10, 15);
			inactiveCircle.ngraphics.endFill();
			
			addChild(inactiveCircle);
			addChild(activeCircle);
			addChild(tf);
			update(1);
		}
		
		public function update(progress:Number):void {
			tf.text = Math.round(100 * progress) + '%';
			tf.x = -tf.width / 2;
			tf.y = -tf.height / 2;
			
			var endAngle:int = Math.round(360 * progress);
			
			activeCircle.graphics.clear();
			activeCircle.graphics.beginFill(0x5588ff);
			activeCircle.ngraphics.drawSegment(0, 0, 10, 15, 0, endAngle);
			activeCircle.graphics.endFill();
		}
	}

}