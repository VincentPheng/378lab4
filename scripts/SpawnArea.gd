extends Area2D
class_name SpawnArea

var zombie = preload("res://instances/zombie.tscn")

@export var collision_shape: CollisionShape2D

var rng = RandomNumberGenerator.new()
var area_size: Vector2
var top_left: Vector2
var bottom_right: Vector2
var can_spawn: bool = true
var spawn_limit: int
var should_spawn: bool

func _ready():
	area_size = collision_shape.get_shape().get_rect().size
	top_left = Vector2(collision_shape.global_position.x - (area_size.x / 2), collision_shape.global_position.y - (area_size.y / 2))
	bottom_right = Vector2(collision_shape.global_position.x + (area_size.x / 2), collision_shape.global_position.y + (area_size.y / 2))
	spawn_limit = get_tree().current_scene.max_zombies
	should_spawn = get_tree().current_scene.spawn_zombies

func _process(delta):
	if should_spawn:
		var zombie_count = len(get_tree().get_nodes_in_group("Zombie"))
		var rand_pos = Vector2(rng.randf_range(top_left.x, bottom_right.x), rng.randf_range(top_left.y, bottom_right.y))
		if rand_pos.distance_to(get_tree().current_scene.get_node("Player").global_position) > 200:
			if zombie_count < spawn_limit and can_spawn:
				var zombie_instance = zombie.instantiate()
				zombie_instance.global_position = rand_pos
				get_tree().current_scene.add_child(zombie_instance)
				$SpawnTimer.start()
				can_spawn = false


func _on_spawn_timer_timeout():
	can_spawn = true
