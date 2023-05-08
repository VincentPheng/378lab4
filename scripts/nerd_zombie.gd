extends Zombie

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	loot = [projectile_box, health_pack]
	$HealthBar.max_value = health
	$HealthBar.value = health
	level = get_tree().current_scene
	player = get_tree().current_scene.get_node("Player")
	hit_sounds = [$HitSound1, $HitSound2, $HitSound3]
	moan_sounds = [$MoanSound1, $MoanSound2]
	
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	await get_tree().physics_frame
	set_movement_target(player.global_position)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta):
	last_delta = delta
	if not permanent:
		despawn_range = position.distance_to(player.position) > 400
		if despawn_range:
			queue_free()
	in_player_range = position.distance_to(player.position) < 200
	if in_player_range and not level.freeze_zombies:
		set_movement_target(player.global_position)
		var current_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()
		var new_velocity: Vector2 = next_path_position - current_agent_position
		new_velocity = new_velocity.normalized()
		should_flip_sprite(new_velocity.x)
		push_object(move_and_collide(new_velocity * SPEED * delta))
