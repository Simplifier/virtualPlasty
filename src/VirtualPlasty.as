package {
	import display.NShape;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import progressBar.CircleProgressIndicator;
	import progressBar.ProgressBar;
	import progressBar.WaitingBar;
	import slider.Slider;
	import slider.SliderConstructor;
	
	/**
	 * ...
	 * @author Alex
	 */
	public class VirtualPlasty extends Sprite {
		public static const debugMap:Boolean = true;
		
		private var canvas:Canvas = new Canvas(800, 600);
		
		private var resetBtn:Button = new Button('Сбросить');
		private var openPhotoBtn:Button = new Button('Выбрать фото...');
		private var saveBtn:Button = new Button('Сохранить');
		private var saveAsBtn:Button = new Button('Сохранить как...');
		
		private var uploadURL:String;
		
		private var interactiveManager:InteractiveManager;
		private var waitingUploadBar:WaitingBar = new WaitingBar;
		private static const initBrushDiameter:Number = 60;
		private var brushDiameterSlider:Slider = new Slider('Диаметр кисти', 150, 0, 500, initBrushDiameter, Slider.EXPONENTIAL);
		
		public function VirtualPlasty():void {
			//stage.color = 0x8080C0;
			if (loaderInfo.parameters.uploadURL)
				uploadURL = loaderInfo.parameters.uploadURL;
			else
				uploadURL = 'http://localhost/upl.php';
			
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			interactiveManager = new InteractiveManager(stage);
			
			canvas.brushRadius = initBrushDiameter / 2;
			
			resetBtn.x = 25;
			resetBtn.y = 10;
			canvas.x = resetBtn.x;
			canvas.y = resetBtn.y + resetBtn.height + 12;
			openPhotoBtn.x = canvas.x;
			openPhotoBtn.y = canvas.y + canvas.height + 15;
			saveAsBtn.x = canvas.x + canvas.width - saveAsBtn.width;
			saveAsBtn.y = openPhotoBtn.y;
			saveBtn.x = saveAsBtn.x - saveBtn.width - 10;
			saveBtn.y = openPhotoBtn.y;
			
			brushDiameterSlider.x = resetBtn.x + resetBtn.width + 30;
			brushDiameterSlider.y = resetBtn.y + resetBtn.height - brushDiameterSlider.height / 2 - 2;
			
			/*var sl:SliderConstructor = new SliderConstructor('slider', 150, 0, 500, initBrushDiameter, Slider.EXPONENTIAL);
			sl.x = brushDiameterSlider.x + brushDiameterSlider.overallWidth + 20;
			sl.y = brushDiameterSlider.y;
			addChild(sl);*/
			
			waitingUploadBar.x = stage.stageWidth / 2 - waitingUploadBar.width / 2;
			waitingUploadBar.y = stage.stageHeight / 2 - waitingUploadBar.height / 2;
			
			if (debugMap) {
				var map:Bitmap = canvas.filterMap;
				map.x = canvas.x + canvas.width + 15;
				map.y = canvas.y;
				stage.addChild(map);
			}
			
			stage.addChild(canvas);
			stage.addChild(resetBtn);
			stage.addChild(openPhotoBtn);
			stage.addChild(saveBtn);
			stage.addChild(saveAsBtn);
			addChild(brushDiameterSlider);
			
			/*var sh:NShape = new NShape;
			sh.ngraphics.beginFill(0x55ff88);
			sh.ngraphics.lineStyle(2);
			sh.ngraphics.drawSector(0, 0, 50, 300, 75);
			sh.ngraphics.beginFill(0x5588ff);
			sh.ngraphics.lineStyle(NaN);
			sh.ngraphics.drawSegment(150, 0, 50, 80, 290, 30);
			sh.x = 500;
			sh.y = 300;
			stage.addChild(sh);
			
			var pr:CircleProgressIndicator = new CircleProgressIndicator;
			pr.x = 300;
			pr.y = 300;
			stage.addChild(pr);*/
			
			openPhotoBtn.addEventListener(MouseEvent.CLICK, onOpenPhotoBtnClick);
			resetBtn.addEventListener(MouseEvent.CLICK, onResetBtnClick);
			saveBtn.addEventListener(MouseEvent.CLICK, onSaveBtnClick);
			saveAsBtn.addEventListener(MouseEvent.CLICK, onSaveAsBtnClick);
			brushDiameterSlider.addEventListener(Event.CHANGE, onBrushSliderChange);
		}
		
		private function onOpenPhotoBtnClick(e:MouseEvent):void {
			canvas.openPhoto();
		}
		
		private function onResetBtnClick(e:MouseEvent):void {
			canvas.reset();
		}
		
		private function onSaveBtnClick(e:MouseEvent):void {
			if (!canvas.imageIsLoaded)
				return;
			
			interactiveManager.disable();
			waitingUploadBar.start();
			stage.addChild(waitingUploadBar);
			//canvas.upload(uploadURL);
			
			canvas.addEventListener(Uploader.UPLOAD_COMPLETE, onUploadComplete);
			e.updateAfterEvent();
		}
		
		private function onUploadComplete(e:Event):void {
			interactiveManager.enable();
			waitingUploadBar.stop();
			stage.removeChild(waitingUploadBar);
		}
		
		private function onSaveAsBtnClick(e:MouseEvent):void {
			canvas.saveAs();
		}
		
		private function onBrushSliderChange(e:Event):void {
			canvas.brushRadius = brushDiameterSlider.value / 2;
		}
	}
}