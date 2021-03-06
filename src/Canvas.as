package {
	import cursors.SpotCursor;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.ui.Mouse;
	
	public class Canvas extends Sprite {
		[Embed(source='../mtr/pattern.png')]
		private var PatternClass:Class;
		
		private var file:FileReference = new FileReference;
		private var loader:Loader = new Loader();
		private var bmp:Bitmap;
		private var fileFilter:Array = [new FileFilter('Изображения (*.jpg, *.gif, *.png)', '*.jpg;*.gif;*.png')];
		private var uploader:Uploader;
		
		private var rangeAreaTool:RangeAreaTool = new RangeAreaTool;
		private var liquifyManager:LiquifyManager = new LiquifyManager;
		private var spotCursor:SpotCursor = new SpotCursor;
		private var mousePressed:Boolean;
		private var rangeAreaPressed:Boolean;
		private var prevPnt:Point = new Point;
		
		private var _filterMap:Bitmap = new Bitmap;
		private var _imageIsLoaded:Boolean;
		
		public function Canvas(width:int, height:int):void {
			graphics.lineStyle(0, 0xcccccc);
			graphics.beginBitmapFill((new PatternClass as Bitmap).bitmapData);
			graphics.drawRect(0, 0, width, height);
			filters = [new DropShadowFilter(4, 45, 0, .5, 5, 5, 1, BitmapFilterQuality.HIGH)];
			
			uploader = new Uploader(file);
			spotCursor.visible = false;
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onDecodePhotoComplete);
			
			loader.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_MOVE, onRangeAreaMouseMove);
			rangeAreaTool.addEventListener(MouseEvent.MOUSE_DOWN, onRangeAreaDown);
			loader.addEventListener(MouseEvent.ROLL_OVER, onImageOver);
			loader.addEventListener(MouseEvent.ROLL_OUT, onImageOut);
		}
		
		public function set brushRadius(value:Number):void {
			liquifyManager.radius = value / loader.scaleX;
			spotCursor.radius = value;
		}
		
		public function get filterMap():Bitmap {
			return _filterMap;
		}
		
		public function get imageIsLoaded():Boolean {
			return _imageIsLoaded;
		}
		
		public function reset():void {
			liquifyManager.reset();
		}
		
		public function saveAs():void {
			uploader.saveAs(liquifyManager.filteredImage);
		}
		
		public function upload(uploadURL:String):void {
			uploader.upload(liquifyManager.filteredImage, uploadURL);
			uploader.addEventListener(Uploader.UPLOAD_COMPLETE, onUploadComplete);
		}
		
		private function onUploadComplete(e:Event):void {
			dispatchEvent(new Event(Uploader.UPLOAD_COMPLETE));
		}
		
		public function openPhoto():void {
			file.browse(fileFilter);
			file.addEventListener(Event.SELECT, onFileSelected);
			file.addEventListener(Event.COMPLETE, onFileLoaded);
			file.addEventListener(Event.CANCEL, onFileCancel);
		}
		
		private function onFileCancel(e:Event):void {
			file.removeEventListener(Event.SELECT, onFileSelected);
			file.removeEventListener(Event.COMPLETE, onFileLoaded);
			file.removeEventListener(Event.CANCEL, onFileCancel);
		}
		
		//грузим изображение
		private function onFileSelected(e:Event):void {
			file.removeEventListener(Event.SELECT, onFileSelected);
			file.removeEventListener(Event.CANCEL, onFileCancel);
			file.load();
		}
		
		//загружаем полученные бинарные данные в отображаемый объект loader
		private function onFileLoaded(e:Event):void {
			file.removeEventListener(Event.COMPLETE, onFileLoaded);
			try {
				loader.close();
			} catch (e:Error) {
			}
			
			if (bmp) {
				bmp.bitmapData.dispose();
			}
			loader.loadBytes(e.target.data);
		}
		
		private function onDecodePhotoComplete(e:Event):void {
			if (contains(loader))
				removeChild(loader);
			if (contains(spotCursor))
				removeChild(spotCursor);
			
			bmp = Bitmap(loader.content);
			loader.scaleX = loader.scaleY = 1;
			if (loader.width > width || loader.height > height) {
				if (loader.width / width > loader.height / height) {
					loader.width = width;
					loader.scaleY = loader.scaleX;
				} else {
					loader.height = height;
					loader.scaleX = loader.scaleY;
				}
			}
			loader.x = width / 2 - loader.width / 2;
			loader.y = height / 2 - loader.height / 2;
			bmp.smoothing = true;
			
			liquifyManager.changeTarget(bmp);
			if (VirtualPlasty.debugMap)
				_filterMap.bitmapData = liquifyManager.filterMap;
			rangeAreaTool.clear();
			
			addChild(loader);
			addChild(rangeAreaTool);
			addChild(spotCursor);
			
			_imageIsLoaded = true;
		}
		
		private function onMouseDown(e:MouseEvent):void {
			rangeAreaTool.mouseEnabled = false;
			rangeAreaTool.clear();
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			loader.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			mousePressed = true;
		}
		
		private function onMouseUp(e:MouseEvent):void {
			rangeAreaTool.mouseEnabled = true;
			closeOffRangeArea();
			mousePressed = false;
		}
		
		private function closeOffRangeArea():void {
			if (!rangeAreaTool.cleared) {
				rangeAreaTool.closeOff();
			}
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			loader.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function onMouseMove(e:MouseEvent):void {
			rangeAreaTool.addPoint(mouseX, mouseY);
			rangeAreaTool.show();
			if (mousePressed && !e.buttonDown) {
				closeOffRangeArea();
				mousePressed = false;
			}
		}
		
		private function onImageOver(e:MouseEvent):void {
			if (rangeAreaPressed) {
				spotCursor.x = mouseX;
				spotCursor.y = mouseY;
				spotCursor.visible = true;
				Mouse.hide();
			}
		}
		
		private function onImageOut(e:MouseEvent):void {
			if (rangeAreaPressed && e.relatedObject != rangeAreaTool) {
				spotCursor.visible = false;
				Mouse.show();
			}
		}
		
		private function onRangeAreaDown(e:MouseEvent):void {
			prevPnt.x = loader.mouseX;
			prevPnt.y = loader.mouseY;
			//rangeAreaTool.hide();
			stage.addEventListener(MouseEvent.MOUSE_UP, onRangeAreaUp);
			rangeAreaPressed = true;
		}
		
		private function onRangeAreaUp(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, onRangeAreaUp);
			//rangeAreaTool.clear();
			spotCursor.visible = false;
			Mouse.show();
			rangeAreaPressed = false;
		}
		
		private function onRangeAreaMouseMove(e:MouseEvent):void {
			if (rangeAreaPressed) {
				
				if (!e.buttonDown) {
					stage.removeEventListener(MouseEvent.MOUSE_UP, onRangeAreaUp);
					rangeAreaPressed = false;
					return;
				}
				
				if (e.target == rangeAreaTool) {
					if (!isNaN(prevPnt.x))
						liquifyManager.doReshape(loader.mouseX, loader.mouseY, loader.mouseX - prevPnt.x, loader.mouseY - prevPnt.y);
					prevPnt.x = loader.mouseX;
					prevPnt.y = loader.mouseY;
					e.updateAfterEvent();
				} else {
					prevPnt.x = NaN;
					prevPnt.y = NaN;
				}
				
			} else {
				if (e.target == rangeAreaTool) {
					spotCursor.visible = true;
					Mouse.hide();
				} else {
					spotCursor.visible = false;
					Mouse.show();
				}
			}
			
			if (spotCursor.visible) {
				spotCursor.x = mouseX;
				spotCursor.y = mouseY;
			}
		}
	}
}