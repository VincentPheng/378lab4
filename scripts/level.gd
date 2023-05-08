extends Node2D
class_name Level

@export var max_zombies = 10
@export var spawn_zombies := true
@export var objectives: Array[String]

@onready var hud: HUD = get_node("HUD")

var freeze_zombies = false

func _ready():
	hud.update_objective(objectives[-1])

func complete_objective(objective: String):
	if objectives[-1] == objective:
		objectives.pop_back()
		max_zombies += 10
		hud.update_objective(objectives[-1])
