package slider {
	import flash.display.Sprite;
	public class SliderConstructor extends Sprite {
		public static const LINEAR:String = 'linear';
		public static const EXPONENTIAL:String = 'exponential';
		public function SliderConstructor(label:String, width:int = 200, min:Number = 0, max:Number = 1, initialValue:Number = 0, scaleMode:String = LINEAR) {
			var model:Model = new Model(min, max, scaleMode);
			var controller:Controller = new Controller(model);
			var view:View = new View(controller, model, label, width);
			model.relatingValue = initialValue;
			addChild(view);
		}
	}
}