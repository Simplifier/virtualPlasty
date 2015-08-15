package {
	import flash.display.*;
	import flash.filters.*;
	import flash.geom.*;
	
	public class LiquifyManager {
		private var target:Bitmap;
		private var targetClone:BitmapData;
		private var _filter:DisplacementMapFilter;
		private var _mapBD:BitmapData;
		private var auxMapBDClone:BitmapData;
		private var mapPoint:Point = new Point;
		
		private var _radius:Number;
		private var gradientShape:Shape = new Shape();
		private var blur:BlurFilter = new BlurFilter(16, 16, BitmapFilterQuality.HIGH);
		
		private var isChanged:Boolean;
		
		private const neutralColor:uint = 0x808080;
		private const ORIGIN:Point = new Point();
		
		public function LiquifyManager():void {
			_filter = new DisplacementMapFilter(null, ORIGIN, BitmapDataChannel.RED, BitmapDataChannel.BLUE, 100, 100);
			_filter.mode = DisplacementMapFilterMode.CLAMP;
		}
		
		private function updateGradient():void {
			gradientShape.graphics.clear();
			var gradientMatrix:Matrix = new Matrix;
			gradientMatrix.createGradientBox(2 * _radius, 2 * _radius);
			gradientShape.graphics.beginGradientFill(GradientType.RADIAL, [neutralColor, neutralColor], [.8, 0], [0, 255], gradientMatrix);
			gradientShape.graphics.drawRect(0, 0, 2 * _radius, 2 * _radius);
			gradientShape.graphics.endFill();
		}
		
		public function doReshape(x:int, y:int, dX:int, dY:int):void {
			mapPoint.x = x - _radius;
			mapPoint.y = y - _radius;
			
			gradientShape.x = mapPoint.x;
			gradientShape.y = mapPoint.y;
			
			var red:int = 128 + Math.min(128, Math.max(-128, -dX * 2));
			var blue:int = 128 + Math.min(128, Math.max( -128, -dY * 2));
			/*trace('rb',red, blue);
			trace('d',-dX, -dY);
			trace('val',Math.min(128, Math.max(-128, -dX * 2)), Math.min(128, Math.max( -128, -dY * 2)));*/
			trace('d',-dX);
			trace('val',Math.min(128, Math.max(-128, -dX * 2)));
			trace('rb',red);
			var clrTransform:ColorTransform = new ColorTransform(0, 0, 0, 1, red, 128, blue, 0);
			
			auxMapBDClone.draw(gradientShape, gradientShape.transform.matrix, clrTransform, BlendMode.HARDLIGHT);
			_mapBD.applyFilter(auxMapBDClone, target.bitmapData.rect, ORIGIN, blur);
			
			target.bitmapData.applyFilter(targetClone, target.bitmapData.rect, ORIGIN, _filter);
			
			isChanged = true;
		}
		
		public function reset():void {
			if (!isChanged)
				return;
			auxMapBDClone.fillRect(auxMapBDClone.rect, neutralColor);
			_mapBD.fillRect(auxMapBDClone.rect, neutralColor);
			target.bitmapData.draw(targetClone);
			
			isChanged = false;
		}
		
		public function changeTarget(target:Bitmap):void {
			this.target = target;
			if (targetClone)
				targetClone.dispose();
			targetClone = target.bitmapData.clone();
			
			_mapBD = new BitmapData(target.bitmapData.width, target.bitmapData.height, false, neutralColor);
			auxMapBDClone = _mapBD.clone();
			_filter.mapBitmap = _mapBD;
			
			isChanged = false;
		}
		
		public function get radius():Number {
			return _radius;
		}
		
		public function set radius(value:Number):void {
			_radius = value;
			updateGradient();
		}
		
		public function get filterMap():BitmapData {
			return _mapBD;
		}
		
		public function get filteredImage():BitmapData {
			return target ? target.bitmapData.clone() : null;
		}
	}
}