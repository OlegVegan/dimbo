extends Sprite2D
var speed = 420
var pos = Vector2.ZERO

func _process(delta):
	var dir = Input.get_vector("left", "right", "up", "down")
	position += dir * speed * delta
