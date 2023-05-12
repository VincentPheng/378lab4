extends RigidBody2D

func _on_body_entered(body):
	if body.is_in_group("Player") or body.is_in_group("Zombie"):
		queue_free()


func _on_life_timer_timeout():
	queue_free()


func _on_parry_detector_body_entered(body):
	$ParryDetector/CollisionShape2D.call_deferred("set_disabled", true)
	linear_velocity = Vector2(linear_velocity.x * -1, linear_velocity.y * -1)
	collision_layer = 8
	collision_mask = 4
