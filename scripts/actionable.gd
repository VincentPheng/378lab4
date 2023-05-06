extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@export var type: Enums.ActionableType
@export var interactable: String

func action():
	match (type):
		Enums.ActionableType.DIALOGUE:
			dialogue_action()
		Enums.ActionableType.INTERACTABLE:
			interactable_action()
	return [type, interactable]
	
func dialogue_action():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)

func interactable_action():
	get_parent().queue_free()
