extends Level

signal toggle_hoard

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
	_on_hud_difficulty_change()

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
	main_level_music_position = $MainLevelMusic.get_playback_position()
	$MainLevelMusic.stop()
	$HoldoutMusic.play()
	$PlayerCamera.set_target_zoom(Vector2(5, 5))
	$HUD.toggle_hoard_screen()
	for spawn_area in spawn_areas:
		match(PlayerData.difficulty):
			0:
				max_zombies = 40
				spawn_area.set_spawn_range_limit(200)
				spawn_area.set_spawn_delay(1)
				spawn_area.set_spawned_zombie_drop_rate(70)
			1:
				max_zombies = 70
				spawn_area.set_spawn_range_limit(150)
				spawn_area.set_spawn_delay(0.5)
				spawn_area.set_spawned_zombie_drop_rate(40)
			2:
				max_zombies = 120
				spawn_area.set_spawn_range_limit(130)
				spawn_area.set_spawn_delay(0.1)
				spawn_area.set_spawned_zombie_drop_rate(15)
	toggle_hoard.emit()
	$HoldoutTimer.start()

func _on_holdout_timer_timeout():
	$HoldoutTimer.stop()
	$HoldoutMusic.stop()
	$PlayerCamera.set_target_zoom(Vector2(4, 4))
	$HUD.toggle_hoard_screen()
	$MainLevelMusic.play(main_level_music_position)
	for spawn_area in spawn_areas:
		match(PlayerData.difficulty):
			0:
				max_zombies = 25
				spawn_area.set_spawn_delay(3)
				spawn_area.set_spawn_range_limit(220)
				spawn_area.set_spawned_zombie_drop_rate(25)
			1:
				max_zombies = 35
				spawn_area.set_spawn_delay(1)
				spawn_area.set_spawn_range_limit(200)
				spawn_area.set_spawned_zombie_drop_rate(15)
			2:
				max_zombies = 65
				spawn_area.set_spawn_delay(0.5)
				spawn_area.set_spawn_range_limit(160)
				spawn_area.set_spawned_zombie_drop_rate(5)
	toggle_hoard.emit()
	$ForcedDialogue.force_dialogue()
	$HoldoutDoors.queue_free()


func _on_hud_difficulty_change():
	super.update_zombie_speed()
	for spawn_area in spawn_areas:
		match(PlayerData.difficulty):
			0:
				max_zombies = 25
				spawn_area.set_spawn_delay(3)
				spawn_area.set_spawn_range_limit(220)
				spawn_area.set_spawned_zombie_drop_rate(25)
			1:
				max_zombies = 35
				spawn_area.set_spawn_delay(1)
				spawn_area.set_spawn_range_limit(200)
				spawn_area.set_spawned_zombie_drop_rate(15)
			2:
				max_zombies = 65
				spawn_area.set_spawn_delay(0.5)
				spawn_area.set_spawn_range_limit(160)
				spawn_area.set_spawned_zombie_drop_rate(5)
