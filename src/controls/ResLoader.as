package controls 
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * Загрузчик ресурсов
	 * @author ProBigi
	 */
	public class ResLoader extends EventDispatcher
	{
		
		private var _config:Object;
		private const PATH:String = "confing.json";
		
		private var _guiData:LoaderInfo;
		private const PATH_RES:String = "res.swf";
		
		public function ResLoader() 
		{
			
		}
		
		public function init():void {
			loadConfig();
			
		}
		
		public function get config():Object { return _config; }
		public function get guiData():LoaderInfo { return _guiData; }
		
		private function loadConfig():void 
		{
			var configLoader:URLLoader = new URLLoader(new URLRequest(PATH));
			configLoader.addEventListener(Event.COMPLETE, loadConfigComplete);
			configLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		private function onIOError(event:IOErrorEvent):void {
			throw new IOError("[ResLoader] Ошибка ввода/вывода");
		}
		
		private function loadConfigComplete(e:Event):void 
		{
			var configLoader:URLLoader = e.currentTarget as URLLoader;
			configLoader.removeEventListener(Event.COMPLETE, loadConfigComplete);
			configLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			_config = JSON.parse(configLoader.data);
			
			loadResources();
			
			
		}
		
		private function loadResources():void 
		{
			var resLoader:Loader = new Loader();
			
			resLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadResComplete);
			resLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			resLoader.load(new URLRequest(PATH_RES));
		}
		
		private function loadResComplete(e:Event):void 
		{
			var resLoader:LoaderInfo = e.currentTarget as LoaderInfo;
			resLoader.removeEventListener(Event.COMPLETE, loadResComplete);
			resLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			_guiData = resLoader;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}

}