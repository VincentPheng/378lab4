extends Area2D

@export var collision_shape: CollisionShape2D
@export var next_scene: String

var hud: HUD
var level: Level

func _ready():
	hud = get_tree().current_scene.get_node("HUD")
	level = get_tree().current_scene

func _on_body_entered(_body):
	if len(level.objectives) <= 1:
		hud.finish(next_scene)
