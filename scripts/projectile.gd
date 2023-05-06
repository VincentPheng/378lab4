extends RigidBody2D
class_name Projectile

func _on_body_entered(_body):
	$AnimationPlayer.play("delete")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "delete":
		queue_free()
