extends Sprite2D

func _ready():
	if PlayerData.dexter_party:
		queue_free()
