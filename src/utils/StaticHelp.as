package utils 
{
	/**
	 * Статичный класс, содержит вспомогательные функции, позволяющие оптимизировать и ускорить создание повторяющихся объектов.
	 * @author ProBigi
	 */
	public class StaticHelp 
	{
		
		public function StaticHelp() 
		{
			
		}
		
		/**
		 * Конвертация общего количества секунд в полноценное время
		 * @param	time - общее количество секунд
		 * @return возвращает массив с часами, минутами, секундами
		 */
		public static function timeConverter(time:int):Array {
			var result:Array = [];
			var hours:int = time / 3600;
			var minutes:int = (time % 3600) / 60;
			var seconds:int = time % 60;
			result.push(hours, minutes, seconds);
			return result;
		}
		
		/**
		 * Конвертация времени в общее количество секунд
		 * @param	time - массив содержит часы, минуты, секунды
		 * @return  возвращает общее количество секунд
		 */
		public static function secondsConverter(time:Array):int {
			var hours:int = time[0];
			var minutes:int = time[1];
			var seconds:int = time[2];
			return (hours * 60 * 60 + minutes * 60 + seconds);
		}
	}

}