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
	import utils.StateWindow;
	/**
	 * Класс Растения 
	 * @author ProBigi
	 */
	public class Plant extends MapObject
	{
		
		private var _resType:String;
		private var _resCount:int;
		private var _actionTime:int;
		
		private const COLLECT_STATE:int = 0;
		private const SPEEDUP_STATE:int = 1;
		
		private var _actionTimer:Timer;
		
		public function Plant() 
		{
			
		}
		
		override public function create(data:Object):void 
		{
			super.create(data);
			_resType = _data.res.type;
			_resCount = _data.res.count;
			_actionTime = _data.actionTime;
			
			initStates();
		}
		
		override protected function initStates():void 
		{
			setState(SPEEDUP_STATE);
		}
		
		override protected function setState(state:int):void 
		{
			clearState();
			
			_state = state;
			
			switch (_state) {
				case COLLECT_STATE:
					if (_cursor) {
						AppControl.STAGE.removeChild(_cursor);
						_cursor.bitmapData.dispose();
						_cursor = null;
						_cursor = new Bitmap(AppControl.getObject("CollectPlantCursor") as BitmapData);
						AppControl.STAGE.addChild(_cursor);
						_cursor.x = AppControl.STAGE.mouseX;
						_cursor.y = AppControl.STAGE.mouseY;
					}
					break;
				case SPEEDUP_STATE:
					_actionTimer = new Timer(1000, _actionTime);
					_actionTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
					_actionTimer.start();
					break;
			}
		}
		
		private function onTimerComplete(e:TimerEvent):void 
		{
			setState(COLLECT_STATE);
		}
		
		private function clearState():void 
		{
			if (_actionTimer) {
				_actionTimer.stop();
				_actionTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				_actionTimer = null;
			}
		}
		
		override protected function createCursor():void 
		{
			if (!_cursor) {
				if (_state == COLLECT_STATE) {
					_cursor = new Bitmap(AppControl.getObject("CollectPlantCursor") as BitmapData);
				}
				else if (_state == SPEEDUP_STATE) {
					_cursor = new Bitmap(AppControl.getObject("SpeedupCursor") as BitmapData);
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
			}
		}
		
		override protected function action():void 
		{
			PDControl.inst.getObject(_data.res.sort, _data.res.type).value++;
			PDControl.inst.updateView();
			StateWindow.inst.hide();
			setState(SPEEDUP_STATE);
			
			ItemEffects.inst.showItem(this, _data.res.type, _data.res.count);
			
			eaze(this).to(0.2, { alpha:0.2 } ).to(0.2, { alpha:1 });
		}
	}

}