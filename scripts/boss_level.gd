extends Level

var types: Array[Dictionary] = [
			{
				"weight": 80,
				"type": "res://instances/zombie.tscn"
			},
			{
				"weight": 20,
				"type": "res://instances/lunch_lady_zombie.tscn"
			},
		]

func _ready():
	super._ready()
	$Player.talking = true
	$HUD.toggle_objective_view()
	$HUD/HealthBar.visible = false
	freeze_zombies = true
	$PlayerCamera.enable_shake = false
	$Intro.force_dialogue()
	spawn_zombies = false
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	for spawn in spawn_areas:
		spawn.set_zombie_types(types)
		spawn.set_spawn_delay(5)
		spawn.set_spawned_zombie_drop_rate(50)
	_on_hud_difficulty_change()

func _on_dialogue_ended(resource: DialogueResource):
	var title = resource.get_titles()[0]
	if title == "mega_zom_intro":
		$MainLevelMusic.play()
		$HUD.toggle_objective_view()
		$HUD/HealthBar.visible = true
		$AnimationPlayer.play("intro_end")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "intro_end":
		freeze_zombies = false
		spawn_zombies = true
		$PlayerCamera.enable_shake = true


func _on_boss_zombie_phase_change(curr_phase):
	if curr_phase == 1:
		for spawn in spawn_areas:
			spawn.set_spawn_delay(1)
	else:
		for spawn in spawn_areas:
			spawn.set_spawn_delay(.5)


func _on_hud_difficulty_change():
	super.update_zombie_speed()
	for spawn_area in spawn_areas:
		match(PlayerData.difficulty):
			0:
				max_zombies = 50
				spawn_area.set_spawn_delay(3)
				spawn_area.set_spawn_range_limit(200)
				spawn_area.set_spawned_zombie_drop_rate(80)
			1:
				max_zombies = 100
				spawn_area.set_spawn_delay(1)
				spawn_area.set_spawn_range_limit(200)
				spawn_area.set_spawned_zombie_drop_rate(50)
			2:
				max_zombies = 160
				spawn_area.set_spawn_delay(0.5)
				spawn_area.set_spawn_range_limit(160)
				spawn_area.set_spawned_zombie_drop_rate(20)


func _on_boss_zombie_death():
	complete_objective()
	$HUD/HealthBar.visible = false
	$Doors.queue_free()
	$MainLevelMusic.stop()
	$EndMusic.play()
	$Spawners.queue_free()
	var zombies = get_tree().get_nodes_in_group("Zombie")
	for zombie in zombies:
		zombie.queue_free()
