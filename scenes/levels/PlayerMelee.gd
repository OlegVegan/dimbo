extends Area2D
var dmg: int = 18
var is_attacking: bool = false
var enemy_list = []

func _ready():
	Globals.player_is_attacking.connect(_on_attack)


func _on_area_entered(area):
	if "is_enemy" in area:
		enemy_list.push_back(area)


func _on_area_exited(area):
	if "is_enemy" in area:
		enemy_list.erase(area)

func _on_attack():
	for e in enemy_list:
		var par = e.get_parent()
		par.hit(dmg)
