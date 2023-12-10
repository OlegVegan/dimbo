extends Node

var historyMap = {}
var areaSize = 500
var max_areas = 10
var currentArea = Vector2(0,0) #x,y

var currentMap = [Vector2(-1,-1), Vector2(0,-1), Vector2(1,-1),
				Vector2(-1, 0), Vector2(0,0), Vector2(1,0),
				Vector2(-1,1), Vector2(0,1), Vector2(1,1)]


func initMapRandomization():
	for m in currentMap:
		var ran = randi_range(1, max_areas)
		historyMap[m] = ran

# Узнаём на какой карте находимся от координат игрока
func updateMap(player_coords):
	var pl_x = int(player_coords.x / areaSize)
	var pl_y = int(player_coords.y / areaSize)
	var vect = Vector2(pl_x, pl_y)
	currentArea = vect
	# заодно обновляем карту
	currentMap = [currentArea + Vector2(-1,-1), currentArea + Vector2(0,-1), currentArea + Vector2(1,-1),
				currentArea + Vector2(-1, 0), currentArea, currentArea + Vector2(1,0),
				currentArea + Vector2(-1,1), currentArea + Vector2(0,1), currentArea + Vector2(1,1)]
	
	for m in currentMap:
		# Эта область уже напомнена
		if historyMap.has(m):
			pass
		else:
			var ran = randi_range(1, max_areas)
			historyMap[m] = ran
