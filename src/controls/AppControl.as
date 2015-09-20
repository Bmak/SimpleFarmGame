package controls 
{
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import map.Map;
	import objects.MapObject;
	import objects.types.Animal;
	import objects.types.Plant;
	import utils.ItemEffects;
	import utils.Notification;
	import utils.StateWindow;
	/**
	 * ...
	 * @author ProBigi
	 */
	public class AppControl 
	{
		public static var STAGE:Stage;
		private var _mainCont:Sprite;
		
		private var _map:Map;
		private var _mapObjects:Vector.<MapObject>;
		
		private var _res:ResLoader;
		public static var GUI:LoaderInfo;
		
		public function AppControl(container:Sprite) 
		{
			_mainCont = container;
			AppControl.STAGE = _mainCont.stage;
		}
		
		public function init():void {
			_res = new ResLoader();
			_res.addEventListener(Event.COMPLETE, completeLoading);
			_res.init();
		}
		
		public static function getObject(name:String):Object {
			return new (GUI.applicationDomain.getDefinition(name));
		}
		
		private function completeLoading(e:Event):void 
		{
			_res.removeEventListener(Event.COMPLETE, completeLoading);
			GUI = _res.guiData;
			
			createMap();
			createData();
			createObjects();
			
			initUtils();
		}
		
		private function createData():void 
		{
			//по идее текущие данные должны подгружаться с сервера
			PDControl.inst.init(_res.config.data, _mainCont);
		}
		
		private function createMap():void {
			_map = new Map();
			var w:int = _res.config.map.width;
			var h:int = _res.config.map.height;
			_map.create(w, h);
			
			_map.x = (_mainCont.stage.stageWidth - _map.width) / 2;
			_map.y = _mainCont.stage.stageHeight/2;
			_mainCont.addChild(_map);
		}
		
		private function createObjects():void {
			_mapObjects = new Vector.<MapObject>;
			
			for each (var obj:Object in _res.config.objects) {
				var gameObj:MapObject;
				switch (obj.type) {
					case "animal":
						gameObj = new Animal();
						break;
					case "plant":
						gameObj = new Plant();
						break;
				}
				gameObj.create(obj);
				_mapObjects.push(gameObj);
				_map.setOnMapObject(gameObj);
			}
		}
		
		private function initUtils():void 
		{
			StateWindow.inst.init();
		}
		
	}

}