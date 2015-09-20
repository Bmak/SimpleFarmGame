package utils 
{
	import aze.motion.eaze;
	import controls.AppControl;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import objects.DataObject;
	/**
	 * Эффекты игровых элементов
	 * @author ProBigi
	 */
	public class ItemEffects 
	{
		
		private static var _inst:ItemEffects;
		
		private var _items:Vector.<Sprite>;
		
		private var _cont:Sprite;
		private var _itemView:Bitmap;
		private var _countTF:TextField;
		
		public function ItemEffects() 
		{
			
		}
		
		public static function get inst():ItemEffects {
			if (!_inst) {
				_inst = new ItemEffects();
			}
			return _inst;
		}
		
		public function showItem(obj:Sprite, view:String, count:int, isUp:Boolean = true):void {
			if (!_items) {
				_items = new Vector.<Sprite>;
			}
			
			var item:Sprite = new Sprite;
			var v:Bitmap = new Bitmap(AppControl.getObject(view) as BitmapData);
			item.addChild(v);
			var countTF:TextField = new TextField;
			var format:TextFormat = new TextFormat(null, 20);
			format.align = TextFormatAlign.CENTER;
			countTF.defaultTextFormat = format;
			countTF.autoSize = TextFieldAutoSize.CENTER;
			if (isUp) {
				countTF.text = "+" + count;
			} else {
				countTF.text = "-" + count;
			}
			countTF.x = v.width - 20;
			countTF.y = v.height - 20;
			item.addChild(countTF);
			
			_items.push(item);
			
			var p:Point = obj.localToGlobal(new Point(0, 0));
			item.x = p.x - item.width/2;
			item.y = p.y - item.height - 20;
			AppControl.STAGE.addChild(item);
			eaze(item).to(1, { y: item.y - 70, alpha: 0.7 } ).to(0.5, { alpha: 0.1 }).onComplete(removeItem, item);
		}
		
		private function removeItem(item:Sprite):void {
			var ind:int = _items.indexOf(item);
			if (ind != -1) { _items.splice(ind, 1); }
			if (AppControl.STAGE.contains(item)) { AppControl.STAGE.removeChild(item); }
			item = null;
		}
	}

}