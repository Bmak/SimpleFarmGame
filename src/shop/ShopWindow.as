package shop 
{
	import controls.AppControl;
	import controls.PDControl;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import objects.DataObject;
	/**
	 * Окно магазина
	 * @author ProBigi
	 */
	public class ShopWindow extends Sprite
	{
		
		private static var _inst:ShopWindow;
		
		private var _shadow:Sprite;
		private var _box:Sprite;
		private var _title:TextField;
		private var _items:Vector.<ShopItem>;
		private var _closeBtn:Sprite;
		
		public function ShopWindow() 
		{
			
		}
		
		public static function get inst():ShopWindow {
			if (!_inst) {
				_inst = new ShopWindow();
			}
			return _inst;
		}
		
		public function show():void {
			_shadow = new Sprite;
			_shadow.graphics.beginFill(0x000000,0.5);
			_shadow.graphics.drawRect(0, 0, AppControl.STAGE.stageWidth, AppControl.STAGE.stageHeight);
			_shadow.graphics.endFill();
			
			_box = new Sprite();
			_box.graphics.lineStyle(2, 0xFF0000);
			_box.graphics.beginFill(0xC0C0C0);
			_box.graphics.drawRoundRect(0, 0, 500, 300, 10, 10);
			_box.graphics.endFill();
			
			_title = new TextField;
			var format:TextFormat = new TextFormat(null, 30);
			format.align = TextFormatAlign.CENTER;
			_title.defaultTextFormat = format;
			_title.autoSize = TextFieldAutoSize.CENTER;
			_title.selectable = false;
			_title.text = "ТОВАРЫ НА ПРОДАЖУ";
			_title.x = (_box.width - _title.textWidth) / 2;
			_title.y = 10;
			
			_closeBtn = new Sprite;
			_closeBtn.buttonMode = true;
			_closeBtn.graphics.lineStyle(2, 0x008000);
			_closeBtn.graphics.beginFill(0xFFFFFF);
			_closeBtn.graphics.drawCircle(0, 0, 20);
			_closeBtn.graphics.endFill();
			
			_closeBtn.x = _box.width;
			_closeBtn.y = 0;
			
			this.addChild(_shadow);
			this.addChild(_box);
			this.addChild(_title);
			this.addChild(_closeBtn);
			
			_closeBtn.addEventListener(MouseEvent.CLICK, hide);
			createItems();
			
			this.x = (AppControl.STAGE.stageWidth - _box.width) / 2;
			this.y = (AppControl.STAGE.stageHeight - _box.height) / 2;
			AppControl.STAGE.addChild(_shadow);
			AppControl.STAGE.addChild(this);
		}
		
		//простейшее отображение элементов, в случае увеличения количества текущая реализация не подходит.
		//Как вариант можно сделать скроллящийся список.
		private function createItems():void 
		{
			_items = new Vector.<ShopItem>;
			
			var item:ShopItem;
			var i:int = 0;
			for each (var obj:DataObject in PDControl.inst.data) {
				if (obj.sort == "resources") {
					item = new ShopItem(obj);
					item.x = 100 + i * (item.width + 20);
					item.y = (_box.height - item.height) / 2 + 20;
					_box.addChild(item);
					i++;
				}
			}
		}
		
		public function hide(e:Event = null):void {
			var len:int = this.numChildren;
			while (len--) { this.removeChildAt(0); }
			
			for each (var item:ShopItem in _items) {
				item.clear();
				item = null;
			}
			_items.length = 0;
			
			_closeBtn.removeEventListener(MouseEvent.CLICK, hide);
			AppControl.STAGE.removeChild(_shadow);
			_shadow = null;
			AppControl.STAGE.removeChild(this);
		}
	}

}