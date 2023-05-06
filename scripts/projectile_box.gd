extends Node2D

@export var projectiles_per_box_lower: int = 1
@export var projectiles_per_box_upper: int = 1

var rng = RandomNumberGenerator.new()

func _on_area_2d_area_entered(area):
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	visible = false
	$PickupSound.play()
	PlayerData.projectiles_left += rng.randi_range(projectiles_per_box_lower, projectiles_per_box_upper)

func _on_pickup_sound_finished():
	queue_free()
