package display {
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	
	public class NGraphics extends BaseGraphics {
		private var graphics:Graphics;
		
		private var gradientMatrix:Matrix = new Matrix;
		private var lineShift:Number = -1;
		private var fillinShift:Number = -1;
		
		public function NGraphics(sourceGraphics:Graphics):void {
			super(sourceGraphics);
			graphics = sourceGraphics;
		}
		
		public function beginStripedFill(thickness:Number = 3, firstColor:uint = 0xffffff, secondColor:uint = 0x000000, needShift:Boolean = true, alpha:Number = 1, angle:Number = Math.PI / 4):void {
			if (needShift)
				fillinShift = fillinShift < 700 ? fillinShift + .5 : 0;
			gradientMatrix.createGradientBox(2 * thickness, 2 * thickness, angle, fillinShift, fillinShift);
			graphics.beginGradientFill(GradientType.LINEAR, [firstColor, secondColor], [alpha, alpha], [127, 128], gradientMatrix, SpreadMethod.REPEAT);
		}
		
		public function drawSector(x:Number, y:Number, radius:uint, startAngle:int, endAngle:int):void {
			if (endAngle-startAngle > 360) {
				startAngle %= 360;
				endAngle %= 360;
			}
			if (startAngle > endAngle) {
				endAngle += 360;
			}
			
			var offsetx:Number = x;
			var offsety:Number = y;
			var xc:Number = radius * Math.cos(startAngle * Math.PI / 180);
			var yc:Number = radius * Math.sin(startAngle * Math.PI / 180);
			graphics.moveTo(xc + offsetx, yc + offsety);
			for (var i:int = startAngle + 1; i <= endAngle; i++) {
				xc = radius * Math.cos(i * Math.PI / 180);
				yc = radius * Math.sin(i * Math.PI / 180);
				graphics.lineTo(xc + offsetx, yc + offsety);
			}
			graphics.lineTo(offsetx, offsety);
		}
		
		public function drawSegment(x:Number, y:Number, innerRadius:uint, outerRadius:uint, startAngle:int = 0, endAngle:int = 360):void {
			if (endAngle-startAngle > 360) {
				startAngle %= 360;
				endAngle %= 360;
			}
			if (startAngle > endAngle) {
				endAngle += 360;
			}
			
			var offsetx:Number = x;
			var offsety:Number = y;
			var xc:Number = innerRadius * Math.cos(startAngle * Math.PI / 180);
			var yc:Number = innerRadius * Math.sin(startAngle * Math.PI / 180);
			graphics.moveTo(xc + offsetx, yc + offsety);
			for (var i:int = startAngle + 1; i <= endAngle; i++) {
				xc = innerRadius * Math.cos(i * Math.PI / 180);
				yc = innerRadius * Math.sin(i * Math.PI / 180);
				graphics.lineTo(xc + offsetx, yc + offsety);
			}
			xc = outerRadius * Math.cos(endAngle * Math.PI / 180);
			yc = outerRadius * Math.sin(endAngle * Math.PI / 180);
			graphics.lineTo(xc + offsetx, yc + offsety);
			for (var j:int = endAngle - 1; j >= startAngle; j--) {
				xc = outerRadius * Math.cos(j * Math.PI / 180);
				yc = outerRadius * Math.sin(j * Math.PI / 180);
				graphics.lineTo(xc + offsetx, yc + offsety);
			}
			xc = innerRadius * Math.cos(startAngle * Math.PI / 180);
			yc = innerRadius * Math.sin(startAngle * Math.PI / 180);
			graphics.lineTo(xc + offsetx, yc + offsety);
		}
		
		public function lineStripedStyle(thickness:Number = 3, firstColor:uint = 0xffffff, secondColor:uint = 0x000000, needShift:Boolean = true, alpha:Number = 1, angle:Number = Math.PI / 4):void {
			if (needShift)
				lineShift = lineShift + .5 < 700 ? lineShift + .5 : 0;
			gradientMatrix.createGradientBox(2 * thickness, 2 * thickness, angle, lineShift, lineShift);
			graphics.lineGradientStyle(GradientType.LINEAR, [firstColor, secondColor], [alpha, alpha], [127, 128], gradientMatrix, SpreadMethod.REPEAT);
		}
	}
}
