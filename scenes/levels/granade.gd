extends RigidBody2D
var explosion = false
var enemy_list = []
var enemy_list2 = []
var dmg = 40
var dmg2 = 5
var processSet = false

func _ready():
	# отчсчёт таймера, взрыв
	$Timer.start()


func _process(delta):
	if explosion:
		$Blast.visible = true
		position = position
		$CollisionShape2D.scale = Vector2(3,3)
		damage_enemies()
		processSet = true


func _on_timer_timeout():
	explosion = true

func damage_enemies():
	if processSet:
		return
	Globals.nade_exp.emit()
	#$expl.play()
	for e in enemy_list:
		var par = e.get_parent()
		par.hit(dmg)
	for e in enemy_list2:
		if e:			
			var par = e.get_parent()
			par.hit(dmg2)
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($Sprite2D, "modulate:a", 0, 0)
	tween.tween_property(self, "modulate:a", 0, 0.4)
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.3).from(0.4)
	await tween.finished 
	queue_free()


func _on_area_2d_area_entered(area):
	if "is_enemy" in area:
		enemy_list.push_back(area)


func _on_area_2d_area_exited(area):
	enemy_list.erase(area)


func _on_area_2d_2_area_entered(area):
	if "is_enemy" in area:
		enemy_list2.push_back(area)


func _on_area_2d_2_area_exited(area):
	enemy_list2.erase(area)
