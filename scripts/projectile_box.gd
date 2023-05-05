extends Node2D

@export var stats: Resource
@export var projectiles_per_box_lower: int = 1
@export var projectiles_per_box_upper: int = 1

var rng = RandomNumberGenerator.new()

func _on_area_2d_area_entered(area):
	stats.projectiles_left += rng.randi_range(projectiles_per_box_lower, projectiles_per_box_upper)
	queue_free()
