package objects 
{
	import controls.AppControl;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import utils.StateWindow;
	/**
	 * Базовый класс игрового объекта
	 * @author ProBigi
	 */
	public class MapObject extends Sprite
	{
		protected var _data:Object;
		protected var _point:int;
		protected var _view:Sprite;
		protected var _name:String;
		
		protected var _cursor:Bitmap;
		protected var _state:int;
		
		public function MapObject() 
		{
			
		}
		
		public function get point():int {
			return _point;
		}
		
		public function create(data:Object):void {
			_data = data;
			_point = _data.point;
			_name = _data.name;
			
			createView();
		}
		
		protected function createView():void {
			_view = new Sprite;
			var v:Bitmap = new Bitmap(AppControl.getObject(_data.view) as BitmapData);
			v.scaleX = v.scaleY = 2;
			_view.addChild(v);
			_view.x = -_view.width / 2;
			_view.y = -_view.height / 2;
			this.addChild(_view);
			
			_view.addEventListener(MouseEvent.MOUSE_OVER, showInfo);
			_view.addEventListener(MouseEvent.MOUSE_OUT, closeInfo);
			_view.addEventListener(MouseEvent.MOUSE_DOWN, onAction);
		}
		
		protected function initStates():void {
			//for override
		}
		
		protected function createCursor():void {
			//for override
		}
		
		private function showInfo(e:MouseEvent):void 
		{
			createCursor();
			Mouse.hide();
			AppControl.STAGE.addChild(_cursor);
			
			checkState();
			
			_view.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function closeInfo(e:MouseEvent):void 
		{
			_view.removeEventListener(Event.ENTER_FRAME, update);
			
			Mouse.show();
			AppControl.STAGE.removeChild(_cursor);
			_cursor.bitmapData.dispose();
			_cursor = null;
			
			StateWindow.inst.hide();
		}
		
		private function update(e:Event):void 
		{
			if (_cursor) {
				_cursor.x = AppControl.STAGE.mouseX;
				_cursor.y = AppControl.STAGE.mouseY;
			}
		}
		
		protected function setState(state:int):void {
			//for override
		}
		
		protected function checkState():void {
			//for override
		}
		
		protected function onAction(e:MouseEvent):void 
		{
			e.stopPropagation();
			
			checkForAction();
		}
		
		public function checkForAction():void {
			//for override
		}
		
		protected function action():void {
			//for override
		}
	}

}