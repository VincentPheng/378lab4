extends Camera2D
class_name PlayerCamera

@export var random_shake_strength := 30.0
@export var shake_decay_rate := 5.0
@export var zoom_speed := Vector2(0.01, 0.01)

@onready var rng = RandomNumberGenerator.new()
@onready var target_zoom = zoom

var shake_strength := 0.0
var enable_shake := true

func _process(delta):
	if enable_shake:
		shake_strength = lerp(shake_strength, 0.0, shake_decay_rate * delta)
		offset = get_random_offset()
		if zoom > target_zoom:
			zoom -= zoom_speed
		elif zoom < target_zoom:
			zoom += zoom_speed

func set_target_zoom(new_zoom: Vector2):
	target_zoom = new_zoom

func shake():
	shake_strength = random_shake_strength
	
func get_random_offset() -> Vector2:
	return Vector2(
		rng.randf_range(-shake_strength, shake_strength),
		rng.randf_range(-shake_strength, shake_strength)
	)
