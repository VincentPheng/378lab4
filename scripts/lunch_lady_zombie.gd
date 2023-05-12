extends Zombie

@onready var grub = preload("res://instances/grub.tscn")

var player_location

func _physics_process(delta):
	last_delta = delta
	if not permanent:
		despawn_range = position.distance_to(player.position) > 350
		if despawn_range:
			queue_free()
	in_player_range = position.distance_to(player.position) < 250
	if in_player_range and not level.freeze_zombies and position.distance_to(player.position) > 80:
		var p_velocity = position.direction_to(player.position)
		should_flip_sprite(p_velocity.x)
		push_object(move_and_collide(p_velocity * SPEED * delta))
	

func lock_location():
	player_location = player.global_position

func _on_attack_timer_timeout():
	if in_player_range and not level.freeze_zombies:
		$AnimationPlayer.play("throw")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "throw":
		if in_player_range:
			var grub_instance: RigidBody2D = grub.instantiate()
			grub_instance.global_position = global_position
			#grub_instance.apply_impulse(Vector2(500, 0).rotated(projectile_spawn_point.global_rotation))
			grub_instance.apply_impulse(200 * global_position.direction_to(player_location))
			get_tree().current_scene.call_deferred("add_child", grub_instance)
		$AnimationPlayer.play("walk")
