extends RigidBody2D

func _on_body_entered(body):
	queue_free()


func _on_life_timer_timeout():
	queue_free()
