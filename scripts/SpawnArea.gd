extends Area2D
class_name SpawnArea

var zombie = preload("res://instances/zombie.tscn")

@export var collision_shape: CollisionShape2D
@export var spawn_delay: float = 1.0
@export var zombie_types: Array[Dictionary] = [
	{
		"weight": 100,
		"type": "res://instances/zombie.tscn"
	}
]

var rng = RandomNumberGenerator.new()
var area_size: Vector2
var top_left: Vector2
var bottom_right: Vector2
var can_spawn: bool = true
var spawn_limit: int
var should_spawn: bool
var zombie_drop_rate := 15
var spawn_table
var player: Player
var spawn_range_limit := 200

func _ready():
	area_size = collision_shape.get_shape().get_rect().size
	$SpawnTimer.wait_time = spawn_delay
	top_left = Vector2(collision_shape.global_position.x - (area_size.x / 2), collision_shape.global_position.y - (area_size.y / 2))
	bottom_right = Vector2(collision_shape.global_position.x + (area_size.x / 2), collision_shape.global_position.y + (area_size.y / 2))
	spawn_limit = get_tree().current_scene.max_zombies
	should_spawn = get_tree().current_scene.spawn_zombies
	player = get_tree().current_scene.get_node("Player")
	build_spawn_table()

func _process(delta):
	spawn_limit = get_tree().current_scene.max_zombies
	if should_spawn:
		if len(get_overlapping_bodies()) > 0 or global_position.distance_to(player.global_position) < 300:
			var zombie_count = len(get_tree().get_nodes_in_group("Zombie"))
			var rand_pos = Vector2(rng.randf_range(top_left.x, bottom_right.x), rng.randf_range(top_left.y, bottom_right.y))
			if rand_pos.distance_to(get_tree().current_scene.get_node("Player").global_position) > spawn_range_limit:
				if zombie_count < spawn_limit and can_spawn:
					var zombie_instance: Zombie = get_zombie_type().instantiate()
					zombie_instance.global_position = rand_pos
					zombie_instance.loot_drop_chance = zombie_drop_rate
					get_tree().current_scene.add_child(zombie_instance)
					$SpawnTimer.start()
					can_spawn = false

func set_spawn_range_limit(new_limit: int):
	spawn_range_limit = new_limit

func set_spawn_delay(new_delay: float):
	spawn_delay = new_delay
	$SpawnTimer.wait_time = spawn_delay

func set_spawned_zombie_drop_rate(new_rate: int):
	zombie_drop_rate = new_rate

func get_zombie_type():
	return spawn_table[rng.randi_range(0, len(spawn_table) - 1)]

func build_spawn_table():
	var table = []
	for i in range(len(zombie_types)):
		for j in range(zombie_types[i]["weight"]):
			table.append(load(zombie_types[i]["type"]))
	spawn_table = table

func _on_spawn_timer_timeout():
	can_spawn = true
