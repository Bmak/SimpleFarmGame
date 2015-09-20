package controls 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import objects.DataObject;
	import shop.ShopWindow;
	/**
	 * Player Data Conrol - Данные игрока и внешний интерфейс
	 * @author ProBigi
	 */
	public class PDControl 
	{
		private static var _inst:PDControl;
		
		private var _playerData:Vector.<DataObject>;
		private var _mainCont:Sprite;
		private var _panel:Sprite;
		private var _res:Sprite;
		private var _resTF:TextField;
		private var _diamonds:Sprite;
		private var _diamondsTF:TextField;
		private var _shopBtn:Sprite;
		
		public function PDControl() 
		{
			
		}
		
		public static function get inst():PDControl {
			if (!_inst) { _inst = new PDControl(); }
			return _inst;
		}
		
		public function get data():Vector.<DataObject> { return _playerData; }
		
		public function getObject(sort:String, type:String):DataObject {
			for each (var obj:DataObject in _playerData) {
				if (obj.sort == sort && obj.type == type) {
					return obj;
				}
			}
			throw Error("Can't find current object!!!");
		}
		
		public function updateView():void {
			_resTF.text = String(getObject("ingredients", "wheat").value);
			_diamondsTF.text = String(getObject("money", "diamonds").value);
		}
		
		public function init(data:Object, mainCont:Sprite):void {
			_playerData = new Vector.<DataObject>;
			
			var dataObj:DataObject;
			for each (var obj:Object in data) {
				dataObj = new DataObject;
				dataObj.sort = obj.sort;
				dataObj.type = obj.type;
				dataObj.value = obj.value;
				if (obj.hasOwnProperty("cost")) { dataObj.cost = obj.cost; }
				_playerData.push(dataObj);
			}
			
			_mainCont = mainCont;
			createView();
		}
		
		private function createView():void {
			_panel = new Sprite;
			
			_diamonds = new Sprite;
			var dv:Bitmap = new Bitmap(AppControl.getObject("diamond") as BitmapData);
			dv.scaleX = dv.scaleY = 2;
			_diamonds.addChild(dv);
			_diamondsTF = new TextField;
			_diamondsTF.selectable = false;
			var format:TextFormat = new TextFormat(null, 20);
			format.align = TextFormatAlign.CENTER;
			_diamondsTF.defaultTextFormat = format;
			_diamondsTF.autoSize = TextFieldAutoSize.CENTER;
			_diamondsTF.text = String(getObject("money", "diamonds").value);
			_diamondsTF.x = dv.width/1.5;
			_diamondsTF.y = dv.height/1.5;
			_diamonds.addChild(_diamondsTF);
			
			_res = new Sprite;
			var v:Bitmap = new Bitmap(AppControl.getObject("wheat") as BitmapData);
			_res.addChild(v);
			_resTF = new TextField;
			_resTF.selectable = false;
			_resTF.defaultTextFormat = format;
			_resTF.autoSize = TextFieldAutoSize.CENTER;
			_resTF.text = String(getObject("ingredients", "wheat").value);
			_resTF.x = v.width/1.5;
			_resTF.y = v.height/1.5;
			_res.addChild(_resTF);
			_res.x = _diamonds.width + 20;
			
			_shopBtn = new Sprite;
			_shopBtn.addChild(new Bitmap(AppControl.getObject("ShopIcon") as BitmapData));
			_shopBtn.x = _res.x + _res.width + 20;
			_shopBtn.buttonMode = true;
			_shopBtn.addEventListener(MouseEvent.CLICK, openStore);
			
			_panel.addChild(_diamonds);
			_panel.addChild(_res);
			_panel.addChild(_shopBtn);
			
			_panel.x = AppControl.STAGE.stageWidth - _panel.width - 20;
			_panel.y = 10;
			
			_mainCont.addChild(_panel);
		}
		
		
		private function openStore(e:MouseEvent):void 
		{
			ShopWindow.inst.show();
		}
		
	}

}