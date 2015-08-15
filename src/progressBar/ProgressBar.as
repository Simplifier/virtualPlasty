package progressBar {
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	
	public class ProgressBar extends Sprite {
		private var back:Shape = new Shape;
		private var inactiveLine:Shape = new Shape;
		private var activeLine:Shape = new Shape;
		private var linesContainer:Sprite = new Sprite;
		
		private var _width:int = 290;
		private var _height:int = 54;
		private var lineWidth:int = 250;
		private var lineHeight:int = 8;
		private var gradientMatrix:Matrix = new Matrix;
		
		public function ProgressBar() {
			//mouseEnabled = false;
			mouseChildren = false;
			//draw background
			gradientMatrix.createGradientBox(_width, _height, Math.PI / 2);
			back.graphics.beginGradientFill(GradientType.LINEAR, [0xEEEEEE, 0xE2E2E2], [1, 1], [0, 255], gradientMatrix);
			back.graphics.drawRoundRect(0, 0, _width, _height, 7);
			back.graphics.endFill();
			back.filters = [new DropShadowFilter(3, 45, 0, .5, 5, 5, 1, BitmapFilterQuality.HIGH)];
			//draw lines of loading
			inactiveLine.graphics.beginFill(0xcccccc);
			inactiveLine.graphics.drawRect(0, 0, lineWidth, lineHeight);
			inactiveLine.graphics.endFill();
			
			linesContainer.x = _width / 2 - lineWidth / 2;
			linesContainer.y = _height / 2 - lineHeight / 2;
			linesContainer.filters = [new DropShadowFilter(2, 45, 0, .5, 5, 5, 1, BitmapFilterQuality.HIGH, true), new DropShadowFilter(1, 90, 0xffffff, .9, 1.5, 1.5, 1, BitmapFilterQuality.HIGH)];
			
			addChild(back);
			addChild(linesContainer);
			linesContainer.addChild(inactiveLine);
			linesContainer.addChild(activeLine);
		}
		
		public function update(progress:Number):void {
			activeLine.graphics.clear();
			//activeLine.graphics.beginFill(0x7AF77A);
			activeLine.graphics.beginFill(0xA0FAA0);
			activeLine.graphics.drawRect(0, 0, lineWidth * progress, lineHeight);
			activeLine.graphics.endFill();
		}
	}

}