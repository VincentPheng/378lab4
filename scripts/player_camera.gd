extends Camera2D
class_name PlayerCamera

@export var random_shake_strength := 30.0
@export var shake_decay_rate := 5.0

@onready var rng = RandomNumberGenerator.new()

var shake_strength := 0.0

func _process(delta):
	shake_strength = lerp(shake_strength, 0.0, shake_decay_rate * delta)
	offset = get_random_offset()

func shake():
	shake_strength = random_shake_strength
	
func get_random_offset() -> Vector2:
	return Vector2(
		rng.randf_range(-shake_strength, shake_strength),
		rng.randf_range(-shake_strength, shake_strength)
	)
