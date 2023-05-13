extends Level

func _ready():
	super._ready()
	for spawn in spawn_areas:
		var types: Array[Dictionary] = [
			{
				"weight": 50,
				"type": "res://instances/zombie.tscn"
			},
			{
				"weight": 20,
				"type": "res://instances/lunch_lady_zombie.tscn"
			},
			{
				"weight": 30,
				"type": "res://instances/nerd_zombie.tscn"
			}
		]
		spawn.set_zombie_types(types)
		spawn.set_spawned_zombie_drop_rate(25)

func _on_fire_trigger_cutscene_end():
	complete_objective()
	$FireExtinguisherCutscene/FireExtinguisherTrigger.is_active = true

func _on_fire_extinguisher_trigger_cutscene_end():
	complete_objective()
	PlayerData.has_fire_extinguisher = true
	hud.enable_fire_extinguisher_icon()
	$FireExtinguisherCutscene.queue_free()
	$FireExtinguishedTrigger.is_active = true


func _on_fire_extinguished_trigger_cutscene_end():
	complete_objective()
	$FireArea.queue_free()


func _on_holdout_trigger_cutscene_end():
	max_zombies = 70
	main_level_music_position = $MainLevelMusic.get_playback_position()
	$MainLevelMusic.stop()
	$HoldoutMusic.play()
	$PlayerCamera.set_target_zoom(Vector2(5, 5))
	$HUD.toggle_hoard_screen()
	for spawn_area in spawn_areas:
		spawn_area.set_spawn_range_limit(150)
		spawn_area.set_spawn_delay(0.5)
		spawn_area.set_spawned_zombie_drop_rate(40)
	$HoldoutTimer.start()

func _on_holdout_timer_timeout():
	$HoldoutTimer.stop()
	max_zombies = 35
	$HoldoutMusic.stop()
	$PlayerCamera.set_target_zoom(Vector2(4, 4))
	$HUD.toggle_hoard_screen()
	$MainLevelMusic.play(main_level_music_position)
	for spawn_area in spawn_areas:
		spawn_area.set_spawn_delay(3)
		spawn_area.set_spawn_range_limit(200)
		spawn_area.set_spawned_zombie_drop_rate(25)
	$ForcedDialogue.force_dialogue()
	$HoldoutDoors.queue_free()
