extends CharacterBody2D
var speed = 400

@onready var ap_legs = $AnimationPlayerLegs
@onready var sprite_legs = $Legs
@onready var ap_torso = $AnimationPlayerTorso
@onready var sprite_torso = $Torso
@onready var ap_head = $AnimationPlayerHead
@onready var ap_full = $AnimationFullBody
@onready var sprite_head = $Head
@onready var swing_sound = $Swing

signal forceTurn(dir)

var pos = Vector2.ZERO
var can_attack = true
var lastCharDir = 'right'
var charLooks = 'right'
var is_throwing_nade = false
var is_rolling = false

func _ready():	
	$ProgressBar.max_value = Globals.player_max_health
	#Globals.test_var.set(88888)
	turnChar(charLooks)

func _process(delta):	
	if $ProgressBar.value == Globals.player_max_health:
		$ProgressBar.visible = false
	else:
		$ProgressBar.visible = true
	$ProgressBar.value = Globals.player_health
	var dir = Input.get_vector("left", "right", "up", "down")
	if is_rolling:
		velocity = dir * speed * 1.4
	else:
		velocity = dir * speed
	
	
	
	if Input.is_action_pressed("roll"):
		if !is_rolling:			
			roll_anim()
	
	if Input.is_action_pressed("action") and can_attack:
		can_attack = false
		$Timer.start()
		attack_anim()
		
	if Input.is_action_pressed("second_action") and can_attack:
		can_attack = false		
		var where_to_look = int(get_global_mouse_position().x - global_position.x)
		forceTurn.emit(where_to_look)
		$Timer.start()
		Globals.nade_throw.emit()
		nade_anim()
	
	if Input.is_action_just_pressed("left"):
		lastCharDir = 'left'
		turnChar('left')
	
	if Input.is_action_just_pressed("right"):
		lastCharDir = 'right'
		turnChar('right')
		
	var hor_diraction = Input.get_axis("left", "right")
	var vert_diraction = Input.get_axis("up", "down")
	animChar(hor_diraction, vert_diraction)
	move_and_slide()

func _on_timer_timeout():
	$PlayerMelee.is_attacking = false
	is_throwing_nade = false
	can_attack = true
	ap_head.play("idle")
	ap_torso.play("idle")

#func _on_area_2d_body_entered(body):
	#print("body entered player")

func showCoords():
	print(position)

func turnChar(direction):
	if charLooks == direction:
		return
	charLooks = direction
	if direction == 'left':	
		sprite_head.flip_h = true
		sprite_torso.flip_h = true
		sprite_legs.flip_h = true
		$FullBody.flip_h = true
		$PlayerMelee/CollisionShape2D.position.x = 0
	else:
		sprite_head.flip_h = false
		sprite_torso.flip_h = false
		sprite_legs.flip_h = false
		$FullBody.flip_h = false
		$PlayerMelee/CollisionShape2D.position.x = 42
		
func animChar(hor_diraction, vert_diraction):
	if hor_diraction == 0 and vert_diraction == 0:
		ap_legs.play("idle_legs")		
		if $PlayerMelee.is_attacking:
			ap_torso.play("attack")
		elif is_throwing_nade:
			ap_torso.play("nade")	
		else:
			ap_torso.play("idle")
	else:
		if $PlayerMelee.is_attacking:
			ap_torso.play("attack")			
		elif is_throwing_nade:
			ap_torso.play("nade")	
		else:
			ap_torso.play("running")
		if hor_diraction:
			ap_legs.play('running_legs')
		else:
			ap_legs.play('running_legs_v')
			
func attack_anim():		
	$PlayerMelee.is_attacking = true
	ap_head.play("attack")
	swing_sound.pitch_scale = randf_range(0.8, 1.2)
	swing_sound.play()
	Globals.player_is_attacking.emit()
	
func nade_anim():
	is_throwing_nade = true
	ap_head.play("attack")
	pass
	


func _on_force_turn(dir):
	print("_on_force_turn")
	print(dir)
	if dir > 0:
		turnChar('right')
	else:
		turnChar('left')
		
func roll_anim():
	is_rolling = true
	$Head.visible = false
	$Torso.visible = false
	$Legs.visible = false
	$FullBody.visible = true
	turnChar(lastCharDir)	
	
	if lastCharDir == 'right':
		print('катимся вправо')
		#var tween = create_tween()
		#tween.tween_property(self, "global_position:x", 100, 0.4)
	else:
		print('катимся влево')
		#var tween = create_tween()
		#tween.tween_property(self, "global_position:x", -100, 0.4)
	
	ap_full.play("roll")
	


func _on_animation_full_body_animation_finished(anim_name):
	$Head.visible = true
	$Torso.visible = true
	$Legs.visible = true
	$FullBody.visible = false
	is_rolling = false
	
func hit(dmg):
	Globals.player_health = Globals.player_health - dmg
