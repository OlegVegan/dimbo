extends Node2D

@onready var nade = preload("res://scenes/levels/granade.tscn")
@onready var crateScene = preload("res://scenes/levels/crate.tscn")
@onready var playereScene = preload("res://scenes/levels/Player.tscn")
@onready var map_picker = preload("res://scenes/levels/map_picker.tscn")
var initialCratesOnScene = 20
var maxCratesOnScene = 100
var player_attacks = false
var player_coords


func _ready():
	GlobalsMap.initMap()
	var areaSize = GlobalsMap.areaSize
	var currentMap = GlobalsMap.currentMap
	var historyMap = GlobalsMap.historyMap
	for m in currentMap:
		var newArea = map_picker.instantiate()
		var area_num = historyMap[m]
		newArea.selectedMap = area_num
		newArea.mapName = m
		newArea.inst = true		
		newArea.global_position = m * areaSize
		$GenMap.add_child(newArea)	
	
	Globals.health_change.connect(_on_health_change)
	Globals.nade_throw.connect(_on_nade_throw)
	spawnInitialCrates()

func _process(_delta):	
	$UI/FPS.text = "fps: " + str(Engine.get_frames_per_second())
	$UI/PlayerHealth.text = "Health: " + str(Globals.player_health)
	$UI/Coins.text = str(Globals.coins)
	$UI/CrateNum.text = "Enemies: " + str($Enemies.get_child_count())
	if Globals.pistol_mode:
		$UI/IconPistol.visible = true
		$UI/IconPistol/Label.text = str($Player.bullets) + "/" + str($Player.magSize)
		$UI/IconCrawbar.visible = false
	else:
		$UI/IconPistol.visible = false
		$UI/IconCrawbar.visible = true
	
	if Input.is_action_just_pressed("zoom"):
		if $Player/Camera2D.zoom == Vector2(2,2):
			$Player/Camera2D.zoom = Vector2(0.18,0.18)
		else:
			$Player/Camera2D.zoom = Vector2(2,2)

func destroy_crate(node):
	remove_child(node)

func spawnInitialCrates():	
	for c in initialCratesOnScene:
		spawnCrate()

func _on_timer_timeout():
	if $Enemies.get_child_count() < maxCratesOnScene:
		spawnCrate()
	
func spawnCrate():
	var p_p = $Player.global_position
	var radius = randf_range(220.0, 520.0)
	var center = p_p
	var angle = 2 * PI * randf_range(0,1)
	var xdirection = Vector2(cos(angle), sin(angle))
	var xpos = center + xdirection * radius
	var randPositon = xpos
	
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
	#print("_______map checker")
	mapVisibilityUpdate()

func mapVisibilityUpdate():
	var historyMap = GlobalsMap.historyMap
	var historyMapLoaded = GlobalsMap.historyMapLoaded
	var currentMap = GlobalsMap.currentMap
	var areaSize = GlobalsMap.areaSize
	var cur_a = GlobalsMap.currentArea
	
	print('___________currentArea')
	print(cur_a)
	#print('currentMap')
	#print(currentMap)
	
	# скрываем области, которые не на ближайшей карте	
	for n in $GenMap.get_children():
		if n.mapName in currentMap:
			n.visible = true
		else:
			n.visible = false
		
	for m in currentMap:
		if !historyMapLoaded[m]:
			var newArea = map_picker.instantiate()
			var area_num = historyMap[m]
			newArea.selectedMap = area_num
			newArea.mapName = m
			newArea.global_position = m * areaSize
			$GenMap.add_child(newArea)	
			GlobalsMap.historyMapLoaded[m] = true
