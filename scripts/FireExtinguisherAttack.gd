extends Area2D

var can_do_damage = true

func _process(_delta):
	look_at(get_global_mouse_position())
	var zombies = get_overlapping_bodies()
	for zombie in zombies:
		if can_do_damage:
			zombie.take_damage()
			can_do_damage = false
		zombie.knockback(3)


func _on_damage_timer_timeout():
	can_do_damage = true


func _on_active_timer_timeout():
	$CollisionPolygon2D.disabled = true
	visible = false
	$CooldownTimer.start()
