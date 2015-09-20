package objects.types 
{
	import aze.motion.eaze;
	import controls.AppControl;
	import controls.PDControl;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import objects.MapObject;
	import utils.ItemEffects;
	import utils.Notification;
	import utils.StateWindow;
	/**
	 * Класс Животного
	 * @author ProBigi
	 */
	public class Animal extends MapObject
	{
		
		private var _resType:String;
		private var _resCount:int;
		private var _actionTime:int;
		private var _fullness:int;
		
		private var _actionTimer:Timer;
		private var _fullnessTimer:Timer;
		
		private const COLLECT_STATE:int = 0;
		private const SPEEDUP_STATE:int = 1;
		private const FEED_STATE:int = 2;
		
		public function Animal() 
		{
			
		}
		
		override public function create(data:Object):void 
		{
			super.create(data);
			_resType = _data.res.type;
			_resCount = _data.res.count;
			_actionTime = _data.actionTime;
			_fullness = _data.fullness;
			
			initStates();
		}
		
		override protected function initStates():void 
		{
			setState(SPEEDUP_STATE);
			_fullnessTimer = new Timer(1000, _fullness);
			_fullnessTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onFullnessTimerComplete);
			_fullnessTimer.start();
		}
		
		override protected function setState(state:int):void 
		{
			_state = state;
			
			switch (_state) {
				case COLLECT_STATE:
					
					break;
				case SPEEDUP_STATE:
					if (!_actionTimer) {
						_actionTimer = new Timer(1000, _actionTime);
						_actionTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onActionTimerComplete);
					}
					if ((_actionTimer.repeatCount - _actionTimer.currentCount) <= 0) {
						_actionTimer.stop();
						_actionTimer.reset();
						_actionTimer.start();
					} else {
						_actionTimer.start();
					}
					break;
				case FEED_STATE:
					_actionTimer.stop();
					break;
			}
			rebuildCursor();
		}
		
		private function rebuildCursor():void {
			if (_cursor) {
				AppControl.STAGE.removeChild(_cursor);
				_cursor.bitmapData.dispose();
				_cursor = null;
				switch (_state) {
					case COLLECT_STATE:
						_cursor = new Bitmap(AppControl.getObject("CollectAnimalCursor") as BitmapData);
						break;
					case SPEEDUP_STATE:
						_cursor = new Bitmap(AppControl.getObject("SpeedupCursor") as BitmapData);
						break;
					case FEED_STATE:
						_cursor = new Bitmap(AppControl.getObject("FeedCursor") as BitmapData);
						break;
				}
				AppControl.STAGE.addChild(_cursor);
				_cursor.x = AppControl.STAGE.mouseX;
				_cursor.y = AppControl.STAGE.mouseY;
			}
		}
		
		private function onActionTimerComplete(e:TimerEvent):void 
		{
			setState(COLLECT_STATE);
		}
		
		private function onFullnessTimerComplete(e:TimerEvent):void 
		{
			if (_state == SPEEDUP_STATE) {
				setState(FEED_STATE);
			}
		}
		
		override protected function createCursor():void 
		{
			if (!_cursor) {
				switch (_state) {
					case COLLECT_STATE:
						_cursor = new Bitmap(AppControl.getObject("CollectAnimalCursor") as BitmapData);
						break;
					case SPEEDUP_STATE:
						_cursor = new Bitmap(AppControl.getObject("SpeedupCursor") as BitmapData);
						break;
					case FEED_STATE:
						_cursor = new Bitmap(AppControl.getObject("FeedCursor") as BitmapData);
						break;
				}
			}
		}
		
		override protected function checkState():void 
		{
			switch (_state) {
				case COLLECT_STATE:
					//don't show window
					break;
				case SPEEDUP_STATE:
					StateWindow.inst.show(this, _name, _actionTimer);
					break;
				case FEED_STATE:
					StateWindow.inst.show(this, _name, _actionTimer, true);
					break;
			}
		}
		
		override public function checkForAction():void 
		{
			switch (_state) {
				case COLLECT_STATE:
					action();
					break;
				case SPEEDUP_STATE:
					//TODO spend money
					action();
					break;
				case FEED_STATE:
					if (PDControl.inst.getObject("ingredients", "wheat").value == 0) {
						Notification.inst.show("НЕДОСТАТОЧНО РЕСУРСОВ!");
						return;
					}
					feed();
					break;
			}
		}
		
		override protected function action():void 
		{
			PDControl.inst.getObject(_data.res.sort, _data.res.type).value++;
			StateWindow.inst.hide();
			setState(SPEEDUP_STATE);
			if ((_fullnessTimer.repeatCount - _fullnessTimer.currentCount) <= 0) {
				setState(FEED_STATE);
			}
			
			ItemEffects.inst.showItem(this, _data.res.type, _data.res.count);
			
			eaze(this).to(0.2, { alpha:0.2 } ).to(0.2, { alpha:1 });
		}
		
		private function feed():void 
		{
			if (!_fullnessTimer) {
				_fullnessTimer = new Timer(1000, _fullness);
				_fullnessTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onFullnessTimerComplete);
			}
			
			PDControl.inst.getObject("ingredients", "wheat").value--;
			PDControl.inst.updateView();
			StateWindow.inst.hide();
			setState(SPEEDUP_STATE);
			
			ItemEffects.inst.showItem(this,"wheat", 1,false);
			
			eaze(this).to(0.2, { alpha:0.2 } ).to(0.2, { alpha:1 });
			
			_fullnessTimer.reset();
			_fullnessTimer.start();
			
		}
		
	}

}