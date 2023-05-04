extends StaticBody2D

@export var SPEED = 50

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position + SPEED * delta
