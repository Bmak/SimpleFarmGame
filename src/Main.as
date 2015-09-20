package
{
	import controls.AppControl;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Security;
	import map.Map;
	
	/**
	 * ...
	 * @author ProBigi
	 */
	public class Main extends Sprite 
	{
		
		private var _app:AppControl;
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			Security.allowDomain("*");
			
			_app = new AppControl(this);
			_app.init();
		}
		
	}
	
}