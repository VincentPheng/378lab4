extends Pickup
@export var type: Enums.SpecialPickups

func _on_area_2d_area_entered(_area):
	disable_collisions_play_sound()
	PlayerData.add_special_pickup(type)

func _on_pickup_sound_finished():
	queue_free()
