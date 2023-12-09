extends RigidBody2D
var max_hit_points = 30
var hit_points = 30
var alive = false

@onready var coinScene = preload("res://scenes/levels/coin.tscn")
@onready var dummy = preload("res://scenes/levels/dummy.tscn")
@onready var poopScene = preload("res://scenes/levels/poop.tscn")
@onready var box_die_sound = $Die
@onready var playerScene = $Player
@onready var tookDmg = $took_dmg

func _ready():
	var tween = create_tween()
	tween.tween_property(self, 'scale', Vector2(1,1), 0.1).from(Vector2(0,0))
	$AnimationPlayer.play("legs")
	$ProgressBar.max_value = hit_points
		
func _physics_process(delta):
	rotation_degrees = 0
	
	
func _process(delta):
	if $ProgressBar.max_value == hit_points:
		$ProgressBar.visible = false
	else:
		$ProgressBar.visible = true
	$ProgressBar.value = hit_points	
	#under_attack = $playerScene.PlayerMelee.is_attacking
	if hit_points <= 0:
		die()	
	
	if !alive:
		if hit_points < max_hit_points:
			chance_to_become_alive()


func die():	
	#box_die_sound.play()
	var randNum = randi_range(0, 100)
	if randNum > 20:
		var newCoin = coinScene.instantiate()
		newCoin.position = position
		get_parent().get_node("Items").add_child(newCoin)
		addCoin()
	else:
		var newPoop = poopScene.instantiate()
		newPoop.position = position
		get_parent().get_node("Items").add_child(newPoop)
			
	Globals.cratesOnScene = Globals.cratesOnScene - 1
	queue_free() 


func addCoin():
	Globals.coins = Globals.coins + 1
	
func hit(dmg):	
	hit_points -= dmg
	#Звук только при большом уроне
	if dmg > 10:
		Globals.crate_takes_dmg.emit()


func chance_to_become_alive():
	alive = true
	var newCrate = dummy.instantiate()
	newCrate.hit_points = hit_points
	newCrate.position = position
	$"..".add_child(newCrate)
	queue_free()
