extends Node2D
class_name Pickup

func disable_collisions_play_sound():
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	visible = false
	$PickupSound.play()
