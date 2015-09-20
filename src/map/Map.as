package map 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import objects.MapObject;
	/**
	 * Изометрическая карта
	 * @author ProBigi
	 */
	public class Map extends Sprite
	{
		private var _points:Vector.<Cell>;
		private var _width:int;
		private var _height:int;
		
		public function Map() 
		{
			_points = new Vector.<Cell>;
		}
		
		public function create(width:int, height:int):void {
			if (width == 0 || height == 0) { return; }
			_width = width;
			_height = height;
			var i:int = 0;
			var len:int = width * height;
			while (i < len)
			{
				var point:Cell = new Cell();
				point.create();
				var iX:int = i % width;
				var iY:int = i / width;
				
				point.x = Math.floor(iY * (Cell.WIDTH / 2)) + Math.floor(iX * (Cell.WIDTH / 2));
				point.y = Math.floor(iY * (Cell.HEIGHT / 2)) - Math.floor(iX * (Cell.HEIGHT / 2));
				
				point.id = i;
				
				_points.push(point);
				
				this.addChild(point);
				point.addEventListener(MouseEvent.MOUSE_OVER, overPoint);
				point.addEventListener(MouseEvent.MOUSE_OUT, outPoint);
				i++;
			}
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMove);
			this.addEventListener(MouseEvent.MOUSE_UP, onStopMove);
		}
		
		private function onMove(e:MouseEvent):void 
		{
			this.startDrag();
		}
		
		private function onStopMove(e:MouseEvent):void 
		{
			this.stopDrag();
		}
		
		public function setOnMapObject(obj:MapObject):void {
			var currentP:Cell;
			for each (var p:Cell in _points) {
				if (p.id == obj.point) {
					currentP = p;
					break;
				}
			}
			if (!currentP) { throw new Error("Object point is out of range MAP!"); }
			obj.x = currentP.x;
			obj.y = currentP.y;
			this.addChild(obj);
		}
		
		public function clear():void
		{
			for each (var point:Cell in _points)
			{
				point.clearData();
				point.removeEventListener(MouseEvent.MOUSE_OVER, overPoint);
				point.removeEventListener(MouseEvent.MOUSE_OUT, outPoint);
			}
			_points.length = 0;
			
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMove);
			this.removeEventListener(MouseEvent.MOUSE_UP, onStopMove);
		}
		
		private function overPoint(e:MouseEvent):void
		{
			var point:Cell = e.currentTarget as Cell;
			point.alpha = .5;
		}
		
		private function outPoint(e:MouseEvent):void
		{
			var point:Cell = e.currentTarget as Cell;
			point.alpha = 1;
		}
	}

}