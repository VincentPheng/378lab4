extends RigidBody2D
class_name Projectile

func fade():
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("delete")

func _on_body_entered(_body):
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("delete")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "delete":
		queue_free()
