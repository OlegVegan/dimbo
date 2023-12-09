extends Node
signal health_change
signal player_is_attacking
signal crate_takes_dmg
signal coin_picked
signal nade_throw
signal nade_exp
var gameHistoryMap = {}
var areaSize = 1000
var currentMapAreaIds = [1, 1, 1,
						1, 1, 1,
						1, 1, 1 ] 
var currentMap = [Vector2(-1,-1), Vector2(-1,0), Vector2(0,-1), 
					Vector2(-1,0), Vector2(0,0), Vector2(1,0), 
					Vector2(-1,1), Vector2(0,1), Vector2(1,1)]

# Создаём карту рандомных ID
# Расстановка сцен по координатам



var cratesOnScene = 0:
	get:
		return cratesOnScene
	set(val):
		cratesOnScene = val

var player_max_health = 100
var player_health = 100:
	get:
		return player_health
	set(val):
		health_change.emit()
		player_health = val


var ally_max_health = 60
var ally_health = 60:
	get:
		return ally_health
	set(val):
		health_change.emit()
		ally_health = val

var coins = 0:
	get:
		return coins
	set(val):
		coins = val