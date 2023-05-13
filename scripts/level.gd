extends Node2D
class_name Level

@export var max_zombies = 10
@export var spawn_zombies := true
@export var objectives: Array[String]

@onready var hud: HUD = get_node("HUD")

var freeze_zombies = false
var spawn_areas
var main_level_music_position: float = 0.0

func _ready():
	spawn_areas = get_tree().get_nodes_in_group("Spawner")
	hud.update_objective(objectives[-1])
	for spawn_area in spawn_areas:
		match(PlayerData.difficulty):
			0:
				spawn_area.set_zombie_speed(50)
			1:
				spawn_area.set_zombie_speed(50)
			2:
				spawn_area.set_zombie_speed(95)

func complete_objective():
	objectives.pop_back()
	max_zombies += 10
	hud.update_objective(objectives[-1])

func update_zombie_speed():
	for spawn_area in spawn_areas:
		match(PlayerData.difficulty):
			0:
				spawn_area.set_zombie_speed(50)
				spawn_area.set_zombie_damage(15)
			1:
				spawn_area.set_zombie_speed(50)
				spawn_area.set_zombie_damage(15)
			2:
				spawn_area.set_zombie_speed(95)
				spawn_area.set_zombie_damage(30)
