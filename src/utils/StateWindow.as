package utils 
{
	import controls.AppControl;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	/**
	 * Всплывающее окно состояния объектов
	 * @author ProBigi
	 */
	public class StateWindow extends Sprite
	{
		private static var _inst:StateWindow;
		
		private var _windowView:Bitmap;
		private var _titleTF:TextField;
		private var _timerTF:TextField;
		private var _timer:Timer;
		private var _time:Array;
		private var _feedTF:TextField;
		
		public function StateWindow() 
		{
			
		}
		
		public static function get inst():StateWindow {
			if (!_inst) {
				_inst = new StateWindow();
			}
			return _inst;
		}
		
		public function init():void 
		{
			_windowView = new Bitmap(AppControl.getObject("WindowView") as BitmapData);
			
			_titleTF = new TextField();
			var format:TextFormat = new TextFormat(null, 25);
			format.align = TextFormatAlign.CENTER;
			_titleTF.defaultTextFormat = format;
			_titleTF.autoSize = TextFieldAutoSize.CENTER;
			
			_timerTF = new TextField();
			var tformat:TextFormat = new TextFormat(null, 17);
			tformat.align = TextFormatAlign.CENTER;
			_timerTF.defaultTextFormat = tformat;
			_timerTF.autoSize = TextFieldAutoSize.CENTER;
			
			_feedTF = new TextField();
			var feedformat:TextFormat = new TextFormat(null, 20, 0xFF0000);
			feedformat.align = TextFormatAlign.CENTER;
			_feedTF.defaultTextFormat = feedformat;
			_feedTF.autoSize = TextFieldAutoSize.CENTER;
			_feedTF.text = "ПОКОРМИТЬ";
			
			this.addChild(_windowView);
			this.addChild(_titleTF);
			this.addChild(_timerTF);
			this.addChild(_feedTF);
		}
		
		public function show(obj:DisplayObject, name:String, timer:Timer, isLocked:Boolean = false):void {
			_titleTF.text = name;
			_titleTF.x = (_windowView.width - _titleTF.textWidth) / 2;
			_titleTF.y = 25;
			
			_timer = timer;
			_timerTF.x = (_windowView.width - _timerTF.textWidth) / 2;
			_timerTF.y = 60;
			onTimerUpdate(null);
			_timer.addEventListener(TimerEvent.TIMER, onTimerUpdate);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			
			var p:Point = obj.localToGlobal(new Point(0, 0));
			this.x = p.x - this.width/2;
			this.y = p.y - this.height - obj.height / 2;
			
			_feedTF.x = (_windowView.width - _feedTF.textWidth) / 2;
			_feedTF.y = _timerTF.y + 20;
			_feedTF.visible = isLocked;
			
			AppControl.STAGE.addChild(this);
		}
		
		private function onTimerComplete(e:TimerEvent):void 
		{
			if (_timer) {
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			}
			hide();
		}
		
		private function onTimerUpdate(e:TimerEvent):void 
		{
			_time = StaticHelp.timeConverter(_timer.repeatCount - _timer.currentCount);
			
			for (var i:int = 0; i < _time.length; i++) {
				_time[i] = (_time[i] >= 10) ? _time[i] : String("0" + _time[i]);
			}
			_timerTF.text = _time[0] + ":" + _time[1] + ":" + _time[2];
		}
		
		public function hide():void {
			if (this.parent) { this.parent.removeChild(this); }
			
			if (_timer) {
				_timer.removeEventListener(TimerEvent.TIMER, onTimerUpdate);
				_timer = null;
			}
		}
		
	}

}