extends Node2D

@onready var nade = preload("res://scenes/levels/granade.tscn")
@onready var crateScene = preload("res://scenes/levels/crate.tscn")
@onready var playereScene = preload("res://scenes/levels/Player.tscn")
@onready var map_picker = preload("res://scenes/levels/map_picker.tscn")
var initialCratesOnScene = 50
var player_attacks = false
var player_coords


func _ready():
	GlobalsMap.initMapRandomization()
	var areaSize = GlobalsMap.areaSize
	var currentMap = GlobalsMap.currentMap
	var historyMap = GlobalsMap.historyMap
	for m in currentMap:
		var newArea = map_picker.instantiate()
		var area_num = historyMap[m]
		newArea.selectedMap = area_num
		newArea.global_position = m * areaSize
		$GenMap.add_child(newArea)	
	
	Globals.health_change.connect(_on_health_change)
	Globals.nade_throw.connect(_on_nade_throw)
	spawnInitialCrates()

func _process(_delta):	
	$UI/FPS.text = "fps: " + str(Engine.get_frames_per_second())
	$UI/PlayerHealth.text = "Health: " + str(Globals.player_health)
	$UI/Coins.text = str(Globals.coins)
	$UI/CrateNum.text = "Crates: " + str($Enemies.get_child_count())

func destroy_crate(node):
	remove_child(node)

func spawnInitialCrates():	
	for c in initialCratesOnScene:
		spawnCrate()

func _on_timer_timeout():
	spawnCrate()
	
func spawnCrate():
	var range = 800
	var p_p = $Player.global_position
	var randPositon = Vector2(randi_range(p_p.x - range, p_p.x + range), randi_range(p_p.y - range, p_p.y + range))
	var newCrate = crateScene.instantiate()
	newCrate.position = randPositon
	#newCrate.player_near_crate.connect(on_player_near_crate)
	$Enemies.add_child(newCrate)

func _on_player_attacks():
	player_attacks = true

func _on_timer_attack_reset_timeout():
	player_attacks = false
	
	
func _on_health_change():
	return
	if Globals.player_health <= 0 or Globals.ally_health <= 0:
		$Player.speed = 0
		$Ally.speed = 0
		$UI/CenterContainer/CenterText.text = "YOU DIED"

	
func _on_nade_throw():
	var n = nade.instantiate()
	var p_p = $Player.global_position
	var m_p = get_global_mouse_position()
	n.global_position = p_p + Vector2(20,10)
	var dir = (get_global_mouse_position() - $Player.global_position).normalized()
	n.linear_velocity = dir * 400
	$Nades.add_child(n)


func _on_map_check_timer_timeout():
	GlobalsMap.updateMap($Player.global_position)
	# Актуализировать карты в игре
	var historyMap = GlobalsMap.historyMap
	var currentMap = GlobalsMap.currentMap
	var areaSize = GlobalsMap.areaSize
	var currentArea = GlobalsMap.currentArea
	print(currentArea)
	
	for n in $GenMap.get_children():
		$GenMap.remove_child(n)
		n.queue_free()
	for m in currentMap:
		var newArea = map_picker.instantiate()
		var area_num = historyMap[m]
		newArea.selectedMap = area_num
		newArea.global_position = m * areaSize
		$GenMap.add_child(newArea)	
	
	# Чистим далёких врагов
