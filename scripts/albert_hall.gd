extends Level

func _ready():
	super._ready()
	if PlayerData.dexter_party:
		complete_objective()
	_on_hud_difficulty_change()


func _on_hud_difficulty_change():
	super.update_zombie_speed()
	for spawn in spawn_areas:
		match(PlayerData.difficulty):
			0:
				max_zombies = 13
				spawn.set_spawn_range_limit(220)
				spawn.set_spawn_delay(3)
				spawn.set_spawned_zombie_drop_rate(25)
			1:
				max_zombies = 19
				spawn.set_spawn_range_limit(200)
				spawn.set_spawn_delay(1)
				spawn.set_spawned_zombie_drop_rate(15)
			2:
				max_zombies = 50
				spawn.set_spawn_range_limit(160)
				spawn.set_spawn_delay(0.5)
				spawn.set_spawned_zombie_drop_rate(5)
