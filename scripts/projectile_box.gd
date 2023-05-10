extends Pickup

@export var projectiles_per_box_lower: int = 1
@export var projectiles_per_box_upper: int = 1

var rng = RandomNumberGenerator.new()

func _on_area_2d_area_entered(_area):
	disable_collisions_play_sound()
	PlayerData.projectiles_left += rng.randi_range(projectiles_per_box_lower, projectiles_per_box_upper)

func _on_pickup_sound_finished():
	queue_free()
