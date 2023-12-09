extends CharacterBody2D

@onready var player = get_parent().get_node("Player")
var target_pos 
var speed = 260
var can_shoot_laser = true
var has_target = false
signal target_found
signal target_lost
var laser_targets = []
@onready var ap_legs = $AnimationPlayerLegs
@onready var laser_sound = $LaserSound
@onready var laser_start_sound = $LaserStartSound
var prevVel = null
var notMoving = true
var dmg = 2
var dmg_multiplier = 1
var dmg_multiplier_max = 4
var timer_m = false


func _ready():
	$ProgressBar.max_value = Globals.ally_max_health
	$ProgressBar.value = Globals.ally_max_health

func _process(_delta):
	queue_redraw()
	set_animation()
			
	if $ProgressBar.value == Globals.ally_max_health:
		$ProgressBar.visible = false
	else:
		$ProgressBar.visible = true
	$ProgressBar.value = Globals.ally_health
		
	if laser_targets.size():	
		speed = 100	
		laser()
		var a_to_b = (laser_targets[0].global_position - self.global_position)
		#$Sprite2D_shoot.rotation = a_to_b.angle()
		
		if a_to_b.x > 0:		
			$Sprite2D_shoot.flip_h = false
		else:
			$Sprite2D_shoot.flip_h = true
			
		
		if !timer_m:
			$MultiTimer.start()
			timer_m = true
	else:
		speed = 260
		var tween = create_tween()
		tween.tween_property($Sprite2D, 'rotation', 0, 0.3)
	
		if velocity.x > 0:		
			$Sprite2D.flip_h = false
		else:
			$Sprite2D.flip_h = true
		
		$MultiTimer.stop()
		dmg_multiplier = 1
		timer_m = false
			
			

func _draw():	
	if laser_targets.size():		
		#print("НАДО РИСОВАТЬ")
		draw_line(Vector2.ZERO, laser_targets[0].global_position - self.global_position, Color.RED, 3 * dmg_multiplier)

func _physics_process(delta):
	if !prevVel:
		prevVel = velocity
	else:
		if prevVel == velocity:
			notMoving = true
		else:
			prevVel = velocity
			notMoving = false
			
	var player_pos = player.position
	target_pos = (player_pos - position).normalized()
	if (position.distance_to(player_pos)) > 100:
		var dir = (target_pos).normalized()
		velocity = (dir * speed)
		move_and_slide()


func _on_area_2d_area_entered(area):
	if "is_enemy" in area:
		laser_targets.push_back(area)
		if !has_target:
			target_found.emit()
			

func _on_area_2d_area_exited(area):
	laser_targets.erase(area)
	if !laser_targets.size():		
		target_lost.emit()

func laser():
	if can_shoot_laser:
		can_shoot_laser = false
		$LaserTimer.start()
		var active_targ = laser_targets[0]
		var box = active_targ.get_parent()
		box.hit(dmg * dmg_multiplier)
		laser_sound.pitch_scale = (randf_range(1, 1.2))
		laser_sound.play()

func _on_laser_timer_timeout():
	can_shoot_laser = true
	
func set_animation():
	#print(get_real_velocity())
	if notMoving:
		ap_legs.play("idle")
	else:
		ap_legs.play("run")
		
	if laser_targets.size():
		$Sprite2D.visible = false
		$Sprite2D_shoot.visible = true
	else:
		$Sprite2D.visible = true
		$Sprite2D_shoot.visible = false


func _on_target_found():
	has_target = true
	laser_start_sound.play()


func _on_target_lost():
	if !laser_targets.size():
		has_target = false


func _on_multiplier_timeout():
	if dmg_multiplier > dmg_multiplier_max:
		return
	else:
		dmg_multiplier += 1
