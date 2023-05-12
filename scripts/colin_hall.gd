extends Level

func _ready():
	super._ready()
	PlayerData.dexter_party = true
	if PlayerData.jerry_party:
		$HoldoutTrigger.is_active = true
		complete_objective("Talk to Jerry")

func _on_holdout_timer_timeout():
	$HoldoutTimer.stop()
	max_zombies = 20
	$HoldoutMusic.stop()
	$PlayerCamera.set_target_zoom(Vector2(4, 4))
	$HUD.toggle_hoard_screen()
	$MainLevelMusic.play(main_level_music_position)
	for spawn_area in spawn_areas:
		spawn_area.set_spawn_delay(3)
		spawn_area.set_spawn_range_limit(200)
		spawn_area.set_spawned_zombie_drop_rate(15)
	$ForcedDialogue.force_dialogue()
	$HoldoutDoors.queue_free()


func _on_holdout_trigger_cutscene_end():
	max_zombies = 40
	main_level_music_position = $MainLevelMusic.get_playback_position()
	$MainLevelMusic.stop()
	$HoldoutMusic.play()
	$PlayerCamera.set_target_zoom(Vector2(5, 5))
	$HUD.toggle_hoard_screen()
	for spawn_area in spawn_areas:
		spawn_area.set_spawn_range_limit(130)
		spawn_area.set_spawn_delay(0.5)
		spawn_area.set_spawned_zombie_drop_rate(25)
	$HoldoutTimer.start()
