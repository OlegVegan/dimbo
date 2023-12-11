extends Node2D
signal iSteppedInPoop
@onready var sfx = $Hurt
@onready var ap = $AnimationPlayer

var steppedOn = false
	
func _on_area_2d_body_entered(body):
	var name = body.name
	if steppedOn:
		return
	if name == "Player":
		steppedOn = true
		ap.play("die")
		$"..".get_parent().get_node("Player").hit(10)
		#sfx.pitch_scale = 1
		#sfx.play()
		iSteppedInPoop.emit()
	elif name == "Ally":
		steppedOn = true
		ap.play("die")
		Globals.ally_health = Globals.ally_health - 10		
		sfx.pitch_scale = 1.5
		sfx.play()
		iSteppedInPoop.emit()

func _on_timer_timeout():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 1)
	await tween.finished
	queue_free()
