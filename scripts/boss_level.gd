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
