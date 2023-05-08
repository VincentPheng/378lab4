extends Sprite2D

func _ready():
	if PlayerData.jerry_party:
		queue_free()
