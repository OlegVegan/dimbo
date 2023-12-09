extends Node2D
@onready var sound = $Player

func _ready():
	var tween = create_tween()
	Globals.coin_picked.emit()
	tween.tween_property(self, "position:y", position.y - 6, 0.2)
	tween.tween_property(self, "position:y", position.y, 0.1)
	tween.tween_property(self, "modulate:a", 0, 0.2)
	await tween.finished
	queue_free()
