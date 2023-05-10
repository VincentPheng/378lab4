extends Pickup

@export var heal_amount = 30

func _on_area_2d_area_entered(_area):
	disable_collisions_play_sound()
	PlayerData.player_health += heal_amount
	if PlayerData.player_health > 100:
		PlayerData.player_health = 100
	get_tree().current_scene.get_node("Player").currHealth = PlayerData.player_health
	get_tree().current_scene.get_node("Player").update_health_bar()

func _on_pickup_sound_finished():
	queue_free()
