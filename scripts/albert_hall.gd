extends Level

func _ready():
	super._ready()
	if PlayerData.dexter_party:
		complete_objective()
