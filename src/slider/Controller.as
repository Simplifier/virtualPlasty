package slider {
	public class Controller {
		private var model:Model;
		public function Controller(model:Model) {
			this.model = model;
		}
		
		public function changePosHandler(position:Number):void {
			model.position = position;
		}
	}
}