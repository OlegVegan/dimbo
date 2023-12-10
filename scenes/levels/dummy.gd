extends CharacterBody2D
var max_hit_points = 30
var hit_points = 30
var speed = 40
var dmg = 4
var target = null

@onready var coinScene = preload("res://scenes/levels/coin.tscn")
@onready var poopScene = preload("res://scenes/levels/poop.tscn")
@onready var box_die_sound = $Die
@onready var tookDmg = $took_dmg

signal dmg_cooldown

func _ready():
	$Legs.visible = true
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($Legs, 'scale', Vector2(1,1), 0.5).from(Vector2(0,0))
	tween.tween_property($Sprite2D, 'position:y', -10, 0.5)
	tween.tween_property($ProgressBar, 'position:y', -36, 0.5)
	tween.tween_property($Shadow, 'position:y', 10, 0.5)
	tween.tween_property($Shadow, 'scale', Vector2(0.5,0.5), 0.5)
	tween.tween_property($Head3, 'scale', Vector2(0.26,0.26), 0.1).from(Vector2(0,0))
	tween.tween_property($CollisionShape2D, 'scale', Vector2(2,2), 0.5)
	tween.tween_property(self, 'scale', Vector2(1,1), 0.1).from(Vector2(0,0))
	$AnimationPlayer.play("legs")
	$ProgressBar.max_value = max_hit_points
	$ProgressBar.value = hit_points
		
func _physics_process(delta):
	rotation_degrees = 0
	var player = get_parent().get_parent().get_node("Player")
	var player_pos = player.position
	var target_pos = (player_pos - position).normalized()
	if (position.distance_to(player_pos)) > Globals.maxEnemyDistance:
		queue_free()
	elif (position.distance_to(player_pos)) > 60:
		var dir = (target_pos).normalized()
		velocity = (dir * speed)
		move_and_slide()
	
	
func _process(delta):
	if $ProgressBar.max_value == hit_points:
		$ProgressBar.visible = false
	else:
		$ProgressBar.visible = true
	$ProgressBar.value = hit_points	
	if hit_points <= 0:
		die()	
	


func die():	
	#box_die_sound.play()
	var randNum = randi_range(0, 100)
	if randNum > 20:
		var newCoin = coinScene.instantiate()
		newCoin.position = position
		get_parent().get_parent().get_node("Items").add_child(newCoin)
		addCoin()
	else:
		var newPoop = poopScene.instantiate()
		newPoop.position = position
		get_parent().get_parent().get_node("Items").add_child(newPoop)
			
	queue_free() 


func addCoin():
	Globals.coins = Globals.coins + 1
	
func hit(dmg):	
	hit_points -= dmg
	#Звук только при большом уроне
	if dmg > 10:
		Globals.crate_takes_dmg.emit()


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		target = body		
		dmg_cooldown.emit()


func _on_dmg_cooldown():	
	if !target:
		return
	target.hit(dmg)
	$DmgTimer.start()


func _on_dmg_timer_timeout():
	if !target:
		return
	target.hit(dmg)


func _on_area_2d_body_exited(body):
	target = null
