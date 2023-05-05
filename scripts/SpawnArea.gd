extends Area2D

@export var spawn_limit: int = 10

var zombie = preload("res://instances/zombie.tscn")

var rng = RandomNumberGenerator.new()
var area_size: Vector2
var top_left: Vector2
var bottom_right: Vector2
var can_spawn: bool = true

func _ready():
	area_size = $SpawnArea.get_shape().get_rect().size
	top_left = Vector2($SpawnArea.position.x - (area_size.x / 2), $SpawnArea.position.y - (area_size.y / 2))
	bottom_right = Vector2($SpawnArea.position.x + (area_size.x / 2), $SpawnArea.position.y + (area_size.y / 2))

func _process(delta):
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
