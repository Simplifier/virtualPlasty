package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class InteractiveManager {
		private var container:DisplayObjectContainer;
		private var reprint:BitmapData;
		private var reprintBmp:Bitmap;
		private var deactivators:Vector.<Sprite> = new Vector.<Sprite>;
		private var blur:BlurFilter = new BlurFilter(20, 20, BitmapFilterQuality.HIGH);
		
		private var width:int;
		private var height:int;
		private var rect:Rectangle;
		private var destPoint:Point = new Point();
		
		public function InteractiveManager(container:DisplayObjectContainer) {
			this.container = container;
			if (container is Stage) {
				width = Stage(container).stageWidth;
				height = Stage(container).stageHeight;
			}else {
				width = container.width;
				height = container.height;
			}
			rect = new Rectangle(0, 0, width, height);
		}
		
		public function disable():void {
			var deactivator:Sprite = new Sprite;
			reprint = new BitmapData(width, height, false);
			reprint.draw(container, container.transform.matrix);
			reprint.applyFilter(reprint, rect, destPoint, blur);
			reprintBmp = new Bitmap(reprint);
			deactivator.addChild(reprintBmp);
			
			container.addChild(deactivator);
			deactivators.push(deactivator);
		}
		
		public function enable():void {
			var deactivator:Sprite = deactivators.pop();
			Bitmap(deactivator.getChildAt(0)).bitmapData.dispose();
			container.removeChild(deactivator);
		}
		
		public function enableAll():void {
			var deactivator:Sprite;
			while (deactivators.length) {
				deactivator = deactivators.pop();
				Bitmap(deactivator.getChildAt(0)).bitmapData.dispose();
				container.removeChild(deactivator);
			}
		}
	}
}