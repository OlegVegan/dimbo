extends Node2D

@onready var nade = preload("res://scenes/levels/granade.tscn")
@onready var crateScene = preload("res://scenes/levels/crate.tscn")
@onready var playereScene = preload("res://scenes/levels/Player.tscn")
@onready var area1 = preload("res://scenes/levels/play_area.tscn")
#@onready  var poopScene = preload("res://scenes/levels/poop.tscn")
var initialCratesOnScene = 200
var player_attacks = false


func _ready():
	var newArea = area1.instantiate()
	newArea.global_position = Vector2(0,0)
	$PlayArea.add_child(newArea)
	
	Globals.health_change.connect(_on_health_change)
	Globals.nade_throw.connect(_on_nade_throw)
	spawnInitialCrates()

func _process(_delta):
	$UI/FPS.text = "fps: " + str(Engine.get_frames_per_second())
	$UI/PlayerHealth.text = "Health: " + str(Globals.player_health)
	$UI/Coins.text = str(Globals.coins)
	$UI/CrateNum.text = "Crates: " + str(Globals.cratesOnScene)

func destroy_crate(node):
	remove_child(node)

func spawnInitialCrates():	
	for c in initialCratesOnScene:
		spawnCrate()

func spawnCrate():
	Globals.cratesOnScene = Globals.cratesOnScene + 1
	var randPositon = Vector2(randi_range(-1000, 1000), randi_range(-1000, 1000))
	var newCrate = crateScene.instantiate()
	newCrate.position = randPositon
	#newCrate.player_near_crate.connect(on_player_near_crate)
	add_child(newCrate)

func _on_timer_timeout():
	spawnCrate()

func _on_player_attacks():
	player_attacks = true

func _on_timer_attack_reset_timeout():
	player_attacks = false
	
	
func _on_health_change():
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
	print("_on_nade_throw")

