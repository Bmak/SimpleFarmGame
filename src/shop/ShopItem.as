package shop 
{
	import aze.motion.eaze;
	import controls.AppControl;
	import controls.PDControl;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import objects.DataObject;
	/**
	 * Элемент магазина для продажи
	 * @author ProBigi
	 */
	public class ShopItem extends Sprite
	{
		private var _data:DataObject;
		
		private var _border:Sprite;
		private var _image:Bitmap;
		private var _countTF:TextField;
		private var _priceCont:Sprite;
		private var _priceTF:TextField;
		private var _priceMoney:Bitmap;
		private var _sellBtn:Sprite;
		
		public function ShopItem(data:DataObject) 
		{
			_data = data;
			
			createView();
		}
		
		private function createView():void {
			_border = new Sprite;
			_border.graphics.lineStyle(2, 0xFF8000);
			_border.graphics.beginFill(0xFBDEAA);
			_border.graphics.drawRoundRect(0, 0, 150, 200, 10, 10);
			_border.graphics.endFill();
			
			_image = new Bitmap(AppControl.getObject(_data.type) as BitmapData);
			_image.x = (_border.width - _image.width) / 2;
			_image.y = 20;
			
			_countTF = new TextField;
			var cformat:TextFormat = new TextFormat(null, 20);
			cformat.align = TextFormatAlign.CENTER;
			_countTF.defaultTextFormat = cformat;
			_countTF.autoSize = TextFieldAutoSize.CENTER;
			_countTF.selectable = false;
			_countTF.text = String(_data.value);
			_countTF.x = _image.x + _image.width / 1.5 + 10;
			_countTF.y = _image.y + _image.height / 1.5 + 10;
			
			this.addChild(_border);
			this.addChild(_image);
			this.addChild(_countTF);
			
			createSellBtn();
		}
		
		private function createSellBtn():void {
			_sellBtn = new Sprite;
			_sellBtn.graphics.lineStyle(2, 0x008000);
			_sellBtn.graphics.beginFill(0xFFFFFF);
			_sellBtn.graphics.drawRoundRect(0, 0, 120, 50, 10, 10);
			_sellBtn.graphics.endFill();
			_sellBtn.buttonMode = true;
			_sellBtn.mouseChildren = false;
			_sellBtn.x = (_border.width - _sellBtn.width) / 2;
			_sellBtn.y = _border.height - _sellBtn.height - 10;
			
			this.addChild(_sellBtn);
			
			_priceCont = new Sprite;
			_priceTF = new TextField;
			var format:TextFormat = new TextFormat(null, 25);
			format.align = TextFormatAlign.LEFT;
			_priceTF.defaultTextFormat = format;
			_priceTF.autoSize = TextFieldAutoSize.LEFT;
			_priceTF.selectable = false;
			_priceTF.text = String(_data.cost * _data.value);
			
			_priceMoney = new Bitmap(AppControl.getObject("diamond") as BitmapData);
			_priceMoney.x = _priceTF.textWidth;
			_priceMoney.y = (_priceTF.textHeight - _priceMoney.height) / 2;
			_priceCont.addChild(_priceTF);
			_priceCont.addChild(_priceMoney);
			
			_priceCont.x = (_sellBtn.width - _priceCont.width) / 2;
			_priceCont.y = (_sellBtn.height - _priceCont.height) / 2;
			_sellBtn.addChild(_priceCont);
			
			_sellBtn.addEventListener(MouseEvent.CLICK, onSellItem);
		}
		
		private function onSellItem(e:MouseEvent):void 
		{
			PDControl.inst.getObject("money", "diamonds").value += _data.cost * _data.value;
			PDControl.inst.updateView();
			_data.value = 0;
			_countTF.text = String(_data.value);
			_priceTF.text = String(_data.cost * _data.value);
			_priceMoney.x = _priceTF.textWidth;
			_priceMoney.y = (_priceTF.textHeight - _priceMoney.height) / 2;
			_priceCont.x = (_sellBtn.width - _priceCont.width) / 2;
			_priceCont.y = (_sellBtn.height - _priceCont.height) / 2;
			
			eaze(_sellBtn).to(0.1, { alpha: 0.3 } ).to(0.1, { alpha:1 } );
		}
		
		public function clear():void {
			var len:int = this.numChildren;
			while (len--) { this.removeChildAt(0); }
			
			_sellBtn.removeEventListener(MouseEvent.CLICK, onSellItem);
		}
	}

}