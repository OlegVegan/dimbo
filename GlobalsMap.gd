extends Node

var historyMap = {}
var historyMapLoaded = {}
var areaSize = 992
var max_areas = 10
var currentArea = Vector2(0,0) #x,y

var currentMap = [Vector2(-1,-1), Vector2(0,-1), Vector2(1,-1),
				Vector2(-1, 0), Vector2(0,0), Vector2(1,0),
				Vector2(-1,1), Vector2(0,1), Vector2(1,1)]


func initMap():
	for m in currentMap:
		var ran = randi_range(1, max_areas)
		historyMap[m] = ran
		historyMapLoaded[m] = true

# Узнаём на какой карте находимся от координат игрока
func updateMap(player_coords):
	var newCurrentArea = getCurrentVect(player_coords)
	
	
	#print('newCurrentArea')
	#print(newCurrentArea)
	#print('currentArea')
	#print(currentArea)
	
	
	if currentArea == newCurrentArea:
		#print("no update needed")
		return
	else:
		currentArea = newCurrentArea
		
	# заодно обновляем карту
	currentMap = [currentArea + Vector2(-1,-1), currentArea + Vector2(0,-1), currentArea + Vector2(1,-1),
				currentArea + Vector2(-1, 0), currentArea, currentArea + Vector2(1,0),
				currentArea + Vector2(-1,1), currentArea + Vector2(0,1), currentArea + Vector2(1,1)]
				
	#print('currentMap')
	#print(currentMap)
		
	for m in currentMap:
		# если ещё не в памяти, даём рандомное значение
		if !historyMap.has(m):
			var ran = randi_range(1, max_areas)
			historyMap[m] = ran
			historyMapLoaded[m] = false
			

func getCurrentVect(player_coords):
	var pl_x = round(player_coords.x / areaSize)
	var pl_y = round(player_coords.y / areaSize)
	var vect = Vector2(pl_x, pl_y)
	return vect
	
