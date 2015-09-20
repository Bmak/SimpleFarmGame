# SimpleFarmGame
Test Task for Cosmos Company

Реализована простейшая игра по типу фермы.
Игра подгружает внешние файлы:
- config.json
- res.swf
В котороых хранятся игровые данные.
При локальном запуске флешки все файлы должны находится в одной директории.

В файле конфигурации config.json можно задавать:
- размер карты "map" (width, height)
- начальные игровые данные игрока "data" (количество ресурсов, денег)
- игровые объекты, которые будут расположены на карте "objects"

На данный момент приложение работает только в локальном режиме, т.к. скомпилированно с дополнительными параметрами -use-network=false

