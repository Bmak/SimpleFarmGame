package map {
	//import engine.map.TexturesConst;
	import controls.AppControl;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * Простейшая стандартная ячейка
	 * 
	 * @author ProBigi
	 */
	public class Cell extends Sprite
	{
		/**
		 * Ширина ячейки в пикселях
		 */
		public static const WIDTH:int = 166;		//100
		/**
		 * Высота ячейки в пикселях
		 */
		public static const HEIGHT:int = 96;    //62
		//
		private var _texture:BitmapData = null;
		//
		private var _cont:Sprite = null;
		//
		private var _id:int = 0;
		
		private var _tf:TextField;
		
		public function Cell()
		{
			
		}
		
		public function get id():int { return _id; }
		public function set id(value:int):void { _id = value; _tf.text = String(value); }
		
		/**
		 * Метод для удаления ячейки
		 */
		public function clearData():void
		{
			this.cacheAsBitmap = false;
			this.graphics.clear();
			if (_texture)
			{
				_texture.dispose();
				_texture = null;
			}
			while (0 < this.numChildren) { this.removeChildAt(0); }
			if (_cont)
			{
				_cont.cacheAsBitmap = false;
				_cont.graphics.clear();
				while (0 < _cont.numChildren) { _cont.removeChildAt(0); }
				_cont = null;
			}
		}
		/**
		 * Инициируем ячейку
		 */
		public function create():void
		{
			_texture = AppControl.getObject("GrassTexture") as BitmapData;
			if (!_texture) { throw new Error("Не удалось создать текстуру!!!"); }
			_cont = new Sprite();
			
			_cont.graphics.clear();
			_cont.graphics.lineStyle(.3, 0xFF0000,0);
			_cont.graphics.beginBitmapFill(_texture);
			_cont.graphics.moveTo(int(WIDTH / 2), 0);
			_cont.graphics.lineTo(WIDTH, HEIGHT / 2);
			_cont.graphics.lineTo(int(WIDTH / 2), HEIGHT);
			_cont.graphics.lineTo(0, HEIGHT / 2);
			_cont.graphics.lineTo(int(WIDTH / 2), 0);
			_cont.graphics.endFill();
			
			_tf = new TextField();
			_tf.x = int(WIDTH / 2);
			_tf.y = 10;
			//_cont.addChild(_tf);
			
			_cont.cacheAsBitmap = true;
			
			_cont.x = -Math.floor(WIDTH / 2);
			_cont.y = -Math.floor(HEIGHT / 2);
			
			this.addChild(_cont);
			this.cacheAsBitmap = true;
		}
	}
}