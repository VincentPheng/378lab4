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

func complete_objective(objective: String):
	if objectives[-1] == objective:
		objectives.pop_back()
		max_zombies += 10
		hud.update_objective(objectives[-1])
