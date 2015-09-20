package utils 
{
	import aze.motion.eaze;
	import controls.AppControl;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.SoftKeyboardTrigger;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * Игровые уведомления
	 * @author ProBigi
	 */
	public class Notification 
	{
		
		private static var _inst:Notification;
		
		private var _notifications:Vector.<Sprite>;
		
		public function Notification() 
		{
			
		}
		
		public static function get inst():Notification {
			if (!_inst) { 
				_inst = new Notification();
			}
			return _inst;
		}
		
		public function show(message:String):void {
			if (!_notifications) {
				_notifications = new Vector.<Sprite>;
			}
			
			var ncont:Sprite = new Sprite;
			var notif:TextField = new TextField;
			var format:TextFormat = new TextFormat(null, 35, 0xFF0000, true);
			format.align = TextFormatAlign.LEFT;
			notif.defaultTextFormat = format;
			notif.autoSize = TextFieldAutoSize.LEFT;
			notif.selectable = false;
			notif.mouseEnabled = false;
			ncont.addChild(notif);
			
			notif.text = message;
			
			for each (var n:Sprite in _notifications) {
				eaze(n).to(0.3, { y: n.y - 35 } );
			}
			
			ncont.x = (AppControl.STAGE.stageWidth - ncont.width)/2;
			ncont.y = (AppControl.STAGE.stageHeight - ncont.height) / 2 - 150;
			notif.alpha = 0;
			_notifications.push(ncont);
			AppControl.STAGE.addChild(ncont);
			
			eaze(notif).to(0.3, { alpha:1 } ).delay(1).to(0.5, { alpha: 0 } ).onComplete(removeNotif, ncont);
		}
		
		private function removeNotif(notif:Sprite):void {
			var ind:int = _notifications.indexOf(notif);
			if (ind != -1) { _notifications.splice(ind, 1); }
			if (AppControl.STAGE.contains(notif)) { AppControl.STAGE.removeChild(notif); }
		}
	}

}