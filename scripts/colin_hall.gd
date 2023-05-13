extends Level

signal toggle_hoard

func _ready():
	super._ready()
	PlayerData.dexter_party = true
	if PlayerData.jerry_party:
		$HoldoutTrigger.is_active = true
		complete_objective()
	_on_hud_difficulty_change()

func _on_holdout_timer_timeout():
	$HoldoutTimer.stop()
	max_zombies = 20
	$HoldoutMusic.stop()
	$PlayerCamera.set_target_zoom(Vector2(4, 4))
	$HUD.toggle_hoard_screen()
	$MainLevelMusic.play(main_level_music_position)
	for spawn_area in spawn_areas:
		match(PlayerData.difficulty):
			0:
				max_zombies = 15
				spawn_area.set_spawn_range_limit(220)
				spawn_area.set_spawn_delay(3)
				spawn_area.set_spawned_zombie_drop_rate(25)
			1:
				max_zombies = 20
				spawn_area.set_spawn_range_limit(200)
				spawn_area.set_spawn_delay(3)
				spawn_area.set_spawned_zombie_drop_rate(15)
			2:
				max_zombies = 50
				spawn_area.set_spawn_range_limit(160)
				spawn_area.set_spawn_delay(0.5)
				spawn_area.set_spawned_zombie_drop_rate(5)
	toggle_hoard.emit()
	$ForcedDialogue.force_dialogue()
	$HoldoutDoors.queue_free()


func _on_holdout_trigger_cutscene_end():
	main_level_music_position = $MainLevelMusic.get_playback_position()
	$MainLevelMusic.stop()
	$HoldoutMusic.play()
	$PlayerCamera.set_target_zoom(Vector2(5, 5))
	$HUD.toggle_hoard_screen()
	for spawn_area in spawn_areas:
		match(PlayerData.difficulty):
			0:
				max_zombies = 25
				spawn_area.set_spawn_range_limit(200)
				spawn_area.set_spawn_delay(1)
				spawn_area.set_spawned_zombie_drop_rate(45)
			1:
				max_zombies = 40
				spawn_area.set_spawn_range_limit(150)
				spawn_area.set_spawn_delay(0.5)
				spawn_area.set_spawned_zombie_drop_rate(25)
			2:
				max_zombies = 80
				spawn_area.set_spawn_range_limit(130)
				spawn_area.set_spawn_delay(0.1)
				spawn_area.set_spawned_zombie_drop_rate(15)
	toggle_hoard.emit()
	$HoldoutTimer.start()


func _on_hud_difficulty_change():
	super.update_zombie_speed()
	for spawn_area in spawn_areas:
		match(PlayerData.difficulty):
			0:
				max_zombies = 15
				spawn_area.set_spawn_range_limit(220)
				spawn_area.set_spawn_delay(5)
				spawn_area.set_spawned_zombie_drop_rate(25)
			1:
				max_zombies = 20
				spawn_area.set_spawn_delay(3)
				spawn_area.set_spawn_range_limit(200)
				spawn_area.set_spawned_zombie_drop_rate(15)
			2:
				max_zombies = 50
				spawn_area.set_spawn_range_limit(160)
				spawn_area.set_spawn_delay(0.5)
				spawn_area.set_spawned_zombie_drop_rate(5)
