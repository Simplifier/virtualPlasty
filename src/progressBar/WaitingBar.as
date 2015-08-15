package progressBar {
	import display.ExtendedShape;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.utils.Timer;
	
	public class WaitingBar extends Sprite {
		private var back:Shape = new Shape;
		private var activeLine:ExtendedShape = new ExtendedShape;
		
		private var _width:int = 290;
		private var _height:int = 54;
		private var lineWidth:int = 250;
		private var lineHeight:int = 8;
		private var gradientMatrix:Matrix = new Matrix;
		private var animationTimer:Timer = new Timer(50);
		
		public function WaitingBar() {
			//mouseEnabled = false;
			mouseChildren = false;
			//draw background
			gradientMatrix.createGradientBox(_width, _height, Math.PI / 2);
			back.graphics.beginGradientFill(GradientType.LINEAR, [0xEEEEEE, 0xE2E2E2], [1, 1], [0, 255], gradientMatrix);
			back.graphics.drawRoundRect(0, 0, _width, _height, 7);
			back.graphics.endFill();
			back.filters = [new DropShadowFilter(3, 45, 0, .5, 5, 5, 1, BitmapFilterQuality.HIGH)];
			
			activeLine.x = _width / 2 - lineWidth / 2;
			activeLine.y = _height / 2 - lineHeight / 2;
			activeLine.filters = [new DropShadowFilter(2, 45, 0, .5, 5, 5, 1, BitmapFilterQuality.HIGH, true), new DropShadowFilter(1, 90, 0xffffff, .9, 1.5, 1.5, 1, BitmapFilterQuality.HIGH)];
			
			addChild(back);
			addChild(activeLine);
			
			animationTimer.addEventListener(TimerEvent.TIMER, onAnimationTimer);
		}
		
		public function start():void {
			if (!animationTimer.running) animationTimer.start();
		}
		
		public function stop():void {
			if (animationTimer.running) animationTimer.stop();
		}
		
		private function onAnimationTimer(e:TimerEvent):void {
			activeLine.graphics.clear();
			activeLine.extendedGraphics.beginStripedFill(10, 0xffffff, 0xA0FAA0);
			activeLine.graphics.drawRect(0, 0, lineWidth, lineHeight);
			activeLine.graphics.endFill();
			e.updateAfterEvent();
		}
	}

}