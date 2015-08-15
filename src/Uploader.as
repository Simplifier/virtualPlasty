package {
	import by.blooddy.crypto.image.JPEGEncoder;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	//import jpgEncoder.JPGEncoder;
	import mpLoader.MultipartURLLoader;
	public class Uploader extends EventDispatcher{
		private var file:FileReference;
		//private var jpegEncoder:JPGEncoder = new JPGEncoder(80);
		private var uploader:MultipartURLLoader = new MultipartURLLoader;
		private var data:ByteArray;
		private var uploadCompleteEvt:Event = new Event(UPLOAD_COMPLETE);
		
		public static const UPLOAD_COMPLETE:String = 'uploadComplete';
		
		public function Uploader(fileReference:FileReference = null):void {
			if (fileReference) file = fileReference;
			else file = new FileReference;
		}
		
		public function upload(img:BitmapData, url:String):void {
			if (!img) return;
			
			//data = jpegEncoder.encode(img);
			data = JPEGEncoder.encode(img, 80);
			uploader.addFile(data, 'image_' + int(Math.random() * int.MAX_VALUE) + '.jpg', 'image');
			uploader.addEventListener(Event.COMPLETE, onUploadComplete);
			uploader.load(url);
			img.dispose();
		}
		
		private function onUploadComplete(e:Event):void {
			trace('complete');
			trace(e.target.loader.data);
			dispatchEvent(uploadCompleteEvt);
		}
		
		public function saveAs(img:BitmapData):void {
			if (!img) return;
			
			//data = jpegEncoder.encode(img);
			data = JPEGEncoder.encode(img, 80);
			file.save(data, 'Modified Photo.jpg');
			img.dispose();
		}
		
		private function saveAndUpload(img:BitmapData, url:String):void {
			/*urlReq.url = url;
			
			if (!img) return;
			data = jpegEncoder.encode(img);
			file.save(data, 'Modified Photo.jpg');
			img.dispose();
			file.addEventListener(Event.COMPLETE, onFileSave);*/
		}
		
		private function onFileSave(e:Event):void {
			//trace(file.data.length);
			//file.upload(urlReq, 'fd');
		}
	}
}