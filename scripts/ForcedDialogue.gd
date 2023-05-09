extends Node2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

var level: Level
var player: Player

func _ready():
	level = get_tree().current_scene
	player = level.get_node("Player")
	DialogueManager.dialogue_ended.connect(_on_dialogue_end)

func _on_dialogue_end(resource: DialogueResource):
	var title = resource.get_titles()[0]
	if title == dialogue_start:
		level.freeze_zombies = false
		player.talking = false
		queue_free()

func force_dialogue():
	level.freeze_zombies = true
	player.talking = true
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
