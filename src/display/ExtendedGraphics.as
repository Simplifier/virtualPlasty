package display{
	import flash.display.*;
	import flash.geom.Matrix;
	
	public class ExtendedGraphics {
		private var graphics:Graphics;
		private var gradientMatrix:Matrix = new Matrix;
		private var lineShift:Number = -1;
		private var fillinShift:Number = -1;
		
		public function ExtendedGraphics(graphics:Graphics):void {
			this.graphics = graphics;
		}
		
		public function lineStripedStyle(thickness:Number = 3, firstColor:uint = 0xffffff, secondColor:uint = 0x000000, needShift:Boolean = true, alpha:Number = 1, angle:Number = Math.PI / 4):void {
			if (needShift)
				lineShift = lineShift + .5 < 700 ? lineShift + .5 : 0;
			gradientMatrix.createGradientBox(2 * thickness, 2 * thickness, angle, lineShift, lineShift);
			graphics.lineGradientStyle(GradientType.LINEAR, [firstColor, secondColor], [alpha, alpha], [127, 128], gradientMatrix, SpreadMethod.REPEAT);
		}
		
		public function beginStripedFill(thickness:Number = 3, firstColor:uint = 0xffffff, secondColor:uint = 0x000000, needShift:Boolean = true, alpha:Number = 1, angle:Number = Math.PI / 4):void {
			if (needShift)
				fillinShift = fillinShift < 700 ? fillinShift + .5 : 0;
			gradientMatrix.createGradientBox(2 * thickness, 2 * thickness, angle, fillinShift, fillinShift);
			graphics.beginGradientFill(GradientType.LINEAR, [firstColor, secondColor], [alpha, alpha], [127, 128], gradientMatrix, SpreadMethod.REPEAT);
		}
	}
}
