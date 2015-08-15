package display{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.IGraphicsData;
	import flash.display.Shader;
	import flash.geom.Matrix;
	
	public class BaseGraphics implements IGraphics {
		private var graphics:Graphics;
		
		public function BaseGraphics(sourceGraphics:Graphics):void {
			graphics = sourceGraphics;
		}
		
		public function beginBitmapFill(bitmap:BitmapData, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false):void {
			graphics.beginBitmapFill(bitmap, matrix, repeat, smooth);
		}
		
		public function beginFill(color:uint, alpha:Number = 1):void {
			graphics.beginFill(color, alpha);
		}
		
		public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number = 0):void {
			graphics.beginGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
		}
		
		public function beginShaderFill(shader:Shader, matrix:Matrix = null):void {
			graphics.beginShaderFill(shader, matrix);
		}
		
		public function clear():void {
			graphics.clear();
		}
		
		public function copyFrom(sourceGraphics:Graphics):void {
			graphics.copyFrom(sourceGraphics);
		}
		
		public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void {
			graphics.curveTo(controlX, controlY, anchorX, anchorY);
		}
		
		public function drawCircle(x:Number, y:Number, radius:Number):void {
			graphics.drawCircle(x, y, radius);
		}
		
		public function drawEllipse(x:Number, y:Number, width:Number, height:Number):void {
			graphics.drawEllipse(x, y, width, height);
		}
		
		public function drawGraphicsData(graphicsData:Vector.<IGraphicsData>):void {
			graphics.drawGraphicsData(graphicsData);
		}
		
		public function drawPath(commands:Vector.<int>, data:Vector.<Number>, winding:String = "evenOdd"):void {
			graphics.drawPath(commands, data, winding);
		}
		
		public function drawRect(x:Number, y:Number, width:Number, height:Number):void {
			graphics.drawRect(x, y, width, height);
		}
		
		public function drawRoundRect(x:Number, y:Number, width:Number, height:Number, ellipseWidth:Number, ellipseHeight:Number = NaN):void {
			graphics.drawRoundRect(x, y, width, height, ellipseWidth, ellipseHeight);
		}
		
		public function drawTriangles(vertices:Vector.<Number>, indices:Vector.<int> = null, uvtData:Vector.<Number> = null, culling:String = "none"):void {
			graphics.drawTriangles(vertices, indices, uvtData, culling);
		}
		
		public function endFill():void {
			graphics.endFill();
		}
		
		public function lineBitmapStyle(bitmap:BitmapData, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false):void {
			graphics.lineBitmapStyle(bitmap, matrix, repeat, smooth);
		}
		
		public function lineGradientStyle(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number = 0):void {
			graphics.lineGradientStyle(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
		}
		
		public function lineShaderStyle(shader:Shader, matrix:Matrix = null):void {
			graphics.lineShaderStyle(shader, matrix);
		}
		
		public function lineStyle(thickness:Number = NaN, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3):void {
			graphics.lineStyle(thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);
		}
		
		public function lineTo(x:Number, y:Number):void {
			graphics.lineTo(x, y);
		}
		
		public function moveTo(x:Number, y:Number):void {
			graphics.moveTo(x, y);
		}
	}
}
