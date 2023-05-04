extends Node2D
class_name Player

signal throw_item(mouse_pos)

func _input(event):
	if event.is_action_pressed("throw"):
		throw_item.emit(event.position)
