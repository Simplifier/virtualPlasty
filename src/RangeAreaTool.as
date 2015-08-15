package {
	import display.ExtendedSprite;
	import flash.display.GraphicsPathCommand;
	import flash.display.GraphicsPathWinding;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class RangeAreaTool extends ExtendedSprite {
		private var closed:Boolean;
		private var _cleared:Boolean = true;
		private var _sqrOfDiameter:Number = 0;
		private var _radius:Number = 0;
		
		private var commands:Vector.<int> = new Vector.<int>;
		private var points:Vector.<Number> = new Vector.<Number>;
		
		private var animationTimer:Timer = new Timer(70);
		
		public function RangeAreaTool():void {
			graphics.lineStyle(0, 0, 1, true);
			extendedGraphics.lineStripedStyle();
			animationTimer.addEventListener(TimerEvent.TIMER, onAnimationTimer);
		}
		
		private function onAnimationTimer(e:TimerEvent):void {
			graphics.clear();
			graphics.beginFill(0x55ccaa, 0);
			graphics.lineStyle(0, 0, 1, true);
			extendedGraphics.lineStripedStyle();
			graphics.drawPath(commands, points, GraphicsPathWinding.NON_ZERO);
			graphics.endFill();
			e.updateAfterEvent();
		}
		
		public function addPoint(x:Number, y:Number):void {
			if (closed)
				return;
			
			if (!points.length) {
				graphics.moveTo(x, y);
				commands.push(GraphicsPathCommand.MOVE_TO);
			} else {
				graphics.lineTo(x, y);
				commands.push(GraphicsPathCommand.LINE_TO);
			}
			points.push(x, y);
			calcMaxDistance();
			_cleared = false;
		}
		
		private function calcMaxDistance():void {
			var lastX:Number = points[points.length - 2];
			var lastY:Number = points[points.length - 1];
			var _sqrOfDistance:Number;
			for (var i:int = 0; i < points.length / 2 - 1; i++) {
				_sqrOfDistance = sqrOfDistance(points[2 * i], points[2 * i + 1], lastX, lastY);
				if (_sqrOfDistance > _sqrOfDiameter)
					_sqrOfDiameter = _sqrOfDistance;
			}
		}
		
		private function sqrOfDistance(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			return (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2);
		}
		
		public function closeOff():void {
			closed = true;
			_radius = Math.sqrt(_sqrOfDiameter) / 2;
			
			points.push(points[0], points[1]);
			commands.push(GraphicsPathCommand.LINE_TO);
			graphics.lineTo(points[0], points[1]);
			
			animationTimer.start();
		}
		
		public function hide():void {
			alpha = 0;
			if (animationTimer.running)
				animationTimer.stop();
		}
		
		public function show():void {
			alpha = 1;
		}
		
		public function clear():void {
			if (_cleared) return;
			
			if (animationTimer.running)
				animationTimer.stop();
			commands = new Vector.<int>;
			points = new Vector.<Number>;
			_sqrOfDiameter = 0;
			_radius = 0;
			
			graphics.clear();
			graphics.lineStyle(0, 0, 1, true);
			extendedGraphics.lineStripedStyle();
			
			_cleared = true;
			closed = false;
		}
		
		public function get cleared():Boolean {
			return _cleared;
		}
		
		public function get radius():Number {
			return _radius;
		}
	}
}