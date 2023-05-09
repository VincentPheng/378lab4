extends Area2D
class_name CutsceneTrigger

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@export var collision: CollisionShape2D

var level: Level
var player: Player

var is_active: bool = false

signal cutscene_end

func _ready():
	level = get_tree().current_scene
	player = level.get_node("Player")
	DialogueManager.dialogue_ended.connect(_on_cutscene_end)

func _on_body_entered(body):
	if is_active:
		level.freeze_zombies = true
		player.talking = true
		DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)

func _on_cutscene_end(resource: DialogueResource):
	var title = resource.get_titles()[0]
	if title == dialogue_start:
		cutscene_end.emit()
		level.freeze_zombies = false
		player.talking = false
		queue_free()
